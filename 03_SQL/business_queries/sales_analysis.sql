-- ============================================================================
-- AI-Powered Sales Forecasting Dashboard
-- SALES PERFORMANCE ANALYSIS (15 Queries)
-- ============================================================================
-- Schema: fact_sales → dim_date (via date_key)
-- Key measures: sales, profit, quantity, discount, profit_margin, shipping_cost
-- ============================================================================

USE sales_forecasting;

-- ============================================================================
-- A. OVERALL PERFORMANCE
-- ============================================================================

-- Q1. Total Sales, Profit, and Profit Margin
SELECT 
    FORMAT(SUM(sales), 2)                              AS total_sales,
    FORMAT(SUM(profit), 2)                             AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)          AS profit_margin_pct,
    FORMAT(SUM(quantity), 0)                           AS total_quantity,
    COUNT(DISTINCT order_id)                           AS total_orders,
    FORMAT(SUM(shipping_cost), 2)                      AS total_shipping_cost
FROM fact_sales;

-- Q2. Average Order Value, Average Discount, and Average Shipping Days
SELECT 
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2)   AS avg_order_value,
    ROUND(AVG(discount) * 100, 2)                     AS avg_discount_pct,
    ROUND(AVG(shipping_days), 1)                       AS avg_shipping_days,
    ROUND(AVG(revenue_per_unit), 2)                    AS avg_revenue_per_unit,
    ROUND(AVG(profit_margin), 2)                       AS avg_profit_margin_pct
FROM fact_sales;

-- Q3. Orders by Ship Mode
SELECT 
    ship_mode,
    COUNT(*)                                           AS total_transactions,
    COUNT(DISTINCT order_id)                           AS total_orders,
    FORMAT(SUM(sales), 2)                              AS total_sales,
    FORMAT(SUM(profit), 2)                             AS total_profit,
    ROUND(AVG(shipping_days), 1)                       AS avg_shipping_days
FROM fact_sales
GROUP BY ship_mode
ORDER BY SUM(sales) DESC;

-- Q4. Orders by Priority Level
SELECT 
    order_priority,
    COUNT(DISTINCT order_id)                           AS total_orders,
    FORMAT(SUM(sales), 2)                              AS total_sales,
    FORMAT(SUM(profit), 2)                             AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)          AS profit_margin_pct
FROM fact_sales
GROUP BY order_priority
ORDER BY SUM(sales) DESC;

-- ============================================================================
-- B. TIME-BASED ANALYSIS
-- ============================================================================

-- Q5. Monthly Revenue and Profit
SELECT 
    d.year,
    d.month,
    d.month_name,
    FORMAT(SUM(f.sales), 2)                            AS monthly_revenue,
    FORMAT(SUM(f.profit), 2)                           AS monthly_profit,
    COUNT(DISTINCT f.order_id)                         AS monthly_orders,
    ROUND(SUM(f.profit) / SUM(f.sales) * 100, 2)      AS margin_pct
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

-- Q6. Quarterly Revenue and Profit
SELECT 
    d.year,
    CONCAT('Q', d.quarter)                             AS quarter_label,
    FORMAT(SUM(f.sales), 2)                            AS quarterly_revenue,
    FORMAT(SUM(f.profit), 2)                           AS quarterly_profit,
    COUNT(DISTINCT f.order_id)                         AS quarterly_orders
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.quarter
ORDER BY d.year, d.quarter;

-- Q7. Yearly Revenue, Profit, and Growth Summary
SELECT 
    d.year,
    FORMAT(SUM(f.sales), 2)                            AS yearly_revenue,
    FORMAT(SUM(f.profit), 2)                           AS yearly_profit,
    COUNT(DISTINCT f.order_id)                         AS yearly_orders,
    COUNT(DISTINCT f.customer_key)                     AS active_customers,
    ROUND(SUM(f.profit) / SUM(f.sales) * 100, 2)      AS profit_margin_pct
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;

-- Q8. Peak and Trough Months (Best & Worst Performing Months)
(
    SELECT 'PEAK' AS type, d.month_name, d.year,
           FORMAT(SUM(f.sales), 2) AS revenue
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY d.year, d.month, d.month_name
    ORDER BY SUM(f.sales) DESC
    LIMIT 5
)
UNION ALL
(
    SELECT 'TROUGH' AS type, d.month_name, d.year,
           FORMAT(SUM(f.sales), 2) AS revenue
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY d.year, d.month, d.month_name
    ORDER BY SUM(f.sales) ASC
    LIMIT 5
);

-- Q9. Day-of-Week Analysis (Which days generate most revenue?)
SELECT 
    d.day_name,
    d.day_of_week,
    COUNT(DISTINCT f.order_id)                         AS total_orders,
    FORMAT(SUM(f.sales), 2)                            AS total_sales,
    ROUND(AVG(f.sales), 2)                             AS avg_sale_value
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.day_name, d.day_of_week
ORDER BY d.day_of_week;

-- Q10. Weekend vs Weekday Performance
SELECT 
    CASE WHEN d.is_weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    COUNT(DISTINCT f.order_id)                         AS total_orders,
    FORMAT(SUM(f.sales), 2)                            AS total_sales,
    FORMAT(SUM(f.profit), 2)                           AS total_profit,
    ROUND(SUM(f.profit) / SUM(f.sales) * 100, 2)      AS margin_pct
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.is_weekend;

-- ============================================================================
-- C. DISCOUNT & PROFITABILITY ANALYSIS
-- ============================================================================

-- Q11. Discount Impact on Profitability
SELECT 
    CASE 
        WHEN discount = 0     THEN 'No Discount'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        ELSE '31%+'
    END                                                AS discount_band,
    COUNT(*)                                           AS transactions,
    FORMAT(SUM(sales), 2)                              AS total_sales,
    FORMAT(SUM(profit), 2)                             AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)          AS margin_pct,
    SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END)       AS loss_making_count
FROM fact_sales
GROUP BY discount_band
ORDER BY MIN(discount);

-- Q12. Profitable vs Loss-Making Transactions
SELECT 
    CASE 
        WHEN profit > 0  THEN 'Profitable'
        WHEN profit = 0  THEN 'Break Even'
        ELSE 'Loss Making'
    END                                                AS profit_status,
    COUNT(*)                                           AS transaction_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_sales), 2) AS pct_of_total,
    FORMAT(SUM(sales), 2)                              AS total_sales,
    FORMAT(SUM(profit), 2)                             AS total_profit
FROM fact_sales
GROUP BY profit_status
ORDER BY SUM(profit) DESC;

-- Q13. Shipping Mode vs Delivery Time Analysis
SELECT 
    ship_mode,
    COUNT(*)                                           AS orders,
    MIN(shipping_days)                                 AS min_days,
    ROUND(AVG(shipping_days), 1)                       AS avg_days,
    MAX(shipping_days)                                 AS max_days,
    FORMAT(SUM(shipping_cost), 2)                      AS total_ship_cost,
    ROUND(AVG(shipping_cost), 2)                       AS avg_ship_cost
FROM fact_sales
GROUP BY ship_mode
ORDER BY AVG(shipping_days);

-- Q14. Monthly Shipping Cost Trend
SELECT 
    d.year,
    d.month,
    d.month_name,
    FORMAT(SUM(f.shipping_cost), 2)                    AS monthly_shipping_cost,
    ROUND(SUM(f.shipping_cost) / SUM(f.sales) * 100, 2) AS shipping_pct_of_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

-- Q15. Fiscal Year Performance (April-March fiscal year)
SELECT 
    d.fiscal_year,
    CONCAT('FQ', d.fiscal_quarter)                     AS fiscal_quarter,
    FORMAT(SUM(f.sales), 2)                            AS revenue,
    FORMAT(SUM(f.profit), 2)                           AS profit,
    COUNT(DISTINCT f.order_id)                         AS orders
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.fiscal_year, d.fiscal_quarter
ORDER BY d.fiscal_year, d.fiscal_quarter;
