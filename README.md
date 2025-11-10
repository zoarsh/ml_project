## 👩‍💻 About Me
I'm **Zoar Or Sharvit**, a social researcher and data science practitioner with an academic background in **social work (M.S.W)** and a **Master’s degree (M.A.) in Early Childhood Education**.  Before entering the data field, I worked directly with **children and youth at risk**, which continues to guide the purpose behind my analytical work.  
Today, as an applied researcher on the **Children and Youth Team**, my goal is to help **reduce risk and vulnerability among children in Israel** through **data-driven insights and practical policy recommendations**.  
I see programming not just as a technical skill — but as a way to connect research with action, translating data into tools that inform, empower, and create real social impact.


# Project Title
Child Risk Prediction and Improvement Modeling with Machine Learning


---

## 🔍 Project Overview
This project focuses on transforming a large-scale social program dataset into a clean, analysis-ready format for machine learning modeling.  
The original dataset contained **107,300 records on 66,955 children**, collected through the **360° national program in Israel**.  
Over 37,000 children had only one measurement, which prevented before–after comparison.  
The work involved advanced data processing, feature engineering, and preparation for **supervised machine learning models** aimed at predicting both **risk levels** and **improvement outcomes**.

---

## ⚙️ Project Setup Summary
The setup phase focused on creating a clear and reproducible project environment.  
In the setup notebook (`setup_project.ipynb`), I ensured that the entire workflow was structured, documented, and version-controlled.  

Key steps included:
- Defining a **consistent folder structure** (`data/raw`, `data/interim`, `data/processed`, `reports`, `src`).
- Initializing a **Git repository** and connecting it to GitHub.
- Installing helpful Jupyter extensions (`jupyterlab-git`, `jupytext`).
- Creating a `.gitignore` file to exclude unnecessary files.
- Standardizing file paths, variable naming, and ensuring all notebooks follow a modular and reproducible structure.

---

## 🧾 Folder Structure
├── data/
│ ├── raw/ # Original data
│ ├── interim/ # Intermediate processed data
│ ├── processed/ # Modeling-ready data
│
├── notebooks/ # Jupyter notebooks
│ ├── 0_setup_project.ipynb
│ ├── 1_data_preparation.ipynb
│ ├── 2_EDA.ipynb
│ ├── 3_Data Cleansing.ipynb
│ ├── 4.Feature Engineering.ipynb
│ ├── 5_Feature_Selection_&_ One-Hote_Encoding.ipynb
│ ├── 6_Model_Selection_&_Fine_Tuning.ipynb
│ └── 8_github_upload.ipynb
│
├── reports/ # Figures, tables, and summaries
├── artifacts/ # Model outputs and snapshots
├── logs/ # Logs for debugging
├── README.md
└── config.json

---

## 🗺️ Project Roadmap
The project includes the following main notebooks:

| Step | Notebook | Description |
|------|-----------|--------------|
| 0 | `0_setup_project.ipynb` | Setup and environment initialization |
| 1 | `1_data_preparation.ipynb` | Data preparation and preprocessing |
| 2 | `2_EDA.ipynb` | Exploratory Data Analysis |
| 3 | `3_Data Cleansing.ipynb` | Data cleaning and validation |
| 4 | `4.Feature Engineering.ipynb` | Feature engineering and transformation |
| 5 | `5_Feature_Selection_&_ One-Hote_Encoding.ipynb` | Feature selection and encoding |
| 6 | `6_Model_Selection_&_Fine_Tuning.ipynb` | Model selection and fine-tuning |
| 8 | `8_github_upload.ipynb` | Final upload and documentation |

 
## 🧩  Step 1 — Data Preparation

### Empty / Near-Empty Columns
**Problem:** The dataset began with 230 variables. 28 were empty and 5 had >99% missing values.  
**Solution:** Dropped empty/non-informative variables, reducing the active set to ~200.

### Measurement Availability
**Problem:** 37,000 children had only one measurement, preventing before–after comparison.  
**Solution:** Filtered to 29,874 children with ≥2 measurements, leaving 69,802 valid records.

### Date Standardization
**Problem:** Two inconsistent datetime formats (with/without seconds).  
**Solution:** Unified format and derived day/month/year components for temporal analysis.

### Invalid Dates
**Problem:** Some records contained invalid or reversed date values.  
**Solution:** Removed inconsistent date entries before standardizing the valid ones.

### Duplicate Forms
**Problem:** 14% of forms were same-day duplicates (2–3 per day per child).  
**Solution:** Defined a completeness-based priority rule (number of filled risk items, time of day, index).  
Ensures one form per child–service–locality–day. In case of ties, selection was based on later submission time and then by record index

### Time Gaps Between Measurements
**Problem:** 73% of forms lacked valid day gaps (NaT or missing).  
**Solution:** Applied a **60–465 day rule (2–15 months)**; selected the latest valid form as m2.  
Invalid gaps excluded from wide format.

### Completeness of Risk Items
**Problem:** 43% of forms missing 2–4 risk items, consistently the same variables.  
**Solution:** Used completeness as a quality criterion — more complete forms prioritized.

### Logic for Building Two Measurements
**Problem:** Original syntax ignored duplicates and invalid date gaps.  
**Solution:** Implemented a rule-based pairing (m1–m2) process that selected only valid pairs within the 60–465 day window, removed duplicates, and verified chronological consistency before transforming to wide format.

---

---

## 🔎 Step 2 — Exploratory Data Analysis (EDA)

### Environment & Setup
Installed a Hebrew-supported environment (Python 3.11) to enable automated profiling and M1–M2 comparison.  
Created backup and working copies (**21,981 rows × 429 columns**) and implemented the helper function `quick_data_report` for schema tracking, missing values, duplicates, and version logs.

### Profiling & Descriptive Analysis
Generated a `ydata_profiling` HTML report comparing M1 and M2.  
Findings showed extensive missingness and imbalanced distributions in risk states.  
Removed **12 fully empty columns** and reviewed variable distributions, revealing strong skewness and dominance of low values.

### Target Definition
Defined two outcome variables:
- **Binary improvement** (`target_binary_improved`): 1 if risk decreased, 0 otherwise.  
- **Continuous change** (`target_delta_strength`): numeric difference between M1 and M2 complexity levels.  
Both were added with their categorical labels for interpretation and visualization.

### Correlations & Group Differences
Used **Spearman** correlations to identify highly correlated pairs (|r| ≥ 0.6),  
removing redundant variables (`days_diff_child_m2`, `birth_year_m2`).  
Applied **t-tests** and **ANOVA** to examine relationships between background factors and improvement scores.  
Risk and family-related variables showed significant and practically meaningful effects.

### Key Findings
- Higher baseline risk predicted stronger improvement.  
- Family-level risks (e.g., emotional or parental difficulties) had the largest impact.  
- Significant group differences:  
  - **Arab** children improved most, followed by **Haredi**, then **Jewish**.  
  - **Ages birth–6** showed the strongest improvement.  
  - Improvement rates highest in **Northern districts (44%)** and lowest in **Southern (26%)**.  
  - Strong variation by program type (**χ² p < 0.001**).  
- **VIF values (1.0–3.6)** indicated no serious multicollinearity.

**Conclusion:**  
The EDA revealed a highly imbalanced dataset with strong links between initial risk, family context, and improvement.  
Results confirmed the validity of the outcome variables and guided feature engineering and cleaning steps in the next stage.

---


## 🧩 Step 3 — Data Cleansing

### Outlier Detection 
No problematic outliers were found — all values were within logical ranges.  
All variables were retained for analysis to preserve variance and enable testing of large-family effects on risk and improvement.

### Missing Values — General Overview
**Problem:** High missingness: 293 columns had missing values, including 125 with ≥80% missing and 16 fully empty.  
**Solution:** Analyzed missingness patterns by variable type and measurement, distinguishing **true missing data** from **structural skips** (automatic skips due to questionnaire logic).

### Continuous Variables
**Problem:** Missing values in continuous variables (<4%) could bias analyses.  
**Solution:** Used a skewness-based imputation rule:  
- |skew| > 1 → fill with median (robust to outliers).  
- |skew| ≤ 1 → fill with mean.  
Filled median values for both child-count variables (`num_children_u18_m1`, `num_children_u18_m2`).

### Categorical Variables — Structural Missingness
**Problem:** Most missing values in risk items (RI) were structural, not random.  
**Solution:**  
- Identified skip patterns caused by “No” or “Unknown” in filter questions.  
- Reclassified “Unknown” as **0 (“no known risk”)** to represent absence of information, not true missingness.  
- Validated distribution consistency after transformation.  

### Large-Scale Imputation
**Problem:** Summary indicators (risk/ high-risk indexes) contained extensive structural missingness.  
**Solution:** Filled all missing cells with **0 (“no risk”)**, totaling **964,867 filled cells** across both measurements.  
Removed fully empty columns when they appeared in both M1 and M2.

### Strengths and Key Background Variables
**Problem:** Two textual “strength domain” variables had >80% missing and could not be imputed.  
**Solution:** After review, it was confirmed that these items were **not included in the data collection period** of this dataset and were introduced only in later questionnaire versions.  
They were therefore removed. Other variables with partial missingness were retained and filled with “Unknown.”

### Additional Rules
- Retained meaningful categorical variables even when partially missing (e.g., orphan status, parent/child disability).  
- Removed non-informative variables with >80% missing or technical metadata.  
- Verified all date variables — kept only those with full coverage (100%).

**Conclusion:**  
Data cleansing addressed structural skips, logical errors, and imputation consistency.  
The resulting dataset retained valid information across **21,981 records and 392 columns**, ready for feature engineering.

---

## 🧠 Step 4 — Feature Engineering

**Goal:** Expand the dataset with meaningful, interpretable features capturing program, risk, strength, and geographic dimensions.

### External Program Data
Merged an external file (95 programs, 11 variables) describing intervention characteristics.  
Matched 81 overlapping program codes with **84% coverage**, adding attributes such as **organizational unit, target group, type and duration of intervention, and declared outcomes**.  
Missing values were filled with `"unknown"`.

### Risk Domains
Aggregated 28 risk items into **7 domains** (family, emotional, behavioral, learning, social, protection, physical).  
Generated domain-level and cross-domain metrics (risk level, change, number of domains improved/worsened).  
→ **42 new variables** summarizing direction and intensity of child risk.

### Strength Indicators
Built normalized indices for **personal** and **interpersonal** strengths (0–1 scale).  
Environmental strengths were not collected in this dataset, as those items were added in later versions.

### Red Flag Items
Counted severe risk indicators (`n_star_flags_m1/m2`) and their change (`delta_star_flags`).  
About one-third of children improved, 40% remained stable, and one-quarter worsened.

### Geographic Indicators
Created multi-level risk measures using coordinates from **HDX**:  
- Local and district risk rates (`geo_risk_rate_m1/m2`)  
- Change and “high-risk area” flags  
Built a **composite intensity index** (0–1) combining risk and red-flag data per locality.

**Result:** Base frame loaded from `data_cleansing_merged.pkl` with shape **(21,981, 405)**; after feature engineering: **(21,981, 485)** — **+80** columns added, **0** removed.

---

## 🧪 Step 5 — Feature Selection & One-Hot Encoding

**Goal:** Produce a leakage-free feature matrix, encode categorical variables robustly, and retain a compact, informative subset for binary classification.

### Pre-filtering & Leakage Control
- Moved identifiers/codes out of the model (e.g., `ref_id_360_m*`, `program_code*`, `service_code`, `yeshuv_code`).
- Excluded all **m2** variables and all **delta/change/improved/worsened/target_* ** fields; kept **m1** and time-invariant variables only.
- Minor missingness fixes: removed 3 empty columns; imputed child age gaps by the mean.

### Categorical Encoding Strategy
- Services (`service_location_m1`, `service_name_m1`, `service_name_m1_clean`) → **Frequency Encoding**.
- Locality (`yeshuv_name_m1`) and Programs (`program_name_m1_clean`, `program_name`) → **Top-K OHE** (≈50 each); alternative program name fields dropped.
- Geographic context: kept **`geo_risk_rate_m1_yishuv`** as a **numeric** aggregate with tail smoothing and minimum-n; removed textual region IDs. Kept district-level numeric rate; dropped categorical district label.
- Removed: birth-region variables (near-constant), problematic action-composition/frequency fields, `organizational_unit`, `form_filler_role_m1`, and the computed `gap_bucket`.

### Univariate and Multimodel Selection
- **Univariate (ANOVA F-test)** after OHE on 812 features: top signals were m1 complexity and risk aggregates.
- **Multimodel votes:** Lasso, Ridge, penalized Logistic, Gradient Boosting, and Random Forest. Converted model selections to binary and kept features with **≥4 votes**.
- Reduced redundancy/multicollinearity by dropping overlapping “sum/count of risks” families (e.g., `n_risk_domains_m1`, `risk_item_count_m1`, several `*_has_m1`).

### Final modeling matrix
**Final modeling matrix:**  
Loaded from `df_modeling_binary_ohe_LATEST.pkl` → **shape (21,981 × 41)**.  
- **X:** 40 selected features (`float64`)  
- **y:** binary target (`target_binary_improved`)  
- **No missing values (NaN)** and **no object dtypes**  

**Target distribution:**  
0 = 14,578 (66.32%) | 1 = 7,403 (33.68%) → balance ratio = 0.51  

**Outcome:** A clean, balanced, and fully numeric dataset with 40 final predictive features, ready for model selection and fine-tuning.

---

## ⚙️ Step 6 — Model Selection & Fine-Tuning

**Goal:** Compare multiple classifiers, prioritize **Recall₀** (identifying non-improvers), and finalize a calibrated production model.

### Data Split
I created a reproducible 70/15/15 split for Train / Dev / Test, ensuring class balance across sets.  
- **Train:** (15,386 × 40)  
- **Dev:** (3,297 × 40)  
- **Test:** (3,298 × 40)  
- **Target balance:** 0 = 66.3%, 1 = 33.7% (stable across splits)

### Baseline Models
- **Logistic Regression:** Accuracy ≈ 0.69, F1 ≈ 0.61, ROC-AUC ≈ 0.77, PR-AUC ≈ 0.61.  
  Predicted ~69% of non-improvers and ~71% of improvers correctly.  
  Positive predictors: higher initial complexity, emotional/behavioral targets, parental education, Arab population.  
  Negative predictors: diagnosed or suspected disability, physical and learning difficulties.  

- **Decision Tree:** Accuracy ≈ 0.67, F1 ≈ 0.52, ROC-AUC ≈ 0.64, PR-AUC ≈ 0.43.  
  The first split is consistently **complexity_m1**, highlighting its dominance.

- **Random Forest:** Accuracy ≈ 0.74, F1 ≈ 0.58, ROC-AUC ≈ 0.79, PR-AUC ≈ 0.66.  
  Performs better overall, still conservative toward identifying improvers.

### Boosting Models
- **Gradient Boosting:** Accuracy ≈ 0.79, F1 ≈ 0.61, ROC-AUC ≈ 0.86, PR-AUC ≈ 0.77.  
  Very high Recall₀; cautious with positive (improvement) predictions.  

- **XGBoost:** F1 ≈ 0.71, ROC-AUC ≈ 0.87.  
  Correctly classifies ~77% of improvers and ~79% of non-improvers.

- **CatBoost (baseline):** Accuracy ≈ 0.80, F1 ≈ 0.72, ROC-AUC ≈ 0.88.  
  Balanced detection: ~78% improvers and ~81% non-improvers.  
  Top drivers: initial complexity, number of star-flags, and number of risk domains.

### Cross-Validation (5-Fold)
I validated model stability using Recall₀ as the main metric.  
- Logistic Regression achieved **Recall₀ ≈ 0.89**, though with a lower F1.  
- Gradient Boosting and Random Forest maintained the best balance between Recall₀ and overall F1.  
- CatBoost and XGBoost preserved strong ROC-AUC with moderate Recall₀ gains.

### Hyperparameter Tuning
- **Logistic Regression:** GridSearchCV yielded similar performance to the baseline; Bayesian optimization improved Recall₀ slightly but harmed overall balance (F1/AUC).  
- **CatBoost:** Randomized/Grid tuning improved metrics marginally — **Accuracy 0.793 → 0.796**, **F1 0.713 → 0.714**, **AUC ≈ 0.88**.  

I then calibrated the decision threshold to **p = 0.45**, achieving  
**Recall₀ ≈ 0.85**, **Accuracy ≈ 0.73**, and **F1 ≈ 0.56**, optimizing early detection of non-improvers while maintaining general reliability.

### Final Model
The **CatBoost (grid-tuned)** model was selected as the final classifier.  
- **Test results:** ROC-AUC ≈ 0.785, PR-AUC ≈ 0.635.  
- **Confusion matrix:** ~85% of non-improvers and ~51% of improvers correctly identified.  
- **Threshold:** 0.45 for optimal trade-off.  

All feature names were standardized (Hebrew → English) to ensure reproducibility and prevent label drift in later interpretability steps.

### Outcome
A stable, generalizable model (CatBoost GridSearchCV) balancing Recall₀ and overall F1, optimized for detecting children unlikely to improve after intervention.

### Feature Importance & Interpretation

Across all models, the most influential predictor of improvement was **initial complexity (num__complexity_m1)** — children who began with higher overall complexity were significantly more likely to show improvement, suggesting that intensive interventions are particularly effective among high-risk participants.  

Other key predictors included:  
- **Academic or learning difficulties (RS14)** and **undiagnosed disabilities**, both negatively associated with improvement.  
- **Parental education (≥12 years)** and **Arab population group**, both positively linked to improvement.  
- **Parental addictions** and **difficulty providing enrichment (RS12_1)** were strong negative predictors.  

Together, these variables describe a consistent pattern: improvement was more common among children with complex but well-defined needs who received structured interventions, while stagnation or deterioration was associated with chronic or unaddressed family and learning difficulties.

**By baseline risk profile:**  
- **Low risk:** improvement associated with moderate complexity, preventive engagement, and absence of addictions or learning problems.  
- **Low complexity:** strongest gains among children with educated parents and community-level high-risk targeting; emotional–social problems reduced improvement odds.  
- **High complexity:** greatest change among children receiving **multi-domain, emotionally focused interventions**.  
- **Extreme risk:** best outcomes when programs combined **emotional, parental, and educational support** for families with high complexity and instability.

Overall, while **complexity_m1** dominated predictive power across models, its meaning varied: in lower-risk groups it captured early prevention success, and in higher-risk groups it reflected the intensity and responsiveness of multi-system intervention.

---

### Next Steps

The findings indicate that **initial complexity (complexity_m1)** is the single most powerful and consistent predictor of improvement across all baseline risk levels.  
While this confirms the model’s predictive strength, it also highlights a key limitation: complexity itself is a *summary indicator* that cannot reveal which specific **risk factors, protective strengths, or program components** actually drive change.  

To translate predictive insight into actionable policy knowledge, the next research phase will focus on **interpretable analyses within each baseline risk group**, excluding `complexity_m1` from the explanatory layer.  
This will allow the identification of concrete levers — the *modifiable* elements that increase or reduce the likelihood of improvement for different profiles of children.

The planned continuation includes:  
- Building **SHAP-based explainability models** within each risk tier (1–4) to map which domains—risk (rs), strengths (st), and program features—contribute most to change.  
- Validating these findings using **partial dependence (PDP/ALE)** and **interpretable logistic models** for direction and effect size.  
- Estimating **program-level impacts** (e.g., outputs, desired outcomes) through light causal inference to detect which interventions “work best for whom.”  
- Synthesizing results into **four risk-profile summaries** with clear, data-driven recommendations for policy and practice.

In essence, the next stage moves from *predicting* improvement to *understanding* its mechanisms — identifying which protective factors, family resources, and intervention strategies most effectively promote positive outcomes.  
Such insights will enable adaptive program design and help **increase improvement rates among children at risk** by matching intervention intensity and content to each child’s initial risk profile.

---

The project now moves from prediction to explanation — using data-driven evidence to refine intervention design and strengthen outcomes for children and families at risk.


