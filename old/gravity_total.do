****ESTIMATE GRAVITY MODEL

*****estimate total value of trade wiht no product differentiation******************************************************************
clear
global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

use "$thesis/Data/database_dta/elisa_preestimate_gravity.dta", clear

set more off

drop if year<1733
drop if year>1789


*****estimate total value of trade wiht no product differentiation******************************************************************


drop if sourcetype=="Colonies" | sourcetype=="Divers" | sourcetype=="Divers - in" | sourcetype=="Résumé" | sourcetype=="Local" 
foreach i in 1733/1751{
drop if sourcetype!="Tableau Général" & year==`i'
}
drop if sourcetype!="Objet Général" & year==1752
drop if sourcetype!="Tableau Général" & year==1753

foreach i of num 1754/1761{
drop if sourcetype!="Objet Général" & year==`i'
}

foreach i of num 1762/1766{
drop if sourcetype!="Tableau Général" & year==`i'
}

foreach i of num 1767/1782{
drop if sourcetype!="Objet Général" & year==`i'
}



foreach i of num 1783/1786{
drop if sourcetype!="Tableau Général" & year==`i'
}


collapse (sum) value, by(year pays_regroupes)



*drop if pays_regroupes=="Duché de Bouillon" | pays_regroupes=="Espagne-Portugal" | pays_regroupes=="France" | pays_regroupes=="Petites Îles"

encode pays_regroupes, gen (pays)
gen lnvalue=ln(value)
tab pays, gen(pays_)
label var pays_1 Germany
label var pays_2 England
label var pays_3 Colonies
label var pays_4 Spain
label var pays_5 "Flander and Habsburg Monarchy"

foreach var of varlist pays_1-pays_12{
gen year_`var'=`var'*year
}

label var year_pays_1 "Time trend Germany"
label var year_pays_2 "Time trend England"
label var year_pays_3 "Time trend Colonies"
label var year_pays_4 "Time trend Spain"
label var year_pays_5 "Time trend Flander and Habsburg Monarchy"

******
gen war=0
gen neutral=0
gen allies=0

label var war Allies
label var war Adversary
label var neutral Neutral

****POLISH SUCCESION WAR
foreach i of num 1733/1738{
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="Angleterre" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}



****
gen year_war=year*war
gen year_neutral=neutral*year
gen year_allies=allies*year

label var year_war "Adversary time trend"
label var year_neutral "Neutral time trend"
label var year_allies "Allies time trend"

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies1, e(r2 F) shvars(war neutral) replace

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend1, e(r2 F) shvars(war neutral year_war year_neutral year_allies) replace



****gen lag and pre war effect
 
/*foreach i of num 1/2{
gen war_lag_`i'=0
gen neutral_lag_`i'=0
gen allies_lag_`i'=0
}

***generate lag

foreach i of num 1/2{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1738+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1738+`i')
replace war_lag_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1738+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1738+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1738+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Indes" & year==(1738+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1738+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1738+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1738+`i')

replace allies_lag_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1738+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Espagne" & year==(1738+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Colonies" & year==(1738+`i')
}
*/
**** run regression with lags

*reg lnvalue i.pays year_pays_1-year_pays_12 war neutral war_lag_1-neutral_lag_5, robust 


****AUSTRIAN SUCCESSION WAR - NOT COLONIAL
replace war=0 
replace neutral=0
replace allies=0

****generate dummies austrian war
foreach i of num 1740/1743{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies1, addto(dummies1) name(austrian_a)

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend1, addto(trend1) name(austrian_a)



****gen lag pre war effect

/*foreach i of num 1/4{
replace prewar_`i'=0
replace preneutral_`i'=0
replace preallies_`i'=0
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1740-`i')
replace prewar_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1740-`i')
replace prewar_`i'=1 if pays_regroupes=="Hollande" & year==(1740-`i')
replace prewar_`i'=1 if pays_regroupes=="Italie" & year==(1740-`i')

replace preneutral_`i'=1 if pays_regroupes=="Indes" & year==(1740-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1740-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1740-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1740-`i')

replace preallies_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1740-`i')
replace preallies_`i'=1 if pays_regroupes=="Espagne" & year==(1740-`i')
replace preallies_`i'=1 if pays_regroupes=="Colonies" & year==(1740-`i')
}
*/
**** run regression with pre war effects

*reg lnvalue i.pays year_pays_1-year_pays_12 war neutral prewar_1-preneutral_4, robust 



****AUSTRIAN SUCCESSION WAR - COLONIAL
replace war=0 
replace neutral=0
replace allies=0

****generate dummies austrian war
foreach i of num 1744/1748{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

***gen lag and pre war effect
 
foreach i of num 1/5{
gen war_lag_`i'=0
gen neutral_lag_`i'=0
gen allies_lag_`i'=0
}

**** label pre and lag effect
label var war_lag_1 "1 year lag for adversaries"
label var neutral_lag_1 "1 year lag for neutral"
label var allies_lag_1 "1 year lag for allies"

foreach i of num 2/5{
label var war_lag_`i' "`i' years lag for adversaries"
label var neutral_lag_`i' "`i' years lag for neutral"
label var allies_lag_`i' "`i' years lag for allies"
}

***generate lag

foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')

replace allies_lag_`i'=1 if neutral_lag_`i'==0 & war_lag_`i'==0 & year==(1748+`i')
}


***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies1, addto(dummies1) name(austrian_b)

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend1, addto(trend1) name(austrian_b)


**** run regression with lags

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag1, e(r2 F) shvars(war neutral neutral_lag_1-neutral_lag_5) replace

***


****SEVEN YEARS WAR
replace war=0
replace neutral=0
replace allies=0

foreach i of num 1756/1763{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

****gen lag and pre war effect
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}

foreach i of num 1/4{
gen prewar_`i'=0
gen preneutral_`i'=0
gen preallies_`i'=0
}

codebook value
label var prewar_1 "1 year pre-war for adversaries"
label var preneutral_1 "1 year pre-war for neutral"
label var preallies_1 "1 year pre-war for allies"

foreach i of num 2/4{
label var prewar_`i' "`i' years pre-war for adversaries"
label var preneutral_`i' "`i' years pre-war for neutral"
label var preallies_`i' "`i' years pre-war for allies"
}

***generate lag

foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1763+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1763+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1756-`i')

replace preneutral_`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 & year==(1756-`i')
}

codebook value

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies1, addto(dummies1) name(seven)


***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend1, addto(trend1) name(seven)

**** run regression with lags

reg lnvalue i.pays year_pays_1-year_pays_11 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag1, addto(lag1) name(seven)

**** run regression with pre war effects

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral prewar_1-preallies_4, robust 
est2vec pre1, e(r2 F) shvars(war neutral preneutral_1-preneutral_4) replace




****AMERICAN REVOLUTIONARY WAR
replace war=0
replace neutral=0
replace allies=0

****generate dummies american war
foreach i of num 1778/1782{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'

replace neutral=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

****gen lag pre war effect
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}

foreach i of num 1/4{
replace prewar_`i'=0
replace preneutral_`i'=0
replace preallies_`i'=0
}
***generate lag
foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1782+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1782+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1782+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 & year==(1778-`i')
}

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies1, addto(dummies1) name(american)


***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend1, addto(trend1) name(american)

**** run regression with lags

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag1, addto(lag1) name(american)


**** run regression with pre war effects

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral prewar_1-preallies_4, robust 
est2vec pre1, addto(pre1) name(american)

******ALL WARS TOGETHER

replace war=0
replace neutral=0
replace allies=0

*** gen dummies for polish war
foreach i of num 1733/1738{
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="Angleterre" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
**** generate dummies austrian war not colonial
foreach i of num 1740/1743{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}

**** generate dummies austrian war not colonial
foreach i of num 1744/1748{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}

****generate dummies seven years war
foreach i of num 1756/1763{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}

**** generate dummies american war
foreach i of num 1778/1782{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'

replace neutral=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

****gen lag pre war effect
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}

foreach i of num 1/4{
replace prewar_`i'=0
replace preneutral_`i'=0
replace preallies_`i'=0
}
***generate lag
foreach i of num 1/5{
****austrian war
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 &  year==(1748+`i')

***seven years war
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 &  year==(1763+`i')
****american war

replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1782+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1782+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 &  year==(1782+`i')
}

***generate pre war effect
foreach i of num 1/4{
****seven years war
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 &  year==(1756-`i')

****american war
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 &  year==(1778-`i')

}


***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies1, addto(dummies1) name(all)

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend1, addto(trend1) name(all)


**** run regression with lags

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag1, addto(lag1) name(all)


**** run regression with pre war effects

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral prewar_1-preallies_4, robust 
est2vec pre1, addto(pre1) name(all)


*****save to latex
est2rowlbl pays_1-pays_4 year_pays_1-year_pays_4 war neutral, saving replace path("$thesis/Data/reg_table/allcountry1/dummies") addto(dummies1)
est2tex dummies1, preserve dropall path("$thesis/Data/reg_table/allcountry1/dummies") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace


est2rowlbl pays_1-pays_4 year_pays_1-year_pays_4 year_war year_neutral year_allies neutral war, saving replace path("$thesis/Data/reg_table/allcountry1/trend") addto(trend1)
est2tex trend1, preserve dropall path("$thesis/Data/reg_table/allcountry1/trend") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace


est2rowlbl war neutral war_lag_1-allies_lag_5, saving replace path("$thesis/Data/reg_table/allcountry1/lag") addto(lag1)
est2tex lag1, preserve dropall path("$thesis/Data/reg_table/allcountry1/lag") mark(stars) fancy collabels(Austrian2 Seven~years American All) replace


est2rowlbl war neutral prewar_1-preallies_4, saving replace path("$thesis/Data/reg_table/allcountry1/pre") addto(pre1)
est2tex pre1, preserve dropall path("$thesis/Data/reg_table/allcountry1/pre") mark(stars) fancy collabels(Seven~years American All) replace



****************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************
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
drop pred_value


****rename classification and pays to english 
replace classification_hamburg_large="Coffee" if classification_hamburg_large=="Café"
replace classification_hamburg_large="Eau-de-vie" if classification_hamburg_large=="Eau ; de vie"
replace classification_hamburg_large="Sugar" if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
replace classification_hamburg_large="Wine" if classification_hamburg_large=="Vin ; de France"
replace classification_hamburg_large="ZOther" if classification_hamburg_large=="Other"
collapse (sum) value, by(year pays_regroupes classification_hamburg_large)

encode pays_regroupes, gen (pays)
encode classification_hamburg_large, gen(class)
tab pays, gen(pays_)
tab classification_hamburg_large, gen(class_)

gen lnvalue=ln(value)

foreach var of varlist pays_1-pays_12{
gen year_`var'=`var'*year
}

label var year_pays_1 "Time trend Germany"
label var year_pays_2 "Time trend England"
label var year_pays_3 "Time trend Colonies"
label var year_pays_4 "Time trend Spain"
label var year_pays_5 "Time trend Flander and Habsburg Monarchy"

******
gen war=0
gen neutral=0
gen allies=0

label var war Allies
label var war Adversary
label var neutral Neutral

****POLISH SUCCESION WAR
foreach i of num 1733/1738{
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="Angleterre" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}



****
gen year_war=year*war
gen year_neutral=neutral*year
gen year_allies=allies*year

label var year_war "Adversary time trend"
label var year_neutral "Neutral time trend"
label var year_allies "Allies time trend"

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral, robust 
est2vec dummies2, e(r2 F) shvars(war neutral) replace

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral year_war year_neutral year_allies, robust 
est2vec trend2, e(r2 F) shvars(war neutral year_war year_neutral) replace



****AUSTRIAN SUCCESSION WAR - NOT COLONIAL
replace war=0 
replace neutral=0
replace allies=0

****generate dummies austrian war
foreach i of num 1740/1743{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral, robust 
est2vec dummies2, addto(dummies2) name(austrian_a)

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral year_war year_neutral year_allies, robust 
est2vec trend2, addto(trend2) name(austrian_a)


****AUSTRIAN SUCCESSION WAR - COLONIAL
replace war=0 
replace neutral=0
replace allies=0

****generate dummies austrian war
foreach i of num 1744/1748{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

***gen lag and pre war effect
 
foreach i of num 1/5{
gen war_lag_`i'=0
gen neutral_lag_`i'=0
gen allies_lag_`i'=0
}

**** label pre and lag effect
label var war_lag_1 "1 year lag for adversaries"
label var neutral_lag_1 "1 year lag for neutral"
label var allies_lag_1 "1 year lag for allies"

foreach i of num 2/5{
label var war_lag_`i' "`i' years lag for adversaries"
label var neutral_lag_`i' "`i' years lag for neutral"
label var allies_lag_`i' "`i' years lag for allies"
}

***generate lag

foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')

replace allies_lag_`i'=1 if neutral_lag_`i'==0 & war_lag_`i'==0 & year==(1748+`i')
}


***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral, robust 
est2vec dummies2, addto(dummies2) name(austrian_b)

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral year_war year_neutral year_allies, robust 
est2vec trend2, addto(trend2) name(austrian_b)


**** run regression with lags

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag2, e(r2 F) shvars(war neutral neutral_lag_1-neutral_lag_5) replace

***


****SEVEN YEARS WAR
replace war=0
replace neutral=0
replace allies=0

foreach i of num 1756/1763{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

****gen lag and pre war effect
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}

foreach i of num 1/4{
gen prewar_`i'=0
gen preneutral_`i'=0
gen preallies_`i'=0
}

codebook value
label var prewar_1 "1 year pre-war for adversaries"
label var preneutral_1 "1 year pre-war for neutral"
label var preallies_1 "1 year pre-war for allies"

foreach i of num 2/4{
label var prewar_`i' "`i' years pre-war for adversaries"
label var preneutral_`i' "`i' years pre-war for neutral"
label var preallies_`i' "`i' years pre-war for allies"
}

***generate lag

foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1763+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1763+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1756-`i')

replace preneutral_`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 & year==(1756-`i')
}

codebook value

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral, robust 
est2vec dummies2, addto(dummies2) name(seven)


***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral year_war year_neutral year_allies, robust 
est2vec trend2, addto(trend2) name(seven)

**** run regression with lags

reg lnvalue i.pays year_pays_1-year_pays_11 class_1-class_4 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag2, addto(lag2) name(seven)

**** run regression with pre war effects

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral prewar_1-preallies_4, robust 
est2vec pre2, e(r2 F) shvars(war neutral preneutral_1-preneutral_4) replace




****AMERICAN REVOLUTIONARY WAR
replace war=0
replace neutral=0
replace allies=0

****generate dummies american war
foreach i of num 1778/1782{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'

replace neutral=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

****gen lag pre war effect
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}

foreach i of num 1/4{
replace prewar_`i'=0
replace preneutral_`i'=0
replace preallies_`i'=0
}
***generate lag
foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1782+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1782+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1782+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 & year==(1778-`i')
}

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral, robust 
est2vec dummies2, addto(dummies2) name(american)


***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral year_war year_neutral year_allies, robust 
est2vec trend2, addto(trend2) name(american)

**** run regression with lags

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag2, addto(lag2) name(american)


**** run regression with pre war effects

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral prewar_1-preallies_4, robust 
est2vec pre2, addto(pre2) name(american)

******ALL WARS TOGETHER

replace war=0
replace neutral=0
replace allies=0

*** gen dummies for polish war
foreach i of num 1733/1738{
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="Angleterre" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
**** generate dummies austrian war not colonial
foreach i of num 1740/1743{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}

**** generate dummies austrian war not colonial
foreach i of num 1744/1748{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}

****generate dummies seven years war
foreach i of num 1756/1763{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}

**** generate dummies american war
foreach i of num 1778/1782{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'

replace neutral=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

****gen lag pre war effect
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}

foreach i of num 1/4{
replace prewar_`i'=0
replace preneutral_`i'=0
replace preallies_`i'=0
}
***generate lag
foreach i of num 1/5{
****austrian war
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 &  year==(1748+`i')

***seven years war
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 &  year==(1763+`i')
****american war

replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1782+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1782+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 &  year==(1782+`i')
}

***generate pre war effect
foreach i of num 1/4{
****seven years war
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 &  year==(1756-`i')

****american war
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 &  year==(1778-`i')

}


***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral, robust 
est2vec dummies2, addto(dummies2) name(all)

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral year_war year_neutral year_allies, robust 
est2vec trend2, addto(trend2) name(all)


**** run regression with lags

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag2, addto(lag2) name(all)


**** run regression with pre war effects

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 class_1-class_4 war neutral prewar_1-preallies_4, robust 
est2vec pre2, addto(pre2) name(all)


*****save to latex
est2rowlbl pays_1-pays_4 year_pays_1-year_pays_4 war neutral, saving replace path("$thesis/Data/reg_table/allcountry1/dummies") addto(dummies2)
est2tex dummies2, preserve dropall path("$thesis/Data/reg_table/allcountry1/dummies") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace


est2rowlbl pays_1-pays_4 year_pays_1-year_pays_4 year_war year_neutral year_allies neutral war, saving replace path("$thesis/Data/reg_table/allcountry1/trend") addto(trend2)
est2tex trend2, preserve dropall path("$thesis/Data/reg_table/allcountry1/trend") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace


est2rowlbl war neutral war_lag_1-allies_lag_5, saving replace path("$thesis/Data/reg_table/allcountry1/lag") addto(lag2)
est2tex lag2, preserve dropall path("$thesis/Data/reg_table/allcountry1/lag") mark(stars) fancy collabels(Austrian2 Seven~years American All) replace


est2rowlbl war neutral prewar_1-preallies_4, saving replace path("$thesis/Data/reg_table/allcountry1/pre") addto(pre2)
est2tex pre2, preserve dropall path("$thesis/Data/reg_table/allcountry1/pre") mark(stars) fancy collabels(Seven~years American All) replace




************************************************ROBUSTNESS*************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

use "$thesis/Data/database_dta/elisa_preestimate_gravity.dta", clear

set more off

drop if year>1789

drop if sourcetype=="Colonies" | sourcetype=="Divers" | sourcetype=="Divers - in" | sourcetype=="Résumé" | sourcetype=="Local" 
foreach i in 1716/1751{
drop if sourcetype!="Tableau Général" & year==`i'
}
drop if sourcetype!="Objet Général" & year==1752
drop if sourcetype!="Tableau Général" & year==1753

foreach i of num 1754/1761{
drop if sourcetype!="Objet Général" & year==`i'
}

foreach i of num 1762/1766{
drop if sourcetype!="Tableau Général" & year==`i'
}

foreach i of num 1767/1782{
drop if sourcetype!="Objet Général" & year==`i'
}


collapse (sum) value, by(year pays_regroupes)

egen _count=count(value), by(pays_regroupes)
drop if _count<10
drop _count
drop if pays_regroupes=="France" 

*drop if pays_regroupes=="Duché de Bouillon" | pays_regroupes=="Espagne-Portugal" | pays_regroupes=="France" | pays_regroupes=="Petites Îles"

encode pays_regroupes, gen (pays)
gen lnvalue=ln(value)
tab pays, gen(pays_)
label var pays_1 Germany
label var pays_2 England
label var pays_3 Colonies
label var pays_4 Spain
label var pays_5 "Flander and Habsburg Monarchy"

foreach var of varlist pays_1-pays_12{
gen year_`var'=`var'*year
}

label var year_pays_1 "Time trend Germany"
label var year_pays_2 "Time trend England"
label var year_pays_3 "Time trend Colonies"
label var year_pays_4 "Time trend Spain"
label var year_pays_5 "Time trend Flander and Habsburg Monarchy"

******
gen war=0
gen neutral=0
gen allies=0

label var war Allies
label var war Adversary
label var neutral Neutral

****POLISH SUCCESION WAR
foreach i of num 1733/1738{
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="Angleterre" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}



****
gen year_war=year*war
gen year_neutral=neutral*year
gen year_allies=allies*year

label var year_war "Adversary time trend"
label var year_neutral "Neutral time trend"
label var year_allies "Allies time trend"

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies3, e(r2 F) shvars(pays_1-pays_4 year_pays_1-year_pays_4 war neutral) replace

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend3, e(r2 F) shvars(pays_1-pays_2 year_pays_1-year_pays_2 war neutral year_war year_neutral year_allies) replace



****AUSTRIAN SUCCESSION WAR - NOT COLONIAL
replace war=0 
replace neutral=0
replace allies=0

****generate dummies austrian war
foreach i of num 1740/1743{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies3, addto(dummies3) name(austrian_a)

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend3, addto(trend3) name(austrian_a)


****AUSTRIAN SUCCESSION WAR - COLONIAL
replace war=0 
replace neutral=0
replace allies=0

****generate dummies austrian war
foreach i of num 1744/1748{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if war==0 & neutral==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

***gen lag and pre war effect
 
foreach i of num 1/5{
gen war_lag_`i'=0
gen neutral_lag_`i'=0
gen allies_lag_`i'=0
}

**** label pre and lag effect
label var war_lag_1 "1 year lag for adversaries"
label var neutral_lag_1 "1 year lag for neutral"
label var allies_lag_1 "1 year lag for allies"

foreach i of num 2/5{
label var war_lag_`i' "`i' years lag for adversaries"
label var neutral_lag_`i' "`i' years lag for neutral"
label var allies_lag_`i' "`i' years lag for allies"
}

***generate lag

foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')

replace allies_lag_`i'=1 if neutral_lag_`i'==0 & war_lag_`i'==0 & year==(1748+`i')
}


***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies3, addto(dummies3) name(austrian_b)

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend3, addto(trend3) name(austrian_b)


**** run regression with lags

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag3, e(r2 F) shvars(war neutral war_lag_1-allies_lag_5) replace

***


****SEVEN YEARS WAR
replace war=0
replace neutral=0
replace allies=0

foreach i of num 1756/1763{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

****gen lag and pre war effect
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}

foreach i of num 1/4{
gen prewar_`i'=0
gen preneutral_`i'=0
gen preallies_`i'=0
}

codebook value
label var prewar_1 "1 year pre-war for adversaries"
label var preneutral_1 "1 year pre-war for neutral"
label var preallies_1 "1 year pre-war for allies"

foreach i of num 2/4{
label var prewar_`i' "`i' years pre-war for adversaries"
label var preneutral_`i' "`i' years pre-war for neutral"
label var preallies_`i' "`i' years pre-war for allies"
}

***generate lag

foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1763+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1763+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1756-`i')

replace preneutral_`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 & year==(1756-`i')
}

codebook value

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies3, addto(dummies3) name(seven)


***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend3, addto(trend3) name(seven)

**** run regression with lags

reg lnvalue i.pays year_pays_1-year_pays_11 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag3, addto(lag3) name(seven)

**** run regression with pre war effects

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral prewar_1-preallies_4, robust 
est2vec pre3, e(r2 F) shvars(war neutral prewar_1-preallies_4) replace




****AMERICAN REVOLUTIONARY WAR
replace war=0
replace neutral=0
replace allies=0

****generate dummies american war
foreach i of num 1778/1781{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'

replace neutral=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

****gen lag pre war effect
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}

foreach i of num 1/4{
replace prewar_`i'=0
replace preneutral_`i'=0
replace preallies_`i'=0
}
***generate lag
foreach i of num 1/5{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1781+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1781+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1781+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1781+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1781+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1781+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1781+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 & year==(1781+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 & year==(1778-`i')
}

***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies3, addto(dummies3) name(american)


***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend3, addto(trend3) name(american)

**** run regression with lags

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag3, addto(lag3) name(american)


**** run regression with pre war effects

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral prewar_1-preallies_4, robust 
est2vec pre3, addto(pre3) name(american)

******ALL WARS TOGETHER

replace war=0
replace neutral=0
replace allies=0

*** gen dummies for polish war
foreach i of num 1733/1738{
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'
replace neutral=1 if pays_regroupes=="Angleterre" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
**** generate dummies austrian war not colonial
foreach i of num 1740/1748{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'

replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}


****generate dummies seven years war
foreach i of num 1756/1763{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}

**** generate dummies american war
foreach i of num 1778/1782{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'

replace neutral=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'
replace neutral=1 if pays_regroupes=="Portugal" & year==`i'

replace allies=1 if neutral==0 & war==0 & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_neutral=neutral*year
replace year_allies=allies*year

****gen lag pre war effect
 
foreach i of num 1/5{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}

foreach i of num 1/4{
replace prewar_`i'=0
replace preneutral_`i'=0
replace preallies_`i'=0
}
***generate lag
foreach i of num 1/5{
****austrian war
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 &  year==(1748+`i')

***seven years war
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 &  year==(1763+`i')
****american war

replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1782+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1782+`i')

replace allies_lag_`i'=1 if war_lag_`i'==0 & neutral_lag_`i'==0 &  year==(1782+`i')
}

***generate pre war effect
foreach i of num 1/4{
****seven years war
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 &  year==(1756-`i')

****american war
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')

replace preallies_`i'=1 if prewar_`i'==0 & preneutral_`i'==0 &  year==(1778-`i')

}


***regress with time trend, fe and war dummies
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral, robust 
est2vec dummies3, addto(dummies3) name(all)

***regress with time trend, fe and war dummies with time trends
reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral year_war year_neutral year_allies, robust 
est2vec trend3, addto(trend3) name(all)


**** run regression with lags

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral war_lag_1-allies_lag_5, robust 
est2vec lag3, addto(lag3) name(all)


**** run regression with pre war effects

reg lnvalue pays_1-pays_11 year_pays_1-year_pays_11 war neutral prewar_1-preallies_4, robust 
est2vec pre3, addto(pre3) name(all)


*****save to latex
est2rowlbl pays_1-pays_4 year_pays_1-year_pays_4 war neutral, saving replace path("$thesis/Data/reg_table/allcountry1/dummies") addto(dummies3)
est2tex dummies3, preserve dropall path("$thesis/Data/reg_table/allcountry1/dummies") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace


est2rowlbl pays_1-pays_4 year_pays_1-year_pays_4 year_war year_neutral year_allies neutral war, saving replace path("$thesis/Data/reg_table/trend") addto(trend3)
est2tex trend3, preserve dropall path("$thesis/Data/reg_table/allcountry1/trend") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace


est2rowlbl war neutral war_lag_1-allies_lag_5, saving replace path("$thesis/Data/reg_table/allcountry1/lag") addto(lag3)
est2tex lag3, preserve dropall path("$thesis/Data/reg_table/allcountry1/lag") mark(stars) fancy collabels(Austrian2 Seven~years American All) replace


est2rowlbl war neutral prewar_1-preallies_4, saving replace path("$thesis/Data/reg_table/pre") addto(pre3)
est2tex pre3, preserve dropall path("$thesis/Data/reg_table/allcountry1/pre") mark(stars) fancy collabels(Seven~years American All) replace


********************************************************************************************************************************
*********************************************************ALTERNATIVE***********************************************************************
********************************************************************************************************************************


use "$thesis/Data/database_dta/elisa_preestimate_gravity.dta", clear

set more off
drop if year<1733
drop if year>1789

drop if sourcetype=="Colonies" | sourcetype=="Divers" | sourcetype=="Divers - in" | sourcetype=="Résumé" | sourcetype=="Local" 
foreach i in 1716/1751{
drop if sourcetype!="Tableau Général" & year==`i'
}
drop if sourcetype!="Objet Général" & year==1752
drop if sourcetype!="Tableau Général" & year==1753

foreach i of num 1754/1761{
drop if sourcetype!="Objet Général" & year==`i'
}

foreach i of num 1762/1766{
drop if sourcetype!="Tableau Général" & year==`i'
}

foreach i of num 1767/1782{
drop if sourcetype!="Objet Général" & year==`i'
}

collapse (sum) value, by(year pays_regroupes)

egen _count=count(value), by(pays_regroupes)
drop if _count<10
drop _count
drop if pays_regroupes=="France" 

*drop if pays_regroupes=="Duché de Bouillon" | pays_regroupes=="Espagne-Portugal" | pays_regroupes=="France" | pays_regroupes=="Petites Îles"

encode pays_regroupes, gen (pays)
gen lnvalue=ln(value)
tab pays, gen(pays_)
label var pays_1 Germany
label var pays_2 England
label var pays_3 Colonies
label var pays_4 Spain
label var pays_5 "Flander and Habsburg Monarchy"

foreach var of varlist pays_1-pays_12{
gen year_`var'=`var'*year
}

label var year_pays_1 "Time trend Germany"
label var year_pays_2 "Time trend England"
label var year_pays_3 "Time trend Colonies"
label var year_pays_4 "Time trend Spain"
label var year_pays_5 "Time trend Flander and Habsburg Monarchy"

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
***al wars
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
gen neutral3_lag`i'=0
replace neutral3_lag`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral3_lag`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral3_lag`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')
replace neutral3_lag`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral3_lag`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')
label var neutral3_lag`i' "Austrian2: lag `i'"
}
foreach i of num 1/5{
gen neutral4_lag`i'=0
replace neutral4_lag`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral4_lag`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral4_lag`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')
replace neutral4_lag`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral4_lag`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
label var neutral4_lag`i' "Seven: lag `i'"
}
***all wars
foreach i of num 1/5{
gen war6_lag`i'=0
replace war6_lag`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war6_lag`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1748+`i')
replace war6_lag`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')

replace war6_lag`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war6_lag`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')
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

label var neutral6_lag`i' "All: lag `i'"
}

foreach i of num 1/5{
gen allies3_lag`i'=0
replace allies3_lag`i'=1 if war3_lag`i'==0 & neutral3_lag`i'==0 & year==(1748+`i')
}
foreach i of num 1/5{
gen allies4_lag`i'=0
replace allies4_lag`i'=1 if war3_lag`i'==0 & neutral3_lag`i'==0 & year==(1748+`i')
}

foreach i of num 1/5{
gen allies6_lag`i'=0
replace allies6_lag`i'=1 if war6_lag`i'==0 & neutral6_lag`i'==0 & year==(1748+`i')
replace allies6_lag`i'=1 if war6_lag`i'==0 & neutral6_lag`i'==0 & year==(1763+`i')
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
gen neutral4_pre`i'=0
replace neutral4_pre`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace neutral4_pre`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace neutral4_pre`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace neutral4_pre`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace neutral4_pre`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')
label var neutral4_pre`i' "Seven: pre `i'"
}
foreach i of num 1/4{
gen neutral5_pre`i'=0
replace neutral5_pre`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1778-`i')
replace neutral5_pre`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace neutral5_pre`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace neutral5_pre`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace neutral5_pre`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')
replace neutral5_pre`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')
label var neutral5_pre`i' "American: pre `i'"
}
***all wars
foreach i of num 1/4{
gen war6_pre`i'=0
replace war6_pre`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace war6_pre`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')
replace war6_pre`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1756-`i')

replace war6_pre`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')
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

label var neutral6_pre`i' "All: pre `i'"
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

****reg with dummies: 
reg lnvalue i.pays year_pays_1-year_pays_12 war6 neutral6
est2vec reg1_dummies, e(r2 F) shvars(neutral6 neutral1-neutral5) replace

reg lnvalue i.pays year_pays_1-year_pays_12 war1-war5 neutral1-neutral5
est2vec reg1_dummies, addto(reg1_dummies) name(reg1_dummies)

poisson value i.pays year_pays_1-year_pays_12 war6 neutral6
est2vec reg1_dummies, addto(reg1_dummies) name(ppml1)

poisson value i.pays year_pays_1-year_pays_12 war1-war5 neutral1-neutral5
est2vec reg1_dummies, addto(reg1_dummies) name(ppml2)

est2rowlbl neutral1-neutral6, saving replace path("$thesis/Data/reg_table/allcountry1/alternative") addto(reg1_dummies)
est2tex reg1_dummies, preserve dropall path("$thesis/Data/reg_table/allcountry1/alternative") mark(stars) fancy label collabels(All War~by~War PPML PPML~war~by~war) replace



****reg with lag
reg lnvalue i.pays year_pays_1-year_pays_12 war6 neutral6 war6_lag1-neutral6_lag5 
est2vec reg1_lag, e(r2 F) shvars(neutral6_lag1-neutral6_lag5 neutral3_lag1-neutral4_lag5) replace

reg lnvalue i.pays year_pays_1-year_pays_12 war1-war5 neutral1-neutral5 war3_lag1-neutral4_lag5 
est2vec reg1_lag, addto(reg1_lag) name(reg1_lag)

est2rowlbl neutral6_lag1-neutral6_lag5 neutral3_lag1-neutral4_lag5, saving replace path("$thesis/Data/reg_table/allcountry1/alternative") addto(reg1_lag)
est2tex reg1_lag, preserve dropall path("$thesis/Data/reg_table/allcountry1/alternative") mark(stars) fancy label collabels(All War~by~War) replace


****reg with pre
reg lnvalue i.pays year_pays_1-year_pays_12 war6 neutral6 war6_pre1-neutral6_pre4
est2vec reg1_pre, e(r2 F) shvars(neutral6_pre1-neutral6_pre4 neutral4_pre1-neutral5_pre4) replace


reg lnvalue i.pays year_pays_1-year_pays_12 war1-war5 neutral1-neutral5 war4_pre1-neutral5_pre4
est2vec reg1_pre, addto(reg1_pre) name(reg1_pre)

est2rowlbl neutral6_pre1-neutral6_pre4 neutral4_pre1-neutral5_pre4, saving replace path("$thesis/Data/reg_table/allcountry1/alternative") addto(reg1_pre)
est2tex reg1_pre, preserve dropall path("$thesis/Data/reg_table/allcountry1/alternative") mark(stars) fancy label collabels(All War~by~War) replace






