*************************************ESTIMATE VALUE FOR MAJOR PRODUCTS**************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

use "$thesis/Data/database_dta/elisa_preestimate_gravity.dta", clear

set more off

drop if year<1733
drop if year>1789

drop if sourcetype=="Colonies" | sourcetype=="Divers" | sourcetype=="Divers - in" | sourcetype=="Résumé" | sourcetype=="National par direction" 

foreach i of num 1754/1789{
drop if sourcetype!="Objet Général" & year==`i'
}


drop if pays_regroupes=="Duché de Bouillon" | pays_regroupes=="Espagne-Portugal" | pays_regroupes=="France" | pays_regroupes=="Petites Îles"
replace classification_hamburg_large="other" if classification_hamburg_large!="Café" & classification_hamburg_large!="Eau ; de vie" & classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Vin ; de France" 


collapse (sum) value, by(year classification_hamburg_large pays_regroupes)

merge m:1 year pays_regroupes classification_hamburg_large using "$thesis/Data/database_dta/allcountry_product_estimation"
drop _merge

replace value = pred_value if year<1752
replace value=pred_value if year==1753
replace value=pred_value if year>1762 & year<1767
replace value=pred_value if year>1782 & year<1787
drop pred_value


****rename classification and pays to english 
replace classification_hamburg_large="Coffee" if classification_hamburg_large=="Café"
replace classification_hamburg_large="Eau-de-vie" if classification_hamburg_large=="Eau ; de vie"
replace classification_hamburg_large="Sugar" if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
replace classification_hamburg_large="Wine" if classification_hamburg_large=="Vin ; de France"
replace classification_hamburg_large="ZOther" if classification_hamburg_large=="Other"

replace pays_regroupes="Germany" if pays_regroupes=="Allemagne et Pologne (par terre)"
replace pays_regroupes="England" if pays_regroupes=="Angleterre"
replace pays_regroupes="Spain" if pays_regroupes=="Espagne"
replace pays_regroupes="Flanders and Habsburg Monarchy" if pays_regroupes=="Flandre et autres états de l'Empereur"
replace pays_regroupes="Netherland" if pays_regroupes=="Hollande"
replace pays_regroupes="Italy" if pays_regroupes=="Italie"
replace pays_regroupes="United States" if pays_regroupes=="États-Unis d'Amérique"
replace pays_regroupes="India" if pays_regroupes=="Indes"
replace pays_regroupes="North" if pays_regroupes=="Nord"
replace pays_regroupes="Switzerland" if pays_regroupes=="Suisse"

encode classification_hamburg_large, gen(class)
encode pays_regroupes, gen (pays)

gen lnvalue=ln(value)

****generate class dummies, label them and generate and label time trends
tab class, gen(class_)
foreach var of varlist class_1-class_5{
gen year_`var'=`var'*year
}
foreach i of num 1/5{
label var year_class_`i' "`: label (class) `i'' time trend" 
}

****generate pays dummies, label them and generate and label time trends
tab pays, gen(pays_)
foreach var of varlist pays_1-pays_12{
gen year_`var'=`var'*year
}
foreach i of num 1/12{
label var year_pays_`i' "`: label (pays) `i'' time trend" 
}


******

egen pays_class=group(pays class)
label var pays_class "Product-country fe"

******
gen war=0
gen neutral=0
gen allies=0

label var war Adversary
label var neutral Neutral
label var allies Allies


****POLISH SUCCESION WAR, no lags and no prewar effects
foreach i of num 1733/1738{
replace war=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==`i'

replace neutral=1 if pays_regroupes=="Netherland" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="North" & year==`i'
replace neutral=1 if pays_regroupes=="Switzerland" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="England" & year==`i'
replace neutral=1 if pays_regroupes=="Italy" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}


****generate product war dummies and label them
foreach var of varlist class_1-class_5{
gen war_`var'=war*`var'
}
foreach var of varlist class_1-class_5{
gen neutral_`var'=neutral*`var'
}
foreach var of varlist class_1-class_5{
gen allies_`var'=allies*`var'
}
foreach i of num 1/5{
label var war_class_`i' "`: label (class) `i'' to adversaries" 
label var neutral_class_`i' "`: label (class) `i'' to neutral" 
label var allies_class_`i' "`: label (class) `i'' to allies" 
}

****generate time trends of product war dummies
foreach i of num 1/5{
gen year_war_class_`i'=year*war_class_`i'
gen year_neutral_class_`i'=year*neutral_class_`i'
gen year_allies_class_`i'=year*allies_class_`i'
}
foreach i of num 1/5{
label var year_war_class_`i' "`: label (class) `i'' war time trend to adversaries" 
label var year_neutral_class_`i' "`: label (class) `i'' war time trend to neutral" 
label var year_allies_class_`i' "`: label (class) `i'' war time trend to allies" 
}

codebook value
***regress with war dummies and country product fe (only product trend common) (polish)
areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5, absorb(pays_class) robust 
estimate store polish_pays_group
est2vec dummies1, e(r2 F) shvars(war_class_1- war_class_4 neutral_class_1-neutral_class_4) replace

***regress with war dummies and pays fe (country and country trend both common) (polish)

*areg lnvalue year_pays_1-year_pays_11 year_class_1-year_class_5 war_class_1- year_allies_class_5, absorb(pays_class) robust 
reg lnvalue i.pays year_pays_1-year_pays_11 class_1-class_4 year_class_1-year_class_5 war_class_1- neutral_class_5, robust 
estimate store polish_pays_fe
est2vec trend1, e(r2 F) shvars(year_war_class_1-year_allies_class_4) replace

****regress each product separately war dummies
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==1, robust
est2vec dummies_polish, e(r2 F) shvars(war neutral) replace
foreach i of num 2/4{
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==`i', robust 
est2vec dummies_polish, addto(dummies_polish) name(polish_`i')
}
*est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5, saving replace path("$thesis/Data/reg_table/dummies") addto(dummies2)
est2tex dummies_polish, preserve dropall path("$thesis/Data/reg_table/allcountry2/dummies") mark(stars) fancy collabels(Coffee Eau~de~vie Sugar Wine) replace

*estout polish_pays_group polish_pays_fe using "$thesis/Data/reg_table/allcountry2/excel/polish.xls", cells(b(star fmt(3)))

****AUSTRIAN SUCCESION WAR - NON COLONIAL no lags and no prewar
replace war=0 
replace neutral=0
replace allies=0

foreach i of num 1740/1743{
replace war=1 if pays_regroupes=="England" & year==`i'
replace war=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==`i'
replace war=1 if pays_regroupes=="Netherland" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="North" & year==`i'	
replace neutral=1 if pays_regroupes=="Switzerland" & year==`i'
replace neutral=1 if pays_regroupes=="Italy" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}


****create time trends for war and neutral

foreach var of varlist class_1-class_5{
replace war_`var'=war*`var'
replace neutral_`var'=neutral*`var'
replace allies_`var'=allies*`var'
}

foreach i of num 1/5{
replace year_war_class_`i'=year*war_class_`i'
replace year_neutral_class_`i'=year*neutral_class_`i'
replace year_allies_class_`i'=year*allies_class_`i'
}

***regress with war dummies (austrian a)
areg lnvalue year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5, absorb(pays_class) robust 
estimate store austrian1_pays_group
est2vec dummies1, addto(dummies1) name(austrian_a)

***regress with time trend, fe and war dummies with time trends (austrian a)

*areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 year_war_class_1-year_allies_class_5, absorb(pays_class) robust 
reg lnvalue i.pays year_pays_1-year_pays_11 class_1-class_5 year_class_1-year_class_5 war_class_1- neutral_class_5, robust 
estimate store austrian1_pays_fe
est2vec trend1, addto(trend1) name(austrian_a)

****regress each product separately war dummies
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==1, robust 
est2vec dummies_austrian_a, e(r2 F) shvars(war neutral) replace
foreach i of num 2/4{
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==`i', robust 
est2vec dummies_austrian_a, addto(dummies_austrian_a) name(dummies_austrian_a`i')
}
*est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5, saving replace path("$thesis/Data/reg_table/dummies") addto(dummies2)
est2tex dummies_austrian_a, preserve dropall path("$thesis/Data/reg_table/allcountry2/dummies") mark(stars) fancy collabels(Coffee Eau~de~vie Sugar Wine) replace

estout austrian1_pays_fe austrian1_pays_group, cells(b(star fmt(3)))
*estout austrian1_pays_fe austrian1_pays_group using "$thesis/Data/reg_table/allcountry2/excel/austrian1.xls", cells(b(star fmt(3)))


****AUSTRIAN SUCCESION WAR - COLONIAL PHASE war lags
replace war=0 
replace neutral=0
replace allies=0

foreach i of num 1744/1748{
replace war=1 if pays_regroupes=="England" & year==`i'
replace war=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==`i'
replace war=1 if pays_regroupes=="Netherland" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="North" & year==`i'
replace neutral=1 if pays_regroupes=="Switzerland" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}


***time trends for war per product
foreach var of varlist class_1-class_5{
replace war_`var'=war*`var'
replace neutral_`var'=neutral*`var'
replace allies_`var'=allies*`var'
}


****gen war lag and neutral lag
 
foreach i of num 1/5{
gen war_lag_`i'=0
}
foreach i of num 1/5{
gen neutral_lag_`i'=0
}
foreach i of num 1/5{
gen allies_lag_`i'=0
}

label var war_lag_1 "1 year of lag to adversaries"
label var neutral_lag_1 "1 year of lag to neutral"
label var allies_lag_1 "1 year of lag to allies"
foreach i of num 2/5{
label var war_lag_`i' "`i' years of lag to adversaries"
label var neutral_lag_`i' "`i' years of lag to neutral"
label var allies_lag_`i' "`i' years of lag to allies"
}
***
foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="England" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Netherland" & year==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="North" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Switzerland" & year==(1748+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1748+`i')
}


foreach i of num 1/5{
foreach j of num 1/5{
gen war_lag`j'_class`i'=war_lag_`j'*class_`i'
}
}
foreach i of num 1/5{
foreach j of num 1/5{
gen neutral_lag`j'_class`i'=neutral_lag_`j'*class_`i'
}
}
foreach i of num 1/5{
foreach j of num 1/5{
gen allies_lag`j'_class`i'=allies_lag_`j'*class_`i'
}
}

foreach i of num 1/5{
label var war_lag1_class`i' "1 year war lag: `: label (class) `i'' to adversaries" 
label var neutral_lag1_class`i' "1 year war lag: `: label (class) `i'' to neutral" 
label var allies_lag1_class`i' "1 year war lag: `: label (class) `i'' to allies" 
}
foreach i of num 1/5{
foreach j of num 1/5{
label var war_lag`i'_class`j' "`i' years war lag: `: label (class) `j'' to adversaries" 
label var neutral_lag`i'_class`j' "`i' years war lag: `: label (class) `j'' to neutral" 
label var allies_lag`i'_class`j' "`i' years war lag: `: label (class) `j'' to allies" 
}
}

***regress with time trend war dummies (austrian a)
foreach i of num 1/5{
replace year_war_class_`i'=year*war_class_`i'
replace year_neutral_class_`i'=year*neutral_class_`i'
replace year_allies_class_`i'=year*allies_class_`i'
}

***regress war dummies (austrian b)
areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5, absorb(pays_class) robust 
estimate store austrian2_pays_group
est2vec dummies1, addto(dummies1) name(austrian_b)

***regress with war time trends (austrian b)

*areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 year_war_class_1-year_allies_class_5, absorb(pays_class) robust 
reg lnvalue i.pays year_pays_1-year_pays_11 class_1-class_5 year_class_1-year_class_5 war_class_1- neutral_class_5, robust 
estimate store austrian2_pays_fe
est2vec trend1, addto(trend1) name(austrian_b)

****regress each product separately war dummies
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==1, robust 
est2vec dummies_austrian_b, e(r2 F) shvars(war neutral) replace
foreach i of num 2/4{
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==`i', robust 
est2vec dummies_austrian_b, addto(dummies_austrian_b) name(dummies_austrian_b`i')
}
*est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5, saving replace path("$thesis/Data/reg_table/dummies") addto(dummies2)
est2tex dummies_austrian_b, preserve dropall path("$thesis/Data/reg_table/allcountry2/dummies") mark(stars) fancy collabels(Coffee Eau~de~vie Sugar Wine) replace


**** regress with lags (austrian b)

areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, absorb(pays_class) robust 
estimate store austrian2_lag
est2vec lag1_war, e(r2 F) shvars(war_lag1_class1-war_lag5_class4) replace

quietly areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, absorb(pays_class) robust 
est2vec lag1_neu, e(r2 F) shvars(neutral_lag1_class1-neutral_lag5_class4) replace

quietly areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, absorb(pays_class) robust 
est2vec lag1_all, e(r2 F) shvars(allies_lag1_class1-allies_lag5_class4) replace

estout austrian2_pays_fe austrian2_pays_group austrian2_lag, cells(b(star fmt(3)))
*estout austrian2_pays_fe austrian2_pays_group austrian2_lag using "$thesis/Data/reg_table/allcountry2/excel/austrian2.xls", cells(b(star fmt(3)))


*********************SEVEN YEARS WAR both lags and pre war effects

replace war=0
replace neutral=0
replace allies=0

****
foreach i of num 1756/1763{
replace war=1 if pays_regroupes=="England" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'

replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="North" & year==`i'
replace neutral=1 if pays_regroupes=="Switzerland" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}


***time trends for war per product
foreach var of varlist class_1-class_5{
replace war_`var'=war*`var'
replace neutral_`var'=neutral*`var'
replace allies_`var'=allies*`var'
}

foreach i of num 1/5{
replace year_war_class_`i'=year*war_class_`i'
replace year_neutral_class_`i'=year*neutral_class_`i'
replace year_allies_class_`i'=year*allies_class_`i'
}


****gen war lag and neutral lag
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}
***
foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="England" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="North" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Switzerland" & year==(1763+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1763+`i')
}

***generate pre war effect
foreach i of num 1/4{
gen prewar_`i'=0
}
foreach i of num 1/4{
gen preneutral_`i'=0
}
foreach i of num 1/4{
gen preallies_`i'=0
}

foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="England" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="United States" & year==(1756-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="North" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Switzerland" & year==(1756-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 & year==(1756-`i')
}

label var prewar_1 "1 year pre-war to adversaries"
label var preneutral_1 "1 year pre-war to neutral"
label var preallies_1 "1 year pre-war to allies"
foreach i of num 2/4{
label var prewar_`i' "`i' years pre-war to adversaries"
label var preneutral_`i' "`i' years pre-war to neutral"
label var preallies_`i' "`i' years pre-war to allies"
}

****gen products lag and product pre war effects

foreach i of num 1/5{
foreach j of num 1/5{
replace war_lag`i'_class`j'=war_lag_`i'*class_`j'
replace neutral_lag`i'_class`j'=neutral_lag_`i'*class_`j'
replace allies_lag`i'_class`j'=allies_lag_`i'*class_`j'
}
}

foreach i of num 1/5{
foreach j of num 1/4{
gen prewar`j'_class`i'=prewar_`j'*class_`i'
}
}
foreach i of num 1/5{
foreach j of num 1/4{
gen preneutral`j'_class`i'=preneutral_`j'*class_`i'
}
}
foreach i of num 1/5{
foreach j of num 1/4{
gen preallies`j'_class`i'=preallies_`j'*class_`i'
}
}
foreach i of num 1/5{
label var prewar1_class`i'"1 year pre-war: `: label (class) `i'' to adversaries"
label var preneutral1_class`i' "1 year pre-war: `: label (class) `i'' to neutral" 
label var preallies1_class`i' "1 year pre-war: `: label (class) `i'' to allies" 
}
foreach i of num 1/4{
foreach j of num 1/5{
label var prewar`i'_class`j' "`i' years pre-war: `: label (class) `j'' to adversaries" 
label var preneutral`i'_class`j' "`i' years pre-war: `: label (class) `j'' to neutral" 
label var preallies`i'_class`j' "`i' years pre-war: `: label (class) `j'' to allies" 
}
}
***regress with war dummies (seven)
areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5, absorb(pays_class) robust 
estimate store seven_pays_group
est2vec dummies1, addto(dummies1) name(seven)

***regress with time trend, fe and war dummies with time trends (seven)
*areg lnvalue year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5 year_war_class_1-year_allies_class_5, absorb(pays_class) robust 
reg lnvalue i.pays year_pays_1-year_pays_11 class_1-class_5 year_class_1-year_class_5 war_class_1- neutral_class_5, robust 
estimate store seven_pays_fe
est2vec trend1, addto(trend1) name(seven)

****regress each product separately war dummies
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==1, robust 
est2vec dummies_seven, e(r2 F) shvars(war neutral) replace
foreach i of num 2/4{
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==`i', robust 
est2vec dummies_seven, addto(dummies_seven) name(dummies_seven_`i')
}
*est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5, saving replace path("$thesis/Data/reg_table/dummies") addto(dummies2)
est2tex dummies_seven, preserve dropall path("$thesis/Data/reg_table/allcountry2/dummies") mark(stars) fancy collabels(Coffee Eau~de~vie Sugar Wine) replace


**** run regression with lags (seven)

areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, absorb(pays_class) robust 
estimate store seven_lag
est2vec lag1_war, addto(lag1_war) name(seven)

quietly areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, absorb(pays_class) robust 
est2vec lag1_neu, addto(lag1_neu) name(seven)

quietly areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, absorb(pays_class) robust 
est2vec lag1_all, addto(lag1_all) name(seven)


**** run regression with prewar effects (seven)

areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 prewar1_class1-preallies4_class5, absorb(pays_class) robust 
estimate store seven_pre
est2vec pre1_war, e(r2 F) shvars(prewar1_class1-prewar4_class4) replace

quietly reg lnvalue i.pays_class year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 prewar1_class1-preallies4_class5, robust 
est2vec pre1_neu, e(r2 F) shvars(preneutral1_class1-preneutral4_class4) replace

quietly reg lnvalue i.pays_class year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 prewar1_class1-preallies4_class5, robust 
est2vec pre1_all, e(r2 F) shvars(preallies1_class1-preallies4_class4) replace 

estout seven_pays_fe seven_pays_group seven_lag seven_pre, cells(b(star fmt(3)))
*estout austrian2_pays_fe austrian2_pays_group austrian2_lag using "$thesis/Data/reg_table/allcountry2/excel/seven.xls", cells(b(star fmt(3)))



*********************AMERICAN REVOLUTIONARY WAR both pre war and war lag
replace war=0 
replace neutral=0
replace allies=0

foreach i of num 1778/1782{
replace war=1 if pays_regroupes=="England" & year==`i'

replace neutral=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="North" & year==`i'
replace neutral=1 if pays_regroupes=="Switzerland" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}

***time trends for war per product
foreach var of varlist class_1-class_5{
replace war_`var'=war*`var'
replace neutral_`var'=neutral*`var'
replace allies_`var'=allies*`var'
}
 
***regress with time trend, fe and war dummies with time trends
foreach i of num 1/5{
replace year_war_class_`i'=year*war_class_`i'
replace year_neutral_class_`i'=year*neutral_class_`i'
replace year_allies_class_`i'=year*allies_class_`i'
}

****gen war lag and neutral lag
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}
***
foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="England" & year==(1782+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="North" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Switzerland" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1782+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1782+`i')
}

***generate pre war effect

foreach i of num 1/4{
replace prewar_`i'=0
replace preneutral_`i'=0
replace preallies_`i'=0
}

foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="England" & year==(1778-`i')

replace preneutral_`i'=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="North" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Switzerland" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 & year==(1778-`i')
}

****gen products lag and product pre war effects

foreach i of num 1/5{
foreach j of num 1/5{
replace war_lag`i'_class`j'=war_lag_`i'*class_`j'
replace neutral_lag`i'_class`j'=neutral_lag_`i'*class_`j'
replace allies_lag`i'_class`j'=allies_lag_`i'*class_`j'
}
}
foreach i of num 1/4{
foreach j of num 1/5{
replace prewar`i'_class`j'=prewar_`i'*class_`j'
replace preneutral`i'_class`j'=preneutral_`i'*class_`j'
replace preallies`i'_class`j'=preallies_`i'*class_`j'
}
}

***regress with war dummies (american)
areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5, absorb(pays_class) robust 
est2vec dummies1, addto(dummies1) name(american)

***regress with time trend, fe and war dummies with time trends (american)
*areg lnvalue pays_1-pays_12 year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 year_war_class_1-year_allies_class_5, absorb(pays_class) robust 
reg lnvalue i.pays year_pays_1-year_pays_11 class_1-class_5 year_class_1-year_class_5 war_class_1- neutral_class_5, robust 
est2vec trend1, addto(trend1) name(american)

****regress each product separately war dummies
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==1, robust 
est2vec dummies_american, e(r2 F) shvars(war neutral) replace
foreach i of num 2/4{
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==`i', robust 
est2vec dummies_american, addto(dummies_american) name(dummies_american`i')
*est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5, saving replace path("$thesis/Data/reg_table/dummies") addto(dummies2)
est2tex dummies_american, preserve dropall path("$thesis/Data/reg_table/allcountry2/dummies") mark(stars) fancy collabels(Coffee Eau~de~vie Sugar Wine) replace
}

**** run regression with lags
/*
areg lnvalue pays_1-pays_12 year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, absorb(pays_class) robust 
est2vec lag1_war, addto(lag1_war) name(american)

quietly reg lnvalue i.pays_class year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, robust 
est2vec lag1_neu, addto(lag1_neu) name(american)

quietly reg lnvalue i.pays_class year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, robust 
est2vec lag1_all, addto(lag1_all) name(american)
*/
**** run regression with prewar effects

areg lnvalue pays_1-pays_12 year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 prewar1_class1-preallies4_class5, absorb(pays_class) robust 
est2vec pre1_war, addto(pre1_war) name(american)

quietly reg  lnvalue i.pays_class year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1-neutral_class_5 prewar1_class1-preallies4_class5, robust 
est2vec pre1_neu, addto(pre1_neu) name(american)

quietly reg  lnvalue i.pays_class year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 prewar1_class1-preallies4_class5, robust 
est2vec pre1_all, addto(pre1_all) name(american)




***********************ALL WARS

replace war=0
replace neutral=0
replace allies=0

****
foreach i of num 1733/1738{
replace war=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==`i'

replace neutral=1 if pays_regroupes=="Netherland" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="North" & year==`i'
replace neutral=1 if pays_regroupes=="Switzerland" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="England" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'

replace neutral=1 if war==0 & neutral==0 & year==`i'
}

foreach i of num 1740/1743{
replace war=1 if pays_regroupes=="England" & year==`i'
replace war=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==`i'
replace war=1 if pays_regroupes=="Netherland" & year==`i'

replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="North" & year==`i'
replace neutral=1 if pays_regroupes=="Switzerland" & year==`i'

replace neutral=1 if war==0 & neutral==0 & year==`i'
}

foreach i of num 1744/1748{
replace war=1 if pays_regroupes=="England" & year==`i'
replace war=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==`i'
replace war=1 if pays_regroupes=="Netherland" & year==`i'

replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="North" & year==`i'
replace neutral=1 if pays_regroupes=="Switzerland" & year==`i'

replace neutral=1 if war==0 & neutral==0 & year==`i'
}

foreach i of num 1756/1763{
replace war=1 if pays_regroupes=="England" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="United States" & year==`i'

replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="North" & year==`i'
replace neutral=1 if pays_regroupes=="Switzerland" & year==`i'

replace neutral=1 if war==0 & neutral==0 & year==`i'
}

foreach i of num 1778/1782{
replace war=1 if pays_regroupes=="England" & year==`i'

replace neutral=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="North" & year==`i'
replace neutral=1 if pays_regroupes=="Switzerland" & year==`i'

replace neutral=1 if war==0 & neutral==0 & year==`i'
}


***time trends for war per product
foreach var of varlist class_1-class_5{
replace war_`var'=war*`var'
replace neutral_`var'=neutral*`var'
replace allies_`var'=war*`var'
}


***regress with time trend, fe and war dummies with time trends
foreach i of num 1/5{
replace year_war_class_`i'=year*war_class_`i'
replace year_neutral_class_`i'=year*neutral_class_`i'
replace year_allies_class_`i'=year*allies_class_`i'
}


****gen war lag and neutral lag
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}

***
foreach i of num 1/5{
****austrian war
replace war_lag_`i'=1 if pays_regroupes=="England" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Netherland" & year==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="North" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Switzerland" & year==(1748+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1748+`i')

****seven years war
replace war_lag_`i'=1 if pays_regroupes=="England" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="United States" & year==(1763+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="North" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Switzerland" & year==(1763+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1763+`i')

****american war
replace war_lag_`i'=1 if pays_regroupes=="England" & year==(1782+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="North" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Switzerland" & year==(1782+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1782+`i')
}

***generate pre war effect
foreach i of num 1/4{

****seven years war
replace prewar_`i'=1 if pays_regroupes=="England" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="United States" & year==(1756-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="North" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Switzerland" & year==(1756-`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1756-`i')

****american war
replace prewar_`i'=1 if pays_regroupes=="England" & year==(1778-`i')

replace preneutral_`i'=1 if pays_regroupes=="Flanders and Habsburg Monarchy" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="North" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Switzerland" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1778-`i')
}

foreach i of num 1/5{
foreach j of num 1/5{
replace war_lag`i'_class`j'=war_lag_`i'*class_`j'
replace neutral_lag`i'_class`j'=neutral_lag_`i'*class_`j'
replace allies_lag`i'_class`j'=allies_lag_`i'*class_`j'
}
}

foreach i of num 1/4{
foreach j of num 1/5{
replace prewar`i'_class`j'=prewar_`i'*class_`j'
replace preneutral`i'_class`j'=preneutral_`i'*class_`j'
replace preallies`i'_class`j'=preallies_`i'*class_`j'
}
}

***regress with time trend, fe and war dummies
areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5, absorb(pays_class) robust 
est2vec dummies1, addto(dummies1) name(all)

***regress with time trend, fe and war dummies with time trends
*areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 year_war_class_1-year_neutral_class_5, absorb(pays_class) robust 
reg lnvalue i.pays year_pays_1-year_pays_11 class_1-class_5 year_class_1-year_class_5 war_class_1- neutral_class_5, robust 
est2vec trend1, addto(trend1) name(all)

****regress each product separately war dummies
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==1, robust 
est2vec dummies_all, e(r2 F) shvars(war neutral) replace
foreach i of num 2/4{
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war neutral if class==`i', robust 
est2vec dummies_all, addto(dummies_all) name(dummies_all`i')
*est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5, saving replace path("$thesis/Data/reg_table/dummies") addto(dummies2)
est2tex dummies_all, preserve dropall path("$thesis/Data/reg_table/allcountry2/dummies") mark(stars) fancy collabels(Coffee Eau~de~vie Sugar Wine) replace
}


**** run regression with lags

areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, absorb(pays_class) robust 
est2vec lag1_war, addto(lag1_war) name(all)

quietly reg lnvalue i.pays_class year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, robust 
est2vec lag1_neu, addto(lag1_neu) name(all)

quietly reg lnvalue i.pays_class year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, robust 
est2vec lag1_all, addto(lag1_all) name(all)

**** run regression with prewar effects

areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 prewar1_class1-preallies4_class5, absorb(pays_class) robust 
est2vec pre1_war, addto(pre1_war) name(all)

quietly reg lnvalue i.pays_class year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 prewar1_class1-preallies4_class5, robust 
est2vec pre1_neu, addto(pre1_neu) name(all)

quietly reg lnvalue i.pays_class year_pays_1-year_pays_12 year_class_1-year_class_5 war_class_1- neutral_class_5 prewar1_class1-preallies4_class5, robust 
est2vec pre1_all, addto(pre1_all) name(all)



*****export to latex
est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5, saving replace path("$thesis/Data/reg_table/dummies") addto(dummies1)
est2tex dummies1, preserve dropall path("$thesis/Data/reg_table/allcountry2/dummies") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace

est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5 year_war_class_1-year_war_class_5, saving replace path("$thesis/Data/reg_table/trend") addto(trend1)
est2tex trend1, preserve dropall path("$thesis/Data/reg_table/allcountry2/trend") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace

est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, saving replace path("$thesis/Data/reg_table/lag") addto(lag1_war)
est2tex lag1_war, preserve dropall path("$thesis/Data/reg_table/allcountry2/lag") mark(stars) fancy collabels(Austrian2 Seven~years All) replace

est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, saving replace path("$thesis/Data/reg_table/lag") addto(lag1_neu)
est2tex lag1_neu, preserve dropall path("$thesis/Data/reg_table/allcountry2/lag") mark(stars) fancy collabels(Austrian2 Seven~years All) replace

est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5 war_lag1_class1-allies_lag5_class5, saving replace path("$thesis/Data/reg_table/lag") addto(lag1_all)
est2tex lag1_all, preserve dropall path("$thesis/Data/reg_table/allcountry2/lag") mark(stars) fancy collabels(Austrian2 Seven~years All) replace

est2rowlbl pays_class war_class_1- neutral_class_5 year_war_class_1-year_neutral_class_5 war_lag1_class1-neutral_lag5_class5 prewar1_class1-preneutral4_class5, saving replace path("$thesis/Data/reg_table/pre") addto(pre1_war)
est2tex pre1_war, preserve dropall path("$thesis/Data/reg_table/allcountry2/pre") mark(stars) fancy collabels(Seven~years American All) replace

est2rowlbl pays_class war_class_1- neutral_class_5 year_war_class_1-year_neutral_class_5 war_lag1_class1-neutral_lag5_class5 prewar1_class1-preneutral4_class5, saving replace path("$thesis/Data/reg_table/pre") addto(pre1_neu)
est2tex pre1_neu, preserve dropall path("$thesis/Data/reg_table/allcountry2/pre") mark(stars) fancy collabels(Seven~years American All) replace

est2rowlbl pays_class war_class_1- neutral_class_5 year_war_class_1-year_neutral_class_5 war_lag1_class1-neutral_lag5_class5 prewar1_class1-preneutral4_class5, saving replace path("$thesis/Data/reg_table/pre") addto(pre1_all)
est2tex pre1_all, preserve dropall path("$thesis/Data/reg_table/allcountry2/pre") mark(stars) fancy collabels(Seven~years American All) replace

********************************************************************************************************************************
***************************************************ALTERANTIVE*****************************************************************************
********************************************************************************************************************************


clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

use "$thesis/Data/database_dta/elisa_preestimate_gravity.dta", clear

set more off

drop if year<1733
drop if year>1789

drop if sourcetype=="Colonies" | sourcetype=="Divers" | sourcetype=="Divers - in" | sourcetype=="Résumé" | sourcetype=="National par direction" 

foreach i of num 1754/1789{
drop if sourcetype!="Objet Général" & year==`i'
}


drop if pays_regroupes=="Duché de Bouillon" | pays_regroupes=="Espagne-Portugal" | pays_regroupes=="France" | pays_regroupes=="Petites Îles"
replace classification_hamburg_large="other" if classification_hamburg_large!="Café" & classification_hamburg_large!="Eau ; de vie" & classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Vin ; de France" 

collapse (sum) value, by(year classification_hamburg_large pays_regroupes direction)

merge m:1 year pays_regroupes classification_hamburg_large using "$thesis/Data/database_dta/allcountry_product_estimation"
drop if _merge==2

drop if year<1733
drop if year>1789

replace direction="total" if direction==""
sort (year) direction
egen _count=sum(value), by(year direction)
replace pred_value=0 if _count!=0 & value==0

replace value=pred_value if year<1752
replace value=pred_value if year==1753 
foreach i of num 1762/1766{
replace value=pred_value if year==`i'
}

drop _merge

collapse (sum) value, by(year classification_hamburg_large pays_regroupes)


****rename classification and pays to english 
replace classification_hamburg_large="Coffee" if classification_hamburg_large=="Café"
replace classification_hamburg_large="Eau-de-vie" if classification_hamburg_large=="Eau ; de vie"
replace classification_hamburg_large="Sugar" if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
replace classification_hamburg_large="Wine" if classification_hamburg_large=="Vin ; de France"
replace classification_hamburg_large="ZOther" if classification_hamburg_large=="Other"


encode classification_hamburg_large, gen(class)
encode pays_regroupes, gen (pays)

gen lnvalue=ln(value)
replace lnvalue=0 if value==0

****generate class dummies, label them and generate and label time trends
tab class, gen(class_)
foreach var of varlist class_1-class_5{
gen year_`var'=`var'*year
}
foreach i of num 1/5{
label var year_class_`i' "`: label (class) `i'' time trend" 
}

****generate pays dummies, label them and generate and label time trends
tab pays, gen(pays_)
foreach var of varlist pays_1-pays_12{
gen year_`var'=`var'*year
}
foreach i of num 1/12{
label var year_pays_`i' "`: label (pays) `i'' time trend" 
}


******

egen pays_class=group(pays class)
label var pays_class "Product-country fe"
******
foreach i of num 1/6{
gen war`i'=0
}
foreach i of num 1/6{
gen neutral`i'=0
}
label var neutral1 Polish
label var neutral2 Austrian1
label var neutral3 Austrian2
label var neutral4 Seven
label var neutral5 American
label var neutral6 All

foreach i of num 1/6{
gen allies`i'=0
}

foreach i of num 1733/1738{
replace war1=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'

replace neutral1=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral1=1 if pays_regroupes=="Levant" & year==`i'
replace neutral1=1 if pays_regroupes=="Nord" & year==`i'
replace neutral1=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral1=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral1=1 if pays_regroupes=="Angleterre" & year==`i'
replace neutral1=1 if pays_regroupes=="Italie" & year==`i'

replace allies1=1 if war1==0 & neutral1==0 & year==`i'
}
foreach i of num 1740/1743{
replace war2=1 if pays_regroupes=="Angleterre" & year==`i'
replace war2=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war2=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral2=1 if pays_regroupes=="Levant" & year==`i'
replace neutral2=1 if pays_regroupes=="Nord" & year==`i'
replace neutral2=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral2=1 if pays_regroupes=="Italie" & year==`i'
replace neutral2=1 if pays_regroupes=="Portugal" & year==`i'

replace allies2=1 if war2==0 & neutral2==0 & year==`i'
}
foreach i of num 1744/1748{
replace war3=1 if pays_regroupes=="Angleterre" & year==`i'
replace war3=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war3=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral3=1 if pays_regroupes=="Levant" & year==`i'
replace neutral3=1 if pays_regroupes=="Nord" & year==`i'
replace neutral3=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral3=1 if pays_regroupes=="Italie" & year==`i'
replace neutral3=1 if pays_regroupes=="Portugal" & year==`i'

replace allies3=1 if war3==0 & neutral3==0 & year==`i'
}
foreach i of num 1756/1763{
replace war4=1 if pays_regroupes=="Angleterre" & year==`i'
replace war4=1 if pays_regroupes=="Portugal" & year==`i'
replace war4=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral4=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral4=1 if pays_regroupes=="Italie" & year==`i'
replace neutral4=1 if pays_regroupes=="Levant" & year==`i'
replace neutral4=1 if pays_regroupes=="Nord" & year==`i'
replace neutral4=1 if pays_regroupes=="Suisse" & year==`i'

replace allies4=1 if war4==0 & neutral4==0 & year==`i'
}
foreach i of num 1778/1782{
replace war5=1 if pays_regroupes=="Angleterre" & year==`i'

replace neutral5=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace neutral5=1 if pays_regroupes=="Italie" & year==`i'
replace neutral5=1 if pays_regroupes=="Levant" & year==`i'
replace neutral5=1 if pays_regroupes=="Nord" & year==`i'
replace neutral5=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral5=1 if pays_regroupes=="Portugal" & year==`i'

replace allies5=1 if war5==0 & neutral5==0 & year==`i'
}
***all wars
foreach i of num 1733/1738{
replace war6=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'

replace neutral6=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral6=1 if pays_regroupes=="Levant" & year==`i'
replace neutral6=1 if pays_regroupes=="Nord" & year==`i'
replace neutral6=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral6=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral6=1 if pays_regroupes=="Angleterre" & year==`i'
replace neutral6=1 if pays_regroupes=="Italie" & year==`i'

replace allies6=1 if war6==0 & neutral6==0 & year==`i'
}
foreach i of num 1740/1748{
replace war6=1 if pays_regroupes=="Angleterre" & year==`i'
replace war6=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war6=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral6=1 if pays_regroupes=="Levant" & year==`i'
replace neutral6=1 if pays_regroupes=="Nord" & year==`i'
replace neutral6=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral6=1 if pays_regroupes=="Italie" & year==`i'
replace neutral6=1 if pays_regroupes=="Portugal" & year==`i'

replace allies6=1 if war6==0 & neutral6==0 & year==`i'
}
foreach i of num 1756/1763{
replace war6=1 if pays_regroupes=="Angleterre" & year==`i'
replace war6=1 if pays_regroupes=="Portugal" & year==`i'
replace war6=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral6=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral6=1 if pays_regroupes=="Italie" & year==`i'
replace neutral6=1 if pays_regroupes=="Levant" & year==`i'
replace neutral6=1 if pays_regroupes=="Nord" & year==`i'
replace neutral6=1 if pays_regroupes=="Suisse" & year==`i'

replace allies6=1 if war6==0 & neutral6==0 & year==`i'
}
foreach i of num 1778/1782{
replace war6=1 if pays_regroupes=="Angleterre" & year==`i'

replace neutral6=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace neutral6=1 if pays_regroupes=="Italie" & year==`i'
replace neutral6=1 if pays_regroupes=="Levant" & year==`i'
replace neutral6=1 if pays_regroupes=="Nord" & year==`i'
replace neutral6=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral6=1 if pays_regroupes=="Portugal" & year==`i'

replace allies6=1 if war6==0 & neutral6==0 & year==`i'
}

foreach i of num 1/6{
foreach j of num 1/5{
gen war`i'_class`j'=war`i'*class_`j'
}
}
foreach i of num 1/6{
foreach j of num 1/5{
gen neutral`i'_class`j'=neutral`i'*class_`j'
local lab `: var label neutral`i''
label var neutral`i'_class`j' "`lab': `: label (class) `j''"
}
}


***gen war lag
foreach i of num 1/5{
gen war3_lag`i'=0
replace war3_lag`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war3_lag`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1748+`i')
replace war3_lag`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')
}
foreach i of num 1/5{
gen war4_lag`i'=0
replace war4_lag`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war4_lag`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')
}
foreach i of num 1/5{
gen war6_lag`i'=0
replace war6_lag`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war6_lag`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1748+`i')
replace war6_lag`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')

replace war6_lag`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war6_lag`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')
}

foreach i of num 1/5{
gen neutral3_lag`i'=0
replace neutral3_lag`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral3_lag`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral3_lag`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')
replace neutral3_lag`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral3_lag`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')
}
foreach i of num 1/5{
gen neutral4_lag`i'=0
replace neutral4_lag`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral4_lag`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral4_lag`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')
replace neutral4_lag`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral4_lag`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
}

foreach i of num 1/5{
gen neutral6_lag`i'=0
replace neutral6_lag`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral6_lag`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral6_lag`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')
replace neutral6_lag`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral6_lag`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')

replace neutral6_lag`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral6_lag`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral6_lag`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')
replace neutral6_lag`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral6_lag`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
}

foreach i of num 1/5{
gen allies3_lag`i'=0
replace allies3_lag`i'=1 if war3_lag`i'==0 & neutral3_lag`i'==0 & year==(1748+`i')
}
foreach i of num 1/5{
gen allies4_lag`i'=0
replace allies4_lag`i'=1 if war4_lag`i'==0 & neutral4_lag`i'==0 & year==(1763+`i')
}
foreach i of num 1/5{
gen allies6_lag`i'=0
replace allies6_lag`i'=1 if war6_lag`i'==0 & neutral6_lag`i'==0 & year==(1763+`i')
replace allies6_lag`i'=1 if war6_lag`i'==0 & neutral6_lag`i'==0 & year==(1748+`i')
}

foreach i of num 3/4{
foreach j of num 1/5{
foreach k of num 1/5{
gen war`i'_lag`j'_class`k'=war`i'_lag`j'*class_`k'
}
}
}
foreach i of num 3/4{
foreach j of num 1/5{
foreach k of num 1/5{
gen neutral`i'_lag`j'_class`k'=neutral`i'_lag`j'*class_`k'
}
}
}
foreach i of num 3/4{
foreach j of num 1/5{
foreach k of num 1/5{
gen allies`i'_lag`j'_class`k'=allies`i'_lag`j'*class_`k'
local lab `: var label neutral`i''
label var neutral`i'_lag`j'_class`k' "`lab': `j' lag `: label (class) `k''"
}
}
}
foreach j of num 1/5{
foreach k of num 1/5{
gen war6_lag`j'_class`k'=war6_lag`j'*class_`k'
}
}
foreach j of num 1/5{
foreach k of num 1/5{
gen neutral6_lag`j'_class`k'=neutral6_lag`j'*class_`k'
}
}
foreach j of num 1/5{
foreach k of num 1/5{
gen allies6_lag`j'_class`k'=allies6_lag`j'*class_`k'
label var neutral6_lag`j'_class`k' "All: `j' lag `: label (class) `k''"
}
}

***gen pre war effects
foreach i of num 1/4{
gen war4_pre`i'=0
replace war4_pre`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace war4_pre`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')
replace war4_pre`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1756-`i')
}
foreach i of num 1/4{
gen war5_pre`i'=0
replace war5_pre`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')
}
foreach i of num 1/4{
gen war6_pre`i'=0
replace war6_pre`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace war6_pre`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')
replace war6_pre`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1756-`i')

replace war6_pre`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')
}
foreach i of num 1/4{
gen neutral4_pre`i'=0
replace neutral4_pre`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace neutral4_pre`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace neutral4_pre`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace neutral4_pre`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace neutral4_pre`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')
}
foreach i of num 1/4{
gen neutral5_pre`i'=0
replace neutral5_pre`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1778-`i')
replace neutral5_pre`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace neutral5_pre`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace neutral5_pre`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace neutral5_pre`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')
replace neutral5_pre`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')
}
foreach i of num 1/4{
gen neutral6_pre`i'=0
replace neutral6_pre`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace neutral6_pre`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace neutral6_pre`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace neutral6_pre`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace neutral6_pre`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')

replace neutral6_pre`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1778-`i')
replace neutral6_pre`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace neutral6_pre`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace neutral6_pre`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace neutral6_pre`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')
replace neutral6_pre`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')
}


foreach i of num 1/4{
gen allies4_pre`i'=0
replace allies4_pre`i'=1 if war4_pre`i'==0 & neutral4_pre`i'==0 & year==(1756-`i')
}
foreach i of num 1/4{
gen allies5_pre`i'=0
replace allies5_pre`i'=1 if war5_pre`i'==0 & neutral5_pre`i'==0 & year==(1778-`i')
}
foreach i of num 1/4{
gen allies6_pre`i'=0
replace allies6_pre`i'=1 if war6_pre`i'==0 & neutral6_pre`i'==0 & year==(1778-`i')
replace allies6_pre`i'=1 if war6_pre`i'==0 & neutral6_pre`i'==0 & year==(1756-`i')
}

foreach i of num 4/6{
foreach j of num 1/4{
foreach k of num 1/5{
gen war`i'_pre`j'_class`k'=war`i'_pre`j'*class_`k'
}
}
}
foreach i of num 4/6{
foreach j of num 1/4{
foreach k of num 1/5{
gen neutral`i'_pre`j'_class`k'=neutral`i'_pre`j'*class_`k'
}
}
}
foreach i of num 4/6{
foreach j of num 1/4{
foreach k of num 1/5{
gen allies`i'_pre`j'_class`k'=allies`i'_pre`j'*class_`k'
local lab `: var label neutral`i''
label var neutral`i'_pre`j'_class`k' "`lab': `j' pre `: label (class) `k''"
}
}
}

****reg with dummies: 
areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war6_class1-war6_class5 neutral6_class1-neutral6_class5, absorb(pays_class)
est2vec reg1_dummies, e(r2 F) shvars(neutral6_class1-neutral6_class4 neutral1_class1-neutral1_class4 neutral2_class1-neutral2_class4 neutral3_class1-neutral3_class4 neutral4_class1-neutral4_class4 neutral5_class1-neutral5_class4) replace

areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war1_class1-war5_class5 neutral1_class1-neutral5_class5, absorb(pays_class)
est2vec reg1_dummies, addto(reg1_dummies) name(reg1_dummies)

poisson value year_pays_1-year_pays_12 year_class_1-year_class_5 war6_class1-war6_class5 neutral6_class1-neutral6_class5 i.pays_class
est2vec reg1_dummies, addto(reg1_dummies) name(ppml1)

poisson value year_pays_1-year_pays_12 year_class_1-year_class_5 war1_class1-war5_class5 neutral1_class1-neutral5_class5 i.pays_class
est2vec reg1_dummies, addto(reg1_dummies) name(ppml2)

est2rowlbl neutral6_class1-neutral6_class4 neutral1_class1-neutral1_class4 neutral2_class1-neutral2_class4 neutral3_class1-neutral3_class4 neutral4_class1-neutral4_class4 neutral5_class1-neutral5_class4, saving replace path("$thesis/Data/reg_table/allcountry2/alternative") addto(reg1_dummies)
est2tex reg1_dummies, preserve dropall path("$thesis/Data/reg_table/allcountry2/alternative") mark(stars) fancy label collabels(All War~by~war PPML PPML~war~by~war) replace

***regress with lags 
areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war6_class1-war6_class5 neutral6_class1-neutral6_class5 war6_lag1_class1-allies6_lag5_class5, absorb(pays_class)
est2vec reg1_lag1, e(r2 F) shvars(neutral6_lag1_class1-neutral6_lag5_class4) replace
est2rowlbl neutral6_lag1_class1-neutral6_lag5_class4, saving replace path("$thesis/Data/reg_table/allcountry2/alternative") addto(reg1_lag1)
est2tex reg1_lag1, preserve dropall path("$thesis/Data/reg_table/allcountry2/alternative") mark(stars) label fancy collabels(All) replace

areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war1_class1-war5_class5 neutral1_class1-neutral5_class5 war3_lag1_class1-allies4_lag5_class5, absorb(pays_class)
est2vec reg1_lag2, e(r2 F) shvars(neutral3_lag1_class1-neutral3_lag5_class4) replace
est2rowlbl neutral3_lag1_class1-neutral3_lag5_class4, saving replace path("$thesis/Data/reg_table/allcountry2/alternative") addto(reg1_lag2)
est2tex reg1_lag2, preserve dropall path("$thesis/Data/reg_table/allcountry2/alternative") mark(stars) label fancy collabels(Austrian2) replace

areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war1_class1-war5_class5 neutral1_class1-neutral5_class5 war3_lag1_class1-allies4_lag5_class5, absorb(pays_class)
est2vec reg1_lag3, e(r2 F) shvars(neutral4_lag1_class1-neutral4_lag5_class4) replace
est2rowlbl neutral4_lag1_class1-neutral4_lag5_class4, saving replace path("$thesis/Data/reg_table/allcountry2/alternative") addto(reg1_lag3)
est2tex reg1_lag3, preserve dropall path("$thesis/Data/reg_table/allcountry2/alternative") mark(stars) label fancy collabels(Seven) replace

 
***regress with pre 
areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war6_class1-war6_class5 neutral6_class1-neutral6_class5 war6_pre1_class1-war6_pre4_class5 neutral6_pre1_class1-neutral6_pre4_class5 allies6_pre1_class1-allies6_pre4_class5, absorb(pays_class)
est2vec reg1_pre1, e(r2 F) shvars(neutral6_pre1_class1-neutral6_pre4_class4) replace
est2rowlbl neutral6_pre1_class1-neutral6_pre4_class4, saving replace path("$thesis/Data/reg_table/allcountry2/alternative") addto(reg1_pre1)
est2tex reg1_pre1, preserve dropall path("$thesis/Data/reg_table/allcountry2/alternative") mark(stars) label fancy collabels(All) replace

areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war1_class1-war5_class5 neutral1_class1-neutral5_class5 war4_pre1_class1-war5_pre4_class5 neutral4_pre1_class1-neutral5_pre4_class5 allies4_pre1_class1-allies5_pre4_class5, absorb(pays_class)
est2vec reg1_pre2, e(r2 F) shvars(neutral4_pre1_class1-neutral4_pre4_class4) replace
est2rowlbl neutral4_pre1_class1-neutral4_pre4_class4, saving replace path("$thesis/Data/reg_table/allcountry2/alternative") addto(reg1_pre2)
est2tex reg1_pre2, preserve dropall path("$thesis/Data/reg_table/allcountry2/alternative") mark(stars) label fancy collabels(Seven) replace

areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war1_class1-war5_class5 neutral1_class1-neutral5_class5 war4_pre1_class1-war5_pre4_class5 neutral4_pre1_class1-neutral5_pre4_class5 allies4_pre1_class1-allies5_pre4_class5, absorb(pays_class)
est2vec reg1_pre3, e(r2 F) shvars(neutral5_pre1_class1-neutral5_pre4_class4) replace
est2rowlbl neutral5_pre1_class1-neutral5_pre4_class4, saving replace path("$thesis/Data/reg_table/allcountry2/alternative") addto(reg1_pre3)
est2tex reg1_pre3, preserve dropall path("$thesis/Data/reg_table/allcountry2/alternative") mark(stars) label fancy collabels(American) replace

 
 
****regress each product separately war dummies
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war1-neutral5 if class==1, robust 
est2vec dummies_all, e(r2 F) shvars(neutral1-neutral5) replace
foreach i of num 2/4{
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war1-neutral5 if class==`i', robust 
est2vec dummies_all, addto(dummies_all) name(dummies_all`i')
est2rowlbl neutral1-neutral5, saving replace path("$thesis/Data/reg_table/dummies") addto(dummies2)
}
est2tex dummies_all, preserve dropall path("$thesis/Data/reg_table/allcountry2/alternative") mark(stars) fancy collabels(Coffee Eau~de~vie Sugar Wine) replace

****regress each product separately war lag
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war1-neutral5 war3_lag1-allies4_lag5 if class==1, robust 
est2vec lag_all, e(r2 F) shvars(neutral3_lag1-neutral4_lag5) replace
foreach i of num 2/4{
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war1-neutral5 war3_lag1-allies4_lag5 if class==`i', robust 
est2vec lag_all, addto(lag_all) name(lag_all`i')
*est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5, saving replace path("$thesis/Data/reg_table/dummies") addto(dummies2)
}
est2tex lag_all, preserve dropall path("$thesis/Data/reg_table/allcountry2/alternative") mark(stars) fancy collabels(Coffee Eau~de~vie Sugar Wine) replace

****regress each product separately war pre
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war1-neutral5 war4_pre1-allies5_pre4 if class==1, robust 
est2vec pre_all, e(r2 F) shvars(neutral4_pre1-neutral5_pre4) replace
foreach i of num 2/4{
reg lnvalue year pays_1-pays_12 year_pays_1-year_pays_11 war1-neutral5 war4_pre1-allies5_pre4 if class==`i', robust 
est2vec pre_all, addto(pre_all) name(pre_all`i')
*est2rowlbl pays_1-pays_12 year_pays_1-year_pays_12 pays_class year_class_1-year_class_5 war_class_1- neutral_class_5, saving replace path("$thesis/Data/reg_table/dummies") addto(dummies2)
}
est2tex pre_all, preserve dropall path("$thesis/Data/reg_table/allcountry2/alternative") mark(stars) fancy collabels(Coffee Eau~de~vie Sugar Wine) replace

****reg with lags
areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war1_class1-war5_class5 neutral1_class1-neutral5_class5 war3_lag1_class1-allies4_lag5_class5, absorb(pays_class)
estimate store lag_all
*estout lag_all, cells(b(star fmt(3)))
*estout lag_all using "$thesis/Data/reg_table/allcountry2/excel/alternative_lag.xls", cells(b(star fmt(3)))

****reg with prewar
areg lnvalue year_pays_1-year_pays_12 year_class_1-year_class_5 war1_class1-war5_class5 neutral1_class1-neutral5_class5 war4_pre1_class1-allies5_pre4_class5, absorb(pays_class)
estimate store pre_all
*estout pre_all, cells(b(star fmt(3)))
*estout pre_all using "$thesis/Data/reg_table/allcountry2/excel/alternative_pre.xls", cells(b(star fmt(3)))
 




