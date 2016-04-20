****ESTIMATE GRAVITY MODEL

use "$thesis/Data/database_dta/elisa_preestimate_gravity.dta", clear

set more off

drop if year<1733
drop if year>1789


*****estimate total value of trade wiht no product differentiation
drop if sourcetype=="Colonies" | sourcetype=="Divers" | sourcetype=="Divers - in" | sourcetype=="Résumé" | sourcetype=="Local" 
foreach i in 1749 1750 1751 1789{
drop if sourcetype!="National par direction" & year==`i'
}
foreach i of num 1752/1761{
drop if sourcetype!="Objet Général" & year==`i'
}

foreach i of num 1767/1788{
drop if sourcetype!="Objet Général" & year==`i'
}

codebook value

collapse (sum) value, by(year pays_regroupes)

egen _count=count(value), by(pays_regroupes)
drop if _count<10
drop _count
drop if pays_regroupes=="France" 

*drop if pays_regroupes=="Duché de Bouillon" | pays_regroupes=="Espagne-Portugal" | pays_regroupes=="France" | pays_regroupes=="Petites Îles"

encode pays_regroupes, gen (pays)
gen lnvalue=ln(value)
tab pays, gen(pays_)

foreach var of varlist pays_1-pays_12{
gen year_`var'=`var'*year
}

******
gen war=0
gen neutral=0
gen allies=0

****generate dummies for seven years war
foreach i of num 1756/1763{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Indes" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
replace allies=1 if pays_regroupes=="Espagne" & year==`i'
replace allies=1 if pays_regroupes=="Colonies" & year==`i'
}
codebook year
****
gen year_war=year*war
gen year_allies=year*allies
gen year_neutral=neutral*year

***regress with time trend, fe and war dummies
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies, robust 

***regress with time trend, fe and war dummies with time trends
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies year_war year_allies year_neutral, robust 


****gen lag pre war effect
 
foreach i of num 1/10{
gen war_lag_`i'=0
gen neutral_lag_`i'=0
gen allies_lag_`i'=0
}

foreach i of num 1/4{
gen prewar_`i'=0
gen preneutral_`i'=0
gen preallies_`i'=0
}
***generate lag

foreach i of num 1/10{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1763+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Indes" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')

replace allies_lag_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1763+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Espagne" & year==(1763+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Colonies" & year==(1763+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1756-`i')

replace preneutral_`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Indes" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')

replace preallies_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1756-`i')
replace preallies_`i'=1 if pays_regroupes=="Espagne" & year==(1756-`i')
replace preallies_`i'=1 if pays_regroupes=="Colonies" & year==(1756-`i')
}

codebook value

**** run regression with lags

reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies war_lag_1-allies_lag_10, robust 

**** run regression with pre war effects

reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies prewar_1-preallies_4, robust 



****AUSTRIAN SUCCESSION WAR
replace war=0
replace neutral=0
replace allies=0

****generate dummies austrian war
foreach i of num 1740/1748{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace war=1 if pays_regroupes=="Hollande" & year==`i'
replace war=1 if pays_regroupes=="Italie" & year==`i'

replace neutral=1 if pays_regroupes=="Indes" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
replace allies=1 if pays_regroupes=="Espagne" & year==`i'
replace allies=1 if pays_regroupes=="Colonies" & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_allies=year*allies
replace year_neutral=neutral*year

***regress with time trend, fe and war dummies
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies, robust 

***regress with time trend, fe and war dummies with time trends
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies year_war year_allies year_neutral, robust 


****gen lag pre war effect
 
foreach i of num 1/10{
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
foreach i of num 1/10{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Flandre et autres états de l'Empereur" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Indes" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')

replace allies_lag_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1748+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Espagne" & year==(1748+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Colonies" & year==(1748+`i')
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

codebook value

**** run regression with lags

reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies war_lag_1-allies_lag_10, robust 

**** run regression with pre war effects

reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies prewar_1-preallies_4, robust 


****AMERICAN REVOLUTIONARY WAR
replace war=0
replace neutral=0
replace allies=0

****generate dummies american war
foreach i of num 1778/1781{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'

replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Indes" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'
replace allies=1 if pays_regroupes=="Espagne" & year==`i'
replace allies=1 if pays_regroupes=="Colonies" & year==`i'
replace allies=1 if pays_regroupes=="Hollande" & year==`i'
}
codebook year
****
replace year_war=year*war
replace year_allies=year*allies
replace year_neutral=neutral*year

***regress with time trend, fe and war dummies
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies, robust 

***regress with time trend, fe and war dummies with time trends
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies year_war year_allies year_neutral, robust 


****gen lag pre war effect
 
foreach i of num 1/7{
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
foreach i of num 1/7{
replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1781+`i')
replace war_lag_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1781+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1781+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Indes" & year==(1781+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1781+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1781+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1781+`i')

replace allies_lag_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1781+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Espagne" & year==(1781+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Colonies" & year==(1781+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1781+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')
replace prewar_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1778-`i')

replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Indes" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')

replace preallies_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1778-`i')
replace preallies_`i'=1 if pays_regroupes=="Espagne" & year==(1778-`i')
replace preallies_`i'=1 if pays_regroupes=="Colonies" & year==(1778-`i')
replace preallies_`i'=1 if pays_regroupes=="Hollande" & year==(1778-`i')

}

codebook value

**** run regression with lags

reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies war_lag_1-allies_lag_10, robust 

**** run regression with pre war effects

reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies prewar_1-preallies_4, robust 





*****estimate value of trade for major products************************************************************************************* 

use "$thesis/Data/database_dta/elisa_preestimate_gravity.dta", clear

drop if year<1733
drop if year>1789

drop if sourcetype=="Colonies" | sourcetype=="Divers" | sourcetype=="Divers - in" | sourcetype=="Résumé" 
foreach i in 1749 1750 1751 1789{
drop if sourcetype!="National par direction" & year==`i'
}
foreach i of num 1752/1789{
drop if sourcetype!="Objet Général" & year==`i'
}

codebook value

drop if pays_regroupes=="Duché de Bouillon" | pays_regroupes=="Espagne-Portugal" | pays_regroupes=="France" | pays_regroupes=="Petites Îles"
replace classification_hamburg_large="other" if classification_hamburg_large!="Café" & classification_hamburg_large!="Eau ; de vie" & classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Vin ; de France" 

collapse (sum) value, by(year classification_hamburg_large pays_regroupes)

encode classification_hamburg_large, gen(class)
encode pays_regroupes, gen (pays)

gen lnvalue=ln(value)

tab pays, gen(pays_)

foreach var of varlist pays_1-pays_13{
gen year_`var'=`var'*year
}

tab class, gen(class_)

foreach var of varlist class_1-class_5{
gen year_`var'=year*`var'
}
******
gen war=0
gen neutral=0
gen allies=0

****
foreach i of num 1756/1763{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Indes" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
replace allies=1 if pays_regroupes=="Espagne" & year==`i'
replace allies=1 if pays_regroupes=="Colonies" & year==`i'
}


codebook year
****
gen year_war=year*war
gen year_allies=year*allies
gen year_neutral=neutral*year

***regress with time trend, fe and war dummies
foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_13 war neutral allies, robust if class==`i'
}

codebook year

***regress with time trend, fe and war dummies with time trends
foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_13 war neutral allies year_war year_allies year_neutral if class==`i', robust 
}

****gen product dummy
foreach i of num 1/5{
gen war_class_`i'=war*class_`i'
gen allies_class_`i'=allies*class_`i'
gen neutral_class_`i'=neutral*class_`i'
}

foreach i of num 1/5{
gen year_war_class_`i'=war*class_`i'*year
gen year_neutral_class_`i'=neutral*class_`i'*year
gen year_allies_class_`i'=allies*class_`i'*year
}

****gen war lag and neutral lag
 
foreach i of num 1/10{
gen war_lag_`i'=0
gen neutral_lag_`i'=0
gen allies_lag_`i'=0
}
***
foreach i of num 1/10{

replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1763+`i')
replace war_lag_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1763+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Indes" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1763+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1763+`i')

replace allies_lag_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1763+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Espagne" & year==(1763+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Colonies" & year==(1763+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1756-`i')
replace prewar_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1756-`i')

replace preneutral_`i'=1 if pays_regroupes=="Hollande" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Indes" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1756-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1756-`i')

replace preallies_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1756-`i')
replace preallies_`i'=1 if pays_regroupes=="Espagne" & year==(1756-`i')
replace preallies_`i'=1 if pays_regroupes=="Colonies" & year==(1756-`i')
}

codebook value

**** run regression with lags

foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies war_lag_1-allies_lag_10 if class==`i', robust 
}

**** run regression with pre war effects
foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies prewar_1-preallies_4 if class==`i', robust 
}

codebook value

*********************AUSTRIAN SUCCESION WAR

replace war=0
replace neutral=0
replace allies=0

****
foreach i of num 1740/1748{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Indes" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
replace allies=1 if pays_regroupes=="Espagne" & year==`i'
replace allies=1 if pays_regroupes=="Colonies" & year==`i'
}


codebook year
****
replace year_war=year*war
replace year_allies=year*allies
replace year_neutral=neutral*year

***regress with time trend, fe and war dummies
foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_13 war neutral allies, robust if class==`i'
}

codebook year

***regress with time trend, fe and war dummies with time trends
foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_13 war neutral allies year_war year_allies year_neutral if class==`i', robust 
}

****gen product dummy
foreach i of num 1/5{
replace war_class_`i'=war*class_`i'
replace allies_class_`i'=allies*class_`i'
replace neutral_class_`i'=neutral*class_`i'
}

foreach i of num 1/5{
replace year_war_class_`i'=war*class_`i'*year
replace year_neutral_class_`i'=neutral*class_`i'*year
replace year_allies_class_`i'=allies*class_`i'*year
}

****gen war lag and neutral lag
 
foreach i of num 1/10{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}
***
foreach i of num 1/10{

replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1748+`i')
replace war_lag_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Indes" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1748+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1748+`i')

replace allies_lag_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1748+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Espagne" & year==(1748+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Colonies" & year==(1748+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1740-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1740-`i')
replace prewar_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1740-`i')

replace preneutral_`i'=1 if pays_regroupes=="Hollande" & year==(1740-`i')
replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1740-`i')
replace preneutral_`i'=1 if pays_regroupes=="Indes" & year==(1740-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1740-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1740-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1740-`i')

replace preallies_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1740-`i')
replace preallies_`i'=1 if pays_regroupes=="Espagne" & year==(1740-`i')
replace preallies_`i'=1 if pays_regroupes=="Colonies" & year==(1740-`i')
}

codebook value

**** run regression with lags

foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies war_lag_1-allies_lag_10 if class==`i', robust 
}

**** run regression with pre war effects
foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies prewar_1-preallies_4 if class==`i', robust 
}

codebook value


*********************AMERICAN REVOLUTIONARY WAR

replace war=0
replace neutral=0
replace allies=0

****
foreach i of num 1778/1782{
replace war=1 if pays_regroupes=="Angleterre" & year==`i'
replace war=1 if pays_regroupes=="Portugal" & year==`i'
replace war=1 if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace neutral=1 if pays_regroupes=="Hollande" & year==`i'
replace neutral=1 if pays_regroupes=="Italie" & year==`i'
replace neutral=1 if pays_regroupes=="Indes" & year==`i'
replace neutral=1 if pays_regroupes=="Levant" & year==`i'
replace neutral=1 if pays_regroupes=="Nord" & year==`i'
replace neutral=1 if pays_regroupes=="Suisse" & year==`i'

replace allies=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
replace allies=1 if pays_regroupes=="Espagne" & year==`i'
replace allies=1 if pays_regroupes=="Colonies" & year==`i'
}


codebook year
****
replace year_war=year*war
replace year_allies=year*allies
replace year_neutral=neutral*year

***regress with time trend, fe and war dummies
foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_13 war neutral allies, robust if class==`i'
}

codebook year

***regress with time trend, fe and war dummies with time trends
foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_13 war neutral allies year_war year_allies year_neutral if class==`i', robust 
}

****gen product dummy
foreach i of num 1/5{
replace war_class_`i'=war*class_`i'
replace allies_class_`i'=allies*class_`i'
replace neutral_class_`i'=neutral*class_`i'
}

foreach i of num 1/5{
replace year_war_class_`i'=war*class_`i'*year
replace year_neutral_class_`i'=neutral*class_`i'*year
replace year_allies_class_`i'=allies*class_`i'*year
}

****gen war lag and neutral lag
 
foreach i of num 1/10{
replace war_lag_`i'=0
replace neutral_lag_`i'=0
replace allies_lag_`i'=0
}
***
foreach i of num 1/10{

replace war_lag_`i'=1 if pays_regroupes=="Angleterre" & year==(1782+`i')
replace war_lag_`i'=1 if pays_regroupes=="Portugal" & year==(1782+`i')
replace war_lag_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & 1782==(1748+`i')

replace neutral_lag_`i'=1 if pays_regroupes=="Hollande" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Italie" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Indes" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Levant" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Nord" & year==(1782+`i')
replace neutral_lag_`i'=1 if pays_regroupes=="Suisse" & year==(1782+`i')

replace allies_lag_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1782+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Espagne" & year==(1782+`i')
replace allies_lag_`i'=1 if pays_regroupes=="Colonies" & year==(1782+`i')
}

***generate pre war effect
foreach i of num 1/4{
replace prewar_`i'=1 if pays_regroupes=="Angleterre" & year==(1778-`i')
replace prewar_`i'=1 if pays_regroupes=="Portugal" & year==(1778-`i')
replace prewar_`i'=1 if pays_regroupes=="États-Unis d'Amérique" & year==(1778-`i')

replace preneutral_`i'=1 if pays_regroupes=="Hollande" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Italie" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Indes" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Levant" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Nord" & year==(1778-`i')
replace preneutral_`i'=1 if pays_regroupes=="Suisse" & year==(1778-`i')

replace preallies_`i'=1 if pays_regroupes=="Allemagne et Pologne (par terre)" & year==(1778-`i')
replace preallies_`i'=1 if pays_regroupes=="Espagne" & year==(1778-`i')
replace preallies_`i'=1 if pays_regroupes=="Colonies" & year==(1778-`i')
}

codebook value

**** run regression with lags

foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies war_lag_1-allies_lag_10 if class==`i', robust 
}

**** run regression with pre war effects
foreach i of num 1/5{
reg lnvalue i.pays year_pays_1-year_pays_12 war neutral allies prewar_1-preallies_4 if class==`i', robust 
}

codebook value


























