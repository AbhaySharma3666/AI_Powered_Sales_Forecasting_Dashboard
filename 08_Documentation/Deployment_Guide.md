# 🚀 Deployment Guide — AI-Powered Sales Forecasting Dashboard

> Step-by-step instructions to deploy the Streamlit app live on Streamlit Community Cloud (free).

---

## ✅ Pre-Deployment Checklist

Before deploying, verify these items are in place:

| # | Item | Status |
|:---:|:---|:---:|
| 1 | `07_Streamlit_App/data/` contains all 7 CSV files | ✅ |
| 2 | `07_Streamlit_App/utils/__init__.py` exists | ✅ |
| 3 | `07_Streamlit_App/.streamlit/config.toml` exists | ✅ |
| 4 | `07_Streamlit_App/requirements.txt` lists all dependencies | ✅ |
| 5 | `.gitignore` whitelists `07_Streamlit_App/data/*.csv` | ✅ |
| 6 | All 7 page files compile without errors | ✅ |
| 7 | No `../` parent directory paths in any app code | ✅ |

---

## Step 1: Push to GitHub

```bash
# Navigate to project root
cd "AI-Powered Sales Forecasting Dashboard"

# Stage all files (the updated .gitignore whitelists needed CSVs)
git add .

# Commit
git commit -m "Production-ready Streamlit Analytics Portal - Phase 7 Complete"

# Push to your GitHub repo
git push origin main
```

### ⚠️ Important: Verify CSVs are Tracked
After pushing, open your GitHub repo in a browser and verify that:
- `07_Streamlit_App/data/sales_clean.csv` is visible
- `07_Streamlit_App/data/model_comparison.csv` is visible
- `07_Streamlit_App/data/rfm_scores.csv` is visible

If they are **not** visible, run:
```bash
git add -f 07_Streamlit_App/data/*.csv
git commit -m "Force add Streamlit data files"
git push origin main
```

---

## Step 2: Deploy on Streamlit Community Cloud

### 2a. Sign In
1. Go to **[share.streamlit.io](https://share.streamlit.io)**
2. Click **"Sign in with GitHub"**
3. Authorize Streamlit to access your repositories

### 2b. Create New App
1. Click **"New app"** (top-right corner)
2. Fill in the deployment form:

| Field | Value |
|:---|:---|
| **Repository** | `AbhaySharma3666/AI_Powered_Sales_Forecasting_Dashboard` |
| **Branch** | `main` |
| **Main file path** | `07_Streamlit_App/app.py` |

3. Click **"Deploy!"**

### 2c. Wait for Build
Streamlit Cloud will:
1. Clone your repository
2. Install packages from `07_Streamlit_App/requirements.txt`
3. Start the Streamlit server
4. Assign a public URL like: `https://your-app-name.streamlit.app`

Build usually takes **3-5 minutes** on first deploy.

---

## Step 3: Configure Advanced Settings (Optional)

### Python Version
If build fails, click **"Advanced settings"** during deployment and set:
```
Python version: 3.11
```
(Prophet works best on 3.10-3.11)

### Secrets
If you need environment variables, add them in **"Advanced settings" → Secrets**:
```toml
[database]
host = "your-db-host"
password = "your-password"
```

---

## Step 4: Share Your Live App

After successful deployment, you'll get a URL like:
```
https://ai-powered-sales-forecasting.streamlit.app
```

Add this to your GitHub README:
```markdown
## 🌐 Live Demo
[![Streamlit App](https://static.streamlit.io/badges/streamlit_badge_black_white.svg)](https://your-app-url.streamlit.app)
```

---

## 🔄 Updating the Deployed App

Any `git push` to the `main` branch will **automatically redeploy** the app:

```bash
# Make changes locally
git add .
git commit -m "Update dashboard charts"
git push origin main
# App redeploys automatically within ~2 minutes
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|:---|:---|
| **ModuleNotFoundError** | Add the missing package to `07_Streamlit_App/requirements.txt` |
| **FileNotFoundError for CSVs** | Ensure `.gitignore` whitelists `07_Streamlit_App/data/*.csv` and CSVs are committed |
| **Prophet install fails** | Set Python version to 3.11 in Advanced Settings |
| **App crashes on load** | Check the Streamlit Cloud logs (click "Manage app" → "Logs") |
| **Memory limit exceeded** | Reduce `sales_clean.csv` size or add `@st.cache_data` decorators |
