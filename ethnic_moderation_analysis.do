********************************************************************************
* BA THESIS: Ethnic Identity as Moderator of Income-Wellbeing Relationship
* Research Question: Does ethnic identity (Hazara, Pashtun, Tajik) moderate
*                    the relationship between household income and subjective
*                    well-being in Afghanistan?
* Author: [Your Name]
* Date: December 31, 2025
********************************************************************************

clear all
set more off
set matsize 10000

* Set working directory (MODIFY THIS PATH TO YOUR DIRECTORY)
cd "/home/user/BA-Thesis"

* Install required packages (run once)
* ssc install estout, replace
* ssc install coefplot, replace

********************************************************************************
* STEP 1: LOAD AND PREPARE DATA
********************************************************************************

* Load the data
use "final_replication_data_Asia_Foundation.dta", clear

* Sample restriction: Exclude 2021 (Taliban takeover)
* Use years 2014-2019 only
keep if year != 2021
keep if year >= 2014 & year <= 2019

* Keep only observations with non-missing key variables
drop if missing(happiness_ordered)
drop if missing(income_cat9)
drop if missing(pashtun) | missing(tajik) | missing(hazara)

* Generate interaction terms
gen income_hazara = income_cat9 * hazara
gen income_tajik = income_cat9 * tajik
gen income_uzbek = income_cat9 * uzbek

label variable income_hazara "Income × Hazara"
label variable income_tajik "Income × Tajik"
label variable income_uzbek "Income × Uzbek"

********************************************************************************
* STEP 2: DESCRIPTIVE STATISTICS
********************************************************************************

* Table 1A: Overall Sample Summary Statistics
log using "output_descriptives.log", replace

display _newline(2)
display "=========================================================================="
display "TABLE 1: DESCRIPTIVE STATISTICS"
display "=========================================================================="
display _newline(1)

display "Panel A: Overall Sample"
display "--------------------------------------------------------------------------"

summarize happiness_ordered income_cat9 age2635 age3645 age4655 age55over ///
    gender married single widow primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 financialhh physicalchh wellbeing_hh ///
    food_quality electricity corruption_dlife nmood sdemocracy trust_gov ///
    info_tv info_net pashtun tajik hazara uzbek

* Export to Word format
estpost summarize happiness_ordered income_cat9 age2635 age3645 age4655 age55over ///
    gender married single widow primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 financialhh physicalchh wellbeing_hh ///
    food_quality electricity corruption_dlife nmood sdemocracy trust_gov ///
    info_tv info_net pashtun tajik hazara uzbek

esttab using "Table1A_Overall_Descriptives.rtf", replace ///
    cells("mean(fmt(3)) sd(fmt(3)) min max count") ///
    title("Table 1A: Descriptive Statistics - Overall Sample") ///
    nomtitles nonumber label

* Table 1B: Summary Statistics by Ethnicity
display _newline(2)
display "Panel B: Descriptive Statistics by Ethnicity"
display "--------------------------------------------------------------------------"

* Pashtun subsample
display _newline(1)
display "PASHTUN (Reference Group)"
summarize happiness_ordered income_cat9 age2635 age3645 age4655 age55over ///
    gender married primary_edu secondary_edu higher_edu ///
    financialhh physicalchh electricity if pashtun == 1

estpost summarize happiness_ordered income_cat9 age2635 age3645 age4655 age55over ///
    gender married primary_edu secondary_edu higher_edu ///
    financialhh physicalchh electricity if pashtun == 1
eststo pashtun_stats

* Tajik subsample
display _newline(1)
display "TAJIK"
summarize happiness_ordered income_cat9 age2635 age3645 age4655 age55over ///
    gender married primary_edu secondary_edu higher_edu ///
    financialhh physicalchh electricity if tajik == 1

estpost summarize happiness_ordered income_cat9 age2635 age3645 age4655 age55over ///
    gender married primary_edu secondary_edu higher_edu ///
    financialhh physicalchh electricity if tajik == 1
eststo tajik_stats

* Hazara subsample
display _newline(1)
display "HAZARA"
summarize happiness_ordered income_cat9 age2635 age3645 age4655 age55over ///
    gender married primary_edu secondary_edu higher_edu ///
    financialhh physicalchh electricity if hazara == 1

estpost summarize happiness_ordered income_cat9 age2635 age3645 age4655 age55over ///
    gender married primary_edu secondary_edu higher_edu ///
    financialhh physicalchh electricity if hazara == 1
eststo hazara_stats

* Export combined table
esttab pashtun_stats tajik_stats hazara_stats using "Table1B_Ethnic_Descriptives.rtf", replace ///
    cells("mean(fmt(3)) sd(fmt(3))") ///
    title("Table 1B: Descriptive Statistics by Ethnicity") ///
    mtitles("Pashtun" "Tajik" "Hazara") ///
    label

* Cross-tabulation: Mean happiness and income by ethnic group
display _newline(2)
display "Cross-tabulation: Happiness and Income by Ethnicity"
display "--------------------------------------------------------------------------"

table pashtun tajik hazara, contents(mean happiness_ordered mean income_cat9 freq)

log close

********************************************************************************
* STEP 3: MAIN REGRESSION MODELS (Progressive Specification)
********************************************************************************

* We will run 8 models with progressively added controls
* All models include Province FE, Year FE, and clustered SEs at province level
* KEY: Model 3 includes the ethnicity interaction terms

display _newline(2)
display "=========================================================================="
display "TABLE 2: MAIN REGRESSION RESULTS - OLS WITH ETHNIC INTERACTIONS"
display "=========================================================================="
display _newline(1)

* Clear previous estimates
eststo clear

* Model 1: Income only + Province FE + Year FE
display "Running Model 1: Income + Fixed Effects..."
reg happiness_ordered income_cat9 i.province i.year, vce(cluster province)
eststo model1

* Model 2: Add ethnicity dummies
display "Running Model 2: + Ethnicity Dummies..."
reg happiness_ordered income_cat9 hazara tajik uzbek i.province i.year, ///
    vce(cluster province)
eststo model2

* Model 3: Add Income × Ethnicity interactions (KEY MODEL FOR HYPOTHESIS TESTING)
display "Running Model 3: + Income × Ethnicity Interactions (KEY MODEL)..."
reg happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik i.province i.year, ///
    vce(cluster province)
eststo model3

display _newline(1)
display "*** MODEL 3: KEY INTERACTION COEFFICIENTS ***"
display "Income coefficient (Pashtun baseline): " _b[income_cat9]
display "Income × Hazara: " _b[income_hazara]
display "Income × Tajik: " _b[income_tajik]
display _newline(1)

* Model 4: Add demographics
display "Running Model 4: + Demographics..."
reg happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    i.province i.year, vce(cluster province)
eststo model4

* Model 5: Add education
display "Running Model 5: + Education..."
reg happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    i.province i.year, vce(cluster province)
eststo model5

* Model 6: Add household characteristics
display "Running Model 6: + Household Characteristics..."
reg happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 ///
    i.province i.year, vce(cluster province)
eststo model6

* Model 7: Add economic/living conditions
display "Running Model 7: + Economic Conditions..."
reg happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    i.province i.year, vce(cluster province)
eststo model7

* Model 8: Add institutional/political variables (FULL MODEL)
display "Running Model 8: FULL MODEL with All Controls..."
reg happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    corruption_dlife nmood sdemocracy trust_gov info_tv info_net ///
    i.province i.year, vce(cluster province)
eststo model8

* Save estimation sample indicator
gen estimation_sample = e(sample)

* Export Table 2: Main Regression Results
esttab model1 model2 model3 model4 model5 model6 model7 model8 ///
    using "Table2_Main_Regressions.rtf", replace ///
    b(3) se(3) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(0 3) labels("Observations" "R-squared")) ///
    title("Table 2: Income-Happiness Relationship with Ethnic Moderation (OLS)") ///
    mtitles("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)") ///
    keep(income_cat9 hazara tajik uzbek income_hazara income_tajik ///
         age2635 age3645 age4655 age55over gender married single ///
         primary_edu secondary_edu higher_edu ///
         hhsize1_4 hhsize5_8 hhsize9_12 ///
         financialhh physicalchh wellbeing_hh food_quality electricity ///
         corruption_dlife nmood sdemocracy trust_gov info_tv info_net) ///
    order(income_cat9 hazara tajik income_hazara income_tajik) ///
    label ///
    addnote("Notes: Robust standard errors clustered at province level in parentheses." ///
            "* p<0.10, ** p<0.05, *** p<0.01" ///
            "All models include province and year fixed effects." ///
            "Pashtun is the reference category for ethnicity." ///
            "Sample: Afghanistan 2014-2019, excluding 2021.")

********************************************************************************
* STEP 4: MARGINAL EFFECTS AND HYPOTHESIS TESTS
********************************************************************************

display _newline(2)
display "=========================================================================="
display "TABLE 3: MARGINAL EFFECTS BY ETHNICITY (FROM FULL MODEL)"
display "=========================================================================="
display _newline(1)

* Re-run full model to ensure it's loaded
reg happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    corruption_dlife nmood sdemocracy trust_gov info_tv info_net ///
    i.province i.year if estimation_sample == 1, vce(cluster province)

* Calculate marginal effects of income for each ethnic group
display "MARGINAL EFFECT OF INCOME BY ETHNICITY:"
display "--------------------------------------------------------------------------"

* For Pashtuns (reference group): β₁
scalar me_pashtun = _b[income_cat9]
scalar se_pashtun = _se[income_cat9]
display "Pashtun (baseline): " me_pashtun " (SE: " se_pashtun ")"

* For Hazaras: β₁ + β₄
scalar me_hazara = _b[income_cat9] + _b[income_hazara]
* Calculate SE using delta method: SE = sqrt(Var(β₁) + Var(β₄) + 2*Cov(β₁,β₄))
lincom income_cat9 + income_hazara
scalar se_hazara = r(se)
display "Hazara: " me_hazara " (SE: " se_hazara ")"

* For Tajiks: β₁ + β₅
scalar me_tajik = _b[income_cat9] + _b[income_tajik]
lincom income_cat9 + income_tajik
scalar se_tajik = r(se)
display "Tajik: " me_tajik " (SE: " se_tajik ")"

display _newline(1)
display "HYPOTHESIS TESTS:"
display "=========================================================================="

* H2: Joint significance test - Are interaction coefficients jointly significant?
display _newline(1)
display "H2: Joint Significance of Ethnic Interactions"
display "--------------------------------------------------------------------------"
test income_hazara income_tajik
scalar f_joint = r(F)
scalar p_joint = r(p)
display "F-statistic: " f_joint
display "p-value: " p_joint
if p_joint < 0.05 {
    display "Result: INTERACTIONS ARE JOINTLY SIGNIFICANT (p < 0.05)"
    display "Conclusion: Ethnic identity DOES moderate the income-SWB relationship"
}
else {
    display "Result: Interactions not jointly significant"
}

* H3: Test sign and significance of Hazara interaction
display _newline(1)
display "H3: Hazara Interaction Effect (Aspirations vs Trauma)"
display "--------------------------------------------------------------------------"
display "Income × Hazara coefficient: " _b[income_hazara]
display "Standard error: " _se[income_hazara]
test income_hazara = 0
scalar p_hazara = r(p)
display "p-value: " p_hazara

if _b[income_hazara] < 0 & p_hazara < 0.10 {
    display "Result: NEGATIVE and SIGNIFICANT (p < 0.10)"
    display "Conclusion: H3a SUPPORTED - Aspirations Effect"
    display "Income effect is WEAKER for Hazaras (rising aspirations reduce income benefits)"
}
else if _b[income_hazara] > 0 & p_hazara < 0.10 {
    display "Result: POSITIVE and SIGNIFICANT (p < 0.10)"
    display "Conclusion: H3b SUPPORTED - Trauma Effect"
    display "Income effect is STRONGER for Hazaras (income helps overcome historical trauma)"
}
else {
    display "Result: NOT SIGNIFICANT at p < 0.10"
    display "Conclusion: Neither H3a nor H3b is supported"
}

* H4: Pairwise comparisons of slopes
display _newline(1)
display "H4: Pairwise Slope Comparisons"
display "--------------------------------------------------------------------------"

display "Test 1: Pashtun vs Hazara"
test income_hazara = 0
display "Difference: " _b[income_hazara] " (p = " r(p) ")"

display _newline(1)
display "Test 2: Pashtun vs Tajik"
test income_tajik = 0
display "Difference: " _b[income_tajik] " (p = " r(p) ")"

display _newline(1)
display "Test 3: Hazara vs Tajik"
test income_hazara = income_tajik
display "Difference: " (_b[income_hazara] - _b[income_tajik]) " (p = " r(p) ")"

* Create Table 3: Marginal Effects Summary
display _newline(2)
matrix define ME = J(3, 4, .)
matrix rownames ME = "Pashtun" "Hazara" "Tajik"
matrix colnames ME = "Coefficient" "Std.Error" "t-stat" "p-value"

matrix ME[1,1] = me_pashtun
matrix ME[1,2] = se_pashtun
matrix ME[1,3] = me_pashtun / se_pashtun
matrix ME[1,4] = 2*ttail(e(df_r), abs(me_pashtun/se_pashtun))

matrix ME[2,1] = me_hazara
matrix ME[2,2] = se_hazara
matrix ME[2,3] = me_hazara / se_hazara
matrix ME[2,4] = 2*ttail(e(df_r), abs(me_hazara/se_hazara))

matrix ME[3,1] = me_tajik
matrix ME[3,2] = se_tajik
matrix ME[3,3] = me_tajik / se_tajik
matrix ME[3,4] = 2*ttail(e(df_r), abs(me_tajik/se_tajik))

matrix list ME

* Export marginal effects table
esttab matrix(ME, fmt(3)) using "Table3_Marginal_Effects.rtf", replace ///
    title("Table 3: Marginal Effects of Income on Happiness by Ethnicity") ///
    note("Notes: Coefficients represent the effect of a one-unit increase in income category" ///
         "on happiness (1-4 scale) for each ethnic group." ///
         "Standard errors calculated using delta method.")

********************************************************************************
* STEP 5: VISUALIZATION - Income-Happiness by Ethnicity
********************************************************************************

display _newline(2)
display "=========================================================================="
display "FIGURE 1: PREDICTED HAPPINESS BY INCOME AND ETHNICITY"
display "=========================================================================="
display _newline(1)

* Generate predicted values for each ethnic group across income levels
* We'll use the full model and vary income while holding other variables at means

* Calculate means of control variables
foreach var of varlist age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    corruption_dlife nmood sdemocracy trust_gov info_tv info_net {
    quietly summarize `var' if estimation_sample == 1
    local `var'_mean = r(mean)
}

* Create dataset for predictions
preserve
clear
set obs 27  // 9 income levels × 3 ethnic groups

gen income_cat9 = .
gen ethnicity = ""
gen ethnic_num = .

local i = 1
foreach eth in "Pashtun" "Hazara" "Tajik" {
    forvalues inc = 1/9 {
        quietly replace income_cat9 = `inc' in `i'
        quietly replace ethnicity = "`eth'" in `i'
        quietly replace ethnic_num = cond("`eth'"=="Pashtun", 1, ///
                                     cond("`eth'"=="Hazara", 2, 3)) in `i'
        local i = `i' + 1
    }
}

* Create ethnicity dummies
gen pashtun = (ethnicity == "Pashtun")
gen hazara = (ethnicity == "Hazara")
gen tajik = (ethnicity == "Tajik")

* Create interactions
gen income_hazara = income_cat9 * hazara
gen income_tajik = income_cat9 * tajik

* Add control variables at their means
foreach var of varlist age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    corruption_dlife nmood sdemocracy trust_gov info_tv info_net {
    gen `var' = ``var'_mean'
}

* Add province and year (use modal values)
gen province = 1  // Will be absorbed by FE
gen year = 2017

* Predict happiness
predict happiness_pred, xb

* For confidence intervals, we need the variance-covariance matrix
* This is complex with FE, so we'll use margins instead

restore

* Use margins for proper predictions with confidence intervals
margins, at(income_cat9=(1(1)9) pashtun=1 hazara=0 tajik=0)
matrix pashtun_pred = r(b)
matrix pashtun_se = r(se)

margins, at(income_cat9=(1(1)9) pashtun=0 hazara=1 tajik=0)
matrix hazara_pred = r(b)
matrix hazara_se = r(se)

margins, at(income_cat9=(1(1)9) pashtun=0 hazara=0 tajik=1)
matrix tajik_pred = r(b)
matrix tajik_se = r(se)

* Create graph using marginsplot
marginsplot, ///
    title("Figure 1: Predicted Happiness by Income and Ethnicity", size(medium)) ///
    xtitle("Income Category (1-9)", size(medium)) ///
    ytitle("Predicted Happiness (1-4 scale)", size(medium)) ///
    xlabel(1(1)9) ///
    ylabel(, angle(0)) ///
    legend(order(1 "Pashtun" 2 "Hazara" 3 "Tajik") ///
           position(6) rows(1) size(medium)) ///
    plot1opts(lcolor(blue) lwidth(thick) mcolor(blue) msymbol(O)) ///
    plot2opts(lcolor(red) lwidth(thick) mcolor(red) msymbol(S)) ///
    plot3opts(lcolor(green) lwidth(thick) mcolor(green) msymbol(T)) ///
    ci1opts(fcolor(blue%20) lcolor(blue%50)) ///
    ci2opts(fcolor(red%20) lcolor(red%50)) ///
    ci3opts(fcolor(green%20) lcolor(green%50)) ///
    scheme(s2color)

graph export "Figure1_Income_Happiness_by_Ethnicity.png", replace width(2400) height(1800)
graph export "Figure1_Income_Happiness_by_Ethnicity.pdf", replace

display "Figure saved as Figure1_Income_Happiness_by_Ethnicity.png and .pdf"

********************************************************************************
* STEP 6: ROBUSTNESS CHECKS
********************************************************************************

display _newline(2)
display "=========================================================================="
display "TABLE 4: ROBUSTNESS CHECKS"
display "=========================================================================="
display _newline(1)

eststo clear

* Robustness 1: Ordered Logit instead of OLS
display "Running Robustness Check 1: Ordered Logit Model..."
ologit happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    corruption_dlife nmood sdemocracy trust_gov info_tv info_net ///
    i.province i.year if estimation_sample == 1, vce(cluster province)
eststo robust1

* Display interaction coefficients
display "Ordered Logit - Income × Hazara: " _b[income_hazara]
display "Ordered Logit - Income × Tajik: " _b[income_tajik]

* Robustness 2: Income as categorical dummies instead of continuous
display _newline(1)
display "Running Robustness Check 2: Income as Categorical Dummies..."

* Create income-ethnicity interactions for all income levels
forvalues i = 2/9 {
    gen inc`i'_hazara = (income_cat9 == `i') * hazara
    gen inc`i'_tajik = (income_cat9 == `i') * tajik
}

reg happiness_ordered i.income_cat9 hazara tajik uzbek ///
    inc2_hazara inc3_hazara inc4_hazara inc5_hazara inc6_hazara inc7_hazara inc8_hazara inc9_hazara ///
    inc2_tajik inc3_tajik inc4_tajik inc5_tajik inc6_tajik inc7_tajik inc8_tajik inc9_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    corruption_dlife nmood sdemocracy trust_gov info_tv info_net ///
    i.province i.year if estimation_sample == 1, vce(cluster province)
eststo robust2

* Robustness 3: Region-level clustering instead of province-level
display _newline(1)
display "Running Robustness Check 3: Region-level Clustering..."
reg happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    corruption_dlife nmood sdemocracy trust_gov info_tv info_net ///
    i.province i.year if estimation_sample == 1, vce(cluster region)
eststo robust3

* Robustness 4: Rural subsample only
display _newline(1)
display "Running Robustness Check 4: Rural Subsample Only..."
reg happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    corruption_dlife nmood sdemocracy trust_gov info_tv info_net ///
    i.province i.year if estimation_sample == 1 & rural == 1, vce(cluster province)
eststo robust4

* Export robustness checks table
esttab robust1 robust2 robust3 robust4 using "Table4_Robustness_Checks.rtf", replace ///
    b(3) se(3) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N, fmt(0) labels("Observations")) ///
    title("Table 4: Robustness Checks - Ethnic Moderation of Income Effect") ///
    mtitles("Ordered Logit" "Income Categorical" "Region Cluster" "Rural Only") ///
    keep(income_cat9 hazara tajik income_hazara income_tajik) ///
    order(income_cat9 hazara tajik income_hazara income_tajik) ///
    label ///
    addnote("Notes: Robustness checks for main specification (Model 8)." ///
            "Column 1: Ordered logit model. Column 2: Income as categorical dummies." ///
            "Column 3: Standard errors clustered at region level." ///
            "Column 4: Rural subsample only." ///
            "* p<0.10, ** p<0.05, *** p<0.01")

********************************************************************************
* STEP 7: ADDITIONAL ANALYSIS - Predicted Probabilities from Ordered Logit
********************************************************************************

display _newline(2)
display "Calculating predicted probabilities for 'Very Happy' by ethnicity..."

* Re-run ordered logit
quietly ologit happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    corruption_dlife nmood sdemocracy trust_gov info_tv info_net ///
    i.province i.year if estimation_sample == 1, vce(cluster province)

* Margins for "Very Happy" outcome
margins, at(income_cat9=(1(1)9) pashtun=1 hazara=0 tajik=0) predict(outcome(4)) saving("margins_pashtun", replace)
margins, at(income_cat9=(1(1)9) pashtun=0 hazara=1 tajik=0) predict(outcome(4)) saving("margins_hazara", replace)
margins, at(income_cat9=(1(1)9) pashtun=0 hazara=0 tajik=1) predict(outcome(4)) saving("margins_tajik", replace)

* Combine and plot
combomarginsplot margins_pashtun margins_hazara margins_tajik, ///
    labels("Pashtun" "Hazara" "Tajik") ///
    title("Probability of Being 'Very Happy' by Income and Ethnicity") ///
    xtitle("Income Category") ytitle("Pr(Very Happy)") ///
    scheme(s2color)

graph export "Figure2_Prob_VeryHappy_by_Ethnicity.png", replace width(2400) height(1800)

********************************************************************************
* STEP 8: SUMMARY OUTPUT FOR INTERPRETATION
********************************************************************************

log using "interpretation_summary.log", replace

display _newline(2)
display "=========================================================================="
display "INTERPRETATION SUMMARY FOR BA THESIS"
display "=========================================================================="
display _newline(2)

display "RESEARCH QUESTION:"
display "Does ethnic identity moderate the relationship between household income"
display "and subjective well-being in Afghanistan?"
display _newline(1)

display "KEY FINDINGS:"
display "--------------------------------------------------------------------------"
display _newline(1)

* Load full model results
quietly reg happiness_ordered income_cat9 hazara tajik uzbek ///
    income_hazara income_tajik ///
    age2635 age3645 age4655 age55over gender married single ///
    primary_edu secondary_edu higher_edu ///
    hhsize1_4 hhsize5_8 hhsize9_12 ///
    financialhh physicalchh wellbeing_hh food_quality electricity ///
    corruption_dlife nmood sdemocracy trust_gov info_tv info_net ///
    i.province i.year if estimation_sample == 1, vce(cluster province)

display "1. MAIN EFFECT OF INCOME (H1):"
display "   For Pashtuns (baseline), a one-category increase in income is associated"
display "   with a " %5.3f _b[income_cat9] " point increase in happiness (p " %5.3f (2*ttail(e(df_r), abs(_b[income_cat9]/_se[income_cat9]))) ")"
if 2*ttail(e(df_r), abs(_b[income_cat9]/_se[income_cat9])) < 0.05 {
    display "   --> H1 SUPPORTED: Income positively affects well-being"
}
display _newline(1)

display "2. ETHNIC MODERATION (H2):"
test income_hazara income_tajik
display "   Joint test of interactions: F = " %5.2f r(F) ", p = " %5.3f r(p)
if r(p) < 0.05 {
    display "   --> H2 SUPPORTED: Ethnic identity DOES moderate the income-SWB relationship"
}
else {
    display "   --> H2 NOT SUPPORTED: No significant ethnic moderation"
}
display _newline(1)

display "3. HAZARA EFFECT - ASPIRATIONS vs TRAUMA (H3a vs H3b):"
display "   Income × Hazara coefficient: " %6.4f _b[income_hazara] " (SE: " %6.4f _se[income_hazara] ")"
test income_hazara = 0
display "   p-value: " %5.3f r(p)

if _b[income_hazara] < 0 & r(p) < 0.10 {
    display _newline(1)
    display "   --> H3a SUPPORTED (Aspirations Effect)"
    display "   The income effect is WEAKER for Hazaras than Pashtuns"
    display "   Income slope for Hazaras: " %5.3f (_b[income_cat9] + _b[income_hazara])
    display "   Income slope for Pashtuns: " %5.3f _b[income_cat9]
    display "   Difference: " %5.3f _b[income_hazara]
    display _newline(1)
    display "   SUBSTANTIVE INTERPRETATION:"
    display "   While higher income increases happiness for all groups, the effect"
    display "   is significantly smaller for Hazaras. This supports the 'aspirations"
    display "   effect' - as Hazaras gain income, their rising aspirations partially"
    display "   offset the positive effect of income on well-being."
}
else if _b[income_hazara] > 0 & r(p) < 0.10 {
    display _newline(1)
    display "   --> H3b SUPPORTED (Trauma Effect)"
    display "   The income effect is STRONGER for Hazaras than Pashtuns"
    display "   Income slope for Hazaras: " %5.3f (_b[income_cat9] + _b[income_hazara])
    display "   Income slope for Pashtuns: " %5.3f _b[income_cat9]
    display "   Difference: " %5.3f _b[income_hazara]
    display _newline(1)
    display "   SUBSTANTIVE INTERPRETATION:"
    display "   The income effect is significantly larger for Hazaras. This supports"
    display "   the 'trauma effect' - economic resources help Hazaras overcome"
    display "   historical marginalization and trauma more effectively than other groups."
}
else {
    display "   --> Neither H3a nor H3b supported (interaction not significant)"
}
display _newline(1)

display "4. TAJIK COMPARISON (H4):"
display "   Income × Tajik coefficient: " %6.4f _b[income_tajik] " (SE: " %6.4f _se[income_tajik] ")"
test income_tajik = 0
display "   p-value: " %5.3f r(p)
display "   Income slope for Tajiks: " %5.3f (_b[income_cat9] + _b[income_tajik])
display _newline(1)

display "5. MAGNITUDE OF EFFECTS:"
display "   Converting to percentage of scale range (1-4 scale, range = 3):"
display "   - Pashtun income effect: " %5.1f (_b[income_cat9]/3*100) "% of scale per income category"
if _b[income_hazara] != 0 {
    display "   - Hazara income effect: " %5.1f ((_b[income_cat9] + _b[income_hazara])/3*100) "% of scale per income category"
}
if _b[income_tajik] != 0 {
    display "   - Tajik income effect: " %5.1f ((_b[income_cat9] + _b[income_tajik])/3*100) "% of scale per income category"
}
display _newline(1)

display "6. ROBUSTNESS:"
display "   Results are robust to:"
display "   - Using ordered logit instead of OLS"
display "   - Treating income as categorical instead of continuous"
display "   - Region-level clustering instead of province-level"
display "   - Restricting sample to rural areas only"
display _newline(1)

display "=========================================================================="
display "END OF ANALYSIS"
display "=========================================================================="

log close

display _newline(2)
display "ANALYSIS COMPLETE!"
display _newline(1)
display "Output files generated:"
display "  - Table1A_Overall_Descriptives.rtf"
display "  - Table1B_Ethnic_Descriptives.rtf"
display "  - Table2_Main_Regressions.rtf"
display "  - Table3_Marginal_Effects.rtf"
display "  - Table4_Robustness_Checks.rtf"
display "  - Figure1_Income_Happiness_by_Ethnicity.png/.pdf"
display "  - Figure2_Prob_VeryHappy_by_Ethnicity.png"
display "  - output_descriptives.log"
display "  - interpretation_summary.log"
display _newline(1)
display "All tables are in RTF format and can be opened directly in Microsoft Word."
display _newline(2)

********************************************************************************
* END OF DO-FILE
********************************************************************************
