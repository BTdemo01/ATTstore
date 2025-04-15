<template>
    <div class="add-product-view">
      <h1>Thêm Sản Phẩm Mới</h1>
  
      <div v-if="categoryLoading" class="info-message">Đang tải danh sách loại hàng...</div>
      <div v-if="categoryError" class="error-message">{{ categoryError }}</div>
  
      <form v-if="!categoryLoading && !categoryError" @submit.prevent="handleSaveProduct" class="product-form">
        <div class="form-group">
          <label for="product-category">Loại sản phẩm <span class="required">*</span></label>
          <select id="product-category" v-model="productData.category" required>
            <option disabled value="">-- Chọn loại hàng --</option>
            <option v-for="cat in categories" :key="cat.id" :value="cat.id">
              {{ cat.name }}
            </option>
          </select>
        </div>
  
        <div class="form-group">
          <label for="product-name">Tên sản phẩm <span class="required">*</span></label>
          <input type="text" id="product-name" v-model="productData.name" required />
        </div>
  
        <div class="form-group">
          <label for="product-description">Mô tả</label>
          <textarea id="product-description" v-model="productData.description"></textarea>
        </div>
  
        <div class="form-group">
          <label for="product-price">Giá bán <span class="required">*</span></label>
          <input type="number" id="product-price" v-model.number="productData.price" required min="0" />
        </div>
  
        <div class="form-group">
          <label for="product-stock">Số lượng tồn kho <span class="required">*</span></label>
          <input type="number" id="product-stock" v-model.number="productData.stock_quantity" required min="0" />
        </div>
  
        <div class="form-group">
          <label for="product-image">Link ảnh sản phẩm</label>
          <input type="url" id="product-image" v-model="productData.image_url" placeholder="https://example.com/image.png" />
           <small>Nhập URL đầy đủ của ảnh.</small>
        </div>
  
        <div v-if="submitError" class="error-message">
              {{ submitError }}
         </div>
         <div v-if="successMessage" class="success-message">
              {{ successMessage }}
         </div>
  
        <div class="form-actions">
          <button type="submit" :disabled="isSubmitting || categories.length === 0">
            {{ isSubmitting ? 'Đang lưu...' : 'Lưu Sản Phẩm' }}
          </button>
          <button type="button" @click="goBack" :disabled="isSubmitting">
            Quay lại
          </button>
        </div>
      </form>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { useRouter } from 'vue-router';
  // Import API functions
  import { fetchCategories, createProduct } from '@/services/apiService';
  
  const router = useRouter();
  
  // State cho danh sách categories để đổ vào dropdown
  const categories = ref([]);
  const categoryLoading = ref(true);
  const categoryError = ref(null);
  
  // State cho dữ liệu form sản phẩm
  const productData = ref({
    category: '', // Sẽ lưu category ID được chọn
    name: '',
    description: '',
    price: 0,
    stock_quantity: 0,
    image_url: ''
  });
  
  // State cho submit form
  const isSubmitting = ref(false);
  const submitError = ref(null);
  const successMessage = ref('');
  
  // Hàm tải danh sách categories cho dropdown
  const loadCategories = async () => {
    categoryLoading.value = true;
    categoryError.value = null;
    try {
      const response = await fetchCategories();
      // Lấy dữ liệu từ response (kiểm tra cấu trúc pagination nếu có)
       if (response.data && Array.isArray(response.data.results)) {
           categories.value = response.data.results;
      } else if (Array.isArray(response.data)) {
           categories.value = response.data;
      } else {
          categories.value = [];
      }
  
       if (categories.value.length === 0) {
          categoryError.value = "Không có loại hàng nào để chọn. Vui lòng thêm loại hàng trước.";
       }
  
    } catch (err) {
      console.error("Lỗi khi tải loại hàng:", err);
      categoryError.value = "Không thể tải danh sách loại hàng.";
    } finally {
      categoryLoading.value = false;
    }
  };
  
  // Tải categories khi component được mount
  onMounted(() => {
    loadCategories();
  });
  
  // Hàm xử lý lưu sản phẩm
  const handleSaveProduct = async () => {
    isSubmitting.value = true;
    submitError.value = null;
    successMessage.value = '';
  
    // Kiểm tra category đã được chọn chưa
    if (!productData.value.category) {
        submitError.value = "Vui lòng chọn loại sản phẩm.";
        isSubmitting.value = false;
        return;
    }
  
    try {
      // Chuẩn bị dữ liệu gửi đi (đảm bảo đúng định dạng số)
      const payload = {
          ...productData.value,
          price: Number(productData.value.price) || 0,
          stock_quantity: Number(productData.value.stock_quantity) || 0,
      };
      const response = await createProduct(payload); // Gọi API thêm sản phẩm
      console.log('Product created:', response.data);
  
      successMessage.value = `Đã thêm thành công sản phẩm "${response.data.name}"!`;
      // Reset form sau khi thành công
      productData.value = { category: '', name: '', description: '', price: 0, stock_quantity: 0, image_url: '' };
      // Có thể điều hướng về trang danh sách sản phẩm hoặc trang quản lý
      // setTimeout(() => router.push({ name: 'manage-products' }), 2000);
  
    } catch (err) {
      console.error("Lỗi khi thêm sản phẩm:", err);
       if (err.response && err.response.data) {
         let errorMsg = 'Lỗi: ';
         try {
              for (const field in err.response.data) {
                  errorMsg += `${field}: ${err.response.data[field].join(', ')} `;
              }
         } catch { errorMsg += JSON.stringify(err.response.data); }
         submitError.value = errorMsg.trim();
      } else {
        submitError.value = "Đã xảy ra lỗi không xác định khi thêm sản phẩm.";
      }
    } finally {
      isSubmitting.value = false;
    }
  };
  
  // Hàm quay lại (có thể quay lại trang trước đó hoặc trang cố định)
  const goBack = () => {
    router.go(-1); // Quay lại trang trước đó
    // Hoặc router.push({ name: 'product-list-view' }); // Nếu muốn về trang list cố định
  };
  </script>
  
  <style scoped>
  /* --- Copy và điều chỉnh CSS tương tự AddCategoryView / AddCustomerView --- */
  .add-product-view {
    max-width: 700px; /* Form có thể rộng hơn */
    margin: 30px auto;
    padding: 30px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  }
  
  h1 {
    text-align: center;
    margin-bottom: 30px;
    color: #343a40;
  }
  
  .info-message { text-align: center; padding: 15px; color: #6c757d; }
  
  .product-form .form-group {
    margin-bottom: 20px;
  }
  
  .product-form label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: #495057;
  }
  .product-form label .required { color: red; margin-left: 4px; }
  
  .product-form input[type="text"],
  .product-form input[type="number"],
  .product-form input[type="url"],
  .product-form textarea,
  .product-form select { /* Thêm select */
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #ced4da;
    border-radius: 4px;
    font-size: 1rem;
    box-sizing: border-box;
  }
  
  .product-form select {
      /* Ghi đè một số style mặc định của trình duyệt cho select nếu cần */
      appearance: none; /* Ẩn mũi tên mặc định */
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3E%3C/svg%3E"); /* Thêm mũi tên tùy chỉnh */
      background-repeat: no-repeat;
      background-position: right 0.75rem center;
      background-size: 16px 12px;
      cursor: pointer;
  }
  
  .product-form textarea {
    min-height: 80px;
    resize: vertical;
  }
  .product-form small { font-size: 0.85em; color: #6c757d; margin-top: 5px; display: block; }
  
  .error-message, .success-message {
    padding: 10px 15px; border-radius: 4px; margin-bottom: 20px; font-size: 0.9rem;
  }
  .error-message { color: #dc3545; background-color: #f8d7da; border: 1px solid #f5c2c7; }
  .success-message { color: #0f5132; background-color: #d1e7dd; border: 1px solid #badbcc; }
  
  .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 25px; }
  .form-actions button { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 1rem; font-weight: 500; transition: background-color 0.2s ease; }
  .form-actions button[type="submit"] { background-color: #198754; color: white; }
  .form-actions button[type="submit"]:hover:not(:disabled) { background-color: #157347; }
  .form-actions button[type="button"] { background-color: #6c757d; color: white; }
  .form-actions button[type="button"]:hover:not(:disabled) { background-color: #5a6268; }
  .form-actions button:disabled { opacity: 0.7; cursor: not-allowed; }
  </style>