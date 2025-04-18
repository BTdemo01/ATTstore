<template>
  <div class="home-view">
    <h1>Sản Phẩm Nổi Bật</h1>

    <div v-if="loading" class="loading-message">Đang tải sản phẩm...</div>
    <div v-if="error" class="error-message">{{ error }}</div>

    <div v-if="!loading && !error" class="product-grid">
      <div v-for="product in featuredProducts" :key="product.id" class="product-card">
          <div class="product-image">
            <img v-if="product.image_url" :src="product.image_url" :alt="product.name" @error="onImageError"/>
            <img v-else src="https://via.placeholder.com/200x160.png?text=No+Image" alt="Ảnh sản phẩm" />
          </div>
          <div class="product-info">
             <h3 class="product-name">{{ product.name }}</h3>
             <p class="product-price">{{ formatCurrency(product.price) }}</p>
          </div>
          <div class="card-actions">
            <p class="product-stock">
              Tồn kho: {{ product.stock_quantity !== undefined ? product.stock_quantity : 'N/A' }}
            </p>
             </div>
          </div>
    </div>

    <div v-if="!loading && featuredProducts.length === 0" class="no-results">
      Hiện chưa có sản phẩm nào nổi bật.
     </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
// Import hàm fetchProducts từ apiService
import { fetchProducts } from '@/services/apiService';
// Giả sử có cart store
// import { useCartStore } from '@/stores/cart';

// const cartStore = useCartStore();
const router = useRouter();

const featuredProducts = ref([]); // State lưu sản phẩm nổi bật
const loading = ref(true);
const error = ref(null);

// Hàm tải sản phẩm nổi bật
const loadFeaturedProducts = async () => {
  loading.value = true;
  error.value = null;
  try {
    // Gọi API fetchProducts với filter is_featured=true
    // Thêm limit nếu muốn giới hạn số lượng SP hiển thị trên trang chủ
    const params = { is_featured: true, limit: 8 }; // Ví dụ lấy 8 sản phẩm
    const response = await fetchProducts(params);

    if (response.data && Array.isArray(response.data.results)) {
      featuredProducts.value = response.data.results;
    } else if (Array.isArray(response.data)) {
      featuredProducts.value = response.data;
    } else {
      featuredProducts.value = [];
    }
  } catch (err) {
    console.error("Lỗi khi tải sản phẩm nổi bật:", err);
    error.value = "Không thể tải sản phẩm nổi bật.";
    featuredProducts.value = [];
  } finally {
    loading.value = false;
  }
};

// Tải dữ liệu khi component mount
onMounted(() => {
  loadFeaturedProducts();
});

// --- Hàm tiện ích ---
const formatCurrency = (value) => { if (value === undefined || value === null || isNaN(value)) return 'N/A'; return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value); };
const onImageError = (event) => { event.target.src = 'https://via.placeholder.com/200x160.png?text=No+Image'; };

// --- Hàm xử lý nút ---
const viewProductDetails = (productId) => {
  // Cần tạo route 'product-details'
  // router.push({ name: 'product-details', params: { id: productId } });
  alert(`Xem chi tiết sản phẩm ${productId} (chưa cài đặt).`);
};
const addToCart = (product) => {
  // Cần cài đặt cart store
  // cartStore.addItem({ ...product, quantity: 1 });
  alert(`Đã thêm "${product.name}" vào giỏ hàng (Demo)!`);
};

</script>

<style scoped>
/* --- CSS tương tự ProductListView.vue --- */
.home-view {
  padding: 25px;
  max-width: 1200px; /* Giới hạn chiều rộng nội dung trang chủ */
  margin: 0 auto; /* Căn giữa */
}

h1 {
  text-align: center;
  margin-bottom: 30px;
  color: #343a40;
  font-size: 1.8rem;
}

.loading-message, .error-message, .no-results {
    text-align: center; margin-top: 40px; padding: 20px; color: #6c757d; font-size: 1.1rem;
}
.error-message { color: red; font-weight: bold; }
.no-results { font-style: italic; }

/* Lưới sản phẩm */
.product-grid {
  display: grid;
  /* Tùy chỉnh số cột cho trang chủ, ví dụ 4 cột */
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); /* Kích thước min có thể lớn hơn */
  gap: 25px; /* Khoảng cách lớn hơn chút */
}

/* Thẻ sản phẩm (style có thể giống hệt ProductListView) */
.product-card {
  background-color: #ffffff; border: 1px solid #e9ecef; border-radius: 8px;
  overflow: hidden; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05); display: flex;
  flex-direction: column; transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
}
.product-card:hover { transform: translateY(-5px); box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1); }

.product-image { width: 100%; height: 180px; /* Chiều cao ảnh có thể lớn hơn */ overflow: hidden; background-color: #f8f9fa; display: flex; justify-content: center; align-items: center; }
.product-image img { display: block; max-width: 100%; max-height: 100%; object-fit: contain; }

.product-info { padding: 12px 15px; text-align: center; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; min-height: 7.5em; }
.product-name { font-size: 1rem; font-weight: 600; margin-bottom: 8px; color: #343a40; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; text-overflow: ellipsis; min-height: 3em; }
.product-price { font-size: 1.1rem; font-weight: bold; color: #d63384; margin-top: auto; padding-top: 8px; }

/* THAY ĐỔI Ở ĐÂY */
.card-actions {
  /* Thay vì flex và space-around, chỉ cần padding */
  padding: 8px 12px 12px 12px;
  text-align: center; /* Căn giữa nội dung tồn kho */
  min-height: 38px; /* Giữ chiều cao tương đương với nút cũ nếu cần */
  display: flex; /* Optional: căn giữa theo chiều dọc nếu cần */
  align-items: center; /* Optional: căn giữa theo chiều dọc */
  justify-content: center; /* Optional: căn giữa theo chiều ngang */
}

.product-stock {
  font-size: 0.95rem; /* Kích thước chữ */
  color: #333;      /* Màu chữ */
  font-weight: 500;
  margin: 0; /* Bỏ margin mặc định của <p> */
}

/* Thêm class này nếu dùng lựa chọn hiển thị hết hàng */
.product-stock-out {
  font-size: 0.95rem;
  color: red; /* Màu đỏ cho hết hàng */
  font-weight: bold;
  margin: 0;
}

.card-actions button { border: none; padding: 8px 10px; border-radius: 5px; cursor: pointer; font-weight: 500; transition: background-color 0.2s ease; font-size: 0.9rem; flex-grow: 1; text-align: center; }
.details-button { background-color: #6c757d; color: #ffffff; }
.details-button:hover { background-color: #5a6268; }
.add-to-cart-button { background-color: #0d6efd; color: #ffffff; }
.add-to-cart-button:hover { background-color: #0b5ed7; }

</style>