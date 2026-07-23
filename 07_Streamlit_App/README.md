# 🚀 NEXUS AI — Enterprise Sales Forecasting & Analytics Streamlit App

> **Phase 7 Deliverable** — Complete Multi-Page Analytics Portal integrating SQL Business Intelligence, RFM Customer Segmentation, Product Analytics, Regional Density Mapping, and AI Machine Learning Forecasting.

---

## 📁 Application Architecture

```
07_Streamlit_App/
│
├── app.py                      # Main Portal Entry Point & Architecture Overview
│
├── pages/
│   ├── 1_Dashboard.py          # Executive Summary & Core KPIs
│   ├── 2_Sales_Analysis.py      # Multi-dimensional Sales & Filter Deep-Dives
│   ├── 3_Customer_Analysis.py   # RFM Customer Cohorts & K-Means Clusters
│   ├── 4_Product_Analysis.py    # Top/Bottom Products & Market Basket Rules
│   ├── 5_Regional_Analysis.py   # Global Map & Geographic Performance
│   ├── 6_Forecasting.py         # 12-Month Prophet Demand Forecast & Buffer Guide
│   └── 7_Model_Performance.py   # Benchmarking (Prophet vs XGBoost vs RF vs ARIMA)
│
├── assets/
│   ├── logo.png                # Platform branding logo
│   └── styles.css              # Custom CSS theme
│
├── data/                       # Embedded app datasets
│   ├── sales_clean.csv
│   ├── customer_segments.csv
│   ├── rfm_scores.csv
│   ├── final_12_month_forecast.csv
│   └── model_comparison.csv
│
├── utils/
│   ├── data_loader.py          # Cached data loading (@st.cache_data)
│   ├── charts.py               # Modular Plotly charting engine
│   └── helper.py               # Formatting & UI component helpers
│
├── requirements.txt            # Dependencies for deployment
└── README.md                   # Deployment documentation
```

---

## 💻 Local Execution Instructions

### 1. Prerequisite Setup
Ensure Python 3.10+ is installed on your machine.

### 2. Install Dependencies
```bash
pip install -r 07_Streamlit_App/requirements.txt
```

### 3. Launch the Application
Navigate to the project root and launch Streamlit:
```bash
streamlit run 07_Streamlit_App/app.py
```

The portal will automatically open in your default web browser at `http://localhost:8501`.

---

## ☁️ Deployment Guide: Streamlit Community Cloud

Follow these steps to deploy this application live on Streamlit Cloud for free:

### Step 1: Push Code to GitHub
Ensure all code and the `07_Streamlit_App/` folder are committed and pushed to your public GitHub repository:
```bash
git add .
git commit -m "Deploy Streamlit Analytics Portal Phase 7"
git push origin main
```

### Step 2: Sign In to Streamlit Community Cloud
1. Go to [share.streamlit.io](https://share.streamlit.io).
2. Sign in with your **GitHub account**.

### Step 3: Create New App Deployment
1. Click **"New App"** in the top right corner.
2. Fill in the repository details:
   - **Repository**: `AbhaySharma3666/AI_Powered_Sales_Forecasting_Dashboard` (or your repo name)
   - **Branch**: `main`
   - **Main file path**: `07_Streamlit_App/app.py`
3. Click **"Deploy!"**.

Streamlit Cloud will build the container, install packages from `requirements.txt`, and deploy the web portal to a live public URL!
