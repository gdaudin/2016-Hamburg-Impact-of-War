****MERGE DATABASE

clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"


*** make french database ready to append

use "$thesis/Data/database_dta/elisa_bdd_courante"

cd "$thesis/Data/database_dta/"

drop exportsimports quantit quantity_unit sitc_rev1

rename value value_fr
generate value_hb=.
generate sourceFRHB="France"

order sourceFRHB marchandises_norm_ortho simplification sitc_rev2 classification_hamburg_large value_fr prix_unitaire, after(year)

save "elisa_fr_preappend.dta", replace

***prepare hamburg database to append

insheet using "$thesis/toflit18_data/foreign_sources/Hambourg/BDD_Hambourg_21_juillet_2014.csv", clear


rename marchandises classification_hamburg_large

replace value=value*grammesargent_markbanco/1000

gen sitc_rev2="Not classified"

replace sitc_rev2="5" if classification_hamburg_large=="Alun"
replace sitc_rev2="0a" if classification_hamburg_large=="Beurre"
replace sitc_rev2="4" if classification_hamburg_large=="Blanc ; de baleine"
replace sitc_rev2="2" if classification_hamburg_large=="Bois ; de Pernambouc"
replace sitc_rev2="2" if classification_hamburg_large=="Bois ; de teinture"
replace sitc_rev2="8" if classification_hamburg_large=="Bougie ; de suif"
replace sitc_rev2="0b" if classification_hamburg_large=="Cacao"
replace sitc_rev2="0b" if classification_hamburg_large=="Café"
replace sitc_rev2="2" if classification_hamburg_large=="Cochenille"
replace sitc_rev2="2" if classification_hamburg_large=="Coton ; autre et de Méditerranée"
replace sitc_rev2="1" if classification_hamburg_large=="Eau ; de vie"
replace sitc_rev2="6" if classification_hamburg_large=="Fer"
replace sitc_rev2="0a" if classification_hamburg_large=="Fruits ; divers ; amandes, pelures, raisins, prunes"
replace sitc_rev2="2" if classification_hamburg_large=="Galle"
replace sitc_rev2="0b" if classification_hamburg_large=="Gingembre"
replace sitc_rev2="5" if classification_hamburg_large=="Gomme"
replace sitc_rev2="5" if classification_hamburg_large=="Goudron ; de Suède"
replace sitc_rev2="4" if classification_hamburg_large=="Huile ; d'olive ; blanc ; de Gènes"
replace sitc_rev2="4" if classification_hamburg_large=="Huile ; de baleine"
replace sitc_rev2="2" if classification_hamburg_large=="Indigo"
replace sitc_rev2="6" if classification_hamburg_large=="Minium"
replace sitc_rev2="5" if classification_hamburg_large=="Oxyde ; de plomb"
replace sitc_rev2="6" if classification_hamburg_large=="Plombs"
replace sitc_rev2="0b" if classification_hamburg_large=="Poivre ; blanc-noir"
replace sitc_rev2="5" if classification_hamburg_large=="Potasse"
replace sitc_rev2="0a" if classification_hamburg_large=="Riz"
replace sitc_rev2="5" if classification_hamburg_large=="Safran ; orange"
replace sitc_rev2="5" if classification_hamburg_large=="Savon"
replace sitc_rev2="0b" if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
replace sitc_rev2="4" if classification_hamburg_large=="Suif ; pour faire du savon"
replace sitc_rev2="5" if classification_hamburg_large=="Sumac"
replace sitc_rev2="1" if classification_hamburg_large=="Tabac ; de Virginie"
replace sitc_rev2="5" if classification_hamburg_large=="Tartre"
replace sitc_rev2="0b" if classification_hamburg_large=="Thé ; boue"
replace sitc_rev2="5" if classification_hamburg_large=="Térébenthine"
replace sitc_rev2="5" if classification_hamburg_large=="Vert-de-gris"
replace sitc_rev2="1" if classification_hamburg_large=="Vin ; de France"
replace sitc_rev2="0a" if classification_hamburg_large=="Vinaigre"
replace sitc_rev2="5" if classification_hamburg_large=="Vitriol ; blanc"
replace sitc_rev2="Not classified" if classification_hamburg_large=="Marchandises non classifiées"


***quick look at classified to non classified ratio
preserve
cd "/$thesis/Data/Graph/"
gen notclassified_value= value if classification_hamburg_large=="Marchandises non classifiées"
gen classified_value= value if classification_hamburg_large!="Marchandises non classifiées"
collapse (sum) value notclassified_value classified_value, by (classification_hamburg_large)
graph pie notclassified_value classified_value, title ("French Exports (1733-1789)") subtitle ("Value in grams of silver") caption ("source : Hamburg") plabel(1 "Not classified products", gap(8)) plabel(2 "Classified products", gap(8)) plabel(_all percent, format(%3.1f))
graph save "notclass_to_total_hb", replace
restore
*** it coincides pretty well with what french data say



***add missing values to append

cd "/$thesis/Data/database_dta/"

generate value_fr = .
rename value value_hb
generate sourceFRHB="Hambourg"

order sourceFRHB sitc_rev2 classification_hamburg_large value_fr value_hb, after(year)

save "elisa_hb_preappend.dta", replace


***collapse values

byso year : egen number=count(value_hb)
drop if number==1
fillin year classification_hamburg_large
replace value_hb=0 if _fillin==1
replace sourceFRHB="Hambourg" if _fillin==1
collapse (sum) value_hb, by(year sitc_rev2 sourceFRHB classification_hamburg_large)

save "elisa_hb_preappend_collapse.dta", replace


**** back to french database to aggregate values

use "elisa_fr_preappend.dta", clear

collapse (sum) value_fr, by(sitc_rev2 year classification_hamburg_large sourceFRHB)
fillin year classification_hamburg_large
replace value_fr=0 if _fillin==1
replace sourceFRHB="France"

replace sitc_rev2="5" if classification_hamburg_large=="Alun"
replace sitc_rev2="0a" if classification_hamburg_large=="Beurre"
replace sitc_rev2="4" if classification_hamburg_large=="Blanc ; de baleine"
replace sitc_rev2="2" if classification_hamburg_large=="Bois ; de Pernambouc"
replace sitc_rev2="2" if classification_hamburg_large=="Bois ; de teinture"
replace sitc_rev2="8" if classification_hamburg_large=="Bougie ; de suif"
replace sitc_rev2="0b" if classification_hamburg_large=="Cacao"
replace sitc_rev2="0b" if classification_hamburg_large=="Café"
replace sitc_rev2="2" if classification_hamburg_large=="Cochenille"
replace sitc_rev2="2" if classification_hamburg_large=="Coton ; autre et de Méditerranée"
replace sitc_rev2="1" if classification_hamburg_large=="Eau ; de vie"
replace sitc_rev2="6" if classification_hamburg_large=="Fer"
replace sitc_rev2="0a" if classification_hamburg_large=="Fruits ; divers ; amandes, pelures, raisins, prunes"
replace sitc_rev2="2" if classification_hamburg_large=="Galle"
replace sitc_rev2="0b" if classification_hamburg_large=="Gingembre"
replace sitc_rev2="5" if classification_hamburg_large=="Gomme"
replace sitc_rev2="5" if classification_hamburg_large=="Goudron ; de Suède"
replace sitc_rev2="4" if classification_hamburg_large=="Huile ; d'olive ; blanc ; de Gènes"
replace sitc_rev2="4" if classification_hamburg_large=="Huile ; de baleine"
replace sitc_rev2="2" if classification_hamburg_large=="Indigo"
replace sitc_rev2="6" if classification_hamburg_large=="Minium"
replace sitc_rev2="5" if classification_hamburg_large=="Oxyde ; de plomb"
replace sitc_rev2="6" if classification_hamburg_large=="Plombs"
replace sitc_rev2="0b" if classification_hamburg_large=="Poivre ; blanc-noir"
replace sitc_rev2="5" if classification_hamburg_large=="Potasse"
replace sitc_rev2="0a" if classification_hamburg_large=="Riz"
replace sitc_rev2="5" if classification_hamburg_large=="Safran ; orange"
replace sitc_rev2="5" if classification_hamburg_large=="Savon"
replace sitc_rev2="0b" if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
replace sitc_rev2="4" if classification_hamburg_large=="Suif ; pour faire du savon"
replace sitc_rev2="5" if classification_hamburg_large=="Sumac"
replace sitc_rev2="1" if classification_hamburg_large=="Tabac ; de Virginie"
replace sitc_rev2="5" if classification_hamburg_large=="Tartre"
replace sitc_rev2="0b" if classification_hamburg_large=="Thé ; boue"
replace sitc_rev2="5" if classification_hamburg_large=="Térébenthine"
replace sitc_rev2="5" if classification_hamburg_large=="Vert-de-gris"
replace sitc_rev2="1" if classification_hamburg_large=="Vin ; de France"
replace sitc_rev2="0a" if classification_hamburg_large=="Vinaigre"
replace sitc_rev2="5" if classification_hamburg_large=="Vitriol ; blanc"
replace sitc_rev2="Not classified" if classification_hamburg_large=="Marchandises non classifiées"
collapse (sum)  value_fr, by(sitc_rev2 year classification_hamburg_large sourceFRHB)

save "elisa_fr_preappend_collapse.dta", replace

***append

use "elisa_hb_preappend_collapse.dta", clear
append using "elisa_fr_preappend_collapse.dta"
order  sitc_rev2 value_fr value_hb sourceFRHB, after (year)

save "elisa_frhb_database.dta", replace






