<template>
  <div class="store">
    <div class="search-bar-container">
      <input type="text" placeholder="Tìm kiếm chi nhánh..." v-model="searchTerm" />
    </div>

    <div v-if="loading" class="loading-message">Đang tải danh sách chi nhánh...</div>
    <div v-if="error" class="error-message">{{ error }}</div>

    <div v-if="!loading && !error" class="branch-grid">
      <div v-for="branch in filteredBranches" :key="branch.id" class="branch-card">
        <div class="card-header">
          {{ branch.name }}
        </div>

        <div class="card-map" style="height: 200px; width: 100%;">
          <l-map
            v-if="branch.latitude && branch.longitude"
            :zoom="mapOptions.zoom"
            :center="[branch.latitude, branch.longitude]"
            :use-global-leaflet="false"
            style="height: 100%; width: 100%; z-index: 0;"
          >
            <l-tile-layer
              url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
              layer-type="base"
              name="OpenStreetMap"
              :attribution="mapOptions.attribution"
            ></l-tile-layer>
            <l-marker :lat-lng="[branch.latitude, branch.longitude]"></l-marker>
          </l-map>
          <div v-else class="map-placeholder">
            Không có thông tin vị trí bản đồ.
          </div>
        </div>

        <div class="branch-contact-info">
          <p v-if="branch.address" class="branch-address">
            <span class="label">Địa chỉ:</span> {{ branch.address }}
          </p>
          <p v-if="branch.phone" class="branch-phone">
             <span class="label">SĐT:</span> {{ branch.phone }}
          </p>
          <p v-if="!branch.address && !branch.phone" class="contact-missing">
            Chưa cập nhật thông tin liên hệ.
          </p>
        </div>
        </div>
    </div>

    <div v-if="!loading && filteredBranches.length === 0" class="no-results">
      {{ searchTerm ? 'Không tìm thấy chi nhánh phù hợp.' : 'Chưa có chi nhánh nào.' }}
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
// Bỏ useRouter nếu không dùng hàm viewBranchDetails nữa
// import { useRouter } from 'vue-router';
import "leaflet/dist/leaflet.css";
import { LMap, LTileLayer, LMarker } from "@vue-leaflet/vue-leaflet";

// const router = useRouter(); // Bỏ nếu không dùng

const branches = ref([]);
const loading = ref(true);
const error = ref(null);
const searchTerm = ref('');

const mapOptions = ref({
  zoom: 15,
  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
});

const loadBranches = async () => {
  loading.value = true;
  error.value = null;
  try {
      // --- Dùng Mock Data (CẬP NHẬT THÊM SĐT) ---
      console.log("Đang dùng Mock Data cho chi nhánh (bao gồm lat/lon và phone)");
      await new Promise(resolve => setTimeout(resolve, 500));
      branches.value = [
        { id: 1, name: 'Chi Nhánh Quận 1', address: '123 Nguyễn Huệ, P. Bến Nghé, Q.1', phone: '028 3822 1111', latitude: 10.7758, longitude: 106.7019 },
        { id: 2, name: 'Chi Nhánh Quận 10', address: '456 Lý Thường Kiệt, P.14, Q.10', phone: '028 3866 2222', latitude: 10.7688, longitude: 106.6564 },
        { id: 3, name: 'Chi Nhánh Quận 11', address: '789 Lê Đại Hành, P.15, Q.11', phone: '028 3855 3333', latitude: 10.7630, longitude: 106.6498 },
        { id: 4, name: 'Chi Nhánh Tân Bình', address: '111 Cộng Hòa, P.12, Q.Tân Bình', phone: '028 3844 4444', latitude: 10.8017, longitude: 106.6518 },
        { id: 5, name: 'Chi Nhánh Phú Nhuận', address: '222 Phan Xích Long, P.2, Q.Phú Nhuận', phone: '028 3877 5555', latitude: 10.7940, longitude: 106.6833 },
        { id: 6, name: 'Chi Nhánh Quận 5', address: '333 Nguyễn Trãi, P.7, Q.5', phone: '028 3888 6666', latitude: 10.7558, longitude: 106.6757 },
        { id: 7, name: 'Chi Nhánh Tân Phú', address: '123 Tân Kỳ Tân Quý, P. TSN, Q.Tân Phú', phone: '028 3811 7777', latitude: 10.7970, longitude: 106.6170 },
        { id: 8, name: 'Chi Nhánh Quận 6', address: '456 Hậu Giang, P.6, Q.6', phone: '028 3899 8888', latitude: 10.7500, longitude: 106.6350 },
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

const filteredBranches = computed(() => {
  if (!searchTerm.value) {
    return branches.value;
  }
  const lower = searchTerm.value.toLowerCase();
  return branches.value.filter(branch =>
    (branch.name && branch.name.toLowerCase().includes(lower)) || // Kiểm tra name tồn tại
    (branch.address && branch.address.toLowerCase().includes(lower)) // Kiểm tra address tồn tại
  );
});

// Xóa hàm này nếu không dùng ở đâu khác
// const viewBranchDetails = (branchId) => {
//   console.log("Xem chi tiết chi nhánh:", branchId);
//   alert(`Xem chi tiết chi nhánh ${branchId} (chưa cài đặt)`);
// };

</script>

<style scoped>
/* --- Giữ các style cũ --- */
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

.card-map { width: 100%; height: 200px; background-color: #e9ecef; }
.map-placeholder { display: flex; justify-content: center; align-items: center; height: 100%; color: #6c757d; font-style: italic; font-size: 0.9rem; text-align: center; padding: 10px; }

/* --- THAY ĐỔI/THÊM STYLE MỚI --- */
/* Xóa hoặc comment out style của nút cũ */
/*
.details-button { ... }
.details-button:hover { ... }
*/

/* Style cho khu vực thông tin liên hệ mới */
.branch-contact-info {
  padding: 12px 15px; /* Padding xung quanh */
  font-size: 0.88rem; /* Cỡ chữ nhỏ hơn chút */
  color: #333;
  border-top: 1px solid #eee; /* Đường kẻ phân cách nhẹ nhàng */
  margin-top: 10px; /* Khoảng cách với bản đồ */
  line-height: 1.5; /* Giãn dòng */
}

.branch-contact-info p {
  margin: 4px 0; /* Khoảng cách giữa các dòng địa chỉ/SĐT */
}

.branch-contact-info .label {
    font-weight: 600; /* In đậm nhãn "Địa chỉ:", "SĐT:" */
    display: inline-block; /* Để không bị xuống dòng nếu muốn */
    margin-right: 5px;
}

.contact-missing {
  font-style: italic;
  color: #888;
  font-size: 0.85rem;
}

</style>