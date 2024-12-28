CREATE DATABASE sql_project_p1;
CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- Data Cleaning process

--Examining the data
SELECT * 
FROM retail_sales
LIMIT 10;


-- checking for null values

SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL 
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;
 
-- Handling null values 
-- You can either delete the rows with null values or you can replace it
-- In this project, I'm deleting the null values
DELETE FROM retail_sales
WHERE transactions_id IS NULL 
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;


-- Data Exploration

-- How many sales do you have?
SELECT COUNT(*)
FROM retail_sales;
-- How many unique customers do we have?
SELECT COUNT( DISTINCT customer_id)
FROM retail_sales;
-- How many unique category do we have?
SELECT COUNT( DISTINCT category)
FROM retail_sales;

-- Data Analysis & Business Key Problems and Answers

-- Write a SQL query to retrieve all columns made on "2022-11-05"

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Write a SQL query to retrive all transactions where the category is 'Clothing' and the quantity sold
--is more than 4 in the month of Nov 2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
	AND TO_CHAR(sale_date, 'yyyy-mm') = '2022-11'
	AND quantity >= 4
GROUP BY 1;


-- Write a SQL query to calculate the total sales(total_sales) for each category
SELECT category, SUM(total_sale) net_sales, COUNT(*) total_orders
FROM retail_sales
GROUP BY category;

-- Write an SQL query to find the average age of customers who purchased items from the 'beauty' category
SELECT category, ROUND(AVG(age), 2)AverageAge
FROM retail_sales 
WHERE category = 'Beauty'
GROUP BY 1;
-- Write an SQL query to find all transactions where the total sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Write an SQL query to find the total number of transactions( transaction_id) made by each gender in each category
SELECT category, gender, COUNT(transactions_id)
FROM retail_sales
GROUP BY 1,2
ORDER BY 1;

--Write a SQL query to calculate the average sale for each month, find out the best selling month in each year
SELECT *
FROM
(
SELECT EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) avg_sale, 
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1;


-- Write an SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id, SUM(total_sale) total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;


-- Write an SQL query to find the number of unique customers based on who purchased items from each category


SELECT category, COUNT(DISTINCT customer_id) unique_cs
FROM retail_sales
GROUP BY 1;


-- Write an SQL query to create each shift and number of orders 
--( Example morning <=12, afternoon between 12 & 17, evening >17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shift
FROM retail_sales
)
SELECT shift, COUNT(*) total_orders
FROM hourly_sale
GROUP BY shift
ORDER BY total_orders DESC;


