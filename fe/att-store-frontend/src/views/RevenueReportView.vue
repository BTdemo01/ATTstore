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
  fetchRevenueSummary,
  fetchRevenueOverTime,
  fetchRevenueByCategory,
  fetchTopSellingProducts,
  fetchInventorySummary,
  fetchOutOfStockProducts
} from '@/services/apiService';

// Import components biểu đồ và ChartJS
import { Line, Doughnut } from 'vue-chartjs';
import { Chart as ChartJS, ArcElement, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from 'chart.js';

// Đăng ký các thành phần cần thiết cho Chart.js
// Đảm bảo dòng này được thực thi trước khi component được mount
ChartJS.register(ArcElement, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend);

// --- State ---
const loading = ref(true);
const error = ref(null);
const startDate = ref('');
const endDate = ref('');
const selectedRange = ref('month');
const chartDataLoaded = ref(false);

// State cho dữ liệu báo cáo
const summary = reactive({
    totalRevenue: 0, orderCount: 0, averageOrderValue: 0,
    totalStockQuantity: 0, totalStockValue: 0, outOfStockCount: 0
});
const revenueOverTimeData = reactive({
    labels: [],
    datasets: [{ label: 'Doanh thu (VND)', data: [], backgroundColor: 'rgba(54, 162, 235, 0.5)', borderColor: 'rgb(54, 162, 235)', tension: 0.1 }] // Màu khác
});
const revenueByCategoryData = reactive({
    labels: [],
    datasets: [{ data: [], backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40', '#FFCD56', '#C9CBCF'] }] // Thêm màu
});
const topProducts = ref([]);
const outOfStockProducts = ref([]);

// Options biểu đồ
const chartOptions = reactive({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
      legend: { position: 'top', },
      title: { display: false, },
      tooltip: {
          callbacks: { // Định dạng tooltip hiển thị tiền tệ
                label: function(context) {
                    let label = context.dataset.label || '';
                    if (label) { label += ': '; }
                    if (context.parsed.y !== null) {
                        label += formatCurrency(context.parsed.y);
                    }
                     // Nếu là biểu đồ tròn, lấy label từ context.label
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
const formatCurrency = (value) => { if (value === undefined || value === null || isNaN(value)) return '0 đ'; return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value); };

const setDateRange = (rangeType) => {
    const today = new Date(); let start = new Date(); const end = new Date(today);
    switch(rangeType) { case 'today': start = new Date(today.setHours(0, 0, 0, 0)); break; case 'week': const dayOfWeek = today.getDay(); const diff = today.getDate() - dayOfWeek + (dayOfWeek === 0 ? -6 : 1); start = new Date(today.setDate(diff)); start.setHours(0,0,0,0); break; case 'month': start = new Date(today.getFullYear(), today.getMonth(), 1); break; }
    startDate.value = start.toISOString().split('T')[0]; endDate.value = end.toISOString().split('T')[0]; selectedRange.value = rangeType; loadRevenueData();
};
const clearSelectedRange = () => { selectedRange.value = ''; }

const loadRevenueData = async () => {
  loading.value = true; error.value = null; chartDataLoaded.value = false;
  topProducts.value = []; outOfStockProducts.value = [];
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
    else { revenueOverTimeData.labels = []; revenueOverTimeData.datasets[0].data = []; }
    // 3. Cập nhật Doanh thu theo loại hàng
    if (byCategoryRes.data && byCategoryRes.data.labels && byCategoryRes.data.data) { revenueByCategoryData.labels = byCategoryRes.data.labels; revenueByCategoryData.datasets[0].data = byCategoryRes.data.data; }
    else { revenueByCategoryData.labels = []; revenueByCategoryData.datasets[0].data = []; }
    // 4. Cập nhật Top sản phẩm
    if (topProductsRes.data && Array.isArray(topProductsRes.data)) { topProducts.value = topProductsRes.data; } else { topProducts.value = []; }
    // 5. Cập nhật SP hết hàng
    if (outOfStockRes.data && Array.isArray(outOfStockRes.data)) { outOfStockProducts.value = outOfStockRes.data; summary.outOfStockCount = outOfStockProducts.value.length; }
    else { outOfStockProducts.value = []; summary.outOfStockCount = 0; }
    // Đánh dấu chart data loaded
    if (revenueOverTimeData.labels.length > 0 || revenueByCategoryData.labels.length > 0) { chartDataLoaded.value = true; } else { chartDataLoaded.value = false; }
  } catch (err) {
      console.error("Lỗi khi tải dữ liệu báo cáo:", err); error.value = "Không thể tải dữ liệu báo cáo. Vui lòng kiểm tra API backend hoặc kết nối mạng.";
      Object.assign(summary, { totalRevenue: 0, orderCount: 0, averageOrderValue: 0, totalStockQuantity: 0, totalStockValue: 0, outOfStockCount: 0 });
      revenueOverTimeData.labels = []; revenueOverTimeData.datasets[0].data = []; revenueByCategoryData.labels = []; revenueByCategoryData.datasets[0].data = [];
      topProducts.value = []; outOfStockProducts.value = []; chartDataLoaded.value = false;
  } finally { loading.value = false; }
};

// Tải dữ liệu lần đầu
onMounted(() => { setDateRange('month'); });

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
</style>