---Create a table named employees with the following structure:

CREATE or Replace TABLE employees (
 employee_id INT PRIMARY KEY,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 department VARCHAR(50),
 hire_date DATE,
 salary INT
);


---Create a table named employees with the following structure:

INSERT INTO employees (employee_id, first_name, last_name, department, hire_date, salary)
VALUES
 (1, 'John', 'Doe', 'HR', '2020-01-15', 50000),
 (2, 'Jane', 'Smith', 'IT', '2019-04-20', 60000),
 (3, 'Michael', 'Johnson', 'Finance', '2021-08-10', 55000),
 (4, 'Emily', 'Davis', 'Marketing', '2018-02-05', 52000),
 (5, 'David', 'Wilson', 'IT', '2022-03-30', 62000);

 SELECT * FROM EMPLOYEES;


---Retrieve the first and last names of all employees

SELECT first_name, last_name From EMPLOYEES;


---Find the total number of employees in the company.

SELECT COUNT(employee_id) as Total_no_of_Employee FROM EMPLOYEES;

---Get the names of employees who work in the IT department.

SELECT CONCAT(first_name,' ' ,last_name) as Employee_Names 
From EMPLOYEES
WHERE department= 'IT';

---Calculate the average salary of all employees

SELECT AVG(salary) as Average_Salary
FROM employees;


--- Find the employee with the highest salary.
SELECT employee_id, CONCAT(first_name,' ' ,last_name) as Employee_Name , salary
from employees
order by salary desc
limit 1;

---List the employees hired before January 1, 2021, along with their hire dates.
SELECT employee_id, concat(first_name,' ', last_name) as Emp_Name, department, hire_date
FROM EMPLOYEES
WHERE hire_date < '2021-01-01'
ORDER BY 1;
