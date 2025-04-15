# api/models.py
from django.db import models
from django.utils.translation import gettext_lazy as _ # Cho các lựa chọn status
import uuid # Để tạo mã đơn hàng/khách hàng ngẫu nhiên

# --- Thêm các import cần thiết nếu chưa có ---
# from django.conf import settings # Nếu liên kết Customer với User model của Django


# --- Model Category và Product đã có từ trước ---
class Category(models.Model):
    name = models.CharField(max_length=100, unique=True, verbose_name="Tên loại hàng")
    description = models.TextField(blank=True, null=True, verbose_name="Mô tả")
    # Giả sử đã thêm image_url từ bước trước
    image_url = models.URLField(max_length=1024, blank=True, null=True, verbose_name="Link ảnh đại diện")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "Loại hàng"
        verbose_name_plural = "Các loại hàng"
        ordering = ['name']

class Product(models.Model):
    category = models.ForeignKey(Category, related_name='products', on_delete=models.CASCADE, verbose_name="Loại hàng")
    name = models.CharField(max_length=200, verbose_name="Tên hàng hóa")
    description = models.TextField(blank=True, null=True, verbose_name="Mô tả")
    price = models.DecimalField(max_digits=10, decimal_places=0, default=0, verbose_name="Giá") # Sửa lại decimal_places nếu cần
    stock_quantity = models.PositiveIntegerField(default=0, verbose_name="Số lượng tồn kho")
    # Giả sử thêm image_url
    image_url = models.URLField(max_length=1024, blank=True, null=True, verbose_name="Link ảnh sản phẩm")
    is_featured = models.BooleanField(default=False, db_index=True, verbose_name="Sản phẩm nổi bật")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "Hàng hóa"
        verbose_name_plural = "Các hàng hóa"
        ordering = ['-created_at']

# --- Model MỚI cho Khách hàng ---
class Customer(models.Model):
    # user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, verbose_name="Tài khoản User") # Tùy chọn: Liên kết với User mặc định của Django
    customer_code = models.CharField(max_length=20, unique=True, blank=True, verbose_name="Mã khách hàng") # Có thể tự tạo hoặc để trống
    name = models.CharField(max_length=150, verbose_name="Tên khách hàng")
    phone = models.CharField(max_length=15, blank=True, null=True, unique=True, verbose_name="Số điện thoại") # SĐT nên là duy nhất
    email = models.EmailField(max_length=100, blank=True, null=True, unique=True, verbose_name="Email") # Email nên là duy nhất
    address = models.TextField(blank=True, null=True, verbose_name="Địa chỉ")
    date_joined = models.DateTimeField(auto_now_add=True, verbose_name="Ngày tham gia")
    updated_at = models.DateTimeField(auto_now=True)

    def save(self, *args, **kwargs):
        # Tự động tạo customer_code nếu chưa có
        if not self.customer_code:
            # Tạo mã dạng KHxxxx (x là số) - ví dụ đơn giản
            last_customer = Customer.objects.all().order_by('id').last()
            next_id = (last_customer.id + 1) if last_customer else 1
            self.customer_code = f'KH{next_id:04d}' # Ví dụ: KH0001
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.name} ({self.customer_code})"

    class Meta:
        verbose_name = "Khách hàng"
        verbose_name_plural = "Các khách hàng"
        ordering = ['-date_joined']

# --- Model MỚI cho Đơn hàng ---
class Order(models.Model):
    class OrderStatus(models.TextChoices):
        PENDING = 'pending', _('Chờ xử lý')
        PROCESSING = 'processing', _('Đang xử lý')
        COMPLETED = 'completed', _('Hoàn thành')
        CANCELLED = 'cancelled', _('Đã hủy')

    order_code = models.CharField(max_length=20, unique=True, blank=True, verbose_name="Mã đơn hàng")
    customer = models.ForeignKey(Customer, on_delete=models.SET_NULL, null=True, blank=True, related_name='orders', verbose_name="Khách hàng") # Nếu khách bị xóa, đơn hàng vẫn giữ nhưng ko biết của ai
    order_date = models.DateTimeField(auto_now_add=True, verbose_name="Ngày đặt hàng")
    total_amount = models.DecimalField(max_digits=12, decimal_places=0, default=0, verbose_name="Tổng tiền") # Sửa decimal_places nếu cần
    status = models.CharField(
        max_length=20,
        choices=OrderStatus.choices,
        default=OrderStatus.PENDING,
        verbose_name="Trạng thái"
    )
    shipping_address = models.TextField(verbose_name="Địa chỉ giao hàng")
    # Thêm các trường khác nếu cần: ghi chú, phương thức thanh toán...
    updated_at = models.DateTimeField(auto_now=True)

    def save(self, *args, **kwargs):
        # Tự động tạo order_code nếu chưa có
        if not self.order_code:
             # Tạo mã dạng UUID hex cho đơn giản và duy nhất
            self.order_code = uuid.uuid4().hex[:10].upper() # Ví dụ: 5D4A6F8B3C
        super().save(*args, **kwargs)

    def __str__(self):
        return f"Đơn hàng {self.order_code} - {self.customer}"

    class Meta:
        verbose_name = "Đơn hàng"
        verbose_name_plural = "Các đơn hàng"
        ordering = ['-order_date']

# --- Model MỚI cho Chi tiết Đơn hàng ---
class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items', verbose_name="Đơn hàng") # Nếu xóa Order thì xóa luôn Item
    product = models.ForeignKey(Product, on_delete=models.SET_NULL, null=True, verbose_name="Sản phẩm") # Giữ lại item nếu sản phẩm bị xóa (để xem lịch sử)
    quantity = models.PositiveIntegerField(default=1, verbose_name="Số lượng")
    price = models.DecimalField(max_digits=10, decimal_places=0, verbose_name="Đơn giá tại thời điểm đặt") # Lưu lại giá lúc mua

    def __str__(self):
        return f"{self.quantity} x {self.product.name} (Đơn: {self.order.order_code})"

    def get_subtotal(self):
        return self.quantity * self.price

    def save(self, *args, **kwargs):
        # Tự động lấy giá sản phẩm tại thời điểm thêm vào đơn hàng nếu chưa có
        # Hoặc có thể lấy trong logic tạo đơn hàng ở view/serializer
        if not self.pk and self.product and self.price == 0: # Chỉ đặt giá khi tạo mới và giá đang là 0
             self.price = self.product.price
        super().save(*args, **kwargs)


    class Meta:
        verbose_name = "Chi tiết đơn hàng"
        verbose_name_plural = "Các chi tiết đơn hàng"
        unique_together = ('order', 'product') # Mỗi sản phẩm chỉ xuất hiện 1 lần trong 1 đơn hàng