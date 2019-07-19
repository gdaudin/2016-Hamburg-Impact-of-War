*******************************************PREPARE DATABASE TO APPEND********************************************
*****************************************************************************************************************
*****************************************************************************************************************


clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"


*******************************************HAMBURG***************************************************************

insheet using "$thesis/toflit18_data_GIT/foreign_sources/Hambourg/BDD_Hambourg_21_juillet_2014.csv", clear


rename marchandises hamburg_classification

preserve
drop if value==0
drop if value==.
firstdigit value, percent
gen firstdigit = real(substr(string(value), 1, 1))
codebook firstdigit
contract firstdigit
set obs 9 
gen x = _n 
gen expected = log10(1 + 1/x) 
twoway histogram firstdigit [fw=_freq], barw(0.5) bfcolor(ltblue) blcolor(navy) ///
 discrete fraction || connected expected x, xla(1/9) title("Observed and Expected") ///
 caption("Hamburg source") yla(, ang(h) format("%02.1f")) legend(off) ///
 plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$thesis//Data/do_files/Hamburg/tex2/benford_hb.png", as(png) replace
restore

replace value=value*grammesargent_markbanco/1000
drop if year>1789


***quick look at classified to non classified ratio
/*preserve
cd "/$thesis/Data/Graph/"
gen notclassified_value= value if hamburg_classification=="Marchandises non classifiées"
gen classified_value= value if hamburg_classification!="Marchandises non classifiées"
collapse (sum) value notclassified_value classified_value, by (hamburg_classification)
graph pie notclassified_value classified_value, title ("French Exports (1733-1789)") subtitle ("Value in grams of silver") caption ("source : Hamburg") plabel(1 "Not classified products", gap(8)) plabel(2 "Classified products", gap(8)) plabel(_all percent, format(%3.1f))
graph save "notclass_to_total_hb", replace
restore
*** it coincides pretty well with what french data say



***add missing values to append

*/

generate value_fr = .
rename value value_hb
generate sourceFRHB="Hamburg"

order sourceFRHB hamburg_classification value_fr value_hb, after(year)

replace hamburg_classification="Thérébenthine" if hamburg_classification=="Térébenthine"
replace hamburg_classification="Coton" if hamburg_classification=="Coton ; autre et de Méditerranée"
replace hamburg_classification="Plomb" if hamburg_classification=="Plombs"

gen sitc_rev2="Not classified"

replace sitc_rev2="5" if hamburg_classification=="Alun"
replace sitc_rev2="0a" if hamburg_classification=="Beurre"
replace sitc_rev2="4" if hamburg_classification=="Blanc ; de baleine"
replace sitc_rev2="2" if hamburg_classification=="Bois ; de Pernambouc"
replace sitc_rev2="2" if hamburg_classification=="Bois ; de teinture"
replace sitc_rev2="8" if hamburg_classification=="Bougie ; de suif"
replace sitc_rev2="0b" if hamburg_classification=="Cacao"
replace sitc_rev2="0b" if hamburg_classification=="Café"
replace sitc_rev2="2" if hamburg_classification=="Cochenille"
replace sitc_rev2="2" if hamburg_classification=="Coton"
replace sitc_rev2="1" if hamburg_classification=="Eau ; de vie"
replace sitc_rev2="6" if hamburg_classification=="Fer"
replace sitc_rev2="0a" if hamburg_classification=="Fruits ; divers ; amandes, pelures, raisins, prunes"
replace sitc_rev2="2" if hamburg_classification=="Galle"
replace sitc_rev2="0b" if hamburg_classification=="Gingembre"
replace sitc_rev2="5" if hamburg_classification=="Gomme"
replace sitc_rev2="5" if hamburg_classification=="Goudron ; de Suède"
replace sitc_rev2="4" if hamburg_classification=="Huile ; d'olive ; blanc ; de Gènes"
replace sitc_rev2="4" if hamburg_classification=="Huile ; de baleine"
replace sitc_rev2="2" if hamburg_classification=="Indigo"
replace sitc_rev2="6" if hamburg_classification=="Minium"
replace sitc_rev2="5" if hamburg_classification=="Oxyde ; de plomb"
replace sitc_rev2="6" if hamburg_classification=="Plomb"
replace sitc_rev2="0b" if hamburg_classification=="Poivre ; blanc-noir"
replace sitc_rev2="5" if hamburg_classification=="Potasse"
replace sitc_rev2="0a" if hamburg_classification=="Riz"
replace sitc_rev2="5" if hamburg_classification=="Safran ; orange"
replace sitc_rev2="5" if hamburg_classification=="Savon"
replace sitc_rev2="0b" if hamburg_classification=="Sucre ; cru blanc ; du Brésil"
replace sitc_rev2="4" if hamburg_classification=="Suif ; pour faire du savon"
replace sitc_rev2="5" if hamburg_classification=="Sumac"
replace sitc_rev2="1" if hamburg_classification=="Tabac ; de Virginie"
replace sitc_rev2="5" if hamburg_classification=="Tartre"
replace sitc_rev2="0b" if hamburg_classification=="Thé ; boue"
replace sitc_rev2="5" if hamburg_classification=="Thérébenthine"
replace sitc_rev2="5" if hamburg_classification=="Vert-de-gris"
replace sitc_rev2="1" if hamburg_classification=="Vin ; de France"
replace sitc_rev2="0a" if hamburg_classification=="Vinaigre"
replace sitc_rev2="5" if hamburg_classification=="Vitriol ; blanc"
replace sitc_rev2="Not classified" if hamburg_classification=="Marchandises non classifiées"
collapse (sum) value_hb, by(year sitc_rev2 sourceFRHB hamburg_classification)

save "$thesis/database_dta/elisa_hb_preappend.dta", replace


*******************************************FRENCH****************************************************************
global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
use "$thesis/Données Stata/bdd courante.dta", clear

keep if country_grouping=="Nord"
drop if year<1733
drop if year>1789
keep if exportsimports=="Exports"

replace value=value*4.505/1000

preserve 
keep if sourcetype=="Tableau Général"
collapse (sum) value, by(year)
rename value value_fr
append using "$thesis/database_dta/elisa_hb_preappend.dta" 
collapse (sum) value_fr value_hb, by(year)
save "$thesis/database_dta/elisa_frhb_database_total.dta", replace
restore

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


collapse (sum) value, by(year country_grouping ///
hamburg_classification exportsimports)

replace hamburg_classification="Marchandises non classifiées" if hamburg_classification==""
rename value value_fr

collapse (sum)  value_fr, by(year hamburg_classification)

generate sourceFRHB="France"


gen sitc_rev2=""
replace sitc_rev2="5" if hamburg_classification=="Alun"
replace sitc_rev2="0a" if hamburg_classification=="Beurre"
replace sitc_rev2="4" if hamburg_classification=="Blanc ; de baleine"
replace sitc_rev2="2" if hamburg_classification=="Bois ; de Pernambouc"
replace sitc_rev2="2" if hamburg_classification=="Bois ; de teinture"
replace sitc_rev2="8" if hamburg_classification=="Bougie ; de suif"
replace sitc_rev2="0b" if hamburg_classification=="Cacao"
replace sitc_rev2="0b" if hamburg_classification=="Café"
replace sitc_rev2="2" if hamburg_classification=="Cochenille"
replace sitc_rev2="2" if hamburg_classification=="Coton"
replace sitc_rev2="1" if hamburg_classification=="Eau ; de vie"
replace sitc_rev2="6" if hamburg_classification=="Fer"
replace sitc_rev2="0a" if hamburg_classification=="Fruits ; divers ; amandes, pelures, raisins, prunes"
replace sitc_rev2="2" if hamburg_classification=="Galle"
replace sitc_rev2="0b" if hamburg_classification=="Gingembre"
replace sitc_rev2="5" if hamburg_classification=="Gomme"
replace sitc_rev2="5" if hamburg_classification=="Goudron ; de Suède"
replace sitc_rev2="4" if hamburg_classification=="Huile ; d'olive ; blanc ; de Gènes"
replace sitc_rev2="4" if hamburg_classification=="Huile ; de baleine"
replace sitc_rev2="2" if hamburg_classification=="Indigo"
replace sitc_rev2="6" if hamburg_classification=="Minium"
replace sitc_rev2="5" if hamburg_classification=="Oxyde ; de plomb"
replace sitc_rev2="6" if hamburg_classification=="Plomb"
replace sitc_rev2="0b" if hamburg_classification=="Poivre ; blanc-noir"
replace sitc_rev2="5" if hamburg_classification=="Potasse"
replace sitc_rev2="0a" if hamburg_classification=="Riz"
replace sitc_rev2="5b" if hamburg_classification=="Safran ; orange"
replace sitc_rev2="5" if hamburg_classification=="Savon"
replace sitc_rev2="0b" if hamburg_classification=="Sucre ; cru blanc ; du Brésil"
replace sitc_rev2="4" if hamburg_classification=="Suif ; pour faire du savon"
replace sitc_rev2="5" if hamburg_classification=="Sumac"
replace sitc_rev2="1" if hamburg_classification=="Tabac ; de Virginie"
replace sitc_rev2="5" if hamburg_classification=="Tartre"
replace sitc_rev2="0b" if hamburg_classification=="Thé ; boue"
replace sitc_rev2="5" if hamburg_classification=="Thérébenthine"
replace sitc_rev2="5" if hamburg_classification=="Vert-de-gris"
replace sitc_rev2="1" if hamburg_classification=="Vin ; de France"
replace sitc_rev2="0a" if hamburg_classification=="Vinaigre"
replace sitc_rev2="5" if hamburg_classification=="Vitriol ; blanc"
replace sitc_rev2="Not classified" if hamburg_classification=="Marchandises non classifiées"

save "$thesis/database_dta/elisa_fr_preappend.dta", replace


*******************************************APPEND***************************************************************

use "$thesis/database_dta/elisa_hb_preappend.dta", clear
append using "$thesis/database_dta/elisa_fr_preappend.dta"
order  sitc_rev2 value_fr value_hb sourceFRHB, after (year)


***clean finalised database

replace sourceFRHB="Hamburg" if sourceFRHB=="Hambourg"
replace sitc_rev2 = "0: Foodstuff, various" if sitc_rev2=="0"	
replace sitc_rev2 = "0a: Foodstuff, European" if sitc_rev2=="0a"
replace sitc_rev2 = "0b: Foodstuff, Exotic" if sitc_rev2=="0b"
replace sitc_rev2 = "1: Beverages and tobacco" if sitc_rev2=="1"
replace sitc_rev2 = "2: Raw materials" if sitc_rev2=="2"
replace sitc_rev2 = "3: Fuels" if sitc_rev2=="3"
replace sitc_rev2 = "4: Oils" if sitc_rev2=="4"
replace sitc_rev2 = "5: Chemicals" if sitc_rev2=="5"
replace sitc_rev2 = "6: Manuf. goods, by material" if sitc_rev2=="6"
replace sitc_rev2 = "6a: Manuf. goods, linen" if sitc_rev2=="6a"
replace sitc_rev2 = "6b: Manuf. goods, wool" if sitc_rev2=="6b"
replace sitc_rev2 = "6c: Manuf. goods, silk" if sitc_rev2=="6c"
replace sitc_rev2 = "6d: Manuf. goods, cotton" if sitc_rev2=="6d"
replace sitc_rev2 = "7: Machinery and transport goods" if sitc_rev2=="7"
replace sitc_rev2 = "8: Misc. manuf. goods" if sitc_rev2=="8"
replace sitc_rev2 = "9: Other (incl. weapons)" if sitc_rev2=="9"
replace sitc_rev2 = "9a: Species" if sitc_rev2=="9a"

order sitc_rev2 value_fr value_hb sourceFRHB hamburg_classification, after(year)
replace value_fr=. if value_fr==0
replace value_hb=. if value_hb==0

save "$thesis/database_dta/elisa_frhb_database.dta", replace






