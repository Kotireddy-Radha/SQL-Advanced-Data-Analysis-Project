/*
===========================================================================================================
Product Report
===========================================================================================================
Purpose: 
	- This report consolidates key Product metrics and behaviours 
Highlights:
	1. Gather essential fields such as Product Names, Category,Subcategory, and Cost details.
	2. Segment Product by Revenue to identify High-performers, Mid-Range, or Low-performers.
	3. Aggregate Product Level metrics:
		- Total Orders
		- Total Sales
		- Total Quantity Sold
		- Total Customers (Unique)
		- Lifespan (in Months)
	4. Calculate Valuable KPI's
		- Recency (months since last Sale)
		- Average Order Revenue
		- Average Monthly Revenue
==============================================================================================================
*/
CREATE VIEW gold.report_Product AS 
WITH Base_query AS (
/*------------------------------------------------------------------------------------------------------------
1. Base Query: Retrieves core fields from tables
-------------------------------------------------------------------------------------------------------------*/
SELECT 
f.order_number,
f.customer_key,
f.order_date,
f.sales_amount,
f.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost 
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
WHERE order_date IS NOT NULL
),
Key_metrics AS(
/*------------------------------------------------------------------------------------------------------------
2. Product Aggregations: Summarizes key metrics at the Product level
-------------------------------------------------------------------------------------------------------------*/
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
MAX(order_date) AS Last_Order_Date,
DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS Lifespan,
COUNT(DISTINCT order_number) AS Total_Orders,
SUM(Sales_amount) AS Total_Revenue,
SUM(quantity) AS Total_qty_sold,
COUNT(DISTINCT(customer_key)) AS Total_customers
--AVG(CAST(SUM(Sales_amount) AS FLOAT)/NULLIF(quantity,0)) AS Avg_Selling_Price
FROM Base_query
GROUP BY 
	product_name,
	category,
	subcategory,
	cost,
	product_key
)
--Main Query
SELECT 
product_name
category,
subcategory,
cost,
Last_Order_date,
DATEDIFF(MONTH,Last_Order_Date,GETDATE()) AS Recency_In_Months,
CASE WHEN Total_Revenue >10000 THEN 'High-performers'
	 WHEN Total_Revenue BETWEEN 5000 AND 10000 THEN 'Mid-range'
	 ELSE 'Low-performers'
END Product_Segment,
Lifespan,
Total_Orders,
Total_Revenue,
Total_Customers,
--Average Order Revenue
CASE WHEN Total_Orders = 0 THEN 0
	 ELSE Total_Revenue/Total_Orders
END Avg_Order_Revenue,
--Average Monthly Revenue
CASE WHEN Lifespan = 0 THEN Total_Revenue
	 ELSE Total_Revenue/Lifespan
END Avg_Monthly_Revenue
FROM Key_metrics


