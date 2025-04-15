# api/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
# Import các viewset CRUD đã có
from .views import (
    CategoryViewSet, ProductViewSet, CustomerViewSet, OrderViewSet, OrderItemViewSet, # CRUD Viewsets
    RevenueSummaryAPIView, RevenueOverTimeAPIView, RevenueByCategoryAPIView, # Report Views
    TopSellingProductsAPIView, InventorySummaryAPIView, OutOfStockProductsAPIView,
    api_root # <<< Import hàm api_root mới
)
from . import views

# Router cho các ViewSet CRUD
router = DefaultRouter()
router.register(r'categories', CategoryViewSet, basename='category')
router.register(r'products', ProductViewSet, basename='product')
router.register(r'customers', CustomerViewSet, basename='customer')
router.register(r'orders', OrderViewSet, basename='order')
router.register(r'order-items', OrderItemViewSet, basename='orderitem') 

# urlpatterns bao gồm cả router và các path báo cáo riêng
urlpatterns = [
    # 1. Đặt api_root làm gốc cho app 'api'
    path('', views.api_root, name='api-root'),

    # 2. Include các URL do router tạo ra (vẫn cần để /categories/, /products/ hoạt động)
    # Lưu ý: Đường dẫn này giờ đây *cũng* bắt đầu từ gốc của app 'api',
    # nhưng vì api_root được đặt trước, nó sẽ xử lý request đến '/api/'
    # còn các request đến '/api/categories/', '/api/products/'... sẽ được xử lý bởi router.urls
    path('', include(router.urls)),

    # 3. Thêm các URLs cho Báo cáo như trước (vẫn cần thiết)
    path('reports/summary/', views.RevenueSummaryAPIView.as_view(), name='report-summary'),
    path('reports/revenue-over-time/', views.RevenueOverTimeAPIView.as_view(), name='report-revenue-over-time'),
    path('reports/revenue-by-category/', views.RevenueByCategoryAPIView.as_view(), name='report-revenue-by-category'),
    path('reports/top-selling-products/', views.TopSellingProductsAPIView.as_view(), name='report-top-products'),
    path('reports/inventory-summary/', views.InventorySummaryAPIView.as_view(), name='report-inventory-summary'),
    path('reports/out-of-stock/', views.OutOfStockProductsAPIView.as_view(), name='report-out-of-stock'),
]