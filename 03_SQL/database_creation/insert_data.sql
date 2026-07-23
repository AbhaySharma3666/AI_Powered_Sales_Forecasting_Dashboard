-- ============================================
-- AI-Powered Sales Forecasting Dashboard
-- Data Insertion Script
-- ============================================
-- Loads processed CSV files into the star schema.
-- 
-- IMPORTANT: 
--   1. Run create_database.sql first
--   2. Run create_tables.sql second
--   3. Run this script last
--
-- NOTE: Update the file paths below to match your
--       actual CSV file locations before running.
-- ============================================

USE sales_forecasting;

-- ============================================
-- SET secure_file_priv (if needed)
-- ============================================
-- Check the allowed directory for LOAD DATA:
-- SHOW VARIABLES LIKE 'secure_file_priv';
-- Place CSV files in that directory, OR
-- Use the LOCAL keyword (requires local_infile=ON):
-- SET GLOBAL local_infile = 1;

-- ============================================
-- STEP 1: Load dim_customer (1,590 rows)
-- ============================================
LOAD DATA LOCAL INFILE 'C:/path/to/02_Dataset/processed_data/dim_customer.csv'
INTO TABLE dim_customer
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_key, customer_id, customer_name, segment, city, state, country, postal_code);

SELECT 'dim_customer loaded' AS status, COUNT(*) AS rows_loaded FROM dim_customer;

-- ============================================
-- STEP 2: Load dim_product (10,292 rows)
-- ============================================
LOAD DATA LOCAL INFILE 'C:/path/to/02_Dataset/processed_data/dim_product.csv'
INTO TABLE dim_product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_key, product_id, product_name, category, sub_category);

SELECT 'dim_product loaded' AS status, COUNT(*) AS rows_loaded FROM dim_product;

-- ============================================
-- STEP 3: Load dim_region (3,819 rows)
-- ============================================
LOAD DATA LOCAL INFILE 'C:/path/to/02_Dataset/processed_data/dim_region.csv'
INTO TABLE dim_region
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(region_key, market, region, country, state, city);

SELECT 'dim_region loaded' AS status, COUNT(*) AS rows_loaded FROM dim_region;

-- ============================================
-- STEP 4: Load dim_date (1,468 rows)
-- ============================================
LOAD DATA LOCAL INFILE 'C:/path/to/02_Dataset/processed_data/dim_date.csv'
INTO TABLE dim_date
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date_key, full_date, day, day_of_week, day_name, week_of_year,
 month, month_name, quarter, year, is_weekend,
 is_month_start, is_month_end, is_quarter_start, is_quarter_end,
 is_year_start, is_year_end, fiscal_year, fiscal_quarter);

SELECT 'dim_date loaded' AS status, COUNT(*) AS rows_loaded FROM dim_date;

-- ============================================
-- STEP 5: Load fact_sales (51,290 rows)
-- Must be loaded LAST (depends on all dimensions)
-- ============================================
LOAD DATA LOCAL INFILE 'C:/path/to/02_Dataset/processed_data/fact_sales.csv'
INTO TABLE fact_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(sale_id, order_id, order_date, ship_date, ship_mode, order_priority,
 customer_key, product_key, region_key, date_key,
 sales, quantity, discount, profit, shipping_cost,
 profit_margin, revenue_per_unit, shipping_days);

SELECT 'fact_sales loaded' AS status, COUNT(*) AS rows_loaded FROM fact_sales;

-- ============================================
-- VERIFICATION: Full Row Count Summary
-- ============================================
SELECT '--- DATA LOAD COMPLETE ---' AS message;

SELECT 'dim_customer' AS table_name, COUNT(*) AS row_count FROM dim_customer
UNION ALL SELECT 'dim_product',  COUNT(*) FROM dim_product
UNION ALL SELECT 'dim_region',   COUNT(*) FROM dim_region
UNION ALL SELECT 'dim_date',     COUNT(*) FROM dim_date
UNION ALL SELECT 'fact_sales',   COUNT(*) FROM fact_sales;

-- ============================================
-- VERIFICATION: Foreign Key Integrity Check
-- ============================================
SELECT 'Orphaned customer_key' AS check_name,
       COUNT(*) AS orphans
FROM fact_sales f
LEFT JOIN dim_customer c ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL

UNION ALL

SELECT 'Orphaned product_key',
       COUNT(*)
FROM fact_sales f
LEFT JOIN dim_product p ON f.product_key = p.product_key
WHERE p.product_key IS NULL

UNION ALL

SELECT 'Orphaned region_key',
       COUNT(*)
FROM fact_sales f
LEFT JOIN dim_region r ON f.region_key = r.region_key
WHERE r.region_key IS NULL

UNION ALL

SELECT 'Orphaned date_key',
       COUNT(*)
FROM fact_sales f
LEFT JOIN dim_date d ON f.date_key = d.date_key
WHERE d.date_key IS NULL;
