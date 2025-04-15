<template>
  
  <div class="store"> <div class="search-bar-container">
      <input type="text" placeholder="Tìm kiếm chi nhánh..." v-model="searchTerm" />
    </div>

    <div v-if="loading" class="loading-message">Đang tải danh sách chi nhánh...</div>
    <div v-if="error" class="error-message">{{ error }}</div>

    <div v-if="!loading && !error" class="branch-grid">
      <div v-for="branch in filteredBranches" :key="branch.id" class="branch-card">
        <div class="card-header">
          {{ branch.name }}
        </div>

        <div class="card-map" style="height: 200px; width: 100%;"> <l-map
            v-if="branch.latitude && branch.longitude"
            :zoom="mapOptions.zoom"
            :center="[branch.latitude, branch.longitude]"
            :use-global-leaflet="false"
            style="height: 100%; width: 100%; z-index: 0;" >
            <l-tile-layer
              url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
              layer-type="base"
              name="OpenStreetMap"
              :attribution="mapOptions.attribution"
            ></l-tile-layer>

            <l-marker :lat-lng="[branch.latitude, branch.longitude]">
                </l-marker>
          </l-map>
          <div v-else class="map-placeholder">
            Không có thông tin vị trí bản đồ.
          </div>
        </div>
        <button class="details-button" @click="viewBranchDetails(branch.id)">
          Xem Chi Tiết
        </button>
      </div>
    </div>

    <div v-if="!loading && filteredBranches.length === 0" class="no-results">
      {{ searchTerm ? 'Không tìm thấy chi nhánh phù hợp.' : 'Chưa có chi nhánh nào.' }}
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
// Import hàm fetchBranches từ apiService (Cần tạo hàm này)
// import { fetchBranches } from '@/services/apiService';

// --- Import CSS và components của Leaflet ---
import "leaflet/dist/leaflet.css";
import { LMap, LTileLayer, LMarker } from "@vue-leaflet/vue-leaflet";
// Có thể cần import LPopup, LIcon nếu dùng
// import { LPopup, LIcon } from "@vue-leaflet/vue-leaflet";
// import L from 'leaflet'; // Import L nếu cần fix icon

// --- (Tùy chọn) Fix lỗi icon marker mặc định với Vite/Webpack ---
// Thử bỏ qua bước này trước, nếu marker không hiển thị mới cần làm
// try {
//   delete L.Icon.Default.prototype._getIconUrl;
//   L.Icon.Default.mergeOptions({
//     iconRetinaUrl: await import('leaflet/dist/images/marker-icon-2x.png'),
//     iconUrl: await import('leaflet/dist/images/marker-icon.png'),
//     shadowUrl: await import('leaflet/dist/images/marker-shadow.png'),
//   });
// } catch (e) {
//   console.error("Lỗi khi cấu hình icon Leaflet:", e)
// }
// --------------------------------------------------------------

const router = useRouter();

const branches = ref([]); // State lưu danh sách chi nhánh từ API
const loading = ref(true);
const error = ref(null);
const searchTerm = ref('');

// Cấu hình chung cho bản đồ
const mapOptions = ref({
  zoom: 15, // Mức zoom ban đầu
  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
});

// Hàm tải danh sách chi nhánh (Cần tạo hàm fetchBranches trong apiService)
const loadBranches = async () => {
  loading.value = true;
  error.value = null;
  try {
     // --- THAY BẰNG GỌI API THẬT ---
     // const response = await fetchBranches({ search: searchTerm.value });
     // if (response.data && Array.isArray(response.data.results)) {
     //     branches.value = response.data.results;
     // } else if (Array.isArray(response.data)) {
     //     branches.value = response.data;
     // } else { branches.value = []; }
     // -----------------------------

     // --- Dùng Mock Data (bao gồm lat/lon) ---
     console.log("Đang dùng Mock Data cho chi nhánh (bao gồm lat/lon)");
     await new Promise(resolve => setTimeout(resolve, 500)); // Giả lập mạng
     branches.value = [
        { id: 1, name: 'Chi Nhánh Quận 1', address: '123 Nguyễn Huệ, P. Bến Nghé, Q.1', latitude: 10.7758, longitude: 106.7019 },
        { id: 2, name: 'Chi Nhánh Quận 10', address: '456 Lý Thường Kiệt, P.14, Q.10', latitude: 10.7688, longitude: 106.6564 },
        { id: 3, name: 'Chi Nhánh Quận 11', address: '789 Lê Đại Hành, P.15, Q.11', latitude: 10.7630, longitude: 106.6498 },
        { id: 4, name: 'Chi Nhánh Tân Bình', address: '111 Cộng Hòa, P.12, Q.Tân Bình', latitude: 10.8017, longitude: 106.6518 },
        { id: 5, name: 'Chi Nhánh Phú Nhuận', address: '222 Phan Xích Long, P.2, Q.Phú Nhuận', latitude: 10.7940, longitude: 106.6833 },
        { id: 6, name: 'Chi Nhánh Quận 5', address: '333 Nguyễn Trãi, P.7, Q.5', latitude: 10.7558, longitude: 106.6757 },
        { id: 7, name: 'Chi Nhánh Tân Phú', address: '123 Tân Kỳ Tân Quý, P. TSN, Q.Tân Phú', latitude: 10.7970, longitude: 106.6170 }, // Sử dụng tọa độ gần đúng
        { id: 8, name: 'Chi Nhánh Quận 6', address: '456 Hậu Giang, P.6, Q.6', latitude: 10.7500, longitude: 106.6350 },       // Sử dụng tọa độ gần đúng
        
      ];
     // ------------------------------------

  } catch (err) {
    console.error("Lỗi khi tải chi nhánh:", err);
    error.value = "Không thể tải danh sách chi nhánh.";
    branches.value = [];
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  loadBranches();
});

// Filter phía client (nếu cần)
const filteredBranches = computed(() => {
  if (!searchTerm.value) {
    return branches.value;
  }
  const lower = searchTerm.value.toLowerCase();
  return branches.value.filter(branch =>
    branch.name.toLowerCase().includes(lower) ||
    branch.address.toLowerCase().includes(lower)
  );
});

// Hàm xem chi tiết (giả sử điều hướng đi đâu đó)
const viewBranchDetails = (branchId) => {
    console.log("Xem chi tiết chi nhánh:", branchId);
    // router.push({ name: 'branch-details', params: { id: branchId } });
    alert(`Xem chi tiết chi nhánh ${branchId} (chưa cài đặt)`);
};

</script>

<style scoped>
/* --- CSS tương tự CategoryListView/ProductListView --- */
.home-view { padding: 20px; background-color: #f8f9fa; }
.search-bar-container { margin-bottom: 30px; display: flex; justify-content: right; align-items: center; }
.search-bar-container input { padding: 10px 15px; border: 1px solid #ced4da; border-radius: 20px; width: 60%; max-width: 500px; font-size: 1rem; align-items: center; }
.loading-message, .error-message, .no-results { text-align: center; margin-top: 30px; padding: 20px; color: #6c757d; }
.error-message { color: red; font-weight: bold; }
.no-results { font-style: italic; }

.branch-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; }
.branch-card { background-color: #ffffff; border: 1px solid #e9ecef; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05); display: flex; flex-direction: column; transition: transform 0.2s ease-in-out; }
.branch-card:hover { transform: translateY(-5px); box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); }
.card-header { background-color: #fecaca; color: #991b1b; padding: 10px 15px; font-weight: bold; text-align: center; }

/* --- CSS cho Map --- */
.card-map {
  width: 100%;
  height: 200px; /* BẮT BUỘC CÓ CHIỀU CAO */
  background-color: #e9ecef; /* Màu nền chờ */
}
.map-placeholder {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
    color: #6c757d;
    font-style: italic;
    font-size: 0.9rem;
    text-align: center;
    padding: 10px;
}
/* ------------------ */

.details-button { background-color: #fda4af; color: #881337; border: none; padding: 10px 15px; margin: 15px; border-radius: 5px; cursor: pointer; font-weight: 500; align-self: center; transition: background-color 0.2s ease; }
.details-button:hover { background-color: #fb7185; }

/* Fix z-index nếu map che mất popup/tooltip (thường không cần nếu đặt z-index=0 cho map) */
/* :deep(.leaflet-pane.leaflet-popup-pane),
:deep(.leaflet-pane.leaflet-tooltip-pane) {
    z-index: 650 !important;
} */
</style>