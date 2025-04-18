import AddCategoryView from '@/views/AddCategoryView.vue';
import AddCustomerView from '@/views/AddCustomerView.vue';
import CategoryListView from '@/views/CategoryListView.vue';
import CuaHang from '@/views/CuaHang.vue';
import CustomerListView from '@/views/CustomerListView.vue';
import EditCustomerView from '@/views/EditCustomerView.vue';
import HomeView from '@/views/HomeView.vue';
import LoginRegisterView from '@/views/LoginRegisterView.vue';
import ManageCategoriesView from '@/views/ManageCategoriesView.vue';
import ManageProductsView from '@/views/ManageProductsView.vue';
import OrderDetailView from '@/views/OrderDetailView.vue';
import OrderListView from '@/views/OrderListView.vue';
import RevenueReportView from '@/views/RevenueReportView.vue';

import { createRouter, createWebHistory } from 'vue-router';


const ProductListView = () => import('../views/ProductListView.vue');
const AddProductView = () => import('../views/AddProductView.vue'); // Import component mới
const CreateOrderView = () => import('../views/CreateOrderView.vue'); // Import component mới


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView // Sử dụng component đã import
    },
    {
      path: '/manage-categories',
      name: 'manage-categories',
      component: ManageCategoriesView // Sử dụng component đã import
    },
    {
      path: '/manage-products',
      name: 'manage-products',
      component: ManageProductsView // Sử dụng component đã import
    },
    {
      path: '/store',
      name: 'store',
      component: CuaHang // Sử dụng component đã import
    },
    {
      path: '/category-list-view',
      name: 'category-list-view',
      component: CategoryListView // Sử dụng component đã import
    },
    {
      path: '/categories/add', // Đường dẫn bạn muốn
      name: 'add-category',
      component: AddCategoryView
    },
    {
      path: '/categories/:categoryId/products', // Đường dẫn động nhận categoryId
      name: 'products-by-category',            // Tên route
      component: ProductListView,
      props: true                              // Cho phép truyền params thành props
    },
    {
      // Đường dẫn có thể là /products/add hoặc /manage-products/add tùy bạn sắp xếp
      path: '/products/add',
      name: 'add-product', // Tên route
      component: AddProductView
    },
    
    {
      path: '/orders', // Đường dẫn bạn muốn
      name: 'order-list',
      component: OrderListView
    },
    {
      path: '/orders/new', // Đường dẫn bạn muốn
      name: 'create-order', // Tên route phải khớp với tên dùng trong router.push
      component: CreateOrderView
    },
    // Route xem chi tiết đơn hàng
    {
      path: '/orders/:id', // Đường dẫn động với :id
      name: 'order-details', // Tên route để dùng trong router.push
      component: OrderDetailView,
      props: true // Truyền :id thành prop cho component
    },

    {
      path: '/customers', // Đường dẫn bạn muốn
      name: 'customer-list',
      component: CustomerListView
    },
    // Route mới cho trang thêm khách hàng
    {
      path: '/customers/add', // Đường dẫn bạn muốn
      name: 'add-customer', // Tên route phải khớp với tên dùng trong router.push
      component: AddCustomerView
    },
    // Route cho sửa khách hàng (ví dụ, cần tạo component EditCustomerView)
    {
      path: '/customers/:id/edit',
      name: 'edit-customer',
      component: EditCustomerView,
      props: true
    },

    {
      path: '/revenue',
      name: 'revenue-report',    // Đặt tên cho route
      component: RevenueReportView // Trỏ đến component bạn đã tạo
    },



    {
      path: '/auth', // Hoặc '/login', '/register' tùy bạn muốn
      name: 'auth',
      component: LoginRegisterView,
      meta: { requiresGuest: true }, // Meta để đánh dấu route này chỉ cho khách (chưa đăng nhập)
      meta: { hideLayout: true }
    }
  
  // ... router config ...
  
  



  ]
});
// (Tùy chọn) Thêm Navigation Guard để chuyển hướng nếu đã đăng nhập
  // router.beforeEach((to, from, next) => {
  //   const authStore = useAuthStore(); // Giả sử dùng Pinia
  //   if (to.meta.requiresGuest && authStore.isAuthenticated) {
  //     next({ name: 'home' }); // Chuyển về trang chủ nếu đã đăng nhập mà cố vào trang auth
  //   } else if (to.meta.requiresAuth && !authStore.isAuthenticated) {
  //     next({ name: 'auth' }); // Chuyển về trang đăng nhập nếu chưa đăng nhập mà vào trang cần auth
  //   } else {
  //     next(); // Cho phép đi tiếp
  //   }
  // });
export default router;