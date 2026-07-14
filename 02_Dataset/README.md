# 📂 02_Dataset — Data Pipeline Documentation

> Complete guide covering data acquisition, cleaning, and star schema transformation for the AI-Powered Sales Forecasting Dashboard project.

---

## 📋 Table of Contents

1. [Dataset Overview](#-dataset-overview)
2. [Folder Structure](#-folder-structure)
3. [Phase 1 — Raw Data Download](#-phase-1--raw-data-download)
4. [Phase 2 — Data Cleaning](#-phase-2--data-cleaning)
5. [Phase 3 — Data Processing (Star Schema)](#-phase-3--data-processing-star-schema)
6. [Star Schema Diagram](#-star-schema-diagram)
7. [Data Dictionary](#-data-dictionary)
8. [Data Quality Summary](#-data-quality-summary)
9. [How to Reproduce](#-how-to-reproduce)

---

## 📊 Dataset Overview

| Property | Value |
|----------|-------|
| **Source** | [Kaggle — Global Super Store Dataset](https://www.kaggle.com/datasets/apoorvaappz/global-super-store-dataset) |
| **Author** | Apoorva Mahalingappa |
| **Domain** | Retail / E-Commerce |
| **Time Period** | January 2011 – December 2014 |
| **Total Records** | 51,290 transactions |
| **Total Orders** | 25,035 unique orders |
| **Customers** | 1,590 unique customers |
| **Products** | 10,292 unique products |
| **Countries** | 147 countries across 7 markets |
| **Revenue** | $12,642,501.68 |
| **Profit** | $1,467,456.52 |

---

## 📁 Folder Structure

```
02_Dataset/
│
├── raw_data/                          ← Original untouched data
│   ├── Global_Superstore2.csv             (11.53 MB)
│   └── Global_Superstore2.xlsx            (7.67 MB)
│
├── cleaned_data/                      ← Cleaned & standardized
│   └── sales_clean.csv                    (13.75 MB)
│
└── processed_data/                    ← Star schema tables
    ├── fact_sales.csv                     (5.80 MB | 51,290 rows)
    ├── dim_customer.csv                   (112 KB  | 1,590 rows)
    ├── dim_product.csv                    (783 KB  | 10,292 rows)
    ├── dim_region.csv                     (175 KB  | 3,819 rows)
    └── dim_date.csv                       (100 KB  | 1,468 rows)
```

---

## 📥 Phase 1 — Raw Data Download

### Source
The dataset is the **Global Superstore** dataset from Kaggle, containing worldwide retail transaction data.

### Download Method
Downloaded programmatically using the `kagglehub` Python package:
```python
import kagglehub

path = kagglehub.dataset_download("apoorvaappz/global-super-store-dataset")
```

### Raw Data Schema (24 Columns)

| # | Column Name | Data Type | Nulls | Description |
|---|-------------|-----------|-------|-------------|
| 1 | Row ID | int | 0 | Unique row identifier |
| 2 | Order ID | string | 0 | Unique order identifier (e.g., `CA-2012-124891`) |
| 3 | Order Date | string | 0 | Date order was placed (DD-MM-YYYY format) |
| 4 | Ship Date | string | 0 | Date order was shipped (DD-MM-YYYY format) |
| 5 | Ship Mode | string | 0 | Shipping method (Same Day, First Class, Second Class, Standard Class) |
| 6 | Customer ID | string | 0 | Unique customer identifier |
| 7 | Customer Name | string | 0 | Full customer name |
| 8 | Segment | string | 0 | Customer segment (Consumer, Corporate, Home Office) |
| 9 | City | string | 0 | Customer city |
| 10 | State | string | 0 | Customer state/province |
| 11 | Country | string | 0 | Customer country |
| 12 | Postal Code | float | **41,296** | Postal/ZIP code (missing for international orders) |
| 13 | Market | string | 0 | Market region (US, APAC, EU, Africa, EMEA, LATAM, Canada) |
| 14 | Region | string | 0 | Sub-region (13 distinct regions) |
| 15 | Product ID | string | 0 | Unique product identifier |
| 16 | Category | string | 0 | Product category (Technology, Furniture, Office Supplies) |
| 17 | Sub-Category | string | 0 | Product sub-category (17 types) |
| 18 | Product Name | string | 0 | Full product name |
| 19 | Sales | float | 0 | Transaction revenue amount |
| 20 | Quantity | int | 0 | Number of units sold (1–14) |
| 21 | Discount | float | 0 | Discount applied (0–0.85) |
| 22 | Profit | float | 0 | Transaction profit (can be negative) |
| 23 | Shipping Cost | float | 0 | Cost of shipping |
| 24 | Order Priority | string | 0 | Priority level (Critical, High, Medium, Low) |

### Issues Identified in Raw Data
- ❌ **41,296 null Postal Codes** (80.5%) — international orders lack US postal codes
- ❌ **Dates stored as strings** in DD-MM-YYYY format
- ❌ **Inconsistent casing** in text columns
- ❌ **No derived time features** for analytics
- ❌ **Flat structure** — not optimized for analytical queries

---

## 🧹 Phase 2 — Data Cleaning

### Cleaning Pipeline (10 Steps)

| Step | Action | Details |
|------|--------|---------|
| **1** | Load raw data | Read CSV with `latin-1` encoding |
| **2** | Standardize column names | Renamed all 24 columns to `snake_case` |
| **3** | Parse dates | Converted `DD-MM-YYYY` strings → `datetime64` objects |
| **4** | Handle missing values | Filled 41,296 null postal codes with `N/A` |
| **5** | Fix data types | Rounded numerics to 2 decimal places |
| **6** | Clean strings | Stripped whitespace, standardized Title Case |
| **7** | Add derived columns | Added 10 new analytical features |
| **8** | Column review | All columns retained |
| **9** | Data validation | Verified 0 nulls, 0 duplicates |
| **10** | Export | Saved as UTF-8 encoded CSV |

### Cleaned Data Schema (34 Columns)

#### Original Columns (24 → standardized)

| Column | Type | Description |
|--------|------|-------------|
| `row_id` | int | Unique row identifier |
| `order_id` | string | Order identifier |
| `order_date` | datetime | Order date (parsed) |
| `ship_date` | datetime | Ship date (parsed) |
| `ship_mode` | string | Same Day / First Class / Second Class / Standard Class |
| `customer_id` | string | Customer identifier |
| `customer_name` | string | Customer full name |
| `segment` | string | Consumer / Corporate / Home Office |
| `city` | string | Customer city |
| `state` | string | Customer state/province |
| `country` | string | Customer country |
| `postal_code` | string | Postal code (`N/A` for international) |
| `market` | string | US / APAC / EU / Africa / EMEA / LATAM / Canada |
| `region` | string | 13 sub-regions |
| `product_id` | string | Product identifier |
| `category` | string | Technology / Furniture / Office Supplies |
| `sub_category` | string | 17 sub-categories |
| `product_name` | string | Full product name |
| `sales` | float | Revenue amount (rounded to 2dp) |
| `quantity` | int | Units sold |
| `discount` | float | Discount rate (0.0 – 0.85) |
| `profit` | float | Profit amount (can be negative) |
| `shipping_cost` | float | Shipping cost |
| `order_priority` | string | Critical / High / Medium / Low |

#### Derived Columns (10 new)

| Column | Type | Formula / Description |
|--------|------|----------------------|
| `order_year` | int | Year extracted from `order_date` (2011–2014) |
| `order_month` | int | Month number (1–12) |
| `order_month_name` | string | Month name (January–December) |
| `order_quarter` | int | Quarter number (1–4) |
| `order_day_of_week` | int | Day of week (0=Monday, 6=Sunday) |
| `order_day_name` | string | Day name (Monday–Sunday) |
| `is_weekend` | int | 1 if Saturday/Sunday, 0 otherwise |
| `shipping_days` | int | `ship_date` − `order_date` in days |
| `profit_margin` | float | `(profit / sales) × 100` (percentage) |
| `revenue_per_unit` | float | `sales / quantity` |

### Cleaning Results

| Metric | Before | After |
|--------|--------|-------|
| Rows | 51,290 | 51,290 |
| Columns | 24 | 34 |
| Null values | 41,296 | **0** |
| Duplicates | 0 | 0 |
| Date format | DD-MM-YYYY string | datetime64 |
| Column naming | Mixed Case with Spaces | snake_case |
| Encoding | latin-1 | UTF-8 |

---

## ⚙️ Phase 3 — Data Processing (Star Schema)

The cleaned flat table was transformed into a **star schema** — the standard data warehouse design for analytical queries and Power BI modeling.

### Why Star Schema?
- ✅ **Faster queries** — JOINs are predictable and optimized
- ✅ **Power BI native** — Direct import with auto-detected relationships
- ✅ **Reduced redundancy** — Customer/Product info stored once
- ✅ **Scalable** — Easy to add new dimensions

---

### Fact Table: `fact_sales.csv`

> The central table containing all transactional measures and foreign keys to dimension tables.

| Column | Type | Description |
|--------|------|-------------|
| `sale_id` | int | Surrogate primary key (1–51,290) |
| `order_id` | string | Business order identifier |
| `order_date` | datetime | Date the order was placed |
| `ship_date` | datetime | Date the order was shipped |
| `ship_mode` | string | Shipping method |
| `order_priority` | string | Order priority level |
| `customer_key` | int | FK → `dim_customer.customer_key` |
| `product_key` | int | FK → `dim_product.product_key` |
| `region_key` | int | FK → `dim_region.region_key` |
| `date_key` | int | FK → `dim_date.date_key` |
| `sales` | float | **Measure**: Revenue amount ($) |
| `quantity` | int | **Measure**: Units sold |
| `discount` | float | **Measure**: Discount rate |
| `profit` | float | **Measure**: Profit amount ($) |
| `shipping_cost` | float | **Measure**: Shipping cost ($) |
| `profit_margin` | float | **Measure**: Profit margin (%) |
| `revenue_per_unit` | float | **Measure**: Revenue per unit ($) |
| `shipping_days` | int | **Measure**: Delivery duration (days) |

**Stats**: 51,290 rows | 18 columns | 5.80 MB

---

### Dimension Table: `dim_customer.csv`

> Customer demographics and segmentation data.

| Column | Type | Description |
|--------|------|-------------|
| `customer_key` | int | Surrogate primary key (1–1,590) |
| `customer_id` | string | Business customer ID |
| `customer_name` | string | Full name |
| `segment` | string | Consumer / Corporate / Home Office |
| `city` | string | Primary city (most frequent) |
| `state` | string | Primary state |
| `country` | string | Primary country |
| `postal_code` | string | Postal code (or N/A) |

**Stats**: 1,590 rows | 8 columns | 112 KB | 99 countries | 3 segments

---

### Dimension Table: `dim_product.csv`

> Product catalog with category hierarchy.

| Column | Type | Description |
|--------|------|-------------|
| `product_key` | int | Surrogate primary key (1–10,292) |
| `product_id` | string | Business product ID |
| `product_name` | string | Full product name |
| `category` | string | Technology / Furniture / Office Supplies |
| `sub_category` | string | 17 sub-categories (Phones, Chairs, Binders, etc.) |

**Stats**: 10,292 rows | 5 columns | 783 KB | 3 categories | 17 sub-categories

---

### Dimension Table: `dim_region.csv`

> Geographic hierarchy from market level down to city level.

| Column | Type | Description |
|--------|------|-------------|
| `region_key` | int | Surrogate primary key (1–3,819) |
| `market` | string | US / APAC / EU / Africa / EMEA / LATAM / Canada |
| `region` | string | 13 sub-regions (East, West, Oceania, etc.) |
| `country` | string | Country name (147 countries) |
| `state` | string | State/province name |
| `city` | string | City name (3,636 cities) |

**Stats**: 3,819 rows | 6 columns | 175 KB | 7 markets | 147 countries

---

### Dimension Table: `dim_date.csv`

> Comprehensive date dimension with calendar and fiscal attributes.

| Column | Type | Description |
|--------|------|-------------|
| `date_key` | int | Surrogate primary key (1–1,468) |
| `full_date` | date | Full calendar date |
| `day` | int | Day of month (1–31) |
| `day_of_week` | int | Day of week (0=Mon, 6=Sun) |
| `day_name` | string | Monday through Sunday |
| `week_of_year` | int | ISO week number (1–53) |
| `month` | int | Month number (1–12) |
| `month_name` | string | January through December |
| `quarter` | int | Calendar quarter (1–4) |
| `year` | int | Calendar year (2011–2015) |
| `is_weekend` | int | 1 = Saturday/Sunday |
| `is_month_start` | int | 1 = First day of month |
| `is_month_end` | int | 1 = Last day of month |
| `is_quarter_start` | int | 1 = First day of quarter |
| `is_quarter_end` | int | 1 = Last day of quarter |
| `is_year_start` | int | 1 = January 1st |
| `is_year_end` | int | 1 = December 31st |
| `fiscal_year` | int | Fiscal year (April start) |
| `fiscal_quarter` | int | Fiscal quarter (1–4) |

**Stats**: 1,468 rows | 19 columns | 100 KB | Date range: 2011-01-01 to 2015-01-07

---

## 🔗 Star Schema Diagram

```
                         ┌──────────────────┐
                         │   dim_customer   │
                         │──────────────────│
                         │ customer_key (PK)│
                         │ customer_id      │
                         │ customer_name    │
                         │ segment          │
                         │ city, state      │
                         │ country          │
                         └────────┬─────────┘
                                  │
┌──────────────────┐    ┌─────────┴────────┐    ┌──────────────────┐
│   dim_product    │    │    fact_sales     │    │   dim_region     │
│──────────────────│    │──────────────────│    │──────────────────│
│ product_key (PK) │◄───│ product_key (FK) │    │ region_key (PK)  │
│ product_id       │    │ customer_key(FK) │───►│ market           │
│ product_name     │    │ region_key (FK)  │    │ region           │
│ category         │    │ date_key (FK)    │    │ country          │
│ sub_category     │    │──────────────────│    │ state, city      │
└──────────────────┘    │ sale_id (PK)     │    └──────────────────┘
                         │ order_id         │
                         │ sales            │
                         │ quantity         │
                         │ discount         │
                         │ profit           │
                         │ shipping_cost    │
                         │ profit_margin    │
                         │ revenue_per_unit │
                         │ shipping_days    │
                         └────────┬─────────┘
                                  │
                         ┌────────┴─────────┐
                         │    dim_date      │
                         │──────────────────│
                         │ date_key (PK)    │
                         │ full_date        │
                         │ day, month, year │
                         │ quarter          │
                         │ day_name         │
                         │ fiscal_year      │
                         │ fiscal_quarter   │
                         └──────────────────┘
```

### Relationships

| Relationship | Join Type | Cardinality |
|-------------|-----------|-------------|
| `fact_sales.customer_key` → `dim_customer.customer_key` | Many-to-One | 51,290 → 1,590 |
| `fact_sales.product_key` → `dim_product.product_key` | Many-to-One | 51,290 → 10,292 |
| `fact_sales.region_key` → `dim_region.region_key` | Many-to-One | 51,290 → 3,819 |
| `fact_sales.date_key` → `dim_date.date_key` | Many-to-One | 51,290 → 1,468 |

---

## 📊 Data Dictionary

### Markets (7)

| Market | Description |
|--------|-------------|
| US | United States |
| APAC | Asia Pacific |
| EU | European Union |
| EMEA | Europe, Middle East, Africa |
| LATAM | Latin America |
| Africa | African continent |
| Canada | Canada |

### Regions (13)

| Region | Market |
|--------|--------|
| East, West, Central, South | US |
| Oceania, Southeast Asia, North Asia, Central Asia | APAC |
| North, South (EU) | EU |
| EMEA | EMEA |
| Caribbean, Central/South America | LATAM |
| Africa | Africa |
| Canada | Canada |

### Categories & Sub-Categories

| Category | Sub-Categories |
|----------|---------------|
| **Technology** | Phones, Accessories, Copiers, Machines |
| **Furniture** | Chairs, Tables, Bookcases, Furnishings |
| **Office Supplies** | Binders, Storage, Paper, Art, Supplies, Envelopes, Labels, Fasteners, Appliances |

### Customer Segments

| Segment | Description |
|---------|-------------|
| Consumer | Individual retail customers |
| Corporate | Business/company buyers |
| Home Office | Work-from-home professionals |

### Ship Modes

| Ship Mode | Typical Days |
|-----------|-------------|
| Same Day | 0 days |
| First Class | 1–3 days |
| Second Class | 3–5 days |
| Standard Class | 5–7 days |

### Order Priority

| Priority | Description |
|----------|-------------|
| Critical | Highest urgency |
| High | High urgency |
| Medium | Standard processing |
| Low | No rush |

---

## ✅ Data Quality Summary

| Check | Result |
|-------|--------|
| Null values (cleaned) | **0** — All handled |
| Duplicate rows | **0** — None found |
| Date integrity | **✓** — All `ship_date ≥ order_date` |
| Foreign key integrity | **✓** — 0 null FKs in fact table |
| Sales range | $0.44 – $22,638.48 |
| Profit range | -$6,599.98 – $8,399.98 |
| Negative profits | 12,540 rows (24.4%) — normal for discounted items |
| Quantity range | 1 – 14 units |
| Discount range | 0% – 85% |

---

## 🔄 How to Reproduce

### Prerequisites
```bash
pip install pandas numpy kagglehub
```

### Step 1: Download Raw Data
```python
import kagglehub
path = kagglehub.dataset_download("apoorvaappz/global-super-store-dataset")
# Copy files to 02_Dataset/raw_data/
```

### Step 2: Clean Data
```bash
python clean_data.py
# Input:  02_Dataset/raw_data/Global_Superstore2.csv
# Output: 02_Dataset/cleaned_data/sales_clean.csv
```

### Step 3: Process into Star Schema
```bash
python process_data.py
# Input:  02_Dataset/cleaned_data/sales_clean.csv
# Output: 02_Dataset/processed_data/fact_sales.csv
#         02_Dataset/processed_data/dim_customer.csv
#         02_Dataset/processed_data/dim_product.csv
#         02_Dataset/processed_data/dim_region.csv
#         02_Dataset/processed_data/dim_date.csv
```

---

## 📈 Quick Stats at a Glance

```
Total Revenue:      $12,642,501.68
Total Profit:       $1,467,456.52
Overall Margin:     11.6%
Total Orders:       25,035
Total Customers:    1,590
Total Products:     10,292
Countries Covered:  147
Markets:            7
Date Range:         Jan 2011 – Dec 2014
Avg Discount:       14.3%
Avg Order Value:    $505.09
```

---

*Last updated: June 22, 2026*
