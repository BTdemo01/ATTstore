<template>
    <div class="auth-page-wrapper">
      <div class="wrapper">
        <div class="card-switch">
          <label class="switch">
            <input type="checkbox" class="toggle" v-model="isRegistering">
            <span class="slider"></span>
            <span class="card-side"></span> <div class="flip-card__inner">
              <div class="flip-card__front">
                <div class="title">Đăng nhập</div>
                <form class="flip-card__form" @submit.prevent="handleLogin">
                  <input
                    class="flip-card__input"
                    name="loginEmail"
                    placeholder="Email hoặc Username"
                    type="text"
                    v-model="loginData.identifier"
                    required
                    autocomplete="username"
                  >
                  <input
                    class="flip-card__input"
                    name="loginPassword"
                    placeholder="Mật khẩu"
                    type="password"
                    v-model="loginData.password"
                    required
                    autocomplete="current-password"
                  >
                   <p v-if="authError && !isRegistering" class="error-message">{{ authError }}</p>
                  <button class="flip-card__btn" :disabled="isLoading">
                    {{ isLoading && !isRegistering ? 'Đang xử lý...' : 'Đăng nhập!' }}
                  </button>
                </form>
              </div>
  
              <div class="flip-card__back">
                <div class="title">Đăng ký</div>
                <form class="flip-card__form" @submit.prevent="handleRegister">
                  <input
                    class="flip-card__input"
                    placeholder="Tên của bạn"
                    type="text"
                    v-model="registerData.name"
                    required
                    autocomplete="name"
                  >
                   <input
                    class="flip-card__input"
                    placeholder="Username (viết liền, không dấu)"
                    type="text"
                    v-model="registerData.username"
                    required
                    autocomplete="username"
                  >
                  <input
                    class="flip-card__input"
                    name="registerEmail"
                    placeholder="Email"
                    type="email"
                    v-model="registerData.email"
                    required
                    autocomplete="email"
                  >
                  <input
                    class="flip-card__input"
                    name="registerPassword"
                    placeholder="Mật khẩu"
                    type="password"
                    v-model="registerData.password"
                    required
                    autocomplete="new-password"
                  >
                   <p v-if="authError && isRegistering" class="error-message">{{ authError }}</p>
                   <p v-if="successMessage" class="success-message">{{ successMessage }}</p>
                  <button class="flip-card__btn" :disabled="isLoading">
                     {{ isLoading && isRegistering ? 'Đang xử lý...' : 'Xác nhận!' }}
                  </button>
                </form>
              </div>
            </div>
          </label>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive, watch } from 'vue';
  import { useRouter } from 'vue-router';
  // Import các hàm API thật (cần tạo/kiểm tra trong apiService.js)
  import { loginUser, registerUser } from '@/services/apiService';
  // Giả sử bạn dùng Pinia để quản lý trạng thái đăng nhập
  // import { useAuthStore } from '@/stores/auth';
  
  // const authStore = useAuthStore();
  const router = useRouter();
  
  const isRegistering = ref(false);
  const loginData = reactive({ identifier: '', password: '' });
  const registerData = reactive({ name: '', username: '', email: '', password: '' });
  const isLoading = ref(false);
  const authError = ref(null);
  const successMessage = ref('');
  
  watch(isRegistering, () => { authError.value = null; successMessage.value = ''; });
  
  const handleLogin = async () => {
    isLoading.value = true; authError.value = null; successMessage.value = '';
    try {
      const credentials = { username: loginData.identifier, email: loginData.identifier, password: loginData.password };
      const response = await loginUser(credentials);
      const token = response.data.key || response.data.access_token || response.data.token;
      if (token) {
          localStorage.setItem('authToken', token);
          // authStore.setToken(token);
          // authStore.setUser(response.data.user);
          console.log("Token saved:", token);
          router.push({ name: 'home' });
      } else { throw new Error("API không trả về token."); }
    } catch (err) {
      console.error("Login failed:", err.response?.data || err.message);
      authError.value = err.response?.data?.non_field_errors?.[0] || err.response?.data?.detail || 'Đăng nhập thất bại.';
      localStorage.removeItem('authToken');
      // authStore.logout();
    } finally { isLoading.value = false; }
  };
  
  const handleRegister = async () => {
    isLoading.value = true; authError.value = null; successMessage.value = '';
    try {
      const userData = { username: registerData.username, email: registerData.email, password: registerData.password, /* first/last name nếu cần */ };
      const response = await registerUser(userData);
      successMessage.value = "Đăng ký thành công! Bạn có thể đăng nhập.";
      Object.assign(registerData, { name: '', username:'', email: '', password: ''});
      isRegistering.value = false;
    } catch (err) {
      console.error("Registration failed:", err.response?.data || err.message);
      let errorMsg = 'Đăng ký thất bại: ';
       try { for (const field in err.response.data) { errorMsg += `${field}: ${err.response.data[field].join(', ')} `; } }
       catch { errorMsg += JSON.stringify(err.response?.data || err.message); }
       authError.value = errorMsg.trim();
    } finally { isLoading.value = false; }
  };
  </script>
  
  <style scoped>
  /* --- Dán toàn bộ CSS bạn cung cấp vào đây --- */
  .wrapper {
            --input-focus: #2d8cf0;
            --font-color: #323232;
            --font-color-sub: #666;
            --bg-color: #fff;
            --bg-color-alt: #666;
            --main-color: #323232;
            display: flex; 
            flex-direction: column; 
            align-items: center; 
          }
          /* switch card */
          .switch {
            transform: translateY(100px);
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 30px;
            width: 50px;
            height: 20px;
          }
          
          .card-side::before {
            position: absolute;
            /*content: 'Log in';*/
            left: -70px;
            top: 0;
            width: 100px;
            text-decoration: underline;
            color: var(--font-color);
            font-weight: 600;
          }
          
          .card-side::after {
            position: absolute;
            /*content: 'Sign up';*/
            left: 70px;
            top: 0;
            width: 100px;
            text-decoration: none;
            color: var(--font-color);
            font-weight: 600;
          }
          
          .toggle {
            opacity: 0;
            width: 0;
            height: 0;
          }
          
          .slider {
            box-sizing: border-box;
            border-radius: 5px;
            border: 2px solid var(--main-color);
            box-shadow: 4px 4px var(--main-color);
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: var(--bg-colorcolor);
            transition: 0.3s;
          }
          
          .slider:before {
            box-sizing: border-box;
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            border: 2px solid var(--main-color);
            border-radius: 5px;
            left: -2px;
            bottom: 2px;
            background-color: var(--bg-color);
            box-shadow: 0 3px 0 var(--main-color);
            transition: 0.3s;
          }
          
          .toggle:checked + .slider {
            background-color: #5a6268;
          }
          
          .toggle:checked + .slider:before {
            transform: translateX(30px);
          }
          
          .toggle:checked ~ .card-side:before {
            text-decoration: none;
          }
          
          .toggle:checked ~ .card-side:after {
            text-decoration: underline;
          }
          
          /* card */ 
          
          .flip-card__inner {
            width: 300px;
            height: 350px;
            position: relative;
            background-color: transparent;
            perspective: 1000px;
              /* width: 100%;
              height: 100%; */
            text-align: center;
            transition: transform 0.8s;
            transform-style: preserve-3d;
          }
          
          .toggle:checked ~ .flip-card__inner {
            transform: rotateY(180deg);
          }
          
          .toggle:checked ~ .flip-card__front {
            box-shadow: none;
          }
          
          .flip-card__front, .flip-card__back {
            padding: 20px;
            position: absolute;
            display: flex;
            flex-direction: column;
            justify-content: center;
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            background: lightgrey;
            gap: 20px;
            border-radius: 5px;
            border: 2px solid var(--main-color);
            box-shadow: 4px 4px var(--main-color);
          }
          
          .flip-card__back {
            width: 100%;
            transform: rotateY(180deg);
          }
          
          .flip-card__form {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
          }
          
          .title {
            margin: 20px 0 20px 0;
            font-size: 25px;
            font-weight: 900;
            text-align: center;
            color: var(--main-color);
          }
          
          .flip-card__input {
            width: 250px;
            height: 40px;
            border-radius: 5px;
            border: 2px solid var(--main-color);
            background-color: var(--bg-color);
            box-shadow: 4px 4px var(--main-color);
            font-size: 15px;
            font-weight: 600;
            color: var(--font-color);
            padding: 5px 10px;
            outline: none;
          }
          
          .flip-card__input::placeholder {
            color: var(--font-color-sub);
            opacity: 0.8;
          }
          
          .flip-card__input:focus {
            border: 2px solid var(--input-focus);
          }
          
          .flip-card__btn:active, .button-confirm:active {
            box-shadow: 0px 0px var(--main-color);
            transform: translate(3px, 3px);
          }
          
          .flip-card__btn {
            margin: 20px 0 20px 0;
            width: 120px;
            height: 40px;
            border-radius: 5px;
            border: 2px solid var(--main-color);
            background-color: var(--bg-color);
            box-shadow: 4px 4px var(--main-color);
            font-size: 17px;
            font-weight: 600;
            color: var(--font-color);
            cursor: pointer;
          } 
  .error-message, .success-message { width: 250px; padding: 8px 10px; margin: 5px 0; font-size: 0.9rem; border-radius: 4px; text-align: center; }
  .error-message { color: #dc3545; background-color: #f8d7da; border: 1px solid #f5c2c7; }
  .success-message { color: #0f5132; background-color: #d1e7dd; border: 1px solid #badbcc; }
  </style>