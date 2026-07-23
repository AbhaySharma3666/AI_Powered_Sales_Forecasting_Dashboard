import streamlit as st
import pandas as pd
import plotly.graph_objects as go
from utils.helper import load_css, render_banner, render_kpi_card, format_currency, create_download_button
from utils.data_loader import load_forecast_data
from utils.charts import plot_forecasting_timeline

st.set_page_config(page_title="Forecasting", page_icon="🤖", layout="wide")
load_css()

render_banner(
    "🤖 Machine Learning Sales Forecasting (Prophet Engine)",
    "12-Month Predictive Future Sales Demand with 95% Confidence Bounds & Inventory Buffer Guidelines"
)

fc_df, full_df, metrics_df = load_forecast_data()

if not fc_df.empty:
    total_2014 = full_df[full_df['ds'].dt.year == 2014]['actual'].sum() if not full_df.empty else 4299865.91
    total_2015 = fc_df['forecast'].sum()
    yoy_growth = ((total_2015 - total_2014) / total_2014) * 100
    peak_month = fc_df.loc[fc_df['forecast'].idxmax(), 'ds'].strftime('%B %Y')
    
    # KPI Row
    c1, c2, c3, c4 = st.columns(4)
    with c1:
        render_kpi_card("2014 Baseline Sales", format_currency(total_2014), "Actual Historical", "#003B73")
    with c2:
        render_kpi_card("2015 Projected Sales", format_currency(total_2015), "Prophet Engine", "#27AE60")
    with c3:
        render_kpi_card("Projected YoY Growth", f"+{yoy_growth:.2f}%", "Target: Positive", "#0074B7")
    with c4:
        render_kpi_card("Forecast Peak Month", peak_month, "Q4 Seasonality Spikes", "#F39C12")

    st.markdown("---")

    # Main Forecasting Timeline Plot
    st.plotly_chart(plot_forecasting_timeline(full_df, fc_df), use_container_width=True)

    st.markdown("---")

    # Interactive Forecast Data Table & CSV Export
    col1, col2 = st.columns([2, 1])

    with col1:
        st.markdown("### 📋 12-Month Detailed Monthly Forecast Table (2015)")
        display_fc = fc_df.copy()
        display_fc['Month'] = display_fc['ds'].dt.strftime('%B %Y')
        display_fc['Forecast ($)'] = display_fc['forecast'].map(lambda x: f"${x:,.2f}")
        display_fc['Lower Bound ($)'] = display_fc['forecast_lower'].map(lambda x: f"${x:,.2f}")
        display_fc['Upper Bound ($)'] = display_fc['forecast_upper'].map(lambda x: f"${x:,.2f}")
        
        st.dataframe(
            display_fc[['Month', 'Forecast ($)', 'Lower Bound ($)', 'Upper Bound ($)']],
            use_container_width=True,
            hide_index=True
        )

    with col2:
        st.markdown("### 💡 Operations Guidelines")
        st.markdown(f"""
        <div class="info-box">
            <b>1. Stock Inventory Buffer:</b><br>
            Maintain a <b>{yoy_growth:.1f}%</b> increase in stock inventory compared to 2014 to support demand.<br><br>
            <b>2. Peak Season Readiness:</b><br>
            Q4 2015 is projected as the highest sales period. Begin warehouse scaling in August/September.<br><br>
            <b>3. Worst-Case Scenarios:</b><br>
            Annual lower bound revenue is <b>${fc_df['forecast_lower'].sum()/1e6:.2f}M</b>.
        </div>
        """, unsafe_allow_html=True)
        
        create_download_button(fc_df, "final_12_month_forecast.csv", "📥 Download 2015 Forecast CSV")

else:
    st.warning("Forecast predictions missing in data/ directory.")
