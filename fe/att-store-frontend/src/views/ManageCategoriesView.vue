<template>
    <div class="manage-categories">
      <h1>Quản lý Loại Hàng</h1>
  
      <CategoryForm
          :category="selectedCategory"
          :isEditing="isEditing"
          @save="handleSaveCategory"
          @cancel="resetForm"
      />
  
      <h2>Danh sách</h2>
      <div v-if="loading">Đang tải...</div>
      <div v-if="error" class="error">{{ error }}</div>
      <ul v-if="!loading && !error">
        <li v-for="category in categories" :key="category.id">
          {{ category.name }} ({{ category.description || 'Không có mô tả' }})
          <button @click="editCategory(category)">Sửa</button>
          <button @click="confirmDelete(category)">Xóa</button>
        </li>
      </ul>
       <div v-if="!loading && categories.length === 0">Chưa có loại hàng nào.</div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { fetchCategories, createCategory, updateCategory, deleteCategory } from '@/services/apiService';
  import CategoryForm from '@/components/CategoryForm.vue'; // Component form riêng
  
  const categories = ref([]);
  const loading = ref(true);
  const error = ref(null);
  const selectedCategory = ref(null); // Category đang được chọn để sửa
  const isEditing = ref(false);
  
  // Hàm lấy danh sách categories
  const loadCategories = async () => {
    loading.value = true;
    error.value = null;
    try {
      const response = await fetchCategories();
      categories.value = response.data.results || response.data; // Handle pagination if any
    } catch (err) {
      console.error("Lỗi khi tải loại hàng:", err);
      error.value = "Không thể tải danh sách loại hàng.";
    } finally {
      loading.value = false;
    }
  };
  
  // Hàm xử lý lưu (thêm mới hoặc cập nhật)
  const handleSaveCategory = async (categoryData) => {
    error.value = null;
    try {
      if (isEditing.value && selectedCategory.value) {
        // Cập nhật
        await updateCategory(selectedCategory.value.id, categoryData);
      } else {
        // Thêm mới
        await createCategory(categoryData);
      }
      resetForm();
      await loadCategories(); // Tải lại danh sách
    } catch (err) {
       console.error("Lỗi khi lưu loại hàng:", err);
       error.value = "Lưu loại hàng thất bại. Vui lòng thử lại.";
       // Có thể xử lý lỗi chi tiết hơn dựa trên response từ backend
    }
  };
  
  // Chọn category để sửa
  const editCategory = (category) => {
    selectedCategory.value = { ...category }; // Tạo bản sao để tránh sửa trực tiếp state
    isEditing.value = true;
    // Có thể scroll lên form hoặc focus vào form ở đây
  };
  
  // Reset form
  const resetForm = () => {
    selectedCategory.value = null;
    isEditing.value = false;
  };
  
  // Xác nhận xóa
  const confirmDelete = async (category) => {
    if (window.confirm(`Bạn có chắc muốn xóa loại hàng "${category.name}" không?`)) {
      error.value = null;
      try {
        await deleteCategory(category.id);
        await loadCategories(); // Tải lại danh sách
      } catch (err) {
        console.error("Lỗi khi xóa loại hàng:", err);
        error.value = "Xóa loại hàng thất bại.";
         // Có thể backend không cho xóa nếu có sản phẩm thuộc loại hàng đó
      }
    }
  };
  
  // Tải dữ liệu khi component được mounted
  onMounted(() => {
    loadCategories();
  });
  </script>
  
  <style scoped>
  .manage-categories {
    padding: 20px;
  }
  .error {
    color: red;
    margin-top: 10px;
  }
  ul {
    list-style: none;
    padding: 0;
  }
  li {
    margin-bottom: 10px;
    padding: 10px;
    border: 1px solid #ccc;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  button {
    margin-left: 5px;
  }
  </style>