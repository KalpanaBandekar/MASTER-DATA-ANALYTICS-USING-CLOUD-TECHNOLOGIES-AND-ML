---Assignment - 4 : SQL WHERE Clause and Logical Operators

CREATE TABLE customers (
 customer_id INT PRIMARY KEY,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 gender VARCHAR(10),
 city VARCHAR(50),
 age INT
);

INSERT INTO customers (customer_id, first_name, last_name, gender, city, age)
VALUES
 (1, 'John', 'Doe', 'Male', 'New York', 35),
 (2, 'Jane', 'Smith', 'Female', 'Los Angeles', 28),
 (3, 'Michael', 'Johnson', 'Male', 'Chicago', 45),
 (4, 'Emily', 'Davis', 'Female', 'Houston', 22),
 (5, 'David', 'Wilson', 'Male', 'Miami', 40),
 (6, 'Lisa', 'Brown', 'Female', 'New York', 32),
 (7, 'William', 'Lee', 'Male', 'Los Angeles', 29),
 (8, 'Sarah', 'White', 'Female', 'Chicago', 50),
 (9, 'James', 'Harris', 'Male', 'Houston', 37),
 (10, 'Maria', 'Martin', 'Female', 'Miami', 24);


SELECT * FROM CUSTOMERS;

---Retrieve the first and last names of all customers.

SELECT first_name, last_name
FROM CUSTOMERS;

---Find the total number of customers in the dataset.
SELECT COUNT(DISTINCT customer_id) AS Total_Customers
FROM CUSTOMERS;

--Get the names of male customers.
SELECT customer_id, concat(first_name, ' ', last_name) as Customer_name,UPPER(gender)
FROM CUSTOMERS
WHERE gender= 'Male'
ORDER BY 1;


---Find customers who are aged 30 or older.
SELECT customer_id, concat(first_name, ' ', last_name) as Customer_name, age
FROM CUSTOMERS
WHERE age >= 30
ORDER BY 1;

---List customers from New York.
SELECT customer_id, concat(first_name, ' ', last_name) as Customer_name,city
FROM CUSTOMERS
WHERE city = 'New York'
ORDER BY 1;

---Retrieve customers whose first name starts with 'J'.
SELECT customer_id, concat(first_name, ' ', last_name) as Customer_name
FROM CUSTOMERS
WHERE first_name LIKE 'J%'
ORDER BY 1;

--Find customers aged between 25 and 35 (inclusive).
SELECT customer_id, concat(first_name, ' ', last_name) as Customer_name, age
FROM CUSTOMERS
WHERE age between 25 and 35
ORDER BY 1;

--Get female customers from Los Angeles or male customers from Chicago.
SELECT customer_id, concat(first_name, ' ', last_name) as Customer_name,city,age
FROM CUSTOMERS
WHERE (gender = 'Female' and city='Los Angeles') or (gender = 'Male' and city='Chicago')
ORDER BY 1;

---. List customers who are either from Miami or aged 50 or older
SELECT customer_id, concat(first_name, ' ', last_name) as Customer_name,city,age
FROM CUSTOMERS
WHERE city='Miami' or age>= 50
ORDER BY 1;

--Find customers with names 'John' or 'Jane' and aged less than 30.
SELECT customer_id, first_name, age
FROM CUSTOMERS
WHERE (first_name = 'John' or first_name = 'Jane') and age < 30
ORDER BY 1;