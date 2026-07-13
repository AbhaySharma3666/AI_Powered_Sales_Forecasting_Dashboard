# 📋 01_Business_Understanding

> Foundation phase of the AI-Powered Sales Forecasting Dashboard — defining the business problem, objectives, KPIs, and data strategy before any analysis begins.

---

## 📁 Folder Contents

| File | Description |
|------|-------------|
| `Business_Understanding.txt` | Complete business document (Charter, Requirements, KPIs, Data Dictionary, Schema) |
| `README.md` | This file — overview and quick reference |

---

## 🎯 Project Objective

Build an **enterprise-grade BI and ML solution** that transforms raw Global Superstore sales data into:

1. **Actionable business insights** via SQL analytics & Power BI dashboards
2. **Customer intelligence** via RFM segmentation & clustering
3. **Predictive forecasts** via ML models (Prophet, XGBoost)
4. **Interactive web app** deployed on Streamlit Cloud

---

## 🔍 Business Problem

The Global Superstore operates across **147 countries** in **7 markets** with **$12.6M** in annual revenue. Key business challenges include:

| Challenge | Impact |
|-----------|--------|
| No demand forecasting | Inventory waste & stockouts |
| Unknown customer churn risk | Lost revenue from departing customers |
| Unclear regional profitability | Misallocated resources |
| No product performance visibility | Keeping unprofitable items |
| Unoptimized discount strategy | 24.4% of transactions are loss-making |

---

## 📊 KPI Framework

### Primary KPIs

| KPI | Formula | Purpose |
|-----|---------|---------|
| **Total Revenue** | `SUM(Sales)` | Track overall business performance |
| **Total Profit** | `SUM(Profit)` | Measure profitability |
| **Profit Margin %** | `Profit / Revenue × 100` | Efficiency indicator (target: >10%) |
| **Total Orders** | `COUNT(DISTINCT Order ID)` | Volume tracking |
| **Avg Order Value** | `Revenue / Orders` | Transaction size benchmark |
| **Customer Count** | `COUNT(DISTINCT Customer ID)` | Market reach |

### Growth KPIs

| KPI | Formula | Purpose |
|-----|---------|---------|
| **YoY Growth** | `(Current Year − Previous) / Previous` | Annual momentum |
| **MoM Growth** | `(Current Month − Previous) / Previous` | Monthly trend |
| **Repeat Purchase Rate** | `Repeat Buyers / Total Customers` | Loyalty metric (target: >30%) |

### Operational KPIs

| KPI | Formula | Purpose |
|-----|---------|---------|
| **Avg Shipping Days** | `AVG(Ship Date − Order Date)` | Fulfillment speed (target: <5 days) |
| **Avg Discount** | `AVG(Discount)` | Pricing strategy (target: <20%) |
| **Loss Rate** | `Negative Profit Orders / Total` | Identify margin leaks (target: <25%) |

### Forecasting KPIs

| KPI | Formula | Purpose |
|-----|---------|---------|
| **MAPE** | Mean Absolute Percentage Error | Forecast accuracy (target: <15%) |
| **R² Score** | Coefficient of Determination | Model fit (target: >0.80) |
| **MAE** | Mean Absolute Error | Prediction deviation |
| **RMSE** | Root Mean Squared Error | Penalizes large errors |

---

## 📈 Data Overview

| Property | Value |
|----------|-------|
| **Source** | [Kaggle — Global Super Store](https://www.kaggle.com/datasets/apoorvaappz/global-super-store-dataset) |
| **Records** | 51,290 transactions |
| **Orders** | 25,035 unique |
| **Customers** | 1,590 unique |
| **Products** | 10,292 unique |
| **Countries** | 147 |
| **Date Range** | Jan 2011 – Dec 2014 |
| **Total Revenue** | $12,642,501.68 |
| **Total Profit** | $1,467,456.52 |
| **Overall Margin** | 11.6% |

---

## 🗄️ Star Schema Design

The data warehouse follows a **star schema** optimized for analytical queries and Power BI modeling:

```
                         ┌──────────────┐
                         │ dim_customer │
                         │  (1,590)     │
                         └──────┬───────┘
                                │
┌──────────────┐      ┌────────┴────────┐      ┌──────────────┐
│ dim_product  │──────│   fact_sales    │──────│  dim_region  │
│  (10,292)    │      │   (51,290)      │      │  (3,819)     │
└──────────────┘      └────────┬────────┘      └──────────────┘
                                │
                         ┌──────┴───────┐
                         │   dim_date   │
                         │  (1,468)     │
                         └──────────────┘
```

### Tables

| Table | Rows | Key Columns |
|-------|------|-------------|
| **fact_sales** | 51,290 | Sales, Profit, Quantity, Discount, Shipping Cost |
| **dim_customer** | 1,590 | Customer Name, Segment, City, Country |
| **dim_product** | 10,292 | Product Name, Category, Sub-Category |
| **dim_region** | 3,819 | Market, Region, Country, State, City |
| **dim_date** | 1,468 | Full Date, Day/Month/Quarter/Year, Fiscal Year |

---

## 🗺️ Market & Region Breakdown

### 7 Markets

| Market | Coverage |
|--------|----------|
| 🇺🇸 US | United States |
| 🌏 APAC | Asia Pacific (Australia, Japan, India, etc.) |
| 🇪🇺 EU | European Union |
| 🌍 EMEA | Europe, Middle East & Africa |
| 🌎 LATAM | Latin America & Caribbean |
| 🌍 Africa | African continent |
| 🇨🇦 Canada | Canada |

### 13 Regions

| Region | Market |
|--------|--------|
| East, West, Central, South | US |
| Oceania, Southeast Asia, North Asia, Central Asia | APAC |
| North, South | EU |
| EMEA | EMEA |
| Caribbean | LATAM |
| Africa | Africa |
| Canada | Canada |

---

## 🏗️ Project Phases

```
Phase 1 → Business Understanding          (this phase)
      ↓
Phase 2 → Data Preparation & Star Schema
      ↓
Phase 3 → SQL Business Analytics (50+ queries)
      ↓
Phase 4 → Power BI Dashboard Development
      ↓
Phase 5 → Executive Power BI Dashboard (5 pages)
      ↓
Phase 6 → Python Advanced Analytics (RFM + Clustering)
      ↓
Phase 7 → ML Sales Forecasting (Prophet / XGBoost)
      ↓
Phase 8 → Streamlit App Deployment
```

---

## 🧰 Technology Stack

| Layer | Technology |
|-------|-----------|
| **Database** | MySQL (Star Schema) |
| **BI Tool** | Power BI (DAX Measures) |
| **Data Processing** | Python — Pandas, NumPy |
| **Visualization** | Matplotlib, Seaborn, Plotly |
| **Machine Learning** | Scikit-learn, XGBoost, Prophet, Statsmodels |
| **Deployment** | Streamlit, Streamlit Cloud |
| **Version Control** | Git & GitHub |

---

## 📦 Deliverables Checklist

### Phase 1 — Business Understanding
- [x] Project Charter
- [x] Business Requirements (25 core questions)
- [x] KPI Definitions (16 KPIs across 4 categories)
- [x] Data Dictionary
- [x] Star Schema Design

### Phase 2 — Data Preparation
- [x] Raw data download from Kaggle
- [x] Data cleaning (0 nulls, 0 duplicates)
- [x] Star schema transformation (5 tables)

### Phase 3–8 — Remaining
- [ ] SQL Analytics (50+ queries)
- [ ] Power BI Dashboard (5 pages)
- [ ] Customer Segmentation (RFM + KMeans)
- [ ] Sales Forecasting (Prophet/XGBoost)
- [ ] Streamlit Deployment
- [ ] Final Documentation

---

## 📝 25 Core Business Questions

### Sales Performance (Q1–Q5)
1. What is the total sales revenue?
2. What is the total profit and overall profit margin?
3. How has revenue trended monthly, quarterly, and yearly?
4. Which months show peak and trough sales?
5. What is the year-over-year growth rate?

### Product Analysis (Q6–Q10)
6. Which are the Top 10 products by revenue?
7. Which are the Bottom 10 underperforming products?
8. Which products generate the highest profit margins?
9. How does each category contribute to total revenue?
10. Which sub-categories are losing money?

### Customer Analysis (Q11–Q15)
11. Who are the Top 10 customers by lifetime value?
12. How many customers are repeat buyers?
13. What is the CLV distribution?
14. Which customer segment is most profitable?
15. Which customers are at risk of churning?

### Regional Analysis (Q16–Q20)
16. Which market/region generates the most revenue?
17. Which region has the worst profitability?
18. How do product preferences vary by region?
19. Which cities are the top revenue contributors?
20. What is the geographic distribution of orders?

### Advanced Analytics (Q21–Q25)
21. What are the RFM scores for each customer?
22. How many distinct customer clusters exist?
23. Which customers should receive promotional offers?
24. What are the predicted sales for the next 12 months?
25. Which ML model provides the most accurate forecast?

---

*Last updated: June 22, 2026*
