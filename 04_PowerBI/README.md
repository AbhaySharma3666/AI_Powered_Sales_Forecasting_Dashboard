# 📊 04_PowerBI — Dashboard Development & DAX Measures

> Comprehensive guide on building the 5-page Executive Power BI Dashboard for the AI-Powered Sales Forecasting project, including step-by-step instructions, data modeling, DAX measures, and page structures.

---

## 📋 Table of Contents

1. [Development Process](#-step-by-step-development-process)
2. [DAX Measures Reference](#-dax-measures-reference)
3. [Dashboard Structure (5 Pages)](#-dashboard-structure-5-pages)
    - [Page 1: Executive Summary](#page-1-executive-summary)
    - [Page 2: Product & Sales Analysis](#page-2-product--sales-analysis)
    - [Page 3: Customer Insights](#page-3-customer-insights)
    - [Page 4: Regional Performance](#page-4-regional-performance)
    - [Page 5: Forecasting & Advanced Analytics](#page-5-forecasting--advanced-analytics)
4. [Design & Theme Guidelines](#-design--theme-guidelines)

---

## 🚀 Step-by-Step Development Process

### Step 1: Data Import & Transformation
- **Get Data**: Import the 5 processed CSV files (`fact_sales`, `dim_customer`, `dim_product`, `dim_region`, `dim_date`) from `02_Dataset/processed_data/`.
- **Power Query**: 
  - Ensure correct data types (e.g., Dates as `Date`, Sales/Profit as `Fixed Decimal Number`).
  - Mark `dim_date` table as the official Date Table in Power BI.

### Step 2: Data Modeling (Star Schema)
- Navigate to the **Model View**.
- Establish One-to-Many (1:*) relationships from dimension tables to the fact table:
  - `dim_customer[customer_key]` ➔ `fact_sales[customer_key]`
  - `dim_product[product_key]` ➔ `fact_sales[product_key]`
  - `dim_region[region_key]` ➔ `fact_sales[region_key]`
  - `dim_date[date_key]` ➔ `fact_sales[date_key]`
- Hide key columns in the Report View to keep the field list clean for end users.

### Step 3: Creating DAX Measures
- Create a dedicated measure table (e.g., `_KeyMeasures`) by entering blank data.
- Organize measures into folders (Core KPIs, Time Intelligence, Segmentation) for easy navigation.
- Implement the DAX code (detailed in the next section).

### Step 4: UI/UX Design & Layout
- Set canvas background (e.g., dark theme or clean corporate light theme).
- Insert a navigation bar on the left or top with buttons linking to the 5 pages using page navigation actions.
- Add consistent headers, filters/slicers panels, and title sections on every page.

### Step 5: Visual Development & Formatting
- Build visuals page by page according to the structure below.
- Apply conditional formatting (e.g., red for negative profit margins).
- Configure tooltips to provide drill-down context (e.g., hovering over a region shows top 3 products).

### Step 6: Publishing & Sharing
- Publish the `.pbix` file to the Power BI Service.
- Set up scheduled refresh if connected to a live database.
- Configure Row-Level Security (RLS) if regional managers only need to see their specific market data.

## 📑 Dashboard Structure (5 Pages)

The dashboard is divided into 5 distinct pages to address the 25 core business questions outlined in the project charter.

### Page 1: Executive Summary
**Objective**: High-level overview for C-level executives to gauge overall business health.

* **Top Bar (Global Filters)**: Year, Quarter, Market dropdowns.
* **KPI Cards (Top Row)**: 
  - Total Revenue (with YoY indicator)
  - Total Profit
  - Profit Margin % (Conditional formatting: Red < 10%, Green >= 10%)
  - Total Orders
* **Visual 1: Revenue & Profit Trend**: Line and Clustered Column Chart (X-axis: Month/Year, Column: Revenue, Line: Profit).
* **Visual 2: Revenue by Market**: Filled Map or Donut Chart showing revenue contribution by the 7 global markets.
* **Visual 3: Top Categories**: Bar chart showing Revenue by Product Category.

### Page 2: Product & Sales Analysis
**Objective**: Deep dive into inventory performance, profitability, and discount impacts.

* **KPI Cards**: Avg Order Value, Total Quantity Sold, Avg Discount %.
* **Visual 1: Profitability Scatter Plot**: Scatter Chart (X: Discount %, Y: Profit Margin %, Details: Sub-Category). Identifies loss-making highly-discounted items.
* **Visual 2: Top 10 Products**: Horizontal Bar Chart ranked by Revenue.
* **Visual 3: Bottom 10 Products by Profit**: Horizontal Bar Chart ranked by Profit (highlighting negative values).
* **Visual 4: Category vs Sub-Category Matrix**: Expandable table showing Revenue, Profit, and Margin % hierarchy.

### Page 3: Customer Insights
**Objective**: Analyze customer behavior, loyalty, and segmentation.

* **KPI Cards**: Total Customers, Revenue per Customer, Repeat Purchase Rate.
* **Visual 1: Customer Segment Breakdown**: Pie Chart (Consumer, Corporate, Home Office) by Revenue share.
* **Visual 2: Top 10 Customers by Lifetime Value (CLV)**: Bar chart or Table displaying top spenders.
* **Visual 3: Order Frequency Distribution**: Histogram or Column chart showing how many customers placed 1, 2-5, 6-10, or 20+ orders.
* **Visual 4: Churn Risk Indicator**: Card or Table highlighting "Single-Order Customers" or customers who haven't purchased in the last 12 months.

### Page 4: Regional Performance
**Objective**: Geographic breakdown to identify strong/weak markets.

* **Filter Panel**: Market, Region, Country hierarchy slicer.
* **Visual 1: Global Profitability Map**: Bubble Map (Location: Country, Bubble Size: Revenue, Bubble Color: Profit Margin gradient from red to green).
* **Visual 2: Region Performance Matrix**: Table showing 13 regions with Sparklines for 12-month revenue trends.
* **Visual 3: Top 10 Cities**: Bar chart showing top cities by Revenue.
* **Visual 4: Loss-Making Geographies**: Table highlighting countries/regions with negative overall profit.

### Page 5: Forecasting & Advanced Analytics
**Objective**: Predictive insights utilizing Power BI's built-in AI capabilities.

* **Visual 1: 12-Month Sales Forecast**: Line Chart with Power BI's native forecasting feature enabled (Forecast length: 12 months, Confidence interval: 95%).
* **Visual 2: Key Influencers for Profitability**: AI Visual analyzing what drives Profit Margin to increase/decrease (e.g., "When Discount is > 20%").
* **Visual 3: Anomaly Detection**: Line chart of daily/weekly sales with anomaly detection enabled to spot unusual spikes or drops.
* **Visual 4: Q&A Visual**: Natural language query box allowing users to ask "What was the profit in US in 2013?".

---

## 🎨 Design & Theme Guidelines

- **Color Palette**: 
  - Primary: Deep Blue `#003B73` (Headers, branding)
  - Secondary: Teal `#0074B7` (Primary data points)
  - Accent/Alert: Crimson Red `#BF212F` (Negative profit, churn)
  - Success: Forest Green `#27AE60` (Positive growth, high margin)
- **Typography**: Segoe UI or DIN (Clean, sans-serif, readable at small sizes).
- **Interactivity**: 
  - Enable cross-filtering across all visuals.
  - Use custom tooltips on maps and trend lines for deeper insights without cluttering the page.
