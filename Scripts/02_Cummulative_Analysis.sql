
--Calculate the Total Sales per month and the running total and Moving Average of sales over time
SELECT 
Order_Date,
Total_Sales,
SUM(Total_Sales) OVER(PARTITION BY YEAR(order_date) ORDER BY Order_Date) AS Running_Total,
AVG(Avg_Price) OVER(PARTITION BY YEAR(order_date) ORDER BY Order_Date) AS Moving_Aveage
FROM(
	SELECT 
	DATETRUNC(MONTH,order_date) AS Order_Date,
	SUM(sales_amount) AS Total_Sales,
	AVG(price) AS Avg_Price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH,order_date)
)t
