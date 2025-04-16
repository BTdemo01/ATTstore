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

## ✅ 1. Clone Project từ GitHub
```bash
git clone <https://github.com/BTdemo01/ATTstore.git>
cd <ATTstore>
```


# Database:

## ✅ 1. Clone Project từ GitHub 



# BACKEND:

## ✅ 1. Mở project bằng VS Code
```bash
code .
```

---

## ✅ 2. Di chuyển đến virtual environment có sẵn trên project (môi trường ảo)

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

## ✅ 3. Kết nối database
vào file 
```bash
python manage.py migrate
```

---

## ✅ 4. Chạy migrations để tạo database
```bash
python manage.py migrate
```

---

## ✅ 5. (Optional) Tạo superuser để vào admin
```bash
python manage.py createsuperuser
```
=> thêm tài khoản admin của bạn
---

## ✅ 6. Chạy server Django

Backend:

```bash
python manage.py runserver
```
- Truy cập: [http://127.0.0.1:8000/api](http://127.0.0.1:8000/api)  để vào trang REST API
- Truy cập: [127.0.0.1:8000/api/schema/swagger-ui/#/](127.0.0.1:8000/api/schema/swagger-ui/#/)  để vào trang kiểm tra api chạy đúng hay chưa


# FRONTEND: 

## 1. 🧰 Chuẩn bị trước

### ✅ Cài Node.js (nếu chưa có)

- Truy cập trang: https://nodejs.org
- Tải và cài bản có chữ **LTS (Long Term Support)**
- Sau khi cài, kiểm tra bằng cách mở Terminal hoặc CMD và gõ:

```bash
node -v
npm -v
```

## 2.Tải thư viện cần thiết
- trong thư mục project chạy lệnh để cài đặt thư viện cần thiết

```bash
npm install
```

## 3.Chạy project
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

