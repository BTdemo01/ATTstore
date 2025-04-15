import axios from 'axios';

// Lấy Base URL từ biến môi trường hoặc đặt mặc định
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8000/api'; // Cho Vite
// const API_BASE_URL = process.env.VUE_APP_API_BASE_URL || 'http://127.0.0.1:8000/api'; // Cho Vue CLI

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
    // Có thể thêm header Authorization nếu có login:
    // 'Authorization': `Bearer ${token}`
  },
});

// --- Category API Calls ---
export const fetchCategories = () => apiClient.get('/categories/');
export const fetchCategory = (id) => apiClient.get(`/categories/${id}/`);
export const createCategory = (data) => apiClient.post('/categories/', data);
export const updateCategory = (id, data) => apiClient.put(`/categories/${id}/`, data);
export const deleteCategory = (id) => apiClient.delete(`/categories/${id}/`);

// --- Product API Calls ---
export const fetchProducts = (params) => apiClient.get('/products/', { params }); // Hỗ trợ pagination, filter...
export const fetchProduct = (id) => apiClient.get(`/products/${id}/`);
export const createProduct = (data) => apiClient.post('/products/', data); // Formdata nếu có upload ảnh
export const updateProduct = (id, data) => apiClient.put(`/products/${id}/`, data);
export const deleteProduct = (id) => apiClient.delete(`/products/${id}/`);

// --- Customer API Calls ---
export const fetchCustomers = (params) => apiClient.get('/customers/', { params }); // Hỗ trợ filter, search qua params
export const fetchCustomer = (id) => apiClient.get(`/customers/${id}/`);
export const createCustomer = (data) => apiClient.post('/customers/', data);
export const updateCustomer = (id, data) => apiClient.put(`/customers/${id}/`, data); // Hoặc dùng patch
export const deleteCustomerAPI = (id) => apiClient.delete(`/customers/${id}/`); // Đổi tên để tránh trùng

// --- Order API Calls ---
export const fetchOrders = (params) => apiClient.get('/orders/', { params }); // Lấy danh sách, có thể filter
export const fetchOrder = (id) => apiClient.get(`/orders/${id}/`); // Lấy chi tiết 1 đơn
export const createOrder = (data) => apiClient.post('/orders/', data); // Tạo đơn hàng (có thể phức tạp hơn)
export const updateOrder = (id, data) => apiClient.put(`/orders/${id}/`, data); // Cập nhật thông tin chung (ít dùng)
export const deleteOrder = (id) => apiClient.delete(`/orders/${id}/`); // Xóa đơn hàng (nếu cho phép)

// API cho các custom actions trong OrderViewSet
export const approveOrderAPI = (id) => apiClient.post(`/orders/${id}/approve/`);
export const completeOrderAPI = (id) => apiClient.post(`/orders/${id}/complete/`);
export const cancelOrderAPI = (id) => apiClient.post(`/orders/${id}/cancel/`);

// --- API Calls cho Báo cáo ---
export const fetchRevenueSummary = (params) => apiClient.get('/reports/summary/', { params });
export const fetchRevenueOverTime = (params) => apiClient.get('/reports/revenue-over-time/', { params });
export const fetchRevenueByCategory = (params) => apiClient.get('/reports/revenue-by-category/', { params });
export const fetchTopSellingProducts = (params) => apiClient.get('/reports/top-selling-products/', { params });
export const fetchInventorySummary = () => apiClient.get('/reports/inventory-summary/');
export const fetchOutOfStockProducts = () => apiClient.get('/reports/out-of-stock/');


// --- Auth API Calls ---
export const loginUser = (credentials) => {
  // credentials nên là object dạng { email: '...', password: '...' }
  // Hoặc { username: '...', password: '...' } tùy backend API
  // Endpoint có thể là '/auth/login/' hoặc '/api-token-auth/' tùy thư viện backend
  return apiClient.post('/auth/login/', credentials); // Thay đổi endpoint nếu cần
};

export const registerUser = (userData) => {
  // userData nên là object dạng { name: '...', email: '...', password: '...' }
  // Hoặc { username: ..., email: ..., password: ... }
  // Endpoint có thể là '/auth/registration/' tùy thư viện backend
  return apiClient.post('/auth/registration/', userData); // Thay đổi endpoint nếu cần
};

// Có thể thêm hàm lấy thông tin user, logout...
// export const fetchUserInfo = () => apiClient.get('/auth/user/');
// export const logoutUser = () => apiClient.post('/auth/logout/');





// Nếu upload file ảnh, cần cấu hình riêng cho product create/update
// export const createProductWithImage = (formData) => apiClient.post('/products/', formData, {
//   headers: { 'Content-Type': 'multipart/form-data' }
// });
// export const updateProductWithImage = (id, formData) => apiClient.put(`/products/${id}/`, formData, {
//   headers: { 'Content-Type': 'multipart/form-data' }
// });






export default apiClient; // Xuất instance để có thể dùng trực tiếp nếu cần