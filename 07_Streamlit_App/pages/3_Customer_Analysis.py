import streamlit as st
import pandas as pd
import plotly.express as px
from utils.helper import load_css, render_banner, render_kpi_card, format_currency, format_number, create_download_button
from utils.data_loader import load_customer_data
from utils.charts import plot_rfm_distribution, plot_customer_cluster_scatter

st.set_page_config(page_title="Customer Analysis", page_icon="👥", layout="wide")
load_css()

render_banner(
    "👥 Customer Analytics & RFM Segmentation",
    "Recency, Frequency, Monetary (RFM) Segmentation and K-Means Machine Learning Clustering Insights"
)

seg_df, rfm_df = load_customer_data()

if not rfm_df.empty:
    # Key Customer Cohort Stats
    total_customers = len(rfm_df)
    champions = len(rfm_df[rfm_df['rfm_segment'] == 'Champions']) if 'rfm_segment' in rfm_df.columns else 0
    loyal = len(rfm_df[rfm_df['rfm_segment'] == 'Loyal Customers']) if 'rfm_segment' in rfm_df.columns else 0
    at_risk = len(rfm_df[rfm_df['rfm_segment'] == 'At Risk']) if 'rfm_segment' in rfm_df.columns else 0
    lost = len(rfm_df[rfm_df['rfm_segment'] == 'Lost Customers']) if 'rfm_segment' in rfm_df.columns else 0

    c1, c2, c3, c4, c5 = st.columns(5)
    with c1:
        render_kpi_card("Total Customers", format_number(total_customers), "Analyzed Buyers", "#003B73")
    with c2:
        render_kpi_card("Champions", format_number(champions), f"{(champions/total_customers*100):.1f}% of base", "#27AE60")
    with c3:
        render_kpi_card("Loyal Customers", format_number(loyal), f"{(loyal/total_customers*100):.1f}% of base", "#0074B7")
    with c4:
        render_kpi_card("At-Risk", format_number(at_risk), f"{(at_risk/total_customers*100):.1f}% of base", "#F39C12")
    with c5:
        render_kpi_card("Lost Customers", format_number(lost), f"{(lost/total_customers*100):.1f}% of base", "#BF212F")

    st.markdown("---")

    # Visualizations
    col1, col2 = st.columns(2)

    with col1:
        st.plotly_chart(plot_rfm_distribution(rfm_df), use_container_width=True, key="rfm_pie")

    with col2:
        if not seg_df.empty:
            st.plotly_chart(plot_customer_cluster_scatter(seg_df), use_container_width=True, key="cluster_scatter")
        else:
            st.info("K-Means Cluster visualization data available.")

    st.markdown("---")

    # Filterable Customer Directory Table
    st.markdown("### 🔍 Customer Segmentation Directory")
    
    selected_segment = st.selectbox("Filter Directory by RFM Segment", ["All Segments"] + sorted(rfm_df['rfm_segment'].unique().tolist()))
    
    display_df = rfm_df.copy()
    if selected_segment != "All Segments":
        display_df = display_df[display_df['rfm_segment'] == selected_segment]
        
    # Select display columns that actually exist
    desired_cols = ['customer_id', 'customer_name', 'recency', 'frequency', 'monetary', 'rfm_score', 'rfm_segment']
    display_cols = [c for c in desired_cols if c in display_df.columns]
    
    st.dataframe(
        display_df[display_cols],
        use_container_width=True,
        hide_index=True
    )
    
    create_download_button(display_df, "customer_rfm_segments.csv", "📥 Download Filtered Customer Dataset")

else:
    st.warning("Customer RFM segmentation data not found in data/ directory.")
