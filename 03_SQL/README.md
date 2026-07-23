# 📂 03_SQL — Database & Business Analytics

> Star schema database creation, **60 SQL analytical queries**, and exported Excel reports for the AI-Powered Sales Forecasting Dashboard.

---

## 📋 Table of Contents

1. [Folder Structure](#-folder-structure)
2. [Database Setup](#️-database-setup)
3. [Star Schema Design](#-star-schema-design)
4. [60 Business Queries](#-60-business-queries-summary)
5. [Query Results (Excel)](#-query-results-excel-exports)
6. [SQL Techniques Used](#️-sql-techniques-used)
7. [Key Business Insights](#-key-business-insights-from-queries)

---

## 📁 Folder Structure

```
03_SQL/
│
├── database_creation/
│   ├── create_database.sql              ← Create the MySQL database
│   ├── create_tables.sql                ← Star schema DDL (5 tables + 18 indexes)
│   └── insert_data.sql                  ← LOAD DATA for all 5 CSVs + FK checks
│
├── business_queries/
│   ├── sales_analysis.sql               ← Q1–Q15  (15 queries)
│   ├── customer_analysis.sql            ← Q16–Q27 (12 queries)
│   ├── product_analysis.sql             ← Q28–Q38 (11 queries)
│   ├── regional_analysis.sql            ← Q39–Q48 (10 queries)
│   └── advanced_sql.sql                 ← Q49–Q60 (12 queries)
│
├── query_results/
│   ├── sales_summary.xlsx               ← 15 sheets (19.6 KB)
│   ├── customer_report.xlsx             ← 12 sheets (16.9 KB)
│   └── product_report.xlsx              ← 21 sheets (29.0 KB)
│
├── ER_Diagram/
│   └── sales_star_schema.sql            ← ASCII + dbdiagram.io format
│
└── README.md                            ← This file
```

---

## 🗄️ Database Setup

### Prerequisites
- MySQL 8.0+ (or MariaDB 10.5+)
- Processed CSV files in `02_Dataset/processed_data/`

### Execution Order

| Step | File | Action |
|------|------|--------|
| **1** | `create_database.sql` | Creates `sales_forecasting` database |
| **2** | `create_tables.sql` | Creates 5 tables with PKs, FKs, and 18 performance indexes |
| **3** | `insert_data.sql` | Loads all CSVs via `LOAD DATA LOCAL INFILE` + runs FK integrity checks |

> **⚠️ Important**: Before running `insert_data.sql`, update the file paths to match your local CSV locations.

### Tables Created

| Table | Engine | Charset | Primary Key | Rows |
|-------|--------|---------|-------------|------|
| `dim_customer` | InnoDB | utf8mb4 | `customer_key` | 1,590 |
| `dim_product` | InnoDB | utf8mb4 | `product_key` | 10,292 |
| `dim_region` | InnoDB | utf8mb4 | `region_key` | 3,819 |
| `dim_date` | InnoDB | utf8mb4 | `date_key` | 1,468 |
| `fact_sales` | InnoDB | utf8mb4 | `sale_id` | 51,290 |

### Indexes (18 total)

| Table | Indexed Columns |
|-------|----------------|
| `fact_sales` | `order_id`, `order_date`, `ship_mode`, `customer_key`, `product_key`, `region_key`, `date_key` |
| `dim_customer` | `segment`, `country` |
| `dim_product` | `category`, `sub_category` |
| `dim_region` | `market`, `region`, `country` |
| `dim_date` | `year`, `month`, `quarter`, `full_date` |

---

## 🔗 Star Schema Design

```
                         ┌──────────────────┐
                         │   dim_customer   │
                         │──────────────────│
                         │ PK customer_key  │
                         │    customer_id   │
                         │    customer_name │
                         │    segment       │
                         │    city, state   │
                         │    country       │
                         │    postal_code   │
                         └────────┬─────────┘
                                  │
┌──────────────────┐    ┌─────────┴────────────────┐    ┌──────────────────┐
│   dim_product    │    │       fact_sales          │    │   dim_region     │
│──────────────────│    │──────────────────────────│    │──────────────────│
│ PK product_key   │◄───│ FK product_key            │    │ PK region_key    │
│    product_id    │    │ FK customer_key  ─────────│───►│    market         │
│    product_name  │    │ FK region_key    ─────────│    │    region         │
│    category      │    │ FK date_key      ───────┐│    │    country        │
│    sub_category  │    │──── MEASURES ───────────││    │    state, city    │
└──────────────────┘    │    sales       DEC(12,2)││    └──────────────────┘
                         │    quantity    INT      ││
                         │    discount   DEC(5,2) ││
                         │    profit     DEC(12,2)││
                         │    shipping_cost       ││
                         │    profit_margin       ││
                         │    revenue_per_unit    ││
                         │    shipping_days       ││
                         └────────────────────────┘│
                                                   │
                         ┌─────────────────────────┘
                         │
                         ▼
                         ┌──────────────────┐
                         │    dim_date      │
                         │──────────────────│
                         │ PK date_key      │
                         │    full_date     │
                         │    day, month    │
                         │    quarter, year │
                         │    day_name      │
                         │    month_name    │
                         │    week_of_year  │
                         │    is_weekend    │
                         │    fiscal_year   │
                         │    fiscal_quarter│
                         └──────────────────┘
```

### Foreign Key Relationships

| Relationship | Cardinality | Fact Rows → Dim Rows |
|-------------|-------------|---------------------|
| `fact_sales.customer_key` → `dim_customer.customer_key` | Many : 1 | 51,290 → 1,590 |
| `fact_sales.product_key` → `dim_product.product_key` | Many : 1 | 51,290 → 10,292 |
| `fact_sales.region_key` → `dim_region.region_key` | Many : 1 | 51,290 → 3,819 |
| `fact_sales.date_key` → `dim_date.date_key` | Many : 1 | 51,290 → 1,468 |

> **ER Diagram File**: See `ER_Diagram/sales_star_schema.sql` for the full diagram in ASCII art and [dbdiagram.io](https://dbdiagram.io) import format.

---

## 📊 60 Business Queries Summary

### Sales Analysis — `sales_analysis.sql` (Q1–Q15)

| # | Query | SQL Technique |
|---|-------|---------------|
| Q1 | Total Sales, Profit, Margin — Overall KPIs | `SUM`, `COUNT DISTINCT` |
| Q2 | Avg Order Value, Discount, Shipping Days | `AVG`, `ROUND` |
| Q3 | Performance by Ship Mode | `GROUP BY` |
| Q4 | Performance by Order Priority | `GROUP BY` |
| Q5 | Monthly Revenue & Profit Trend | `JOIN dim_date` |
| Q6 | Quarterly Revenue & Profit | `JOIN`, `CONCAT` |
| Q7 | Yearly Revenue with Active Customers | `JOIN`, `COUNT DISTINCT` |
| Q8 | Top 5 Peak & Bottom 5 Trough Months | `UNION ALL`, `LIMIT` |
| Q9 | Day-of-Week Sales Analysis | `JOIN dim_date` |
| Q10 | Weekend vs Weekday Performance | `CASE WHEN` |
| Q11 | Discount Band Impact on Profitability | `CASE` bands |
| Q12 | Profitable vs Loss-Making Transactions | `CASE`, subquery |
| Q13 | Shipping Mode vs Delivery Time | `MIN`, `AVG`, `MAX` |
| Q14 | Monthly Shipping Cost as % of Sales | `JOIN`, calculated field |
| Q15 | Fiscal Year/Quarter Performance | `fiscal_year`, `fiscal_quarter` |

### Customer Analysis — `customer_analysis.sql` (Q16–Q27)

| # | Query | SQL Technique |
|---|-------|---------------|
| Q16 | Top 10 Customers by Revenue | `ORDER BY DESC LIMIT 10` |
| Q17 | Bottom 10 Customers by Profit | `ORDER BY ASC LIMIT 10` |
| Q18 | Repeat Customers (>1 order) | `HAVING count > 1` |
| Q19 | Order Frequency Distribution | `CASE` + nested subquery |
| Q20 | Customer Lifetime Value — Top 15 | `DATEDIFF`, `MIN/MAX` |
| Q21 | Average CLV by Segment | Segment aggregation |
| Q22 | Segment Performance with Revenue Share | Subquery for `%` |
| Q23 | Segment Revenue Trend by Year | Multi-table `JOIN` |
| Q24 | Top 15 Customer Countries | `GROUP BY country` |
| Q25 | Single-Order Customers (Churn Risk) | `HAVING = 1` |
| Q26 | Customers Inactive Before 2014 | `HAVING MAX(date)` |
| Q27 | New vs Returning Customers by Year | `CASE` + subquery join |

### Product Analysis — `product_analysis.sql` (Q28–Q38)

| # | Query | SQL Technique |
|---|-------|---------------|
| Q28 | Top 10 Products by Revenue | `ORDER BY`, `LIMIT` |
| Q29 | Bottom 10 Products by Revenue | `ORDER BY ASC` |
| Q30 | Most Profitable Products — Top 10 | `ORDER BY profit` |
| Q31 | Most Loss-Making Products | `HAVING SUM < 0` |
| Q32 | Category Performance with Revenue Share | Subquery `%` |
| Q33 | Sub-Category Performance | Multi-column agg |
| Q34 | Loss-Making Sub-Categories | `HAVING` filter |
| Q35 | Category Revenue Contribution (Pareto) | Subquery ratio |
| Q36 | Category Performance by Year | Multi-table `JOIN` |
| Q37 | Top 5 Products per Category | `ROW_NUMBER() OVER` |
| Q38 | Products Sold in Most Countries | `COUNT DISTINCT country` |

### Regional Analysis — `regional_analysis.sql` (Q39–Q48)

| # | Query | SQL Technique |
|---|-------|---------------|
| Q39 | Market Performance (7 markets) | `GROUP BY market` |
| Q40 | Region Performance (13 regions) | `GROUP BY market, region` |
| Q41 | Best Region by Revenue | `LIMIT 1` |
| Q42 | Worst Region by Profit | `ORDER BY ASC LIMIT 1` |
| Q43 | Top 15 Countries by Revenue | Multi-table `JOIN` |
| Q44 | Top 15 Cities by Revenue | Multi-table `JOIN` |
| Q45 | Region × Category Cross Analysis | Cross-dimension `JOIN` |
| Q46 | Market × Segment Cross Analysis | Cross-dimension `JOIN` |
| Q47 | Market Revenue Trend by Year | Time-series `JOIN` |
| Q48 | Loss-Making Countries | `HAVING SUM(profit) < 0` |

### Advanced SQL — `advanced_sql.sql` (Q49–Q60)

| # | Query | SQL Technique |
|---|-------|---------------|
| Q49 | Region Revenue Ranking | `RANK() OVER` |
| Q50 | Product Revenue Ranking — Top 20 | `DENSE_RANK() OVER` |
| Q51 | Month-over-Month Revenue Change | `CTE` + `LAG()` |
| Q52 | Next Month Revenue Comparison | `CTE` + `LEAD()` |
| Q53 | Year-over-Year Growth Rate | `CTE` + `LAG()` |
| Q54 | Cumulative Running Total Revenue | `SUM() OVER (ORDER BY)` |
| Q55 | 3-Month Moving Average Revenue | `AVG() OVER (ROWS BETWEEN)` |
| Q56 | Top 3 Products per Category | `ROW_NUMBER()` + `CTE` |
| Q57 | Customer Percentile & Quartile | `PERCENT_RANK()` + `NTILE(4)` |
| Q58 | Cumulative Revenue Share by Category | Pareto window function |
| Q59 | Market Quarterly Growth (QoQ) | `LAG() OVER (PARTITION BY)` |
| Q60 | Sub-Category Rank + Cumulative % | Multi-window functions |

---

## 📑 Query Results — Excel Exports

All 60 queries have been executed against the processed CSV data and exported as Excel workbooks with one sheet per query.

### Files

| File | Sheets | Size | Coverage |
|------|--------|------|----------|
| **`sales_summary.xlsx`** | 15 | 19.6 KB | Q1–Q15: KPIs, time trends, discounts, shipping, fiscal |
| **`customer_report.xlsx`** | 12 | 16.9 KB | Q16–Q27: Top customers, CLV, segments, churn risk |
| **`product_report.xlsx`** | 21 | 29.0 KB | Q28–Q48: Products, categories + markets, regions, countries |

### Sheet Index

#### `sales_summary.xlsx`
| Sheet Name | Query |
|------------|-------|
| `Q1_Overall_KPIs` | Total Sales, Profit, Margin, Quantity, Orders |
| `Q2_Averages` | Avg Order Value, Discount, Shipping Days |
| `Q3_By_Ship_Mode` | Ship Mode breakdown |
| `Q4_By_Priority` | Order Priority breakdown |
| `Q5_Monthly_Revenue` | Monthly revenue & profit (48 months) |
| `Q6_Quarterly_Revenue` | Quarterly revenue & profit (16 quarters) |
| `Q7_Yearly_Revenue` | Yearly summary (2011–2014) |
| `Q8_Peak_Trough_Months` | 5 best + 5 worst months |
| `Q9_Day_of_Week` | Revenue by day of week |
| `Q10_Weekend_vs_Weekday` | Weekend vs weekday performance |
| `Q11_Discount_Impact` | Discount band profitability |
| `Q12_Profit_vs_Loss` | Profitable vs loss-making split |
| `Q13_Shipping_Analysis` | Ship mode delivery times & costs |
| `Q14_Monthly_Shipping` | Monthly shipping cost trend |
| `Q15_Fiscal_Performance` | Fiscal year/quarter performance |

#### `customer_report.xlsx`
| Sheet Name | Query |
|------------|-------|
| `Q16_Top10_Revenue` | Top 10 customers by sales |
| `Q17_Bottom10_Profit` | 10 most loss-making customers |
| `Q18_Repeat_Customers` | Top 20 repeat buyers |
| `Q19_Order_Frequency` | Customer order count distribution |
| `Q20_CLV_Top15` | Customer Lifetime Value — top 15 |
| `Q21_CLV_by_Segment` | Average CLV per segment |
| `Q22_Segment_Performance` | Segment KPIs & revenue share |
| `Q23_Segment_by_Year` | Segment revenue trend by year |
| `Q24_Top15_Countries` | Top 15 countries by customer revenue |
| `Q25_Churn_Risk` | Single-order customers |
| `Q26_Inactive_Customers` | Customers inactive since before 2014 |
| `Q27_New_vs_Returning` | New vs returning customers by year |

#### `product_report.xlsx`
| Sheet Name | Query |
|------------|-------|
| `Q28_Top10_Products` | Top 10 products by revenue |
| `Q29_Bottom10_Products` | Bottom 10 products |
| `Q30_Most_Profitable` | 10 most profitable products |
| `Q31_Loss_Making` | 10 most loss-making products |
| `Q32_Category_Performance` | Category KPIs & revenue share |
| `Q33_SubCategory` | All 17 sub-category metrics |
| `Q34_Loss_SubCategories` | Loss-making sub-categories |
| `Q35_Category_Contribution` | Category revenue contribution |
| `Q36_Category_by_Year` | Category trend by year |
| `Q37_Top5_per_Category` | Top 5 products per category |
| `Q38_Global_Reach` | Products sold in most countries |
| `Q39_Market_Performance` | 7 markets with revenue share |
| `Q40_Region_Performance` | 13 regions ranked |
| `Q41_Best_Region` | #1 region by revenue |
| `Q42_Worst_Region` | Worst region by profit |
| `Q43_Top15_Countries` | Top 15 countries |
| `Q44_Top15_Cities` | Top 15 cities |
| `Q45_Region_x_Category` | Region × Category cross-tab |
| `Q46_Market_x_Segment` | Market × Segment cross-tab |
| `Q47_Market_by_Year` | Market revenue trend by year |
| `Q48_Loss_Countries` | Countries with negative profit |

---

## 🛠️ SQL Techniques Used

| Technique | Queries | Count |
|-----------|---------|-------|
| `JOIN` (INNER) | Q5–Q60 | 40+ |
| `GROUP BY` + `HAVING` | Q18, Q25, Q26, Q34, Q48 | 5 |
| `CASE` expressions | Q10, Q11, Q12, Q19, Q27 | 5 |
| `UNION ALL` | Q8 | 1 |
| Subqueries | Q12, Q19, Q22, Q32, Q35 | 5 |
| `CTE` (WITH clause) | Q51–Q60 | 10 |
| `RANK()` | Q49 | 1 |
| `DENSE_RANK()` | Q50 | 1 |
| `ROW_NUMBER()` | Q37, Q56 | 2 |
| `LAG()` | Q51, Q53, Q59 | 3 |
| `LEAD()` | Q52 | 1 |
| `NTILE()` | Q57 | 1 |
| `PERCENT_RANK()` | Q57 | 1 |
| Running `SUM() OVER` | Q54 | 1 |
| Moving `AVG() OVER` | Q55 | 1 |
| `DATEDIFF()` | Q20 | 1 |
| `FORMAT()` | All queries | 60 |
| `PARTITION BY` | Q56, Q59, Q60 | 3 |

---

## 💡 Key Business Insights from Queries

| Insight | Source |
|---------|--------|
| **$12.6M** total revenue, **$1.47M** profit, **11.6%** margin | Q1 |
| **25,035** unique orders from **1,590** customers | Q1 |
| Avg order value: **$505.09** | Q2 |
| **24.4%** of transactions are loss-making | Q12 |
| **Same Day** shipping is fastest but most expensive | Q13 |
| **Consumer** segment generates the most revenue | Q22 |
| **Technology** category leads in both sales and profit | Q32 |
| **7 markets**, **13 regions**, **147 countries** covered | Q39, Q40 |
| Advanced window functions reveal MoM, YoY, and QoQ growth trends | Q51–Q59 |
| Pareto analysis shows top categories drive majority of revenue | Q58, Q60 |

---

*Last updated: June 27, 2026*
