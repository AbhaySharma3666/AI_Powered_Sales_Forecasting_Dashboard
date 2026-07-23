-- ============================================================================
-- AI-Powered Sales Forecasting Dashboard
-- ADVANCED SQL ANALYSIS (12 Queries: Q49–Q60)
-- CTEs, Subqueries, Window Functions: RANK, DENSE_RANK, LAG, LEAD, NTILE
-- ============================================================================

USE sales_forecasting;

-- Q49. Region Revenue Ranking with RANK()
SELECT r.region,
    FORMAT(SUM(f.sales),2) AS total_sales,
    RANK() OVER (ORDER BY SUM(f.sales) DESC) AS sales_rank
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
GROUP BY r.region;

-- Q50. Product Revenue Ranking with DENSE_RANK() — Top 20
SELECT p.product_name, p.category,
    FORMAT(SUM(f.sales),2) AS total_sales,
    DENSE_RANK() OVER (ORDER BY SUM(f.sales) DESC) AS sales_rank
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_key, p.product_name, p.category
LIMIT 20;

-- Q51. Month-over-Month Revenue Change with LAG()
WITH monthly AS (
    SELECT d.year, d.month, d.month_name,
        SUM(f.sales) AS monthly_sales
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY d.year, d.month, d.month_name
)
SELECT year, month_name,
    FORMAT(monthly_sales,2) AS revenue,
    FORMAT(LAG(monthly_sales) OVER (ORDER BY year, month),2) AS prev_month,
    ROUND((monthly_sales - LAG(monthly_sales) OVER (ORDER BY year, month))
        / LAG(monthly_sales) OVER (ORDER BY year, month) * 100, 2) AS mom_growth_pct
FROM monthly ORDER BY year, month;

-- Q52. Next Month Comparison with LEAD()
WITH monthly AS (
    SELECT d.year, d.month, d.month_name,
        SUM(f.sales) AS monthly_sales
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY d.year, d.month, d.month_name
)
SELECT year, month_name,
    FORMAT(monthly_sales,2) AS current_revenue,
    FORMAT(LEAD(monthly_sales) OVER (ORDER BY year, month),2) AS next_month_revenue
FROM monthly;

-- Q53. Year-over-Year Growth (CTE + LAG)
WITH yearly AS (
    SELECT d.year,
        SUM(f.sales) AS annual_sales,
        SUM(f.profit) AS annual_profit
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY d.year
)
SELECT year,
    FORMAT(annual_sales,2) AS revenue,
    FORMAT(annual_profit,2) AS profit,
    FORMAT(LAG(annual_sales) OVER (ORDER BY year),2) AS prev_year,
    ROUND((annual_sales - LAG(annual_sales) OVER (ORDER BY year))
        / LAG(annual_sales) OVER (ORDER BY year) * 100, 2) AS yoy_growth_pct
FROM yearly;

-- Q54. Running Total Revenue (Cumulative Sum)
WITH daily AS (
    SELECT f.order_date, SUM(f.sales) AS daily_sales
    FROM fact_sales f GROUP BY f.order_date
)
SELECT order_date,
    FORMAT(daily_sales,2) AS daily_revenue,
    FORMAT(SUM(daily_sales) OVER (ORDER BY order_date),2) AS running_total
FROM daily ORDER BY order_date;

-- Q55. 3-Month Moving Average Revenue
WITH monthly AS (
    SELECT d.year, d.month,
        SUM(f.sales) AS monthly_sales
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY d.year, d.month
)
SELECT year, month,
    FORMAT(monthly_sales,2) AS revenue,
    FORMAT(AVG(monthly_sales) OVER (
        ORDER BY year, month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ),2) AS moving_avg_3m
FROM monthly ORDER BY year, month;

-- Q56. Top 3 Products per Category (Window + CTE)
WITH ranked AS (
    SELECT p.category, p.product_name,
        SUM(f.sales) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(f.sales) DESC) AS rn
    FROM fact_sales f
    JOIN dim_product p ON f.product_key = p.product_key
    GROUP BY p.category, p.product_key, p.product_name
)
SELECT category, product_name, FORMAT(total_sales,2) AS sales
FROM ranked WHERE rn <= 3
ORDER BY category, total_sales DESC;

-- Q57. Customer Percentile Ranking (PERCENT_RANK + NTILE)
SELECT c.customer_name, c.segment,
    FORMAT(SUM(f.sales),2) AS total_sales,
    ROUND(PERCENT_RANK() OVER (ORDER BY SUM(f.sales)) * 100, 1) AS percentile,
    NTILE(4) OVER (ORDER BY SUM(f.sales) DESC) AS quartile
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.customer_name, c.segment;

-- Q58. Cumulative Revenue Share by Category (Pareto)
WITH cat_sales AS (
    SELECT p.category, SUM(f.sales) AS total_sales
    FROM fact_sales f
    JOIN dim_product p ON f.product_key = p.product_key
    GROUP BY p.category
)
SELECT category,
    FORMAT(total_sales,2) AS category_sales,
    FORMAT(SUM(total_sales) OVER (ORDER BY total_sales DESC),2) AS cumulative_sales,
    ROUND(SUM(total_sales) OVER (ORDER BY total_sales DESC)
        / SUM(total_sales) OVER () * 100, 2) AS cumulative_pct
FROM cat_sales;

-- Q59. Market Quarterly Growth with LAG (Multi-dimensional)
WITH market_qtr AS (
    SELECT r.market, d.year, d.quarter,
        SUM(f.sales) AS qtr_sales
    FROM fact_sales f
    JOIN dim_region r ON f.region_key = r.region_key
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY r.market, d.year, d.quarter
)
SELECT market, year, CONCAT('Q', quarter) AS qtr,
    FORMAT(qtr_sales,2) AS revenue,
    FORMAT(LAG(qtr_sales) OVER (PARTITION BY market ORDER BY year, quarter),2) AS prev_qtr,
    ROUND((qtr_sales - LAG(qtr_sales) OVER (PARTITION BY market ORDER BY year, quarter))
        / LAG(qtr_sales) OVER (PARTITION BY market ORDER BY year, quarter) * 100, 2) AS qoq_growth_pct
FROM market_qtr
ORDER BY market, year, quarter;

-- Q60. Sub-Category Revenue Rank within Category + Cumulative %
WITH subcat AS (
    SELECT p.category, p.sub_category,
        SUM(f.sales) AS total_sales,
        SUM(f.profit) AS total_profit
    FROM fact_sales f
    JOIN dim_product p ON f.product_key = p.product_key
    GROUP BY p.category, p.sub_category
)
SELECT category, sub_category,
    FORMAT(total_sales,2) AS sales,
    FORMAT(total_profit,2) AS profit,
    RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rank_in_category,
    ROUND(total_sales * 100.0 / SUM(total_sales) OVER (PARTITION BY category), 2) AS pct_of_category,
    ROUND(SUM(total_sales) OVER (PARTITION BY category ORDER BY total_sales DESC)
        * 100.0 / SUM(total_sales) OVER (PARTITION BY category), 2) AS cumulative_pct
FROM subcat
ORDER BY category, total_sales DESC;
