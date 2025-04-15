<template>
  <div id="app-container">
    <header class="site-header">
      <div class="logo">
        <!-- <span>CỬA HÀNG TIỆN LỢI ATT</span> -->
        <RouterLink to="/">CỬA HÀNG TIỆN LỢI ATT</RouterLink>
      </div>

      <nav class="main-nav">
        <RouterLink to="/category-list-view">Sản Phẩm</RouterLink>
        <RouterLink to="/orders">Đơn Hàng</RouterLink> 
        <RouterLink to="/revenue">Doanh Thu</RouterLink> 
        <RouterLink to="/customers">Khách Hàng</RouterLink> 
        <RouterLink to="/store">Cửa Hàng</RouterLink> 
        <!-- <RouterLink to="/manage-categories">loại hàng</RouterLink>  -->
      </nav>

       <div class="user-profile">
        <button class="Btn">
          
          <div class="sign"><svg viewBox="0 0 512 512"><path d="M377.9 105.9L500.7 228.7c7.2 7.2 11.3 17.1 11.3 27.3s-4.1 20.1-11.3 27.3L377.9 406.1c-6.4 6.4-15 9.9-24 9.9c-18.7 0-33.9-15.2-33.9-33.9l0-62.1-128 0c-17.7 0-32-14.3-32-32l0-64c0-17.7 14.3-32 32-32l128 0 0-62.1c0-18.7 15.2-33.9 33.9-33.9c9 0 17.6 3.6 24 9.9zM160 96L96 96c-17.7 0-32 14.3-32 32l0 256c0 17.7 14.3 32 32 32l64 0c17.7 0 32 14.3 32 32s-14.3 32-32 32l-64 0c-53 0-96-43-96-96L0 128C0 75 43 32 96 32l64 0c17.7 0 32 14.3 32 32s-14.3 32-32 32z"></path></svg></div>
          
          <div class="text">Logout</div>
        </button>
       </div>
    </header>

      
    <main class="main-content">
      <RouterView /> 
    </main>

    <footer class="site-footer">
      <p>&copy; {{ new Date().getFullYear() }} Chuỗi Cửa Hàng Tiện Lợi ATT. Đã đăng ký bản quyền.</p>
    </footer>
  </div>
</template>

<script setup>
// Import RouterLink và RouterView là đủ cho template này
import { RouterLink, RouterView, useRoute } from 'vue-router';
// Lấy thông tin route hiện tại một cách reactive
const route = useRoute();

// Bạn có thể thêm console log để kiểm tra meta khi chuyển route
// import { watch } from 'vue';
// watch(route, (newRoute) => {
//   console.log('Route meta:', newRoute.meta);
// });
</script>

<style scoped>
/* Container chính để có thể làm sticky footer */
#app-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh; /* Chiều cao tối thiểu bằng chiều cao màn hình */
  
  flex-grow: 1;
   justify-content: center;
   /* align-items: center; // Hoặc center tùy ý */
   padding-top: 0; /* Ghi đè padding của main-content nếu có */
}

/* --- Header Styling --- */
.site-header {
  display: flex;            /* Bật Flexbox */
  justify-content: space-between; /* Phân bố không gian */
  align-items: center;      /* Căn giữa theo chiều dọc */
  padding: 0.8rem 1.5rem;   /* Padding (giảm một chút so với ví dụ trước) */
  background-color: #FFC0CB; 
  border-bottom: 1px solid #dee2e6; /* Viền dưới màu xám nhạt */
  color: #495057;           /* Màu chữ tối hơn */
}

.logo {
  font-weight: bold;
  font-size: 2rem; /* Cỡ chữ to hơn */
  color: #d63384; /* Màu hồng đậm cho tên cửa hàng (ví dụ) */
}

/* --- Navigation Styling --- */
.main-nav a {
  color: #495057; /* Màu link */
  text-decoration: none;
  margin-left: 18px;   /* Khoảng cách giữa các link */
  padding: 8px 12px;
  border-radius: 4px;
  font-weight: 500; /* Chữ đậm vừa phải */
  transition: background-color 0.2s ease, color 0.2s ease;
}

.main-nav a:first-child {
  margin-left: 0;
}

.main-nav a:hover {
  background-color: #f8f9fa; /* Nền xám rất nhạt khi hover */
  color: #000;
}

/* Style cho link đang active (trùng với route hiện tại) */
.main-nav a.router-link-exact-active {
  color: #495057; /* Màu hồng đậm */
  font-weight: bold;
  /* background-color: #f8f9fa; */ /* Có thể bỏ background cho active link */
}


/* --- User Profile Styling (Ví dụ) --- */
.user-profile .profile-button {
  background-color: #FFC0CB; /* Màu hồng nhạt */
  border: none;
  border-radius: 50%; /* Làm nút tròn */
  width: 40px;
  height: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  font-size: 1.2rem;
}

/* --- Main Content Styling --- */
.main-content {
  flex-grow: 1;
}

/* --- Footer Styling --- */
.site-footer {
  background-color: #FFC0CB; /* Nền xám nhạt */
  color: #6c757d; /* Màu chữ xám */
  padding: 1rem 1.5rem;
  text-align: center;
  border-top: 1px solid #dee2e6; /* Viền trên */
  font-size: 0.9rem;
}
/* From Uiverse.io by vinodjangid07 */ 
.Btn {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  width: 45px;
  height: 45px;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition-duration: .3s;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.199);
  background-color: #FF8398;
}

/* plus sign */
.sign {
  width: 100%;
  transition-duration: .3s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.sign svg {
  width: 17px;
}

.sign svg path {
  fill: white;
}
/* text */
.text {
  position: absolute;
  right: 0%;
  width: 0%;
  opacity: 0;
  color: white;
  font-size: 1.2em;
  font-weight: 600;
  transition-duration: .3s;
}
/* hover effect on button width */
.Btn:hover {
  width: 125px;
  border-radius: 40px;
  transition-duration: .3s;
}

.Btn:hover .sign {
  width: 30%;
  transition-duration: .3s;
  padding-left: 20px;
}
/* hover effect button's text */
.Btn:hover .text {
  opacity: 1;
  width: 70%;
  transition-duration: .3s;
  padding-right: 10px;
}
/* button click effect*/
.Btn:active {
  transform: translate(2px ,2px);
}
#app-container {
   display: flex;
   flex-direction: column;
   min-height: 100vh;
}
</style>