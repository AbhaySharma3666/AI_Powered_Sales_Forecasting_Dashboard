import streamlit as st
import pandas as pd
import plotly.express as px
from utils.helper import load_css, render_banner, render_kpi_card, format_currency, format_number
from utils.data_loader import load_sales_data
from utils.charts import plot_regional_choropleth

st.set_page_config(page_title="Regional Analysis", page_icon="🌍", layout="wide")
load_css()

render_banner(
    "🌍 Regional & Geographic Intelligence",
    "Geographic Sales Densities, Global Market Performance, and City-Level Revenue Breakdowns"
)

sales_df = load_sales_data()

# Regional KPIs
country_count = sales_df['country'].nunique()
market_count = sales_df['market'].nunique()
top_market = sales_df.groupby('market')['sales'].sum().idxmax()
top_market_sales = sales_df.groupby('market')['sales'].sum().max()
top_country = sales_df.groupby('country')['sales'].sum().idxmax()

c1, c2, c3, c4 = st.columns(4)
with c1:
    render_kpi_card("Global Markets", format_number(market_count), "7 Global Regions", "#003B73")
with c2:
    render_kpi_card("Total Countries", format_number(country_count), "147 Territories", "#0074B7")
with c3:
    render_kpi_card("Top Market", top_market, format_currency(top_market_sales), "#27AE60")
with c4:
    render_kpi_card("Top Country", top_country, format_currency(sales_df.groupby('country')['sales'].sum().max()), "#F39C12")

st.markdown("---")

# Global Interactive Map
st.plotly_chart(plot_regional_choropleth(sales_df), use_container_width=True)

st.markdown("---")

# Market & Region Performance Breakdowns
col1, col2 = st.columns(2)

with col1:
    mkt_df = sales_df.groupby('market').agg({'sales': 'sum', 'profit': 'sum'}).reset_index().sort_values('sales', ascending=False)
    fig_mkt = px.bar(
        mkt_df, x='market', y='sales', text_auto='.2s', color='market',
        title="Sales Volume by Global Market",
        labels={'market': 'Market', 'sales': 'Sales ($)'},
        color_discrete_sequence=px.colors.qualitative.Bold
    )
    fig_mkt.update_layout(template="plotly_white", showlegend=False, height=380)
    st.plotly_chart(fig_mkt, use_container_width=True)

with col2:
    city_df = sales_df.groupby('city').agg({'sales': 'sum', 'profit': 'sum'}).reset_index().sort_values('sales', ascending=False).head(10)
    fig_city = px.bar(
        city_df, y='city', x='sales', orientation='h', text_auto='.2s',
        title="Top 10 Cities by Revenue Volume",
        labels={'city': 'City', 'sales': 'Sales ($)'},
        color_discrete_sequence=["#0074B7"]
    )
    fig_city.update_layout(template="plotly_white", height=380, yaxis={'autorange': 'reversed'})
    st.plotly_chart(fig_city, use_container_width=True)
