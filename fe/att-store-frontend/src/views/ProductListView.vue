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

     <div v-if="!productsLoading && filteredProducts.length === 0" class="no-results">
       {{ searchTerm ? 'Không tìm thấy sản phẩm phù hợp.' : 'Chưa có sản phẩm nào trong loại hàng này.' }}
     </div>
   </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { fetchProducts, fetchCategory } from '@/services/apiService';
// import { useCartStore } from '@/stores/cart';

// const cartStore = useCartStore();
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
      // Quan trọng: Đảm bảo API trả về trường tồn kho (ví dụ: stock_quantity) trong mỗi sản phẩm
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
router.push({ name: 'add-product', params: { categoryId: props.categoryId } });
// alert('Bạn muốn thêm sản phẩm mới?'); // Có thể bỏ alert nếu không cần
};

// 2. Xử lý nút "Thêm vào giỏ hàng" (nếu giữ lại)
const addToCart = (product) => {
console.log('Thêm vào giỏ:', product);
// cartStore.addItem({ ...product, quantity: 1 });
alert(`Đã thêm "${product.name}" vào giỏ hàng (Demo)!`);
};

// 3. Đã xóa hàm viewProductDetails
// const viewProductDetails = (productId) => { ... };

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
flex-wrap: wrap;
gap: 15px;
}

/* --- Nút Thêm Sản phẩm --- */
.add-product-button {
  background-color: #FFC0CB; /* Màu hồng */
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
  background-color: #157347; /* Đổi màu hover nếu muốn */
}


/* --- Thanh Tìm kiếm --- */
.search-bar-container {
flex-grow: 1;
display: flex;
justify-content: flex-end;
}
.search-bar-container input {
padding: 10px 15px;
border: 1px solid #ced4da;
border-radius: 20px;
width: 100%;
max-width: 400px;
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
flex-grow: 1;
display: flex;
flex-direction: column;
justify-content: space-between;
min-height: 7em;
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
min-height: 2.8em;
}
.product-price {
font-size: 1.05rem;
font-weight: bold;
color: #d63384;
margin-top: auto;
padding-top: 5px;
}

/* --- Khu vực chứa các nút/thông tin trên card --- */
.card-actions {
  display: flex;
  justify-content: center; /* Căn giữa nếu chỉ có thông tin tồn kho */
  align-items: center; /* Căn giữa theo chiều dọc */
  padding: 0 10px 10px 10px;
  gap: 5px;
  min-height: 30px; /* Đảm bảo chiều cao tối thiểu */
}

/* --- Style chung cho các nút trên card (nếu có) --- */
.card-actions button {
border: none;
padding: 6px 10px;
border-radius: 5px;
cursor: pointer;
font-weight: 500;
transition: background-color 0.2s ease;
font-size: 0.8rem;
flex-grow: 1;
text-align: center;
}

/* --- Định dạng cho phần hiển thị tồn kho --- */
.product-stock {
  font-size: 0.85rem;
  color: #495057; /* Màu xám đậm */
  font-weight: 500;
  margin: 0; /* Bỏ margin mặc định của <p> */
  padding: 6px 0; /* Thêm padding dọc cho cân đối */
  text-align: center;
  flex-grow: 1; /* Chiếm không gian nếu cần */
}

/* Nút Thêm vào giỏ (nếu giữ lại) */
.add-to-cart-button {
background-color: #0d6efd;
color: #ffffff;
}
.add-to-cart-button:hover { background-color: #0b5ed7; }

</style>