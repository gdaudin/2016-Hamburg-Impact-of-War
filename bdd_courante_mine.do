clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"

set more off

use "$thesis/Données Stata/bdd courante.dta"

drop if year==1805.75
drop if yearstr=="10 mars-31 décembre 1787"

collapse (sum) value, by(sourcetype year direction pays_grouping exportsimports ///
marchandises_simplification classification_hamburg_large sitc18_rev3)

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
drop if exportsimports=="Imports"
replace direction="total" if direction==""
drop if sourcetype=="Tableau Général"

collapse (sum) value, by(sourcetype year direction pays_grouping classification_hamburg_large)

egen _count=count(value), by(pays_grouping)
drop if _count<21
drop _count
drop if pays_grouping=="France" 
drop if pays_grouping=="Indes" 

by direction year, sort: gen nvals = _n == 1
by direction: replace nvals=sum(nvals)
by direction: replace nvals = nvals[_N]
drop if nvals==1
drop nvals


fillin year pays_grouping direction classification_hamburg_large

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
collapse (sum) pred_value value, by(year pays_grouping pays direction dir classification_hamburg_large class)
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

collapse (sum) pred_value, by(year pays_grouping classification_hamburg_large)
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


collapse (sum) value, by(year sourcetype pays_grouping ///
classification_hamburg_large sitc18_rev3 exportsimports)
drop if value==0
drop if sourcetype=="Divers"


***** save db with no product differentiation
preserve
foreach i of num 1716/1782{
drop if sourcetype!="Tableau Général" & year==`i'
}

foreach i of num 1782/1822{
drop if sourcetype!="Résumé" & year==`i'
}

collapse (sum) value, by(year pays_grouping exportsimports)

save "$thesis/database_dta/bdd_courante1", replace

keep if pays_grouping=="Nord"
drop pays_grouping
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


collapse (sum) value, by(year pays_grouping ///
classification_hamburg_large sitc18_rev3 exportsimports)


merge m:1 year pays_grouping classification_hamburg_large ///
using "$thesis/database_dta/product_estimation"
drop if _merge==2
drop _merge

replace value = pred_value if year<1752
replace value=pred_value if year==1753
drop pred_value
drop if value==.


save "$thesis/database_dta/bdd_courante2", replace

keep if pays_grouping=="Nord" 
drop pays_grouping
save "$thesis/database_dta/hamburg2", replace



