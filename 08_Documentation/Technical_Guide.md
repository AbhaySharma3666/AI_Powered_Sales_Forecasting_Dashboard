# 🛠️ Technical Architecture & Setup Guide

> Complete technical reference for reproducing the AI-Powered Sales Forecasting Dashboard from scratch.

---

## 📋 Prerequisites

| Requirement | Minimum Version | Purpose |
|:---|:---|:---|
| Python | 3.10+ | Core runtime |
| MySQL | 8.0+ | Star schema database |
| Power BI Desktop | Latest | Dashboard development |
| Jupyter Notebook | Latest | Analytics notebooks |
| Git | 2.30+ | Version control |

---

## 📦 Python Dependencies

```
pandas>=2.0.0
numpy>=1.24.0
matplotlib>=3.7.0
seaborn>=0.12.0
scikit-learn>=1.3.0
scipy>=1.11.0
statsmodels>=0.14.0
prophet>=1.1.5
xgboost>=2.0.0
mlxtend>=0.22.0
plotly>=5.18.0
streamlit>=1.30.0
joblib>=1.3.0
```

### Installation
```bash
pip install -r requirements.txt
```

---

## 🗄️ Database Setup (Phase 2)

### Step 1: Create Database
```sql
CREATE DATABASE superstore_analytics;
USE superstore_analytics;
```

### Step 2: Run Schema Creation Scripts
Execute the scripts in `03_SQL/database_creation/` in order:
1. `create_tables.sql` — Creates fact and dimension tables
2. `insert_data.sql` — Populates tables from cleaned CSV

### Step 3: Verify Star Schema
```sql
SELECT 'fact_sales' AS tbl, COUNT(*) AS rows FROM fact_sales
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_region', COUNT(*) FROM dim_region
UNION ALL
SELECT 'dim_date', COUNT(*) FROM dim_date;
```

---

## 📊 Power BI Setup (Phase 4)

1. Open `04_PowerBI/AI_Powered_Sales_Forecasting.pbix` in Power BI Desktop
2. Update the MySQL data source connection if prompted
3. Refresh data to load the star schema tables
4. DAX measures are pre-configured in the report

---

## 🐍 Jupyter Notebooks (Phases 5-6)

### Advanced Analytics (Phase 5)
```bash
cd 05_Advanced_Analytics/notebooks
jupyter notebook
```
Run notebooks in order: `01_EDA.ipynb` → `02_RFM_Analysis.ipynb` → `03_Customer_Segmentation.ipynb` → `04_Correlation_Analysis.ipynb` → `05_Market_Basket_Analysis.ipynb`

### Machine Learning (Phase 6)
```bash
cd 06_Machine_Learning/notebooks
jupyter notebook
```
Run notebooks in order: `01_Time_Series_Preparation.ipynb` → `02_ARIMA_Model.ipynb` → `03_Prophet_Model.ipynb` → `04_XGBoost_Model.ipynb` → `05_Random_Forest_Model.ipynb` → `06_Model_Comparison.ipynb` → `07_Final_Forecast.ipynb`

---

## 🌐 Streamlit Web App (Phase 7)

### Local Development
```bash
streamlit run 07_Streamlit_App/app.py
```
The app launches at `http://localhost:8501`.

### Streamlit Cloud Deployment

1. Push repository to GitHub
2. Go to [share.streamlit.io](https://share.streamlit.io)
3. Connect your GitHub account
4. Select repository & set main file to `07_Streamlit_App/app.py`
5. Click Deploy

---

## 📁 Complete File Map

```
AI-Powered-Sales-Forecasting-Dashboard/
│
├── 01_Business_Understanding/
│   ├── Business_Understanding.txt     # Project charter & KPIs
│   └── README.md                      # Phase 1 documentation
│
├── 02_Dataset/
│   ├── raw_data/                      # Original Superstore dataset
│   ├── cleaned_data/
│   │   └── sales_clean.csv            # Production-ready dataset (51,290 rows)
│   └── processed_data/               # Star schema export files
│
├── 03_SQL/
│   ├── database_creation/             # CREATE TABLE & INSERT scripts
│   ├── business_queries/              # 50+ analytical SQL queries
│   ├── query_results/                 # Query output snapshots
│   ├── ER_Diagram/                    # Entity-Relationship diagrams
│   └── README.md                      # Phase 3 documentation
│
├── 04_PowerBI/
│   ├── AI_Powered_Sales_Forecasting.pbix  # Main Power BI report
│   ├── Dashboard_Screenshots/         # 5 page captures
│   ├── DAX_Measures/                  # Categorized DAX formulas
│   └── README.md                      # Phase 4 documentation
│
├── 05_Advanced_Analytics/
│   ├── notebooks/                     # 5 Jupyter notebooks (EDA to Market Basket)
│   ├── outputs/                       # rfm_scores.csv, customer_segments.csv
│   ├── visualizations/                # 17 analytical charts
│   └── README.md                      # Phase 5 documentation
│
├── 06_Machine_Learning/
│   ├── notebooks/                     # 7 ML notebooks (Prep to Final Forecast)
│   ├── models/                        # Serialized model files (.pkl)
│   ├── predictions/                   # Model predictions & final forecast CSVs
│   ├── evaluation/                    # model_comparison.csv
│   ├── visualizations/                # Forecast & comparison charts
│   └── README.md                      # Phase 6 documentation
│
├── 07_Streamlit_App/
│   ├── app.py                         # Landing page
│   ├── pages/                         # 7 analytics pages
│   ├── utils/                         # Data loaders, chart engine, helpers
│   ├── data/                          # Embedded app datasets
│   ├── assets/                        # Logo & CSS
│   └── README.md                      # Phase 7 documentation
│
├── 08_Documentation/
│   ├── Project_Report.md              # Comprehensive project report
│   └── Technical_Guide.md             # This file
│
├── 09_GitHub_Assets/
│   ├── banner.png                     # Repository header banner
│   └── screenshots/                   # Curated visual showcases
│
├── requirements.txt                   # Global Python dependencies
└── README.md                          # Repository overview
```
