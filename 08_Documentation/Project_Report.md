# 📚 AI-Powered Sales Forecasting Dashboard — Project Report

> **Comprehensive Technical & Business Documentation**
> Prepared by: Abhay Sharma | July 2026

---

## 📋 Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Business Problem & Objectives](#2-business-problem--objectives)
3. [Data Architecture & Star Schema](#3-data-architecture--star-schema)
4. [SQL Business Analytics](#4-sql-business-analytics)
5. [Power BI Dashboard](#5-power-bi-dashboard)
6. [Python Advanced Analytics](#6-python-advanced-analytics)
7. [Machine Learning Sales Forecasting](#7-machine-learning-sales-forecasting)
8. [Streamlit Web Application](#8-streamlit-web-application)
9. [Key Business Insights & Recommendations](#9-key-business-insights--recommendations)
10. [Technology Stack](#10-technology-stack)
11. [Future Enhancements](#11-future-enhancements)

---

## 1. Executive Summary

This project demonstrates a **complete end-to-end data analytics pipeline** — from raw transactional data to AI-powered predictive forecasting deployed as an interactive web application.

### Key Achievements

| Metric | Result |
|:---|:---|
| **Dataset Processed** | 51,290 transactions across 147 countries (2011–2014) |
| **SQL Queries Developed** | 50+ business intelligence queries |
| **Power BI Dashboard** | 6 pages, 105 visuals, categorized DAX measures |
| **Customer Segments Identified** | 1,590 customers segmented via RFM + K-Means |
| **Forecasting Accuracy (MAPE)** | **8.62%** (Target was <15%) |
| **Projected 2015 Revenue** | **$5,135,726** (+19.44% YoY growth) |
| **Web App Pages** | 7 interactive Streamlit pages deployed |

---

## 2. Business Problem & Objectives

### Problem Statement
A global retail business needed a unified analytics platform to:
- Understand historical sales patterns and profitability drivers
- Identify high-value customer segments for targeted marketing
- Predict future monthly sales demand for inventory planning
- Provide stakeholders with self-service interactive dashboards

### KPI Framework

| KPI | Definition | Baseline (2014) |
|:---|:---|:---|
| Total Revenue | Sum of all sales transactions | $4,299,865 |
| Total Profit | Net profit after discounts/costs | $504,166 |
| Profit Margin | Profit / Revenue × 100 | 11.60% |
| Average Order Value | Revenue / Unique Orders | ~$200 |
| Customer Lifetime Value | Total revenue per customer | $7,958 |

### Project Workflow

```
Phase 1: Business Understanding
        ↓
Phase 2: Star Schema (SQL Database Design)
        ↓
Phase 3: SQL Business Analytics (50+ Queries)
        ↓
Phase 4: Power BI Dashboard (6 Pages)
        ↓
Phase 5: Python Advanced Analytics (RFM + Clustering)
        ↓
Phase 6: Machine Learning Forecasting (4 Models)
        ↓
Phase 7: Streamlit Web App Deployment (7 Pages)
```

---

## 3. Data Architecture & Star Schema

### Database Design
The raw Superstore Global dataset was transformed into a **star schema** optimized for analytical queries:

```
                          dim_customer (1,590 rows)
                               |
        dim_product  ───  fact_sales  ───  dim_region
        (10,292 rows)    (51,290 rows)    (147 countries)
                               |
                          dim_date (1,461 days)
```

### Fact Table: `fact_sales`
| Column | Type | Description |
|:---|:---|:---|
| order_id | VARCHAR | Unique transaction identifier |
| sales | DECIMAL | Revenue amount |
| profit | DECIMAL | Net profit after discounts |
| quantity | INT | Units sold |
| discount | DECIMAL | Discount rate applied |
| shipping_cost | DECIMAL | Logistics cost |

### Dimension Tables
- **`dim_customer`**: customer_id, customer_name, segment (Consumer/Corporate/Home Office)
- **`dim_product`**: product_id, category, sub_category, product_name
- **`dim_region`**: country, city, state, market, region
- **`dim_date`**: order_date, year, month, quarter, day_of_week, is_weekend

---

## 4. SQL Business Analytics

### Query Categories (50+ Queries)

| Category | Query Count | Techniques Used |
|:---|:---:|:---|
| Sales Performance | 15 | Aggregation, GROUP BY, HAVING |
| Customer Analytics | 12 | Window Functions, RANK, NTILE |
| Product Intelligence | 10 | CTEs, Subqueries, CASE WHEN |
| Regional Analysis | 8 | JOINs, Cross-tabulation |
| Time Series SQL | 8 | DATE functions, LAG/LEAD, YoY Growth |

### Example Advanced Queries
- **YoY Revenue Growth** using `LAG()` window function
- **Customer RFM Scoring** via `NTILE()` quartile binning
- **Running Totals** with cumulative `SUM() OVER(ORDER BY)`
- **Market Share %** using `SUM() OVER(PARTITION BY)`

---

## 5. Power BI Dashboard

### Dashboard Architecture: 6 Pages

| # | Page | Key Visuals |
|:---|:---|:---|
| 1 | Executive Summary | KPI cards, revenue trend, profit waterfall |
| 2 | Product & Sales Analysis | Category bars, sub-category rankings, discount scatter |
| 3 | Customer Insights | Segment distribution, top customers, purchase patterns |
| 4 | Regional Performance | Geographic map, market comparison, city rankings |
| 5 | Regional Deep Dive | Country-level heatmap, shipping mode analysis |
| 6 | Time Intelligence | MoM/QoQ/YoY growth, moving averages, forecasting |

### DAX Measures Developed
Over 30 categorized DAX measures including:
- **Revenue Metrics**: Total Sales, YoY Growth %, Running Total
- **Profitability**: Profit Margin %, Gross Profit, Net Yield
- **Customer Metrics**: Customer Count, Avg CLV, Repeat Rate
- **Time Intelligence**: MTD, QTD, YTD, Same Period Last Year

---

## 6. Python Advanced Analytics

### Notebooks Developed

| # | Notebook | Objective | Key Output |
|:---|:---|:---|:---|
| 01 | EDA | Exploratory Data Analysis | Distribution plots, correlation matrix |
| 02 | RFM Analysis | Customer value scoring | rfm_scores.csv (1,590 customers) |
| 03 | Customer Segmentation | K-Means ML clustering | customer_segments.csv (4 clusters) |
| 04 | Correlation Analysis | Feature relationships | Heatmaps, scatter matrices |
| 05 | Market Basket Analysis | Cross-sell recommendations | association_rules.csv |

### RFM Customer Segments

| Segment | Count | % of Total | Business Action |
|:---|:---:|:---:|:---|
| Champions | 352 | 22.1% | VIP loyalty program |
| Loyal Customers | 238 | 15.0% | Upsell premium products |
| Potential Loyalists | 195 | 12.3% | Nurture with engagement |
| At Risk | 192 | 12.1% | Urgent win-back campaigns |
| Lost Customers | 385 | 24.2% | Reactivation email series |
| Others | 228 | 14.3% | Segment-specific offers |

### K-Means Clustering (4 Segments)
- **Cluster 0 — High-Value**: Top spenders, frequent, recent purchases
- **Cluster 1 — Mid-Value Active**: Moderate spend, steady purchase cadence
- **Cluster 2 — Low-Value Occasional**: Infrequent, small basket sizes
- **Cluster 3 — Inactive/Dormant**: Haven't purchased in 6+ months

---

## 7. Machine Learning Sales Forecasting

### Methodology

```
sales_clean.csv (51,290 transactions)
        ↓
Monthly Aggregation (48 data points: 2011-2014)
        ↓
Feature Engineering (Lag features, rolling stats, calendar vars)
        ↓
Chronological Train/Test Split (Train: 2012-2013, Test: 2014)
        ↓
┌──────────┬──────────┬──────────┬───────────────┐
│  ARIMA   │ Prophet  │ XGBoost  │ Random Forest │
└──────────┴──────────┴──────────┴───────────────┘
        ↓
Model Evaluation (MAE, RMSE, MAPE, R²)
        ↓
Best Model Selection → Prophet
        ↓
Retrain on Full Data (2011-2014)
        ↓
12-Month Forecast → final_12_month_forecast.csv
```

### Model Performance Comparison (Test Set: 2014)

| Model | MAPE (%) | MAE ($) | RMSE ($) | R² Score |
|:---|:---:|:---:|:---:|:---:|
| 🏆 **Facebook Prophet** | **8.62%** | **$33,960** | **$48,177** | **0.84** |
| Random Forest | 17.64% | $71,106 | $87,750 | 0.46 |
| XGBoost | 18.79% | $75,468 | $96,598 | 0.35 |
| ARIMA (SARIMAX) | 19.39% | $75,419 | $89,384 | 0.44 |

### Why Prophet Won
1. **Multiplicative Seasonality**: Naturally models retail sales where seasonal amplitude scales with trend
2. **Fourier-Based Yearly Patterns**: Captures complex Q4 holiday spikes without manual feature engineering
3. **Data Efficiency**: Robust performance on just 48 monthly observations
4. **Built-in Uncertainty**: Generates 95% confidence intervals for risk planning

### 12-Month Forecast Results (2015)

| Metric | Value |
|:---|:---|
| **2014 Actual Revenue** | $4,299,865 |
| **2015 Projected Revenue** | $5,135,726 |
| **Projected YoY Growth** | +19.44% |
| **Peak Demand Month** | November 2015 (Q4 seasonal spike) |
| **Lower Bound (95% CI)** | ~$4.2M |
| **Upper Bound (95% CI)** | ~$6.1M |

---

## 8. Streamlit Web Application

### Application Architecture

```
07_Streamlit_App/
├── app.py                        # Portal landing page
├── pages/
│   ├── 1_Dashboard.py            # Executive KPI summary
│   ├── 2_Sales_Analysis.py       # Multi-filter sales deep dive
│   ├── 3_Customer_Analysis.py    # RFM segments & K-Means clusters
│   ├── 4_Product_Analysis.py     # Product rankings & market basket
│   ├── 5_Regional_Analysis.py    # Geographic choropleth map
│   ├── 6_Forecasting.py          # Prophet 12-month forecast
│   └── 7_Model_Performance.py    # ML model benchmarking
├── utils/                        # Shared data loaders & chart engine
├── data/                         # Embedded datasets
└── assets/                       # Logo & CSS theme
```

### Page Features

| Page | Key Features |
|:---|:---|
| **Dashboard** | 5 KPI cards, monthly revenue trend, category distribution |
| **Sales Analysis** | Year/Market/Category interactive filters, discount impact scatter |
| **Customer Analysis** | RFM donut chart, PCA cluster scatter, searchable directory, CSV export |
| **Product Analysis** | Top/bottom product rankings, Apriori cross-sell recommendations |
| **Regional Analysis** | Plotly interactive world choropleth, market & city performance bars |
| **Forecasting** | Historical + forecast timeline with 95% CI, operations buffer guidelines |
| **Model Performance** | MAPE/MAE/RMSE/R² comparison bars, technical model selection rationale |

---

## 9. Key Business Insights & Recommendations

### Finding 1: The Discount-Profit Paradox
> Discounts exceeding 20% cause a **dramatic margin erosion** — many transactions above 20% discount become unprofitable.

**Action**: Cap standard customer discounts at 20%. Reserve higher discounts only for strategic clearance events.

### Finding 2: Q4 Seasonal Revenue Spike
> Sales consistently surge 40-60% in Q4 (October–December) annually driven by holiday retail demand.

**Action**: Begin inventory capacity scaling in August/September. Increase warehousing buffer by 19.4% compared to 2014 baseline.

### Finding 3: Customer Churn Risk
> 24.2% of customers are classified as "Lost" and 12.1% as "At Risk" based on RFM scoring.

**Action**: Deploy automated re-engagement email campaigns targeting At-Risk customers with personalized offers before they transition to Lost status.

### Finding 4: Product Cross-Sell Opportunities
> Market Basket Analysis reveals that Art → Storage and Binders → Paper are frequently co-purchased.

**Action**: Implement checkout page "frequently bought together" recommendations and bundle discount promotions.

### Finding 5: Geographic Revenue Concentration
> The top 10 cities account for a disproportionate share of total revenue, with significant untapped potential in emerging markets.

**Action**: Invest in localized marketing campaigns for high-potential underserved regions.

---

## 10. Technology Stack

| Layer | Technology | Purpose |
|:---|:---|:---|
| **Database** | MySQL | Star schema relational data warehouse |
| **BI Tool** | Power BI Desktop | Interactive dashboard with DAX formulas |
| **Analytics** | Python, Pandas, NumPy | Data wrangling, EDA, feature engineering |
| **ML Models** | Facebook Prophet, XGBoost, Scikit-learn, Statsmodels | Time series forecasting |
| **Visualization** | Matplotlib, Seaborn, Plotly Express | Static & interactive charts |
| **Web App** | Streamlit | Multi-page interactive analytics portal |
| **Version Control** | Git & GitHub | Code versioning and collaboration |

---

## 11. Future Enhancements

1. **Real-Time Data Pipeline**: Connect to live transactional databases via ETL (Apache Airflow / dbt)
2. **Deep Learning Models**: Experiment with LSTM / Transformer architectures for time-series forecasting
3. **A/B Testing Framework**: Measure the business impact of discount policy changes recommended above
4. **Cloud Deployment**: Deploy Streamlit app to Streamlit Community Cloud or AWS for enterprise access
5. **Automated Retraining**: Implement MLOps pipeline for automatic model retraining as new data arrives
