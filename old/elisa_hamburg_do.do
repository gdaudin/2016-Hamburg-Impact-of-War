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


***merge with normalisation orthographique

merge m:1 marchandises using "$thesis/Data/database_dta/bdd_marchandises_normalisation_orthographique.dta"
drop if _merge==2
drop if _merge==1 & sourcetype!="Tableau Général"
replace marchandises_norm_ortho="total per year" if sourcetype=="Tableau Général"
drop _merge

***merge with simplification
merge m:1 marchandises_norm_ortho using "$thesis/Data/database_dta/bdd_revised_marchandises_simplifiees.dta"
drop if _merge==2
drop if _merge==1 & sourcetype!="Tableau Général"
replace marchandises_simplification="total per year" if sourcetype=="Tableau Général"
drop _merge

***merge with classification
merge m:1 marchandises_simplification using "$thesis/Data/database_dta/bdd_revised_classification_hamburg.dta"
drop if _merge==2
drop if _merge==1 & sourcetype!="Tableau Général"
drop _merge


***merge with sitc
merge m:1 marchandises_simplification using "$thesis/Data/database_dta/travail_sitcrev3.dta"
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

preserve
drop if value==0
drop if value==.
gen firstdigit = real(substr(string(value), 1, 1))
drop if firstdigit==.
firstdigit value
contract firstdigit
set obs 9 
gen x = _n 
gen expected = log10(1 + 1/x) 
twoway histogram firstdigit [fw=_freq], barw(0.5) bfcolor(ltblue) blcolor(navy) discrete fraction || connected expected x, xla(1/9) title("observed and expected") caption("French source") yla(, ang(h) format("%02.1f")) legend(off)
graph export "$thesis/Data/Graph/Benford/benford_fr.png", as(png) replace
restore
replace value=value*4.505/1000


****keep only exports towards hamburg 
keep if pays_corriges=="Villes hanséatiques" | pays_corriges=="Villes hanséatiques-Hollande" | pays_corriges=="Villes hanséatiques-Nord" | pays_corriges=="Nord"
keep if exportsimports=="Exports" |  exportsimports=="Exportations" |  exportsimports=="Export" |  exportsimports=="Sortie" |  exportsimports=="exports" |  exportsimports=="export"
replace direction="total" if direction==""


***clean database
keep if exportsimports=="Exports" |  exportsimports=="Exportations" |  exportsimports=="Export" |  exportsimports=="Sortie" |  exportsimports=="exports" |  exportsimports=="export"


replace classification_hamburg_large="Coton" if classification_hamburg_large=="Coton ; autre et de Méditerranée"
replace classification_hamburg_large="Vin ; de France" if marchandises_simplification=="vin de Bordeaux" | marchandises_simplification=="vin de France" | marchandises_simplification=="vin d'amont" | marchandises_simplification=="vin de Bordeaux de ville" | marchandises_simplification=="vin de Languedoc"
replace classification_hamburg_large="Indigo" if marchandises_simplification=="indigo"
replace classification_hamburg_large="Safran ; orange" if marchandises_simplification=="safran"
replace classification_hamburg_large="Gingembre" if marchandises_simplification=="gingembre"

replace classification_hamburg_large="Marchandises non classifiées" if classification_hamburg_large==""
replace sitc18_rev3="Not classified" if classification_hamburg_large=="Marchandises non classifiées"

***eliminate useless variables
collapse (sum) value, by(sourcetype year direction marchandises_simplification classification_hamburg_large sitc18_rev3)

save "$thesis/Data/database_dta/elisa", replace

use "$thesis/Data/database_dta/elisa", replace

preserve
replace direction="total" if direction==""
drop if direction=="Amiens" | direction=="Montpellier" | direction=="Rennes"
collapse (sum) value, by(year direction sourcetype)
gen lnvalue=ln(value)
sort (year) direction
egen _count=sum(value), by(year direction)
replace lnvalue=0 if _count!=0 & value==0
drop _count
encode direction, gen(dir)
fillin year dir
quietly reg lnvalue i.dir i.year [iw=value]
predict value1
gen value2=exp(value1)
gen value3=. 
replace value3=value2 if dir==8
capture corr value value3 if dir==8
local corr: display %3.2f r(rho)
replace value=. if value==0
replace value3=. if value3==0
twoway (connected value year) (connected value3 year) if dir==8, title("Predicted versus actual value of export") subtitle("Correlation: `corr'")
graph export predict_value.png, replace as(png) 
restore

****
preserve 
replace direction="total" if direction==""
drop if sourcetype=="Tableau Général"
drop if direction=="Amiens" | direction=="Montpellier" | direction=="Rennes"
collapse (sum) value, by(year classification_hamburg_large direction sourcetype)
gen lnvalue=ln(value)
sort (year) direction
egen _count=sum(value), by(year direction)
replace lnvalue=0 if _count!=0 & value==0
drop _count
encode direction, gen(dir)
drop if classification_hamburg_large=="Vert-de-gris"| classification_hamburg_large=="Plomb" | classification_hamburg_large=="Suif ; pour faire du savon"
fillin year dir classification_hamburg_large
encode classification_hamburg_large, gen(class)

foreach i of num 1/32 {
gen lnvalue`i'=lnvalue if class==`i'
}

foreach i of num 1/32 {
quietly reg lnvalue`i' i.dir i.year [iw=value], robust
predict value1
gen value2=exp(value1)
gen pred_value`i'=. 
replace pred_value`i'=value2 if class==`i' & dir==8 
drop value1 value2
}

gen pred_value=.
foreach i of num 1/32{
replace pred_value=pred_value`i' if class==`i'
}
collapse (sum) pred_value, by(year classification_hamburg_large) 
/*drop if year<1733
drop if year==1752
foreach i of num 1754/1761{
drop if year==`i'
}
drop if year>1766
*/
save "/$thesis/Data/database_dta/prediction_product", replace
restore




**** keep only years of interest
*drop if year<1733
drop if year>1789

preserve
foreach i of num 1733/1751{
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
foreach i of num 1767/1789{
drop if sourcetype!="Objet Général" & year==`i'
}
save "$thesis/Data/database_dta/elisa_hamburg1", replace
restore

***make sure you dont count twice
drop if sourcetype=="Tableau Général"
drop if sourcetype=="Résumé" & year==1787
drop if sourcetype=="Résumé" & year==1788
drop if sourcetype=="Local" & year==1750
drop if sourcetype=="National par direction" & year==1789
drop if sourcetype=="Local" & year==1752
drop if sourcetype!="Objet Général" & year==1787
foreach i of num 1754/1761{
drop if sourcetype=="Local" & year==`i'
}
foreach i of num 1767/1780{
drop if sourcetype=="Local" & year==`i'
}
collapse (sum) value, by(year classification_hamburg_large direction)

save "$thesis/Data/database_dta/elisa_hamburg2", replace


save "$thesis/Data/database_dta/elisa_bdd_courante.dta", replace





***merge with units--> it is about quantities and database are really old so I'll leave it for now






















