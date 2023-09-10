--CREATING TABLES FOR PRODUCTION SCHEMA--
CREATE OR REPLACE TABLE KB_CATEGORIES (
 category_id INT PRIMARY KEY,
 category_name varchar(50)
);

CREATE OR REPLACE TABLE KB_PRODUCTS (
 product_id INT PRIMARY KEY,
 product_name varchar(60),
 brand_id INT,
 category_id INT,
 model_year date,
 list_price FLOAT
);

CREATE OR REPLACE TABLE KB_STOCKS (
 store_id INT,
 product_id INT,
 quantity INT,BIKESTORES.SALES
 PRIMARY KEY(store_id,product_id)
);

CREATE OR REPLACE TABLE KB_BRANDS (
 brand_id INT PRIMARY KEY,
 brand_name varchar(30)
);


--CREATING TABLES FOR SALES SCHEMA--

CREATE OR REPLACE TABLE KB_CUSTOMERS (
 customer_id INT PRIMARY KEY,
 first_name varchar(30),
 last_name varchar(30),
 phone varchar(25),
 email varchar(50),
 street varchar(50),
 city varchar(30),
 state varchar(30),
 zip_code NUMBER(8,0)
);

CREATE OR REPLACE TABLE KB_ORDERS (
 order_id INT PRIMARY KEY,
 customer_id INT,
 order_status INT,
 order_date DATE,
 required_date DATE,
 shipped_date varchar(50),
 store_id INT,
 staff_id INT
);

CREATE OR REPLACE TABLE KB_STAFFS (
 staff_id INT PRIMARY KEY,
 first_name varchar(30),
 last_name varchar(30),
 email varchar(30),
 phone varchar(20),
 active NUMBER(5),
 store_id INT,
 manager_id varchar(20)
);

CREATE OR REPLACE TABLE KB_STORES (
 store_id INT PRIMARY KEY,
 store_name varchar(20),
 phone varchar(20),
 email varchar(50),
 street varchar(50),
 city varchar(30),
 state varchar(30),
 zipcode INT
);

CREATE OR REPLACE TABLE KB_ORDER_ITEMS (
 order_id INT,
 item_id INT,
 product_id INT,
 quantity INT,
 list_price FLOAT,
 discount FLOAT,
 PRIMARY KEY (order_id,item_id)
);


---ALTER COMMAND USING FOR ASSIGNING FOREIGN KEY---

ALTER TABLE KB_STAFFS
ADD FOREIGN KEY(store_id) REFERENCES KB_STORES(store_id);

ALTER TABLE KB_STAFFS
ADD FOREIGN KEY(manager_id) REFERENCES KB_STAFFS(staff_id);

ALTER TABLE KB_ORDERS
ADD FOREIGN KEY(customer_id) REFERENCES KB_CUSTOMERS(customer_id);

ALTER TABLE KB_ORDERS
ADD FOREIGN KEY(store_id) REFERENCES KB_STORES(store_id);

ALTER TABLE KB_ORDERS
ADD FOREIGN KEY(staff_id) REFERENCES KB_STAFFS(staff_id);

ALTER TABLE KB_ORDER_ITEMS
ADD FOREIGN KEY(order_id) REFERENCES KB_ORDERS(orders_id);

ALTER TABLE SALES.KB_ORDER_ITEMS
ADD FOREIGN KEY(product_id) REFERENCES PRODUCTION.KB_PRODUCTS(product_id);


ALTER TABLE PRODUCTION.KB_STOCKS
ADD FOREIGN KEY(store_id) REFERENCES SALES.KB_STORES(store_id);

ALTER TABLE PRODUCTION.KB_PRODUCTS
ADD FOREIGN KEY(category_id) REFERENCES PRODUCTION.KB_CATEGORIES(category_id);

ALTER TABLE PRODUCTION.KB_PRODUCTS
ADD FOREIGN KEY(brand_id) REFERENCES PRODUCTION.KB_BRANDS(brand_id);


/* 3.Does any of the table has missing or NULL value ? If yes which are those and what are their counts ?*/


---order TABLE NULL VALUES---
SELECT count(*) FROM KB_ORDERS WHERE shipped_date is NULL;



SELECT count(*) FROM KB_ORDERS WHERE shipped_date='NULL';

--count= 23 Null Values---

----Customer Table NULL Values----

SELECT count(*) FROM KB_CUSTOMERS WHERE PHONE='NULL';

SELECT COUNT(*) FROM KB_CUSTOMERS WHERE PHONE is null;


/* Q3.How many unique tables are present in each schema and under each table how many records are
we having ? (Write SQL Script for the same – I don’t need answer like 3/5/4 etc)  */

USE BIKESTORES.PRODUCTION;

SHOW TABLES;

USE BIKESTORES.SALES;

SHOW TABLES;

/* Q4: How many total serving customer BikeStore has ? */

 SELECT COUNT(*) FROM BIKESTORES.SALES.KB_CUSTOMERS;

 
/* Q5: .How many total orders are there ? */  

  SELECT COUNT(*) FROM BIKESTORES.SALES.KB_ORDERS;


/* Q6: Which store has the highest number of sales ? */
SELECT * FROM BIKESTORES.PRODUCTION.KB_STOCKS ORDER BY quantity DESC LIMIT 3;

SELECT store_name FROM BIKESTORES.SALES.KB_STORES WHERE store_id=1;

/* Which month the sales was highest and for which store ?*/


/*Q9 How many orders each customer has placed (give me top 10 customers) */ 

SELECT customer_id, order_status FROM BIKESTORES.SALES.KB_ORDERS ORDER BY order_status DESC;


/* Q9: Which are the TOP 3 selling product ? */ 

SELECT product_id, MAX(quantity) FROM BIKESTORES.SALES.KB_ORDER_ITEMS
GROUP BY product_id ORDER BY 1 DESC LIMIT 3;

/* Q10: Which was the first and last order placed by the customer who has placed maximum number of
orders ? */

SELECT customer_id,MAX(order_date) as last_order ,MIN(order_date) as First_order,COUNT(order_id)
FROM BIKESTORES.SALES.KB_ORDERS
GROUP BY 1
ORDER BY 3 DESC LIMIT 1;

/*Q11: 1. For every customer,which is the cheapest product and the costliest product which the
customer has bought.*/
SELECT MIN(list_price) AS Cheapest_Product, MAX(list_price) AS COSTLIEST_PRODUCT FROM BIKESTORES.PRODUCTION.KB_PRODUCTS; /* Cant have customers because we have to use joins to retrieve the customers data 


/* Q12: Which product has orders more than 200 ? */


/* 13.Add a column TOTAL_PRICE with appropriate data type into the sales.order_items*/


ALTER TABLE BIKESTORES.SALES.KB_ORDER_ITEMS
ADD total_price float;



/* Calculate TOTAL_PRICE = quantity * list price and Update the value for all rows in the
sales.order_items table. */

UPDATE BIKESTORES.SALES.KB_ORDER_ITEMS
SET total_price = quantity * list_price;


/* 14.What is the value of the TOTAL_PRICE paid for all the sales.order_items ? */ 
SELECT SUM(total_price) AS Total_Price_All
FROM BIKESTORES.SALES.KB_ORDER_ITEMS;
