-- ============================================================================
-- AI-Powered Sales Forecasting Dashboard
-- CUSTOMER ANALYSIS (12 Queries: Q16–Q27)
-- ============================================================================
-- Schema: fact_sales → dim_customer (via customer_key)
-- ============================================================================

USE sales_forecasting;

-- Q16. Top 10 Customers by Revenue
SELECT c.customer_name, c.segment, c.country,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.customer_name, c.segment, c.country
ORDER BY SUM(f.sales) DESC LIMIT 10;

-- Q17. Bottom 10 Customers by Profitability
SELECT c.customer_name, c.segment, c.country,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.customer_name, c.segment, c.country
ORDER BY SUM(f.profit) ASC LIMIT 10;

-- Q18. Repeat Customers (More than 1 order)
SELECT c.customer_name, c.segment,
    COUNT(DISTINCT f.order_id) AS order_count,
    FORMAT(SUM(f.sales),2) AS total_sales
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.customer_name, c.segment
HAVING order_count > 1
ORDER BY order_count DESC LIMIT 20;

-- Q19. Customer Order Frequency Distribution
SELECT order_bucket, COUNT(*) AS num_customers FROM (
    SELECT c.customer_key,
        CASE 
            WHEN COUNT(DISTINCT f.order_id) = 1 THEN '1 order'
            WHEN COUNT(DISTINCT f.order_id) <= 5 THEN '2-5 orders'
            WHEN COUNT(DISTINCT f.order_id) <= 10 THEN '6-10 orders'
            ELSE '10+ orders'
        END AS order_bucket
    FROM fact_sales f
    JOIN dim_customer c ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
) sub GROUP BY order_bucket;

-- Q20. Customer Lifetime Value — Top 15
SELECT c.customer_name, c.segment, c.country,
    FORMAT(SUM(f.sales),2) AS lifetime_revenue,
    FORMAT(SUM(f.profit),2) AS lifetime_profit,
    COUNT(DISTINCT f.order_id) AS total_orders,
    MIN(f.order_date) AS first_order,
    MAX(f.order_date) AS last_order,
    DATEDIFF(MAX(f.order_date), MIN(f.order_date)) AS tenure_days,
    ROUND(SUM(f.sales)/COUNT(DISTINCT f.order_id),2) AS avg_order_value
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.customer_name, c.segment, c.country
ORDER BY SUM(f.sales) DESC LIMIT 15;

-- Q21. Average CLV by Segment
SELECT c.segment,
    COUNT(DISTINCT c.customer_key) AS customer_count,
    FORMAT(SUM(f.sales),2) AS total_revenue,
    ROUND(SUM(f.sales)/COUNT(DISTINCT c.customer_key),2) AS avg_clv,
    ROUND(COUNT(DISTINCT f.order_id)*1.0/COUNT(DISTINCT c.customer_key),1) AS avg_orders
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.segment ORDER BY avg_clv DESC;

-- Q22. Segment Performance Overview
SELECT c.segment,
    COUNT(DISTINCT c.customer_key) AS num_customers,
    COUNT(DISTINCT f.order_id) AS num_orders,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct,
    ROUND(SUM(f.sales)*100.0/(SELECT SUM(sales) FROM fact_sales),2) AS revenue_share_pct
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.segment ORDER BY SUM(f.sales) DESC;

-- Q23. Segment Trend by Year
SELECT d.year, c.segment,
    FORMAT(SUM(f.sales),2) AS revenue,
    COUNT(DISTINCT c.customer_key) AS active_customers
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, c.segment
ORDER BY d.year, SUM(f.sales) DESC;

-- Q24. Top 15 Customer Countries
SELECT c.country,
    COUNT(DISTINCT c.customer_key) AS num_customers,
    FORMAT(SUM(f.sales),2) AS total_sales,
    ROUND(SUM(f.sales)/COUNT(DISTINCT c.customer_key),2) AS avg_clv
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.country ORDER BY SUM(f.sales) DESC LIMIT 15;

-- Q25. Single-Order Customers (Churn Risk)
SELECT c.customer_name, c.segment, c.country,
    MAX(f.order_date) AS only_order_date,
    FORMAT(SUM(f.sales),2) AS total_sales
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.customer_name, c.segment, c.country
HAVING COUNT(DISTINCT f.order_id) = 1
ORDER BY SUM(f.sales) DESC LIMIT 20;

-- Q26. Customers Inactive Since Before 2014
SELECT c.customer_name, c.segment,
    MAX(f.order_date) AS last_order_date,
    COUNT(DISTINCT f.order_id) AS total_orders,
    FORMAT(SUM(f.sales),2) AS total_sales
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.customer_name, c.segment
HAVING MAX(f.order_date) < '2014-01-01'
ORDER BY SUM(f.sales) DESC LIMIT 20;

-- Q27. New vs Returning Customers by Year
SELECT d.year,
    COUNT(DISTINCT CASE WHEN f.order_date = fo.first_order THEN f.customer_key END) AS new_customers,
    COUNT(DISTINCT CASE WHEN f.order_date > fo.first_order THEN f.customer_key END) AS returning_customers
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
JOIN (SELECT customer_key, MIN(order_date) AS first_order FROM fact_sales GROUP BY customer_key) fo
    ON f.customer_key = fo.customer_key
GROUP BY d.year ORDER BY d.year;
