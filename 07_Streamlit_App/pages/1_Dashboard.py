import streamlit as st
import pandas as pd
from utils.helper import load_css, render_banner, render_kpi_card, format_currency, format_number
from utils.data_loader import load_sales_data
from utils.charts import plot_monthly_sales_trend, plot_sales_by_category, plot_sales_by_subcategory

st.set_page_config(page_title="Executive Dashboard", page_icon="🏠", layout="wide")
load_css()

render_banner(
    "🏠 Executive Dashboard Summary",
    "High-Level Performance Overview, Core KPIs, and Macro Revenue Trajectory"
)

sales_df = load_sales_data()

# Calculate Core KPIs
total_sales = sales_df['sales'].sum()
total_profit = sales_df['profit'].sum()
total_orders = sales_df['order_id'].nunique()
total_customers = sales_df['customer_id'].nunique()
profit_margin = (total_profit / total_sales) * 100

# Top KPI Row
k1, k2, k3, k4, k5 = st.columns(5)
with k1:
    render_kpi_card("Total Sales", format_currency(total_sales), "Historical 2011-2014", "#003B73")
with k2:
    render_kpi_card("Total Profit", format_currency(total_profit), f"{profit_margin:.1f}% Margin", "#27AE60")
with k3:
    render_kpi_card("Total Orders", format_number(total_orders), "Transactions", "#0074B7")
with k4:
    render_kpi_card("Total Customers", format_number(total_customers), "Unique Buyers", "#F39C12")
with k5:
    render_kpi_card("Profit Margin", f"{profit_margin:.2f}%", "Target >10%", "#27AE60")

st.markdown("---")

# Main Charts
c1, c2 = st.columns([2, 1])

with c1:
    st.plotly_chart(plot_monthly_sales_trend(sales_df), use_container_width=True)

with c2:
    st.plotly_chart(plot_sales_by_category(sales_df), use_container_width=True)

st.markdown("---")

# Secondary Charts Row
st.plotly_chart(plot_sales_by_subcategory(sales_df, top_n=10), use_container_width=True)
