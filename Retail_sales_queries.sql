
-- SQL Retail Sales Analysis --

--Create Table
DROP TABLE IF EXISTS Retail_sales;
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(6),
	age INT,
	category VARCHAR(20),
	quantiy INT,
	price_per_unit INT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales LIMIT 10;

---DATA CLEANING---

--Null Value Check: Check for any null values in the dataset and delete records with missing data.
SELECT * FROM Retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

---
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

---


--DATA EXPLORATION--

--Record Count: Determine the total number of records in the dataset.
SELECT COUNT(*) FROM retail_sales;

--Customer Count: Find out how many unique customers are in the dataset.
SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales; 

--Category Count: Identify all unique product categories in the dataset.
SELECT DISTINCT(category) FROM retail_sales; 



--DATA ANALYSING AND FINDINGS--

--1. Retrieve all coulmns for sales made on '2022-11-05'.
SELECT transactions_id, sale_date FROM retail_sales WHERE sale_date = '2022-11-05';

--2. Retrieve all transactions where the category is "Clothing" and the quantity sold is more than 4 in the month of Nov - 2022.
SELECT * FROM retail_sales WHERE 
category = 'Clothing' AND  TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' AND quantiy >= 4;

--3. Calculate the total sale for each category.
SELECT category, SUM(total_sale) AS total_sales, COUNT(*) as total_orders FROM retail_sales GROUP BY category;

--4. Find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) AS average_age FROM retail_sales WHERE category = 'Beauty';

--5. Find all transactions where the total_sale is greater than 1000.
SELECT transactions_id FROM retail_sales WHERE total_sale > 1000;

--6. Find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(transactions_id) AS total_transc FROM 
retail_sales GROUP BY category, gender ORDER BY 1;

--7. Calculate the average sale for each month. Find out best selling month in each year.
SELECT * FROM --created a sub query
(
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_sales,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales GROUP BY 1, 2 
) AS a1 WHERE rank = 1;

--8. Find the top 5 customers based on the highest total sales.
SELECT customer_id, SUM(total_sale) FROM retail_sales GROUP BY 1 ORDER BY 2 DESC LIMIT 5;

--9. Find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT(customer_id)) AS customer_count FROM retail_sales GROUP BY 1;

--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)4
--Creating CTE(Common Table Expression)
WITH Hourly_sales AS (
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'  
		ELSE 'Evening'
	END AS shift
FROM retail_sales
) SELECT shift, COUNT(*) AS total_orders FROM Hourly_sales GROUP BY shift ;

--END--