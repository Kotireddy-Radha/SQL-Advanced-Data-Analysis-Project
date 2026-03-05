**Skills: SQL | Data Analysis | Window Functions | Data Segmentation | Business Analytics**

# SQL-Advanced-Data-Analysis-Project
Advanced SQL Data Analysis Project using Microsoft SQL Server.

## Project Overview
This project demonstrates **advanced SQL analytics techniques** applied to a retail sales dataset.

The objective is to analyze **sales trends, customer behavior, and product performance** 
using SQL queries and analytical functions.

**The project includes multiple types of analysis such as:**
 . Trend analysis
 . cumulative Analysis
 . Performance analysis
 . Part To Whole analysis
 . Data Segmentation
 . Analytical Report Generation

## Database Structure
The analysis is performed using a **star schema** data model.
- Fact Table: 
    . gold.fact_sales
- Dimension Tables:
    . gold.dim_customers
    . gold.dim_products

## Analysis Performed
**1️. Change Over Time Analysis**
    Analyzing how business metrics evolve across time (yearly and monthly trends).

**2️. Cumulative Analysis**
    Calculating running totals and moving averages to track sales performance over time.

**3️. Performance Analysis**
    Comparing product sales across different years and evaluating changes in performance.

**4️. Part-to-Whole Analysis**
    Determining how much each product category contributes to total revenue.
    
**5️. Data Segmentation Analysis**
    Segmenting:
    Products by cost range
    Customers by spending behavior

**6️. Report Generation**
    Creating SQL views for business reporting:
    Customer Analytics Report
    Product Performance Report

## SQL Concepts Used
- SELECT, WHERE, ORDER BY, GROUP BY
- Date Functions (YEAR, DATETRUNC, DATEDIFF)    
- Aggregate functions (SUM, COUNT, AVG, MIN, MAX)
- JOIN
- Window functions (SUM() OVER(), AVG() OVER(), LAG() OVER())
- CASE WHEN
- CAST, ROUND, CONCAT
- CTEs (Common Table Expressions)
- SQL Views

## Documentation
Detailed tasks, SQL queries, and outputs are available
in the documentation folder.

## Author
Radha – Aspiring Data Analyst
