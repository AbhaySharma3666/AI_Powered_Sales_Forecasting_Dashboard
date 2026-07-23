# 🔬 05_Advanced_Analytics — Python Advanced Analytics

> **Phase 6 of the AI-Powered Sales Forecasting Dashboard** — Moving from Descriptive Analytics *(What happened?)* to Advanced Analytics *(Why? Who? What patterns? What actions?)*.

**Status**: ✅ **COMPLETED**

---

## 📋 Project Flow Context

```
Business Understanding → Star Schema (SQL) → SQL Analytics → Power BI Dashboard
    ↓
  ★ Advanced Analytics (Python) ← COMPLETED
    ↓
  Machine Learning Forecasting → Streamlit Deployment
```

---

## 📁 Folder Structure

```
05_Advanced_Analytics/
│
├── notebooks/
│   ├── 01_EDA.ipynb                       (12.3 KB)
│   ├── 02_RFM_Analysis.ipynb              (9.6 KB)
│   ├── 03_Customer_Segmentation.ipynb     (10.8 KB)
│   ├── 04_Correlation_Analysis.ipynb      (9.4 KB)
│   └── 05_Market_Basket_Analysis.ipynb    (11.5 KB)
│
├── outputs/
│   ├── rfm_scores.csv                     (131 KB — 1,589 customers)
│   ├── customer_segments.csv              (160 KB — 1,589 customers)
│   └── association_rules.csv              (291 B  — 2 rules)
│
├── visualizations/                        (17 charts — see catalog below)
│
└── README.md
```

---

## 📓 Notebook Details & Results

### Notebook 1: `01_EDA.ipynb` — Exploratory Data Analysis

| Aspect | Detail |
|---|---|
| **Goal** | Understand data shape, distributions, missing values, outliers, trends |
| **Dataset** | `sales_clean.csv` — 51,290 rows × 34 columns |
| **Techniques** | Histograms, Box Plots, Bar Charts, Time Series Line Charts |

**Key Findings:**
- Revenue shows a **consistent upward trend** year over year (2011–2014)
- **Technology** leads revenue; **Furniture** has the lowest profit margins
- **APAC** and **EU** are the strongest performing markets
- Sales spike in **Q4** (Sep–Dec) — strong seasonality detected
- Profit distribution is **right-skewed** with many loss-making transactions
- Discounts above 20% correlate with **negative profits**

**Visualizations Generated:**
- `univariate_distributions.png` — Sales, Profit, Quantity, Discount histograms
- `outlier_boxplots.png` — Box plots for outlier detection
- `category_analysis.png` — Revenue by Category, Sub-Category, Market, Region
- `time_series_trends.png` — Monthly Revenue & Profit trends
- `missing_values.png` — Missing value heatmap

---

### Notebook 2: `02_RFM_Analysis.ipynb` — RFM Customer Scoring

| Aspect | Detail |
|---|---|
| **Goal** | Score every customer on Recency, Frequency, and Monetary value (1–5 scale) |
| **Customers Scored** | **1,589** unique customers |
| **Output** | `outputs/rfm_scores.csv` |

**RFM Segment Distribution (Actual Results):**

| Segment | Customers | % of Total | Description |
|---|---|---|---|
| **Lost Customers** | 384 | 24.2% | Low R, F, M — haven't bought in a long time |
| **Loyal Customers** | 364 | 22.9% | High R, F, M — consistent repeat buyers |
| **Champions** | 351 | 22.1% | Best customers — recent, frequent, high spend |
| **At Risk** | 193 | 12.1% | Used to buy frequently but gone silent |
| **New Customers** | 114 | 7.2% | Recent first-time buyers |
| **Potential Loyalists** | 80 | 5.0% | Showing early signs of loyalty |
| **Others** | 58 | 3.7% | Mixed signals |
| **Hibernating** | 40 | 2.5% | Occasional past buyers, now inactive |
| **Need Attention** | 5 | 0.3% | Borderline customers needing engagement |

**Visualizations Generated:**
- `rfm_distribution.png` — Recency, Frequency, Monetary histograms
- `rfm_segments.png` — Customer count per RFM segment

---

### Notebook 3: `03_Customer_Segmentation.ipynb` — K-Means Clustering

| Aspect | Detail |
|---|---|
| **Goal** | Use unsupervised ML to auto-group customers by purchasing behavior |
| **Pipeline** | StandardScaler → Elbow Method → KMeans (K=4) → PCA 2D Visualization |
| **Output** | `outputs/customer_segments.csv` |

**K-Means Cluster Results (Actual):**

| Cluster | Label | Customers | % | Profile |
|---|---|---|---|---|
| 0 | **Low-Value Occasional** | 651 | 41.0% | Low frequency & monetary, varied recency |
| 1 | **Mid-Value Active** | 497 | 31.3% | Moderate frequency & spend, active buyers |
| 2 | **High-Value Customers** | 284 | 17.9% | High frequency, high monetary, low recency |
| 3 | **Inactive/Churned** | 157 | 9.9% | Very high recency, low frequency |

**Visualizations Generated:**
- `elbow_silhouette.png` — Optimal K selection (Elbow + Silhouette Score)
- `customer_clusters.png` — PCA 2D scatter plot with cluster colors & centroids
- `cluster_profiles.png` — Per-cluster bar charts of Avg Recency, Frequency, Monetary

---

### Notebook 4: `04_Correlation_Analysis.ipynb` — Statistical Relationship Analysis

| Aspect | Detail |
|---|---|
| **Goal** | Quantify statistical relationships between sales, profit, discount, quantity, shipping |
| **Technique** | Pearson Correlation, Scatter Plots with Trend Lines, Discount Band Analysis |

**Key Findings:**
- **Sales & Profit** have a strong positive correlation — higher revenue generally means higher profit
- **Discount & Profit** are negatively correlated — discounts above 20% destroy profitability
- **31%+ discounts** result in ~90%+ loss-making transactions — **immediate pricing policy review needed**
- **Shipping cost** positively correlates with sales — high-value orders naturally cost more to ship
- **Furniture** category is the most sensitive to discount-driven margin erosion

**Visualizations Generated:**
- `correlation_matrix.png` — Heatmap of all variable correlations
- `scatter_analysis.png` — Sales vs Profit, Discount vs Profit, Quantity vs Profit, Shipping vs Sales
- `discount_impact.png` — Avg Sales/Profit/Loss% by discount band
- `category_correlation.png` — Discount vs Profit per category

---

### Notebook 5: `05_Market_Basket_Analysis.ipynb` — Association Rule Mining

| Aspect | Detail |
|---|---|
| **Goal** | Discover products frequently bought together (Amazon/Walmart technique) |
| **Algorithm** | Apriori (mlxtend) with `min_support=0.02` |
| **Rules Found** | **2 association rules** |

**Association Rules (Actual Results):**

| Antecedent | Consequent | Support | Confidence | Lift |
|---|---|---|---|---|
| Art | Storage | 5.83% | 26.8% | 1.01 |
| Storage | Art | 5.83% | 22.0% | 1.01 |

> **Note:** The low rule count and near-1.0 lift values indicate that Global Superstore's sub-category combinations don't exhibit strong co-purchase patterns at the sub-category level. This is expected for a B2B/B2C hybrid retailer where orders are often single-category. A product-name-level or per-market analysis may yield stronger associations.

**Visualizations Generated:**
- `item_frequency.png` — Sub-category frequency in multi-item orders
- `basket_analysis.png` — Support vs Confidence scatter (colored by Lift)
- `top_association_rules.png` — Top rules ranked by Lift

---

## 📊 Complete Visualization Catalog (17 Charts)

| # | File | Notebook | Description |
|---|---|---|---|
| 1 | `missing_values.png` | 01_EDA | Missing value heatmap |
| 2 | `univariate_distributions.png` | 01_EDA | Sales/Profit/Qty/Discount distributions |
| 3 | `outlier_boxplots.png` | 01_EDA | Box plots for outlier detection |
| 4 | `category_analysis.png` | 01_EDA | Revenue by Category/SubCat/Market/Region |
| 5 | `time_series_trends.png` | 01_EDA | Monthly Revenue & Profit trends |
| 6 | `rfm_distribution.png` | 02_RFM | Recency/Frequency/Monetary histograms |
| 7 | `rfm_segments.png` | 02_RFM | Customer count per RFM segment |
| 8 | `elbow_silhouette.png` | 03_Segmentation | Optimal K selection charts |
| 9 | `customer_clusters.png` | 03_Segmentation | PCA 2D cluster visualization |
| 10 | `cluster_profiles.png` | 03_Segmentation | Per-cluster metric comparison |
| 11 | `correlation_matrix.png` | 04_Correlation | Variable correlation heatmap |
| 12 | `scatter_analysis.png` | 04_Correlation | Key variable scatter plots |
| 13 | `discount_impact.png` | 04_Correlation | Discount band profitability analysis |
| 14 | `category_correlation.png` | 04_Correlation | Per-category discount vs profit |
| 15 | `item_frequency.png` | 05_Basket | Sub-category frequency chart |
| 16 | `basket_analysis.png` | 05_Basket | Association rules scatter |
| 17 | `top_association_rules.png` | 05_Basket | Top rules by Lift |

---

## 📦 Output Files

| File | Records | Size | Description |
|---|---|---|---|
| `rfm_scores.csv` | 1,589 customers | 131 KB | RFM scores (R/F/M 1–5) + segment labels |
| `customer_segments.csv` | 1,589 customers | 160 KB | RFM + K-Means cluster labels combined |
| `association_rules.csv` | 2 rules | 291 B | Product association rules with metrics |

---

## 🔗 Notebook Dependencies

```
01_EDA.ipynb ──────────────────────────────────── (standalone — reads sales_clean.csv)
02_RFM_Analysis.ipynb ──── outputs/rfm_scores.csv
                                    ↓
03_Customer_Segmentation.ipynb ──── outputs/customer_segments.csv
04_Correlation_Analysis.ipynb ─────────────────── (standalone — reads sales_clean.csv)
05_Market_Basket_Analysis.ipynb ── outputs/association_rules.csv (standalone)
```

> **Run Order**: Execute sequentially (1 → 2 → 3 → 4 → 5) since Notebook 3 depends on Notebook 2's output.

---

## 🚀 How to Reproduce

```bash
# Install dependencies
pip install pandas numpy matplotlib seaborn plotly scikit-learn mlxtend scipy

# Run all notebooks in order
cd 05_Advanced_Analytics/notebooks
jupyter notebook 01_EDA.ipynb
```

---

## 💡 Executive Summary of Insights

| Domain | Key Finding | Business Action |
|---|---|---|
| **Sales Trends** | Revenue grows YoY with Q4 seasonality | Plan inventory buildup for Q3–Q4 |
| **Customer Value** | 22% are Champions, 24% are Lost | Invest in retention for Champions; win-back campaigns for Lost |
| **Segmentation** | 4 distinct ML clusters identified | Tailor marketing per cluster (High-Value vs Inactive) |
| **Discounts** | 31%+ discounts → 90%+ loss transactions | Cap discounts at 20%; category-specific discount policies |
| **Cross-Selling** | Art ↔ Storage co-purchase pattern | Bundle offers; limited cross-sell at sub-category level |

---

## ➡️ Next Phase

**`06_Machine_Learning/`** — Sales Forecasting with Prophet & XGBoost
