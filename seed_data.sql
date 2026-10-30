INSERT INTO customers (customer_name,email,city) VALUES
('Aarav Kumar','aarav@example.com','Coimbatore'),
('Diya Sharma','diya@example.com','Chennai'),
('Ishaan Raj','ishaan@example.com','Bengaluru'),
('Meera Nair','meera@example.com','Coimbatore'),
('Kavin S','kavin@example.com','Madurai'),
('Nila Devi','nila@example.com','Chennai');

INSERT INTO categories (category_name) VALUES
('Electronics'),('Books'),('Home'),('Sports');

INSERT INTO products (product_name,category_id,price) VALUES
('Wireless Mouse',1,650.00),('USB Keyboard',1,900.00),
('SQL Handbook',2,450.00),('Python Basics',2,550.00),
('Desk Lamp',3,800.00),('Water Bottle',3,300.00),
('Yoga Mat',4,700.00),('Skipping Rope',4,250.00),
('Webcam',1,1500.00);

INSERT INTO orders (customer_id,order_date,order_status) VALUES
(1,'2026-01-05','DELIVERED'),(2,'2026-01-10','DELIVERED'),
(1,'2026-02-02','SHIPPED'),(3,'2026-02-15','DELIVERED'),
(4,'2026-03-01','DELIVERED'),(2,'2026-03-12','CANCELLED'),
(5,'2026-03-20','DELIVERED'),(3,'2026-04-04','PLACED'),
(1,'2026-04-18','DELIVERED'),(4,'2026-05-03','SHIPPED'),
(5,'2026-05-15','DELIVERED');

INSERT INTO order_items (order_id,product_id,quantity,unit_price) VALUES
(1,1,2,650),(1,3,1,450),(2,2,1,900),(2,4,2,550),
(3,5,1,800),(3,6,2,300),(4,1,1,650),(4,7,1,700),
(5,3,3,450),(5,5,1,800),(6,2,1,900),(7,8,2,250),
(7,6,1,300),(8,4,1,550),(8,7,2,700),(9,1,1,650),
(9,2,1,900),(10,5,2,800),(10,3,1,450),(11,8,3,250),
(11,6,2,300);
