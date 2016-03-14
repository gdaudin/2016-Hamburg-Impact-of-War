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

insheet using "/$thesis/Data/database_csv/elisa_bdd_marchandises_classifiees.csv", names
drop if missing(marchandises_norm_ortho)
duplicates drop marchandises_norm_ortho, force
save "$thesis/Data/database_dta/elisa_bdd_marchandises_classifiees.dta", replace

clear


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
merge m:1 marchandises_norm_ortho using "$thesis/Data/database_dta/elisa_bdd_marchandises_classifiees.dta"
*gen not_matched=marchandises_norm_ortho
*replace not_matched="" if _merge!=1
drop _merge

*rename classification_hambourg_large classification_hamburg_large

replace classification_hamburg_large="Coton" if classification_hamburg_large=="Coton ; autre et de Méditerranée"
replace classification_hamburg_large="Vin ; de France" if simplification=="vin de Bordeaux" | simplification=="vin de France" | simplification=="vin d'amont" | simplification=="vin de Bordeaux de ville" | simplification=="vin de Languedoc"
replace classification_hamburg_large="Indigo" if simplification=="indigo"
replace classification_hamburg_large="Safran ; orange" if simplification=="safran"
replace classification_hamburg_large="Gingembre" if simplification=="gingembre"



***save temporarily
*save "/$thesis/Data/elisa_bdd_courante.dta", replace


***create csv with merchandise to simplify

*duplicates drop marchandises_norm_ortho, force
**codebook marchandises_norm_ortho
*outsheet obsolete marchandises_norm_ortho simplification suggestiondesimplification imprimatur using "elisa_simplification.csv", replace

***create a csv with marchandises still to classify
*duplicates drop not_matched, force
*outsheet not_matched using "not_matched.csv", replace



***eliminate useless variables
drop source sourcepath total v26 pays_normalises_orthographique pays_corriges pays_regroupes mériteplusdetravail 
drop imprimatur  nbr_dans_bdc  marchandises_tres_simplifiees 
drop classificationproduitsmdicinaux  remarques_marchandises wallislist  exclusion_not_medical_primarily nom_wallis  large narrow  
drop sitc1digit sitc18thc  nbr_lignes_fr_bis classification_hambourg_etroite  ajouts_565860 commestibles_eur_grainsetsubstit  grains_ou_farine 
drop categories_de_grains  v9 source_bdc  nbr_bdc_marchandises_simplifiees remarkspourlesdroits doublecompte
drop origine leurvaleursubtotal_1 leurvaleursubtotal_2 leurvaleursubtotal_3 probleme remarks problemes  Droitstotauxindiqués 
drop unit_price droitsunitaires doubleaccounts  unitépourlesdroits bureaus  v33  quantitépourlesdroits  problem  
drop numrodeligne dataentryby bureaux sheet pays exportsimports marchandises quantit quantity_unit sitc_rev1

preserve 
replace direction="total" if direction==""
drop if direction=="Amiens" | direction=="Montpellier" | direction=="Rennes"
encode direction, gen(dir)
gen lnvalue=ln(value)
save "$thesis/Data/database_dta/elisa", replace
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
drop sourcetype direction


save "$thesis/Data/database_dta/elisa_bdd_courante.dta", replace





***merge with units--> it is about quantities and database are really old so I'll leave it for now




