-- RabTech Task 04: Retail Sales Analysis System
CREATE TABLE customers (
 customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 customer_name VARCHAR(100) NOT NULL,
 email VARCHAR(150) UNIQUE NOT NULL,
 city VARCHAR(100) NOT NULL
);
CREATE TABLE categories (
 category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 category_name VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE products (
 product_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 product_name VARCHAR(100) NOT NULL,
 category_id INT NOT NULL REFERENCES categories(category_id),
 price NUMERIC(10,2) NOT NULL CHECK (price > 0)
);
CREATE TABLE orders (
 order_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 customer_id INT NOT NULL REFERENCES customers(customer_id),
 order_date DATE NOT NULL,
 order_status VARCHAR(20) NOT NULL
 CHECK (order_status IN ('PLACED','SHIPPED','DELIVERED','CANCELLED'))
);
CREATE TABLE order_items (
 item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 order_id INT NOT NULL REFERENCES orders(order_id),
 product_id INT NOT NULL REFERENCES products(product_id),
 quantity INT NOT NULL CHECK (quantity > 0),
 unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0)
);
