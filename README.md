# BA Thesis: Ethnic Identity as Moderator of Income-Wellbeing Relationship in Afghanistan

## Research Question
Does ethnic identity (Hazara, Pashtun, Tajik) moderate the relationship between household income and subjective well-being in Afghanistan?

## Author
[Your Name]

## Date
December 31, 2025

---

## Research Overview

### Background
This study examines whether the relationship between household income and subjective well-being varies across ethnic groups in Afghanistan, specifically comparing Pashtuns (the politically dominant group), Hazaras (a historically marginalized minority), and Tajiks.

### Hypotheses

**H1: Main Effect of Income**
- Income positively affects subjective well-being across all ethnic groups

**H2: Ethnic Moderation**
- Ethnic identity moderates the income-SWB relationship (interaction effects are statistically significant)

**H3a: Aspirations Effect (Hazara)**
- The income effect is WEAKER for Hazaras than Pashtuns (negative interaction coefficient)
- Mechanism: As Hazaras gain income and education, their aspirations rise faster than their achievements, reducing the positive effect of income on well-being

**H3b: Trauma Effect (Hazara)**
- The income effect is STRONGER for Hazaras than Pashtuns (positive interaction coefficient)
- Mechanism: Economic resources help Hazaras overcome historical trauma and marginalization more effectively than other groups

**H4: Tajik Positioning**
- Tajiks fall between Hazaras and Pashtuns in the strength of the income-SWB relationship

---

## Data

**Source**: Asia Foundation Survey of the Afghan People (2014-2019)

**Sample Restrictions**:
- Years: 2014-2019 (excluding 2021 due to Taliban takeover)
- Non-missing values for key variables (happiness, income, ethnicity)

**Key Variables**:
- **Dependent Variable**: `happiness_ordered` (1=not at all happy to 4=very happy)
- **Independent Variable**: `income_cat9` (household income, 9 categories, treated as continuous)
- **Moderator**: Ethnicity dummies (`hazara`, `tajik`, `uzbek`; Pashtun = reference)
- **Control Variables**:
  - Demographics: age, gender, marital status
  - Education: primary, secondary, higher education
  - Household: household size categories
  - Economic: financial situation, physical condition, health, food quality, electricity
  - Institutional: corruption, national mood, democracy satisfaction, government trust
  - Information access: TV, internet

---

## Empirical Specification

### Main Model (OLS Regression)

```
Happiness = β₀ + β₁(Income) + β₂(Hazara) + β₃(Tajik) +
            β₄(Income × Hazara) + β₅(Income × Tajik) +
            Controls + Province FE + Year FE + ε
```

**Standard Errors**: Clustered at province level (34 clusters)

**Fixed Effects**:
- Province fixed effects (i.province)
- Year fixed effects (i.year)

### Interpretation of Key Coefficients

- **β₁**: Effect of income on happiness for Pashtuns (baseline group)
- **β₄**: Difference in income effect between Hazaras and Pashtuns
  - If β₄ < 0 and significant → H3a supported (Aspirations Effect)
  - If β₄ > 0 and significant → H3b supported (Trauma Effect)
- **β₅**: Difference in income effect between Tajiks and Pashtuns

**Marginal Effects**:
- Income effect for Pashtuns: β₁
- Income effect for Hazaras: β₁ + β₄
- Income effect for Tajiks: β₁ + β₅

---

## Analysis Files

This repository contains two complete analysis scripts:

### 1. **Stata Do-File** (Recommended)
📄 `ethnic_moderation_analysis.do`

**Requirements**:
- Stata 14 or higher
- Packages: `estout`, `coefplot` (script will prompt installation)

**Usage**:
```stata
* 1. Place your data file in the working directory
* 2. Open Stata
* 3. Run the do-file:
do ethnic_moderation_analysis.do
```

**Outputs**:
- `Table1A_Overall_Descriptives.rtf`
- `Table1B_Ethnic_Descriptives.rtf`
- `Table2_Main_Regressions.rtf`
- `Table3_Marginal_Effects.rtf`
- `Table4_Robustness_Checks.rtf`
- `Figure1_Income_Happiness_by_Ethnicity.png` (and `.pdf`)
- `Figure2_Prob_VeryHappy_by_Ethnicity.png`
- `output_descriptives.log`
- `interpretation_summary.log`

### 2. **Python Script** (Alternative)
📄 `ethnic_moderation_analysis.py`

**Requirements**:
```bash
pip install pandas numpy scipy statsmodels matplotlib seaborn linearmodels
```

**Usage**:
```bash
python ethnic_moderation_analysis.py
```

**Outputs**:
- `Table1A_Overall_Descriptives.csv`
- `Table1B_Ethnic_Descriptives.csv`
- `Table2_Main_Regressions.csv`
- `Table3_Marginal_Effects.csv`
- `Figure1_Income_Happiness_by_Ethnicity.png` (and `.pdf`)

**Note**: CSV files can be opened in Excel and formatted for Word

---

## Analysis Steps

Both scripts follow the same 8-step analysis:

### Step 1: Data Preparation
- Load data
- Apply sample restrictions (exclude 2021, keep 2014-2019)
- Create interaction terms (income × ethnicity)

### Step 2: Descriptive Statistics
- **Table 1A**: Overall sample summary statistics
- **Table 1B**: Summary statistics by ethnicity (Pashtun, Hazara, Tajik)
- Cross-tabulations of happiness and income by ethnic group

### Step 3: Progressive Regression Models
Eight models with increasing controls:
1. Income + Province FE + Year FE
2. + Ethnicity dummies
3. **+ Income × Ethnicity interactions** ← KEY MODEL
4. + Demographics (age, gender, marital status)
5. + Education levels
6. + Household characteristics
7. + Economic/living conditions
8. **+ Institutional variables** ← FULL MODEL

### Step 4: Marginal Effects and Hypothesis Tests
From the full model (Model 8):
- Calculate marginal effect of income for each ethnic group
- **Test H2**: Joint significance of interaction terms
- **Test H3**: Sign and significance of Hazara interaction
- **Test H4**: Pairwise slope comparisons

### Step 5: Visualization
- Line graph showing predicted happiness by income category
- Separate lines for Pashtun, Hazara, and Tajik
- 95% confidence intervals

### Step 6: Robustness Checks
Four alternative specifications:
1. Ordered logit instead of OLS
2. Income as categorical dummies instead of continuous
3. Region-level clustering instead of province-level
4. Rural subsample only

### Step 7: Additional Analysis (Stata only)
- Predicted probabilities from ordered logit model
- Probability of being "Very Happy" by ethnicity

### Step 8: Interpretation Summary
- Comprehensive summary of results
- Hypothesis testing outcomes
- Substantive interpretation of coefficients
- Effect size calculations

---

## Expected Results & Interpretation Guide

### If H3a is Supported (Aspirations Effect)
**Finding**: Income × Hazara coefficient is **negative** and significant

**Interpretation for Thesis**:
> "The positive relationship between income and well-being is significantly weaker for Hazaras compared to Pashtuns (β₄ = -0.XX, p < 0.05). Specifically, a one-category increase in income is associated with a 0.XX point increase in happiness for Pashtuns, compared to only 0.XX for Hazaras—a difference of 0.XX points. This finding supports the 'aspirations effect' hypothesis: as Hazaras experience income gains and increased social mobility, their aspirations and reference groups shift upward more rapidly than their actual achievements, partially offsetting the psychological benefits of higher income. This pattern is consistent with Easterlin's (2001) relative income hypothesis and suggests that subjective well-being among historically marginalized groups may be more sensitive to aspirational dynamics than absolute economic improvements."

### If H3b is Supported (Trauma Effect)
**Finding**: Income × Hazara coefficient is **positive** and significant

**Interpretation for Thesis**:
> "The positive relationship between income and well-being is significantly stronger for Hazaras compared to Pashtuns (β₄ = +0.XX, p < 0.05). A one-category increase in income is associated with a 0.XX point increase in happiness for Pashtuns, but a 0.XX point increase for Hazaras—a difference of 0.XX points. This finding supports the 'trauma effect' hypothesis: economic resources enable Hazaras to overcome the psychological impacts of historical persecution and systemic marginalization more effectively than they benefit other ethnic groups. Higher income may provide Hazaras with greater security, social mobility, and buffering against discrimination, translating into larger gains in subjective well-being."

### If H2 is Not Supported
**Finding**: Interaction terms are not jointly significant

**Interpretation for Thesis**:
> "Contrary to expectations, ethnic identity does not significantly moderate the relationship between income and subjective well-being in Afghanistan (F = X.XX, p = 0.XX). The income-happiness relationship appears similar across Pashtuns, Hazaras, and Tajiks, suggesting that economic factors operate similarly across ethnic groups despite their different historical and social positions. This finding aligns with universalist theories of subjective well-being that emphasize the primacy of absolute economic resources over group-specific mechanisms."

---

## Publication-Ready Tables

All tables are formatted for direct inclusion in your thesis:

### Table 1: Descriptive Statistics
- Panel A: Overall sample (N, means, SDs)
- Panel B: By ethnicity

### Table 2: Main Regression Results
- 8 progressive models
- Coefficients with standard errors
- Stars for significance levels
- R² and N at bottom
- **Highlight**: Income × Ethnicity interactions

### Table 3: Marginal Effects
- Income slope for each ethnic group
- Standard errors (delta method)
- p-values
- Pairwise comparisons

### Table 4: Robustness Checks
- 4 alternative specifications
- Focus on interaction coefficients

### Figure 1: Income-Happiness by Ethnicity
- High-resolution PNG (for presentations)
- PDF (for LaTeX/Word)
- 95% confidence intervals
- Professional formatting

---

## Statistical Notes

### Clustering
Standard errors are clustered at the **province level** (34 clusters) to account for:
- Within-province correlation of errors
- Province-level policies and conditions
- Spatial autocorrelation

### Fixed Effects
- **Province FE**: Control for time-invariant provincial characteristics
- **Year FE**: Control for Afghanistan-wide trends and shocks

### Missing Data
Listwise deletion is used (observations with missing values on key variables are excluded). The final sample size will depend on data completeness.

### Significance Levels
- *** p < 0.01
- ** p < 0.05
- * p < 0.10

---

## Thesis Writing Tips

### Results Section Structure

**1. Descriptive Statistics (1-2 paragraphs)**
- Sample composition by ethnicity
- Mean happiness and income by group
- Reference Table 1

**2. Main Results (3-4 paragraphs)**
- H1: Main effect of income (Model 1)
- H2: Adding ethnicity controls (Model 2)
- H2 & H3: Interaction effects (Models 3-8)
- Focus on Model 8 (full specification)
- Reference Table 2

**3. Marginal Effects (2-3 paragraphs)**
- Income slopes by ethnicity
- Hypothesis testing (H3a vs H3b, H4)
- Substantive interpretation
- Reference Table 3 and Figure 1

**4. Robustness (1-2 paragraphs)**
- Brief summary of robustness checks
- Confirm main results hold
- Reference Table 4

### Discussion Section

**Key Points to Address**:
1. **Which hypothesis is supported?** (H3a or H3b)
2. **Why might this be the case?** (theoretical mechanisms)
3. **What are the implications?**
   - For understanding ethnic inequality in Afghanistan
   - For development policy
   - For theories of subjective well-being
4. **Limitations**:
   - Cross-sectional data (cannot establish causality)
   - Self-reported measures
   - Omitted variable bias concerns
   - Sample period (2014-2019)
5. **Future research directions**

---

## Data File Requirements

The analysis scripts expect a data file named:
- `final_replication_data_Asia_Foundation.dta` (Stata format)
- OR `final_replication_data_Asia_Foundation.csv` (CSV format)

**Required Variables** (must be present in the dataset):
- `happiness_ordered`
- `income_cat9`
- `pashtun`, `tajik`, `hazara`, `uzbek`
- `province`, `year`, `region`
- Control variables (see list in Research Overview)

If your data file has a different name, modify line 3 of the do-file or line 27 of the Python script.

---

## Troubleshooting

### Stata Issues

**Problem**: "file not found"
- **Solution**: Ensure the `.dta` file is in the same directory as the do-file, or modify the file path in line 3

**Problem**: "variable not found"
- **Solution**: Check that all required variables exist in your dataset. Comment out missing variables in the control lists.

**Problem**: "too few clusters"
- **Solution**: If you have fewer than 34 provinces, consider using region-level clustering instead

**Problem**: "insufficient observations"
- **Solution**: Relax sample restrictions or use fewer control variables

### Python Issues

**Problem**: Module not found
- **Solution**: Install required packages:
  ```bash
  pip install pandas numpy scipy statsmodels matplotlib seaborn linearmodels
  ```

**Problem**: Memory error
- **Solution**: Use a smaller sample or run on a machine with more RAM

**Problem**: Convergence issues with Ordered Logit
- **Solution**: This is common with complex models. The OLS results are the primary focus.

---

## Citation

If you use this analysis framework, please cite:

```
[Your Name]. (2025). Ethnic Identity as a Moderator of the Income-Wellbeing
Relationship in Afghanistan: Evidence from the Asia Foundation Survey 2014-2019.
BA Thesis, [Your University].
```

**Data Source**:
```
The Asia Foundation. (2014-2019). Afghanistan Survey of the Afghan People.
Available at: https://asiafoundation.org/
```

---

## Contact

For questions about this analysis, contact:
- Email: [your.email@university.edu]
- GitHub: [your-github-username]

---

## License

This analysis code is provided for academic use. Please attribute appropriately if you use or modify these scripts.

---

## Appendix: Variable Descriptions

### Dependent Variable
- `happiness_ordered`: Self-reported happiness (1=not at all happy, 2=not very happy, 3=somewhat happy, 4=very happy)

### Independent Variable
- `income_cat9`: Household monthly income in 9 categories (1=lowest, 9=highest)

### Ethnicity (Dummies)
- `pashtun`: 1 if Pashtun, 0 otherwise (REFERENCE CATEGORY)
- `tajik`: 1 if Tajik, 0 otherwise
- `hazara`: 1 if Hazara, 0 otherwise
- `uzbek`: 1 if Uzbek, 0 otherwise

### Control Variables

**Demographics**:
- `age2635`: 1 if age 26-35, 0 otherwise
- `age3645`: 1 if age 36-45, 0 otherwise
- `age4655`: 1 if age 46-55, 0 otherwise
- `age55over`: 1 if age 55+, 0 otherwise (reference: age 18-25)
- `gender`: 1 if male, 0 if female
- `married`: 1 if married, 0 otherwise
- `single`: 1 if single, 0 otherwise
- `widow`: 1 if widowed, 0 otherwise

**Education**:
- `primary_edu`: 1 if completed primary education, 0 otherwise
- `secondary_edu`: 1 if completed secondary education, 0 otherwise
- `higher_edu`: 1 if completed higher education, 0 otherwise (reference: no education)

**Household**:
- `hhsize1_4`: 1 if household size 1-4, 0 otherwise
- `hhsize5_8`: 1 if household size 5-8, 0 otherwise
- `hhsize9_12`: 1 if household size 9-12, 0 otherwise

**Economic/Living Conditions**:
- `financialhh`: Household financial situation (1=worse, 2=same, 3=better)
- `physicalchh`: Physical condition of dwelling (1=worse, 2=same, 3=better)
- `wellbeing_hh`: Health well-being of household (1=worse, 2=same, 3=better)
- `food_quality`: Quality of food/diet (1=worse, 2=same, 3=better)
- `electricity`: Access to electricity (1=worse, 2=same, 3=better)

**Institutional/Political**:
- `corruption_dlife`: Experience of corruption in daily life (1=yes, 0=no)
- `nmood`: National mood/direction (1=right direction, 0=wrong direction)
- `sdemocracy`: Satisfaction with democracy (1=very dissatisfied to 4=very satisfied)
- `trust_gov`: Trust in government (1=no trust to 4=a lot of trust)

**Information Access**:
- `info_tv`: Access to television (1=yes, 0=no)
- `info_net`: Access to internet (1=yes, 0=no)

**Fixed Effects**:
- `province`: Province identifier (34 provinces)
- `year`: Survey year (2014-2019)
- `region`: Geographic region (8 regions)

---

**End of README**
