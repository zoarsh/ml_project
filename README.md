# Project Title
Short overview, how to run, structure, and goals.

### Project Setup Summary

In the setup notebook (`setup_project.ipynb`), I organized the project so it is structured, clear, and easy to use. I set the project root for stable file paths, created a Git repository and connected it to GitHub, and enabled credential caching for smooth saving and sharing. I installed useful Jupyter tools (`jupyterlab-git` and `jupytext`), wrote a `.gitignore` file to exclude unnecessary files, and built a clean folder structure with dedicated folders for data, notebooks, reports, code, and documentation. I then moved all existing files into the right places, converted lesson scripts into notebooks, and defined standard path variables to ensure the project can always locate its data and reports.

### Project Data Preparation Summary

## Empty / Near-Empty Columns

⚠️ **Problem:** The dataset began with 230 variables. A total of 28 were completely empty and 5 had more than 99% missing values. Two system date fields contained almost only placeholders or missing values.
✅ **Solution:** The 28 empty variables and the two non-informative date fields were dropped, reducing the active set to about 200 variables. Near-empty fields were flagged for later review.

## Measurement Availability

⚠️ **Problem:** The original file contained 107,300 records on 66,955 children. Over 37,000 children had only one measurement, which prevents before–after analysis.
✅ **Solution:** These cases were excluded, leaving 69,802 records on 29,874 children with at least two measurements. Within this subset, about 81% have exactly two records and the rest three or more.

## Date Standardization

⚠️ **Problem:** The main date field was stored in two inconsistent formats: around 63% of records with seconds and 37% without.
✅ **Solution:** All 69,802 records were successfully converted to a unified datetime format, with additional derived fields for day, month, and year to allow consistent temporal analysis.


## Duplicate Forms

⚠️ **Problem:** Out of 69,802 records,About 14% of forms were same-day duplicates — the same child had more than one form submitted on the same day. This is problematic because the original syntax (“build two measurements”) assumed one unique form per day. In most cases there were 2–3 forms per day, with extreme cases of 10–24 forms.
✅ **Solution**: A mechanism was defined to select a primary form based on a completeness index (number of risk items filled, 28 = 100%), time of day (later is preferred), and, in case of ties, a technical tie-breaker by row index (the last entry). This ensures that for each child–service–locality–day, only one consistent form is retained.

## Time Gaps Between Measurements

⚠️ **Problem**: Out of ~70,000 forms, 73% had no computed day gap (days_diff_child). Around 30,000 of these are legitimate (the first forms for each child), but 25,600 were invalid dates (NaT). Without intervention, these cases would be automatically excluded.
✅ **Solution**: A manual review was added for the values that fell to NaT to identify their causes (missing values, dummy entries, inconsistent formats, typing errors). The decision was to apply a time-window rule of 60–465 days (2–15 months). For each first form (m1), a second form (m2) was identified within this range; if multiple candidates existed, the latest one was chosen. Forms with gaps shorter than 2 months or longer than 15 months remain in the long file but are excluded from the wide format.

## Completeness of Risk Items

⚠️ **Problem**: Almost all forms include all 28 risk items, but about 43% contained only 24 items, and another 5% contained 25 items. The same items (24–26) are consistently missing, creating a recurring pattern of incomplete data.
✅ **Solution**: Completeness was used as a validity check for questionnaires. A more complete form was prioritized over a less complete one within the same child–service–locality–day group.

## Logic for Building Two Measurements

⚠️ **Problem**: The original syntax handled only time gaps, without addressing same-day duplicates or invalid dates.
✅ **Solution**: The decision was to apply a time-window rule of 60–465 days (2–15 months). For each first form (m1), a second form (m2) was identified within this range; if multiple candidates existed, the latest one was chosen. Forms with gaps shorter than 2 months or longer than 15 months remain in the long file but are excluded from the wide format. After resolving same-day duplicates and invalid dates, the dataset was transformed into wide format with suffixes (_m1, _m2), and quality checks were performed to count how many children passed each step, flag keys left without valid pairs, and verify that no duplicates remained after the pivot.

## Column Handling  

During the column-handling stage, I standardized variable types, cleaned and normalized text values, consolidated categories, merged duplicate columns from the two measurements, removed non-informative fields, and engineered new population indicators. This ensured a compact, consistent, and analysis-ready dataset.  

**Problems and Solutions**  

- **Column Types & Dates**  
  ⚠️ Many columns were stored as `object`, and dates appeared as inconsistent strings.  
  ✅ Converted columns to proper types (`category`, `string`, `datetime`) with uniform parsing rules.  

- **Text Normalization**  
  ⚠️ Free-text fields included stray characters, hyphens, dots, and whitespace, fragmenting values.  
  ✅ Removed special characters, trimmed spaces, and standardized separators.  

- **Category Consolidation (Programs & Birth Countries)**  
  ⚠️ Program names and countries of birth appeared under multiple near-duplicate labels.  
  ✅ Unified program names into a consistent scheme and grouped countries into broader regions.  

- **Merging m1/m2 Twin Columns**  
  ⚠️ Identical attributes existed twice in the wide file (m1 and m2).  
  ✅ Merged each pair into one canonical column, preferring m1 unless missing.  

- **Derived Population Signals**  
  ⚠️ Indicators for Haredi, Arab, Jewish, Other and religiosity level were not explicitly available.  
  ✅ Engineered new features for population groups and religiosity, based on form type and population-group variables.

- **Service, Program, and Locality Names**
  ⚠️ Text fields for service_name, program_name, and residence_locality contained multiple near-duplicates, inconsistent spellings, and redundant categories .
  ✅ Applied normalization rules (lowercasing, trimming, hyphen removal) and canonical mapping patterns for consistent naming. Program names from the two measurements (m1/m2) were
      verified as nearly identical and merged into a single field. After cleaning, overlap between service_name and program_name increased from 51.5% to 90.9%, confirming successful
      unification and substantial reduction in duplicate categories.

- **Non-informative Columns**  
  ⚠️ Several fields carried constant values across all rows.  
  ✅ Dropped constant-value columns that added no analytic signal.  

**  

