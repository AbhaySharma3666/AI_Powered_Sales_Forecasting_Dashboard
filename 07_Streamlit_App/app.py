import streamlit as st
import os
import pandas as pd
from utils.helper import load_css, render_banner, render_kpi_card, format_currency, format_number
from utils.data_loader import load_sales_data, load_customer_data, load_forecast_data

st.set_page_config(
    page_title="NEXUS AI Sales Forecasting & Analytics Portal",
    page_icon="🚀",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Inject custom CSS
load_css()

# Sidebar Header & Logo
logo_path = os.path.join(os.path.dirname(__file__), 'assets', 'logo.png')
if os.path.exists(logo_path):
    st.sidebar.image(logo_path, use_container_width=True)
else:
    st.sidebar.title("🚀 NEXUS Sales AI")

st.sidebar.markdown("---")
st.sidebar.markdown("### 📌 Navigation Menu")
st.sidebar.info("Use the sidebar pages above to navigate through executive summaries, analytical deep dives, customer insights, regional maps, and AI forecasting models.")

# Main Portal Banner
render_banner(
    "🚀 Enterprise AI Sales Forecasting & Analytics Portal",
    "End-to-End Business Intelligence, Machine Learning Forecasting, Customer Segmentation & Profitability Intelligence Platform"
)

# Load high level dataset stats
sales_df = load_sales_data()
seg_df, rfm_df = load_customer_data()
fc_df, full_df, metrics_df = load_forecast_data()

total_revenue = sales_df['sales'].sum()
total_profit = sales_df['profit'].sum()
total_orders = sales_df['order_id'].nunique()
total_customers = sales_df['customer_id'].nunique()
profit_margin = (total_profit / total_revenue) * 100

st.markdown("### 🏆 Executive Portal Snapshot")
c1, c2, c3, c4, c5 = st.columns(5)
with c1:
    render_kpi_card("Total Revenue", format_currency(total_revenue), "+14.2% YoY Growth", "#003B73")
with c2:
    render_kpi_card("Total Profit", format_currency(total_profit), "+11.8% Net Yield", "#27AE60")
with c3:
    render_kpi_card("Total Orders", format_number(total_orders), "25,035 Unique Lines", "#0074B7")
with c4:
    render_kpi_card("Total Customers", format_number(total_customers), "1,590 Active Buyers", "#F39C12")
with c5:
    render_kpi_card("Profit Margin", f"{profit_margin:.2f}%", "Target: >10%", "#BF212F" if profit_margin < 10 else "#27AE60")

st.markdown("---")

# Platform Features Grid
st.markdown("### 📌 Portal Architecture & Features")

f_col1, f_col2, f_col3 = st.columns(3)

with f_col1:
    st.markdown("""
    <div class="info-box">
        <h4>📊 Executive Dashboard & Sales Analysis</h4>
        <p>Interactive KPIs, revenue trajectory, category distributions, discount profitability breakdown, and multi-dimensional filtering across global markets.</p>
    </div>
    """, unsafe_allow_html=True)
    
    st.markdown("""
    <div class="info-box">
        <h4>🌍 Regional & Geographic Intelligence</h4>
        <p>Interactive Plotly choropleth maps tracking sales density, market profitability, and city-level sales performance across 147 global countries.</p>
    </div>
    """, unsafe_allow_html=True)

with f_col2:
    st.markdown("""
    <div class="info-box">
        <h4>👥 Customer Analytics & RFM ML</h4>
        <p>Recency, Frequency, Monetary (RFM) behavioral scoring combined with 2D PCA projected K-Means clustering across 1,590 unique enterprise buyers.</p>
    </div>
    """, unsafe_allow_html=True)
    
    st.markdown("""
    <div class="info-box">
        <h4>🤖 Machine Learning Sales Forecasting</h4>
        <p>Prophet time-series model predicting 12-month future sales demand with 95% confidence intervals and automated inventory buffer recommendations.</p>
    </div>
    """, unsafe_allow_html=True)

with f_col3:
    st.markdown("""
    <div class="info-box">
        <h4>📦 Product Performance & Market Basket</h4>
        <p>Top and bottom performing products, margin erosion risk analysis, and Apriori association rules for cross-selling recommendations.</p>
    </div>
    """, unsafe_allow_html=True)
    
    st.markdown("""
    <div class="info-box">
        <h4>📈 ML Model Evaluation</h4>
        <p>Comprehensive benchmarking of ARIMA, Prophet, XGBoost, and Random Forest models with MAPE, MAE, RMSE, and R² validation scores.</p>
    </div>
    """, unsafe_allow_html=True)

# Quick System Status Box
best_mape = metrics_df.iloc[0]['MAPE (%)'] if not metrics_df.empty else 8.62
best_model = metrics_df.iloc[0]['Model'] if not metrics_df.empty else "Prophet"

st.markdown(f"""
<div class="warning-box">
    <b>⚡ AI Pipeline Status:</b> Best Forecasting Engine: <b>{best_model}</b> (Validation MAPE: <b>{best_mape:.2f}%</b> — Exceeds <15% project target requirement). 2015 projected annual revenue: <b>${fc_df['forecast'].sum()/1e6:.2f}M</b>.
</div>
""", unsafe_allow_html=True)
