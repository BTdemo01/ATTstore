<template>
    <div class="product-list-view">
      <h1 v-if="categoryName">Sản phẩm: {{ categoryName }}</h1>
      <h1 v-else-if="!categoryLoading && !categoryError">Danh sách sản phẩm</h1>
      <div v-if="categoryLoading" class="info-message">Đang tải thông tin loại hàng...</div>
      <div v-if="categoryError && !categoryLoading" class="error-message">
        Không thể tải tên loại hàng. {{ categoryError }}
      </div>
  
      <div class="actions-bar">
         <button class="add-product-button" @click="addProduct">
           + Thêm sản phẩm
         </button>
         <div class="search-bar-container">
           <input type="text" placeholder="Tìm kiếm sản phẩm trong loại hàng này..." v-model="searchTerm" />
         </div>
       </div>
  
  
      <div v-if="productsLoading" class="info-message">Đang tải danh sách sản phẩm...</div>
      <div v-if="productsError" class="error-message">{{ productsError }}</div>
  
      <div v-if="!productsLoading && !productsError" class="product-grid">
        <div v-for="product in filteredProducts" :key="product.id" class="product-card">
           <div class="product-image">
             <img v-if="product.image_url" :src="product.image_url" :alt="product.name" @error="onImageError"/>
             <img v-else src="https://via.placeholder.com/200x160.png?text=No+Image" alt="Ảnh sản phẩm" /> </div>
           <div class="product-info">
              <h3 class="product-name">{{ product.name }}</h3>
              <p class="product-price">{{ formatCurrency(product.price) }}</p>
           </div>
           <div class="card-actions">
              <button class="details-button" @click="viewProductDetails(product.id)">
                Xem Chi Tiết
              </button>
              <!-- <button class="add-to-cart-button" @click="addToCart(product)">
                Thêm vào giỏ
              </button> -->
              </div>
           </div>
      </div>
  
       <div v-if="!productsLoading && filteredProducts.length === 0" class="no-results">
         {{ searchTerm ? 'Không tìm thấy sản phẩm phù hợp.' : 'Chưa có sản phẩm nào trong loại hàng này.' }}
       </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted, watch } from 'vue';
  import { useRouter } from 'vue-router';
  import { fetchProducts, fetchCategory } from '@/services/apiService';
  // Giả sử bạn sẽ tạo store quản lý giỏ hàng (ví dụ dùng Pinia)
  // import { useCartStore } from '@/stores/cart';
  
  // const cartStore = useCartStore(); // Khởi tạo cart store
  const props = defineProps({
    categoryId: { type: [String, Number], required: true }
  });
  const router = useRouter();
  
  const categoryName = ref('');
  const categoryLoading = ref(false);
  const categoryError = ref(null);
  const products = ref([]);
  const productsLoading = ref(true);
  const productsError = ref(null);
  const searchTerm = ref('');
  
  // --- Load Data ---
  const loadCategoryInfo = async (id) => { /* ... giữ nguyên ... */
      categoryLoading.value = true;
      categoryError.value = null;
      try {
          const response = await fetchCategory(id);
          categoryName.value = response.data.name;
      } catch (err) { console.error("Lỗi tải category:", err); categoryError.value = "Lỗi tải tên loại hàng."; }
      finally { categoryLoading.value = false; }
  };
  const loadProducts = async (catId) => { /* ... giữ nguyên ... */
      productsLoading.value = true;
      productsError.value = null;
      try {
          const response = await fetchProducts({ category: catId });
          if (response.data && Array.isArray(response.data.results)) { products.value = response.data.results; }
          else if (Array.isArray(response.data)) { products.value = response.data; }
          else { products.value = []; }
      } catch (err) { console.error("Lỗi tải products:", err); productsError.value = "Không thể tải sản phẩm."; products.value = []; }
      finally { productsLoading.value = false; }
  };
  
  onMounted(() => {
    if (props.categoryId) { loadCategoryInfo(props.categoryId); loadProducts(props.categoryId); }
    else { productsError.value = "Không xác định loại hàng."; productsLoading.value = false; }
  });
  watch(() => props.categoryId, (newId) => {
    if (newId) { loadCategoryInfo(newId); loadProducts(newId); }
  });
  
  // --- Tìm kiếm phía Client ---
  const filteredProducts = computed(() => { /* ... giữ nguyên ... */
    if (!searchTerm.value) { return products.value; }
    const lower = searchTerm.value.toLowerCase();
    return products.value.filter(p => p.name.toLowerCase().includes(lower));
  });
  
  // --- Hàm tiện ích ---
  const formatCurrency = (value) => { /* ... giữ nguyên ... */
      if (value === undefined || value === null || isNaN(value)) return 'N/A';
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
  };
  const onImageError = (event) => { /* ... giữ nguyên ... */
      console.warn("Lỗi tải ảnh:", event.target.src);
      event.target.src = 'https://via.placeholder.com/200x160.png?text=No+Image'; // Dùng URL placeholder
  };
  
  // --- HÀM XỬ LÝ NÚT MỚI ---
  
  // 1. Xử lý nút "+ Thêm sản phẩm"
  const addProduct = () => {
    console.log('Điều hướng đến trang Thêm sản phẩm mới...');
    // Cần tạo route và component cho việc thêm sản phẩm (ví dụ: AddProductView.vue)
    // Giả sử tên route là 'add-product' và thuộc về category hiện tại (nếu cần)
    router.push({ name: 'add-product', params: { categoryId: props.categoryId } });
    // Hoặc một route quản lý chung:
    // router.push({ name: 'manage-products', query: { action: 'add' } });
    alert('Bạn muốn thêm sản phẩm mới?');
  };
  
  // 2. Xử lý nút "Thêm vào giỏ hàng"
  const addToCart = (product) => {
    console.log('Thêm vào giỏ:', product);
    // --- LOGIC THÊM VÀO GIỎ HÀNG THỰC TẾ SẼ Ở ĐÂY ---
    // Ví dụ nếu dùng Pinia store:
    // cartStore.addItem({ ...product, quantity: 1 }); // Cần định nghĩa action addItem trong store
  
    // Hiển thị thông báo đơn giản
    alert(`Đã thêm "${product.name}" vào giỏ hàng (Demo)!`);
    // Hoặc dùng một thư viện notification đẹp hơn
  };
  
  // 3. Xử lý nút "Xem Chi Tiết" (giữ nguyên)
  const viewProductDetails = (productId) => {
    console.log('Xem chi tiết sản phẩm ID:', productId);
    // router.push({ name: 'product-details', params: { id: productId } });
    alert(`Xem chi tiết sản phẩm ${productId} (chưa cài đặt).`);
  };
  
  </script>
  
  <style scoped>
  /* --- Style tổng thể giữ nguyên --- */
  .product-list-view { padding: 20px; background-color: #f8f9fa; }
  h1 { text-align: center; margin-bottom: 25px; color: #495057; }
  .info-message, .error-message, .no-results { text-align: center; margin-top: 30px; padding: 20px; color: #6c757d; }
  .error-message { color: red; font-weight: bold; }
  .no-results { font-style: italic; }
  
  /* --- Thanh Hành động --- */
  .actions-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    flex-wrap: wrap; /* Cho phép xuống dòng nếu không đủ chỗ */
    gap: 15px; /* Khoảng cách giữa nút thêm và search bar nếu xuống dòng */
  }
  
  /* --- Nút Thêm Sản phẩm --- */
  .add-product-button {
      background-color: #FFC0CB; /* Màu hồng xinh iu */
      color: white;
      border: none;
      padding: 10px 15px;
      border-radius: 5px;
      cursor: pointer;
      font-weight: 500;
      transition: background-color 0.2s ease;
      white-space: nowrap;
  }
  .add-product-button:hover {
      background-color: #157347;
  }
  
  
  /* --- Thanh Tìm kiếm --- */
  .search-bar-container {
    /* width: 50%; */ /* Có thể bỏ width để nó co giãn */
    /* max-width: 400px; */
    flex-grow: 1; /* Cho phép thanh tìm kiếm chiếm không gian còn lại */
    display: flex;
    justify-content: flex-end; /* Đẩy input về bên phải container của nó */
  }
  .search-bar-container input {
    padding: 10px 15px;
    border: 1px solid #ced4da;
    border-radius: 20px;
    width: 100%; /* Chiếm hết .search-bar-container */
    max-width: 400px; /* Giới hạn chiều rộng tối đa của input */
    font-size: 1rem;
  }
  
  
  /* --- Lưới sản phẩm --- */
  .product-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 20px;
  }
  
  /* --- Thẻ sản phẩm --- */
  .product-card {
    background-color: #ffffff;
    border: 1px solid #e9ecef;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    display: flex;
    flex-direction: column;
    transition: box-shadow 0.2s ease-in-out;
  }
  .product-card:hover {
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  .product-image {
    width: 100%;
    height: 160px;
    overflow: hidden;
    background-color: #f8f9fa;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .product-image img {
    display: block;
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
  }
  
  /* --- Thông tin sản phẩm --- */
  .product-info {
    padding: 10px 12px;
    text-align: center;
    flex-grow: 1; /* Đẩy khu vực nút xuống dưới */
    display: flex;
    flex-direction: column;
    justify-content: space-between; /* Cố gắng đẩy giá xuống */
    min-height: 7em; /* Đảm bảo có chiều cao tối thiểu */
  }
  .product-name {
    font-size: 0.95rem;
    font-weight: 600;
    margin-bottom: 5px;
    color: #343a40;
     display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
    min-height: 2.8em; /* Chiều cao cho 2 dòng */
  }
  .product-price {
    font-size: 1.05rem;
    font-weight: bold;
    color: #d63384;
    margin-top: auto; /* Đẩy giá xuống dưới cùng nếu có không gian */
    padding-top: 5px; /* Khoảng cách với tên */
  }
  
  /* --- Khu vực chứa các nút trên card --- */
  .card-actions {
      display: flex; /* Đặt các nút trên cùng một hàng */
      justify-content: space-around; /* Căn đều các nút */
      padding: 0 10px 10px 10px; /* Padding đáy và hai bên */
      gap: 5px; /* Khoảng cách giữa các nút */
  }
  
  /* --- Style chung cho các nút trên card --- */
  .card-actions button {
    border: none;
    padding: 6px 10px; /* Giảm padding nếu cần */
    border-radius: 5px;
    cursor: pointer;
    font-weight: 500;
    transition: background-color 0.2s ease;
    font-size: 0.8rem; /* Chữ nhỏ hơn */
    flex-grow: 1; /* Cho các nút cố gắng chiếm không gian bằng nhau */
    text-align: center;
  }
  
  /* Nút Xem Chi Tiết */
  .details-button {
    background-color: #6c757d;
    color: #ffffff;
  }
  .details-button:hover { background-color: #5a6268; }
  
  /* Nút Thêm vào giỏ */
  .add-to-cart-button {
    background-color: #0d6efd; /* Màu xanh dương */
    color: #ffffff;
  }
  .add-to-cart-button:hover { background-color: #0b5ed7; }
  
  </style>