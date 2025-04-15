<template>
    <div class="add-category-view">
      <h1>Thêm Loại Sản Phẩm Mới</h1>
  
      <form @submit.prevent="handleSaveCategory" class="category-form">
        <div class="form-group">
          <label for="category-name">Tên loại hàng <span class="required">*</span></label>
          <input type="text" id="category-name" v-model="categoryData.name" required />
        </div>
  
        <div class="form-group">
          <label for="category-description">Mô tả</label>
          <textarea id="category-description" v-model="categoryData.description"></textarea>
        </div>
  
        <div class="form-group">
          <label for="category-image">Link ảnh đại diện</label>
          <input type="url" id="category-image" v-model="categoryData.image_url" placeholder="https://example.com/image.png" />
          <small>Nhập URL đầy đủ của ảnh.</small>
        </div>
  
        <div v-if="error" class="error-message">
          {{ error }}
        </div>
         <div v-if="successMessage" class="success-message">
          {{ successMessage }}
        </div>
  
        <div class="form-actions">
          <button type="submit" :disabled="isSubmitting">
            {{ isSubmitting ? 'Đang lưu...' : 'Lưu Loại Hàng' }}
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
  import { createCategory } from '@/services/apiService'; // Import hàm API
  
  const router = useRouter();
  
  // State cho form
  const categoryData = ref({
    name: '',
    description: '',
    image_url: ''
  });
  const isSubmitting = ref(false);
  const error = ref(null);
  const successMessage = ref('');
  
  // Hàm xử lý khi submit form
  const handleSaveCategory = async () => {
    isSubmitting.value = true;
    error.value = null;
    successMessage.value = '';
  
    try {
      // Gọi API để tạo category mới
      const response = await createCategory(categoryData.value);
      console.log('Category created:', response.data);
  
      // Đặt lại form
      categoryData.value = { name: '', description: '', image_url: '' };
  
      // Hiển thị thông báo thành công và có thể điều hướng sau vài giây
      successMessage.value = `Đã thêm thành công loại hàng "${response.data.name}"!`;
      // setTimeout(() => {
      //   router.push({ name: 'category-list' }); // Quay lại trang danh sách
      // }, 2000); // Chờ 2 giây
  
    } catch (err) {
      console.error("Lỗi khi thêm loại hàng:", err);
      if (err.response && err.response.data) {
        // Cố gắng hiển thị lỗi cụ thể từ backend nếu có
         error.value = `Lỗi: ${JSON.stringify(err.response.data)}`;
      } else {
         error.value = "Đã xảy ra lỗi. Vui lòng thử lại.";
      }
    } finally {
      isSubmitting.value = false;
    }
  };
  
  // Hàm quay lại trang danh sách
  const goBack = () => {
    router.push({ name: 'category-list' }); // Đảm bảo 'category-list' là tên route đúng
    // Hoặc dùng router.go(-1) để quay lại trang trước đó
  };
  </script>
  
  <style scoped>
  .add-category-view {
    max-width: 600px; /* Giới hạn chiều rộng form */
    margin: 30px auto; /* Căn giữa */
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
  
  .category-form .form-group {
    margin-bottom: 20px;
  }
  
  .category-form label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: #495057;
  }
   .category-form label .required {
      color: red;
      margin-left: 4px;
  }
  
  
  .category-form input[type="text"],
  .category-form input[type="url"],
  .category-form textarea {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #ced4da;
    border-radius: 4px;
    font-size: 1rem;
    box-sizing: border-box; /* Quan trọng */
  }
  
  .category-form textarea {
    min-height: 80px;
    resize: vertical;
  }
  
   .category-form small {
      font-size: 0.85em;
      color: #6c757d;
      margin-top: 5px;
      display: block;
  }
  
  .error-message {
    color: #dc3545; /* Màu đỏ bootstrap */
    background-color: #f8d7da;
    border: 1px solid #f5c2c7;
    padding: 10px 15px;
    border-radius: 4px;
    margin-bottom: 20px;
    font-size: 0.9rem;
  }
   .success-message {
    color: #0f5132; /* Màu xanh lá bootstrap */
    background-color: #d1e7dd;
    border: 1px solid #badbcc;
     padding: 10px 15px;
    border-radius: 4px;
    margin-bottom: 20px;
    font-size: 0.9rem;
  }
  
  
  .form-actions {
    display: flex;
    justify-content: flex-end; /* Đẩy nút về bên phải */
    gap: 10px; /* Khoảng cách giữa các nút */
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
    background-color: #0d6efd; /* Màu xanh dương bootstrap */
    color: white;
  }
  .form-actions button[type="submit"]:hover:not(:disabled) {
    background-color: #0b5ed7;
  }
  
  .form-actions button[type="button"] {
    background-color: #6c757d; /* Màu xám bootstrap */
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