# 360° Children at Risk — Predicting Improvement

### 🎯 Goal
Develop a **supervised machine learning model** that predicts improvement among children participating in Israel’s **360° National Program for Children and Youth at Risk**, supporting **early identification of children unlikely to improve** (Recall₀ priority for preventive intervention).

---

### 🧾 Data
Administrative monitoring data (Sep 2023 – Sep 2024):

- **107,300 forms → 66,955 children**
- After pairing valid M1–M2 (60–465 days) and resolving duplicates by completeness:  
  → **21,981 children**, ~400 features  
- Integrated program registry: **95 programs, 11 variables, 81 matched (84% coverage)**

---

### ⚙️ Process (Notebooks)
Data Preparation → EDA → Data Cleansing (structural skips & imputation) → Feature Engineering (risk, strengths, geo, program) → Feature Selection & Encoding → Model Selection & Tuning → SHAP Interpretation  

📂 See full workflow in the `notebooks/` folder (steps 0–6)

---

### 🧩 Key Methods
- **Cleansing:** structural-skip logic, skew-aware imputation, removal of empty variables  
- **Features:** seven risk domains, red-flag counts, personal and interpersonal strengths, geo risk rates, program attributes  
- **Selection & Encoding:** leakage-free matrix (M1 + time-invariant only); Top-K OHE and frequency encoding; multimodel votes → **X = 40 numeric features**  
- **Models tested:** Logistic Regression, Decision Tree, Random Forest, Gradient Boosting, XGBoost, **CatBoost** (baseline + Random/Grid/Bayesian tuning)  
- **Metric focus:** **Recall₀** (non-improvers), balanced with F1 / ROC-AUC / PR-AUC

---

### 📊 Results
- **Final model:** CatBoost (Grid-tuned)  
- **Test performance:** ROC-AUC = **0.785**, PR-AUC = **0.635**  
- **Calibrated threshold p = 0.45:** Recall₀ = **0.85**, Recall₁ = **0.51**, Accuracy ≈ **0.73**  
- **Top predictors (SHAP):** initial complexity (`complexity_m1`), learning/participation difficulties, parental addictions (−), parental education (+), population group (Arab) (+)  
- 📈 Leaderboard comparing baseline and tuned models → `reports/figures/leaderboard.png`

---

### 🧠 Interpretation
`complexity_m1` consistently dominates prediction across all models.  
Secondary signals align with family and education context.  
SHAP analyses were performed on the **full sample** and by **baseline risk tiers**, initiating subgroup exploration of _“what works for whom”_.

---

### 🚀 Next Steps
- Develop SHAP-based subgroup models by risk tier (1–4)  
- Apply PDP/ALE and interpretable logistic analyses  
- Conduct light causal checks on program features to derive **actionable policy levers**

---

### 📚 Additional Resources
- 📄 **Full Project Report:** [Data Science Project Protocol — Zohar Or Sharvit (PDF)](https://github.com/zoarsh/ml_project/blob/main/Data%20Science%20Project%20Protocol-%20Zohar%20Or%20S%20harvit.pdf)  
- 📘 **Extended README (Full Documentation):** [README_full.md](https://github.com/zoarsh/ml_project/blob/main/README_full.md)  
- 🖼️ **Figures & Visualizations:** see `reports/figures/`
