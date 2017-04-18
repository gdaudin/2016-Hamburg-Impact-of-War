********************************************************************************
***************************CLEAN AND MERGE DATABASES****************************
********************************************************************************

**** 1) Clean

clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"

set more off

***Clean bdd_centrale
import delimited "$thesis/toflit18_data/base/bdd_centrale.csv", encoding(UTF-8) clear varname(1) stringcols(_all)
save "$thesis/database_dta/bdd_centrale.dta", replace
clear


***Clean bdd_pays

import delimited "$thesis/toflit18_data/base/bdd_pays.csv", encoding(UTF-8) clear varname(1) stringcols(_all)
rename pays_normalises_orthographique pays_norm_ortho
save "$thesis/database_dta/bdd_pays.dta", replace

clear


***Clean bdd_marchandises_normalisees_orthographique

import delimited "$thesis/toflit18_data/base/bdd_marchandises_normalisees_orthographique.csv", encoding(UTF-8) clear varname(1) stringcols(_all)
duplicates drop marchandises, force
save "$thesis/database_dta/bdd_marchandises_normalisees_orthographique.dta", replace
clear

***Clean bdd_marchandises_simplifiees

import delimited "$thesis/toflit18_data/base/bdd_marchandises_simplifiees.csv", encoding(UTF-8) clear varname(1) stringcols(_all)
duplicates drop marchandises_norm_ortho, force
save "$thesis/database_dta/bdd_marchandises_simplifiees.dta", replace
clear

***clean marchandises classification hamburg
import delimited "$thesis/toflit18_data/base/bdd_marchandises_hamburg.csv", encoding(UTF-8) clear varname(1) stringcols(_all)
duplicates drop marchandises_simplification, force
save "$thesis/database_dta/bdd_marchandises_hamburg.dta", replace
clear

***clean sitc
import delimited "$thesis/toflit18_data/base/bdd_marchandises_sitc.csv", encoding(UTF-8) clear varname(1) stringcols(_all)
duplicates drop marchandises_simplification, force
save "$thesis/database_dta/bdd_marchandises_sitc.dta", replace
clear


**** 2) Merge

use "$thesis/database_dta/bdd_centrale.dta"

***merge central and pays 
merge m:1 pays using "$thesis/database_dta/bdd_pays.dta"
drop if _merge==2
drop if _merge==1
drop _merge


***merge with normalisation orthographique

merge m:1 marchandises using "$thesis/database_dta/bdd_marchandises_normalisees_orthographique.dta"
drop if _merge==2
drop if _merge==1 & sourcetype!="Tableau Général"
drop _merge

***merge with simplification
merge m:1 marchandises_norm_ortho using "$thesis/database_dta/bdd_marchandises_simplifiees.dta"
drop if _merge==2
drop if _merge==1 & sourcetype!="Tableau Général"
drop _merge

***merge with classification
merge m:1 marchandises_simplification using "$thesis/database_dta/bdd_marchandises_hamburg.dta"
drop if _merge==2
drop if _merge==1 & sourcetype!="Tableau Général"
drop _merge

***merge with sitc
merge m:1 marchandises_simplification using "$thesis/database_dta/bdd_marchandises_sitc.dta"
drop if _merge==2
drop if _merge==1 & sourcetype!="Tableau Général"
drop _merge



***clean database
keep if exportsimports=="Exports" 
drop if pays_regroupes=="?"


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
replace year="1787" if year=="10 mars-31 décembre 1787"
destring year, replace
drop if year==.

foreach variable of var quantit value prix_unitaire { 
	replace `variable'  =usubinstr(`variable',",",".",.)
	replace `variable'  =usubinstr(`variable'," ","",.)
	replace `variable'  =usubinstr(`variable'," ","",.)
	display "---------Loop-----------------"
}


destring quantit prix_unitaire value, replace

replace value=prix_unitaire*quantit if value==0 & sourcetype=="Local" & prix_unitaire!=. & quantit!=.
drop if sourcetype=="1792-both semestre"
drop if sourcetype=="1792-first semestre"


***eliminate useless variables
collapse (sum) value, by(sourcetype year direction pays_regroupes ///
marchandises_simplification classification_hamburg_large sitc18_rev3)

*******save database for analysis_frhb
save "$thesis/database_dta/elisa_bdd_courante", replace
use "$thesis/database_dta/elisa_bdd_courante", replace

****keep only 5 categories of goods
replace classification_hamburg_large="Not classified" ///
if classification_hamburg_large=="" & sourcetype!="Tableau Général"
drop if classification_hamburg_large=="Blanc ; de baleine" | ///
classification_hamburg_large=="Huile ; de baleine" | classification_hamburg_large=="Minum"
replace classification_hamburg_large="Sugar" if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
replace classification_hamburg_large="Coffee" if classification_hamburg_large=="Café"
replace classification_hamburg_large="Wine" if classification_hamburg_large=="Vin ; de France"
replace classification_hamburg_large="Eau de vie" if classification_hamburg_large=="Eau ; de vie"
replace classification_hamburg_large="Other" if classification_hamburg_large!="Sugar" ///
& classification_hamburg_large!="Coffee" & classification_hamburg_large!="Wine" & classification_hamburg_large!="Eau de vie" 


********************************************************************************
*****************************TEST BENFORD***************************************
********************************************************************************

preserve
drop if value==0
drop if value==.
gen firstdigit = real(substr(string(value), 1, 1))
drop if firstdigit==.
firstdigit value, percent
contract firstdigit
set obs 9 
gen x = _n 
gen expected = log10(1 + 1/x) 
twoway histogram firstdigit [fw=_freq], plotregion(fcolor(white)) graphregion(fcolor(white)) ///
barw(0.5) bfcolor(ltblue) blcolor(navy) discrete fraction || connected expected x, ///
xla(1/9) title("observed and expected") caption("French source") yla(, ang(h) format("%02.1f")) ///
legend(off) plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$thesis/Graph/Benford/benford_fr.png", as(png) replace
restore



********************************************************************************
*************************ESTIMATE VALUES BEFORE 1750****************************
********************************************************************************
preserve 
replace direction="total" if direction==""
drop if sourcetype=="Tableau Général"

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
label define order 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order)
gen lnvalue=ln(value)

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


gen pred_value=. 
foreach i of num 1/5{
foreach j of num 1/12{
replace pred_value=pred_value`i'_`j' if class==`i' & pays==`j' & dir==21
}
}

/*
collapse (sum) pred_value value, by(year pays_regroupes pays direction dir classification_hamburg_large class)
foreach i of num 1/5{
foreach j of num 1/12{
twoway (connected pred_value year) (connected value year) if pays==`j' & class==`i' & ///
dir==21, title(`: label (pays) `j'') subtitle( `: label (class) `i'')
graph export class`i'_pay`j'.png, as(png) replace
}
}
*/

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

collapse (sum) pred_value, by(year pays_regroupes classification_hamburg_large)
save "$thesis/database_dta/product_estimation", replace
restore


********************************************************************************
***************************CREATE 4 DATABASES***********************************
********************************************************************************

/* LEGEND OF SOURCETYPE
- Colonies: 1787, 1788, 1789
- Divers: 1839
- Divers - in: 1783, 1784
- Local: 1718-1741, 1744-1780 
- National par Direction: 1750, 1789
- National par Direction (-): 1749, 1751, 1777, 1787
- Objet Général: 1752, 1754-1761, 1767-1780, 1782, 1787, 1788
- Résumé: 1787-1789, 1797-1821
- Tableau Général: 1716-1775, 1777-1782 (aggregate)
- Tableau de marchandises: 1821
- Tableau des quantités: 1822
*/


collapse (sum) value, by(year sourcetype pays_regroupes classification_hamburg_large sitc18_rev3)
drop if value==0
drop if sourcetype=="Divers"

***** save db with no product differentiation
preserve
foreach i of num 1716/1751{
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
foreach i of num 1767/1780{
drop if sourcetype!="Objet Général" & year==`i'
}
drop if sourcetype!="Tableau Général" & year==1781

foreach i of num 1782/1788{
drop if sourcetype!="Objet Général" & year==`i'
}

foreach i of num 1789/1822{
drop if sourcetype!="Résumé" & year==`i'
}

collapse (sum) value, by(year pays_regroupes)

save "$thesis/database_dta/bdd_courante1", replace

keep if pays_regroupes=="Nord"
drop pays_regroupes
save "$thesis/database_dta/hamburg1", replace
restore

**** save db with product differentiation 
drop if sourcetype=="Colonies" | sourcetype=="Divers" | sourcetype=="Divers - in" ///
| sourcetype=="National par direction" | sourcetype=="Tableau Général" ///
| sourcetype=="Tableau des quantités"

foreach i of num 1716/1751{
drop if sourcetype!="Local" & year==`i'
}
drop if sourcetype!="Objet Général" & year==1752
drop if sourcetype!="Local" & year==1753
foreach i of num 1754/1761{
drop if sourcetype!="Objet Général" & year==`i'
}
foreach i of num 1762/1766{
drop if sourcetype!="Local" & year==`i'
}
foreach i of num 1767/1780{
drop if sourcetype!="Objet Général" & year==`i'
}

foreach i in 1782 1787 1788{
drop if sourcetype!="Objet Général" & year==`i'
}
foreach i of num 1789/1821{
drop if sourcetype!="Résumé" & year==`i'
}


collapse (sum) value, by(year pays_regroupes classification_hamburg_large)

/*
merge m:1 year pays_regroupes classification_hamburg_large using "$thesis/database_dta/product_estimation"
drop if _merge==2
drop _merge

replace value = pred_value if year<1752
replace value=pred_value if year==1753
foreach i of num 1762/1766{
replace value=pred_value if year==`i'
}
drop pred_value
drop if value==.
*/

save "$thesis/database_dta/bdd_courante2", replace

keep if pays_regroupes=="Nord" 
drop pays_regroupes
save "$thesis/database_dta/hamburg2", replace

























