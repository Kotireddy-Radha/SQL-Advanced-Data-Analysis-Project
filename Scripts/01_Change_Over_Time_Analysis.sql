
--Yearly Trends Analysis 
SELECT 
YEAR(order_date) AS Order_Year, 
SUM(sales_amount) AS 'Total Revenue',
COUNT(DISTINCT customer_key) AS Total_customers,
SUM(quantity) Total_Qty
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

--Monthly Trends Analysis 
SELECT 
DATETRUNC(MONTH,order_date) AS Order_Date, 
SUM(sales_amount) AS 'Total Revenue',
COUNT(DISTINCT customer_key) AS Total_customers,
SUM(quantity) Total_Qty
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
ORDER BY DATETRUNC(MONTH,order_date)

