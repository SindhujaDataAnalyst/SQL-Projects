USE branch;
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO customers (first_name, last_name, email, phone, address, city, country) VALUES
('John', 'Doe', 'john.doe@email.com', '1234567890', '123 Main St', 'New York', 'USA'),
('Alice', 'Smith', 'alice.smith@email.com', '2345678901', '456 Elm St', 'Los Angeles', 'USA'),
('Michael', 'Johnson', 'michael.johnson@email.com', '3456789012', '789 Pine St', 'Chicago', 'USA'),
('Emma', 'Williams', 'emma.williams@email.com', '4567890123', '321 Oak St', 'Houston', 'USA'),
('Oliver', 'Brown', 'oliver.brown@email.com', '5678901234', '654 Maple St', 'Phoenix', 'USA'),
('Sophia', 'Jones', 'sophia.jones@email.com', '6789012345', '987 Birch St', 'Philadelphia', 'USA'),
('Liam', 'Garcia', 'liam.garcia@email.com', '7890123456', '741 Cedar St', 'San Antonio', 'USA'),
('Isabella', 'Martinez', 'isabella.martinez@email.com', '8901234567', '852 Spruce St', 'San Diego', 'USA'),
('Noah', 'Davis', 'noah.davis@email.com', '9012345678', '963 Willow St', 'Dallas', 'USA'),
('Mia', 'Rodriguez', 'mia.rodriguez@email.com', '0123456789', '147 Palm St', 'San Jose', 'USA');
select * from customers;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    rating DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO products (product_name, category, price, stock_quantity, rating) VALUES
('iPhone 14', 'Electronics', 999.99, 50, 4.8),
('Samsung Galaxy S22', 'Electronics', 899.99, 40, 4.7),
('MacBook Pro 16', 'Electronics', 2499.99, 30, 4.9),
('Dell XPS 13', 'Electronics', 1299.99, 20, 4.6),
('Sony WH-1000XM4', 'Accessories', 349.99, 100, 4.8),
('Apple Watch Series 8', 'Wearables', 429.99, 70, 4.7),
('Samsung Galaxy Watch 5', 'Wearables', 329.99, 60, 4.5),
('Nintendo Switch', 'Gaming', 299.99, 80, 4.9),
('PlayStation 5', 'Gaming', 499.99, 25, 4.9),
('Xbox Series X', 'Gaming', 499.99, 30, 4.8),
('Bose QuietComfort 45', 'Accessories', 299.99, 90, 4.7),
('Google Pixel 7', 'Electronics', 599.99, 45, 4.6),
('Amazon Echo Dot', 'Smart Home', 49.99, 150, 4.5),
('Samsung 55 QLED TV', 'Electronics', 1299.99, 20, 4.8),
('LG 65 OLED TV', 'Electronics', 1999.99, 15, 4.9);
INSERT INTO products (product_name, category, price, stock_quantity, rating) VALUES
('Google  7', 'Electronics', 599.99, 0, 4.6),
('Amazon Echo ', 'Smart Home', 49.99, 0, 4.5);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 1999.98, 'Shipped'),
(2, 899.99, 'Pending'),
(3, 2499.99, 'Delivered'),
(4, 1299.99, 'Shipped'),
(5, 349.99, 'Pending'),
(6, 429.99, 'Cancelled'),
(7, 299.99, 'Delivered'),
(8, 499.99, 'Shipped'),
(9, 499.99, 'Pending'),
(10, 1299.99, 'Delivered');
select * from orders;

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
	
INSERT INTO order_details (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 2, 1999.98),
(2, 2, 1, 899.99),
(3, 3, 1, 2499.99),
(4, 4, 1, 1299.99),
(5, 5, 1, 349.99),
(6, 6, 1, 429.99),
(7, 7, 1, 299.99),
(8, 8, 1, 499.99),
(9, 9, 1, 499.99),
(10, 10, 1, 1299.99);

SELECT * FROM customers, orders;
SELECT * FROM products, order_details;
SELECT * FROM orders;
SELECT * FROM order_details;

-- calculate the total revenue generated per month from delivered orders --

SELECT SUM(total_amount) AS 'Total Revenue', DATE_FORMAT(order_date, '%y-%m') AS 'Month'
FROM branch.orders
WHERE status = 'Delivered'
GROUP BY Month

-- TOP 5 BEST SELLING PRODUCTS BASED ON THE TOTAL QUANTITY SOLD -

SELECT p.product_name, sum(o.quantity) AS 'Total_quantity_sold'
FROM branch.order_details o
JOIN branch.products p
ON o.product_id= p.product_id 
GROUP BY p.product_name
ORDER BY 2 DESC 
LIMIT 5

-- Write a SQL query to find the customer who has spent the most on purchases. 
-- The query should return the customer's first name, last name, and the total amount they have spent,
-- sorted in descending order, and display only the highest spender

SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS 'Customer Name',
	   SUM(o.total_amount) AS 'Total Amount'
FROM branch.customers c 
JOIN branch.orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY 3 DESC 
LIMIT 1;


-- Write a SQL query to retrieve the names of all products that are currently out of stock 
-- (i.e., have a stock quantity of zero)

SELECT * FROM branch.products 
WHERE stock_quantity = 0;

-- find orders that contain more than one product.
-- The query should return the order ID and the count of products in each order, 
-- sorted in descending order by the product count 

SELECT order_id, count(product_id)
FROM branch.order_details 
GROUP BY order_id 
HAVING count(quantity) > 1;


-- Rank customers based on their total purchase amount and display only the top 3 customers.
--  If two customers have the same total spent, they should have the same rank.

SELECT customer_id, total_amount,
DENSE_RANK() over(ORDER BY total_amount desc) AS Customer_Rank
FROM branch.orders 
ORDER BY Customer_Rank 
LIMIT 3;


-- Display the order ID, customer name, order total, and order status for all delivered orders.


SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS Customer_name, 
	o.total_amount AS Order_amount, o.status
FROM branch.orders o
JOIN branch.customers c 
ON c.customer_id = o.customer_id
WHERE status = 'Delivered'	 
ORDER BY Order_amount DESC 


-- Retrieve a list of order IDs and statuses for orders that are either 'Delivered' or 'Pending'. 
-- Ensure duplicate records are removed.

SELECT order_id, status 
FROM branch.orders 
WHERE status in('Delivered','Pending');


-- Write a query to calculate the total revenue generated for each product category.

SELECT p.category, SUM(p.price*od.quantity) AS Total_revenue
FROM branch.products p
JOIN branch.order_details od 
ON p.product_id = od.product_id
GROUP BY p.category


/* Write a query to display the total spending per customer, sorted from highest to lowest.*/


SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS Customer_name,
		sum(o.total_amount) AS Total_spending
FROM branch.customers c
JOIN branch.orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id 
ORDER BY Total_spending DESC;


/* List all customers along with the number of orders they have placed.*/

SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS Customer_name, 
	   COUNT(o.order_id) AS Number_of_orders
FROM branch.customers c 
LEFT JOIN branch.orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, Customer_name
ORDER BY Number_of_orders


/* Write a query to calculate the cumulative total revenue over time, ordered by order date.*/

SELECT
    order_date,
    total_amount,
    SUM(total_amount) OVER (ORDER BY order_date) AS cumulative_revenue
FROM orders
ORDER BY order_date;




