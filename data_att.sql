--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: api_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.api_category (id, name, description, created_at, updated_at, image_url) VALUES (2, 'Nước không cồn', 'Nước ngọt, nước suối, nước ion, ...', '2025-04-13 08:40:10.536698+07', '2025-04-13 08:40:10.536698+07', 'https://down-vn.img.susercontent.com/file/1b70168e259105cfa8eba3631be8f2b4');
INSERT INTO public.api_category (id, name, description, created_at, updated_at, image_url) VALUES (3, 'Nước có cồn', 'Bia, rượu, ...', '2025-04-13 08:42:03.708715+07', '2025-04-13 08:45:42.319191+07', 'https://palada.vn/wp-content/uploads/2023/05/Strongbow.jpg');
INSERT INTO public.api_category (id, name, description, created_at, updated_at, image_url) VALUES (4, 'Kẹo', 'Socola, kẹo dẻo, kẹo cứng, ...', '2025-04-13 08:47:08.508805+07', '2025-04-13 08:47:08.508805+07', 'https://nghebep.com/wp-content/uploads/2017/12/keo-marshmallow.jpg');
INSERT INTO public.api_category (id, name, description, created_at, updated_at, image_url) VALUES (6, 'Dụng cụ học tập', 'Sách, vở, bút, thước, ...', '2025-04-13 08:51:48.906953+07', '2025-04-13 08:51:48.906953+07', 'https://ds393qgzrxwzn.cloudfront.net/cat1/img/images/0/C6ERg3PxYx.jpg');
INSERT INTO public.api_category (id, name, description, created_at, updated_at, image_url) VALUES (5, 'Trà gói', 'Trà gói', '2025-04-13 08:50:06.864138+07', '2025-04-13 08:52:19.853633+07', 'https://file.hstatic.net/1000075078/file/2_0a01cf6a51f44ef18b0fd9a175381e89_grande.jpg');
INSERT INTO public.api_category (id, name, description, created_at, updated_at, image_url) VALUES (7, 'Oishi', 'snack nhìu vị nè', '2025-04-13 11:41:15.131322+07', '2025-04-13 11:41:15.131322+07', 'https://th.bing.com/th/id/R.8b7f24815d0998d4481758888195932c?rik=Xle5yyJ5YZewWg&pid=ImgRaw&r=0');
INSERT INTO public.api_category (id, name, description, created_at, updated_at, image_url) VALUES (8, 'Đồ ăn liền', 'đồ ăn liền', '2025-04-13 11:43:48.550091+07', '2025-04-13 11:43:48.550091+07', 'https://th.bing.com/th/id/OIP.1wZlnqh-0ggtMPcD1UHqRgHaHa?rs=1&pid=ImgDetMain');
INSERT INTO public.api_category (id, name, description, created_at, updated_at, image_url) VALUES (1, 'Bánh', 'bánh siu đẹp, siu ngon', '2025-04-13 08:08:48.98555+07', '2025-04-15 08:40:38.771947+07', 'https://www.hoidaubepaau.com/wp-content/uploads/2015/12/hinh-anh-banh-donut.jpg');


--
-- Data for Name: api_customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.api_customer (id, customer_code, name, phone, email, address, date_joined, updated_at) VALUES (1, 'KH0001', 'Nguyễn Văn A', '0901234567', 'a.nguyen@gmail.com', '123 Đường Trần Hưng Đạo, Quận 1, TP.HCM', '2025-04-13 11:36:03.546026+07', '2025-04-13 11:36:03.546026+07');
INSERT INTO public.api_customer (id, customer_code, name, phone, email, address, date_joined, updated_at) VALUES (2, 'KH0002', 'Trần Thị B', '0912345678', 'b.tran@email.com', '456 Đường Điện Biên Phủ, Quận 3, TP.HCM', '2025-04-13 11:36:53.142252+07', '2025-04-13 11:36:53.142252+07');
INSERT INTO public.api_customer (id, customer_code, name, phone, email, address, date_joined, updated_at) VALUES (3, 'KH0003', 'Lê Văn C', '0987654321', 'c.le@email.com', '789 Đường Lý Thường Kiệt, Quận 10, TP.HCM', '2025-04-13 11:37:32.063321+07', '2025-04-13 11:37:32.063321+07');
INSERT INTO public.api_customer (id, customer_code, name, phone, email, address, date_joined, updated_at) VALUES (4, 'KH0004', 'Phạm Thị D', '0934567890', 'd.pham@email.com', '111 Đường Cộng Hòa, Quận Tân Bình, TP.HCM', '2025-04-13 11:38:15.636768+07', '2025-04-13 11:38:15.636768+07');
INSERT INTO public.api_customer (id, customer_code, name, phone, email, address, date_joined, updated_at) VALUES (5, 'KH0005', 'Hoàng Văn E', '0908950001', 'e.hoang@email.com', '222 Đường Nguyễn Tri Phương, Quận 5, TP.HCM', '2025-04-13 11:39:13.801742+07', '2025-04-13 11:39:21.762264+07');
INSERT INTO public.api_customer (id, customer_code, name, phone, email, address, date_joined, updated_at) VALUES (7, 'KH0006', 'Đinh Hoàng F', '0952846936', 'f.dinh@email.com', '234 Lê Văn Sỹ, Quận Tân Bình', '2025-04-13 12:45:31.60692+07', '2025-04-13 12:51:32.81059+07');


--
-- Data for Name: api_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.api_order (id, order_code, order_date, total_amount, status, shipping_address, updated_at, customer_id) VALUES (8, '8A0EC9842D', '2025-04-14 00:46:35.848885+07', 219000, 'pending', '456 Đường Điện Biên Phủ, Quận 3, TP.HCM', '2025-04-14 00:46:35.855901+07', 2);
INSERT INTO public.api_order (id, order_code, order_date, total_amount, status, shipping_address, updated_at, customer_id) VALUES (6, '31524A701F', '2025-04-14 00:46:03.860233+07', 75000, 'processing', '789 Đường Lý Thường Kiệt, Quận 10, TP.HCM', '2025-04-14 00:47:39.2674+07', 3);
INSERT INTO public.api_order (id, order_code, order_date, total_amount, status, shipping_address, updated_at, customer_id) VALUES (5, 'A7DBC47B61', '2025-04-14 00:18:05.200102+07', 27000, 'completed', '111 Đường Cộng Hòa, Quận Tân Bình, TP.HCM', '2025-04-14 00:47:45.060045+07', 4);
INSERT INTO public.api_order (id, order_code, order_date, total_amount, status, shipping_address, updated_at, customer_id) VALUES (7, '36B5BAA391', '2025-04-14 00:46:20.460897+07', 14000, 'cancelled', '789 Đường Lý Thường Kiệt, Quận 10, TP.HCM', '2025-04-14 00:47:50.022102+07', 3);
INSERT INTO public.api_order (id, order_code, order_date, total_amount, status, shipping_address, updated_at, customer_id) VALUES (9, '6B182B2B43', '2025-04-14 00:47:16.763882+07', 31000, 'processing', '123 Đường Trần Hưng Đạo, Quận 1, TP.HCM', '2025-04-14 00:47:56.652896+07', 1);
INSERT INTO public.api_order (id, order_code, order_date, total_amount, status, shipping_address, updated_at, customer_id) VALUES (10, '49356A7768', '2025-04-14 00:52:39.74375+07', 0, 'cancelled', '234 Lê Văn Sỹ, Quận Tân Bình', '2025-04-14 00:52:48.029446+07', 7);
INSERT INTO public.api_order (id, order_code, order_date, total_amount, status, shipping_address, updated_at, customer_id) VALUES (12, '0A76B092A4', '2025-04-14 08:34:36.485395+07', 824000, 'completed', '123 Đường Trần Hưng Đạo, Quận 1, TP.HCM', '2025-04-14 08:35:05.941681+07', 1);
INSERT INTO public.api_order (id, order_code, order_date, total_amount, status, shipping_address, updated_at, customer_id) VALUES (11, 'DA1E5D687A', '2025-04-14 08:33:38.483537+07', 236900, 'completed', '222 Đường Nguyễn Tri Phương, Quận 5, TP.HCM', '2025-04-14 08:35:09.46381+07', 5);
INSERT INTO public.api_order (id, order_code, order_date, total_amount, status, shipping_address, updated_at, customer_id) VALUES (13, '6A3B5C0E1C', '2025-04-14 13:33:08.830789+07', 62900, 'pending', '456 Đường Điện Biên Phủ, Quận 3, TP.HCM', '2025-04-14 13:33:08.860354+07', 2);
INSERT INTO public.api_order (id, order_code, order_date, total_amount, status, shipping_address, updated_at, customer_id) VALUES (14, '558C3ED32C', '2025-04-15 08:21:00.535707+07', 27000, 'completed', '789 Đường Lý Thường Kiệt, Quận 10, TP.HCM', '2025-04-15 08:21:38.907702+07', 4);


--
-- Data for Name: api_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (8, 'Snack Bí Đỏ', '', 5000, 70, '2025-04-13 21:46:43.217215+07', '2025-04-13 21:46:43.217215+07', 7, 'https://cf.shopee.vn/file/87fa959230451df3419e7bacb52ffac6', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (12, 'Snack Bắp Ngọt', '', 5000, 60, '2025-04-13 21:55:13.272414+07', '2025-04-13 21:55:13.272414+07', 7, 'https://toplist.vn/images/800px/snack-oishi-533581.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (13, 'Crab Me!', '', 5000, 88, '2025-04-13 21:56:56.057228+07', '2025-04-13 21:56:56.057228+07', 7, 'https://cf.shopee.vn/file/966151a9dd31ca4c1d49c2fe13885372', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (14, 'PINATTSU', 'Snack nhân đậu phộng', 12, 20, '2025-04-13 21:57:54.150252+07', '2025-04-13 21:57:54.150252+07', 7, 'https://cooponline.vn/wp-content/uploads/2022/11/Snack-dau-phong-muc-OISHI-85g-20221111.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (15, '4X', 'Sốt Sriacha Vị cay', 6000, 99, '2025-04-13 21:59:23.302791+07', '2025-04-13 21:59:23.302791+07', 7, 'https://oishi.cdn.vccloud.vn/storage/products/September2023/O1NXIbzJiBIR6GIbtrIa.png', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (16, 'C' 'est BON!', 'C''EST BON SỢI THỊT GÀ', 35000, 50, '2025-04-13 22:01:25.280251+07', '2025-04-13 22:01:25.280251+07', 1, 'https://cooponline.vn/wp-content/uploads/2022/08/banh-orion-cest-bon-soi-thit-ga-km.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (17, 'Gouté', '', 30000, 10, '2025-04-13 22:02:58.659113+07', '2025-04-13 22:02:58.659113+07', 1, 'https://product.hstatic.net/200000073345/product/banh_orion_goute_hop_144g_e95d1ea5401c4c44b5e3a54ae5140876_1024x1024.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (19, 'Mì trộn hải sản Hàn Quốc Miliket tô 105g', '', 17400, 52, '2025-04-13 22:05:55.839217+07', '2025-04-13 22:05:55.839217+07', 8, 'https://cdn.tgdd.vn/Products/Images/2565/195176/bhx/mi-tron-hai-san-han-quoc-miliket-to-105g-202202241140572192.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (20, 'Mì xào khô Indomie Mi Goreng vị đặc biệt gói 85g', '', 6000, 100, '2025-04-13 22:06:39.696107+07', '2025-04-13 22:06:39.696107+07', 8, 'https://cdn.tgdd.vn/Products/Images/2565/106457/bhx/mi-xao-kho-indomie-mi-goreng-goi-85g-201912111531110055.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (21, 'Mì Gấu Đỏ bò bít tết gói 63g', '', 3500, 399, '2025-04-13 22:07:21.742264+07', '2025-04-13 22:07:21.742264+07', 8, 'https://cdn.tgdd.vn/Products/Images/2565/77659/bhx/mi-gau-do-bo-bit-tet-goi-63g-202407121409180471.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (22, 'Thước Kẻ 20 cm - Deli 6220', '', 7000, 5, '2025-04-13 22:08:29.59703+07', '2025-04-13 22:08:29.59703+07', 6, 'https://cdn1.fahasa.com/media/catalog/product/6/9/6921734962201.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (23, 'Bóp Viết Vải - Yescholar 7972 - Màu Đen', '', 125000, 10, '2025-04-13 22:09:06.270196+07', '2025-04-13 22:09:06.270196+07', 6, 'https://cdn1.fahasa.com/media/catalog/product/3/9/3900000301930.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (24, 'Chuốt Bút Chì Masterart Cỡ 7 - Màu Đen', '', 8000, 0, '2025-04-13 22:10:26.274398+07', '2025-04-13 22:10:26.274398+07', 6, 'https://cdn1.fahasa.com/media/catalog/product/8/8/8851907134099-den.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (25, 'Gôm Dust Free - Faber-Castell 187120', '', 15500, 45, '2025-04-13 22:10:58.964884+07', '2025-04-13 22:10:58.964884+07', 6, 'https://cdn1.fahasa.com/media/catalog/product/9/5/9556089871204-_1_.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (28, 'Kẹo hương xoài nhân muối ớt Alpenliebe gói 87g', '', 15400, 11, '2025-04-13 22:15:49.915897+07', '2025-04-13 22:15:49.915897+07', 4, 'https://cdn.tgdd.vn/Products/Images/2687/231014/bhx/keo-huong-xoai-nhan-muoi-ot-alpenliebe-goi-87g-202011231000137354.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (29, 'Kẹo cà phê Coffeeshot Classic KOPIKO gói 135g', '', 13900, 0, '2025-04-13 22:16:17.304336+07', '2025-04-13 22:16:17.304336+07', 4, 'https://cdn.tgdd.vn/Products/Images/2687/77808/bhx/keo-ca-phe-coffeeshot-classic-kopiko-goi-135g-202209281426158879.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (30, 'Kẹo ngậm không đường hương bạc hà Anytime gói 60g', '', 30500, 0, '2025-04-13 22:16:42.354033+07', '2025-04-13 22:16:42.354033+07', 4, 'https://cdn.tgdd.vn/Products/Images/2687/79575/bhx/keo-anytime-xyliton-huong-bac-ha-60g-201901240939311195.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (31, 'Thùng 24 lon bia Sài Gòn Special Sleek 330ml', '', 345000, 2, '2025-04-13 22:18:07.898018+07', '2025-04-13 22:18:07.898018+07', 3, 'https://cdnv2.tgdd.vn/bhx-static/bhx/Products/Images/2282/276230/bhx/276230_202411232150043205.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (26, 'Bút sáp màu Jumbo CR-C035 18 màu', '', 50000, 21, '2025-04-13 22:12:14.82715+07', '2025-04-14 08:34:36.515402+07', 6, 'https://cdn1.fahasa.com/media/catalog/product/8/9/8935001824466.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (27, 'Kẹo sữa caramen Alpenliebe gói 115.5g', '', 14000, 9, '2025-04-13 22:14:23.936077+07', '2025-04-14 00:46:20.469549+07', 4, 'https://cdn.tgdd.vn/Products/Images/2687/80038/bhx/keo-sua-caramen-alpenliebe-goi-1155g-202304050953174731.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (33, 'Thùng 20 lon bia Tiger Soju Wonder Melon vị dưa lưới 330ml', '', 405000, 0, '2025-04-13 22:19:17.752393+07', '2025-04-14 08:34:36.496399+07', 3, 'https://cdnv2.tgdd.vn/bhx-static/bhx/Products/Images/2282/305079/bhx/305079_202411232223451021.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (7, 'Snack Tôm Cay Đặc Biệt', '', 5000, 79, '2025-04-13 21:45:40.876269+07', '2025-04-14 00:47:16.7771+07', 7, 'https://th.bing.com/th/id/OIP.UaSYDIKR_9X5lPrsIdWqhQHaHa?rs=1&pid=ImgDetMain', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (10, 'Snack Pho Mát Miếng', '', 5000, 4, '2025-04-13 21:53:47.114422+07', '2025-04-14 00:47:16.78489+07', 7, 'https://sieuthiminitunjp.com/wp-content/uploads/2023/11/Bim-bim-Oishi-snack-pho-m%C3%A1t-mi%E1%BA%BFng.jpeg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (35, 'Nước ngọt Fanta hương soda kem trái cây 1.5 lít', '', 21000, 9, '2025-04-13 22:21:05.376115+07', '2025-04-14 00:47:16.791684+07', 2, 'https://cdn.tgdd.vn/Products/Images/2443/215576/bhx/-202403281416258157.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (6, 'Snack Tôm Cay', '', 5000, 99, '2025-04-13 21:44:42.028378+07', '2025-04-14 08:33:38.542248+07', 7, 'https://th.bing.com/th/id/OIP.w5ShwRY_AKL-D_UUf-EN8gHaHa?rs=1&pid=ImgDetMain', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (34, 'Thùng 24 lon Bia Red Ruby 330ml', '', 219000, 1, '2025-04-13 22:19:57.171935+07', '2025-04-14 08:33:38.554248+07', 3, 'https://cdnv2.tgdd.vn/bhx-static/bhx/Products/Images/2282/266318/bhx/266318_202411232149001434.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (32, 'Thùng 24 lon bia Tiger lon cao 330ml', '', 349000, 2, '2025-04-13 22:18:50.830274+07', '2025-04-14 08:34:36.503401+07', 3, 'https://cdnv2.tgdd.vn/bhx-static/bhx/Products/Images/2282/316846/bhx/1469307061-1_202501031432069235.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (5, 'Cháo tươi SG Food', 'Cháo tươi SG Food nhiều vị', 20000, 57, '2025-04-13 21:38:51.676258+07', '2025-04-14 08:34:36.508399+07', 8, 'https://th.bing.com/th/id/R.20f2ae9fc2466120ac0f93d3b6dbda8b?rik=S7GvVnlaXxh31g&pid=ImgRaw&r=0', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (2, 'Bánh Chocopie đào', 'Bánh Chocopie đào', 47000, 20, '2025-04-13 21:31:37.319545+07', '2025-04-13 21:31:37.319545+07', 1, 'https://orion.vn/media/1ihnycvm/269872572_326309769346564_1593850772332147454_n.jpg', true);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (4, 'Mì lẩu thái Jin', 'chua chua cay cay, ăn là ghiền', 12000, 39, '2025-04-13 21:37:24.518979+07', '2025-04-14 13:33:08.847391+07', 8, 'https://th.bing.com/th/id/R.33be9c021a750c11ed6206084ba7243e?rik=tTKQhTySfrhfFw&pid=ImgRaw&r=0', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (37, 'Nước ngọt 7 Up vị chanh chai 1.5 lít', '', 21000, 30, '2025-04-13 22:22:08.153461+07', '2025-04-13 22:22:08.153461+07', 2, 'https://cdn.tgdd.vn/Products/Images/2443/83599/bhx/nuoc-ngot-7-up-vi-chanh-chai-15-lit-202401271236378599.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (18, 'Custas', 'Bánh Custas Kem Trứng', 55000, 4, '2025-04-13 22:04:33.212641+07', '2025-04-14 00:46:03.870291+07', 1, 'https://orion.vn/media/xcchisa4/custas_12p_mockup.png', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (1, 'Bánh quế', 'thơm lừng, giòn tan', 27000, 50, '2025-04-13 13:42:03.758109+07', '2025-04-13 13:42:03.758109+07', 1, 'https://cdn.tgdd.vn/2020/08/CookProduct/%EB%9E%91%EA%B7%B8%EB%93%9C%EC%83%A4(%EC%8B%9C%EA%B0%80%EB%A0%9B%EC%BF%A0%ED%82%A4)%EB%A7%8C%EB%93%A4%EA%B8%B0LangueDeChat(CigaretteCookies)RecipeCookingtree5-51screenshot-1200x676.jpg', true);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (3, 'Mì Siu Kay', 'Mì cay siu cay, cay xé lưỡi, thơm nức mũi', 17000, 23, '2025-04-13 21:36:13.554693+07', '2025-04-14 13:33:08.85234+07', 8, 'https://khaisanfood.vn/wp-content/uploads/2021/11/z2953098185488_fd509894c5879b19d67a651b78b18f44.jpg', true);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (36, 'Nước ngọt Coca Cola nguyên bản (giảm đường) chai 1.5 lít', '', 21000, 49, '2025-04-13 22:21:32.355937+07', '2025-04-14 13:33:08.855339+07', 2, 'https://cdnv2.tgdd.vn/bhx-static/bhx/Products/Images/2443/222274/bhx/hy6y65_202410101052522546.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (38, 'Nước tăng lực Redbull Thái kẽm và vitamin 250ml', '', 12900, 28, '2025-04-13 22:22:50.30682+07', '2025-04-14 13:33:08.858374+07', 2, 'https://cdn.tgdd.vn/Products/Images/3226/322544/bhx/nuoc-tang-luc-redbull-250ml-clone-202403011702366012.jpg', false);
INSERT INTO public.api_product (id, name, description, price, stock_quantity, created_at, updated_at, category_id, image_url, is_featured) VALUES (39, 'Nước tăng lực Monster Energy Mango vị xoài lon 355ml', '', 27000, 8, '2025-04-13 22:24:32.91701+07', '2025-04-15 08:21:00.552043+07', 2, 'https://cdn.tgdd.vn/Products/Images/3226/241566/bhx/nuoc-tang-luc-monster-energy-mango-vi-xoai-lon-355ml-202203151625118234.jpg', false);


--
-- Data for Name: api_orderitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (1, 1, 27000, 5, 39);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (2, 1, 55000, 6, 18);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (3, 1, 20000, 6, 5);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (4, 1, 14000, 7, 27);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (5, 1, 219000, 8, 34);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (6, 1, 5000, 9, 7);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (7, 1, 5000, 9, 10);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (8, 1, 21000, 9, 35);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (9, 1, 5000, 11, 6);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (10, 1, 12900, 11, 38);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (11, 1, 219000, 11, 34);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (12, 1, 405000, 12, 33);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (13, 1, 349000, 12, 32);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (14, 1, 20000, 12, 5);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (15, 1, 50000, 12, 26);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (16, 1, 12000, 13, 4);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (17, 1, 17000, 13, 3);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (18, 1, 21000, 13, 36);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (19, 1, 12900, 13, 38);
INSERT INTO public.api_orderitem (id, quantity, price, order_id, product_id) VALUES (20, 1, 27000, 14, 39);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_content_type (id, app_label, model) VALUES (1, 'admin', 'logentry');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (2, 'auth', 'permission');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (3, 'auth', 'group');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (4, 'auth', 'user');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (6, 'sessions', 'session');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (7, 'api', 'category');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (8, 'api', 'product');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (9, 'api', 'customer');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (10, 'api', 'order');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (11, 'api', 'orderitem');


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (25, 'Can add Loại hàng', 7, 'add_category');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (26, 'Can change Loại hàng', 7, 'change_category');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (27, 'Can delete Loại hàng', 7, 'delete_category');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (28, 'Can view Loại hàng', 7, 'view_category');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (29, 'Can add Hàng hóa', 8, 'add_product');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (30, 'Can change Hàng hóa', 8, 'change_product');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (31, 'Can delete Hàng hóa', 8, 'delete_product');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (32, 'Can view Hàng hóa', 8, 'view_product');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (33, 'Can add Khách hàng', 9, 'add_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (34, 'Can change Khách hàng', 9, 'change_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (35, 'Can delete Khách hàng', 9, 'delete_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (36, 'Can view Khách hàng', 9, 'view_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (37, 'Can add Đơn hàng', 10, 'add_order');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (38, 'Can change Đơn hàng', 10, 'change_order');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (39, 'Can delete Đơn hàng', 10, 'delete_order');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (40, 'Can view Đơn hàng', 10, 'view_order');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (41, 'Can add Chi tiết đơn hàng', 11, 'add_orderitem');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (42, 'Can change Chi tiết đơn hàng', 11, 'change_orderitem');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (43, 'Can delete Chi tiết đơn hàng', 11, 'delete_orderitem');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (44, 'Can view Chi tiết đơn hàng', 11, 'view_orderitem');


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) VALUES (1, 'pbkdf2_sha256$1000000$n9hR2xNDRlUD92p8hjc90i$xOsTty1noDrDDJy6TEnQLrAlbs4w0T8/uzgzDMmWuGI=', '2025-04-13 23:52:27.422084+07', true, 'admin', '', '', 'admin@gmail.com', true, true, '2025-04-13 08:14:25.173769+07');


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (1, '2025-04-13 08:41:18.38818+07', '1', 'Bánh', 2, '[{"changed": {"fields": ["T\u00ean lo\u1ea1i h\u00e0ng"]}}]', 7, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (2, '2025-04-13 08:42:03.710714+07', '3', 'Nước có cồn', 1, '[{"added": {}}]', 7, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (3, '2025-04-13 08:47:08.51031+07', '4', 'Kẹo', 1, '[{"added": {}}]', 7, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (4, '2025-04-13 08:52:19.855629+07', '5', 'Trà gói', 2, '[{"changed": {"fields": ["T\u00ean lo\u1ea1i h\u00e0ng"]}}]', 7, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (5, '2025-04-13 11:36:03.551023+07', '1', 'Nguyễn Văn A (KH0001)', 1, '[{"added": {}}]', 9, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (6, '2025-04-13 11:36:53.14426+07', '2', 'Trần Thị B (KH0002)', 1, '[{"added": {}}]', 9, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (7, '2025-04-13 11:37:32.065331+07', '3', 'Lê Văn C (KH0003)', 1, '[{"added": {}}]', 9, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (8, '2025-04-13 11:38:15.636768+07', '4', 'Phạm Thị D (KH0004)', 1, '[{"added": {}}]', 9, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (9, '2025-04-13 11:39:13.803744+07', '5', 'Hoàng Văn E (KH0005)', 1, '[{"added": {}}]', 9, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (10, '2025-04-13 11:39:21.765266+07', '5', 'Hoàng Văn E (KH0005)', 2, '[{"changed": {"fields": ["S\u1ed1 \u0111i\u1ec7n tho\u1ea1i"]}}]', 9, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (11, '2025-04-13 11:41:15.133325+07', '7', 'Oishi', 1, '[{"added": {}}]', 7, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (12, '2025-04-13 11:43:48.551092+07', '8', 'Đồ ăn liền', 1, '[{"added": {}}]', 7, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (13, '2025-04-13 12:22:36.132063+07', '9', 'Khác', 3, '', 7, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (14, '2025-04-13 13:42:03.761148+07', '1', 'Bánh quế', 1, '[{"added": {}}]', 8, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (15, '2025-04-13 23:52:55.714001+07', '2', 'Đơn hàng 6BB6007111 - Hoàng Văn E (KH0005)', 3, '', 10, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (16, '2025-04-13 23:52:55.714001+07', '1', 'Đơn hàng 662A2963DF - Đinh Hoàng F (KH0006)', 3, '', 10, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (17, '2025-04-14 00:25:47.411928+07', '4', 'Đơn hàng E5263F6476 - Phạm Thị D (KH0004)', 3, '', 10, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (18, '2025-04-14 00:25:47.411928+07', '3', 'Đơn hàng 4C98DF0AC5 - Đinh Hoàng F (KH0006)', 3, '', 10, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (19, '2025-04-15 09:09:55.75047+07', '11', 'Snack Hành', 3, '', 8, 1);
INSERT INTO public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) VALUES (20, '2025-04-15 09:09:55.75047+07', '9', 'INDO Chips', 3, '', 8, 1);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_migrations (id, app, name, applied) VALUES (1, 'contenttypes', '0001_initial', '2025-04-13 07:55:38.770275+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (2, 'auth', '0001_initial', '2025-04-13 07:55:38.823275+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (3, 'admin', '0001_initial', '2025-04-13 07:55:38.836283+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (4, 'admin', '0002_logentry_remove_auto_add', '2025-04-13 07:55:38.840282+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (5, 'admin', '0003_logentry_add_action_flag_choices', '2025-04-13 07:55:38.843788+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (6, 'api', '0001_initial', '2025-04-13 07:55:38.858807+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (7, 'api', '0002_customer_category_image_url_product_image_url_and_more', '2025-04-13 07:55:38.907314+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (8, 'contenttypes', '0002_remove_content_type_name', '2025-04-13 07:55:38.924314+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (9, 'auth', '0002_alter_permission_name_max_length', '2025-04-13 07:55:38.929316+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (10, 'auth', '0003_alter_user_email_max_length', '2025-04-13 07:55:38.934313+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (11, 'auth', '0004_alter_user_username_opts', '2025-04-13 07:55:38.942828+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (12, 'auth', '0005_alter_user_last_login_null', '2025-04-13 07:55:38.955836+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (13, 'auth', '0006_require_contenttypes_0002', '2025-04-13 07:55:38.958837+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (14, 'auth', '0007_alter_validators_add_error_messages', '2025-04-13 07:55:38.971825+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (15, 'auth', '0008_alter_user_username_max_length', '2025-04-13 07:55:38.993824+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (16, 'auth', '0009_alter_user_last_name_max_length', '2025-04-13 07:55:39.001824+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (17, 'auth', '0010_alter_group_name_max_length', '2025-04-13 07:55:39.010825+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (18, 'auth', '0011_update_proxy_permissions', '2025-04-13 07:55:39.017824+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (19, 'auth', '0012_alter_user_first_name_max_length', '2025-04-13 07:55:39.023824+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (20, 'sessions', '0001_initial', '2025-04-13 07:55:39.029831+07');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (21, 'api', '0003_product_is_featured', '2025-04-14 10:33:56.679236+07');


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_session (session_key, session_data, expire_date) VALUES ('smot6s10wa2e61kkcejjawzfsi6hxzkp', '.eJxVjEEOwiAURO_C2hCgFPgu3fcM5PMBqRpISrsy3t026UKXM-_NvJnHbS1-62nxc2RXJtnltwtIz1QPEB9Y741Tq-syB34o_KSdTy2m1-10_w4K9rKvrdIKYg5KRjKZrEt6gD2aRIPBCE5nYWFEAQocEeIoSIIUBEIHHSz7fAHqSjfb:1u3lwT:YXqkdZco-vjOnesqmS7saVArT3FPSHKCA3nhIUDMGX8', '2025-04-27 08:15:25.092678+07');
INSERT INTO public.django_session (session_key, session_data, expire_date) VALUES ('ui0iul1ikm4cduwg8xoty4b18matkas4', '.eJxVjEEOwiAURO_C2hCgFPgu3fcM5PMBqRpISrsy3t026UKXM-_NvJnHbS1-62nxc2RXJtnltwtIz1QPEB9Y741Tq-syB34o_KSdTy2m1-10_w4K9rKvrdIKYg5KRjKZrEt6gD2aRIPBCE5nYWFEAQocEeIoSIIUBEIHHSz7fAHqSjfb:1u40ZH:sgFzuujgdpf6LvdxN-A9JN_OuRv6qRuY9D3-x1skzEs', '2025-04-27 23:52:27.424602+07');


--
-- Name: api_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_category_id_seq', 9, true);


--
-- Name: api_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_customer_id_seq', 7, true);


--
-- Name: api_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_order_id_seq', 14, true);


--
-- Name: api_orderitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_orderitem_id_seq', 20, true);


--
-- Name: api_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_product_id_seq', 39, true);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 44, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 20, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 11, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 21, true);


--
-- PostgreSQL database dump complete
--

