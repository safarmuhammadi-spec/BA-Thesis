* Replication 07.August 2025

use "C:\Users\Asadi\Documents\Replication of first paper Income and SWB_STATA.dta", clear 


*Start
*===============================================================================
**# Original Variables

*m1 z47 x15b x4 x16 x21 x82 x14a x14d x14h x14e x14g x14f m4 m5 m6b m7 m8 z1 z2 z6 z9 z10 z11 z55 x37b income_cat x25a x153a x153b x153c x153f 

* Recoded variables list 

*happiness_ordered happiness4 income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov no_edu primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age1825 age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 hhsize_over single married widow gender pashtun tajik uzbek hazara turkmen electricity info_tv info_net province year 

save final_replication_data.dta, replace

**#Recoded Variables

sum m1 if m1 == 1 // identifier = individual is m1 (for each respondent)
gen person_id = m1

* time identifier is m8 ( for each wave of interviews)
gen wave_id = m8

*Happiness = SWB = Life Satisfaction = z47
*orginal var: 1 = very happy 2= somwhat happy 3 = not very happy 4 = not at all happy
*change to happiness_ordered as follows: 
* 1= Not at all happy
* 2 = not very happy
* 3 = somwhat happy
* 4 = very happy 
recode z47(1 = 4) (2 = 3) (3 = 2) ( 4 = 1) (98 99 = .), gen(happiness_ordered)
fre happiness_ordered
sum happiness_ordered

* Happiness_cat3
recode z47(4 = 1) (3 2 = 2) (1 = 3) (98 99 = .), gen(happiness_cat3)
sum happiness_cat3
fre happiness_cat3

* recode z47 for happiness_cat
recode z47 (4 3 = 1) ( 2 = 2) (1 = 3) (98 99 =.), gen(happines_cat)
sum happines_cat
fre happiness_cat

*recode happiness refer to the revision refree 1

*Models binary SWB (0: happiness 1–3, 1: happiness 4) to test the referee's concern about happiness 1–3 vs. 4 grouping (Comment 8).

recode z47 (1 = 1) (2 3 4 = 0) (98 99 =.), gen(happiness4)
sum happiness4
fre happiness4
********************************************************************************

*Fear variable
* 1 = Never fear 2= rarely fear, 3= sometimes fear, 4 often fear
fre x15b 
recode x15 (4 = 1) (3 = 2) (2 = 3) (1 = 4) (8 9 = .), gen(fear0612)
fre fear0612

* this x15b recoded in questionnary in from 2015.
recode x15b (5 = 1) (4 = 2) (3 = 3) (1 2 = 4) (98 99 = .), gen(fear1321)
fre fear1321
sum fear0612
sum fear1321
fre fear0612
fre fear1321
* combine the two binary fear variables
gen fear = .
replace fear = 1 if fear0612 == 1
replace fear = 2 if fear0612 == 2
replace fear = 3 if fear0612 == 3
replace fear = 4 if fear0612 == 4
replace fear = 1 if fear1321 == 1
replace fear = 2 if fear1321 == 2
replace fear = 3 if fear1321 == 3
replace fear = 4 if fear1321 == 4

**recode fear
recode fear (4 = 1) (1 2 3 = 0), gen(fear1)
recode fear (3 = 1) (1 2 4 = 0), gen(fear2)
recode fear (1 2 = 1) (3 4 = 0), gen(fear3)
sum fear1 fear2 fear3
fre fear1 fear2 fear3

* label variable fear
fre fear
sum fear
*end fear categorical
*********************************************
*recode fear to binary
recode fear (1 2 = 0) (3 4 = 1), gen(fearbinary)
label define fear_lbl 1 "Never" 2 "rarely" 3 "Sometimes" 4 "Often"
label values fear fear_lbl
fre fear
********************************************************************************
* check for victim of volience and crime rate
fre 
recode x16 (101 = 1) ( 102 = 0) (998 999 = .), gen (vovc)
fre vovc
sum vovc
* end 

* national mood the code is x4
* Afghanistan is going on the right direction or wrong direction. 0 = Wrong, 1 = Right.
fre x4
recode x4 (101 = 1) (102 = 0) (103 998 999 = .), gen (nmood)

* satisfaction from democracy:  1 = very dissatisfied, 2 = somewhat dissatisfied, 3 =  somewhat satisfied, 4 = very satisfied.
fre x82
recode x82 (104 = 1) (103 = 2) (102 = 3) (101 = 4) (998 999 = .), gen(sdemocracy)
fre sdemocracy

* trust to the government 1 = No trust, 2 = a little trust, 3 = Some trust, 4 = a lot of trust.
fre x21

* Household financial situation. 1 = worse, 2 = the same, 3 = better. 
fre x14a
recode x14a (3 = 1) (2  = 2) (1 = 3) (8 9 = .), gen(financialhh)
fre financialhh

* Access to schools quality of school services: 1 = worse, 2 = the same, 3 = better.
recode x14h (3 = 1) (2 = 2) ( 1 = 3) (8 9 = .), gen(qualitysch)
sum qualitysch
fre qualitysch

* Physical condition of the household and dwelling. 1 = worse, 2 = the same, 3 = better
fre x14e
recode x14e (3 = 1) (2 = 2) ( 1 = 3) (8 9 = .), gen(physicalchh)
fre physicalchh

* electricity access
recode x14g (3 = 1) (2 = 2) ( 1 = 3) (8 9 = .), gen(electricity)
sum electricity
fre electricity

* Health well-being of the Household. 1 = worse, 2 = the same, 3 = better.
recode x14f (3 = 1) (2 = 2) ( 1 = 3) (8 9 = .), gen(wellbeing_hh)
sum wellbeing_hh
fre wellbeing_hh

* satisfaction of government
* 0= very dissatisfied, 1 =  somewhat dissatisfied , 2=  somewhat satisfied, 3 = very satisfied
recode x37b (104 = 1) (103 = 2) (102 = 3) (101 = 3) (998 999 = .), gen (sgovernment) 
fre sgovernment

* Quality of food and diet of the household. 1 = worse, 2 = the same, 3 = better.
recode x14d (3 = 1) (2 = 2) ( 1 = 3) (8 9 = .), gen(food_quality)
sum food_quality
fre food_quality

recode income_cat to income_cat9
recode income_cat (98 99 =.), gen(income_cat9)
*end
recode income_cat (1 2 3 4 = 1) (5 6 = 2) (7 8 9 = 3) (98 99 =.), gen(income_cat3) // with this one income_cat3 Obs: 55,694
fre income_cat3
sum income_cat3
*Income_binary
recode income_cat (1 2 3 4 5 = 0) (6 7 8 9 = 1) (98 99 =.), gen(income_binary)
fre income_binary
sum income_binary
****end

recode x25a (101 102 103 = 1) (104 = 0) (105 998 999 =.), gen(corruption_exp)
fre x25a
fre corruption_exp

** #control variables recoded

* age: of the interviewee = z2 = age_cont
fre z2
fre age_cont
sum age_cont

* Age categorical variables are exist
fre age // 1 = 18 to 25, 2 = 26 to 35, 3 = 36 to 45, 4 = 46 to 55 and 5 = above
sum age
* age square 
gen age2=age_cont^2

**start
gen age_contsq = age_cont^2
*end 
* age levels
fre age
recode age (1 = 1) (2 3 4 5 = 0), gen(age1825)
recode age (2 = 1) (1 3 4 5 = 0), gen(age2635)
recode age (3 = 1) (1 2 4 5 = 0), gen(age3645)
recode age (4 = 1) (1 2 3 5 = 0), gen(age4655)
recode age (5 = 1) (1 2 3 4 = 0), gen(age55over)

* education Levels 

fre edu // edu has all waves. 2006 to 2021

recode edu (1 = 1) (2 3 4 5 = 0) (97 98 99 = .), gen(edu_no)
recode edu (2 = 1) (1 3 4 5 = 0) (97 98 99 = .), gen(edu_primary)
recode edu (3 = 1) (1 2 4 5 = 0) (97 98 99 = .), gen(edu_secondary)
recode edu (4 5 = 1) (1 2 3 = 0) (97 98 99 = .), gen(edu_higher)
* end 
fre edu_no edu_primary edu_secondary edu_higher
* edu_ordered 

*education and z6 have been combined. 
fre education
fre z6

fre edu031
sum edu031
* 1 = no education, 2 = primary, 3=secondary, 4, higher edu
recode z6 (101 = 1) (102 103 = 2) (104 105 = 3) (106 107   118 119 120 121 122 = 4) ( 112 123 998 999 = .), gen (edu031)
fre edu031
sum edu031
fre education
recode education (0 = 1) (1 = 2) (2 = 3) ( 3 4 = 4) (98 99 = .), gen(edu032)
fre edu032
sum edu032
* combine the two ordered edu031 and edu032 variables
gen edu_ordered = .
replace edu_ordered = 1 if edu031 == 1
replace edu_ordered = 2 if edu031 == 2
replace edu_ordered = 3 if edu032 == 3
replace edu_ordered = 4 if edu032 == 4

sum edu031 edu032
sum edu_ordered
fre edu_ordered
*end

*recode z55 education completed with grade
recode z55(0 = 1) (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 = 0) (97 98 99 = .), gen(no_edu)
recode z55(1 2 3 4 5 6 = 1) (0 7 8 9 10 11 12 13 14 15 16 17 18 19 20 = 0) (97 98 99 = .), gen(primary_edu)
recode z55(7 8 9 10 = 1) (0 2 3 4 5 6 11 12 13 14 15 16 17 18 19 20 = 0) (97 98 99 = .), gen(secondary_edu)
recode z55(13 14 15 16 17 18 19 20 = 1) (0 1 2 3 4 5 6 7 8 9 10 11 12 = 0) (97 98 99 = .), gen(higher_edu)
sum no_edu primary_edu secondary_edu higher_edu
fre no_edu primary_edu secondary_edu higher_edu

* marital status is equal to z9. 
* single married and widow
recode z9 (101 = 1) (102 103 104 = 0) (998 999 = .), gen(single)
recode z9 (102 = 1) (101 103 104 = 0) (998 999 = .), gen(married)
recode z9 (103 = 1) (101 102 104 = 0) (998 999 = .), gen(widow)
fre single married widow
sum single married widow
* marital
recode z9 (101 = 1) (102 = 0) (103 104 998 999 = .), gen(marital)
fre marital
sum marital

* gender is equal to z1. 
* 0 = female and 1 = male
fre z1
sum z1
recode z1 ( 1 = 1) (2 = 0), gen(gender)
fre gender

* region 
* CSO Geographica Code Rural and Urban = m6b = 1 = rural & 2 = urban
fre m6b
fre region_1

recode m6b (1 = 1) (2 = 0), gen (region_1)

* check for rural and urban
recode m6b (1 = 1) (2 = 0), gen (rural)
recode m6b (2 = 1) (1 = 0), gen (urban) 
fre rural urban
sum rural urban
* check for different regions
fre region
sum region
recode region (1 = 1) (2 3 4 5 6 7 8 = 0), gen(kabul_central)
recode region (2 = 1) (1 3 4 5 6 7 8 = 0), gen(east)
recode region (3 4 = 1) (1 2 5 6 7 8 = 0), gen(south)
recode region (5 = 1) (1 2 3 4 6 7 8 = 0), gen(west)
recode region (6 8 = 1) (1 2 3 4 5 7 = 0), gen(north)
recode region (7 = 1) (1 2 3 4 5 6 8 = 0), gen(central_highlands)
fre kabul_central east south west north central_highlands
* end 
fre kabul_central east south west north central_highlands
sum kabul_central east south west north central_highlands

* ethnic groups
fre z10
sum z10
fre pashtun tajik uzbek hazara // these are the main four ethnic groups in Afg
recode z10 (101 = 1) (102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 = 0) (996 998 999 = .), gen(pashtun)
recode z10 (102 = 1) (101 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 = 0) (996 998 999 = .), gen(tajik)
recode z10 (103 = 1) (101 102 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 = 0) (996 998 999 = .), gen(uzbek)
recode z10 (104 = 1) (101 102 103 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 = 0) (996 998 999 = .), gen(hazara)
recode z10 (105 = 1) (101 102 103 104 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 = 0) (996 998 999 = .), gen(turkmen)
* end

* household size = z11. 
fre z11
recode z11 (98 99 = .), gen(hhsize) // continous 
fre hhsize

*householdsize categories 
gen hhsize1_4 = .
gen hhsize5_8 = .
gen hhsize9_12 =.
gen hhsize_over = .

replace hhsize1_4 = 1 if z11 <= 4
replace hhsize1_4 = 0 if z11 > 4
replace hhsize1_4 = . if missing(z11)

replace hhsize5_8 = 1 if z11 <= 5
replace hhsize5_8 = 0 if z11 > 5
replace hhsize5_8 = . if missing(z11)

replace hhsize9_12 = 1 if z11 <= 9
replace hhsize9_12 = 0 if z11 > 9
replace hhsize9_12 = . if missing(z11)

replace hhsize_over = 1 if z11 <= 12
replace hhsize_over = 0 if z11 > 12
replace hhsize_over = . if missing(z11)

replace hhsize_cat1 = 1 if z11 <= 5

recode x153a (1 = 1 ) (2 = 0) ( 98 99 = .), gen(info_radio)
recode x153b (1 = 1 ) (2 = 0) ( 98 99 = .), gen(info_tv)
recode x153c (1 = 1 ) (2 = 0) ( 98 99 = .), gen(info_mobile)
recode x153f (1 = 1 ) (2 = 0) ( 98 99 = .), gen(info_net)

sum info_tv info_radio info_mobile info_net
fre info_tv info_radio info_mobile info_net
ologit happiness_ordered info_radio info_tv info_mobile info_net

*recode m7
recode m7 (1 = 1) (2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 21 22 23 24 25 26 27 28 29 30 31 32 33 34 = 0), gen(kabul_geo)
recode m7 (27 = 1) (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 21 22 23 24 25 26 28 29 30 31 32 33 34 = 0), gen(helmand_geo)
recode m7 (10 = 1) (1 2 3 4 5 6 7 8 9 11 12 13 14 15 16 17 18 19 20 21 21 22 23 24 25 26 27 28 29 30 31 32 33 34 = 0), gen(nangarhar_geo)

**recode m4 to north and south 
recode m4 (3 4 = 1) (1 2 5 6 7 8 = 0), gen(southgeo)
recode m4 (6 8 = 1) (1 2 3 4 5 7 = 0), gen(northgeo)
recode m4 (2 = 1) (1 3 4 5 6 7 8 = 0), gen(eastgeo)
recode m4 (5 = 1) (1 2 3 4 6 7 8 = 0), gen(westgeo)
drop westgeo
sum northgeo eastgeo southgeo westgeo

* end of recoding

**==============================================================================
**# Labels
label variable happiness_ordered "Happiness"
label variable happiness_binary "Happiness"
label variable income_cat9 "Income Levels"
label variable financialhh "Household financial situation"
label variable physicalchh "Household physical condition"
label variable fearbinary "Fear of insecurity"
label variable vovc "Being a victim of violence"
label variable corruption_dlife "Corruption in daily life"
label variable nmood "Country direction"
label variable sdemocracy "Satisfaction with democracy"
label variable trust_gov "Trust in government"
label variable no_edu "No education"
label variable primary_edu "Primary education"
label variable secondary_edu "Secondary education"
label variable higher_edu "Higher education"
label variable qualitysch "Access and quality of school"
label variable wellbeing_hh "Health well-being"
label variable food_quality "Food quality"
label variable age1825 "Age18-25"
label variable age2635 "Age 26-35"
label variable age3645 "Age 36-45"
label variable age4655 "Age 46-55"
label variable age55over "Age 46-55"
label variable hhsize1_4 "Household size 1-4"
label variable hhsize5_8 "Household size 5-8"
label variable hhsize9_12 "Household size 9-12"
label variable hhsize_over "Household size over 12"
label variable single "Single = 1"
label variable married "Married = 1"
label variable widow "Widow"
label variable gender "Gender"
label variable pashtun "Pashtun"
label variable tajik "Tajik"
label variable uzbek "Uzbek"
label variable hazara "Hazara"
label variable turkmen "Turkmen"
label variable electricity "Access to electricity"
label variable info_tv "Access to TV"
label variable info_net "Access to internet"
label variable province "Province dummies"
label variable year "Year dummies"

*end
*===============================================================================
**#Table 1: Summary Statistics
sum happiness_ordered income_cat9 fearbinary vovc
* Unweighted
*end 
********************************************************************************
* Full Summary Statistics
sum happiness_ordered income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov no_edu primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age1825 age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 hhsize_over single married widow gender pashtun tajik uzbek hazara turkmen electricity info_tv info_net province year
* Unweighted
*end 
*Fig. 3: Average of SWB and Fear of Insecurity in Afghanistan (2016 – 2021)
*===============================================================================
**#Table 2: SWB, Ordered Logit Model
*8 Models UNWEIGHTED with vce(cluster province) dummies in all models 20May Final
* Note! before runing this regression use e(sample) considerin the if e(sample) in model 8 to control the sample
*generate spsvyApril25 = e(sample)

ologit happiness_ordered i.income_cat9 i.province i.year if e(sample), vce(cluster province)
eststo model01
ologit happiness_ordered i.income_cat9 financialhh physicalchh i.province i.year if e(sample), vce(cluster province)
eststo model02
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc i.province i.year if e(sample), vce(cluster province)
eststo model03
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov i.province i.year if e(sample), vce(cluster province)
eststo model04
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch i.province i.year if e(sample), vce(cluster province)
eststo model05
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality i.province i.year if e(sample), vce(cluster province)
eststo model06
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen i.province i.year if e(sample), vce(cluster province)
eststo model07

ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)
*generate spsvyApril25 = e(sample)
eststo model08

esttab model01 model02 model03 model04 model05 model06 model07 model08 using "results_Happiness POLM unweighted province 20May.2025.rtf", ///
cells(b(star fmt(3)) t(par fmt(3))) ///
stats(N, fmt(2) labels(Observations)) ///
collabels(none) ///
title("Table 2: SWB, Pooled Ordered Logit Model unweighted vce(cluster province)") ///
nomtitles star(* 0.10 ** 0.05 *** 0.01) ///
replace varwidth(25) modelwidth(8) ///
label
**end
*This is reported in the paper version "Income_SWB_V_RDE_10June.2025"
*Table 2: SWB, Ordered Logit Model
*Notes: Robust standard errors clustered at the province level (34 clusters). Z statistics are reported in parentheses. ***p < 0.01, **p < 0.05, *p < 0.1. 
*===============================================================================

**# Table 3: SWB, Ordered Logit Model, Marginal Effects
**Marginal Effects 15 April 2025 with POLGM+++
ologit happiness_ordered i.income_cat9 fearbinary vovc financialhh physicalchh corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)
eststo m1: margins, dydx (*) post predict(outcome(1))

ologit happiness_ordered i.income_cat9 fearbinary vovc financialhh physicalchh corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)
eststo m2: margins, dydx (*) post predict(outcome(2))

ologit happiness_ordered i.income_cat9 fearbinary vovc financialhh physicalchh corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)
eststo m3: margins, dydx (*) post predict(outcome(3))

ologit happiness_ordered i.income_cat9 fearbinary vovc financialhh physicalchh corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)
eststo m4: margins, dydx (*) post predict(outcome(4))

esttab m1 m2 m3 m4 using "results_Marginal effect of SWB POLGM 15 April 2025.rtf", cells(b(star fmt(3)) t(par fmt(3))) stats(N, fmt(2) labels(Observations)) collabels(none) title("Table 3: SWB, Pooled Ordered Logit Model, Marginal Effects") nomtitles star(* 0.10 ** 0.05 *** 0.01) replace  varwidth(25) modelwidth(8) drop()
*end

*This is reported in the paper version "Income_SWB_V_RDE_10June.2025"
*"Table 3: SWB, Pooled Ordered Logit Model, Marginal Effects"
*===============================================================================

**# Fig 4: SWB, Ordered Logit Model, Marginal Effects
*Marginal Effects with Graph all four cat. of Happiness

ologit happiness_ordered i.income_cat9 fearbinary vovc financialhh physicalchh corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)

margins income_cat9, predict(outcome(1)) ///
    predict(outcome(2)) ///
    predict(outcome(3)) ///
    predict(outcome(4))
	
marginsplot, title("Marginal Effects of Income on Happiness Levels") ///
    ytitle("Predicted Probability") xtitle("Income Category") ///
    xlabel(1(1)9, valuelabel) ///
    plot1opts(lwidth(medthick) color(red)) ///
    plot2opts(lwidth(medthick) color(cranberry)) ///
    plot3opts(lwidth(medthick) color(eltgreen)) ///
    plot4opts(lwidth(medthick) color(forest_green)) ///
    ciopts(color(gs12)) ///
    legend(order(1 "Not at all happy" 2 "Not very happy" 3 "Somewhat happy" 4 "Very happy"))

*end
*This is reported in the paper version "Income_SWB_V_RDE_10June.2025"
*===============================================================================

**# Fig 5: SWB and Fear of Insecurity, Ordered Logit, Marginal Effects, Interactions
**# Fig 6: SWB and Being Victim of Violence, Ordered Logit, Marginal Effects, Interactions

*Interaction,Graphs,POLGM, unweighted income_cat9 and vce(cluster province) 22.April 2025+++

ologit happiness_ordered i.income_cat9##i.fearbinary i.income_cat9##i.vovc financialhh physicalchh corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)

* Graph: Fear
margins, dydx(income_cat9) at(fearbinary = (0(1)1)) vsquish
margins income_cat9#fearbinary, predict(outcome(4)) post 
marginsplot
marginsplot, yline(0)

* Graph Violence
margins, dydx(income_cat9) at(vovc = (0(1)1)) vsquish
margins income_cat9#vovc, predict(outcome(4)) post 
marginsplot
marginsplot, yline(0)
*end 
* Graphs in STATA files. 
*This is reported in the paper version "Income_SWB_V_RDE_10June.2025"
*===============================================================================
**# Table A1: Descriptive Statistics Weighted and Unweighted 
svyset district [pweight=mergewgt1], strata(province)

svy: mean happiness_ordered income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov no_edu primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age1825 age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 hhsize_over single married widow gender pashtun tajik uzbek hazara turkmen electricity info_tv info_net province year
* This result generated in STATA and then copied and past in ms word with unweighted results
*This is reported in the paper version "Income_SWB_V_RDE_02June.2025"
*===============================================================================
**# Table A3: SWB, Linear Probability Model
*8 Models happiness4 LPM unweighted income_cat9 vce province all dummies 22May Final

reg happiness4 i.income_cat9 i.province i.year if e(sample), vce(cluster province)
eststo model01
reg happiness4 i.income_cat9 financialhh physicalchh i.province i.year if e(sample), vce(cluster province)
eststo model02
reg happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc i.province i.year if e(sample), vce(cluster province)
eststo model03
reg happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov i.province i.year if e(sample), vce(cluster province)
eststo model04
reg happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch i.province i.year if e(sample), vce(cluster province)
eststo model05
reg happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality i.province i.year if e(sample), vce(cluster province)
eststo model06
reg happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen i.province i.year if e(sample), vce(cluster province)
eststo model07
reg happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)
eststo model08

esttab model01 model02 model03 model04 model05 model06 model07 model08 using "results_happiness4 LPM model 22May.2025.rtf", ///
cells(b(star fmt(3)) t(par fmt(3))) ///
stats(N, fmt(2) labels(Observations)) ///
collabels(none) ///
title("Table A3: SWB (happiness4), LMP unweighted vce(cluster province)") ///
nomtitles star(* 0.10 ** 0.05 *** 0.01) ///
replace varwidth(25) modelwidth(8) ///
label
*end 
* Table A3: SWB, Linear Probability Model
*This is reported in the paper version "Income_SWB_V_RDE_10June.2025"
*Notes: Robust standard errors clustered at the province level (34 clusters). t statistics are reported in parentheses. ***p < 0.01, **p < 0.05, *p < 0.1.
*===============================================================================
**# Table A4: SWB, Logit Model
*8 Models happiness4 LOGIT unweighted income_cat9 vce province all dummies 22May

logit happiness4 i.income_cat9 i.province i.year if e(sample), vce(cluster province)
eststo model01
logit happiness4 i.income_cat9 financialhh physicalchh i.province i.year if e(sample), vce(cluster province)
eststo model02
logit happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc i.province i.year if e(sample), vce(cluster province)
eststo model03
logit happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov i.province i.year if e(sample), vce(cluster province)
eststo model04
logit happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch i.province i.year if e(sample), vce(cluster province)
eststo model05
logit happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality i.province i.year if e(sample), vce(cluster province)
eststo model06
logit happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen i.province i.year if e(sample), vce(cluster province)
eststo model07
logit happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)
eststo model08

esttab model01 model02 model03 model04 model05 model06 model07 model08 using "results_happiness4 logit model 22May.2025.rtf", ///
cells(b(star fmt(3)) t(par fmt(3))) ///
stats(N, fmt(2) labels(Observations)) ///
collabels(none) ///
title("Table A4: SWB, (happiness4) logit unweighted vce(cluster province)") ///
nomtitles star(* 0.10 ** 0.05 *** 0.01) ///
replace varwidth(25) modelwidth(8) ///
label
*end 
* Table A4: SWB,happiness4 Logit Model final
*This is reported in the paper version "Income_SWB_V_RDE_10June.2025"
*===============================================================================

**# Table A5: SWB, Logit Model, Marginal Effects, SWB (0 = (1-3),1= (4))

logit happiness4 i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)

eststo mb1: margins, dydx(*) post

esttab mb1 using "results_Marginal effect of logit happiness4 22 April 2025.rtf", cells(b(star fmt(3)) t(par fmt(3))) stats(N, fmt(2) labels(Observations)) collabels(none) title("Table 3: SWB, Logit Model, Marginal Effects Happiness4") nomtitles star(* 0.10 ** 0.05 *** 0.01) replace  varwidth(25) modelwidth(8) drop()

* Table A5: SWB, Logit Model, Marginal Effects, SWB (0 = (1-3),1= (4))
*This is reported in the paper version "Income_SWB_V_RDE_02June.2025"
*===============================================================================

**# Table A6: SWB, Ordered Logit Model, Region
** 8 models POLGM REGION unweighted with vce(cluster region) all dummies 20May Final

ologit happiness_ordered i.income_cat9 i.region i.year if e(sample), vce(cluster region)
eststo model01
ologit happiness_ordered i.income_cat9 financialhh physicalchh i.region i.year if e(sample), vce(cluster region)
eststo model02
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc i.region i.year if e(sample), vce(cluster region)
eststo model03
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov i.region i.year if e(sample), vce(cluster region)
eststo model04
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch i.region i.year if e(sample), vce(cluster region)
eststo model05
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality i.region i.year if e(sample), vce(cluster region)
eststo model06
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen i.region i.year if e(sample), vce(cluster region)
eststo model07
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.region i.year if e(sample), vce(cluster region)
eststo model08

esttab model01 model02 model03 model04 model05 model06 model07 model08 using "results_Happiness POLM unweighted region 20May.2025.rtf", ///
cells(b(star fmt(3)) t(par fmt(3))) ///
stats(N, fmt(2) labels(Observations)) ///
collabels(none) ///
title("Table A6: SWB, Ordered Logit Model, Region vce (cluster region)) ") ///
nomtitles star(* 0.10 ** 0.05 *** 0.01) ///
replace varwidth(25) modelwidth(8) ///
label
*end 
*===============================================================================
**#Table A7: SWB, Ordered Logit Model with High Conflict Dummy (2021 Excluded)
* orginal model
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year, vce(cluster province)
eststo model08

* include low security province dummy varaible
ologit happiness_ordered low_secure i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year, vce(cluster province)
eststo model09

* exclude 2021
ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if year != 2021, vce(cluster province)
eststo model010

esttab model08 model09 model010 using "results_Happiness POLM unweighted province excluded 2021 27May.2025.rtf", ///
    cells(b(star fmt(3)) t(par fmt(3))) ///
    stats(N, fmt(2) labels(Observations)) ///
    collabels(none) ///
    title("Table A7: SWB, Pooled Ordered Logit Model unweighted vce(cluster province) excluded 2021") ///
    nomtitles ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    replace ///
    varwidth(25) modelwidth(8) ///
    label

*This is reported in the paper version "Income_SWB_V_RDE_10June.2025"
* low_secure = High Conflict Dummy
* NOTE: when you run these three models, clear the STATA memory then run otherwise the number of obs of excluded will be equal to the other two model. becuase of the if condition option.
* end
*===============================================================================

**# Table A8: Mean of Fatalities, Security Level by Province
* This Table has been prepared with ACLED data see "dofile_conflicted_provinces_ACLED" in STATA File 2025 April results. The data set is also there.

*===============================================================================

**# Table A9: SWB, Ordered Logit Model, Weighted
** 9 models WIEGHTED district [pweight=mergewgt1], strata(province) and REGION all dummies 20May Final

svyset district [pweight=mergewgt1], strata(province)

svy: ologit happiness_ordered i.income_cat9 i.province i.year if e(sample)
eststo model01
svy: ologit happiness_ordered i.income_cat9 financialhh physicalchh i.province i.year if e(sample)
eststo model02
svy: ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc i.province i.year if e(sample)
eststo model03
svy: ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov i.province i.year if e(sample)
eststo model04
svy: ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch i.province i.year if e(sample)
eststo model05
svy: ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality i.province i.year if e(sample)
eststo model06
svy: ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen i.province i.year if e(sample)
eststo model07
svy: ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample)
eststo model08

svy: ologit happiness_ordered i.income_cat9 financialhh physicalchh fearbinary vovc corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.region i.year if e(sample)
eststo model09

esttab model01 model02 model03 model04 model05 model06 model07 model08 model09 using "results_Happiness POLM weighted province and region 20May.2025.rtf", ///
cells(b(star fmt(3)) t(par fmt(3))) ///
stats(N, fmt(2) labels(Observations)) ///
collabels(none) ///
title("Table A9: SWB, Ordered Logit Model, Weighted") ///
nomtitles star(* 0.10 ** 0.05 *** 0.01) ///
replace varwidth(25) modelwidth(8) ///
label

*This is reported in the paper version "Income_SWB_V_RDE_10June.2025"
*end
* Notes: Estimates are from a survey-weighted ordered logistic regression model. Standard errors are based on Taylor linearization approach. The analysis includes 8 strata, (regions), 34 strata (provinces) and 11,094 (districts) primary sampling units (PSUs). t statistics are reported in parentheses. ***p < 0.01, **p < 0.05, *p < 0.1.
*===============================================================================
**# Table A10: SWB, Ordered Logit, Marginal Effects, Interactions

*Interaction unweighted income_cat9 and vce(cluster province) 15.April 2025+++

ologit happiness_ordered i.income_cat9##i.fearbinary i.income_cat9##i.vovc financialhh physicalchh corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year if e(sample), vce(cluster province)


margins, dydx(income_cat9) at(fearbinary = (0(1)1)) vsquish
margins, dydx(income_cat9) at(vovc = (0(1)1)) vsquish

*This is reported in the paper version "Income_SWB_V_RDE_02June.2025"
*Note: This result has been generated manaually in the paper by getting the difference interaction term of 0 and 1 see below table.

*===============================================================================
**# Fig A1: SWB and Fear of Insecurity, Logit Model, Marginal Effects, Interactions

*Interaction, Graphs LOGIT happiness4, Fearbinary, unweighted 20May+++

logit happiness4 i.income_cat9##i.fearbinary i.income_cat9##i.vovc financialhh physicalchh corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year, vce(cluster province)

margins, dydx(income_cat9) at(fearbinary = (0 1)) vsquish
margins income_cat9#fearbinary, post
marginsplot
marginsplot, yline(0)
*This is reported in the paper version "Income_SWB_V_RDE_10June.2025"
*end

***********************************************************
**# Fig A2: SWB and Being Victim of Violence, Logit Model, Marginal Effects, Interactions

**Interaction, Graphs LOGIT happiness4, vovc, unweighted 20May+++

logit happiness4 i.income_cat9##i.fearbinary i.income_cat9##i.vovc financialhh physicalchh corruption_dlife nmood sdemocracy trust_gov primary_edu secondary_edu higher_edu qualitysch wellbeing_hh food_quality age2635 age3645 age4655 age55over hhsize1_4 hhsize5_8 hhsize9_12 single married gender tajik uzbek hazara turkmen electricity info_tv info_net i.province i.year, vce(cluster province)

margins, dydx(income_cat9) at(vovc = (0 1)) vsquish
margins income_cat9#vovc, post
marginsplot
marginsplot, yline(0)

*This is reported in the paper version "Income_SWB_V_RDE_10June.2025"

*END


