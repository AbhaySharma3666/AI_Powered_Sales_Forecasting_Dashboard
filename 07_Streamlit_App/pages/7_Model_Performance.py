import streamlit as st
import pandas as pd
import plotly.express as px
from utils.helper import load_css, render_banner, render_kpi_card
from utils.data_loader import load_forecast_data
from utils.charts import plot_model_comparison_bar

st.set_page_config(page_title="Model Performance", page_icon="📊", layout="wide")
load_css()

render_banner(
    "📊 Machine Learning Model Benchmarking & Performance Evaluation",
    "Comparative Evaluation of ARIMA, Facebook Prophet, XGBoost, and Random Forest on 2014 Validation Test Set"
)

fc_df, full_df, metrics_df = load_forecast_data()

if not metrics_df.empty:
    best_model = metrics_df.iloc[0]
    
    # Model Benchmarking KPIs
    c1, c2, c3, c4 = st.columns(4)
    with c1:
        render_kpi_card("Winning Model", best_model['Model'], "Champion Engine", "#003B73")
    with c2:
        render_kpi_card("Best MAPE", f"{best_model['MAPE (%)']:.2f}%", "Target: <15%", "#27AE60")
    with c3:
        render_kpi_card("Best R² Score", f"{best_model['R2']:.4f}", "Target: >0.80", "#0074B7")
    with c4:
        render_kpi_card("Best MAE", f"${best_model['MAE']:,.2f}", "Mean Absolute Error", "#F39C12")

    st.markdown("---")

    # Metrics Bar Chart & Summary Table
    col1, col2 = st.columns([1, 1])

    with col1:
        st.plotly_chart(plot_model_comparison_bar(metrics_df), use_container_width=True)

    with col2:
        st.markdown("### 📋 Full Model Evaluation Matrix (2014 Test Set)")
        st.dataframe(
            metrics_df.style.format({'MAPE (%)': '{:.2f}%', 'MAE': '${:,.2f}', 'RMSE': '${:,.2f}', 'R2': '{:.4f}'}),
            use_container_width=True,
            hide_index=True
        )

    st.markdown("---")

    # Technical Explanation & Model Selection Rationale
    st.markdown("### 🧠 Technical Model Evaluation Insights")
    
    t1, t2 = st.columns(2)
    with t1:
        st.markdown("""
        <div class="info-box">
            <h4>🏆 Why Facebook Prophet Won:</h4>
            <ul>
                <li><b>Multiplicative Seasonality:</b> Accurately modeled retail sales expansion where seasonal amplitude grows proportional to the trend.</li>
                <li><b>Fourier Components:</b> Captures complex annual holiday peaks (Q4 retail surge) natively without manual lag engineering.</li>
                <li><b>Data Efficiency:</b> Highly robust on monthly time-series data with 48 historical observations.</li>
            </ul>
        </div>
        """, unsafe_allow_html=True)

    with t2:
        st.markdown("""
        <div class="warning-box">
            <h4>⚙️ Supervised ML & Statistical Baseline Findings:</h4>
            <ul>
                <li><b>Tree-Based Models (XGBoost / Random Forest):</b> Achieved 17.6%–18.7% MAPE. Require larger daily/weekly transaction grain for optimal splits.</li>
                <li><b>ARIMA (SARIMAX):</b> Served as the classical benchmark (19.39% MAPE), confirming linear trend limitations vs Prophet's flexible changepoints.</li>
            </ul>
        </div>
        """, unsafe_allow_html=True)

else:
    st.warning("Model comparison data missing in data/ directory.")
