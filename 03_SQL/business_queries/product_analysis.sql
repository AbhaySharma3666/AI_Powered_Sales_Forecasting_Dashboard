-- ============================================================================
-- AI-Powered Sales Forecasting Dashboard
-- PRODUCT ANALYSIS (11 Queries: Q28–Q38)
-- ============================================================================
-- Schema: fact_sales → dim_product (via product_key)
-- ============================================================================

USE sales_forecasting;

-- Q28. Top 10 Products by Revenue
SELECT p.product_name, p.category, p.sub_category,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    SUM(f.quantity) AS total_qty,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_key, p.product_name, p.category, p.sub_category
ORDER BY SUM(f.sales) DESC LIMIT 10;

-- Q29. Bottom 10 Products by Revenue
SELECT p.product_name, p.category, p.sub_category,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    SUM(f.quantity) AS total_qty
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_key, p.product_name, p.category, p.sub_category
ORDER BY SUM(f.sales) ASC LIMIT 10;

-- Q30. Most Profitable Products — Top 10
SELECT p.product_name, p.category,
    FORMAT(SUM(f.profit),2) AS total_profit,
    FORMAT(SUM(f.sales),2) AS total_sales,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_key, p.product_name, p.category
HAVING SUM(f.sales) > 0
ORDER BY SUM(f.profit) DESC LIMIT 10;

-- Q31. Most Loss-Making Products — Top 10
SELECT p.product_name, p.category, p.sub_category,
    FORMAT(SUM(f.profit),2) AS total_loss,
    FORMAT(SUM(f.sales),2) AS total_sales,
    ROUND(AVG(f.discount)*100,1) AS avg_discount_pct
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_key, p.product_name, p.category, p.sub_category
HAVING SUM(f.profit) < 0
ORDER BY SUM(f.profit) ASC LIMIT 10;

-- Q32. Category Performance Summary
SELECT p.category,
    COUNT(DISTINCT p.product_key) AS product_count,
    COUNT(DISTINCT f.order_id) AS total_orders,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct,
    ROUND(SUM(f.sales)*100.0/(SELECT SUM(sales) FROM fact_sales),2) AS revenue_share_pct
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category ORDER BY SUM(f.sales) DESC;

-- Q33. Sub-Category Performance
SELECT p.category, p.sub_category,
    FORMAT(SUM(f.sales),2) AS total_sales,
    FORMAT(SUM(f.profit),2) AS total_profit,
    ROUND(SUM(f.profit)/SUM(f.sales)*100,2) AS margin_pct,
    SUM(f.quantity) AS total_qty,
    ROUND(AVG(f.discount)*100,1) AS avg_discount_pct
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category, p.sub_category
ORDER BY p.category, SUM(f.sales) DESC;

-- Q34. Loss-Making Sub-Categories
SELECT p.sub_category,
    FORMAT(SUM(f.profit),2) AS total_profit,
    FORMAT(SUM(f.sales),2) AS total_sales,
    ROUND(AVG(f.discount)*100,1) AS avg_discount_pct,
    SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS loss_transactions
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.sub_category
HAVING SUM(f.profit) < 0
ORDER BY SUM(f.profit) ASC;

-- Q35. Product Contribution (Pareto — % of Total Revenue)
SELECT p.category,
    FORMAT(SUM(f.sales),2) AS category_sales,
    ROUND(SUM(f.sales)*100.0/(SELECT SUM(sales) FROM fact_sales),2) AS sales_pct
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category ORDER BY SUM(f.sales) DESC;

-- Q36. Category Performance by Year
SELECT d.year, p.category,
    FORMAT(SUM(f.sales),2) AS revenue,
    FORMAT(SUM(f.profit),2) AS profit,
    COUNT(DISTINCT f.order_id) AS orders
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, p.category
ORDER BY d.year, SUM(f.sales) DESC;

-- Q37. Top 5 Products per Category
SELECT category, product_name, total_sales FROM (
    SELECT p.category, p.product_name,
        FORMAT(SUM(f.sales),2) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(f.sales) DESC) AS rn
    FROM fact_sales f
    JOIN dim_product p ON f.product_key = p.product_key
    GROUP BY p.category, p.product_key, p.product_name
) ranked WHERE rn <= 5
ORDER BY category, rn;

-- Q38. Products Sold in Most Countries (Global Reach)
SELECT p.product_name, p.category,
    COUNT(DISTINCT r.country) AS countries_sold_in,
    FORMAT(SUM(f.sales),2) AS total_sales,
    SUM(f.quantity) AS total_qty
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
JOIN dim_region r ON f.region_key = r.region_key
GROUP BY p.product_key, p.product_name, p.category
ORDER BY countries_sold_in DESC LIMIT 10;
