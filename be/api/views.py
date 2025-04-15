# api/views.py
from rest_framework import viewsets, status,filters
from rest_framework.decorators import action
from rest_framework.response import Response
# Import AllowAny và các permission khác nếu cần sau này
from rest_framework.permissions import AllowAny, IsAuthenticated, IsAdminUser
from django_filters.rest_framework import DjangoFilterBackend

from .models import Category, Product, Customer, Order, OrderItem

from .serializers import (
    CategorySerializer, ProductSerializer,
    CustomerSerializer, OrderSerializer, OrderItemSerializer
)


# --- Import MỚI cho Báo cáo ---
from rest_framework.views import APIView
from django.db.models import Sum, Count, Avg, F, DecimalField, Q
from django.db.models.functions import TruncDate
from django.utils import timezone
from datetime import datetime, timedelta, date

from rest_framework.decorators import api_view # Import thêm
from rest_framework.reverse import reverse



# --- ViewSets cho Category và Product ---
class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all().order_by('name')
    serializer_class = CategorySerializer
    permission_classes = [AllowAny] # <<<--- THAY ĐỔI Ở ĐÂY (Tạm thời)

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all().order_by('-created_at')
    serializer_class = ProductSerializer
    permission_classes = [AllowAny] # <<<--- THAY ĐỔI Ở ĐÂY (Tạm thời)
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['category', 'is_featured']
    search_fields = ['name', 'description']

# --- ViewSet cho Khách hàng ---
class CustomerViewSet(viewsets.ModelViewSet):
    """
    API endpoint cho phép xem và chỉnh sửa Khách hàng.
    """
    queryset = Customer.objects.all().order_by('-date_joined')
    serializer_class = CustomerSerializer
    permission_classes = [AllowAny] # <<<--- THAY ĐỔI Ở ĐÂY (Tạm thời)
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['name', 'phone', 'email']

# --- ViewSet cho Đơn hàng ---
class OrderViewSet(viewsets.ModelViewSet):
    """
    API endpoint cho phép xem, chỉnh sửa trạng thái và các thông tin cơ bản của Đơn hàng.
    """
    queryset = Order.objects.select_related('customer').prefetch_related('items__product').all().order_by('-order_date')
    serializer_class = OrderSerializer
    permission_classes = [AllowAny] # <<<--- THAY ĐỔI Ở ĐÂY (Tạm thời)
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['status', 'customer__id', 'customer__phone']

    # --- Custom Actions để cập nhật trạng thái ---
    # Bỏ permission_classes ở đây vì ViewSet đã là AllowAny

    @action(detail=True, methods=['post'], url_path='approve')
    def approve_order(self, request, pk=None):
        """
        Action để duyệt đơn hàng (chuyển sang processing).
        """
        order = self.get_object()
        if order.status == Order.OrderStatus.PENDING:
            order.status = Order.OrderStatus.PROCESSING
            order.save()
            serializer = self.get_serializer(order)
            return Response(serializer.data)
        else:
            return Response({'error': 'Chỉ có thể duyệt đơn hàng đang chờ xử lý.'}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['post'], url_path='complete')
    def complete_order(self, request, pk=None):
        """
        Action để hoàn thành đơn hàng.
        """
        order = self.get_object()
        if order.status == Order.OrderStatus.PROCESSING:
            order.status = Order.OrderStatus.COMPLETED
            order.save()
            # --- Logic trừ kho (ví dụ) ---
            # ...
            # ----------------------------
            serializer = self.get_serializer(order)
            return Response(serializer.data)
        else:
            return Response({'error': 'Chỉ có thể hoàn thành đơn hàng đang xử lý.'}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['post'], url_path='cancel')
    def cancel_order(self, request, pk=None):
        """
        Action để hủy đơn hàng.
        """
        order = self.get_object()
        if order.status in [Order.OrderStatus.PENDING, Order.OrderStatus.PROCESSING]:
            original_status = order.status
            order.status = Order.OrderStatus.CANCELLED
            order.save()
            # --- Logic hoàn kho (ví dụ) ---
            # ...
            # ----------------------------
            serializer = self.get_serializer(order)
            return Response(serializer.data)
        else:
            return Response({'error': 'Không thể hủy đơn hàng đã hoàn thành hoặc đã hủy.'}, status=status.HTTP_400_BAD_REQUEST)

# --- ViewSet cho OrderItem (Tùy chọn) ---

class OrderItemViewSet(viewsets.ModelViewSet): # <<< Kế thừa ModelViewSet
    """
    API endpoint cho phép xem, tạo, sửa, xóa chi tiết đơn hàng.
    CẨN THẬN: Việc cho phép sửa/xóa item trực tiếp có thể ảnh hưởng logic tổng tiền, trạng thái đơn hàng.
    """
    queryset = OrderItem.objects.select_related('product', 'order').all()
    serializer_class = OrderItemSerializer
    permission_classes = [IsAuthenticated] # <<< Đặt quyền phù hợp, ví dụ: chỉ user đã đăng nhập
    # Thêm filter nếu cần
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['order', 'product']





# ==============================================
# === BẮT ĐẦU THÊM CODE CHO API BÁO CÁO ===
# ==============================================

# --- Hàm tiện ích xử lý ngày tháng (đặt ở đầu phần báo cáo) ---
def parse_date(date_string, default_date=None):
    """Chuyển đổi YYYY-MM-DD string thành date object."""
    if not date_string: return default_date
    try: return datetime.strptime(date_string, '%Y-%m-%d').date()
    except (ValueError, TypeError): return None

def get_date_range(request):
    """Lấy start_date và end_date từ query params."""
    today = timezone.localdate()
    default_start = today - timedelta(days=29) # Mặc định 30 ngày gần nhất

    start_date_str = request.query_params.get('start_date')
    end_date_str = request.query_params.get('end_date')

    start_date = parse_date(start_date_str, default_start)
    end_date = parse_date(end_date_str, today)

    if start_date is None or end_date is None:
        raise ValueError("Định dạng ngày không hợp lệ. Sử dụng YYYY-MM-DD.")
    if start_date > end_date:
        raise ValueError("Ngày bắt đầu không được lớn hơn ngày kết thúc.")

    end_date_inclusive = end_date + timedelta(days=1)
    return start_date, end_date, end_date_inclusive

# --- API Views cho Báo cáo ---

class RevenueSummaryAPIView(APIView):
    """
    API trả về thống kê doanh thu tổng quan.
    Params: ?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD
    """
    permission_classes = [AllowAny] 

    def get(self, request, *args, **kwargs):
        try:
            start_date, end_date, end_date_inclusive = get_date_range(request)
        except ValueError as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

        completed_orders = Order.objects.filter(
            status=Order.OrderStatus.COMPLETED,
            order_date__gte=start_date,
            order_date__lt=end_date_inclusive
        )

        summary = completed_orders.aggregate(
            total_revenue=Sum('total_amount', default=0, output_field=DecimalField()),
            order_count=Count('id')
        )

        total_revenue = summary.get('total_revenue') or 0
        order_count = summary.get('order_count') or 0
        average_order_value = (total_revenue / order_count) if order_count > 0 else 0

        data = {
            'startDate': start_date.isoformat(),
            'endDate': end_date.isoformat(),
            'totalRevenue': total_revenue,
            'orderCount': order_count,
            'averageOrderValue': average_order_value
        }
        return Response(data)

class RevenueOverTimeAPIView(APIView):
    """
    API trả về dữ liệu doanh thu theo ngày để vẽ biểu đồ.
    Params: ?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD
    """
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        try:
            start_date, end_date, end_date_inclusive = get_date_range(request)
        except ValueError as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

        revenue_by_date = Order.objects.filter(
            status=Order.OrderStatus.COMPLETED,
            order_date__gte=start_date,
            order_date__lt=end_date_inclusive
        ).annotate(date=TruncDate('order_date')) \
         .values('date') \
         .annotate(daily_revenue=Sum('total_amount', output_field=DecimalField())) \
         .order_by('date')

        chart_data = {'labels': [], 'data': []}
        revenue_dict = {item['date']: item['daily_revenue'] for item in revenue_by_date}

        current_date = start_date
        while current_date <= end_date:
            chart_data['labels'].append(current_date.strftime('%d/%m/%Y')) # Format label rõ hơn
            chart_data['data'].append(revenue_dict.get(current_date, 0)) # Điền 0 nếu ngày đó ko có doanh thu
            current_date += timedelta(days=1)

        return Response(chart_data)

class RevenueByCategoryAPIView(APIView):
    """
    API trả về dữ liệu doanh thu theo loại sản phẩm.
    Params: ?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD
    """
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        try:
            start_date, end_date, end_date_inclusive = get_date_range(request)
        except ValueError as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

        # Lấy tất cả items thuộc các đơn hàng hoàn thành trong khoảng thời gian
        order_items = OrderItem.objects.filter(
            order__status=Order.OrderStatus.COMPLETED,
            order__order_date__gte=start_date,
            order__order_date__lt=end_date_inclusive,
            product__category__isnull=False # Đảm bảo có category
        ).select_related('product__category') # Tối ưu query

        # Tính tổng doanh thu cho từng category name
        revenue_data_dict = {}
        for item in order_items:
            category_name = item.product.category.name
            subtotal = item.quantity * item.price
            revenue_data_dict[category_name] = revenue_data_dict.get(category_name, 0) + subtotal

        # Chuyển dict thành list để dễ sort (nếu cần) và format
        revenue_data_list = sorted(
            [{'category_name': name, 'category_revenue': revenue} for name, revenue in revenue_data_dict.items()],
            key=lambda x: x['category_revenue'],
            reverse=True # Sắp xếp giảm dần
        )

        chart_data = {
            'labels': [item['category_name'] for item in revenue_data_list],
            'data': [item['category_revenue'] for item in revenue_data_list]
        }
        return Response(chart_data)

class TopSellingProductsAPIView(APIView):
    """
    API trả về top N sản phẩm bán chạy nhất (theo số lượng).
    Params: ?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD&limit=10
    """
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        try:
            start_date, end_date, end_date_inclusive = get_date_range(request)
        except ValueError as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

        try:
            limit = int(request.query_params.get('limit', 10))
        except ValueError:
            limit = 10

        top_products = OrderItem.objects.filter(
            order__status=Order.OrderStatus.COMPLETED,
            order__order_date__gte=start_date,
            order__order_date__lt=end_date_inclusive,
            product__isnull=False
        ).values(
            'product__id',
            'product__name'
        ).annotate(
            total_sold_quantity=Sum('quantity')
        ).order_by('-total_sold_quantity')[:limit]

        return Response(list(top_products))

class InventorySummaryAPIView(APIView):
    """
    API trả về thống kê tồn kho tổng quát.
    """
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        summary = Product.objects.aggregate(
            total_stock_quantity=Sum('stock_quantity', default=0),
            total_stock_value=Sum(F('stock_quantity') * F('price'), output_field=DecimalField(), default=0)
        )
        # Lấy số lượng sản phẩm hết hàng
        out_of_stock_count = Product.objects.filter(stock_quantity__lte=0).count()

        data = {
            'totalStockQuantity': summary.get('total_stock_quantity') or 0,
            'totalStockValue': summary.get('total_stock_value') or 0,
            'outOfStockCount': out_of_stock_count
        }
        return Response(data)

class OutOfStockProductsAPIView(APIView):
    """
    API trả về danh sách sản phẩm đã hết hàng (tồn kho <= 0).
    """
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        out_of_stock = Product.objects.filter(stock_quantity__lte=0).values(
            'id', 'name', 'stock_quantity', 'category__name' # Thêm tên category
        ).order_by('category__name', 'name') # Sắp xếp

        return Response(list(out_of_stock))

# ==============================================
# === KẾT THÚC CODE CHO API BÁO CÁO ===
# ==============================================

@api_view(['GET'])
def api_root(request, format=None):
    """
    API Root tùy chỉnh hiển thị tất cả các endpoint chính.
    """
    # Lấy URL cho các list view từ router (ví dụ)
    # Tên 'category-list', 'product-list'... được DefaultRouter tự tạo ra
    # Bạn có thể xem các tên này bằng cách chạy `python manage.py show_urls`
    view_data = {
        'categories': reverse('category-list', request=request, format=format),
        'products': reverse('product-list', request=request, format=format),
        'customers': reverse('customer-list', request=request, format=format),
        'orders': reverse('order-list', request=request, format=format),
        # 'order-items': reverse('orderitem-list', request=request, format=format), # Nếu có đăng ký OrderItemViewSet
    }

    # Thêm URL cho các API báo cáo (sử dụng name đã đặt ở urls.py)
    report_data = {
        'report-summary': reverse('report-summary', request=request, format=format),
        'report-revenue-over-time': reverse('report-revenue-over-time', request=request, format=format),
        'report-revenue-by-category': reverse('report-revenue-by-category', request=request, format=format),
        'report-top-products': reverse('report-top-products', request=request, format=format),
        'report-inventory-summary': reverse('report-inventory-summary', request=request, format=format),
        'report-out-of-stock': reverse('report-out-of-stock', request=request, format=format),
    }

    # Kết hợp cả hai
    # Có thể nhóm lại nếu muốn: return Response({'core_api': view_data, 'reports': report_data})
    return Response({**view_data, **report_data}) # Gộp chung vào một dict lớn