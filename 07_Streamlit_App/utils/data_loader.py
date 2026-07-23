import streamlit as st
import pandas as pd
import os

DATA_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'data')

@st.cache_data
def load_sales_data():
    file_path = os.path.join(DATA_DIR, 'sales_clean.csv')
    df = pd.read_csv(file_path, parse_dates=['order_date', 'ship_date'])
    return df

@st.cache_data
def load_customer_data():
    segments_path = os.path.join(DATA_DIR, 'customer_segments.csv')
    rfm_path = os.path.join(DATA_DIR, 'rfm_scores.csv')
    
    # --- Customer Segments (with clusters) ---
    seg_df = pd.read_csv(segments_path) if os.path.exists(segments_path) else pd.DataFrame()
    if not seg_df.empty:
        # Original columns: customer_id, customer_name, segment (business), country,
        # Recency, Frequency, Monetary, R_Score, F_Score, M_Score, RFM_Score,
        # Segment (RFM label), Cluster, Cluster_Label
        # Rename to avoid collision and normalize
        rename_map = {}
        cols = list(seg_df.columns)
        # Find the second 'Segment' (RFM label) — it's at a higher index than the first 'segment'
        seg_indices = [i for i, c in enumerate(cols) if c.lower() == 'segment']
        if len(seg_indices) >= 2:
            cols[seg_indices[0]] = 'business_segment'
            cols[seg_indices[1]] = 'rfm_segment'
            seg_df.columns = cols
        elif len(seg_indices) == 1 and 'Cluster_Label' in cols:
            cols[seg_indices[0]] = 'business_segment'
            seg_df.columns = cols
        
        seg_df.columns = [c.lower() for c in seg_df.columns]
        if 'cluster_label' in seg_df.columns:
            seg_df.rename(columns={'cluster_label': 'cluster_name'}, inplace=True)
    
    # --- RFM Scores ---
    rfm_df = pd.read_csv(rfm_path) if os.path.exists(rfm_path) else pd.DataFrame()
    if not rfm_df.empty:
        # Original columns: customer_id, customer_name, segment (business), country,
        # Recency, Frequency, Monetary, ..., Segment (RFM label)
        cols = list(rfm_df.columns)
        seg_indices = [i for i, c in enumerate(cols) if c.lower() == 'segment']
        if len(seg_indices) >= 2:
            cols[seg_indices[0]] = 'business_segment'
            cols[seg_indices[1]] = 'rfm_segment'
            rfm_df.columns = cols
        elif len(seg_indices) == 1:
            # Single 'Segment' col — check if it contains RFM labels
            sample_val = str(rfm_df.iloc[0][cols[seg_indices[0]]])
            if sample_val in ['Champions', 'Loyal Customers', 'At Risk', 'Lost Customers',
                              'Potential Loyalists', 'Others', 'New Customers', 'Need Attention']:
                cols[seg_indices[0]] = 'rfm_segment'
                rfm_df.columns = cols
        
        rfm_df.columns = [c.lower() for c in rfm_df.columns]
    
    return seg_df, rfm_df

@st.cache_data
def load_forecast_data():
    forecast_path = os.path.join(DATA_DIR, 'final_12_month_forecast.csv')
    full_path = os.path.join(DATA_DIR, 'full_forecast_with_actuals.csv')
    metrics_path = os.path.join(DATA_DIR, 'model_comparison.csv')
    
    fc_df = pd.read_csv(forecast_path) if os.path.exists(forecast_path) else pd.DataFrame()
    if not fc_df.empty and 'ds' in fc_df.columns:
        fc_df['ds'] = pd.to_datetime(fc_df['ds'])
        
    full_df = pd.read_csv(full_path) if os.path.exists(full_path) else pd.DataFrame()
    if not full_df.empty and 'ds' in full_df.columns:
        full_df['ds'] = pd.to_datetime(full_df['ds'])
        
    metrics_df = pd.read_csv(metrics_path) if os.path.exists(metrics_path) else pd.DataFrame()
    
    return fc_df, full_df, metrics_df

@st.cache_data
def load_association_rules():
    rules_path = os.path.join(DATA_DIR, 'association_rules.csv')
    if os.path.exists(rules_path):
        return pd.read_csv(rules_path)
    return pd.DataFrame()
