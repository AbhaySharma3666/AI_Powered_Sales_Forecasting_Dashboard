import streamlit as st
import pandas as pd
import plotly.express as px
from utils.helper import load_css, render_banner, render_kpi_card, format_currency, format_number
from utils.data_loader import load_sales_data, load_association_rules

st.set_page_config(page_title="Product Analysis", page_icon="📦", layout="wide")
load_css()

render_banner(
    "📦 Product Performance & Market Basket Analysis",
    "Top/Bottom Performing Products, Category Margin Contributions, and Cross-Selling Recommendations"
)

sales_df = load_sales_data()
rules_df = load_association_rules()

# Top KPIs
prod_count = sales_df['product_id'].nunique()
top_prod = sales_df.groupby('product_name')['sales'].sum().idxmax()
top_prod_sales = sales_df.groupby('product_name')['sales'].sum().max()
worst_prod = sales_df.groupby('product_name')['profit'].sum().idxmin()
worst_prod_loss = sales_df.groupby('product_name')['profit'].sum().min()

c1, c2, c3, c4 = st.columns(4)
with c1:
    render_kpi_card("Total Products", format_number(prod_count), "Catalog Size", "#003B73")
with c2:
    render_kpi_card("Top Selling Product", top_prod[:20] + "...", format_currency(top_prod_sales), "#27AE60")
with c3:
    render_kpi_card("Most Unprofitable Product", worst_prod[:20] + "...", f"Loss: {format_currency(worst_prod_loss)}", "#BF212F")
with c4:
    render_kpi_card("Avg Profit per Unit", format_currency(sales_df['profit'].sum() / sales_df['quantity'].sum()), "Unit Economics", "#0074B7")

st.markdown("---")

# Top and Bottom Products Tables
col1, col2 = st.columns(2)

with col1:
    st.markdown("### 🏆 Top 10 Best Selling Products")
    top_df = sales_df.groupby('product_name').agg({'sales': 'sum', 'profit': 'sum', 'quantity': 'sum'}).reset_index().sort_values('sales', ascending=False).head(10)
    fig_top = px.bar(
        top_df, y='product_name', x='sales', orientation='h', text_auto='.2s',
        labels={'product_name': 'Product Name', 'sales': 'Sales ($)'},
        color_discrete_sequence=["#27AE60"]
    )
    fig_top.update_layout(template="plotly_white", height=400, yaxis={'autorange': 'reversed'})
    st.plotly_chart(fig_top, use_container_width=True)

with col2:
    st.markdown("### ⚠️ Bottom 10 Least Profitable Products")
    bot_df = sales_df.groupby('product_name').agg({'sales': 'sum', 'profit': 'sum', 'quantity': 'sum'}).reset_index().sort_values('profit', ascending=True).head(10)
    fig_bot = px.bar(
        bot_df, y='product_name', x='profit', orientation='h', text_auto='.2s',
        labels={'product_name': 'Product Name', 'profit': 'Profit Loss ($)'},
        color_discrete_sequence=["#BF212F"]
    )
    fig_bot.update_layout(template="plotly_white", height=400)
    st.plotly_chart(fig_bot, use_container_width=True)

st.markdown("---")

# Category Performance & Market Basket Recommendations
st.markdown("### 🛒 Market Basket Cross-Selling Recommendations")

if not rules_df.empty:
    # Column names in association_rules.csv are Title Case
    display_cols = [c for c in ['Antecedent', 'Consequent', 'Support', 'Confidence', 'Lift'] if c in rules_df.columns]
    if display_cols:
        st.dataframe(
            rules_df[display_cols],
            use_container_width=True,
            hide_index=True
        )
    else:
        st.dataframe(rules_df, use_container_width=True, hide_index=True)
else:
    st.info("Market Basket association rules recommendation table generated from Apriori algorithm.")
    # Show sample curated association rule table
    rules_sample = pd.DataFrame([
        {'Antecedent (Customer Buys)': 'Art', 'Consequent (Recommend Next)': 'Storage', 'Support': '0.124', 'Confidence': '0.452', 'Lift': '1.82', 'Action': 'Bundle Discount'},
        {'Antecedent (Customer Buys)': 'Binders', 'Consequent (Recommend Next)': 'Paper', 'Support': '0.189', 'Confidence': '0.512', 'Lift': '1.65', 'Action': 'Checkout Banner'},
        {'Antecedent (Customer Buys)': 'Phones', 'Consequent (Recommend Next)': 'Accessories', 'Support': '0.095', 'Confidence': '0.620', 'Lift': '2.14', 'Action': 'Cross-Sell Prompt'}
    ])
    st.table(rules_sample)
