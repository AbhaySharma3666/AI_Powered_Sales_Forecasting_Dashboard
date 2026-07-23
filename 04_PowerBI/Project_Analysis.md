# 📊 Project Analysis & Dashboard Reports

> A comprehensive synthesis of the `LLM_Project_Context.pdf`, `AI_Powered_Sales_Forecasting_Detailed_Dashboard_Report_2.pdf`, and `AI_Powered_Sales_Forecasting_Short_Report.pdf`.

---

## 🚀 Project Overview & Architecture
This project is an end-to-end Business Intelligence solution analyzing the **Global Superstore** dataset (~51K records). It transforms raw sales data into actionable insights through a robust data architecture:
*   **Data Model**: A Star Schema featuring a central `fact_sales` table connected to `dim_customer`, `dim_product`, `dim_region`, and `dim_date`. 
*   **Design Language**: A professional corporate light theme using a specific palette (Primary: `#003B73`, Secondary: `#0074B7`, Success: `#27AE60`, Alert: `#BF212F`), rounded cards, and subtle shadows for modern UX.
*   **Deliverables**: Encompasses SQL analytics, a 5-page Power BI dashboard, Python forecasting, and a Streamlit deployment.

---

## 📈 Executive Summary & Key Findings
The dashboard provides a high-level view of business health, revealing strong overall performance:
*   **Total Revenue**: ~$12.64M
*   **Total Profit**: ~$1.47M
*   **Profitability**: Healthy overall profit margin of **>11%**.
*   **Trends**: Consistent upward revenue trends, especially toward the end of the fiscal year.

---

## 🔍 In-Depth Domain Analysis

### 1. Product & Sales Analysis
*   **Top Performer**: The **Technology** category generates the highest revenue.
*   **Areas of Concern**: **Furniture** yields the lowest profit margins.
*   **Pricing Impact**: Discounts have a direct and significant influence on profitability. Several bottom-performing products indicate a need for immediate pricing or inventory optimization.

### 2. Customer Insights
*   **Top Segment**: The **Consumer** segment contributes the largest share of revenue.
*   **Loyalty**: A high proportion of repeat buyers points to strong customer loyalty. High-value customers drive a massive portion of the total revenue.
*   **Actionable Metrics**: Churn-risk customers have been successfully identified using purchase history and recency, creating targets for retention campaigns.

### 3. Regional Performance
*   **Top Markets**: **APAC** and **EU** are the strongest global markets for revenue generation.
*   **Top Geographies**: The **United States** is the highest contributing country, with **New York City** leading among individual cities.
*   **Strategic Value**: Visualizing geographic profitability uncovers regional opportunities (for expansion) and risks (markets with negative margins).

### 4. Forecasting & Advanced Analytics
*   **Predictive Trends**: Forecasting indicates continued sales growth, supporting proactive demand planning.
*   **Anomaly Detection**: Successfully identifies unusual sales spikes or drops for immediate investigation.
*   **Root-Cause Analysis**: Key Influencers explain the primary drivers behind profit margin fluctuations, while the Decomposition Tree enables interactive drill-downs from overall revenue to specific sub-categories and regions.

---

## 💡 Strategic Business Recommendations
Based on the synthesized reports, the following actions are recommended for the executive team:
1.  **Double Down on Winners**: Increase inventory investment and marketing for high-performing **Technology** products.
2.  **Optimize the Bottom Line**: Review the pricing and discount strategy for low-margin **Furniture** products to prevent revenue leakage.
3.  **Proactive Retention**: Launch targeted marketing and retention campaigns aimed at identified churn-risk customers.
5.  **Data-Driven Planning**: Utilize the forecasting results for tighter inventory planning, accurate budgeting, and better resource allocation.

---

## 🛠️ PBIX Technical Analysis
An internal structural analysis of the compiled `AI_Powered_Sales_Forecasting.pbix` file reveals the following architectural details regarding the dashboard layout:

*   **Total Dashboard Pages**: 6
    1.  **01 Executive Summary** (20 visuals/elements)
    2.  **02 Product & Sales Analysis** (22 visuals/elements)
    3.  **03 Customer Insights** (21 visuals/elements)
    4.  **04 Regional Performance** (22 visuals/elements)
    5.  **05 Forecasting & Advanced Analytics** (19 visuals/elements)
    6.  **Tooltip_Info** (1 visual - acts as a custom tooltip canvas for other pages)
*   **Design Complexity**: The high visual count per page (~20 visuals) suggests a rich UI that includes structural elements (backgrounds, navigation buttons, custom text, slicer panels) alongside core charts, indicating a highly polished and interactive enterprise-grade reporting environment.
