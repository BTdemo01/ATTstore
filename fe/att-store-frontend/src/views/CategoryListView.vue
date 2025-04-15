<template>
    <div class="category-list-view">
      <div class="actions-bar">
        <button class="add-category-button" @click="navigateToAddCategory">
          + Thêm loại sản phẩm
        </button>
        <div class="search-bar-container">
          <input type="text" placeholder="Tìm kiếm loại hàng..." v-model="searchTerm" />
        </div>
      </div>
  
      <div v-if="loading" class="loading-message">Đang tải danh sách loại hàng...</div>
      <div v-if="error" class="error-message">{{ error }}</div>
  
      <div v-if="!loading && !error" class="category-grid">
        <div v-for="category in filteredCategories" :key="category.id" class="category-card">
          <div class="card-header">
            {{ category.name }}
          </div>
          <div class="card-image">
            <img v-if="category.image_url" :src="category.image_url" :alt="`Ảnh ${category.name}`" />
            <!-- <img v-else src="/images/placeholder-category.png" alt="Ảnh loại hàng" /> -->
          </div>
          <button class="details-button" @click="viewProductsByCategory(category.id, category.name)">
            Xem Chi Tiết
          </button>
        </div>
      </div>
  
      <div v-if="!loading && filteredCategories.length === 0" class="no-results">
        {{ searchTerm ? 'Không tìm thấy loại hàng phù hợp.' : 'Chưa có loại hàng nào.' }}
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue';
  import { useRouter } from 'vue-router';
  import { fetchCategories } from '@/services/apiService';
  
  const router = useRouter();
  
  const categories = ref([]);
  const loading = ref(true);
  const error = ref(null);
  const searchTerm = ref('');
  
  const loadCategories = async () => {
    loading.value = true;
    error.value = null;
    try {
      const response = await fetchCategories();
      if (response.data && Array.isArray(response.data.results)) {
        categories.value = response.data.results;
      } else if (Array.isArray(response.data)) {
        categories.value = response.data;
      } else {
        console.warn("Unexpected API response structure:", response.data);
        categories.value = [];
      }
    } catch (err) {
      console.error("Lỗi khi tải loại hàng:", err);
      error.value = "Không thể tải danh sách loại hàng. Vui lòng thử lại.";
    } finally {
      loading.value = false;
    }
  };
  
  onMounted(() => {
    loadCategories();
  });
  
  const filteredCategories = computed(() => {
    // ... (logic filter giữ nguyên)
    if (!searchTerm.value) {
      return categories.value;
    }
    const lowerCaseSearch = searchTerm.value.toLowerCase();
    return categories.value.filter(category =>
      category.name.toLowerCase().includes(lowerCaseSearch)
    );
  });
  
  const viewProductsByCategory = (categoryId, categoryName) => {
    console.log(`Xem sản phẩm thuộc loại hàng: ${categoryName} (ID: ${categoryId})`);
    // ... (logic điều hướng giữ nguyên)
    router.push({ name: 'products-by-category', params: { categoryId: categoryId } });
  };
  
  // Hàm xử lý cho nút "Thêm loại sản phẩm"
  const navigateToAddCategory = () => {
    console.log('Chuyển đến trang thêm loại sản phẩm...');
    // TODO: Điều hướng đến trang quản lý/thêm category hoặc mở modal
    // Ví dụ điều hướng đến route quản lý:
    router.push({ name: 'add-category' });
    alert('Bạn muốn thêm loại sản phẩm mới.');
  };
  
  </script>
  
  <style scoped>
  .category-list-view {
    padding: 20px;
    background-color: #f8f9fa;
    min-height: calc(100vh - 100px);
  }
  
  /* --- Thanh Hành động --- */
  .actions-bar {
    display: flex;            /* Bật flexbox */
    justify-content: space-between; /* Đẩy nút và search bar ra hai phía */
    align-items: center;      /* Căn giữa theo chiều dọc */
    margin-bottom: 30px;      /* Khoảng cách với lưới bên dưới */
  }
  
  /* --- Nút Thêm --- */
  .add-category-button {
    background-color: #FFC0CB; /* Màu hồng nhạt */
    color: white;           /* Màu chữ đỏ sẫm */
    border: none;
    padding: 10px 15px;
    border-radius: 5px;
    cursor: pointer;
    font-weight: 500;
    transition: background-color 0.2s ease;
    white-space: nowrap; /* Chống xuống dòng nếu tên nút dài */
  }
  
  .add-category-button:hover {
    background-color: #fb7185; /* Đậm hơn khi hover */
  }
  
  /* --- Thanh Tìm kiếm --- */
  .search-bar-container {
    /* Không cần margin-bottom nữa vì đã có ở actions-bar */
    /* display: flex; */ /* Không cần flex ở đây nữa */
    /* justify-content: center; */ /* Bỏ căn giữa */
    /* Có thể đặt width nếu muốn giới hạn độ rộng */
     width: 50%; /* Ví dụ: cho thanh search chiếm 50% */
     max-width: 400px;
  }
  
  .search-bar-container input {
    padding: 10px 15px;
    border: 1px solid #ced4da;
    border-radius: 20px;
    width: 100%; /* Chiếm hết width của container cha (.search-bar-container) */
    font-size: 1rem;
  }
  
  /* --- Các style khác giữ nguyên --- */
  
  .loading-message, .error-message, .no-results {
      text-align: center;
      margin-top: 30px;
      padding: 20px;
  }
  .error-message {
      color: red;
      font-weight: bold;
  }
  .no-results {
      color: #6c757d;
      font-style: italic;
  }
  
  .category-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 25px;
  }
  
  .category-card {
    background-color: #ffffff;
    border: 1px solid #e9ecef;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    display: flex;
    flex-direction: column;
    transition: transform 0.2s ease-in-out;
  }
  
  .category-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  .card-header {
    background-color: #fecaca;
    color: #991b1b;
    padding: 10px 15px;
    font-weight: bold;
    text-align: center;
  }
  
  .card-image {
    width: 100%;
    height: 180px;
    overflow: hidden;
    background-color: #e9ecef;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .card-image img {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
  
  .details-button {
    background-color: #fda4af;
    color: #881337;
    border: none;
    padding: 10px 15px;
    margin: 15px;
    border-radius: 5px;
    cursor: pointer;
    font-weight: 500;
    align-self: center;
    transition: background-color 0.2s ease;
  }
  
  .details-button:hover {
    background-color: #fb7185;
  }
  </style>