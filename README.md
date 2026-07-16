# 🚀 AI-Powered Sales Forecasting Dashboard

An enterprise-grade Business Intelligence and Machine Learning project that transforms raw sales data into actionable insights and predictive forecasts.

## 📋 Project Overview

This project demonstrates a complete data analytics pipeline — from SQL database design to interactive ML-powered dashboards — mirroring how professional analytics teams operate.

## 🏗️ Project Phases

| Phase | Description |
|-------|------------|
| **Phase 1** | Business Understanding
| **Phase 2** | Data Preparation & Star Schema
| **Phase 3** | SQL Business Analytics (50+ Queries)
| **Phase 4** | Power BI Dashboard Development
| **Phase 5** | Executive Power BI Dashboard (5 Pages)
| **Phase 6** | Python Advanced Analytics (RFM & Clustering)
| **Phase 7** | ML Sales Forecasting (Prophet/XGBoost)
| **Phase 8** | Streamlit App Deployment

## 🗄️ Star Schema Design

```
                dim_customer
                     |
dim_product --- fact_sales --- dim_region
                     |
                 dim_date
```

### Fact Table: `fact_sales`
- Sales, Profit, Quantity, Discount

### Dimension Tables
- `dim_customer` — Customer details & segments
- `dim_product` — Product categories & sub-categories
- `dim_region` — Geographic data
- `dim_date` — Time hierarchy (Day → Month → Quarter → Year)

## 🤖 Machine Learning Models

| Model | Purpose |
|-------|---------|
| Linear Regression | Baseline prediction |
| Random Forest | Ensemble learning |
| XGBoost | Gradient boosting |
| **Prophet** | Time series forecasting (Main Model) |

### Evaluation Metrics
- MAE (Mean Absolute Error)
- RMSE (Root Mean Squared Error)
- MAPE (Mean Absolute Percentage Error)
- R² (Coefficient of Determination)

## 📁 Project Structure

```
AI-Powered-Sales-Forecasting-Dashboard/
├── 01_Business_Understanding/     # Project charter, data dictionary, KPIs
├── 02_Dataset/                    # Raw, cleaned, and processed data
│   ├── raw_data/
│   ├── cleaned_data/
│   └── processed_data/
├── 03_SQL/                        # Database creation & 50+ business queries
│   ├── database_creation/
│   ├── business_queries/
│   ├── query_results/
│   └── ER_Diagram/
├── 04_PowerBI/                    # Dashboard files & DAX measures
│   ├── Dashboard_Screenshots/
│   ├── DAX_Measures/
│   └── Reports/
├── 05_Advanced_Analytics/         # EDA, RFM, customer segmentation
│   ├── notebooks/
│   ├── outputs/
│   └── visualizations/
├── 06_Machine_Learning/           # ML models & forecasting
│   ├── notebooks/
│   ├── saved_models/
│   ├── predictions/
│   └── evaluation/
├── 07_Streamlit_App/              # Deployed interactive dashboard
│   ├── pages/
│   ├── assets/
│   └── models/
├── 08_Documentation/              # Reports & presentations
└── 09_GitHub_Assets/              # Banners, screenshots, GIFs
    └── screenshots/
```

## 🛠️ Tech Stack

- **Database**: MySQL
- **BI Tool**: Power BI (DAX)
- **Analytics**: Python (Pandas, NumPy, Scikit-learn)
- **ML/Forecasting**: Prophet, XGBoost, ARIMA
- **Visualization**: Matplotlib, Seaborn, Plotly
- **Deployment**: Streamlit
- **Version Control**: Git & GitHub

## 🚀 Getting Started

1. Clone this repository
2. Install Python dependencies: `pip install -r requirements.txt`
3. Set up MySQL database using scripts in `03_SQL/database_creation/`
4. Open Power BI dashboards in `04_PowerBI/`
5. Run Jupyter notebooks in `05_Advanced_Analytics/` and `06_Machine_Learning/`
6. Launch Streamlit app: `streamlit run 07_Streamlit_App/app.py`

## 📊 Key Business Insights

_To be populated after analysis completion._

## 📝 License

This project is for educational and portfolio purposes.
