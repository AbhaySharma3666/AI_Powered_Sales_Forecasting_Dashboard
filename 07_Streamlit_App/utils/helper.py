import streamlit as st
import pandas as pd
import os

def load_css():
    css_path = os.path.join(os.path.dirname(__file__), '..', 'assets', 'styles.css')
    if os.path.exists(css_path):
        with open(css_path, 'r', encoding='utf-8') as f:
            st.markdown(f'<style>{f.read()}</style>', unsafe_allow_html=True)

def render_banner(title, subtitle):
    st.markdown(f"""
    <div class="banner-container">
        <h1 class="banner-title">{title}</h1>
        <p class="banner-subtitle">{subtitle}</p>
    </div>
    """, unsafe_allow_html=True)

def render_kpi_card(label, value, subtext="", border_color="#003B73", value_color=None, subtext_color=None):
    is_loss = "-" in str(value) or "Loss" in str(value) or "Loss" in str(subtext) or border_color == "#BF212F"
    
    if value_color is None:
        value_color = "#BF212F" if is_loss else "#1E293B"
        
    if subtext_color is None:
        subtext_color = "#BF212F" if is_loss else "#27AE60"
        
    st.markdown(f"""
    <div class="kpi-card" style="border-left-color: {border_color};">
        <div class="kpi-label">{label}</div>
        <div class="kpi-value" style="color: {value_color};">{value}</div>
        {"<div class='kpi-subtext' style='color: " + subtext_color + ";'>" + subtext + "</div>" if subtext else ""}
    </div>
    """, unsafe_allow_html=True)

def format_currency(val):
    if abs(val) >= 1e6:
        return f"${val/1e6:,.2f}M"
    elif abs(val) >= 1e3:
        return f"${val/1e3:,.1f}K"
    else:
        return f"${val:,.2f}"

def format_number(val):
    return f"{val:,.0f}"

def create_download_button(df, filename="data_export.csv", label="📥 Download CSV"):
    csv = df.to_csv(index=False).encode('utf-8')
    st.download_button(
        label=label,
        data=csv,
        file_name=filename,
        mime='text/csv',
        use_container_width=True
    )
