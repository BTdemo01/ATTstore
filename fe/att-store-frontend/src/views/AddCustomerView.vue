<template>
    <div class="add-customer-view">
      <h1>Thêm Khách Hàng Mới</h1>
  
      <form @submit.prevent="handleSaveCustomer" class="customer-form">
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
  
        <div v-if="error" class="error-message">
          {{ error }}
        </div>
        <div v-if="successMessage" class="success-message">
          {{ successMessage }}
        </div>
  
        <div class="form-actions">
          <button type="submit" :disabled="isSubmitting">
            {{ isSubmitting ? 'Đang lưu...' : 'Lưu Khách Hàng' }}
          </button>
          <button type="button" @click="goBack" :disabled="isSubmitting">
            Quay lại danh sách
          </button>
        </div>
      </form>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  import { useRouter } from 'vue-router';
  // Đảm bảo bạn đã export hàm createCustomer từ apiService
  import { createCustomer } from '@/services/apiService';
  
  const router = useRouter();
  
  // State cho dữ liệu form
  const customerData = ref({
    name: '',
    phone: '',
    email: '',
    address: ''
    // Backend sẽ tự tạo customer_code (theo logic trong model)
  });
  
  // State cho trạng thái submit và thông báo
  const isSubmitting = ref(false);
  const error = ref(null);
  const successMessage = ref('');
  
  // Hàm xử lý khi submit form
  const handleSaveCustomer = async () => {
    isSubmitting.value = true;
    error.value = null;
    successMessage.value = '';
  
    try {
      // Gọi API để tạo khách hàng mới
      const response = await createCustomer(customerData.value);
      console.log('Customer created:', response.data);
  
      // Đặt lại form
      customerData.value = { name: '', phone: '', email: '', address: '' };
  
      // Hiển thị thông báo thành công
      successMessage.value = `Đã thêm thành công khách hàng "${response.data.name}"!`;
      // Có thể tự động quay lại sau vài giây
      // setTimeout(() => goBack(), 2000);
  
    } catch (err) {
      console.error("Lỗi khi thêm khách hàng:", err);
      if (err.response && err.response.data) {
         // Hiển thị lỗi chi tiết từ backend nếu có (ví dụ: email/phone đã tồn tại)
         let errorMsg = 'Đã xảy ra lỗi: ';
         try {
              // Thử duyệt qua các lỗi field trả về từ DRF
              for (const field in err.response.data) {
                  errorMsg += `${field}: ${err.response.data[field].join(', ')} `;
              }
         } catch {
              errorMsg += JSON.stringify(err.response.data);
         }
         error.value = errorMsg.trim();
      } else {
         error.value = "Đã xảy ra lỗi không xác định. Vui lòng thử lại.";
      }
    } finally {
      isSubmitting.value = false;
    }
  };
  
  // Hàm quay lại trang danh sách khách hàng
  const goBack = () => {
    // Đảm bảo 'customer-list' là name của route hiển thị danh sách KH
    router.push({ name: 'customer-list' });
  };
  </script>
  
  <style scoped>
  /* --- Copy và điều chỉnh CSS tương tự AddCategoryView.vue --- */
  .add-customer-view {
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
    background-color: #198754; /* Màu xanh lá cho Lưu KH */
    color: white;
  }
  .form-actions button[type="submit"]:hover:not(:disabled) {
    background-color: #157347;
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