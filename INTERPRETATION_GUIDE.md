# Quick Interpretation Guide for Your BA Thesis Results

## What to Look For When You Run the Analysis

---

## STEP 1: Check Your Sample Size

After running the code, look for:
```
After excluding 2021: N = XXXX
After keeping 2014-2019: N = XXXX
Final sample: N = XXXX
```

**What you need**: At least 5,000-10,000 observations for reliable results

---

## STEP 2: Main Results (Table 2, Model 8)

### Key Coefficients to Examine

#### 1. **income_cat9** (Main Effect for Pashtuns)
- **Expected**: Positive and significant
- **Example**: 0.125*** (0.032)
- **Interpretation**: "For Pashtuns (baseline), a one-category increase in income is associated with a 0.125-point increase in happiness on a 1-4 scale (p < 0.01)"

#### 2. **income_hazara** (The Critical Interaction!)
This is your **MAIN FINDING** for H3a vs H3b!

**If NEGATIVE and significant** (e.g., -0.045**):
✅ **H3a SUPPORTED (Aspirations Effect)**
- The income effect is WEAKER for Hazaras
- Rising aspirations partially offset income benefits
- Write in thesis: "This supports the aspirations hypothesis (H3a). Despite income gains, Hazaras' rising aspirations dampen the positive effects on well-being."

**If POSITIVE and significant** (e.g., +0.038*):
✅ **H3b SUPPORTED (Trauma Effect)**
- The income effect is STRONGER for Hazaras
- Income helps overcome historical trauma
- Write in thesis: "This supports the trauma hypothesis (H3b). Economic resources enable Hazaras to overcome marginalization more effectively than other groups."

**If NOT significant** (e.g., -0.012, p=0.45):
❌ **Neither H3a nor H3b supported**
- No ethnic moderation for Hazaras
- Write in thesis: "The relationship between income and well-being does not differ significantly between Hazaras and Pashtuns, suggesting universal economic mechanisms."

#### 3. **income_tajik** (Tajik Interaction)
- **Expected**: Somewhere between 0 and Hazara coefficient
- **Example**: -0.022 (not significant)
- **Interpretation**: Focus less on this unless it's significant

---

## STEP 3: Hypothesis Testing Summary

Look for these test results in the output:

### H1: Income Effect (Main Effect)
**Where to find**: Model 1, coefficient on `income_cat9`
- ✅ **Supported** if positive and p < 0.05
- **Write**: "Income positively affects subjective well-being (H1 supported)"

### H2: Ethnic Moderation (Joint Test)
**Where to find**: After Model 8, "Joint significance test"
```
F-statistic: 3.45
p-value: 0.032
```
- ✅ **Supported** if p < 0.05
- **Write**: "Ethnic identity significantly moderates the income-well-being relationship (H2 supported, F=3.45, p=0.032)"

### H3a vs H3b: Which Mechanism?
**Where to find**: Coefficient on `income_hazara` in Model 8

| Coefficient | Significance | Conclusion |
|------------|--------------|------------|
| β < 0 | p < 0.10 | **H3a supported** (Aspirations) |
| β > 0 | p < 0.10 | **H3b supported** (Trauma) |
| Any | p > 0.10 | Neither supported |

### H4: Tajik Positioning
**Where to find**: Pairwise comparison tests
- Check if Tajik slope falls between Hazara and Pashtun

---

## STEP 4: Marginal Effects (Table 3)

This table shows the **actual income slopes** for each group.

### Example Output:
```
           Coefficient  Std.Error  p-value
Pashtun       0.125      0.032     0.001
Hazara        0.080      0.041     0.052
Tajik         0.103      0.036     0.004
```

### How to Interpret:

**Magnitude**:
- 0.125 on a 1-4 scale (range=3) = **4.2% of scale** per income category
- Over 8 income categories (low to high) = **34% of scale** = **1 full point**

**Substantive Interpretation Template**:
> "Moving from the lowest to highest income category is associated with a 1.0-point increase in happiness for Pashtuns (0.125 × 8 = 1.0), compared to only 0.64 points for Hazaras (0.080 × 8 = 0.64)—a difference of 0.36 points, or 12% of the happiness scale."

---

## STEP 5: Statistical Significance

### P-value Guide:
- **p < 0.01** (***): Very strong evidence (less than 1% chance of random occurrence)
- **p < 0.05** (**): Strong evidence (less than 5% chance)
- **p < 0.10** (*): Moderate evidence (less than 10% chance)
- **p > 0.10**: Not statistically significant (could be random)

### What to Report:
- Always report: coefficient, standard error, p-value
- Example: "β = 0.125, SE = 0.032, p < 0.001"

---

## STEP 6: Effect Sizes (Is This Meaningful?)

### Small, Medium, or Large Effect?

For a 1-4 scale (range = 3):
- **Small effect**: 0.05-0.10 (2-3% of scale)
- **Medium effect**: 0.10-0.20 (3-7% of scale)
- **Large effect**: >0.20 (>7% of scale)

### Contextualize:
Compare your income effect to other variables in the model:
- Is income more important than education?
- Is the ethnic difference (interaction) large relative to the main effect?

---

## STEP 7: Robustness Checks (Table 4)

Look for **consistency** across specifications:

| Check | Purpose | What to Look For |
|-------|---------|------------------|
| Ordered Logit | Different model | Same sign and significance of interactions |
| Income Categorical | Functional form | Consistent pattern across income levels |
| Region Clustering | Alternative SEs | Interactions still significant |
| Rural Subsample | Heterogeneity | Effects hold in rural areas |

**Good news**: If your key results (income_hazara coefficient) have the same **sign** and are **still significant** in most checks, your findings are robust!

**Warning sign**: If results flip signs or lose significance, discuss this honestly in limitations.

---

## STEP 8: Figure 1 (Visual Interpretation)

Your graph should show 3 lines (Pashtun, Hazara, Tajik) going from left (low income) to right (high income).

### What to Look For:

**H3a Supported (Aspirations)**:
```
Happiness ↑
    │     Pashtun (steeper) ──────────────
    │     Tajik (middle) ─────────────
    │     Hazara (flatter) ────────────
    │
    └────────────────────────────► Income
```
- Hazara line has the **smallest slope** (flattest)
- Lines should **NOT cross** (parallel or diverging)

**H3b Supported (Trauma)**:
```
Happiness ↑
    │     Hazara (steepest) ──────────────
    │     Tajik (middle) ─────────────
    │     Pashtun (flatter) ────────────
    │
    └────────────────────────────► Income
```
- Hazara line has the **largest slope** (steepest)
- Lines should **diverge** (Hazaras benefit more from income)

**No Moderation**:
```
Happiness ↑
    │     ───────────── (all lines parallel)
    │     ─────────────
    │     ─────────────
    │
    └────────────────────────────► Income
```
- All three lines have the **same slope**
- Lines are **parallel** (same income effect for all groups)

---

## STEP 9: Writing Your Results Section

### Template Paragraph 1: Main Effect
> "Table 2 presents the results of eight OLS regression models examining the relationship between household income and subjective well-being. Model 1 shows that income has a positive and statistically significant effect on happiness (β = 0.XXX, p < 0.01), supporting H1. This relationship remains robust across all specifications, including the full model (Model 8) which controls for demographics, education, household characteristics, economic conditions, and institutional variables (β = 0.XXX, p < 0.01)."

### Template Paragraph 2: Ethnic Moderation (H3a Supported)
> "The key finding of this study is the significant moderation effect of Hazara ethnicity on the income-well-being relationship (Model 3 onwards). The interaction term Income × Hazara is negative and statistically significant in the full model (β = -0.XXX, p < 0.05), indicating that the positive effect of income on happiness is significantly weaker for Hazaras compared to Pashtuns. Table 3 presents the marginal effects: for Pashtuns, a one-category increase in income is associated with a 0.XXX-point increase in happiness, compared to only 0.XXX for Hazaras—a difference of 0.XXX points. This supports the aspirations hypothesis (H3a) over the trauma hypothesis (H3b). Figure 1 visualizes this pattern, showing that while all ethnic groups benefit from higher income, the slope is notably flatter for Hazaras."

### Template Paragraph 3: Joint Significance
> "A joint significance test confirms that ethnic identity significantly moderates the income-well-being relationship (F = X.XX, p < 0.05), supporting H2. The Tajik interaction term is [significant/not significant], suggesting that [interpretation based on your results]."

### Template Paragraph 4: Robustness
> "Table 4 presents robustness checks using alternative specifications. The key finding—that the income effect is weaker for Hazaras—remains consistent across ordered logit estimation (Column 1), treating income as categorical rather than continuous (Column 2), using region-level clustering (Column 3), and restricting the sample to rural areas (Column 4). This consistency strengthens confidence in the main results."

---

## STEP 10: Common Issues and Solutions

### Issue 1: Huge standard errors
**Cause**: Too few clusters or multicollinearity
**Solution**:
- Check N of provinces/clusters
- Remove highly correlated controls
- Consider region-level clustering

### Issue 2: Interactions not significant
**Possible reasons**:
- True null effect (no ethnic moderation)
- Insufficient statistical power (need more observations)
- Misspecification (try ordered logit)

**What to write**: Report honestly, discuss in limitations

### Issue 3: Unexpected sign
**Example**: You expected negative (H3a) but got positive (H3b)
**What to do**:
- Check data coding
- If correct, report honestly and discuss mechanisms
- This is still a valid finding!

### Issue 4: Results change across models
**What to check**:
- Is sample size changing? (due to missing controls)
- Are there important confounders?
- Focus on the most comprehensive model (Model 8)

---

## Final Checklist Before Writing

- [ ] I understand which hypothesis (H3a or H3b) is supported by my results
- [ ] I can explain the substantive meaning of my coefficients (not just "significant")
- [ ] I have calculated effect sizes and can comment on practical significance
- [ ] I have checked robustness and know if results are stable
- [ ] I can interpret Figure 1 and it matches my regression results
- [ ] I know my sample size and can describe sample composition
- [ ] I understand the limitations of my analysis

---

## Quick Reference: What Makes a Strong Thesis?

### ✅ DO:
- Report exact p-values (not just "p < 0.05")
- Discuss substantive significance, not just statistical
- Be transparent about non-significant results
- Acknowledge limitations
- Interpret coefficients in real-world terms
- Use figures to illustrate key findings

### ❌ DON'T:
- Cherry-pick significant results
- Over-interpret weak effects (p=0.09 with tiny coefficient)
- Claim causality from cross-sectional data
- Ignore robustness checks that contradict main results
- Use jargon without explanation

---

## Need Help Interpreting?

Common questions:

**Q: My interaction is significant but small (β = -0.02). Does this matter?**
A: Compare to the main effect. If the main effect is 0.12 and interaction is -0.02, that's a 17% reduction—potentially meaningful!

**Q: What if H2 is not supported (no ethnic moderation)?**
A: This is a valid finding! It suggests universal mechanisms. Discuss why this might be.

**Q: Should I focus on Model 3 or Model 8?**
A: Model 8 (full controls) is preferred for causal inference, but show progression from Model 3 to demonstrate robustness.

**Q: What if Stata/Python gives different results?**
A: Small differences are normal (rounding, optimization). Large differences suggest a coding error—check carefully.

---

Good luck with your analysis! 🎓

**Remember**: Your thesis is a contribution to knowledge whether you find support for H3a, H3b, or neither. What matters is rigorous analysis and honest interpretation.
