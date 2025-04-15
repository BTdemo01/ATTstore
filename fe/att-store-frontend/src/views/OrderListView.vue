<template>
  <div class="order-list-view">
    <h1>Quản lý Đơn Hàng</h1>

    <div class="actions-bar">
       <button class="add-order-button" @click="addOrder">+ Tạo đơn hàng mới</button>
       <div class="search-bar-container">
         <input type="text" placeholder="Tìm kiếm đơn hàng (Mã ĐH, Mã KH...)" v-model="searchTerm" @input="handleSearchInput" />
       </div>
    </div>

    <div v-if="loading" class="loading-message">Đang tải danh sách đơn hàng...</div>
    <div v-if="error" class="error-message">{{ error }}</div>

    <div v-if="!loading && !error" class="table-container">
      <table>
        <thead>
          <tr>
            <th>Mã đơn hàng</th>
            <th>Khách hàng</th> <th>Địa chỉ Giao</th>
            <th>Ngày đặt</th>
            <th>Tổng tiền</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="orders.length === 0">
            <td :colspan="columnCount" class="no-results">
              {{ searchPerformed ? 'Không tìm thấy đơn hàng phù hợp.' : 'Chưa có đơn hàng nào.' }}
            </td>
          </tr>
          <tr v-for="order in orders" :key="order.id">
            <td>{{ order.order_code }}</td>
            <td>{{ order.customer_name || order.customer_code || 'N/A' }}</td> <td>{{ order.shipping_address }}</td>
            <td>{{ formatDate(order.order_date) }}</td>
            <td>{{ formatCurrency(order.total_amount) }}</td>
            <td>
              <span :class="['status-badge', getStatusClass(order.status)]">
                 {{ order.status_display }} </span>
            </td>
            <td class="action-buttons">
               <button class="btn-view" @click="viewOrder(order.id)" title="Xem chi tiết">Xem</button>
              <button class="btn-edit" @click="editOrder(order.id)" :disabled="!canEdit(order.status)" title="Sửa đơn hàng">Sửa</button>
              <button class="btn-approve" @click="approveOrderAction(order.id)" :disabled="!canApprove(order.status)" title="Duyệt đơn">Duyệt</button>
              <button class="btn-cancel" @click="cancelOrderAction(order.id)" :disabled="!canCancel(order.status)" title="Hủy đơn">Hủy</button>
              <button class="btn-complete" @click="completeOrderAction(order.id)" :disabled="!canComplete(order.status)" title="Hoàn thành">Hoàn tất</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
// Import các hàm API thật
import { fetchOrders, approveOrderAPI, cancelOrderAPI, completeOrderAPI } from '@/services/apiService';

const router = useRouter();

const orders = ref([]);        // Danh sách đơn hàng từ API
const loading = ref(true);     // Bắt đầu là true
const error = ref(null);
const searchTerm = ref('');
const columnCount = 7;       // Cập nhật số cột
const searchPerformed = ref(false);

// --- Debounce cho tìm kiếm ---
let searchTimeout = null;
const handleSearchInput = () => {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        loadOrders(); // Gọi lại loadOrders khi người dùng ngừng gõ
    }, 500);
};

// --- Hàm gọi API tải danh sách đơn hàng ---
const loadOrders = async () => {
  loading.value = true;
  error.value = null;
  searchPerformed.value = !!searchTerm.value;
  try {
    const params = {};
    if (searchTerm.value) {
      // Backend cần hỗ trợ search theo các trường mong muốn
      params.search = searchTerm.value;
    }
    const response = await fetchOrders(params); // Gọi API thật

    // Xử lý response (kiểm tra cấu trúc pagination nếu có)
    if (response.data && Array.isArray(response.data.results)) {
      orders.value = response.data.results;
       // Xử lý pagination data nếu cần: response.data.count, .next, .previous
    } else if (Array.isArray(response.data)) {
      orders.value = response.data;
    } else {
      console.warn("Cấu trúc API orders response không đúng:", response.data);
      orders.value = [];
    }
  } catch (err) {
    console.error("Lỗi khi tải đơn hàng:", err);
    error.value = "Không thể tải danh sách đơn hàng. Vui lòng thử lại.";
    orders.value = [];
  } finally {
    loading.value = false;
  }
};

// Tải dữ liệu lần đầu
onMounted(() => {
  loadOrders();
});

// --- Hàm định dạng (giữ nguyên) ---
const formatDate = (dateString) => { /* ... */
    if (!dateString) return 'N/A';
    const options = { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' };
    return new Date(dateString).toLocaleDateString('vi-VN', options);
};
const formatCurrency = (value) => { /* ... */
    if (value === undefined || value === null || isNaN(value)) return 'N/A';
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
};
// const formatStatus = (status) => { ... } // Không cần nữa nếu dùng status_display từ serializer
const getStatusClass = (status) => `status-${status}`; // Giữ lại để tạo class CSS

// --- Logic kiểm tra trạng thái nút (điều chỉnh nếu cần) ---
const canEdit = (status) => status === 'pending'; // Chỉ sửa khi đang chờ? Tùy logic
const canApprove = (status) => status === 'pending';
const canCancel = (status) => status === 'pending' || status === 'processing';
const canComplete = (status) => status === 'processing'; // Chỉ hoàn tất khi đang xử lý?

// --- Hàm xử lý nút ---

// Nút Tạo đơn hàng mới
const addOrder = () => {
  console.log('Điều hướng đến trang Tạo đơn hàng mới...');
  // Cần tạo route và component CreateOrderView
  router.push({ name: 'create-order' }); // Giả sử tên route là 'create-order'
};

// Các nút thao tác trên dòng
const viewOrder = (orderId) => {
  console.log(`Xem chi tiết đơn hàng ID: ${orderId}`);
  router.push({ name: 'order-details', params: { id: orderId } });
};

const editOrder = (orderId) => {
  console.log(`Sửa đơn hàng ID: ${orderId}`);
  // router.push({ name: 'order-edit', params: { id: orderId } });
  alert(`Sửa đơn hàng ${orderId} (chưa cài đặt).`);
};

// Hàm gọi API Action Duyệt
const approveOrderAction = async (orderId) => {
    if (!confirm(`Bạn có chắc muốn DUYỆT đơn hàng có mã ${orders.value.find(o=>o.id===orderId)?.order_code || orderId}?`)) return;
    error.value = null; // Xóa lỗi cũ
    try {
        await approveOrderAPI(orderId); // Gọi API action
        alert('Đơn hàng đã được duyệt thành công!');
        loadOrders(); // Tải lại danh sách để cập nhật trạng thái
    } catch (err) {
        console.error("Lỗi khi duyệt đơn hàng:", err);
        error.value = err.response?.data?.error || "Lỗi khi duyệt đơn hàng.";
    }
};

// Hàm gọi API Action Hủy
const cancelOrderAction = async (orderId) => {
     if (!confirm(`Bạn có chắc muốn HỦY đơn hàng có mã ${orders.value.find(o=>o.id===orderId)?.order_code || orderId}?`)) return;
     error.value = null;
    try {
        await cancelOrderAPI(orderId); // Gọi API action
        alert('Đơn hàng đã được hủy thành công!');
        loadOrders(); // Tải lại danh sách
    } catch (err) {
        console.error("Lỗi khi hủy đơn hàng:", err);
         error.value = err.response?.data?.error || "Lỗi khi hủy đơn hàng.";
    }
};

// Hàm gọi API Action Hoàn tất (Ví dụ)
const completeOrderAction = async (orderId) => {
     if (!confirm(`Bạn có chắc muốn đánh dấu HOÀN THÀNH đơn hàng có mã ${orders.value.find(o=>o.id===orderId)?.order_code || orderId}?`)) return;
     error.value = null;
    try {
        await completeOrderAPI(orderId); // Gọi API action
        alert('Đơn hàng đã được hoàn thành!');
        loadOrders(); // Tải lại danh sách
    } catch (err) {
        console.error("Lỗi khi hoàn thành đơn hàng:", err);
         error.value = err.response?.data?.error || "Lỗi khi hoàn thành đơn hàng.";
    }
};

</script>

<style scoped>
/* --- Style tương tự CustomerListView, điều chỉnh nếu cần --- */
.order-list-view { padding: 20px; background-color: #f8f9fa; }
h1 { text-align: center; margin-bottom: 25px; color: #343a40; }

/* Thanh hành động */
.actions-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 15px;
}
/* Nút tạo đơn hàng */
.add-order-button {
    background-color: #FFC0CB; /* Màu hồng */
    color: white;
    border: none; padding: 10px 15px; border-radius: 5px; cursor: pointer; font-weight: 500; transition: background-color 0.2s ease; white-space: nowrap;
}
.add-order-button:hover { background-color: #0b5ed7; }

/* Thanh tìm kiếm */
.search-bar-container { flex-grow: 1; display: flex; justify-content: flex-end; }
.search-bar-container input { padding: 10px 15px; border: 1px solid #ced4da; border-radius: 20px; width: 100%; max-width: 400px; font-size: 0.95rem; }

/* Bảng */
.table-container { background-color: #fff; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #dee2e6; }
thead tr { background-color: #fecaca; }
th { color: #991b1b; font-weight: 600; text-transform: uppercase; font-size: 0.9rem; white-space: nowrap; }
tbody tr:hover { background-color: #f1f3f5; }
td { font-size: 0.95rem; color: #495057; vertical-align: middle; }

/* Cột thao tác */
td.action-buttons { text-align: center; white-space: nowrap; }
td.action-buttons button { margin: 0 3px; padding: 5px 8px; border: none; border-radius: 4px; cursor: pointer; font-size: 0.85rem; transition: opacity 0.2s ease, transform 0.1s ease; }
td.action-buttons button:hover:not(:disabled) { transform: scale(1.05); }
td.action-buttons button:disabled { cursor: not-allowed; opacity: 0.5; }

/* Màu nút thao tác */
.btn-view { background-color: #6c757d; color: white;}
.btn-view:hover:not(:disabled) { background-color: #5a6268;}
.btn-edit { background-color: #ffc107; color: #343a40;}
.btn-edit:hover:not(:disabled) { background-color: #e0a800;}
.btn-approve { background-color: #198754; color: white;} /* Xanh lá */
.btn-approve:hover:not(:disabled) { background-color: #157347;}
.btn-cancel { background-color: #dc3545; color: white;} /* Đỏ */
.btn-cancel:hover:not(:disabled) { background-color: #bb2d3b;}
.btn-complete { background-color: #0dcaf0; color: white;} /* Xanh cyan */
.btn-complete:hover:not(:disabled) { background-color: #0aa3bd;}


/* Trạng thái */
.status-badge { padding: 4px 8px; border-radius: 12px; font-size: 0.8rem; font-weight: bold; white-space: nowrap; }
.status-pending { background-color: #fff3cd; color: #664d03; } /* Vàng */
.status-processing { background-color: #cfe2ff; color: #0a58ca; } /* Xanh dương */
.status-completed { background-color: #d1e7dd; color: #146c43; } /* Xanh lá */
.status-cancelled { background-color: #f8d7da; color: #842029; } /* Đỏ */

/* Thông báo */
.loading-message, .error-message, .no-results { text-align: center; padding: 20px; color: #6c757d; }
.error-message { color: red; font-weight: bold; }
.no-results td { text-align: center; font-style: italic; }
</style>