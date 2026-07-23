# 🔮 06_Machine_Learning — ML Sales Forecasting

> **Phase 7 of the AI-Powered Sales Forecasting Dashboard** — Predictive Analytics: *What will happen next?*

**Status**: ✅ **COMPLETED**

---

## 📋 Workflow

```
sales_clean.csv
       |
01 Time-Series Preparation
       |
Train (2011-2013) / Test (2014) Split
       |
+--------+---------+---------+--------------+
| ARIMA  | Prophet | XGBoost | Random Forest|
+--------+---------+---------+--------------+
       |
MAE + RMSE + MAPE + R2
       |
06 Model Comparison
       |
Select Best Model (Prophet)
       |
07 Retrain on Full Historical Data
       |
final_12_month_forecast.csv
       |
Phase 7: Streamlit App
```

---

## 📁 Folder Structure

```
06_Machine_Learning/
|
+-- notebooks/
|   +-- 01_Time_Series_Preparation.ipynb   <- Aggregate, decompose, feature engineer, split
|   +-- 02_ARIMA_Model.ipynb               <- SARIMAX(1,1,1)(1,1,1,12)
|   +-- 03_Prophet_Model.ipynb             <- Facebook Prophet (multiplicative)
|   +-- 04_XGBoost_Model.ipynb             <- Gradient Boosted Trees
|   +-- 05_Random_Forest_Model.ipynb       <- Ensemble Bagging
|   +-- 06_Model_Comparison.ipynb          <- Unified metrics + overlay chart
|   +-- 07_Final_Forecast.ipynb            <- Retrain best model, 12-month forecast
|
+-- models/
|   +-- arima_model.pkl
|   +-- prophet_model.pkl
|   +-- prophet_model_final.pkl            <- Retrained on full data (2011-2014)
|   +-- xgboost_model.pkl
|   +-- random_forest_model.pkl
|
+-- predictions/
|   +-- arima_predictions.csv
|   +-- prophet_predictions.csv
|   +-- xgboost_predictions.csv
|   +-- random_forest_predictions.csv
|   +-- final_12_month_forecast.csv        <- Official 2015 forecast
|   +-- full_forecast_with_actuals.csv     <- Combined for Streamlit
|
+-- evaluation/
|   +-- model_comparison.csv               <- Side-by-side metrics table
|
+-- visualizations/
|   +-- sales_time_series.png
|   +-- model_comparison.png
|   +-- all_models_overlay.png
|   +-- final_forecast.png
|
+-- data/                                  <- Intermediate prepared data
|   +-- monthly_sales.csv
|   +-- train_ts.csv, test_ts.csv
|   +-- ml_features.csv
|   +-- train_ml.csv, test_ml.csv
|
+-- README.md
```

---

## 📈 Model Performance (Test Set: Jan-Dec 2014)

| Model | MAPE (%) | MAE ($) | RMSE ($) | R2 Score | vs Target (<15%) |
|:---|:---:|:---:|:---:|:---:|:---:|
| **Prophet** | **8.62%** | **$33,960** | **$48,177** | **0.84** | **ACHIEVED** |
| Random Forest | 17.64% | $71,106 | $87,750 | 0.46 | Not Met |
| XGBoost | 18.79% | $75,468 | $96,598 | 0.35 | Not Met |
| ARIMA (SARIMAX) | 19.39% | $75,419 | $89,384 | 0.44 | Not Met |

### Why Prophet Won
1. **Multiplicative seasonality** naturally fits retail sales where seasonal amplitude scales with trend level.
2. **Fourier-based yearly seasonality** captures complex monthly patterns without manual feature engineering.
3. Tree-based models (XGBoost, RF) are data-hungry and struggled with only 48 monthly observations.

---

## 🔮 Final 12-Month Forecast (2015)

| Metric | Value |
|:---|:---|
| **Best Model** | Facebook Prophet (Multiplicative) |
| **Validation MAPE** | 8.62% |
| **Validation R2** | 0.84 |
| **2014 Actual Sales** | $4,299,865.91 |
| **2015 Forecast Sales** | $5,135,726.27 |
| **Projected YoY Growth** | +19.44% |
| **Expected Peak** | Q4 2015 (Nov-Dec) |

---

## 🔗 Notebook Dependencies

```
01_Time_Series_Preparation  -->  data/*.csv (shared prep)
        |
   +----+----+----+----+
   v    v    v    v
  02   03   04   05      (independent model notebooks)
   |    |    |    |
   v    v    v    v
   predictions/*.csv
        |
        v
06_Model_Comparison  -->  evaluation/model_comparison.csv
        |
        v
07_Final_Forecast    -->  predictions/final_12_month_forecast.csv
```

> **Run Order**: 01 first, then 02-05 in any order, then 06, then 07.

---

## 🚀 How to Reproduce

```bash
pip install pandas numpy matplotlib seaborn scikit-learn xgboost prophet statsmodels joblib

cd 06_Machine_Learning/notebooks
jupyter notebook 01_Time_Series_Preparation.ipynb
```

---

## ➡️ Next Phase

**`07_Streamlit_App/`** — Integrate insights, segmentation, and forecasting into an interactive web application.
