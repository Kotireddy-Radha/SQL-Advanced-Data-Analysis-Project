
--Which Categories contributes the most to overall sales
SELECT 
category,
Total_Revenue,
SUM(Total_Revenue) OVER() AS Overall_Sales,
CONCAT(ROUND((CAST(Total_Revenue AS FLOAT)/SUM(Total_Revenue) OVER())*100,2),'%') AS '%OfSales'
FROM 
(SELECT 
p.category,
SUM(f.sales_amount) AS Total_Revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
ON f.product_key=p.product_key
GROUP BY p.category)t
ORDER BY Total_Revenue DESC
