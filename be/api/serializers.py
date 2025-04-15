# api/serializers.py
from rest_framework import serializers
from .models import Category, Product, Customer, Order, OrderItem # Thêm Customer, Order, OrderItem

# --- Serializers cho Category và Product đã có từ trước ---
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name', 'description', 'image_url', 'created_at', 'updated_at']

class ProductSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = Product
        fields = [
            'id', 'name', 'description', 'price', 'stock_quantity', 'image_url',
            'category', # ID để ghi
            'category_name', # Tên để đọc
            'created_at', 'updated_at'
        ]

# --- Serializer MỚI cho Khách hàng ---
class CustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customer
        fields = ['id', 'customer_code', 'name', 'phone', 'email', 'address', 'date_joined', 'updated_at']
        read_only_fields = ('customer_code', 'date_joined', 'updated_at') # Mã KH tự tạo, ngày tham gia ko đổi

# --- Serializer MỚI cho Chi tiết đơn hàng ---
# Serializer đơn giản cho Product để hiển thị trong OrderItem
class ProductSimpleSerializer(serializers.ModelSerializer):
     class Meta:
        model = Product
        fields = ['id', 'name', 'price', 'image_url'] # Chỉ lấy các trường cần thiết

class OrderItemSerializer(serializers.ModelSerializer):
    # product = ProductSimpleSerializer(read_only=True) # Hiển thị thông tin chi tiết product khi đọc
    product_id = serializers.PrimaryKeyRelatedField(queryset=Product.objects.all(), source='product', write_only=True) # Để tạo/update item bằng product ID
    product_name = serializers.CharField(source='product.name', read_only=True) # Thêm tên SP chỉ đọc
    product_image = serializers.URLField(source='product.image_url', read_only=True) # Thêm ảnh SP chỉ đọc
    subtotal = serializers.DecimalField(source='get_subtotal', max_digits=12, decimal_places=0, read_only=True) # Hiển thị thành tiền

    class Meta:
        model = OrderItem
        fields = ['id', 'product_id', 'product_name', 'product_image', 'quantity', 'price', 'subtotal']
        read_only_fields = ('price', 'subtotal') # Giá được lấy tự động hoặc đặt khi tạo Order

# --- Serializer MỚI cho Đơn hàng ---
class OrderSerializer(serializers.ModelSerializer):
    # Hiển thị thông tin chi tiết của khách hàng khi đọc Order
    # customer = CustomerSerializer(read_only=True)
    # Hoặc chỉ hiển thị tên và mã KH
    customer_name = serializers.CharField(source='customer.name', read_only=True, allow_null=True)
    customer_code = serializers.CharField(source='customer.customer_code', read_only=True, allow_null=True)

    items_payload = serializers.ListField(
       child=serializers.DictField(), write_only=True, required=False
    )

    # Hiển thị danh sách các item trong đơn hàng khi đọc Order
    items = OrderItemSerializer(many=True, read_only=True)

    # Cho phép tạo Order bằng cách truyền customer ID
    customer_id = serializers.PrimaryKeyRelatedField(
        queryset=Customer.objects.all(), source='customer', write_only=True, allow_null=True, required=False
    )
    # Format lại status để dễ đọc hơn
    status_display = serializers.CharField(source='get_status_display', read_only=True)


    class Meta:
        model = Order
        fields = [
            'id', 'order_code',
            'customer_id', # Dùng để tạo/update
            'customer_code', 'customer_name', # Chỉ để đọc
            'order_date', 'total_amount', 'status', 'status_display',
            'shipping_address', 'items', 'updated_at',
            'items_payload'
        ]
        read_only_fields = ('order_code', 'order_date', 'total_amount', 'items', 'updated_at', 'status_display')
        # total_amount sẽ được tính toán ở View hoặc logic khác
        # items được quản lý riêng hoặc trong logic tạo Order phức tạp hơn

    # (Nâng cao) Nếu muốn tạo Order và OrderItems cùng lúc, cần override .create()
    def create(self, validated_data):
        # Lấy dữ liệu items (cần gửi từ client theo cấu trúc đặc biệt)
        items_data = validated_data.pop('items_payload', []) # Ví dụ: items_payload=[{'product_id': 1, 'quantity': 2}, ...]
        order = Order.objects.create(**validated_data)
        total = 0
        for item_data in items_data:
            product = Product.objects.get(id=item_data['product_id'])
            
            # Kiểm tra tồn kho nếu cần
            if product.stock_quantity < item_data['quantity']:
                raise serializers.ValidationError(f"Sản phẩm {product.name} không đủ tồn kho.")


            order_item = OrderItem.objects.create(
                order=order,
                product=product,
                quantity=item_data['quantity'],
                price=product.price # Lấy giá hiện tại
            )
            total += order_item.get_subtotal()
            # Có thể thêm logic giảm stock ở đây
            product.stock_quantity -= item_data['quantity']
            product.save()

        # except Product.DoesNotExist:
        #     # Xử lý nếu product_id không tồn tại
        #     # Có thể bỏ qua item này hoặc báo lỗi tùy logic
        #     print(f"Warning: Product with id {item_data.get('product_id')} not found.")
        #     continue # Bỏ qua item lỗi và tiếp tục
        # except KeyError:
        #     print(f"Warning: Invalid item data format: {item_data}")
        #     continue # Bỏ qua item lỗi


        order.total_amount = total
        order.save()
        return order