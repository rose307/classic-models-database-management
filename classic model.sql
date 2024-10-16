use classicmodels;

/* Q1 a.Fetch the employee number, first name and 
last name of those employees who are working as Sales 
Rep reporting to employee with employeenumber 1102  a */
select employeeNumber, firstName, lastName 
from employees 
where jobTitle='sales Rep' and reportsTo=1102 ;

/*q1 b Show the unique productline values
 containing the word cars at the end from the products table.*/
select distinct productLine
from products
where productLine like '%cars';

/*--------------------------------------------------------------------*/

/*q2 a. Using a CASE statement, segment customers 
into three categories based on their country 
North America" for customers from USA or Canada
"Europe" for customers from UK, France, or Germany
"Other" for all remaining countries
Select the customerNumber, customerName, and the assigned 
region as "CustomerSegment".
*/
select customerNumber, customerName,
Case 
     when country in ('canada','usa') then'North america'
     when country in('uk','france','germany') then 'europe'
     else 'others'
    end as countrySegment
from customers;

/*-----------------------------------------------------------*/

/*q3 a. a.	Using the OrderDetails table, identify the top 10 products 
(by productCode) with the highest total order quantity across all orders. */
select productCode, sum(quantityordered) as total_ordered
from orderdetails
group by productCode 
order by total_ordered desc limit 10;

/*Q3 b. b.	Company wants to analyse payment frequency by month. 
Extract the month name from the payment date to count the total number 
of payments for each month and include only those months with a payment
 count exceeding 20. Sort the results by total number of payments in descending order.   */
select  date_format(paymentdate,'%M') as payment_month, 
count(amount) as num_payments
from payments
group by payment_month
having num_payments>20;
/*-----------------------------------------------------*/
/*q4 a. Create a new database named and Customers_Orders and
 add the following tables as per the description
a.	Create a table named Customers to store customer information. Include the following columns:
customer_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
first_name: This should be a VARCHAR(50) to store the customer's first name.
last_name: This should be a VARCHAR(50) to store the customer's last name.
email: This should be a VARCHAR(255) set as UNIQUE to ensure no duplicate email addresses exist.
phone_number: This can be a VARCHAR(20) to allow for different phone number formats.
Add a NOT NULL constraint to the first_name and last_name columns to ensure they always have a value.
 */
create table customers_1
(
customer_id int auto_increment primary key,
first_name varchar(50) not null ,
last_name varchar(50) not null ,
email varchar(255) unique ,
phone_number varchar(20) unique not null
);
desc customers_1;

/*q4 b.Create a table named Orders to store information about customer orders.
 Include the following columns:
order_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
customer_id: This should be an integer referencing the customer_id in the 
Customers table  (FOREIGN KEY).
order_date: This should be a DATE data type to store the order date.
total_amount: This should be a DECIMAL(10,2) to store the total order amount.
Constraints:
a)	Set a FOREIGN KEY constraint on customer_id to reference the Customers table.
b)	Add a CHECK constraint to ensure the total_amount is always a positive value.
 */
create table orders_1
(
order_id int auto_increment primary key,
customer_id int,
constraint customer_id_fk foreign key (customer_id) references customers (customernumber),
oder_date date,
total_amount decimal(10,2) 
); 
desc orders_1 ; 
/*constrains */
/*a*/
alter table customers_1
add constraint customer_id2_fk foreign key (customer_id) 
references customers(customernumber);
/*b*/
alter table orders_1
add check(total_amount>0);
/*-------------------------------------------------------*/
/*q5 a. List the top 5 countries 
(by order count) that Classic Models ships to.  */
select country, count(ordernumber) as order_count
from customers inner join orders 
on customers.customernumber=orders.customernumber 
group by country 
order by order_count  desc
limit 5 ;
select* from customers;
select* from orders;
/*q6 b. Create a table project with below fields.
EmployeeID : integer set as the PRIMARY KEY and AUTO_INCREMENT.
FullName: varchar(50) with no null values
Gender : Values should be only ‘Male’  or ‘Female’
ManagerID: integer 
Add below data into it.
employeeID: 1, 2, 3, 4, 5, 6, 7
fullName : pranaya, priyanka, preety, anurag, sambit, rajesh, hina 
gender : male, female, female, male, male, male, female
manager id : 3, 1, null, 1, 1, 3, 3
Find out the names of employees and their related managers.
 */
create table project 
(
employeeID int auto_increment primary key,
full_name varchar(50) not null ,
gender varchar(10) check (gender in ('male','female')),
managerID int
);
insert into project values (1,'pranaya','male',3),
						   (2,'priyanka','female',1),
                           (3,'preety','female',null),
                           (4, 'anurag','male',1),
                           (5,'sambit','male',1),
                           (6,'rajesh','male',3),
                           (7,'hina','female',3);
select* from project;
select e1.full_name as emp_name, m1.full_name as mgr_name
from project e1  join project m1 
on e1.managerID=m1.employeeID ;
/*------------------------------------------------------------*/
/*q7. . Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country
i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.
*/
create table facilities
(
facility_id int,
name varchar(50),
state varchar(50),
country varchar(50)
);
alter table facilities 
modify facility_id int auto_increment primary key;
alter table facilities 
add column city varchar(50) not null ;
desc facilities;
/*--------------------------------------------------------------*/
/*q8 a. Create a view named product_category_sales that provides insights into sales performance by product category. This view should include the following information:
productLine: The category name of the product (from the ProductLines table).
total_sales: The total revenue generated by products within that category (calculated by summing the orderDetails.quantity * orderDetails.priceEach for each product in the category).
number_of_orders: The total number of orders containing products from that category.
*/
SELECT* FROM PRODUCTS ;
SELECT* FROM ORDERDETAILS;
SELECT* FROM ORDERS ;
SELECT* FROM PRODUCTLINES;

create view product_category_sales1 as
select pl.productLine, sum(od.quantityOrdered * od.priceEach) as total_sales, 
count(distinct o.orderNumber) as number_of_orders
from  productlines pl inner join  products p inner join orderdetails od inner join  orders o
on pl.productLine = p.productLine and p.productCode = od.productCode and od.orderNumber = o.orderNumber
group by  pl.productLine;

select* from product_category_sales1;
/*--------------------------------------------------------------------------------------------------------*/

/*q9.Create a stored procedure Get_country_payments which takes in year and country as 
inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K) */
call get_country_payments(2003,'france');
/*--------------------------------------------------------------*/
						
/*q10 ) Using customers and orders tables, rank the customers based on 
their order frequency */
select* from customers;
select* from orders;

select c.customername, count(o.ordernumber) as order_frequency, 
dense_rank() over (order by count(o.ordernumber) desc) rank_1
from customers c left join orders o
on c.customerNumber=o.customerNumber 
group by c.customernumber, c.customername 
order by rank_1;
select* from customers;
/*------------------------------------------------------------*/

/*q10 b. Calculate year wise, month name wise count of 
orders and year over year (YoY) percentage change. 
Format the YoY values in no decimals and show in % sign. */
select* from orders;
with 
Monthlyorders as 
(
select extract(year from orderdate ) as order_yr, 
	   date_format(orderdate,'%M') as order_month_name,
       month(orderdate) as order_month,
       count(ordernumber) as order_count
from orders
group by order_yr, order_month_name, order_month
),
yearlyorders as 
(
select order_yr, sum(order_count) as total_orders 
from monthlyorders 
group by order_yr
),
yoychange as 
(
select mo.order_yr, mo.order_month_name, mo.order_month, 
       mo.order_count,
      lag(mo.order_count) over (order by mo.order_yr, mo.order_month)
      as pervious_yr_count, 
      case when 
      lag(mo.order_count) over (order by mo.order_yr, 
      mo.order_month) is null 
      then null 
      else round((mo.order_count- lag(mo.order_count) 
      over (order by mo.order_yr,mo.order_month))*100.0
      /lag(mo.order_count) over(order by mo.order_yr, mo.order_month))
      end as  yoy_percentage_change 
      from monthlyorders mo
)
      select order_yr, order_month_name, order_count,
      case when 
      yoy_percentage_change is not null 
      then concat(round(yoy_percentage_change),'%')
      else 'null'
      end as yoy_change 
      from yoychange 
     order by order_yr, order_month;

/*q11 Find out how many product lines are there for which the buy price value is greater than the average of 
buy price value. Show the output as product line and its count.
*/
select* from products;
select productline,count(productline) as total 
from products
where buyprice >(select avg(buyprice)
				from products )
group by productline;

/*q12. Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in 
Emp_EH. Handle the error using exception handling concept. 
Show the message as “Error occurred” in case of 
anything wrong.
*/	
create table emp_eh 
(
emid int primary key,
empname varchar(100),
emailaddress varchar(100)
);
insert into emp_eh values(1, 'john','john@gmail.com'),
					(2, 'abraham', 'abraham@gmail.com');
select* from emp_eh;
alter table emp_eh 
rename column emid to empid;

call insert_emp(5, 'john', 'sahubhgmail');

/* q13. Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.
*/

create table emp_bit
(empname varchar(150),
occupation varchar(150),
working_date date,
working_hrs time 
);
insert into emp_bit values ('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
select* from emp_bit;
insert into emp_bit values ('test','tester','2020-12-12',-5);
select* from emp_bit;

/*--------------------------------------------------------------------------------------*/


 







