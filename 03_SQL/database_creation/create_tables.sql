-- ============================================
-- AI-Powered Sales Forecasting Dashboard
-- Create Tables Script (Star Schema)
-- ============================================
-- Matches exactly with processed CSV files in:
--   02_Dataset/processed_data/
-- ============================================

CREATE DATABASE IF NOT EXISTS sales_forecasting;
USE sales_forecasting;

-- ============================================
-- DIMENSION TABLES (create first — no FKs)
-- ============================================

-- -------------------------------------------------
-- dim_customer: 1,590 unique customers
-- Source: dim_customer.csv
-- -------------------------------------------------
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_customer;

CREATE TABLE dim_customer (
    customer_key    INT             PRIMARY KEY,
    customer_id     VARCHAR(20)     NOT NULL UNIQUE,
    customer_name   VARCHAR(100)    NOT NULL,
    segment         VARCHAR(50)     NOT NULL,
    city            VARCHAR(100),
    state           VARCHAR(100),
    country         VARCHAR(100),
    postal_code     VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------
-- dim_product: 10,292 unique products
-- Source: dim_product.csv
-- -------------------------------------------------
DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_product (
    product_key     INT             PRIMARY KEY,
    product_id      VARCHAR(30)     NOT NULL UNIQUE,
    product_name    VARCHAR(300)    NOT NULL,
    category        VARCHAR(50)     NOT NULL,
    sub_category    VARCHAR(50)     NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------
-- dim_region: 3,819 unique location combinations
-- Source: dim_region.csv
-- -------------------------------------------------
DROP TABLE IF EXISTS dim_region;

CREATE TABLE dim_region (
    region_key      INT             PRIMARY KEY,
    market          VARCHAR(50)     NOT NULL,
    region          VARCHAR(50)     NOT NULL,
    country         VARCHAR(100)    NOT NULL,
    state           VARCHAR(100),
    city            VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------
-- dim_date: 1,468 unique dates (2011-01-01 to 2015-01-07)
-- Source: dim_date.csv
-- -------------------------------------------------
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_key          INT           PRIMARY KEY,
    full_date         DATE          NOT NULL UNIQUE,
    day               INT           NOT NULL,
    day_of_week       INT           NOT NULL,
    day_name          VARCHAR(15)   NOT NULL,
    week_of_year      INT           NOT NULL,
    month             INT           NOT NULL,
    month_name        VARCHAR(15)   NOT NULL,
    quarter           INT           NOT NULL,
    year              INT           NOT NULL,
    is_weekend        TINYINT       NOT NULL DEFAULT 0,
    is_month_start    TINYINT       NOT NULL DEFAULT 0,
    is_month_end      TINYINT       NOT NULL DEFAULT 0,
    is_quarter_start  TINYINT       NOT NULL DEFAULT 0,
    is_quarter_end    TINYINT       NOT NULL DEFAULT 0,
    is_year_start     TINYINT       NOT NULL DEFAULT 0,
    is_year_end       TINYINT       NOT NULL DEFAULT 0,
    fiscal_year       INT           NOT NULL,
    fiscal_quarter    INT           NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- FACT TABLE (create last — has FKs)
-- ============================================

-- -------------------------------------------------
-- fact_sales: 51,290 transactions
-- Source: fact_sales.csv
-- -------------------------------------------------
CREATE TABLE fact_sales (
    sale_id           INT             PRIMARY KEY,
    order_id          VARCHAR(25)     NOT NULL,
    order_date        DATE            NOT NULL,
    ship_date         DATE            NOT NULL,
    ship_mode         VARCHAR(20)     NOT NULL,
    order_priority    VARCHAR(20)     NOT NULL,
    customer_key      INT             NOT NULL,
    product_key       INT             NOT NULL,
    region_key        INT             NOT NULL,
    date_key          INT             NOT NULL,
    sales             DECIMAL(12,2)   NOT NULL,
    quantity          INT             NOT NULL,
    discount          DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
    profit            DECIMAL(12,2)   NOT NULL,
    shipping_cost     DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    profit_margin     DECIMAL(8,2),
    revenue_per_unit  DECIMAL(10,2),
    shipping_days     INT             NOT NULL DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_fact_customer  FOREIGN KEY (customer_key)  REFERENCES dim_customer(customer_key),
    CONSTRAINT fk_fact_product   FOREIGN KEY (product_key)   REFERENCES dim_product(product_key),
    CONSTRAINT fk_fact_region    FOREIGN KEY (region_key)    REFERENCES dim_region(region_key),
    CONSTRAINT fk_fact_date      FOREIGN KEY (date_key)      REFERENCES dim_date(date_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- INDEXES for Query Performance
-- ============================================

-- Fact table indexes
CREATE INDEX idx_fact_order_id     ON fact_sales(order_id);
CREATE INDEX idx_fact_order_date   ON fact_sales(order_date);
CREATE INDEX idx_fact_ship_mode    ON fact_sales(ship_mode);
CREATE INDEX idx_fact_customer_key ON fact_sales(customer_key);
CREATE INDEX idx_fact_product_key  ON fact_sales(product_key);
CREATE INDEX idx_fact_region_key   ON fact_sales(region_key);
CREATE INDEX idx_fact_date_key     ON fact_sales(date_key);

-- Dimension table indexes
CREATE INDEX idx_customer_segment  ON dim_customer(segment);
CREATE INDEX idx_customer_country  ON dim_customer(country);
CREATE INDEX idx_product_category  ON dim_product(category);
CREATE INDEX idx_product_subcat    ON dim_product(sub_category);
CREATE INDEX idx_region_market     ON dim_region(market);
CREATE INDEX idx_region_region     ON dim_region(region);
CREATE INDEX idx_region_country    ON dim_region(country);
CREATE INDEX idx_date_year         ON dim_date(year);
CREATE INDEX idx_date_month        ON dim_date(month);
CREATE INDEX idx_date_quarter      ON dim_date(quarter);
CREATE INDEX idx_date_full         ON dim_date(full_date);

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Verify table creation
SELECT 'dim_customer' AS table_name, COUNT(*) AS row_count FROM dim_customer
UNION ALL
SELECT 'dim_product',  COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_region',   COUNT(*) FROM dim_region
UNION ALL
SELECT 'dim_date',     COUNT(*) FROM dim_date
UNION ALL
SELECT 'fact_sales',   COUNT(*) FROM fact_sales;
