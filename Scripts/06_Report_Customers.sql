/* 
===========================================================================================================
Customer Report
===========================================================================================================
Purpose: 
	- This report consolidates key customer metrics and behaviours 
Highlights:
	1. Gather essential fields such as Names, ages, and transaction details.
	2. Segment Customers in to 3 categories (VIP, Regular, New) and age groups
	3. Aggregate Customer Level metrics:
		- Total Orders
		- Total Sales
		- Total Quantity Purchased
		- Total Products
		- Lifespan (in Months)
	4. Calculate Valuable KPI's
		- Recency (months since last order)
		- Average Order Value
		- Average Monthly spends
==============================================================================================================
*/
CREATE VIEW gold.report_customers 
AS
WITH Base_Query AS (
/*------------------------------------------------------------------------------------------------------------
1. Base Query: Retrives core fields from tables
-------------------------------------------------------------------------------------------------------------*/
SELECT 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_id,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
DATEDIFF(YEAR, c.birthdate,CURRENT_DATE) AS Age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL),
Customer_aggregation AS (
/*------------------------------------------------------------------------------------------------------------
2. Customer Aggregations: Summarizes key metrics at the customer level
-------------------------------------------------------------------------------------------------------------*/
SELECT 
	Customer_Name,
	customer_key,
	customer_number,
	Age,
	MAX(order_date) AS Last_order,
	COUNT( DISTINCT order_number) AS Total_Orders,
	SUM(sales_amount) AS Total_Sales,
	SUM(quantity) AS Total_Qty_Purchased,
	COUNT(DISTINCT product_key) AS Total_Products,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS Lifespan
FROM Base_Query
GROUP BY 
	Customer_Name,
	customer_key,
	customer_number,
	Age
)
SELECT
Customer_Name,
customer_key,
customer_number,
Age,
CASE WHEN Age <20 THEN 'Under 20'
	 WHEN Age BETWEEN 21 AND 40 THEN '21-40'
	 WHEN Age BETWEEN 41 AND 60 THEN '41-60'
	 WHEN Age BETWEEN 61 AND 80 THEN '61-80'
	 WHEN Age BETWEEN 81 AND 100 THEN '81-100'
	 ELSE 'Above 100'
END Age_Group,
Lifespan,
CASE WHEN Total_Sales >5000 AND Lifespan >=12 THEN 'VIP'
	 WHEN Total_Sales <=5000 AND Lifespan >=12 THEN 'Regular'
	 ELSE 'New'
END Customer_category,
Last_Order,
DATEDIFF(MONTH,Last_order, CURRENT_DATE) AS Recency,
Total_orders,
Total_Sales,
Total_Qty_Purchased,
Total_Products,
--Compute Average order Value 
CASE WHEN Total_Orders = 0 THEN 0
	 ELSE Total_Sales/Total_Orders 
END Average_Order_Value,
--Compute Average Monthly Spends
CASE WHEN Lifespan =0 THEN Total_sales
	 ELSE Total_sales/Lifespan
END Average_Monthly_Spends
FROM Customer_aggregation
