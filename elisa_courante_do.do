*** 1)CLEAN INITIAL DATABASE
clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

***Clean bdd_centrale
insheet using "/$thesis/toflit18_data/base/bdd_centrale.csv", names
save "$thesis/Data/database_dta/bdd_centrale.dta", replace

clear



***Clean bdd_pays

insheet using "/$thesis/toflit18_data/base/bdd_pays.csv", names
save "$thesis/Data/database_dta/bdd_pays.dta", replace

clear

***Clean bdd_marchandises_normalisees_orthographique

insheet using "/$thesis/toflit18_data/traitements_marchandises/bdd_marchandises_normalisees_orthographique.csv", names

drop if missing(marchandises)
duplicates drop marchandises, force
save "$thesis/Data/database_dta/bdd_marchandises_normalisation_orthographique.dta", replace
clear


***Clean bdd_simplification
insheet using "/$thesis/Data/database_csv/elisa_simplification.csv", names
*rename orthographic_pierre marchandises_norm_ortho
duplicates drop marchandises_norm_ortho, force
save "$thesis/Data/database_dta/simplification_travail.dta", replace

clear


***Clean bdd_marchandises_classifiees

/*insheet using "/$thesis/Data/database_csv/elisa_bdd_marchandises_classifiees.csv", names
drop if missing(marchandises_norm_ortho)
duplicates drop marchandises_norm_ortho, force
save "$thesis/Data/database_dta/elisa_bdd_marchandises_classifiees.dta", replace

*/clear


**** 2) MERGE

use "$thesis/Data/database_dta/bdd_centrale.dta"

***merge central and pays 
merge m:1 pays using "$thesis/Data/database_dta/bdd_pays.dta"
drop if _merge==2
drop if _merge==1
drop source_bdc-_merge

****keep only exports towards hamburg 
keep if pays_corriges=="Villes hanséatiques" | pays_corriges=="Villes hanséatiques-Hollande" | pays_corriges=="Villes hanséatiques-Nord" | pays_corriges=="Nord"
keep if exportsimports=="Exports" |  exportsimports=="Exportations" |  exportsimports=="Export" |  exportsimports=="Sortie" |  exportsimports=="exports" |  exportsimports=="export"
drop if missing(marchandises)


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
destring year, replace
drop if year==.

***destring values
destring value, replace dpcomma
codebook value
replace value=value*4.505/1000

destring prix_unitaire, replace dpcomma
replace prix_unitaire=value*4.505/1000
codebook prix_unitaire



***merge with normalisation orthographique

merge m:1 marchandises using "$thesis/Data/database_dta/bdd_marchandises_normalisation_orthographique.dta"
drop if _merge==2
drop _merge

***merge with simplification
merge m:1 marchandises_norm_ortho using "/$thesis/Data/database_dta/simplification_travail.dta"
drop if _merge==2
drop if _merge==1
drop _merge


***merge with classification
/*merge m:1 marchandises_norm_ortho using "$thesis/Data/database_dta/elisa_bdd_marchandises_classifiees.dta"
drop _merge

*rename classification_hambourg_large classification_hamburg_large

*/replace classification_hamburg_large="Coton" if classification_hamburg_large=="Coton ; autre et de Méditerranée"
replace classification_hamburg_large="Vin ; de France" if simplification=="vin de Bordeaux" | simplification=="vin de France" | simplification=="vin d'amont" | simplification=="vin de Bordeaux de ville" | simplification=="vin de Languedoc"
replace classification_hamburg_large="Indigo" if simplification=="indigo"
replace classification_hamburg_large="Safran ; orange" if simplification=="safran"
replace classification_hamburg_large="Gingembre" if simplification=="gingembre"

replace classification_hamburg_large="Marchandises non classifiées" if classification_hamburg_large==""
replace sitc_rev2="Not classified" if classification_hamburg_large=="Marchandises non classifiées"


***eliminate useless variables
drop numrodeligne dataentryby source sourcepath exportsimports bureaux sheet marchandises pays quantit origine total nbr_dans_bdc 
drop quantity_unit leurvaleursubtotal_1 leurvaleursubtotal_2 leurvaleursubtotal_3 probleme remarks problemes doublecompte v26 
drop Droitstotauxindiqués unit_price  droitsunitaires doubleaccounts  unitépourlesdroits bureaus  v33  quantitépourlesdroits  
drop problem  remarkspourlesdroits  pays_normalises_orthographique  pays_corriges  pays_regroupes  mériteplusdetravail  imprimatur

save "$thesis/Data/database_dta/elisa", replace

use "$thesis/Data/database_dta/elisa", replace

preserve
replace direction="total" if direction==""
drop if direction=="Amiens" | direction=="Montpellier" | direction=="Rennes"
collapse (sum) value, by(year direction dir sourcetype)
gen lnvalue=ln(value)
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
collapse (sum) value3, by(year)
keep if year>1732
drop if year>1753
save "/$thesis/Data/database_dta/prediction_total", replace
restore


preserve 
replace direction="total" if direction==""
drop if direction=="Amiens" | direction=="Montpellier" | direction=="Rennes"
encode direction, gen(dir)
collapse (sum) value, by(year classification_hamburg_large dir direction sourcetype)
gen lnvalue=ln(value)
drop if classification_hamburg_large=="Vert-de-gris"
fillin year dir classification_hamburg_large
encode classification_hamburg_large, gen(class)
foreach i of num 1/35 {
gen lnvalue`i'=lnvalue if class==`i'
}

foreach i of num 1/35 {
quietly reg lnvalue`i' i.dir i.year [iw=value], robust
predict value1
gen value2=exp(value1)
gen pred_value`i'=. 
replace pred_value`i'=value2 if class==`i' & dir==8 
drop value1 value2
}

gen pred_value=.
foreach i of num 1/35{
replace pred_value=pred_value`i' if class==`i'
}
collapse (sum) pred_value, by(year classification_hamburg_large) 
keep if year>1732
drop if year>1753
save "/$thesis/Data/database_dta/prediction_product", replace
restore




**** keep only years of interest
drop if year<1733
drop if year>1789

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


rename prix_unitaire unit_price
drop if year==.
replace value=. if value==0
drop sourcetype direction


save "$thesis/Data/database_dta/elisa_bdd_courante.dta", replace





***merge with units--> it is about quantities and database are really old so I'll leave it for now




