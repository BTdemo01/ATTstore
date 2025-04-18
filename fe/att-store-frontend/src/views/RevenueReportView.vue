<template>
  <div class="revenue-report-view">
    <h1>Báo cáo Doanh thu</h1>

    <div class="date-filters card">
      <label>Chọn khoảng thời gian:</label>
      <div class="filter-options">
        <button @click="setDateRange('today')" :class="{ active: selectedRange === 'today' }">Hôm nay</button>
        <button @click="setDateRange('week')" :class="{ active: selectedRange === 'week' }">Tuần này</button>
        <button @click="setDateRange('month')" :class="{ active: selectedRange === 'month' }">Tháng này</button>
        <div class="custom-range">
          <input type="date" v-model="startDate" @change="clearSelectedRange">
          <span>đến</span>
          <input type="date" v-model="endDate" @change="clearSelectedRange">
          <button @click="loadRevenueData" class="btn-view-report">Xem</button>
        </div>
      </div>
      <div class="export-action">
           <button @click="exportToExcel" class="btn-export-excel" :disabled="loading || error">
             <i class="fas fa-file-excel"></i> Xuất Excel
           </button>
      </div>
    </div>

    <div v-if="loading" class="loading-message">Đang tải dữ liệu báo cáo...</div>
    <div v-if="error" class="error-message">{{ error }}</div>

    <div v-if="!loading && !error" class="summary-stats">
      <div class="stat-card">
          <h3>Tổng Doanh Thu</h3>
          <p>{{ formatCurrency(summary.totalRevenue) }}</p>
        </div>
        <div class="stat-card">
          <h3>Số Đơn Hàng (Hoàn thành)</h3>
          <p>{{ summary.orderCount }}</p>
        </div>
        <div class="stat-card">
          <h3>Trung bình/Đơn</h3>
          <p>{{ formatCurrency(summary.averageOrderValue) }}</p>
        </div>
          <div class="stat-card">
            <h3>Tổng SL Tồn kho</h3>
            <p>{{ summary.totalStockQuantity }}</p>
          </div>
          <div class="stat-card">
            <h3>Tổng GT Tồn kho</h3>
            <p>{{ formatCurrency(summary.totalStockValue) }}</p>
          </div>
          <div class="stat-card">
            <h3>Số SP Hết hàng</h3>
            <p>{{ summary.outOfStockCount }}</p>
          </div>
    </div>

    <div v-if="!loading && !error" class="charts-section">
      <div class="chart-container card">
          <h3>Doanh thu theo thời gian</h3>
          <div class="chart-wrapper">
            <Line v-if="chartDataLoaded" :data="revenueOverTimeData" :options="chartOptions" />
            <p v-else class="no-chart-data">Chưa có đủ dữ liệu cho biểu đồ này.</p>
          </div>
        </div>
        <div class="chart-container card">
          <h3>Doanh thu theo loại hàng</h3>
           <div class="chart-wrapper doughnut-wrapper">
                <Doughnut v-if="chartDataLoaded" :data="revenueByCategoryData" :options="chartOptions" />
                <p v-else class="no-chart-data">Chưa có đủ dữ liệu cho biểu đồ này.</p>
           </div>
        </div>
    </div>

    <div v-if="!loading && !error" class="additional-reports">
      <div class="report-list-section card">
            <h3>Top 5 Sản phẩm Bán chạy (Số lượng)</h3>
            <ul v-if="topProducts.length > 0">
                <li v-for="product in topProducts" :key="product.product__id || product.id"> <span class="item-name">{{ product.product__name }}</span>
                    <span class="item-value">Đã bán: {{ product.total_sold_quantity || product.total_quantity || 'N/A' }}</span> </li>
            </ul>
            <p v-else><i>Chưa có dữ liệu top sản phẩm.</i></p>
        </div>

        <div class="report-list-section card">
            <h3>Sản phẩm Hết hàng (Tồn kho <= 0)</h3>
            <ul v-if="outOfStockProducts.length > 0">
                <li v-for="product in outOfStockProducts" :key="product.id">
                    <span class="item-name">{{ product.name }} ({{product.category__name || 'N/A'}})</span>
                    <span class="item-value">Kho: {{ product.stock_quantity }}</span>
                </li>
            </ul>
        <p v-else><i>Không có sản phẩm nào hết hàng.</i></p>
        </div>
    </div>

  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
// Import các hàm API THẬT từ apiService
import {
  fetchRevenueSummary, fetchRevenueOverTime, fetchRevenueByCategory,
  fetchTopSellingProducts, fetchInventorySummary, fetchOutOfStockProducts
} from '@/services/apiService';
// Import thư viện xlsx (Đã có)
import * as XLSX from 'xlsx';

// Import components biểu đồ và ChartJS
import { Line, Doughnut } from 'vue-chartjs';
import { Chart as ChartJS, ArcElement, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from 'chart.js';

// Đăng ký các thành phần cần thiết cho Chart.js
ChartJS.register(ArcElement, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend);

// --- State ---
const loading = ref(true);
const error = ref(null);
const startDate = ref('');
const endDate = ref('');
const selectedRange = ref('month');
const chartDataLoaded = ref(false); // Vẫn dùng để kiểm soát việc hiển thị biểu đồ

// State cho dữ liệu báo cáo (giữ nguyên)
const summary = reactive({
    totalRevenue: 0, orderCount: 0, averageOrderValue: 0,
    totalStockQuantity: 0, totalStockValue: 0, outOfStockCount: 0
});
const revenueOverTimeData = reactive({
    labels: [],
    datasets: [{ label: 'Doanh thu (VND)', data: [], backgroundColor: 'rgba(54, 162, 235, 0.5)', borderColor: 'rgb(54, 162, 235)', tension: 0.1 }]
});
const revenueByCategoryData = reactive({
    labels: [],
    datasets: [{ data: [], backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40', '#FFCD56', '#C9CBCF'] }]
});
const topProducts = ref([]);
const outOfStockProducts = ref([]);

// Options biểu đồ (giữ nguyên)
const chartOptions = reactive({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
     legend: { position: 'top', },
     title: { display: false, },
     tooltip: {
         callbacks: {
              label: function(context) {
                  let label = context.dataset.label || '';
                  if (label) { label += ': '; }
                  if (context.parsed.y !== null) {
                      label += formatCurrency(context.parsed.y);
                  }
                  else if (context.label && context.parsed !== null) {
                       label = `${context.label}: ${formatCurrency(context.parsed)}`;
                  }
                  return label;
              }
          }
     }
  }
});

// --- Functions ---
// formatCurrency (giữ nguyên)
const formatCurrency = (value) => { if (value === undefined || value === null || isNaN(value)) return '0 đ'; return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value); };

// !!! THÊM HÀM NÀY !!!
// Hàm format số không kèm đơn vị tiền tệ cho Excel
const formatNumber = (value) => {
    const num = Number(value); // Cố gắng chuyển đổi sang số
    if (isNaN(num)) { // Nếu không phải là số hợp lệ
        return 0; // Trả về 0 hoặc null/undefined tùy bạn muốn
    }
    return num; // Trả về giá trị số
};


// setDateRange, clearSelectedRange (giữ nguyên)
const setDateRange = (rangeType) => {
    const today = new Date(); let start = new Date(); const end = new Date(today);
    switch(rangeType) { case 'today': start = new Date(today.setHours(0, 0, 0, 0)); break; case 'week': const dayOfWeek = today.getDay(); const diff = today.getDate() - dayOfWeek + (dayOfWeek === 0 ? -6 : 1); start = new Date(today.setDate(diff)); start.setHours(0,0,0,0); break; case 'month': start = new Date(today.getFullYear(), today.getMonth(), 1); break; }
    startDate.value = start.toISOString().split('T')[0]; endDate.value = end.toISOString().split('T')[0]; selectedRange.value = rangeType; loadRevenueData();
};
const clearSelectedRange = () => { selectedRange.value = ''; }

// loadRevenueData (sửa logic set chartDataLoaded)
const loadRevenueData = async () => {
  loading.value = true; error.value = null; chartDataLoaded.value = false; // Reset trước khi tải
  topProducts.value = []; outOfStockProducts.value = [];
  // Reset summary về 0 để tránh hiển thị số liệu cũ nếu API lỗi
  Object.assign(summary, { totalRevenue: 0, orderCount: 0, averageOrderValue: 0, totalStockQuantity: 0, totalStockValue: 0, outOfStockCount: 0 });
  revenueOverTimeData.labels = []; revenueOverTimeData.datasets[0].data = []; revenueByCategoryData.labels = []; revenueByCategoryData.datasets[0].data = [];


  console.log(`Đang tải dữ liệu THẬT từ ${startDate.value} đến ${endDate.value}`);
  const dateParams = { start_date: startDate.value, end_date: endDate.value };
  try {
    const [ summaryRes, overTimeRes, byCategoryRes, topProductsRes, inventoryRes, outOfStockRes ] = await Promise.all([
        fetchRevenueSummary(dateParams), fetchRevenueOverTime(dateParams), fetchRevenueByCategory(dateParams),
        fetchTopSellingProducts({...dateParams, limit: 5 }), fetchInventorySummary(), fetchOutOfStockProducts()
    ]);
    // 1. Cập nhật Summary
    if (summaryRes.data) { Object.assign(summary, summaryRes.data); }
    if (inventoryRes.data) { Object.assign(summary, { ...summary, ...inventoryRes.data }); }
    // 2. Cập nhật Doanh thu theo thời gian
    if (overTimeRes.data && overTimeRes.data.labels && overTimeRes.data.data) { revenueOverTimeData.labels = overTimeRes.data.labels; revenueOverTimeData.datasets[0].data = overTimeRes.data.data; }
    // else đã reset ở trên
    // 3. Cập nhật Doanh thu theo loại hàng
    if (byCategoryRes.data && byCategoryRes.data.labels && byCategoryRes.data.data) { revenueByCategoryData.labels = byCategoryRes.data.labels; revenueByCategoryData.datasets[0].data = byCategoryRes.data.data; }
    // else đã reset ở trên
    // 4. Cập nhật Top sản phẩm
    if (topProductsRes.data && Array.isArray(topProductsRes.data)) { topProducts.value = topProductsRes.data; }
    // else đã reset ở trên
    // 5. Cập nhật SP hết hàng
    if (outOfStockRes.data && Array.isArray(outOfStockRes.data)) { outOfStockProducts.value = outOfStockRes.data; summary.outOfStockCount = outOfStockProducts.value.length; }
    // else đã reset ở trên

    // Sửa logic: Chỉ đánh dấu chartDataLoaded = true nếu CÓ dữ liệu cho ÍT NHẤT MỘT biểu đồ
    // Biến này chỉ dùng để hiển thị text "Chưa có đủ dữ liệu cho biểu đồ này."
    if (revenueOverTimeData.labels.length > 0 || revenueByCategoryData.labels.length > 0) {
        chartDataLoaded.value = true;
    } else {
        chartDataLoaded.value = false;
    }

  } catch (err) {
      console.error("Lỗi khi tải dữ liệu báo cáo:", err);
      error.value = "Không thể tải dữ liệu báo cáo. Vui lòng kiểm tra API backend hoặc kết nối mạng.";
      // Dữ liệu đã được reset về rỗng/0 ở đầu hàm try
      chartDataLoaded.value = false; // Đảm bảo không hiển thị biểu đồ khi lỗi
  } finally {
    loading.value = false; // Luôn đặt loading = false ở cuối
  }
};

// Tải dữ liệu lần đầu
onMounted(() => { setDateRange('month'); });


// --- HÀM XUẤT EXCEL MỚI --- (Giữ nguyên, giờ sẽ hoạt động vì có formatNumber)
const exportToExcel = () => {
    console.log("Chuẩn bị xuất Excel...");
    try { // Thêm try...catch để bắt lỗi nếu có trong quá trình tạo file
        // 1. Chuẩn bị dữ liệu cho các sheet
        const summaryData = [
            ["Báo cáo Doanh thu"],
            [`Từ ngày: ${startDate.value}`, `Đến ngày: ${endDate.value}`],
            [],
            ["Mục", "Giá trị"],
            ["Tổng Doanh Thu", formatNumber(summary.totalRevenue)],
            ["Số Đơn Hàng (Hoàn thành)", summary.orderCount],
            ["Trung bình/Đơn", formatNumber(summary.averageOrderValue)],
            ["Tổng SL Tồn kho", summary.totalStockQuantity],
            ["Tổng GT Tồn kho", formatNumber(summary.totalStockValue)],
            ["Số SP Hết hàng", summary.outOfStockCount],
        ];
        const wsSummary = XLSX.utils.aoa_to_sheet(summaryData);
        wsSummary['!cols'] = [ { wch: 30 }, { wch: 20, z: '#,##0 "đ"' } ];

        const topProductsData = topProducts.value.map(p => ({
            "Tên Sản Phẩm": p.product__name || 'N/A', // Thêm fallback 'N/A'
            "Số Lượng Đã Bán": p.total_sold_quantity || p.total_quantity || 0
        }));
        const wsTopProducts = XLSX.utils.json_to_sheet(topProductsData);
        wsTopProducts['!cols'] = [ { wch: 40 }, { wch: 20 } ];

        const outOfStockData = outOfStockProducts.value.map(p => ({
            "Tên Sản Phẩm": p.name || 'N/A', // Thêm fallback 'N/A'
            "Loại Hàng": p.category__name || 'N/A',
            "Tồn Kho": p.stock_quantity !== undefined ? p.stock_quantity : 'N/A' // Xử lý undefined
        }));
        const wsOutOfStock = XLSX.utils.json_to_sheet(outOfStockData);
        wsOutOfStock['!cols'] = [ { wch: 40 }, { wch: 25 }, { wch: 15 } ];

        // 2. Tạo Workbook và thêm các sheet
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, wsSummary, "Tóm tắt Báo cáo");
        XLSX.utils.book_append_sheet(wb, wsTopProducts, "Top Sản phẩm Bán chạy");
        XLSX.utils.book_append_sheet(wb, wsOutOfStock, "Sản phẩm Hết hàng");

        // 3. Tạo tên file và xuất file
        const fileName = `BaoCaoDoanhThu_${startDate.value || 'nodate'}_den_${endDate.value || 'nodate'}.xlsx`; // Thêm fallback nếu ngày rỗng
        XLSX.writeFile(wb, fileName);

        console.log("Đã xuất file:", fileName);
    } catch (exportError) {
        console.error("Lỗi khi tạo file Excel:", exportError);
        // Có thể hiển thị thông báo lỗi cho người dùng ở đây
        alert("Đã xảy ra lỗi khi cố gắng xuất file Excel. Vui lòng thử lại hoặc kiểm tra console.");
    }
};
</script>





<style scoped>
/* --- CSS giữ nguyên như ví dụ trước --- */
.revenue-report-view { padding: 25px; background-color: #f8f9fa; }
h1 { text-align: center; margin-bottom: 25px; color: #343a40; }
.card { background-color: #fff; padding: 20px; border-radius: 8px; margin-bottom: 25px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border: 1px solid #e9ecef; }
.date-filters { display: flex; flex-direction: column; gap: 15px; }
.date-filters label { font-weight: bold; color: #495057; margin-bottom: 5px; }
.filter-options { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.filter-options button, .filter-options input[type="date"] { padding: 8px 12px; border: 1px solid #ced4da; border-radius: 4px; font-size: 0.9rem; cursor: pointer; }
.filter-options button { background-color: #e9ecef; color: #495057; transition: background-color 0.2s ease; }
.filter-options button:hover { background-color: #dee2e6; }
.filter-options button.active { background-color: #0d6efd; color: white; border-color: #0d6efd; }
.custom-range { display: flex; align-items: center; gap: 8px; margin-left: auto; }
.custom-range span { color: #6c757d; }
.btn-view-report { background-color: #198754; color: white; border-color: #198754; }
.btn-view-report:hover { background-color: #157347; }
.summary-stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 15px; margin-bottom: 30px; }
.stat-card { background-color: #fff; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); text-align: center; border: 1px solid #e9ecef; }
.stat-card h3 { margin-top: 0; margin-bottom: 8px; color: #6c757d; font-size: 0.9rem; text-transform: uppercase; }
.stat-card p { margin: 0; font-size: 1.6rem; font-weight: bold; color: #343a40; word-wrap: break-word; }
.charts-section { display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 30px; margin-bottom: 30px;}
.chart-container h3 { text-align: center; margin-bottom: 20px; font-size: 1.2rem; color: #495057; }
.chart-wrapper { height: 350px; position: relative; }
.doughnut-wrapper { max-width: 350px; margin: 0 auto; }
.additional-reports { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 25px; }
.report-list-section h3 { margin-top: 0; margin-bottom: 15px; font-size: 1.1rem; color: #495057; border-bottom: 1px solid #eee; padding-bottom: 8px;}
.report-list-section ul { list-style: none; padding: 0; margin: 0; max-height: 250px; overflow-y: auto; }
.report-list-section li { padding: 8px 5px; border-bottom: 1px dashed #dee2e6; display: flex; justify-content: space-between; font-size: 0.9rem; }
.report-list-section li:last-child { border-bottom: none; }
.report-list-section .item-name { font-weight: 500; color: #343a40; margin-right: 10px; }
.report-list-section .item-value { color: #6c757d; font-weight: bold; white-space: nowrap; }
.loading-message, .error-message { text-align: center; padding: 20px; color: #6c757d; font-size: 1.1rem; }
.error-message { color: red; font-weight: bold; }
.no-chart-data { text-align: center; padding-top: 50px; color: #6c757d; font-style: italic;}


/* --- CSS cho nút Xuất Excel --- */
.export-action {
    margin-top: 15px; /* Khoảng cách với các bộ lọc */
    text-align: right; /* Đặt nút về bên phải */
}
.btn-export-excel {
    background-color: #117a47; /* Màu xanh lá cây đậm hơn */
    color: white;
    border: none;
    padding: 8px 15px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.9rem;
    transition: background-color 0.2s ease;
}
.btn-export-excel:hover:not(:disabled) { background-color: #0d653a; }
.btn-export-excel:disabled { background-color: #cccccc; cursor: not-allowed; opacity: 0.7; }
.btn-export-excel i { margin-right: 5px; } /* Style cho icon nếu dùng FontAwesome */


.export-action { margin-top: 15px; text-align: right; }
.btn-export-excel { background-color: #117a47; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; font-size: 0.9rem; transition: background-color 0.2s ease; }
.btn-export-excel:hover:not(:disabled) { background-color: #0d653a; }
.btn-export-excel:disabled { background-color: #cccccc; cursor: not-allowed; opacity: 0.7; }
.btn-export-excel i { margin-right: 5px; }

</style>