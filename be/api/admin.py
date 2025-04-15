# api/admin.py
from django.contrib import admin
# Import các model cũ và mới
from .models import Category, Product, Customer, Order, OrderItem

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name', 'description', 'created_at')
    search_fields = ('name',)

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'price', 'stock_quantity', 'is_featured', 'created_at')
    list_filter = ('category', 'is_featured', 'created_at')
    search_fields = ('name', 'description')
    autocomplete_fields = ('category',)
    list_editable = ('price', 'stock_quantity', 'is_featured')

# --- Đăng ký Admin cho các Model MỚI ---

@admin.register(Customer)
class CustomerAdmin(admin.ModelAdmin):
    list_display = ('customer_code', 'name', 'phone', 'email', 'date_joined')
    search_fields = ('customer_code', 'name', 'phone', 'email', 'address')
    list_filter = ('date_joined',)
    readonly_fields = ('customer_code', 'date_joined', 'updated_at')

# Inline admin cho OrderItem để hiển thị trong OrderAdmin
class OrderItemInline(admin.TabularInline): # Hoặc StackedInline
    model = OrderItem
    fields = ('product', 'quantity', 'price', 'get_subtotal') # Hiển thị các trường này
    readonly_fields = ('price', 'get_subtotal') # Giá và thành tiền chỉ đọc ở đây
    extra = 0 # Không hiển thị dòng trống để thêm mới mặc định
    autocomplete_fields = ['product'] # Giúp chọn sản phẩm dễ hơn

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ('order_code', 'customer', 'order_date', 'status', 'total_amount', 'shipping_address')
    list_filter = ('status', 'order_date', 'customer')
    search_fields = ('order_code', 'customer__name', 'customer__customer_code', 'shipping_address')
    readonly_fields = ('order_code', 'order_date', 'total_amount', 'updated_at')
    inlines = [OrderItemInline] # Nhúng OrderItem admin vào đây
    list_per_page = 20 # Số lượng order hiển thị trên mỗi trang admin

@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    # Thường không cần quản lý OrderItem trực tiếp ở đây nếu đã dùng inline
    # Nhưng đăng ký để có thể xem nếu cần
    list_display = ('order', 'product', 'quantity', 'price', 'get_subtotal')
    list_filter = ('order__order_date', 'product__category')
    search_fields = ('order__order_code', 'product__name')
    readonly_fields = ('price', 'get_subtotal')
    autocomplete_fields = ['order', 'product']