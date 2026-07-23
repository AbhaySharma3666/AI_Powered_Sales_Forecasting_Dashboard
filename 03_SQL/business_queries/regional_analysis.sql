-- ============================================================================
-- AI-Powered Sales Forecasting Dashboard
-- REGIONAL ANALYSIS (10 Queries: Q39–Q48)
-- ============================================================================
-- Schema: fact_sales → dim_region (via region_key)
-- ============================================================================

USE sales_forecasting;

-- Q39. Market Performance Overview
SELECT r.market,
    COUNT(DISTINCT r.country) AS num_countries,
    COUNT(DISTINCT f.order_id) AS total_orders,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct,
    ROUND(SUM(f.sales)*100.0/(SELECT SUM(sales) FROM fact_sales),2) AS revenue_share_pct
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
GROUP BY r.market ORDER BY SUM(f.sales) DESC;

-- Q40. Region Performance (13 Regions)
SELECT r.market, r.region,
    COUNT(DISTINCT f.order_id) AS total_orders,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
GROUP BY r.market, r.region
ORDER BY SUM(f.sales) DESC;

-- Q41. Best Region by Revenue
SELECT r.region,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
GROUP BY r.region
ORDER BY SUM(f.sales) DESC LIMIT 1;

-- Q42. Worst Region by Profit
SELECT r.region,
    FORMAT(SUM(f.profit),2) AS total_profit,
    FORMAT(SUM(f.sales),2) AS total_sales,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
GROUP BY r.region
ORDER BY SUM(f.profit) ASC LIMIT 1;

-- Q43. Top 15 Countries by Revenue
SELECT r.country, r.market, r.region,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
GROUP BY r.country, r.market, r.region
ORDER BY SUM(f.sales) DESC LIMIT 15;

-- Q44. Top 15 Cities by Revenue
SELECT r.city, r.state, r.country, r.market,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
GROUP BY r.city, r.state, r.country, r.market
ORDER BY SUM(f.sales) DESC LIMIT 15;

-- Q45. Region × Category Cross Analysis
SELECT r.region, p.category,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY r.region, p.category
ORDER BY r.region, SUM(f.sales) DESC;

-- Q46. Market × Segment Cross Analysis
SELECT r.market, c.segment,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    COUNT(DISTINCT c.customer_key) AS num_customers
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY r.market, c.segment
ORDER BY r.market, SUM(f.sales) DESC;

-- Q47. Market Performance by Year (Trend)
SELECT d.year, r.market,
    FORMAT(SUM(f.sales),2) AS revenue,
    FORMAT(SUM(f.profit),2) AS profit,
    COUNT(DISTINCT f.order_id) AS orders
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, r.market
ORDER BY d.year, SUM(f.sales) DESC;

-- Q48. Countries with Negative Profit (Loss-Making Markets)
SELECT r.country, r.market, r.region,
    FORMAT(SUM(f.profit),2) AS total_loss,
    FORMAT(SUM(f.sales),2) AS total_sales,
    ROUND(AVG(f.discount)*100,1) AS avg_discount_pct,
    COUNT(DISTINCT f.order_id) AS orders
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
GROUP BY r.country, r.market, r.region
HAVING SUM(f.profit) < 0
ORDER BY SUM(f.profit) ASC;
