CREATE DATABASE miniproject_ss8;
USE miniproject_ss8;

-- 1. Bảng Khách hàng
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    gender TINYINT COMMENT '0: Nữ, 1: Nam',
    birthday DATE
);

-- 2. Bảng Danh mục
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 3. Bảng Sản phẩm
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- 4. Bảng Đơn hàng
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 5. Chi tiết đơn hàng
CREATE TABLE Order_Details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    order_detail_price decimal(10,2) not null,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    UNIQUE(order_id, product_id) 
);

INSERT INTO Customers (full_name, email, gender, birthday) VALUES 
('Nguyen Van An', 'an.nguyen@ptit.edu.vn', 1, '2005-05-20'),
('Le Thi Binh', 'binh.le@gmail.com', 0, '1998-11-15'),
('Tran Van Chi', 'chi.tran@outlook.com', 1, '2002-03-10'),
('Pham Minh Dung', 'dung.pham@yahoo.com', 1, '1990-07-05'),
('Vu Hoang Giang', 'giang.vu@gmail.com', 0, '2007-12-12');

INSERT INTO Categories (category_name) VALUES 
('Điện thoại di động'), 
('Gia dụng'), 
('Thời trang'),
('Phụ kiện điện thoại'),
('Trang sức');

INSERT INTO Products (product_name, price, category_id) VALUES 
('iPhone 15', 25000000, 1), 
('Samsung S25', 18000000, 1), 
('Nồi cơm điện', 1200000, 2), 
('Áo sơ mi', 350000, 3), 
('Tủ lạnh', 8000000, 2),
('Airpod pro', 2000000, 4),
('Nhẫn kim cương', 50000000, 5);

INSERT INTO Orders (customer_id, order_date) VALUES 
(1, '2024-03-15'), 
(2, '2024-04-01'), 
(1, '2024-04-10'),
(3, '2023-12-25'), 
(4, '2024-04-20'); 

INSERT INTO Order_Details (order_id, product_id, quantity, order_detail_price) VALUES 
(1, 1, 1, 25000000), 
(1, 4, 2, 350000), 
(2, 2, 1, 18000000), 
(3, 5, 1, 8000000), 
(4, 3, 3, 1200000), 
(5, 1, 1, 25000000), 
(5, 2, 1, 18000000); 

-- Câu 1:
SELECT full_name, email, 
    CASE 
        WHEN gender = 1 THEN 'Nam'
        ELSE 'Nữ'
    END AS gender_text
FROM Customers;

-- Câu 2:
SELECT full_name, birthday, (YEAR(NOW()) - YEAR(birthday)) AS age
FROM Customers
ORDER BY age ASC
LIMIT 3;

-- Câu 3:
SELECT o.order_id, o.order_date, c.full_name
FROM Orders o
INNER JOIN Customers c
ON o.customer_id = c.customer_id;

-- Câu 4: 
SELECT category_id, COUNT(product_id) AS product_count
FROM Products
GROUP BY category_id
HAVING product_count >= 2;

-- Câu 5:
SELECT * FROM Products 
WHERE price > (SELECT AVG(price) FROM Products);

-- Câu 6:
SELECT * FROM Customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id FROM Orders WHERE customer_id IS NOT NULL
);

-- Câu 7:
SELECT p.category_id, SUM(od.order_detail_price * od.quantity) as total_revenue
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.category_id
HAVING total_revenue > (
    SELECT AVG(revenue) * 1.2 
    FROM (
        SELECT SUM(od2.order_detail_price * od2.quantity) as revenue 
        FROM Order_Details od2 
        JOIN Products p2 ON od2.product_id = p2.product_id 
        GROUP BY p2.category_id
    ) AS temp
);

-- Câu 8: 
SELECT * FROM Products p1
WHERE price = (
    SELECT MAX(price) 
    FROM Products p2 
    WHERE p2.category_id = p1.category_id 
);

-- Câu 9:
SELECT full_name FROM Customers
WHERE customer_id IN (
    SELECT customer_id FROM Orders WHERE order_id IN (
        SELECT order_id FROM Order_Details WHERE product_id IN (
            SELECT product_id FROM Products WHERE category_id = (
                SELECT category_id FROM Categories WHERE category_name = 'Điện thoại di động'
            )
        )
    )
);