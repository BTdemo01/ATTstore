// src/stores/auth.js
import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
// Import apiService nếu cần gọi API lấy thông tin user
// import apiService from '@/services/apiService'

// Đặt tên store là 'auth'
export const useAuthStore = defineStore('auth', () => {
  // === State ===
  // Lấy token từ localStorage khi store khởi tạo (nếu có)
  const authToken = ref(localStorage.getItem('authToken') || null)
  const currentUser = ref(null) // Lưu thông tin user (ví dụ: { id, username, email })

  // === Getters ===
  // Kiểm tra xem đã đăng nhập chưa dựa vào sự tồn tại của token
  const isAuthenticated = computed(() => !!authToken.value)

  // === Actions ===
  // Lưu token và có thể lấy thông tin user
  function setToken(token) {
    authToken.value = token
    localStorage.setItem('authToken', token)
    // TODO: Gọi API lấy thông tin user nếu cần và cập nhật currentUser.value
    // fetchUserInfoAction();
    // Cấu hình axios interceptor để tự động thêm token vào header nếu muốn
    // updateApiClientAuthHeader(token);
  }

  function setUser(user) {
      currentUser.value = user;
      // Có thể lưu user vào localStorage nếu muốn persistent
  }

  // Xóa token và thông tin user khi logout
  function logout() {
    authToken.value = null
    currentUser.value = null
    localStorage.removeItem('authToken')
    // updateApiClientAuthHeader(null); // Xóa token khỏi header axios
    // Có thể gọi API logout của backend nếu có
    // apiService.logoutUser();
  }

   // Action ví dụ để lấy thông tin user (cần API backend)
  // async function fetchUserInfoAction() {
  //   if (!authToken.value) return;
  //   try {
  //       const response = await apiService.fetchUserInfo(); // Cần tạo hàm này
  //       currentUser.value = response.data;
  //   } catch (error) {
  //       console.error("Failed to fetch user info:", error);
  //       // Có thể logout nếu token không hợp lệ
  //       logout();
  //   }
  // }

   // --- Ví dụ cập nhật header cho mọi request axios ---
   // function updateApiClientAuthHeader(token) {
   //    if (token) {
   //       apiService.defaults.headers.common['Authorization'] = `Token ${token}`; // Hoặc Bearer nếu dùng JWT
   //    } else {
   //       delete apiService.defaults.headers.common['Authorization'];
   //    }
   // }
   // Gọi lần đầu khi store khởi tạo
   // updateApiClientAuthHeader(authToken.value);
   // ----------------------------------------------------


  // Return state và actions để component có thể sử dụng
  return { authToken, currentUser, isAuthenticated, setToken, setUser, logout /*, fetchUserInfoAction*/ }
})