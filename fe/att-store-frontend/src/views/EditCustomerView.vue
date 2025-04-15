<template>
    <div class="edit-customer-view">
      <h1>Sửa Thông Tin Khách Hàng</h1>
  
      <div v-if="loading" class="loading-message">Đang tải thông tin khách hàng...</div>
      <div v-if="loadError" class="error-message">{{ loadError }}</div>
  
      <form v-if="!loading && !loadError" @submit.prevent="handleUpdateCustomer" class="customer-form">
        <div class="form-group">
            <label>Mã khách hàng:</label>
            <input type="text" :value="customerData.customer_code" disabled />
        </div>
  
        <div class="form-group">
          <label for="customer-name">Tên khách hàng <span class="required">*</span></label>
          <input type="text" id="customer-name" v-model="customerData.name" required />
        </div>
  
        <div class="form-group">
          <label for="customer-phone">Số điện thoại</label>
          <input type="tel" id="customer-phone" v-model="customerData.phone" />
        </div>
  
        <div class="form-group">
          <label for="customer-email">Email</label>
          <input type="email" id="customer-email" v-model="customerData.email" />
        </div>
  
        <div class="form-group">
          <label for="customer-address">Địa chỉ</label>
          <textarea id="customer-address" v-model="customerData.address"></textarea>
        </div>
  
        <div v-if="submitError" class="error-message">
          {{ submitError }}
        </div>
        <div v-if="successMessage" class="success-message">
          {{ successMessage }}
        </div>
  
        <div class="form-actions">
          <button type="submit" :disabled="isSubmitting">
            {{ isSubmitting ? 'Đang cập nhật...' : 'Cập Nhật Khách Hàng' }}
          </button>
          <button type="button" @click="goBack" :disabled="isSubmitting">
            Quay lại danh sách
          </button>
        </div>
      </form>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { useRouter, useRoute } from 'vue-router';
  // Import hàm API cần thiết
  import { fetchCustomer, updateCustomer } from '@/services/apiService';
  
  const router = useRouter();
  const route = useRoute(); // Dùng useRoute để lấy params từ URL
  
  // Lấy customerId từ route params
  const customerId = ref(route.params.id);
  
  // State cho dữ liệu form (khởi tạo rỗng)
  const customerData = ref({
    customer_code: '', // Thêm để hiển thị mã KH
    name: '',
    phone: '',
    email: '',
    address: ''
  });
  
  // State cho trạng thái tải dữ liệu ban đầu
  const loading = ref(true);
  const loadError = ref(null);
  
  // State cho trạng thái submit và thông báo
  const isSubmitting = ref(false);
  const submitError = ref(null);
  const successMessage = ref('');
  
  // Hàm tải dữ liệu khách hàng hiện tại
  const loadCustomerData = async () => {
    loading.value = true;
    loadError.value = null;
    try {
      const response = await fetchCustomer(customerId.value);
      // Gán dữ liệu lấy được vào state của form
      customerData.value = { ...response.data }; // Copy để tránh thay đổi trực tiếp response
    } catch (err) {
      console.error("Lỗi khi tải thông tin khách hàng:", err);
      loadError.value = "Không thể tải thông tin khách hàng. Vui lòng thử lại hoặc quay lại.";
      // Có thể điều hướng về trang list nếu không tải được
      // router.push({ name: 'customer-list' });
    } finally {
      loading.value = false;
    }
  };
  
  // Tải dữ liệu khi component được mount
  onMounted(() => {
    loadCustomerData();
  });
  
  // Hàm xử lý khi submit form (Cập nhật)
  const handleUpdateCustomer = async () => {
    isSubmitting.value = true;
    submitError.value = null;
    successMessage.value = '';
  
    try {
      // Tạo payload chỉ chứa những trường có thể sửa đổi (không gửi id, customer_code...)
      const updatePayload = {
          name: customerData.value.name,
          phone: customerData.value.phone,
          email: customerData.value.email,
          address: customerData.value.address,
          // Thêm các trường khác nếu có thể sửa đổi
      };
  
      // Gọi API để cập nhật khách hàng
      const response = await updateCustomer(customerId.value, updatePayload);
      console.log('Customer updated:', response.data);
  
      // Hiển thị thông báo thành công
      successMessage.value = `Đã cập nhật thành công thông tin khách hàng "${response.data.name}"!`;
      // Có thể không cần reset form sau khi sửa, hoặc quay lại list
      // setTimeout(() => goBack(), 2000);
  
    } catch (err) {
      console.error("Lỗi khi cập nhật khách hàng:", err);
      if (err.response && err.response.data) {
        let errorMsg = 'Lỗi cập nhật: ';
         try {
             for (const field in err.response.data) {
                 errorMsg += `${field}: ${err.response.data[field].join(', ')} `;
             }
         } catch {
              errorMsg += JSON.stringify(err.response.data);
         }
         submitError.value = errorMsg.trim();
      } else {
        submitError.value = "Đã xảy ra lỗi không xác định khi cập nhật. Vui lòng thử lại.";
      }
    } finally {
      isSubmitting.value = false;
    }
  };
  
  // Hàm quay lại trang danh sách khách hàng
  const goBack = () => {
    router.push({ name: 'customer-list' });
  };
  </script>
  
  <style scoped>
  /* --- Copy và điều chỉnh CSS tương tự AddCustomerView.vue --- */
  .edit-customer-view {
    max-width: 600px;
    margin: 30px auto;
    padding: 25px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  }
  
  h1 {
    text-align: center;
    margin-bottom: 25px;
    color: #343a40;
  }
  
  .loading-message { text-align: center; padding: 20px; }
  
  .customer-form .form-group {
    margin-bottom: 20px;
  }
  
  .customer-form label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: #495057;
  }
  .customer-form label .required {
      color: red;
      margin-left: 4px;
  }
  
  .customer-form input[type="text"],
  .customer-form input[type="tel"],
  .customer-form input[type="email"],
  .customer-form textarea {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #ced4da;
    border-radius: 4px;
    font-size: 1rem;
    box-sizing: border-box;
  }
  
  .customer-form input[disabled] {
      background-color: #e9ecef; /* Nền xám cho input bị vô hiệu hóa */
      cursor: not-allowed;
  }
  
  
  .customer-form textarea {
    min-height: 80px;
    resize: vertical;
  }
  
  .error-message, .success-message {
    padding: 10px 15px;
    border-radius: 4px;
    margin-bottom: 20px;
    font-size: 0.9rem;
  }
  .error-message {
    color: #dc3545;
    background-color: #f8d7da;
    border: 1px solid #f5c2c7;
  }
  .success-message {
    color: #0f5132;
    background-color: #d1e7dd;
    border: 1px solid #badbcc;
  }
  
  .form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 25px;
  }
  
  .form-actions button {
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
    font-weight: 500;
    transition: background-color 0.2s ease;
  }
  
  .form-actions button[type="submit"] {
    background-color: #0d6efd; /* Màu xanh dương cho Cập nhật */
    color: white;
  }
  .form-actions button[type="submit"]:hover:not(:disabled) {
    background-color: #0b5ed7;
  }
  
  .form-actions button[type="button"] {
    background-color: #6c757d;
    color: white;
  }
  .form-actions button[type="button"]:hover:not(:disabled) {
    background-color: #5a6268;
  }
  
  .form-actions button:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }
  </style>