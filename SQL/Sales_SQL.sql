/**************************************************************
Sales Performance Analysis Script
Author: Data Analyst
Description: This script answers business questions outlined in
the Client Requirements Document for sales performance analysis.
Data Source: Sales.csv imported into #Sales temporary table.
**************************************************************/
SELECT
	ORDER_ID
	,ORDER_DATE
	,SHIP_DATE
	,SHIP_MODE
	,CUSTOMER_ID
	,CUSTOMER_NAME
	,SEGMENT
	,COUNTRY
	,CITY
	,[STATE]
	,POSTAL_CODE
	,REGION
	,PRODUCT_ID
	,CATEGORY
	,SUB_CATEGORY
	,PRODUCT_NAME
	,ROUND(SALES,2) AS SALES
FROM SALES;

---Record Count: Determine the total number of records in the dataset
SELECT
	COUNT(*) AS TOTAL_RECORDS
FROM SALES;

---Remove Records with NULL in ANY Column
DELETE FROM SALES
WHERE 
	 ORDER_ID IS NULL
	OR ORDER_DATE IS NULL
	OR SHIP_DATE IS NULL
	OR SHIP_MODE IS NULL
	OR CUSTOMER_ID IS NULL
	OR CUSTOMER_NAME IS NULL
	OR SEGMENT IS NULL
	OR COUNTRY IS NULL
	OR CITY IS NULL
	OR [STATE] IS NULL
	OR POSTAL_CODE IS NULL
	OR REGION IS NULL
	OR PRODUCT_ID IS NULL
	OR CATEGORY IS NULL
	OR SUB_CATEGORY IS NULL
	OR PRODUCT_NAME IS NULL
	OR SALES IS NULL;
/*****************************************************************
SECTION A: Overall Performance & Trends
*****************************************************************/

-- A1. Total Sales Overview: Total Revenue and Total Number of Orders
-- What is the total revenue generated, and what is the total number of orders?
SELECT
	ROUND(SUM(SALES),2) AS TOTAL_REVENUE
	,COUNT(DISTINCT ORDER_ID) AS TOTAL_NUM_OF_UNIQUE_ORDERS
FROM SALES;

-- A2. Sales Trend: Monthly Sales Trends
-- How have total sales trended over time? (Monthly)
SELECT
	 YEAR(CONVERT(DATE,ORDER_DATE,103)) AS ORDER_YEAR
	,MONTH(CONVERT(DATE,ORDER_DATE,103)) AS ORDER_MONTH
	,DATENAME(MONTH,CONVERT(DATE,ORDER_DATE, 103)) AS MONTH_NAME
	,ROUND(SUM(SALES),2) AS SALES
FROM SALES
GROUP BY
		YEAR(CONVERT(DATE,ORDER_DATE,103))
		,MONTH(CONVERT(DATE,ORDER_DATE,103))
		,DATENAME(MONTH,CONVERT(DATE,ORDER_DATE, 103))
ORDER BY
		ORDER_YEAR
	   ,ORDER_MONTH;

-- A3. Year-over-Year Growth Rate for Sales
-- Calculate the year-over-year growth rate for sales.
WITH YEARLY_SALES AS (
    SELECT
        YEAR(CONVERT(DATE, [ORDER_DATE], 103)) AS ORDER_YEAR
	   ,ROUND(SUM(SALES), 2) AS ANNUAL_SALES
    FROM SALES
    GROUP BY YEAR(CONVERT(DATE, [ORDER_DATE], 103))
)
SELECT
    ORDER_YEAR
   ,ANNUAL_SALES
   ,LAG(ANNUAL_SALES) OVER (ORDER BY ORDER_YEAR) AS PREVIOUS_YEAR_SALES
   ,ROUND(
		CASE
            WHEN LAG(ANNUAL_SALES) OVER (ORDER BY ORDER_YEAR) IS NULL THEN NULL
            ELSE ((ANNUAL_SALES - LAG(ANNUAL_SALES) OVER (ORDER BY ORDER_YEAR)) 
                  / LAG(ANNUAL_SALES) OVER (ORDER BY ORDER_YEAR)) * 100
		END,
	2)
		 AS YoYGrowthPercentage
FROM YEARLY_SALES
ORDER BY ORDER_YEAR;

/*****************************************************************
SECTION B: Product Analysis
*****************************************************************/

-- B1. Top Performers: Top 10 Products by Sales and Quantity
-- What are our top 10 products by total sales?
SELECT TOP 10
	 PRODUCT_NAME
	,SUM(SALES) AS TOTAL_SALES
FROM SALES
GROUP BY PRODUCT_NAME
ORDER BY TOTAL_SALES DESC;

-- NOTE: The analysis for "Top 10 Products by Quantity Sold" cannot be performed.
-- The required 'Quantity' field is not present in the dataset.
-- This is a data quality issue that should be addressed.

-- B2. Category & Sub-Category Performance
-- What is the total sales and average order value for each product Category?

----- What is the total sales and average order value for each product Category?
SELECT
    CATEGORY
    ,ROUND(SUM(SALES), 2) AS TOTAL_SALES
    ,ROUND(SUM(SALES) / COUNT(DISTINCT [ORDER_ID]), 2) AS AVG_ORDER_VALUE
FROM SALES
GROUP BY CATEGORY
ORDER BY TOTAL_SALES DESC;

---Performance within each Sub-Category
SELECT 
	SUB_CATEGORY
	,ROUND(SUM(SALES),2) AS TOTAL_SALES
	,ROUND(SUM(SALES)/COUNT(DISTINCT [ORDER_ID]),2) AS AVG_ORDER_VALUE
FROM SALES
GROUP BY SUB_CATEGORY
ORDER BY TOTAL_SALES DESC;

-- B3. Product Portfolio: Number of unique products
-- How many unique products do we sell?
SELECT
	COUNT(DISTINCT PRODUCT_ID) AS UNIQUE_PRODUCTS_COUNT
FROM SALES
ORDER BY UNIQUE_PRODUCTS_COUNT DESC;

/*****************************************************************
SECTION C: Customer Analysis
*****************************************************************/
-- C1. Customer Segmentation
-- Who are our top 10 customers by total spending?
SELECT TOP 10
	CUSTOMER_NAME
	,ROUND(SUM(SALES),2) AS TOTAL_SPENDING
FROM SALES
GROUP BY CUSTOMER_NAME
ORDER BY TOTAL_SPENDING DESC;

-- What is the sales distribution across different Segments?
SELECT
	SEGMENT
	,ROUND(SUM(SALES),2) AS TOTAL_SALES
	,ROUND((SUM(SALES)/(SELECT SUM(SALES) FROM SALES))*100,2) AS SALES_PERCENTAGE
FROM SALES
GROUP BY SEGMENT
ORDER BY TOTAL_SALES DESC;

-- C2. Customer Value: Average sales value per customer
-- What is the average sales value per customer?
SELECT
    ROUND(SUM(SALES) / COUNT(DISTINCT [CUSTOMER_ID]), 2) AS AVG_SALES_PERCUSTOMER
FROM SALES;

---------------------------------------------------------------------
--SECTION D. Geographic Analysis
---------------------------------------------------------------------

-- D1. Regional Performance
-- How do sales differ across various Regions and States?
SELECT
	REGION
	,[STATE]
	,ROUND(SUM(SALES),2) AS TOTAL_SALES
FROM SALES
GROUP BY REGION,[STATE]
ORDER BY REGION,TOTAL_SALES DESC;

-- Which City is our top-performing city by sales?
SELECT TOP 1
	CITY
	,[STATE]
	,ROUND(SUM(SALES),2) AS TOTAL_SALES
FROM SALES
GROUP BY CITY, [STATE]
ORDER BY CITY,TOTAL_SALES;

-- D2. Country Focus: Top 5 and Bottom 5 States by Revenue
-- Since all sales are in the US, which states are the top 5 and bottom 5 contributors to revenue?
WITH STATE_SALES  AS(
	SELECT
		[STATE]
		,ROUND(SUM(SALES),2) AS TOTAL_SALES
	FROM SALES
	GROUP BY [STATE]
),
RANKED_STATES AS(
	SELECT
		[STATE]
		,TOTAL_SALES
		,RANK() OVER(ORDER BY TOTAL_SALES DESC) AS TOP_RANK
		,RANK() OVER(ORDER BY TOTAL_SALES ASC) AS BOTTOM_RANK
	FROM STATE_SALES
)
SELECT 'TOP 5' AS RANK_TYPE,[STATE],TOTAL_SALES
FROM RANKED_STATES
WHERE TOP_RANK<=5
UNION ALL
SELECT 'BOTTOM 5' AS RANK_TYPE,[STATE],TOTAL_SALES
FROM RANKED_STATES
WHERE BOTTOM_RANK<=5
ORDER BY RANK_TYPE DESC,TOTAL_SALES DESC;

---------------------------------------------------------------------
--SECTION E. Operational Analysis
---------------------------------------------------------------------
---E1. Shipping Analysis
---Most commonly used Ship Mode
SELECT
	SHIP_MODE
	,COUNT(*) AS NUM_OF_ORDERS
FROM SALES
GROUP BY SHIP_MODE
ORDER BY NUM_OF_ORDERS DESC;

---Correlation between Ship Mode and average sales value/profit
SELECT
	SHIP_MODE
	,COUNT(DISTINCT ORDER_ID) AS NUM_OF_ORDERS
	,ROUND(AVG(SALES),2) AS AVG_SALES_VALUE
FROM SALES
GROUP BY SHIP_MODE
ORDER BY AVG_SALES_VALUE DESC;

---E2. Sales Velocity
---The average number of days between Order Date and Ship Date
SELECT 
	AVG(DATEDIFF(DAY,ORDER_DATE,SHIP_DATE)) AS AVG_DAYS_TO_SHIP
FROM SALES;
