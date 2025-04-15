<template>
    <div class="create-order-view">
      <h1>Tạo Đơn Hàng Mới</h1>
  
      <div v-if="loadingCustomers" class="info-message">Đang tải danh sách khách hàng...</div>
      <div v-if="loadError" class="error-message">{{ loadError }}</div>
  
      <form v-if="!loadingCustomers && !loadError" @submit.prevent="handleCreateOrder" class="order-form">
        <div class="form-group">
          <label for="order-customer">Khách hàng <span class="required">*</span></label>
          <select id="order-customer" v-model="orderData.customer_id" required @change="onCustomerChange">
            <option disabled value="">-- Chọn khách hàng --</option>
            <option v-for="customer in customers" :key="customer.id" :value="customer.id">
              {{ customer.name }} ({{ customer.customer_code }})
            </option>
          </select>
          <small v-if="customers.length === 0">Không có khách hàng nào. Vui lòng thêm khách hàng trước.</small>
        </div>
        <div class="form-group">
          <label for="order-shipping-address">Địa chỉ giao hàng <span class="required">*</span></label>
          <textarea id="order-shipping-address" v-model="orderData.shipping_address" required placeholder="Nhập địa chỉ đầy đủ để giao hàng"></textarea>
          <small>Bạn có thể sửa lại địa chỉ này nếu khác với địa chỉ mặc định của khách.</small>
        </div>
  
        <div class="order-items-section">
          <h2>Chi tiết sản phẩm</h2>
  
          <div class="add-item-form">
            <div class="form-group search-product-group">
              <label for="product-search">Tìm sản phẩm:</label>
              <input
                type="text"
                id="product-search"
                v-model="productSearchTerm"
                @input="debouncedSearchProducts"
                placeholder="Nhập tên sản phẩm..."
                autocomplete="off"
              />
              <ul v-if="searchedProducts.length > 0 && productSearchTerm" class="search-results">
                <li v-for="prod in searchedProducts" :key="prod.id" @click="selectProductForResult(prod)">
                   <img :src="prod.image_url || '/images/placeholder-product.png'" alt="" class="result-img">
                   <span>{{ prod.name }} - {{ formatCurrency(prod.price) }}</span>
                </li>
              </ul>
            </div>
  
            <div v-if="selectedProduct" class="selected-product-area">
               <span>Đã chọn: <strong>{{ selectedProduct.name }}</strong></span>
               <div class="form-group quantity-group">
                  <label for="item-quantity">Số lượng:</label>
                  <input type="number" id="item-quantity" v-model.number="addItemQuantity" min="1" />
               </div>
                <button type="button" @click="addItemToOrder" class="btn-add-item">Thêm vào đơn</button>
                <button type="button" @click="clearSelectedProduct" class="btn-clear-selection">Bỏ chọn</button>
            </div>
             <div v-if="loadingProducts" class="info-message-small">Đang tìm...</div>
  
          </div>
  
          <div v-if="currentOrderItems.length > 0" class="items-table-container">
            <h3>Sản phẩm trong đơn hàng:</h3>
            <table>
              <thead>
                <tr>
                  <th>Sản phẩm</th>
                  <th>Số lượng</th>
                  <th>Đơn giá</th>
                  <th>Thành tiền</th>
                  <th>Xóa</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(item, index) in currentOrderItems" :key="item.productId">
                  <td>
                    <img :src="item.productImage || '/images/placeholder-product.png'" class="item-img" alt="">
                    {{ item.productName }}
                  </td>
                  <td>
                    <input type="number" min="1" v-model.number="item.quantity" @change="updateItemSubtotal(item)" class="quantity-input"/>
                  </td>
                  <td>{{ formatCurrency(item.price) }}</td>
                  <td>{{ formatCurrency(item.subtotal) }}</td>
                  <td>
                    <button type="button" @click="removeItemFromOrder(index)" class="btn-remove-item">Xóa</button>
                  </td>
                </tr>
              </tbody>
              <tfoot>
                 <tr>
                    <td colspan="3" style="text-align: right; font-weight: bold;">Tổng cộng:</td>
                    <td style="font-weight: bold;">{{ formatCurrency(orderTotal) }}</td>
                    <td></td>
                 </tr>
              </tfoot>
            </table>
          </div>
          <div v-else>
             <p><i>Chưa có sản phẩm nào trong đơn hàng.</i></p>
          </div>
        </div>
        <div v-if="submitError" class="error-message">{{ submitError }}</div>
        <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
  
        <div class="form-actions">
          <button type="submit" :disabled="isSubmitting || !orderData.customer_id || currentOrderItems.length === 0">
            {{ isSubmitting ? 'Đang tạo...' : 'Tạo Đơn Hàng' }}
          </button>
          <button type="button" @click="goBack" :disabled="isSubmitting">
            Quay lại danh sách
          </button>
        </div>
      </form>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive, computed, onMounted } from 'vue';
  import { useRouter } from 'vue-router';
  import { fetchCustomers, createOrder, fetchProducts } from '@/services/apiService'; // Thêm fetchProducts
  
  const router = useRouter();
  
  // State cho khách hàng
  const customers = ref([]);
  const loadingCustomers = ref(true);
  const loadError = ref(null);
  
  // State cho dữ liệu đơn hàng mới
  const orderData = ref({
    customer_id: '',
    shipping_address: '',
  });
  
  // --- State MỚI cho quản lý items ---
  const currentOrderItems = ref([]); // Mảng chứa các sản phẩm trong đơn hiện tại
  const productSearchTerm = ref('');
  const searchedProducts = ref([]); // Kết quả tìm kiếm sản phẩm
  const selectedProduct = ref(null); // Sản phẩm đang được chọn để thêm
  const addItemQuantity = ref(1); // Số lượng cho sản phẩm sắp thêm
  const loadingProducts = ref(false); // Loading khi tìm sản phẩm
  let searchProductsTimeout = null; // Timeout cho debounce tìm kiếm
  // ---------------------------------
  
  // State cho submit form
  const isSubmitting = ref(false);
  const submitError = ref(null);
  const successMessage = ref('');
  
  // --- Hàm tải dữ liệu khách hàng (giữ nguyên) ---
  const loadCustomersForSelect = async () => { /* ... */
      loadingCustomers.value = true; loadError.value = null;
      try {
          const response = await fetchCustomers();
          if (response.data && Array.isArray(response.data.results)) { customers.value = response.data.results; }
          else if (Array.isArray(response.data)) { customers.value = response.data; }
          else { customers.value = []; }
          if (customers.value.length === 0) { loadError.value = "Không có khách hàng nào."; }
      } catch (err) { console.error("Lỗi tải KH:", err); loadError.value = "Lỗi tải danh sách khách hàng."; }
      finally { loadingCustomers.value = false; }
  };
  onMounted(() => { loadCustomersForSelect(); });
  const onCustomerChange = () => { /* ... (giữ nguyên logic điền địa chỉ) ... */
      const selectedCustomer = customers.value.find(c => c.id === orderData.value.customer_id);
      if (selectedCustomer && !orderData.value.shipping_address) { orderData.value.shipping_address = selectedCustomer.address; }
  };
  
  
  // --- Hàm MỚI: Tìm kiếm sản phẩm (Debounced) ---
  const searchProducts = async () => {
    if (!productSearchTerm.value || productSearchTerm.value.length < 2) { // Chỉ tìm khi đủ 2 ký tự
      searchedProducts.value = [];
      return;
    }
    loadingProducts.value = true;
    try {
      const response = await fetchProducts({ search: productSearchTerm.value, limit: 10 }); // Giới hạn 10 kết quả
       if (response.data && Array.isArray(response.data.results)) { searchedProducts.value = response.data.results; }
       else if (Array.isArray(response.data)) { searchedProducts.value = response.data; }
       else { searchedProducts.value = []; }
    } catch (err) {
      console.error("Lỗi tìm sản phẩm:", err);
      searchedProducts.value = []; // Xóa kết quả nếu lỗi
    } finally {
      loadingProducts.value = false;
    }
  };
  const debouncedSearchProducts = () => {
      clearTimeout(searchProductsTimeout);
      searchProductsTimeout = setTimeout(searchProducts, 400); // Chờ 400ms
  };
  
  // --- Hàm MỚI: Chọn sản phẩm từ kết quả tìm kiếm ---
  const selectProductForResult = (product) => {
      selectedProduct.value = product; // Lưu object sản phẩm đã chọn
      productSearchTerm.value = product.name; // Hiển thị tên lên input search
      searchedProducts.value = []; // Ẩn danh sách kết quả
      addItemQuantity.value = 1; // Reset số lượng về 1
  };
  
  // --- Hàm MỚI: Xóa sản phẩm đã chọn ---
  const clearSelectedProduct = () => {
      selectedProduct.value = null;
      productSearchTerm.value = '';
      searchedProducts.value = [];
      addItemQuantity.value = 1;
  };
  
  // --- Hàm MỚI: Thêm Item vào đơn hàng hiện tại ---
  const addItemToOrder = () => {
      if (!selectedProduct.value || addItemQuantity.value <= 0) {
          alert("Vui lòng chọn sản phẩm và nhập số lượng hợp lệ.");
          return;
      }
  
      // Kiểm tra xem sản phẩm đã có trong giỏ chưa
      const existingItemIndex = currentOrderItems.value.findIndex(item => item.productId === selectedProduct.value.id);
  
      if (existingItemIndex > -1) {
          // Nếu đã có, tăng số lượng
          currentOrderItems.value[existingItemIndex].quantity += addItemQuantity.value;
          updateItemSubtotal(currentOrderItems.value[existingItemIndex]); // Cập nhật lại thành tiền
      } else {
          // Nếu chưa có, thêm mới vào mảng
          const newItem = {
              productId: selectedProduct.value.id,
              productName: selectedProduct.value.name,
              productImage: selectedProduct.value.image_url, // Lấy ảnh từ sản phẩm đã chọn
              quantity: addItemQuantity.value,
              price: Number(selectedProduct.value.price) || 0, // Lấy giá từ sản phẩm đã chọn
              subtotal: (Number(selectedProduct.value.price) || 0) * addItemQuantity.value,
          };
          currentOrderItems.value.push(newItem);
      }
  
      // Reset form thêm item
      clearSelectedProduct();
  };
  
  // --- Hàm MỚI: Cập nhật thành tiền khi số lượng thay đổi ---
  const updateItemSubtotal = (item) => {
      item.quantity = Math.max(1, item.quantity); // Đảm bảo số lượng >= 1
      item.subtotal = item.price * item.quantity;
  };
  
  
  // --- Hàm MỚI: Xóa Item khỏi đơn hàng hiện tại ---
  const removeItemFromOrder = (index) => {
      currentOrderItems.value.splice(index, 1); // Xóa item tại vị trí index
  };
  
  // --- Computed Property MỚI: Tính tổng tiền ---
  const orderTotal = computed(() => {
      return currentOrderItems.value.reduce((sum, item) => sum + item.subtotal, 0);
  });
  
  // --- Sửa lại Hàm xử lý tạo đơn hàng ---
  const handleCreateOrder = async () => {
    isSubmitting.value = true;
    submitError.value = null;
    successMessage.value = '';
  
    // Chuẩn bị payload gửi đi
    const payload = {
        customer_id: orderData.value.customer_id,
        shipping_address: orderData.value.shipping_address,
        // Chuyển đổi currentOrderItems thành định dạng backend mong muốn
        items_payload: currentOrderItems.value.map(item => ({
            product_id: item.productId,
            quantity: item.quantity
            // Backend sẽ tự lấy giá và tính total_amount dựa trên items_payload này
        }))
    };
  
    // Validate cơ bản
    if (!payload.customer_id || !payload.shipping_address) {
        submitError.value = "Vui lòng chọn khách hàng và nhập địa chỉ giao hàng.";
        isSubmitting.value = false; return;
    }
    if (!payload.items_payload || payload.items_payload.length === 0) {
         submitError.value = "Vui lòng thêm ít nhất một sản phẩm vào đơn hàng.";
        isSubmitting.value = false; return;
    }
  
    try {
      const response = await createOrder(payload); // Gọi API tạo đơn hàng với items
      console.log('Order created:', response.data);
      successMessage.value = `Đã tạo thành công đơn hàng ${response.data.order_code}! Tổng tiền: ${formatCurrency(response.data.total_amount)}`;
      // Reset form và danh sách items
      orderData.value = { customer_id: '', shipping_address: ''};
      currentOrderItems.value = [];
      // setTimeout(() => router.push({ name: 'order-details', params: { id: response.data.id } }), 3000);
  
    } catch (err) { /* ... (Xử lý lỗi giữ nguyên) ... */
       console.error("Lỗi khi tạo đơn hàng:", err);
       if (err.response && err.response.data) {
         let errorMsg = 'Lỗi tạo đơn hàng: ';
         try { for (const field in err.response.data) { errorMsg += `${field}: ${err.response.data[field].join(', ')} `; } }
         catch { errorMsg += JSON.stringify(err.response.data); }
         submitError.value = errorMsg.trim();
      } else { submitError.value = "Lỗi không xác định khi tạo đơn hàng."; }
    } finally {
      isSubmitting.value = false;
    }
  };
  
  // Hàm quay lại (giữ nguyên)
  const goBack = () => { /* ... */ router.push({ name: 'order-list' }); };
  
  // Định dạng tiền tệ (giữ nguyên)
  const formatCurrency = (value) => { /* ... */ if (value === undefined || value === null || isNaN(value)) return 'N/A'; return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value); };
  
  </script>
  
  <style scoped>
  /* --- CSS giữ nguyên và bổ sung --- */
  .create-order-view { max-width: 900px; /* Rộng hơn */ margin: 30px auto; padding: 30px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); }
  h1 { text-align: center; margin-bottom: 30px; color: #343a40; }
  .info-message { text-align: center; padding: 15px; color: #6c757d; }
  .order-form .form-group { margin-bottom: 20px; }
  .order-form label { display: block; margin-bottom: 8px; font-weight: 500; color: #495057; }
  .order-form label .required { color: red; margin-left: 4px; }
  .order-form input[type="text"], .order-form input[type="number"], .order-form input[type="url"], .order-form input[type="email"], .order-form input[type="tel"], .order-form textarea, .order-form select { width: 100%; padding: 10px 12px; border: 1px solid #ced4da; border-radius: 4px; font-size: 1rem; box-sizing: border-box; }
  .order-form select { cursor: pointer; appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 0.75rem center; background-size: 16px 12px; }
  .order-form textarea { min-height: 80px; resize: vertical; }
  .order-form small { font-size: 0.85em; color: #6c757d; margin-top: 5px; display: block; }
  
  /* --- CSS MỚI CHO PHẦN THÊM SẢN PHẨM --- */
  .order-items-section { border: 1px solid #e9ecef; padding: 20px; margin-top: 30px; margin-bottom: 20px; border-radius: 8px; background-color: #f8f9fa; }
  .order-items-section h2 { margin-top: 0; margin-bottom: 20px; font-size: 1.3rem; color: #495057; border-bottom: 1px solid #dee2e6; padding-bottom: 10px; }
  .add-item-form { display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-start; margin-bottom: 20px; position: relative; }
  .search-product-group { flex: 1 1 300px; /* Cho phép co giãn, cơ sở 300px */ position: relative; }
  .search-results { list-style: none; padding: 0; margin: 5px 0 0 0; position: absolute; background-color: white; border: 1px solid #ced4da; border-top: none; border-radius: 0 0 4px 4px; width: 100%; max-height: 200px; overflow-y: auto; z-index: 10; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
  .search-results li { padding: 8px 12px; cursor: pointer; display: flex; align-items: center; gap: 8px; }
  .search-results li:hover { background-color: #e9ecef; }
  .result-img { width: 30px; height: 30px; object-fit: contain; }
  
  .selected-product-area { background-color: #e9ecef; padding: 10px; border-radius: 4px; margin-top: 10px; display: flex; align-items: center; flex-wrap: wrap; gap: 10px; }
  .quantity-group { display: flex; align-items: center; gap: 5px; margin: 0; flex-basis: 150px; /* Giới hạn chiều rộng */}
  .quantity-group label { margin-bottom: 0; white-space: nowrap; }
  .quantity-group input { width: 60px; text-align: center; }
  
  .btn-add-item, .btn-clear-selection { padding: 8px 12px; font-size: 0.9rem; }
  .btn-add-item { background-color: #198754; color: white; border: none; border-radius: 4px; cursor: pointer; }
  .btn-add-item:hover { background-color: #157347; }
  .btn-clear-selection { background-color: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer; }
  .btn-clear-selection:hover { background-color: #5a6268; }
  
  .info-message-small { font-size: 0.9em; color: #6c757d; margin-left: 10px; }
  
  
  /* --- CSS MỚI CHO BẢNG ITEMS --- */
  .items-table-container { margin-top: 20px; }
  .items-table-container h3 { margin-bottom: 15px; font-size: 1.1rem; color: #495057; }
  .items-table-container table { width: 100%; border-collapse: collapse; }
  .items-table-container th, .items-table-container td { padding: 8px 10px; text-align: left; border-bottom: 1px solid #dee2e6; }
  .items-table-container thead { background-color: #e9ecef; font-size: 0.9rem; }
  .items-table-container tbody td { font-size: 0.95rem; vertical-align: middle; }
  .item-img { width: 40px; height: 40px; object-fit: contain; margin-right: 10px; vertical-align: middle; }
  .quantity-input { width: 60px; text-align: center; padding: 4px; border: 1px solid #ced4da; border-radius: 4px; }
  .btn-remove-item { background-color: #dc3545; color: white; border: none; padding: 4px 8px; font-size: 0.8rem; border-radius: 4px; cursor: pointer; }
  .btn-remove-item:hover { background-color: #bb2d3b; }
  
  /* -------------------------------------------- */
  
  .error-message, .success-message { padding: 10px 15px; border-radius: 4px; margin-bottom: 20px; font-size: 0.9rem; }
  .error-message { color: #dc3545; background-color: #f8d7da; border: 1px solid #f5c2c7; }
  .success-message { color: #0f5132; background-color: #d1e7dd; border: 1px solid #badbcc; }
  
  .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 25px; }
  .form-actions button { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 1rem; font-weight: 500; transition: background-color 0.2s ease; }
  .form-actions button[type="submit"] { background-color: #0d6efd; color: white; }
  .form-actions button[type="submit"]:hover:not(:disabled) { background-color: #0b5ed7; }
  .form-actions button[type="button"] { background-color: #6c757d; color: white; }
  .form-actions button[type="button"]:hover:not(:disabled) { background-color: #5a6268; }
  .form-actions button:disabled { opacity: 0.7; cursor: not-allowed; }
  </style>