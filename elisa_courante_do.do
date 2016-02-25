***CLEAN INITIAL DATABASE
clear


***Clean bdd_centrale
insheet using "/Users/Tirindelli/Google Drive/ETE/Thesis/toflit18_data/base/bdd_centrale.csv", names
save "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/bdd_centrale.dta", replace

clear



***Clean bdd_pays

insheet using "/Users/Tirindelli/Google Drive/ETE/Thesis/toflit18_data/base/bdd_pays.csv", names
save "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/bdd_pays.dta", replace

clear

***Clean bdd_marchandises_normalisees_orthographique

insheet using "/Users/Tirindelli/Google Drive/ETE/Thesis/toflit18_data/traitements_marchandises/bdd_marchandises_normalisees_orthographique.csv", names

drop if missing(marchandises)
duplicates drop marchandises, force
save "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/bdd_marchandises _normalisation_orthographique.dta", replace
clear


***Clean bdd_simplification
insheet using "/Users/Tirindelli/Google Drive/ETE/Thesis/toflit18_data/traitements_marchandises/simplification_travail.csv", names
gen marchandises_norm_ortho=orthographic_pierre
drop orthographic_pierre
duplicates drop marchandises_norm_ortho, force
save "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/simplification_travail.dta", replace

clear


***Clean bdd_marchandises_classifiees

insheet using "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/elisa_bdd_marchandises_classifiees.csv", names
drop if missing(marchandises_norm_ortho)
duplicates drop marchandises_norm_ortho, force
save "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/elisa_bdd_marchandises_classifiees.dta", replace

clear


****MERGE

cd "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/"

use "bdd_centrale.dta"

***merge central and pays 
merge m:1 pays using "bdd_pays.dta"
drop if _merge==2
drop if _merge==1
drop source_bdc-_merge

keep if pays_corriges=="Villes hanséatiques" | pays_corriges=="Villes hanséatiques-Hollande" | pays_corriges=="Villes hanséatiques-Nord" | pays_corriges=="Nord"
keep if exportsimports=="Exports" |  exportsimports=="Exportations" |  exportsimports=="Export" |  exportsimports=="Sortie" |  exportsimports=="exports" |  exportsimports=="export"
drop if missing(marchandises)
drop if sourcetype=="Tableau Général"
drop if sourcetype!="Objet Général" & year=="1787"
drop if sourcetype=="National par direction" & year=="1789"


destring value, replace dpcomma
codebook value
replace value=value*4.505/1000
codebook value

***merge with normalisation orthographique

merge m:1 marchandises using "bdd_marchandises_normalisation_orthographique.dta"
drop if _merge==2
drop _merge

***merge with simplification
merge m:1 marchandises_norm_ortho using "simplification_travail.dta"
drop if _merge==2
drop if _merge==1
drop _merge


***merge with classification
merge m:1 marchandises_norm_ortho using "elisa_bdd_marchandises_classifiees.dta"
*gen not_matched=marchandises_norm_ortho
*replace not_matched="" if _merge!=2
*drop _merge

*tab classification_hambourg_large

****keep only years 1733-1789
drop if year=="An 10" | year=="An 11" | year=="An 12" | year=="An 13" | year=="An 5" | year=="An 6" | year=="An 7" | year=="An 8"| year=="An 9" | year=="An 14 & 1806"
destring year, replace
drop if year<1733
drop if year>1789

***check
*codebook marchandises_norm_ortho
*codebook toclassify
*codebook year
*codebook pays_corriges
*codebook exportsimports 

***save temporarily
save "elisa_bdd_courante.dta", replace


***create csv with merchandise to simplify

*duplicates drop marchandises_norm_ortho, force
**codebook marchandises_norm_ortho
*outsheet obsolete marchandises_norm_ortho simplification suggestiondesimplification imprimatur using "elisa_simplification.csv", replace

***create a csv with marchandises still to classify
*duplicates drop toclassify, force
*codebook toclassify
*outsheet toclassify using "to_classify.csv", replace



***eliminate useless variables
use "elisa_bdd_courante.dta", clear
drop source sourcepath sourcetype exportsimports total v26 pays_normalises_orthographique pays_corriges pays_regroupes mériteplusdetravail 
drop imprimatur  nbr_dans_bdc obsolete  suggestiondesimplification status  beforeitems afteritems  marchandises_tres_simplifiees 
drop classificationproduitsmdicinaux  remarques_marchandises wallislist  exclusion_not_medical_primarily nom_wallis  large narrow  
drop sitc1digit sitc18thc  nbr_lignes_fr_bis classification_hambourg_etroite  ajouts_565860 commestibles_eur_grainsetsubstit  grains_ou_farine 
drop categories_de_grains  v9 source_bdc  nbr_bdc_marchandises_simplifiees _merge mdicinaux

***save clean dataset 

save "elisa_bdd_courante.dta", replace

























































