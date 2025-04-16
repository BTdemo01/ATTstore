# BT-PM-MNM
Bài báo cáo môn Phát triển phần mềm mã nguồn mở:
https://drive.google.com/drive/folders/1-6vacjbMUGUZbmOkao6G3ZvlXN2nBg78?usp=sharing

TẢI VÀ CÀI ĐẶT PROJECT
**Cài đặt ứng dụng**
visual studio code (visual xanh), PostgreSQL, Postman (dùng để test api => nếu không cần thì không tải), Node.js , Anaconda

**Cài đặt môi trường Anaconda**
```bash

```

---

---

# 📖 Hướng Dẫn Chạy Project Django Trên VS Code:

## Bước 1: Clone Project từ GitHub
```bash
git clone <https://github.com/BTdemo01/ATTstore.git>

```


## Bước 2: Tạo Database:

### ✅ 1. Tạo database mới trong PostgreSQL 
```bash

```


## Bước 3: Chạy BACKEND:

### ✅ 1. Mở project bằng VS Code


---

### ✅ 2. Di chuyển đến virtual environment có sẵn trên project (môi trường ảo)

Kích hoạt môi trường ảo:
- **Windows:**
```bash
.\venv\Scripts\activate
```
- **Mac/Linux:**
```bash
source venv/bin/activate
```


---

### ✅ 3. Kết nối project với database
- Vào file:  be/att_store_backend/settings.py
- Kiểm tra và sửa đoạn code sau:
  
```bash

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'att_db',             # Tên DB bạn tạo ở Bước 2
        'USER': 'postgres',           # đổi thành User postgres của bạn 
        'PASSWORD': '123456',         # Mật khẩu postgres của bạn 
        'HOST': 'localhost',          # Hoặc '127.0.0.1'. Nếu DB ở máy khác, điền IP/hostname
        'PORT': '5432',               # Port postgres của bạn 
    }
}

```

---

### ✅ 4. Chạy migrations để tạo database 
```bash
python manage.py migrate
```


### ✅ 5. Thêm dữ liệu cho database
- Vào phần mềm pgAdmin 4 
- Kết nối db đã tạo ở bước 2
- Mở file data_att.sql trong file ATTstore đã Clone về trước đó
- Chạy file data_att.sql trong db đã tạo ở bước 2 để thêm dữ liệu


---

### ✅ 6. Tạo superuser để vào admin

```bash
python manage.py createsuperuser
```
- thêm tài khoản admin của bạn


---

### ✅ 7. Chạy server Django


```bash
python manage.py runserver
```

- Truy cập: [http://127.0.0.1:8000/api](http://127.0.0.1:8000/api)  để vào trang REST API
- Truy cập: [http:127.0.0.1:8000/api/schema/swagger-ui/#/](http:127.0.0.1:8000/api/schema/swagger-ui/#/)  để vào trang kiểm tra api chạy đúng hay chưa


## Bước 4: Chạy FRONTEND

### 1. 🧰 Chuẩn bị trước

#### ✅ Cài Node.js (nếu chưa có)

- Truy cập trang: https://nodejs.org
- Tải và cài bản có chữ **LTS (Long Term Support)**
- Sau khi cài, kiểm tra bằng cách mở Terminal hoặc CMD và gõ:

```bash
node -v
npm -v
```

### 2.Tải thư viện cần thiết
- trong thư mục project chạy lệnh để cài đặt thư viện cần thiết

```bash
npm install
```

### 3.Chạy project
🔹 Nếu project dùng Vite (thường có file vite.config.js):
- chạy lệnh

```bash
npm run dev
```

Sau đó bạn sẽ thấy dòng như:
```bash
App running at:
  > Local:   http://localhost:5173/
```

Mở trình duyệt và dán link đó vào để xem project!

🔹 Nếu project dùng Vue CLI (thường có vue.config.js):

- chạy lệnh

```bash
npm run serve
```

Sau đó bạn sẽ thấy dòng như:

```bash
App running at:
  - Local:   http://localhost:8080/
```

Mở trình duyệt và dán link đó vào!

