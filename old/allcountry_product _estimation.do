*** 1)CLEAN INITIAL DATABASE
clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

set more off

***Clean bdd_centrale
insheet using "/$thesis/toflit18_data/base/bdd_centrale.csv", names
save "$thesis/Data/database_dta/bdd_centrale.dta", replace
clear


***Clean bdd_pays

insheet using "/$thesis/toflit18_data/base/bdd_pays.csv", names
rename pays_normalises_orthographique pays_norm_ortho
save "$thesis/Data/database_dta/bdd_pays.dta", replace

clear


***Clean bdd_marchandises_normalisees_orthographique

insheet using "/$thesis/toflit18_data/base/bdd_revised_marchandises_normalisees_orthographique.csv", names
duplicates drop marchandises, force
save "$thesis/Data/database_dta/bdd_marchandises_normalisation_orthographique.dta", replace
clear

***Clean bdd_marchandises_simplifiees

insheet using "/$thesis/toflit18_data/base/bdd_revised_marchandises_simplifiees.csv", names
duplicates drop marchandises_norm_ortho, force
save "$thesis/Data/database_dta/bdd_revised_marchandises_simplifiees.dta", replace
clear

***clean marchandises classification hamburg
insheet using "/$thesis/toflit18_data/base/bdd_revised_classification_hamburg.csv", names
duplicates drop marchandises_simplification, force
save "$thesis/Data/database_dta/bdd_revised_classification_hamburg.dta", replace
clear



**** 2) MERGE

use "$thesis/Data/database_dta/bdd_centrale.dta"

***merge central and pays 
merge m:1 pays using "$thesis/Data/database_dta/bdd_pays.dta"
drop if _merge==2
drop if _merge==1
drop _merge



***clean database
keep if exportsimports=="Exports" |  exportsimports=="Exportations" |  exportsimports=="Export" |  exportsimports=="Sortie" |  exportsimports=="exports" |  exportsimports=="export"
drop if pays_regroupes=="?"


***merge with normalisation orthographique

merge m:1 marchandises using "$thesis/Data/database_dta/bdd_marchandises_normalisation_orthographique.dta"
drop if _merge==2
drop if _merge==1 & sourcetype!="Tableau Général"
drop _merge

***merge with simplification
merge m:1 marchandises_norm_ortho using "$thesis/Data/database_dta/bdd_revised_marchandises_simplifiees.dta"
drop if _merge==2
drop if _merge==1 & sourcetype!="Tableau Général"
drop _merge

***merge with classification
merge m:1 marchandises_simplification using "$thesis/Data/database_dta/bdd_revised_classification_hamburg.dta"
drop if _merge==2
drop if _merge==1 & sourcetype!="Tableau Général"
drop _merge



****destring years
replace year="1806" if year=="An 14 & 1806"
replace year="1805" if year=="An 13"
replace year="1804" if year=="An 12"
replace year="1803" if year=="An 11"
replace year="1802" if year=="An 10"
replace year="1801" if year=="An 9"
replace year="1800" if year=="An 8"
replace year="1799" if year=="An 7"
replace year="1798" if year=="An 6"
replace year="1797" if year=="An 5"
replace year="1792" if year=="1792-1er semestre"
destring year, replace
drop if year==.


***destring values
destring value, replace dpcomma
replace value=value*4.505/1000


****keep only useful variables
collapse (sum) value, by(sourcetype year direction pays_regroupes classification_hamburg_large marchandises_simplification)

save "$thesis/Data/database_dta/elisa_preestimate_gravity.dta", replace
***
use "$thesis/Data/database_dta/elisa_preestimate_gravity.dta", clear

****estimate value of hamburg classification
drop if sourcetype=="Tableau Général"

replace direction="total" if direction==""
replace classification_hamburg_large ="not classified" if classification_hamburg_large ==""
replace classification_hamburg_large="other" if classification_hamburg_large!="Café" & classification_hamburg_large!="Eau ; de vie" & classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Vin ; de France"

collapse (sum) value, by(sourcetype year direction pays_regroupes classification_hamburg_large)

egen _count=count(value), by(pays_regroupes)
drop if _count<21
drop _count
drop if pays_regroupes=="France" 
drop if pays_regroupes=="Indes" 

by direction year, sort: gen nvals = _n == 1
by direction: replace nvals=sum(nvals)
by direction: replace nvals = nvals[_N]
drop if nvals==1
drop nvals


fillin year pays_regroupes direction classification_hamburg_large

encode direction, gen(dir)
encode pays, gen(pays)
encode classification_hamburg_large, gen(class)
gen lnvalue=ln(value)
sort (year) direction
egen _count=sum(value), by(year direction)
replace lnvalue=0 if _count!=0 & value==0
drop _count

foreach i of num 1/5{
foreach j of num 1/12{
gen lnvalue`i'_`j'=lnvalue if class==`i' & pays==`j'
}
}
foreach i of num 1/5{
foreach j of num 1/12{
quietly reg lnvalue`i'_`j' i.year i.dir [iw=value], robust 
predict value2 
gen value3=exp(value2)
gen pred_value`i'_`j'=.
replace pred_value`i'_`j'=value3 if class==`i' & pays==`j' & dir==21
drop value2 value3
}
}
codebook value

gen pred_value=. 
foreach i of num 1/5{
foreach j of num 1/12{
replace pred_value=pred_value`i'_`j' if class==`i' & pays==`j' & dir==21
}
}

codebook value

/*foreach i of num 1/5{
foreach j of num 1/13{
twoway (connected pred_value`i'_`j' year) (connected value year) if pays==`j' & class==`i' & dir==21, title(`: label (pays) `j'') subtitle( `: label (class) `i'')
graph export class`i'_pay`j'.png, as(png) replace
}
}
*/

drop if year<1733
drop if year==1752 |year==1754
drop if year>1753 & year<1762
drop if year>1767 & year<1783
drop if year>1786
keep if dir==21

drop if pays==12
drop if pays==8 
drop if class==1 & pays==10
drop if class==2 & pays==1
drop if class==2 & pays==7
drop if class==2 & pays==10
drop if class==2 & pays==11
drop if class==3 & pays==1
drop if class==3 & pays==2
drop if class==3 & pays==10
drop if class==4 & pays==1
drop if class==4 & pays==7
drop if class==4 & pays==11


collapse (sum) pred_value, by(year classification_hamburg_large pays_regroupes)

save "$thesis/Data/database_dta/allcountry_product_estimation", replace













