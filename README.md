**Sales Performance Analysis**

**Project Overview**

This project delivers a comprehensive sales performance analysis based on raw transactional data. Using SQL (Microsoft SQL Server Management Studio), the sales dataset (Sales.csv) is transformed into actionable insights that help identify performance trends, customer value, product profitability, and geographic strengths.

The analysis was conducted in response to the Client Requirements Document, with the ultimate goal of enabling data-driven decision-making for future business strategy.

**Repository Contents**

Sales.csv – The raw sales dataset containing order-level transactional data.

Sales_SQL.sql – A fully documented SQL script containing all queries used to perform the analysis. Queries are organized by business questions (with comments for clarity).

Client Requirements Document.pdf – A stakeholder requirements document outlining the scope, objectives, and key business questions.

**Business Objectives**

The analysis addresses the following areas of interest:

Overall Performance & Trends

Total revenue and order volume.

Monthly/quarterly sales trends.

Year-over-year growth rates.

Product Analysis

Top 10 products by sales and quantity sold.

Category and sub-category performance.

Unique product count.

Customer Analysis

Top 10 customers by spending.

Sales distribution across segments (Consumer, Corporate, Home Office).

Average sales per customer.

Geographic Analysis

Regional and state-level performance.

Top-performing cities.

Top 5 and bottom 5 states by revenue.

Operational Analysis

Most common shipping modes.

Correlation between shipping mode and sales/profit.

Average shipping time (order to delivery).

**Tools & Technologies**

SQL Server Management Studio (SSMS) – Used to write and execute all queries.

Dataset Format – CSV file with sales transactions.

SQL Features – Aggregations, grouping, window functions, and date conversions (to handle DD/MM/YYYY format).

**How to Use**

Import the Dataset

Load Sales.csv into your SQL Server environment.

Ensure data types (especially dates) are correctly formatted.

Run the SQL Script

Open Sales_SQL.sql in SQL Server Management Studio.

Execute the script sequentially from top to bottom.

Each section is clearly commented to indicate which business question it answers.

Review Results

Query outputs will provide the required insights.

Use the results to create dashboards, visualizations, or management reports as needed.

**Success Criteria**

The project is considered successful if:

The SQL script runs without errors.

All business questions outlined in the requirements document are answered.

The analysis provides clear, concise, and actionable insights for non-technical stakeholders.

**Future Enhancements**

Develop interactive dashboards in Power BI or Tableau for better visualization.

Automate analysis pipelines for real-time insights.

Expand the dataset to include additional KPIs (e.g., profit margins, marketing costs).

**Author**

Data Analyst

Role: Business Insights & SQL Analysis

Deliverables: Data exploration, SQL scripting, business insights reporting
