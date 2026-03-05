
/*Analyze the Yearly Performance of products by comparing each product's sales to 
both its average sales performance and the previous year's sales */

--Creating CTE-Common Table Expression
WITH Yearly_Product_Sales AS (
SELECT 
YEAR(f.order_date) AS Order_Year, 
p.product_name, 
SUM(f.sales_amount) AS Current_Sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
ON p.product_key=f.product_key
WHERE f.order_date IS NOT NULL
GROUP BY 
p.product_name, 
YEAR(order_date)
)

SELECT 
Order_Year,
product_name,
Current_Sales,
AVG(Current_Sales) OVER(PARTITION BY product_name) AS Avg_Sales,
Current_Sales-AVG(Current_Sales) OVER(PARTITION BY product_name) AS Diff_Avg,
CASE 
	WHEN Current_Sales-AVG(Current_Sales) OVER(PARTITION BY product_name) >0 THEN 'Above Avg'
	WHEN Current_Sales-AVG(Current_Sales) OVER(PARTITION BY product_name) <0 THEN 'Below Avg'
	ELSE 'Avg'
END Avg_change,
--Year-over-year Analysis
LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) AS Previous_Year_Sales,
Current_Sales-LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) AS Diff_Py,
CASE
	WHEN Current_Sales-LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year)>0 THEN 'Increase'
	WHEN Current_Sales-LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) <0 THEN 'Decrease'
	ELSE 'No Change'
END Py_Change
FROM Yearly_Product_Sales
ORDER BY product_name, Order_Year
