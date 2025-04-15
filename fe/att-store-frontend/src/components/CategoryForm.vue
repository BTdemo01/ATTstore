<template>
    <form @submit.prevent="handleSubmit">
      <h3>{{ formTitle }}</h3>
      <div>
        <label for="category-name">Tên loại hàng:</label>
        <input type="text" id="category-name" v-model="formData.name" required />
      </div>
      <div>
        <label for="category-description">Mô tả:</label>
        <textarea id="category-description" v-model="formData.description"></textarea>
      </div>
      <button type="submit">{{ isEditing ? 'Cập nhật' : 'Thêm mới' }}</button>
      <button type="button" @click="handleCancel" v-if="isEditing">Hủy</button>
      <div v-if="formError" class="error">{{ formError }}</div>
    </form>
  </template>
  
  <script setup>
  import { ref, watch, computed } from 'vue';
  
  // Props để nhận dữ liệu từ component cha
  const props = defineProps({
    category: Object, // Dữ liệu category để sửa, null nếu là thêm mới
    isEditing: Boolean, // Trạng thái đang sửa hay thêm mới
  });
  
  // Emits để gửi sự kiện lên component cha
  const emit = defineEmits(['save', 'cancel']);
  
  // State nội bộ của form
  const formData = ref({
    name: '',
    description: '',
  });
  const formError = ref(null); // State báo lỗi của form
  
  // Computed property cho tiêu đề form
  const formTitle = computed(() => props.isEditing ? 'Sửa Loại Hàng' : 'Thêm Loại Hàng Mới');
  
  // Theo dõi prop `category` để cập nhật form khi chuyển sang chế độ sửa
  watch(() => props.category, (newCategory) => {
    if (newCategory && props.isEditing) {
      formData.value.name = newCategory.name;
      formData.value.description = newCategory.description || '';
    } else {
      // Reset form khi không ở chế độ sửa hoặc không có category
      formData.value.name = '';
      formData.value.description = '';
    }
    formError.value = null; // Reset lỗi khi dữ liệu thay đổi
  }, { immediate: true }); // Chạy ngay lần đầu
  
  // Xử lý submit form
  const handleSubmit = () => {
    formError.value = null; // Reset lỗi trước khi gửi
    // Validate cơ bản (có thể thêm validate phức tạp hơn)
    if (!formData.value.name.trim()) {
        formError.value = "Tên loại hàng không được để trống.";
        return;
    }
    // Gửi sự kiện 'save' với dữ liệu form lên component cha
    emit('save', { ...formData.value });
  };
  
  // Xử lý nút Hủy (chỉ hiển thị khi đang sửa)
  const handleCancel = () => {
    emit('cancel'); // Gửi sự kiện 'cancel' lên cha để reset state ở cha
  }
  </script>
  
  <style scoped>
  form {
    margin-bottom: 20px;
    padding: 15px;
    border: 1px solid #eee;
    background-color: #f9f9f9;
  }
  div {
    margin-bottom: 10px;
  }
  label {
    display: block;
    margin-bottom: 5px;
  }
  input[type="text"], textarea {
    width: 100%;
    padding: 8px;
    box-sizing: border-box;
  }
  button {
    margin-right: 10px;
  }
  .error {
      color: red;
      font-size: 0.9em;
      margin-top: 5px;
  }
  </style>