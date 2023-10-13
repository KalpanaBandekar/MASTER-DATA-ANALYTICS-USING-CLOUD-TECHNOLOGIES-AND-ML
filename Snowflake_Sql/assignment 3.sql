--Assignment-3 : SQL GROUP BY and Aggregation

CREATE TABLE sales (
 order_id INT PRIMARY KEY,
 customer_id INT,
 product_id INT,
 product_name VARCHAR(50),
 quantity INT,
 unit_price DECIMAL(10, 2),
 order_date DATE
);

INSERT INTO sales (order_id, customer_id, product_id, product_name, quantity, unit_price, order_date)
VALUES
 (1, 101, 1, 'Widget A', 5, 10.00, '2023-01-15'),
 (2, 102, 2, 'Widget B', 2, 12.50, '2023-01-16'),
 (3, 103, 1, 'Widget A', 3, 10.00, '2023-01-16'),
 (4, 104, 3, 'Widget C', 1, 15.75, '2023-01-17'),
 (5, 105, 2, 'Widget B', 4, 12.50, '2023-01-17'),
 (6, 106, 1, 'Widget A', 2, 10.00, '2023-01-18'),
 (7, 107, 4, 'Widget D', 3, 20.00, '2023-01-18'),
 (8, 108, 2, 'Widget B', 5, 12.50, '2023-01-19'),
 (9, 109, 1, 'Widget A', 1, 10.00, '2023-01-19'),
 (10, 101, 3, 'Widget C', 2, 15.75, '2023-01-20');

 SELECT * FROM SALES;


----Retrieve the total sales quantity and revenue for each product.

SELECT product_name, order_id, SUM(QUANTITY) as Total_sales, SUM(UNIT_PRICE* QUANTITY) as Total_Revenue
FROM SALES
GROUP BY 1,2
ORDER BY 1;

---Find the total revenue for each customer.
SELECT customer_id,product_name, SUM(UNIT_PRICE* QUANTITY) as Total_Revenue
FROM SALES
GROUP BY 1,2
ORDER BY 1;


---Get the products with more than 10 units sold in a single order.

SELECT order_id, product_id, product_name, quantity
FROM sales
WHERE quantity >= 10
ORDER BY quantity desc;


--List the customers who have placed orders on at least three different dates.

SELECT order_id, customer_id,order_date
FROM SALES
GROUP BY 1,2,3
HAVING COUNT(DISTINCT order_date) >=3 ;

---Calculate the average unit price of products
SELECT product_id, product_name, AVG(UNIT_PRICE) as Average_price
FROM sales
GROUP BY 1,2
ORDER BY 1;


--Find the products with an average unit price greater than $12.00.

SELECT product_id, product_name, AVG(UNIT_PRICE) as Average_price
FROM sales
GROUP BY 1,2
HAVING Average_Price >= 12
ORDER BY 3;

---Retrieve the customers who have spent more than $100.00 in total.
SELECT customer_id, product_name, SUM(UNIT_PRICE * QUANTITY) as TOTAL_SPENT
FROM sales
GROUP BY 1,2
HAVING TOTAL_SPENT >= 100;

---List the customers who have purchased 'Widget B' and 'Widget A' in the same order
SELECT DISTINCT(customer_id) ,product_name
FROM SALES
GROUP BY 1,2
HAVING product_name = 'Widget B' AND product_name = 'Widget A';
