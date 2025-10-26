create database inventory_management;
use inventory_management;

#SUPPLIER'S TABLE
CREATE TABLE suppliers (
  supplier_id INT PRIMARY KEY,
  supplier_name VARCHAR(50),
  city VARCHAR(30),
  contact_no VARCHAR(15)
);

INSERT INTO suppliers VALUES
(101, 'Sunrise Traders', 'Mumbai', '9876543210'),
(102, 'Elite Supply Co.', 'Chennai', '9898989898'),
(103, 'Global Goods Ltd.', 'Delhi', '9988776655'),
(104, 'Shree Enterprises', 'Pune', '9123456789'),
(105, 'Prime Distributors', 'Hyderabad', '9765432109');

select*from suppliers;

#PRODUCT'S TABLE
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category VARCHAR(30),
  unit_price DECIMAL(10,2),
  stock_qty INT,
  supplier_id INT,
  foreign key(supplier_id) references suppliers(supplier_id)
);

INSERT INTO products VALUES
(201, 'Dental Chair', 'Equipment', 55000, 12, 101),
(202, 'Surgical Mask', 'Consumables', 5, 500, 102),
(203, 'Latex Gloves', 'Consumables', 8, 300, 102),
(204, 'X-Ray Film', 'Diagnostic', 120, 200, 103),
(205, 'Implant Kit', 'Surgery', 25000, 15, 104),
(206, 'Sterilizer', 'Equipment', 18000, 10, 105),
(207, 'Scaler Machine', 'Cleaning', 22000, 8, 101),
(208, 'Dental Mirror', 'Tool', 150, 100, 103);

select * from products;

#CUSTOMER'S TABLE
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(50),
  clinic_name VARCHAR(50),
  city VARCHAR(30),
  phone_no VARCHAR(15)
);

INSERT INTO customers VALUES
(301, 'Dr. Ramesh', 'Pearl Dental Clinic', 'Chennai', '9812345678'),
(302, 'Dr. Maya', 'Smile Dental Care', 'Pune', '9823456789'),
(303, 'Dr. Arjun', 'White Tooth Dental', 'Delhi', '9876541230'),
(304, 'Dr. Mehul', 'Happy Teeth Clinic', 'Mumbai', '9767896543'),
(305, 'Dr. Banu', 'Elite Dental Studio', 'Hyderabad', '9888888888');

select * from customers;

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  product_id INT,
  customer_id INT,
  order_date DATE,
  quantity INT,
  total_amount DECIMAL(10,2),
  foreign key(product_id) references products(product_id),
  foreign key(customer_id) references customers(customer_id)
);

INSERT INTO orders VALUES
(401, 201, 301, '2025-01-12', 1, 55000),
(402, 202, 302, '2025-02-10', 100, 500),
(403, 203, 303, '2025-02-25', 150, 1200),
(404, 205, 304, '2025-03-01', 2, 50000),
(405, 206, 305, '2025-03-20', 1, 18000),
(406, 207, 301, '2025-04-05', 1, 22000),
(407, 204, 302, '2025-05-15', 20, 2400),
(408, 208, 303, '2025-06-01', 10, 1500),
(409, 202, 304, '2025-06-18', 200, 1000),
(410, 205, 305, '2025-07-02', 1, 25000);

select * from orders;

#TO DISPLAY ALL THE ORDERS RECORDS INCLUDING CUSTOMER AND PRODUCT INFO
select 
o.order_id,
o.order_date,
c.customer_name,
p.product_name,
o.quantity,
o.total_amount
from orders as o
join customers as c on c.customer_id = o.customer_id
join products as p on p.product_id = o.product_id
order by order_date;

select * from orders;

#TOTAL REVENUE GENERATED
SELECT sum(total_amount) as Total_Revenue from orders;

#TOP THREE SELLING ITEMS BY QUANTITY
select
p.Product_name,
sum(o.quantity) as Total_Sales
from orders as o 
join products as p on p.product_id = o.product_id
group by p.product_name
order by total_sales desc
limit 3;

#SUPPLIERS PERFORMANCE(TOTAL ITEM SOLD)
select 
s.supplier_name,
sum(o.quantity) as Total_Quantity_Sold
from orders as o
join products as p on p.product_id - o.product_id
join suppliers as s on s.supplier_id = p.supplier_id
group by s.supplier_name
order by total_quantity_sold desc;

#MONTHLY REVENUE TREND
select 
month(o.order_date) as Month,
sum(o.quantity) as quantity,
sum(o.Total_amount) as Total_Sales_This_Month
from orders as o
group by month(o.order_date);

# CUSTOMERS WHO HAS SPENT MORE THAN 20,000
select
c.customer_name,
sum(o.total_amount) as Total_Spent
from orders as o
join customers as c on o.customer_id = c.customer_id
group by c.customer_name
having total_spent > 20000
order by total_spent desc;

#CURRENT STOCKS AFTER ORDERS
SELECT 
    p.product_name,
    p.stock_qty AS Initial_Stock,
    COALESCE(SUM(o.quantity), 0) AS Stock_Sold,
    p.stock_qty - COALESCE(SUM(o.quantity), 0) AS Remaining_Stock
FROM products AS p
LEFT JOIN orders AS o 
    ON p.product_id = o.product_id
GROUP BY p.product_name, p.stock_qty;
