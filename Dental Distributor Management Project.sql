CREATE DATABASE project;
USE project;

#CREATING TABLE FOR THR PRODUCT'S DETAILS
CREATE TABLE products(product_id INT PRIMARY KEY, product_name VARCHAR(20), price DECIMAL(10,2), qty INT);

#CREATING TABLE FOR THE DOCTOR'S DETAILS
CREATE TABLE doctors(doctor_id INT PRIMARY KEY, doctor_name VARCHAR(20), clinic_name VARCHAR(50), area VARCHAR(20), specialization VARCHAR(20), ph_no varchar(11));
#INSERTING VALUES INTO PRODUCTS
INSERT INTO products VALUES
(01, 'Helios 500', 320000, 7),
(02, 'Laser', 270000, 5),
(03, 'Nanopix', 51500,10),
(04, 'Hyperlight', 64500, 7),
(05,'E-connect', 24500, 5),
(06, 'Point Implants', 6500, 100),
(07, 'Loupes', 31900 ,8),
(08, 'FastPack', 20000,3);  

#INSERTING VALUES OF DOCTORS
INSERT INTO doctors VALUES
(001, 'Dr.Ramesh', 'Pearl Dental Clinic', 'Washermenpet','Endodontist',8767864376),
(002,'Dr.Saket', 'Saket Dental Clinic', 'Egmore', 'Periodontist', 8219876839),
(003, 'Dr.Viren', 'Daya Dental Clinic', 'Koyembedu','Implantologist', 9865458371),
(004, 'Dr.Yukta', 'White Tooth Dental Care','Egmore','Endodontist',9768882975),
(005, 'Dr.Maya', 'Crown Dental Clinic', 'Washermenpet','Periodontost',8768008656),
(006, 'Dr.Mehul', 'Yugs Dental Care', 'AnnaNagar','Prosthodontist',7876890853),
(007, 'Dr.Arjun', 'Ambattur Dental Care', 'Ambattur','Periodontist', 9865734261),
(008, 'Dr.Banu', '32 Dental Care', 'Koyembedu','Implantologist',9863462718),
(009, 'Dr.Maya', 'White Pearl Dental Care', 'Endodontist', 'Chrompet', 9797865646),
(010, 'Dr.Vina', 'Vina Dentistry', 'AnnaNagar','Prosthodontist',8766646336);

#CREATING SALESMAN TABLE
create table salesman(salesman_id int primary key, name varchar(20), area varchar(20), ph_no varchar(11));

#CREATING ORDER TABLE
create table orders(order_id int primary key,product_id int, doctor_id int, salesman_id int, quantity int, total_amount decimal(10,2),order_date date,  
foreign key(product_id) references products(product_id),
foreign key(doctor_id) references doctors(doctor_id),
foreign key(salesman_id) references salesman(salesman_id));

#INSERTING VALUES INTO SALESMAN TABLE
insert into salesman values
(01,'Mr.Raj', 'AnnaNagar',9867565434),
(02,'Mr.Mihir','Koyembedu',9987675432),
(03,'Mrs.Jiya','AnnaNagar',8987546433),
(04,'Mr.Sam','Ambattur',9878907631),
(05,'Mr.Rahul','Egmore',7686356721);

#INSERTING VALUES TO ORDERS TABLE

insert into orders values
(001,04,003,02,1,64500,'2025-01-05'),
(002,04,001,04,2,64500,'2025-02-05'),
(003,02,007,04,1,270000,'2025-01-17'),
(004,01,005,01,1,300000,'2025-03-20'),
(005,07,007,05,1,31900,'2025-04-02'),
(006,06,006,02,10,65000,'2025-04-15'),
(007,08,001,03,2,40000,'2025-05-01'),
(008,05,008,05,4,98000,'2025-06-01'),
(009,01,004,01,3,960000,'2025-07-10'),
(010,03,008,02,4,206000,'2025-08-15');

#TO FIND THE TOP 5 DOCTORS BY TOTAL PURCHASE

select doctor_name, sum(orders.total_amount) as Total_Purchases
from orders
join doctors on orders.doctor_id = doctors.doctor_id
group by doctors.doctor_name
order by total_purchases desc
limit 5;

#TO FIND THE BEST SELLING PRODUCT
select product_name,sum(o.quantity) as Most_Selling
from products as p
join orders as o on p.product_id = o.product_id
group by p.product_name
order by most_selling desc; 

#GOOD PERFORMING SALESMAN ACCORDING TO SALES
select name,sum(o.total_amount) as Total_sales
from salesman as mr
join orders as o on mr.salesman_id = o.salesman_id
group by mr.name
order by total_sales desc;

#CALCULATE TOTAL REVENUE PER MONTH
select MONTH(order_date) as month, sum(total_amount) as This_Month_Sales
from orders
group by month(order_date)
order by this_month_sales desc;

#PENDING STOCKS
select 
p.product_name,
p.qty as Initial_Stock,
sum(o.quantity) as Sold,
p.qty - coalesce(sum(o.quantity),0) as Current_Stock
from products p
left join orders as o on p.product_id = o.product_id
group by p.product_name,p.qty; 

