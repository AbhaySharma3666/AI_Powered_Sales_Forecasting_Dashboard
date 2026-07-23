import streamlit as st
import pandas as pd
import plotly.express as px
from utils.helper import load_css, render_banner, render_kpi_card, format_currency, format_number
from utils.data_loader import load_sales_data
from utils.charts import plot_sales_by_category, plot_sales_by_subcategory, plot_discount_vs_profit

st.set_page_config(page_title="Sales Analysis", page_icon="📈", layout="wide")
load_css()

render_banner(
    "📈 Multi-Dimensional Sales & Profitability Analysis",
    "Interactive filtering across Year, Market, Region, and Category to evaluate growth drivers and margin leaks."
)

sales_df = load_sales_data()

# Sidebar Filters
st.sidebar.subheader("🔍 Interactive Filters")

years = ["All"] + sorted(sales_df['order_year'].unique().tolist())
selected_year = st.sidebar.selectbox("Select Year", years)

markets = ["All"] + sorted(sales_df['market'].unique().tolist())
selected_market = st.sidebar.selectbox("Select Market", markets)

categories = ["All"] + sorted(sales_df['category'].unique().tolist())
selected_category = st.sidebar.selectbox("Select Category", categories)

# Apply filters
filtered_df = sales_df.copy()
if selected_year != "All":
    filtered_df = filtered_df[filtered_df['order_year'] == selected_year]
if selected_market != "All":
    filtered_df = filtered_df[filtered_df['market'] == selected_market]
if selected_category != "All":
    filtered_df = filtered_df[filtered_df['category'] == selected_category]

# KPI Summary of Filtered Data
f_sales = filtered_df['sales'].sum()
f_profit = filtered_df['profit'].sum()
f_orders = filtered_df['order_id'].nunique()
f_margin = (f_profit / f_sales * 100) if f_sales > 0 else 0

c1, c2, c3, c4 = st.columns(4)
with c1:
    render_kpi_card("Filtered Sales", format_currency(f_sales), f"Selection: {selected_year}", "#003B73")
with c2:
    render_kpi_card("Filtered Profit", format_currency(f_profit), f"Margin: {f_margin:.1f}%", "#27AE60")
with c3:
    render_kpi_card("Filtered Orders", format_number(f_orders), "Order Count", "#0074B7")
with c4:
    render_kpi_card("Avg Order Value", format_currency(f_sales / f_orders if f_orders > 0 else 0), "Per Transaction", "#F39C12")

st.markdown("---")

# Yearly & Monthly Sales Analysis
col1, col2 = st.columns(2)

with col1:
    yearly_df = filtered_df.groupby('order_year')['sales'].sum().reset_index()
    fig_yr = px.bar(
        yearly_df, x='order_year', y='sales', text_auto='.2s',
        title="Yearly Sales Revenue Comparison",
        labels={'order_year': 'Year', 'sales': 'Sales ($)'},
        color_discrete_sequence=["#003B73"]
    )
    fig_yr.update_layout(template="plotly_white", height=380)
    st.plotly_chart(fig_yr, use_container_width=True)

with col2:
    monthly_df = filtered_df.groupby('order_month_name')['sales'].sum().reset_index()
    # Sort months chronologically
    month_order = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    monthly_df['order_month_name'] = pd.Categorical(monthly_df['order_month_name'], categories=month_order, ordered=True)
    monthly_df = monthly_df.sort_values('order_month_name')
    
    fig_m = px.line(
        monthly_df, x='order_month_name', y='sales', markers=True,
        title="Seasonality: Total Revenue by Month",
        labels={'order_month_name': 'Month', 'sales': 'Sales ($)'},
        color_discrete_sequence=["#0074B7"]
    )
    fig_m.update_layout(template="plotly_white", height=380)
    st.plotly_chart(fig_m, use_container_width=True)

st.markdown("---")

# Category and Discount Analysis
col3, col4 = st.columns(2)

with col3:
    st.plotly_chart(plot_sales_by_subcategory(filtered_df, top_n=10), use_container_width=True)

with col4:
    st.plotly_chart(plot_discount_vs_profit(filtered_df), use_container_width=True)
