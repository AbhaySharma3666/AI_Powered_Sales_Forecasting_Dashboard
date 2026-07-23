import plotly.express as px
import plotly.graph_objects as go
import pandas as pd
import numpy as np

COLOR_PRIMARY = "#003B73"
COLOR_SECONDARY = "#0074B7"
COLOR_SUCCESS = "#27AE60"
COLOR_ALERT = "#BF212F"
COLOR_WARNING = "#F39C12"

PALETTE = ["#003B73", "#0074B7", "#0096C7", "#48CAE4", "#90E0EF", "#27AE60", "#F39C12", "#BF212F"]

def plot_monthly_sales_trend(df):
    monthly = df.resample('ME', on='order_date')['sales'].sum().reset_index()
    fig = px.line(
        monthly, x='order_date', y='sales',
        title="Monthly Revenue Trajectory (2011 - 2014)",
        labels={'order_date': 'Date', 'sales': 'Sales ($)'},
        color_discrete_sequence=[COLOR_PRIMARY]
    )
    fig.update_traces(linewidth=2.5)
    fig.update_layout(
        margin=dict(t=40, b=20, l=10, r=10),
        xaxis_title="Date",
        yaxis_title="Monthly Revenue ($)",
        template="plotly_white",
        height=380
    )
    return fig

def plot_sales_by_category(df):
    cat_df = df.groupby('category')['sales'].sum().reset_index().sort_values('sales', ascending=False)
    fig = px.bar(
        cat_df, x='category', y='sales', text_auto='.2s',
        title="Sales Distribution by Category",
        labels={'category': 'Category', 'sales': 'Total Sales ($)'},
        color='category',
        color_discrete_sequence=PALETTE
    )
    fig.update_layout(template="plotly_white", showlegend=False, height=350, margin=dict(t=40, b=20, l=10, r=10))
    return fig

def plot_sales_by_subcategory(df, top_n=10):
    sub_df = df.groupby('sub_category')['sales'].sum().reset_index().sort_values('sales', ascending=True).tail(top_n)
    fig = px.bar(
        sub_df, y='sub_category', x='sales', orientation='h', text_auto='.2s',
        title=f"Top {top_n} Sub-Categories by Revenue",
        labels={'sub_category': 'Sub-Category', 'sales': 'Total Sales ($)'},
        color_discrete_sequence=[COLOR_SECONDARY]
    )
    fig.update_layout(template="plotly_white", height=380, margin=dict(t=40, b=20, l=10, r=10))
    return fig

def plot_discount_vs_profit(df):
    fig = px.scatter(
        df.sample(min(1000, len(df)), random_state=42),
        x='discount', y='profit', color='category', size='sales',
        hover_data=['sub_category', 'country'],
        title="Discount vs. Profitability Impact",
        labels={'discount': 'Discount Rate', 'profit': 'Profit ($)'},
        color_discrete_sequence=PALETTE
    )
    fig.add_hline(y=0, line_dash="dash", line_color=COLOR_ALERT, annotation_text="Break-even Profit Line")
    fig.add_vline(x=0.2, line_dash="dot", line_color=COLOR_WARNING, annotation_text="20% Max Discount Cap Policy")
    fig.update_layout(template="plotly_white", height=400, margin=dict(t=40, b=20, l=10, r=10))
    return fig

def plot_rfm_distribution(rfm_df):
    if 'rfm_segment' not in rfm_df.columns:
        return go.Figure()
    seg_counts = rfm_df['rfm_segment'].value_counts().reset_index()
    seg_counts.columns = ['Segment', 'Customer Count']
    fig = px.pie(
        seg_counts, names='Segment', values='Customer Count',
        title="RFM Customer Segment Breakdown",
        color_discrete_sequence=PALETTE,
        hole=0.4
    )
    fig.update_traces(textposition='inside', textinfo='percent+label')
    fig.update_layout(template="plotly_white", height=380, margin=dict(t=40, b=20, l=10, r=10))
    return fig

def plot_customer_cluster_scatter(seg_df):
    # Use Recency vs Monetary for 2D cluster view (PCA not exported to CSV)
    x_col = 'recency' if 'recency' in seg_df.columns else None
    y_col = 'monetary' if 'monetary' in seg_df.columns else None
    color_col = 'cluster_name' if 'cluster_name' in seg_df.columns else ('cluster' if 'cluster' in seg_df.columns else None)
    
    if x_col and y_col and color_col:
        plot_df = seg_df.copy()
        plot_df[color_col] = plot_df[color_col].astype(str)
        hover_cols = [c for c in ['frequency', 'rfm_score', 'customer_name'] if c in plot_df.columns]
        fig = px.scatter(
            plot_df, x=x_col, y=y_col, color=color_col,
            title="K-Means Customer Segmentation (Recency vs Monetary)",
            labels={'recency': 'Recency (Days)', 'monetary': 'Monetary ($)'},
            hover_data=hover_cols,
            color_discrete_sequence=PALETTE
        )
        fig.update_layout(template="plotly_white", height=420, margin=dict(t=40, b=20, l=10, r=10))
        return fig
    return go.Figure()

def plot_regional_choropleth(df):
    country_df = df.groupby('country').agg({'sales': 'sum', 'profit': 'sum'}).reset_index()
    fig = px.choropleth(
        country_df, locations='country', locationmode='country names',
        color='sales', hover_name='country',
        hover_data={'sales': ':$,.2f', 'profit': ':$,.2f'},
        title="Global Sales Geographic Density Map",
        color_continuous_scale="Viridis"
    )
    fig.update_layout(template="plotly_white", height=450, margin=dict(t=40, b=20, l=10, r=10))
    return fig

def plot_forecasting_timeline(full_df, forecast_df):
    fig = go.Figure()
    
    # Historical actuals
    if 'actual' in full_df.columns:
        actuals = full_df.dropna(subset=['actual'])
        fig.add_trace(go.Scatter(
            x=actuals['ds'], y=actuals['actual'],
            name='Historical Sales (2011-2014)',
            line=dict(color='black', width=2),
            marker=dict(size=5)
        ))
        
    # 2015 Forecast
    if not forecast_df.empty:
        fig.add_trace(go.Scatter(
            x=forecast_df['ds'], y=forecast_df['forecast'],
            name='Prophet 12-Month Forecast (2015)',
            line=dict(color=COLOR_PRIMARY, width=2.5, dash='dash'),
            marker=dict(symbol='diamond', size=6)
        ))
        
        # Confidence interval
        if 'forecast_upper' in forecast_df.columns and 'forecast_lower' in forecast_df.columns:
            fig.add_trace(go.Scatter(
                x=forecast_df['ds'].tolist() + forecast_df['ds'].tolist()[::-1],
                y=forecast_df['forecast_upper'].tolist() + forecast_df['forecast_lower'].tolist()[::-1],
                fill='toself',
                fillcolor='rgba(0, 116, 183, 0.15)',
                line=dict(color='rgba(255,255,255,0)'),
                hoverinfo="skip",
                showlegend=True,
                name='95% Confidence Interval'
            ))
            
    fig.update_layout(
        title="12-Month Projected Demand vs. Historical Baseline",
        xaxis_title="Date",
        yaxis_title="Monthly Revenue ($)",
        template="plotly_white",
        height=450,
        margin=dict(t=40, b=20, l=10, r=10),
        legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="left", x=0.01)
    )
    return fig

def plot_model_comparison_bar(metrics_df):
    fig = px.bar(
        metrics_df, x='Model', y='MAPE (%)',
        title="Model Accuracy Comparison (MAPE % — Lower is Better)",
        color='Model', text_auto='.2f',
        color_discrete_map={'Prophet': COLOR_PRIMARY, 'Random Forest': COLOR_SUCCESS, 'XGBoost': COLOR_SECONDARY, 'ARIMA': COLOR_ALERT}
    )
    fig.add_hline(y=15, line_dash="dash", line_color=COLOR_ALERT, annotation_text="Project Target: MAPE < 15%")
    fig.update_layout(template="plotly_white", height=380, showlegend=False, margin=dict(t=40, b=20, l=10, r=10))
    return fig
