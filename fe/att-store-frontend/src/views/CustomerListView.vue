<template>
    <div class="customer-list-view">
      <div class="search-bar-container">
        <input type="text" placeholder="Tìm kiếm khách hàng (theo Mã KH, Tên, Địa chỉ...)" v-model="searchTerm" @input="handleSearchInput" />
         </div>
  
      <div class="add-button-container">
        <button class="add-customer-button" @click="addCustomer">+ Thêm khách hàng</button>
      </div>
  
      <div v-if="loading" class="loading-message">Đang tải danh sách khách hàng...</div>
      <div v-if="error" class="error-message">{{ error }}</div>
  
      <div v-if="!loading && !error" class="table-container">
        <table>
          <thead>
            <tr>
              <th>Mã khách hàng</th>
              <th>Tên khách hàng</th>
              <th>Địa chỉ</th>
              <th>Số điện thoại</th>
              <th>Email</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="customers.length === 0">
              <td :colspan="columnCount" class="no-results">
                {{ searchPerformed ? 'Không tìm thấy khách hàng phù hợp.' : 'Chưa có khách hàng nào.' }}
              </td>
            </tr>
            <tr v-for="customer in customers" :key="customer.id">
              <td>{{ customer.customer_code }}</td>
              <td>{{ customer.name }}</td>
              <td>{{ customer.address }}</td>
              <td>{{ customer.phone || 'N/A' }}</td>
              <td>{{ customer.email || 'N/A' }}</td>
              <td class="action-buttons">
                <button class="btn-edit" @click="editCustomer(customer.id)">Sửa</button>
                <button class="btn-delete" @click="deleteCustomer(customer.id, customer.name)">Xóa</button>
              </td>
            </tr>
          </tbody>
        </table>
         </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, watch } from 'vue'; // Bỏ computed nếu không filter client-side
  import { useRouter } from 'vue-router';
  // Import các hàm API thật
  import { fetchCustomers, deleteCustomerAPI } from '@/services/apiService';
  
  const router = useRouter();
  
  const customers = ref([]); // Dữ liệu khách hàng từ API
  const loading = ref(true); // *** Bắt đầu với trạng thái loading = true ***
  const error = ref(null);
  const searchTerm = ref('');
  const columnCount = 6;
  const searchPerformed = ref(false); // Biến để biết đã thực hiện tìm kiếm hay chưa
  
  // --- Debounce cho tìm kiếm (tránh gọi API liên tục khi gõ) ---
  let searchTimeout = null;
  const handleSearchInput = () => {
      clearTimeout(searchTimeout);
      searchTimeout = setTimeout(() => {
          // Tải lại dữ liệu với search term mới sau khi người dùng ngừng gõ 500ms
          loadCustomers();
      }, 500); // Chờ 500ms
  };
  // -----------------------------------------------------------
  
  // Hàm gọi API để tải khách hàng
  const loadCustomers = async () => {
    loading.value = true;
    error.value = null;
    searchPerformed.value = !!searchTerm.value; // Đánh dấu đã tìm kiếm nếu có searchTerm
    try {
      // Truyền searchTerm vào params nếu nó có giá trị
      const params = {};
      if (searchTerm.value) {
        // Giả sử backend hỗ trợ tìm kiếm qua param 'search'
        // Hoặc có thể là 'name', 'phone' tùy cấu hình FilterSet backend
        params.search = searchTerm.value;
      }
      const response = await fetchCustomers(params); // Gọi API thật
  
      // Xử lý response (kiểm tra cấu trúc pagination nếu có)
      if (response.data && Array.isArray(response.data.results)) {
        customers.value = response.data.results;
        // Xử lý thông tin pagination khác nếu cần (response.data.count, .next, .previous)
      } else if (Array.isArray(response.data)) {
        customers.value = response.data; // Nếu API trả về mảng trực tiếp
      } else {
        console.warn("Cấu trúc API response không đúng:", response.data);
        customers.value = [];
      }
    } catch (err) {
      console.error("Lỗi khi tải khách hàng:", err);
      error.value = "Không thể tải danh sách khách hàng. Vui lòng thử lại.";
      customers.value = []; // Đảm bảo mảng rỗng khi lỗi
    } finally {
      loading.value = false;
    }
  };
  
  // Tải dữ liệu lần đầu khi component được mount
  onMounted(() => {
    loadCustomers();
  });
  
  // --- Hàm xử lý nút ---
  const addCustomer = () => {
    console.log('Điều hướng đến trang Thêm khách hàng mới...');
    // Giả sử bạn có route tên 'add-customer' cho trang thêm mới
    router.push({ name: 'add-customer' });
  };
  
  const editCustomer = (customerId) => {
    console.log(`Điều hướng đến trang Sửa khách hàng ID: ${customerId}`);
    // Giả sử bạn có route tên 'edit-customer' nhận param 'id'
    router.push({ name: 'edit-customer', params: { id: customerId } });
  };
  
  const deleteCustomer = async (customerId, customerName) => {
    console.log(`Xóa khách hàng ID: ${customerId}`);
    // Sử dụng tên KH (nếu có) trong thông báo xác nhận
    if (confirm(`Bạn có chắc muốn XÓA khách hàng "${customerName || customerId}" không? Hành động này không thể hoàn tác.`)) {
      loading.value = true; // Hiển thị loading trong khi xóa
      error.value = null;
      try {
        // Gọi API để xóa khách hàng
        await deleteCustomerAPI(customerId);
  
        // Tải lại danh sách khách hàng sau khi xóa thành công
        await loadCustomers(); // Chờ tải lại xong mới ẩn loading
  
        alert('Xóa khách hàng thành công!');
  
      } catch (err) {
         console.error("Lỗi khi xóa khách hàng:", err);
         // Hiển thị lỗi cụ thể hơn nếu có từ response
         if (err.response && err.response.data && err.response.data.detail) {
              error.value = `Lỗi xóa khách hàng: ${err.response.data.detail}`;
         } else {
              error.value = 'Có lỗi xảy ra khi xóa khách hàng. Vui lòng thử lại.';
         }
         // Không ẩn loading ngay nếu có lỗi để người dùng thấy thông báo lỗi
         loading.value = false; // Có thể ẩn loading ngay cả khi lỗi tùy ý
      }
      // finally {
      //     // loading.value = false; // Chuyển vào trong try/catch để xử lý tốt hơn
      // }
    }
  };
  
  </script>
  
  <style scoped>
  /* CSS giữ nguyên như trước */
  .customer-list-view {
    padding: 20px;
    background-color: #f8f9fa;
  }
  
  .add-button-container {
      margin-bottom: 20px;
      display: flex;
  }
  
  .add-customer-button {
      background-color: #FFC0CB;
      color: white;
      border: none;
      padding: 10px 15px;
      border-radius: 5px;
      cursor: pointer;
      font-weight: 500;
      transition: background-color 0.2s ease;
  }
  .add-customer-button:hover {
      background-color: #157347;
  }
  
  .search-bar-container {
    margin-bottom: 20px;
    display: flex;
    justify-content: flex-end;
  }
  .search-bar-container input {
    padding: 8px 12px;
    border: 1px solid #ced4da;
    border-radius: 20px;
    width: 40%;
    max-width: 350px;
  }
  
  .table-container {
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
      overflow-x: auto;
  }
  
  table {
    width: 100%;
    border-collapse: collapse;
  }
  
  th, td {
    padding: 12px 15px;
    text-align: left;
    border-bottom: 1px solid #dee2e6;
  }
  
  thead tr {
    background-color: #fecaca;
  }
  
  th {
    color: #991b1b;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.9rem;
    white-space: nowrap;
  }
  
  tbody tr:hover {
    background-color: #f1f3f5;
  }
  
  td {
      font-size: 0.95rem;
      color: #495057;
  }
  
  td.action-buttons {
      text-align: center;
       white-space: nowrap;
  }
  
  td.action-buttons button {
    margin: 0 4px;
    padding: 6px 10px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.9rem;
    transition: opacity 0.2s ease;
  }
  
  td.action-buttons button:disabled {
      cursor: not-allowed;
      opacity: 0.6;
  }
  
  .btn-edit, .btn-delete {
      background-color: #fda4af;
      color: #881337;
  }
  .btn-edit:hover:not(:disabled), .btn-delete:hover:not(:disabled) {
      background-color: #fb7185;
  }
  
  .loading-message, .error-message, .no-results {
      text-align: center;
      padding: 20px;
      color: #6c757d;
  }
  .error-message { color: red; font-weight: bold; }
  .no-results td { text-align: center; font-style: italic; }
  
  </style>