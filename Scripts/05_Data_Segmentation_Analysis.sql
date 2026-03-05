
/* Segment products into cost ranges and 
count how many products fall into each category*/
WITH Cost_Segment AS (
SELECT
product_name,
cost,
CASE WHEN cost BETWEEN 0 AND 300 THEN '0-300'
	WHEN cost BETWEEN 301 AND 600 THEN '301-600'
	WHEN cost BETWEEN 601 AND 900 THEN '601-900'
	WHEN cost BETWEEN 901 AND 1200 THEN '901-1200'
	WHEN cost BETWEEN 1201 AND 1500 THEN '1201-1500'
	ELSE '1500 +'
END Cost_range
FROM gold.dim_products)
SELECT 
Cost_range,
COUNT(product_name) AS Total_Products
FROM Cost_Segment
GROUP BY Cost_range
ORDER BY COUNT(product_name) DESC

/* Group Customers into three Segments based on their Spending behaviour:
	- VIP : Customers with at least 12 Months of history and spending more than $5,000.
	- REGULAR : Customers with at least 12 Months of history and spending $5,000 or less.
	- NEW : Customers with Lifespan less than 12 months
and find the total number of customers by each Group*/
--1st CTE
WITH Order_Details AS (
SELECT
customer_key,
SUM(sales_amount) AS Total_Sales,
DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS LifeSpan
FROM gold.fact_sales
GROUP BY customer_key),
--2nd CTE
Segment_details AS (
SELECT *,
CASE WHEN Total_Sales >5000 AND LifeSpan >= 12 THEN 'VIP'
	WHEN Total_Sales <=5000 AND LifeSpan >= 12 THEN 'REGULAR'
	ELSE 'NEW'
END Segment_Category
FROM Order_Details)
--Main Query
SELECT 
Segment_Category, 
COUNT(customer_key) AS Customer_count 
FROM Segment_details 
GROUP BY Segment_Category
ORDER BY COUNT(customer_key) DESC



