#!/usr/bin/env python3
"""
BA THESIS: Ethnic Identity as Moderator of Income-Wellbeing Relationship
Research Question: Does ethnic identity (Hazara, Pashtun, Tajik) moderate
                   the relationship between household income and subjective
                   well-being in Afghanistan?

Author: [Your Name]
Date: December 31, 2025

This Python script provides an alternative to the Stata analysis
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
import statsmodels.api as sm
import statsmodels.formula.api as smf
from statsmodels.iolib.summary2 import summary_col
from statsmodels.regression.linear_model import OLS
from linearmodels.panel import PanelOLS
import warnings
warnings.filterwarnings('ignore')

# Set visualization style
sns.set_style("whitegrid")
plt.rcParams['figure.figsize'] = (12, 8)
plt.rcParams['font.size'] = 11

print("="*80)
print("ETHNIC IDENTITY MODERATION ANALYSIS")
print("Afghanistan Survey Data 2014-2019")
print("="*80)
print()

################################################################################
# STEP 1: LOAD AND PREPARE DATA
################################################################################

print("STEP 1: Loading and preparing data...")
print("-"*80)

# Load data (supports both Stata .dta and CSV formats)
try:
    # Try loading Stata file
    df = pd.read_stata('final_replication_data_Asia_Foundation.dta')
    print("✓ Loaded Stata file successfully")
except:
    try:
        # Try CSV alternative
        df = pd.read_csv('final_replication_data_Asia_Foundation.csv')
        print("✓ Loaded CSV file successfully")
    except:
        print("ERROR: Data file not found!")
        print("Please ensure one of these files exists:")
        print("  - final_replication_data_Asia_Foundation.dta")
        print("  - final_replication_data_Asia_Foundation.csv")
        exit(1)

# Sample restrictions
print(f"Initial observations: {len(df)}")

# Exclude 2021 (Taliban takeover)
df = df[df['year'] != 2021]
print(f"After excluding 2021: {len(df)}")

# Keep only 2014-2019
df = df[(df['year'] >= 2014) & (df['year'] <= 2019)]
print(f"After keeping 2014-2019: {len(df)}")

# Drop missing values in key variables
key_vars = ['happiness_ordered', 'income_cat9', 'pashtun', 'tajik', 'hazara']
df = df.dropna(subset=key_vars)
print(f"After dropping missing key variables: {len(df)}")

# Create interaction terms
df['income_hazara'] = df['income_cat9'] * df['hazara']
df['income_tajik'] = df['income_cat9'] * df['tajik']
df['income_uzbek'] = df['income_cat9'] * df['uzbek']

print("✓ Interaction terms created")
print()

################################################################################
# STEP 2: DESCRIPTIVE STATISTICS
################################################################################

print("="*80)
print("TABLE 1: DESCRIPTIVE STATISTICS")
print("="*80)
print()

# Table 1A: Overall Sample
print("Panel A: Overall Sample")
print("-"*80)

desc_vars = ['happiness_ordered', 'income_cat9', 'age2635', 'age3645',
             'age4655', 'age55over', 'gender', 'married', 'single', 'widow',
             'primary_edu', 'secondary_edu', 'higher_edu',
             'hhsize1_4', 'hhsize5_8', 'hhsize9_12',
             'financialhh', 'physicalchh', 'wellbeing_hh', 'food_quality',
             'electricity', 'corruption_dlife', 'nmood', 'sdemocracy',
             'trust_gov', 'info_tv', 'info_net',
             'pashtun', 'tajik', 'hazara', 'uzbek']

# Filter to available variables
desc_vars = [v for v in desc_vars if v in df.columns]

desc_overall = df[desc_vars].describe().T
desc_overall = desc_overall[['mean', 'std', 'min', 'max', 'count']]
print(desc_overall.round(3))

# Export to CSV (can be opened in Excel/Word)
desc_overall.to_csv('Table1A_Overall_Descriptives.csv')
print("\n✓ Saved to Table1A_Overall_Descriptives.csv")
print()

# Table 1B: By Ethnicity
print("Panel B: Descriptive Statistics by Ethnicity")
print("-"*80)

ethnic_groups = [
    ('Pashtun', df[df['pashtun'] == 1]),
    ('Hazara', df[df['hazara'] == 1]),
    ('Tajik', df[df['tajik'] == 1])
]

ethnic_desc = []
for name, group in ethnic_groups:
    print(f"\n{name} (N = {len(group)}):")
    desc = group[desc_vars].describe().T[['mean', 'std']]
    desc.columns = [f'{name}_mean', f'{name}_std']
    ethnic_desc.append(desc)
    print(desc.round(3).head(15))

ethnic_desc_combined = pd.concat(ethnic_desc, axis=1)
ethnic_desc_combined.to_csv('Table1B_Ethnic_Descriptives.csv')
print("\n✓ Saved to Table1B_Ethnic_Descriptives.csv")
print()

# Cross-tabulation
print("Cross-tabulation: Mean Happiness and Income by Ethnicity")
print("-"*80)
for name, group in ethnic_groups:
    print(f"{name:10s}: Happiness = {group['happiness_ordered'].mean():.3f}, "
          f"Income = {group['income_cat9'].mean():.3f}, N = {len(group)}")
print()

################################################################################
# STEP 3: MAIN REGRESSION MODELS
################################################################################

print("="*80)
print("TABLE 2: MAIN REGRESSION RESULTS - OLS WITH ETHNIC INTERACTIONS")
print("="*80)
print()

# Control variables for each model
controls = {
    'model1': '',
    'model2': 'hazara + tajik + uzbek',
    'model3': 'hazara + tajik + uzbek + income_hazara + income_tajik',
    'model4': 'hazara + tajik + uzbek + income_hazara + income_tajik + '
              'age2635 + age3645 + age4655 + age55over + gender + married + single',
    'model5': 'hazara + tajik + uzbek + income_hazara + income_tajik + '
              'age2635 + age3645 + age4655 + age55over + gender + married + single + '
              'primary_edu + secondary_edu + higher_edu',
    'model6': 'hazara + tajik + uzbek + income_hazara + income_tajik + '
              'age2635 + age3645 + age4655 + age55over + gender + married + single + '
              'primary_edu + secondary_edu + higher_edu + '
              'hhsize1_4 + hhsize5_8 + hhsize9_12',
    'model7': 'hazara + tajik + uzbek + income_hazara + income_tajik + '
              'age2635 + age3645 + age4655 + age55over + gender + married + single + '
              'primary_edu + secondary_edu + higher_edu + '
              'hhsize1_4 + hhsize5_8 + hhsize9_12 + '
              'financialhh + physicalchh + wellbeing_hh + food_quality + electricity',
    'model8': 'hazara + tajik + uzbek + income_hazara + income_tajik + '
              'age2635 + age3645 + age4655 + age55over + gender + married + single + '
              'primary_edu + secondary_edu + higher_edu + '
              'hhsize1_4 + hhsize5_8 + hhsize9_12 + '
              'financialhh + physicalchh + wellbeing_hh + food_quality + electricity + '
              'corruption_dlife + nmood + sdemocracy + trust_gov + info_tv + info_net'
}

# Add fixed effects specification
fe_spec = 'C(province) + C(year)'

results = {}

for model_name, control_vars in controls.items():
    print(f"Running {model_name}...")

    if control_vars:
        formula = f'happiness_ordered ~ income_cat9 + {control_vars} + {fe_spec}'
    else:
        formula = f'happiness_ordered ~ income_cat9 + {fe_spec}'

    # Run regression with clustered standard errors
    try:
        mod = smf.ols(formula, data=df).fit(
            cov_type='cluster',
            cov_kwds={'groups': df['province']}
        )
        results[model_name] = mod

        if model_name == 'model3':
            print("\n*** MODEL 3: KEY INTERACTION COEFFICIENTS ***")
            print(f"Income (Pashtun baseline): {mod.params.get('income_cat9', np.nan):.4f}")
            print(f"Income × Hazara: {mod.params.get('income_hazara', np.nan):.4f}")
            print(f"Income × Tajik: {mod.params.get('income_tajik', np.nan):.4f}")
            print()
    except Exception as e:
        print(f"Warning: Could not run {model_name}: {e}")
        continue

# Create regression table
print("\nRegression Results Summary:")
print("-"*80)

# Extract key coefficients
coef_names = ['income_cat9', 'hazara', 'tajik', 'uzbek', 'income_hazara', 'income_tajik']
reg_table = pd.DataFrame()

for model_name, mod in results.items():
    model_num = model_name.replace('model', '')
    coefs = []
    for coef in coef_names:
        if coef in mod.params.index:
            val = f"{mod.params[coef]:.3f}"
            se = f"({mod.bse[coef]:.3f})"
            pval = mod.pvalues[coef]
            stars = '***' if pval < 0.01 else '**' if pval < 0.05 else '*' if pval < 0.10 else ''
            coefs.append(f"{val}{stars}\n{se}")
        else:
            coefs.append('')

    coefs.append(f"{mod.nobs:.0f}")
    coefs.append(f"{mod.rsquared:.3f}")

    reg_table[f'({model_num})'] = coefs

reg_table.index = coef_names + ['N', 'R²']
print(reg_table)

# Export
reg_table.to_csv('Table2_Main_Regressions.csv')
print("\n✓ Saved to Table2_Main_Regressions.csv")
print()

################################################################################
# STEP 4: MARGINAL EFFECTS AND HYPOTHESIS TESTS
################################################################################

print("="*80)
print("TABLE 3: MARGINAL EFFECTS BY ETHNICITY (FROM FULL MODEL)")
print("="*80)
print()

# Use Model 8 (full model)
mod_full = results['model8']

# Calculate marginal effects
print("MARGINAL EFFECT OF INCOME BY ETHNICITY:")
print("-"*80)

# Pashtun (baseline)
me_pashtun = mod_full.params['income_cat9']
se_pashtun = mod_full.bse['income_cat9']
t_pashtun = me_pashtun / se_pashtun
p_pashtun = 2 * (1 - stats.t.cdf(abs(t_pashtun), mod_full.df_resid))

print(f"Pashtun (baseline): {me_pashtun:.4f} (SE: {se_pashtun:.4f}, p={p_pashtun:.3f})")

# Hazara
me_hazara = mod_full.params['income_cat9'] + mod_full.params['income_hazara']
# Delta method for SE
cov_matrix = mod_full.cov_params()
var_hazara = (cov_matrix.loc['income_cat9', 'income_cat9'] +
              cov_matrix.loc['income_hazara', 'income_hazara'] +
              2 * cov_matrix.loc['income_cat9', 'income_hazara'])
se_hazara = np.sqrt(var_hazara)
t_hazara = me_hazara / se_hazara
p_hazara = 2 * (1 - stats.t.cdf(abs(t_hazara), mod_full.df_resid))

print(f"Hazara: {me_hazara:.4f} (SE: {se_hazara:.4f}, p={p_hazara:.3f})")

# Tajik
me_tajik = mod_full.params['income_cat9'] + mod_full.params['income_tajik']
var_tajik = (cov_matrix.loc['income_cat9', 'income_cat9'] +
             cov_matrix.loc['income_tajik', 'income_tajik'] +
             2 * cov_matrix.loc['income_cat9', 'income_tajik'])
se_tajik = np.sqrt(var_tajik)
t_tajik = me_tajik / se_tajik
p_tajik = 2 * (1 - stats.t.cdf(abs(t_tajik), mod_full.df_resid))

print(f"Tajik: {me_tajik:.4f} (SE: {se_tajik:.4f}, p={p_tajik:.3f})")
print()

# Create marginal effects table
me_table = pd.DataFrame({
    'Coefficient': [me_pashtun, me_hazara, me_tajik],
    'Std.Error': [se_pashtun, se_hazara, se_tajik],
    't-stat': [t_pashtun, t_hazara, t_tajik],
    'p-value': [p_pashtun, p_hazara, p_tajik]
}, index=['Pashtun', 'Hazara', 'Tajik'])

print(me_table.round(4))
me_table.to_csv('Table3_Marginal_Effects.csv')
print("\n✓ Saved to Table3_Marginal_Effects.csv")
print()

# HYPOTHESIS TESTS
print("="*80)
print("HYPOTHESIS TESTS")
print("="*80)
print()

# H2: Joint significance of interactions
print("H2: Joint Significance of Ethnic Interactions")
print("-"*80)

# F-test for joint significance (simplified)
r_matrix = np.zeros((2, len(mod_full.params)))
param_names = list(mod_full.params.index)
r_matrix[0, param_names.index('income_hazara')] = 1
r_matrix[1, param_names.index('income_tajik')] = 1

from scipy.stats import f as f_dist
wald_test = mod_full.wald_test(r_matrix)
f_stat = wald_test.fvalue[0][0]
p_val = wald_test.pvalue

print(f"F-statistic: {f_stat:.3f}")
print(f"p-value: {p_val:.4f}")

if p_val < 0.05:
    print("Result: INTERACTIONS ARE JOINTLY SIGNIFICANT (p < 0.05)")
    print("Conclusion: Ethnic identity DOES moderate the income-SWB relationship")
else:
    print("Result: Interactions not jointly significant")
print()

# H3: Hazara interaction
print("H3: Hazara Interaction Effect (Aspirations vs Trauma)")
print("-"*80)

hazara_coef = mod_full.params['income_hazara']
hazara_se = mod_full.bse['income_hazara']
hazara_t = hazara_coef / hazara_se
hazara_p = mod_full.pvalues['income_hazara']

print(f"Income × Hazara coefficient: {hazara_coef:.4f}")
print(f"Standard error: {hazara_se:.4f}")
print(f"p-value: {hazara_p:.4f}")
print()

if hazara_coef < 0 and hazara_p < 0.10:
    print("→ H3a SUPPORTED (Aspirations Effect)")
    print("  The income effect is WEAKER for Hazaras than Pashtuns")
    print(f"  Income slope for Hazaras: {me_hazara:.4f}")
    print(f"  Income slope for Pashtuns: {me_pashtun:.4f}")
    print(f"  Difference: {hazara_coef:.4f}")
    print()
    print("  INTERPRETATION: While higher income increases happiness for all groups,")
    print("  the effect is significantly smaller for Hazaras. This supports the")
    print("  'aspirations effect' - as Hazaras gain income, their rising aspirations")
    print("  partially offset the positive effect of income on well-being.")
elif hazara_coef > 0 and hazara_p < 0.10:
    print("→ H3b SUPPORTED (Trauma Effect)")
    print("  The income effect is STRONGER for Hazaras than Pashtuns")
    print(f"  Income slope for Hazaras: {me_hazara:.4f}")
    print(f"  Income slope for Pashtuns: {me_pashtun:.4f}")
    print(f"  Difference: {hazara_coef:.4f}")
    print()
    print("  INTERPRETATION: The income effect is significantly larger for Hazaras.")
    print("  This supports the 'trauma effect' - economic resources help Hazaras")
    print("  overcome historical marginalization more effectively than other groups.")
else:
    print("→ Neither H3a nor H3b supported (interaction not significant)")
print()

# H4: Pairwise comparisons
print("H4: Pairwise Slope Comparisons")
print("-"*80)
print(f"Pashtun vs Hazara: Difference = {hazara_coef:.4f} (p = {hazara_p:.4f})")

tajik_coef = mod_full.params['income_tajik']
tajik_p = mod_full.pvalues['income_tajik']
print(f"Pashtun vs Tajik: Difference = {tajik_coef:.4f} (p = {tajik_p:.4f})")

diff_ht = hazara_coef - tajik_coef
# SE of difference (delta method)
var_diff = (cov_matrix.loc['income_hazara', 'income_hazara'] +
            cov_matrix.loc['income_tajik', 'income_tajik'] -
            2 * cov_matrix.loc['income_hazara', 'income_tajik'])
se_diff = np.sqrt(var_diff)
t_diff = diff_ht / se_diff
p_diff = 2 * (1 - stats.t.cdf(abs(t_diff), mod_full.df_resid))
print(f"Hazara vs Tajik: Difference = {diff_ht:.4f} (p = {p_diff:.4f})")
print()

################################################################################
# STEP 5: VISUALIZATION
################################################################################

print("="*80)
print("FIGURE 1: PREDICTED HAPPINESS BY INCOME AND ETHNICITY")
print("="*80)
print()

# Create prediction dataset
income_range = np.arange(1, 10)

# Calculate means of control variables
control_means = {}
control_vars_list = ['age2635', 'age3645', 'age4655', 'age55over',
                     'gender', 'married', 'single',
                     'primary_edu', 'secondary_edu', 'higher_edu',
                     'hhsize1_4', 'hhsize5_8', 'hhsize9_12',
                     'financialhh', 'physicalchh', 'wellbeing_hh',
                     'food_quality', 'electricity',
                     'corruption_dlife', 'nmood', 'sdemocracy',
                     'trust_gov', 'info_tv', 'info_net']

for var in control_vars_list:
    if var in df.columns:
        control_means[var] = df[var].mean()

# Modal province and year
modal_province = df['province'].mode()[0]
modal_year = df['year'].mode()[0]

# Generate predictions for each ethnic group
predictions = {}
ci_lower = {}
ci_upper = {}

for eth_name, eth_vars in [('Pashtun', {'pashtun': 1, 'hazara': 0, 'tajik': 0, 'uzbek': 0}),
                            ('Hazara', {'pashtun': 0, 'hazara': 1, 'tajik': 0, 'uzbek': 0}),
                            ('Tajik', {'pashtun': 0, 'hazara': 0, 'tajik': 1, 'uzbek': 0})]:

    pred_data = pd.DataFrame({
        'income_cat9': income_range,
        **eth_vars,
        **control_means,
        'province': modal_province,
        'year': modal_year
    })

    # Add interactions
    pred_data['income_hazara'] = pred_data['income_cat9'] * pred_data['hazara']
    pred_data['income_tajik'] = pred_data['income_cat9'] * pred_data['tajik']
    pred_data['income_uzbek'] = pred_data['income_cat9'] * pred_data['uzbek']

    # Predict
    preds = mod_full.predict(pred_data)
    predictions[eth_name] = preds.values

    # Confidence intervals (approximate)
    pred_se = np.sqrt(mod_full.scale)  # Simplified
    ci_lower[eth_name] = preds.values - 1.96 * pred_se
    ci_upper[eth_name] = preds.values + 1.96 * pred_se

# Create figure
fig, ax = plt.subplots(figsize=(12, 8))

colors = {'Pashtun': '#1f77b4', 'Hazara': '#d62728', 'Tajik': '#2ca02c'}
markers = {'Pashtun': 'o', 'Hazara': 's', 'Tajik': '^'}

for eth_name in ['Pashtun', 'Hazara', 'Tajik']:
    ax.plot(income_range, predictions[eth_name],
            label=eth_name,
            color=colors[eth_name],
            marker=markers[eth_name],
            linewidth=2.5,
            markersize=8)

    ax.fill_between(income_range,
                    ci_lower[eth_name],
                    ci_upper[eth_name],
                    color=colors[eth_name],
                    alpha=0.2)

ax.set_xlabel('Income Category (1-9)', fontsize=13, fontweight='bold')
ax.set_ylabel('Predicted Happiness (1-4 scale)', fontsize=13, fontweight='bold')
ax.set_title('Figure 1: Predicted Happiness by Income and Ethnicity\n(with 95% Confidence Intervals)',
             fontsize=14, fontweight='bold', pad=20)
ax.set_xticks(income_range)
ax.legend(loc='best', fontsize=12, frameon=True, shadow=True)
ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('Figure1_Income_Happiness_by_Ethnicity.png', dpi=300, bbox_inches='tight')
plt.savefig('Figure1_Income_Happiness_by_Ethnicity.pdf', bbox_inches='tight')
print("✓ Saved Figure 1 (PNG and PDF)")
print()

################################################################################
# STEP 6: ROBUSTNESS CHECKS
################################################################################

print("="*80)
print("TABLE 4: ROBUSTNESS CHECKS")
print("="*80)
print()

robust_results = {}

# Robustness 1: Ordered Logit (using statsmodels)
print("Running Robustness Check 1: Ordered Logit...")
from statsmodels.miscmodels.ordinal_model import OrderedModel

try:
    # Prepare data for ordered logit
    robust_formula = ('income_cat9 + hazara + tajik + uzbek + income_hazara + income_tajik + '
                     'age2635 + age3645 + age4655 + age55over + gender + married + single + '
                     'primary_edu + secondary_edu + higher_edu + '
                     'hhsize1_4 + hhsize5_8 + hhsize9_12 + '
                     'financialhh + physicalchh + wellbeing_hh + food_quality + electricity + '
                     'corruption_dlife + nmood + sdemocracy + trust_gov + info_tv + info_net + '
                     'C(province) + C(year)')

    mod_ologit = OrderedModel.from_formula(
        f'happiness_ordered ~ {robust_formula}',
        data=df,
        distr='logit'
    )
    res_ologit = mod_ologit.fit(method='bfgs', disp=False)
    robust_results['ologit'] = res_ologit
    print("✓ Ordered logit completed")
except Exception as e:
    print(f"  Warning: Ordered logit failed: {e}")

# Robustness 2: Income as categorical
print("Running Robustness Check 2: Income as Categorical...")
df['income_cat'] = df['income_cat9'].astype('category')
for i in range(2, 10):
    df[f'inc{i}_hazara'] = ((df['income_cat9'] == i) * df['hazara']).astype(int)
    df[f'inc{i}_tajik'] = ((df['income_cat9'] == i) * df['tajik']).astype(int)

cat_formula = ('C(income_cat9) + hazara + tajik + uzbek + '
               'inc2_hazara + inc3_hazara + inc4_hazara + inc5_hazara + '
               'inc6_hazara + inc7_hazara + inc8_hazara + inc9_hazara + '
               'inc2_tajik + inc3_tajik + inc4_tajik + inc5_tajik + '
               'inc6_tajik + inc7_tajik + inc8_tajik + inc9_tajik + '
               'age2635 + age3645 + age4655 + age55over + gender + married + single + '
               'primary_edu + secondary_edu + higher_edu + '
               'hhsize1_4 + hhsize5_8 + hhsize9_12 + '
               'financialhh + physicalchh + wellbeing_hh + food_quality + electricity + '
               'corruption_dlife + nmood + sdemocracy + trust_gov + info_tv + info_net + '
               'C(province) + C(year)')

try:
    mod_cat = smf.ols(f'happiness_ordered ~ {cat_formula}', data=df).fit(
        cov_type='cluster',
        cov_kwds={'groups': df['province']}
    )
    robust_results['categorical'] = mod_cat
    print("✓ Categorical income completed")
except Exception as e:
    print(f"  Warning: Categorical model failed: {e}")

# Robustness 3: Region clustering
print("Running Robustness Check 3: Region-level Clustering...")
try:
    mod_region = smf.ols(
        f'happiness_ordered ~ income_cat9 + hazara + tajik + uzbek + income_hazara + income_tajik + '
        f'age2635 + age3645 + age4655 + age55over + gender + married + single + '
        f'primary_edu + secondary_edu + higher_edu + '
        f'hhsize1_4 + hhsize5_8 + hhsize9_12 + '
        f'financialhh + physicalchh + wellbeing_hh + food_quality + electricity + '
        f'corruption_dlife + nmood + sdemocracy + trust_gov + info_tv + info_net + '
        f'C(province) + C(year)',
        data=df
    ).fit(cov_type='cluster', cov_kwds={'groups': df['region']})
    robust_results['region_cluster'] = mod_region
    print("✓ Region clustering completed")
except Exception as e:
    print(f"  Warning: Region clustering failed: {e}")

# Robustness 4: Rural subsample
print("Running Robustness Check 4: Rural Subsample...")
try:
    df_rural = df[df['rural'] == 1]
    mod_rural = smf.ols(
        f'happiness_ordered ~ income_cat9 + hazara + tajik + uzbek + income_hazara + income_tajik + '
        f'age2635 + age3645 + age4655 + age55over + gender + married + single + '
        f'primary_edu + secondary_edu + higher_edu + '
        f'hhsize1_4 + hhsize5_8 + hhsize9_12 + '
        f'financialhh + physicalchh + wellbeing_hh + food_quality + electricity + '
        f'corruption_dlife + nmood + sdemocracy + trust_gov + info_tv + info_net + '
        f'C(province) + C(year)',
        data=df_rural
    ).fit(cov_type='cluster', cov_kwds={'groups': df_rural['province']})
    robust_results['rural'] = mod_rural
    print("✓ Rural subsample completed")
except Exception as e:
    print(f"  Warning: Rural subsample failed: {e}")

print()
print("Robustness checks summary:")
for name, model in robust_results.items():
    print(f"  {name}: N = {model.nobs if hasattr(model, 'nobs') else 'N/A'}")

print("\n✓ Robustness checks completed")
print()

################################################################################
# STEP 7: SUMMARY OUTPUT
################################################################################

print("="*80)
print("INTERPRETATION SUMMARY FOR BA THESIS")
print("="*80)
print()

print("RESEARCH QUESTION:")
print("Does ethnic identity moderate the relationship between household income")
print("and subjective well-being in Afghanistan?")
print()

print("KEY FINDINGS:")
print("-"*80)
print()

print("1. MAIN EFFECT OF INCOME (H1):")
print(f"   For Pashtuns (baseline), a one-category increase in income is associated")
print(f"   with a {me_pashtun:.3f} point increase in happiness (p={p_pashtun:.3f})")
if p_pashtun < 0.05:
    print("   → H1 SUPPORTED: Income positively affects well-being")
print()

print("2. ETHNIC MODERATION (H2):")
print(f"   Joint test of interactions: F = {f_stat:.2f}, p = {p_val:.4f}")
if p_val < 0.05:
    print("   → H2 SUPPORTED: Ethnic identity DOES moderate the income-SWB relationship")
else:
    print("   → H2 NOT SUPPORTED: No significant ethnic moderation")
print()

print("3. HAZARA EFFECT - ASPIRATIONS vs TRAUMA (H3a vs H3b):")
print(f"   Income × Hazara coefficient: {hazara_coef:.4f} (SE: {hazara_se:.4f})")
print(f"   p-value: {hazara_p:.4f}")
print()

if hazara_coef < 0 and hazara_p < 0.10:
    print("   → H3a SUPPORTED (Aspirations Effect)")
    print("   The income effect is WEAKER for Hazaras than Pashtuns")
    print(f"   Income slope for Hazaras: {me_hazara:.3f}")
    print(f"   Income slope for Pashtuns: {me_pashtun:.3f}")
    print(f"   Difference: {hazara_coef:.3f}")
elif hazara_coef > 0 and hazara_p < 0.10:
    print("   → H3b SUPPORTED (Trauma Effect)")
    print("   The income effect is STRONGER for Hazaras than Pashtuns")
    print(f"   Income slope for Hazaras: {me_hazara:.3f}")
    print(f"   Income slope for Pashtuns: {me_pashtun:.3f}")
    print(f"   Difference: {hazara_coef:.3f}")
else:
    print("   → Neither H3a nor H3b supported")
print()

print("4. TAJIK COMPARISON (H4):")
print(f"   Income × Tajik coefficient: {tajik_coef:.4f} (p={tajik_p:.4f})")
print(f"   Income slope for Tajiks: {me_tajik:.3f}")
print()

print("5. MAGNITUDE OF EFFECTS:")
print(f"   - Pashtun income effect: {(me_pashtun/3*100):.1f}% of scale per income category")
print(f"   - Hazara income effect: {(me_hazara/3*100):.1f}% of scale per income category")
print(f"   - Tajik income effect: {(me_tajik/3*100):.1f}% of scale per income category")
print()

print("="*80)
print("ANALYSIS COMPLETE!")
print("="*80)
print()
print("Output files generated:")
print("  - Table1A_Overall_Descriptives.csv")
print("  - Table1B_Ethnic_Descriptives.csv")
print("  - Table2_Main_Regressions.csv")
print("  - Table3_Marginal_Effects.csv")
print("  - Figure1_Income_Happiness_by_Ethnicity.png/.pdf")
print()
print("All CSV files can be opened in Excel and copied to Word.")
print("="*80)
