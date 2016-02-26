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
*replace not_matched="" if _merge!=1
drop _merge
replace marchandises_norm_ortho="Not classified" if classification_hambourg_large==""
replace sitc_rev2="Not classified" if marchandises_norm_ortho=="Not classified goods"


****keep only years 1733-1789
drop if year=="An 10" | year=="An 11" | year=="An 12" | year=="An 13" | year=="An 5" | year=="An 6" | year=="An 7" | year=="An 8"| year=="An 9" | year=="An 14 & 1806"
destring year, replace
drop if year<1733
drop if year>1789

replace classification_hambourg_large="Coton" if classification_hambourg_large=="Coton ; autre et de Méditerranée"
replace classification_hambourg_large="Vin ; de France" if simplification=="vin de Bordeaux" | simplification=="vin de France" | simplification=="vin d'amont" | simplification=="vin de Bordeaux de ville" | simplification=="vin de Languedoc"
replace classification_hambourg_large="Indigo" if simplification=="indigo"
replace classification_hambourg_large="Safran ; orange" if simplification=="safran"
replace classification_hambourg_large="Gingembre" if simplification=="gingembre"




***save temporarily
save "elisa_bdd_courante.dta", replace


***create csv with merchandise to simplify

*duplicates drop marchandises_norm_ortho, force
**codebook marchandises_norm_ortho
*outsheet obsolete marchandises_norm_ortho simplification suggestiondesimplification imprimatur using "elisa_simplification.csv", replace

***create a csv with marchandises still to classify
*duplicates drop not_matched, force
*outsheet not_matched using "not_matched.csv", replace



***eliminate useless variables
use "elisa_bdd_courante.dta", clear
drop source sourcepath sourcetype total v26 pays_normalises_orthographique pays_corriges pays_regroupes mériteplusdetravail 
drop imprimatur  nbr_dans_bdc obsolete  suggestiondesimplification status  beforeitems afteritems  marchandises_tres_simplifiees 
drop classificationproduitsmdicinaux  remarques_marchandises wallislist  exclusion_not_medical_primarily nom_wallis  large narrow  
drop sitc1digit sitc18thc  nbr_lignes_fr_bis classification_hambourg_etroite  ajouts_565860 commestibles_eur_grainsetsubstit  grains_ou_farine 
drop categories_de_grains  v9 source_bdc  nbr_bdc_marchandises_simplifiees


***save clean dataset 

save "elisa_bdd_courante.dta", replace



***merge with units--> it is about quantities and database are really old so I'll leave it for now

***STUDY MARCHANDISES

***study sugar and coffee
cd "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/"

use "elisa_bdd_courante.dta", clear

cd "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/Graph"


***coffee
preserve

keep if classification_hambourg_large=="Café"
collapse (sum) value, by (year simplification)

gen coffee_=value if simplification=="café"
gen coffee_bourbon=value if simplification=="café de Bourbon"
gen coffee_moka=value if simplification=="café de Moka"
gen coffee_indes=value if simplification=="café des Indes"
gen coffee_levant=value if simplification=="café du Levant"
twoway (connected coffee_ year) (connected coffee_bourbon year)(connected coffee_moka year)(connected coffee_indes year) (connected coffee_levant year), title("French Exports (1750-1789)") subtitle("coffee, value") caption("source : France")
graph save coffeevalue.gph, replace 

restore 

***sugar
preserve

keep if classification_hambourg_large=="Sucre ; cru blanc ; du Brésil"
collapse (sum) value, by (year simplification)

gen sugar_blanc=value if simplification=="sucre blanc"
gen sugar_terre=value if simplification=="sucre terré"
gen sugar_brut=value if simplification=="sucre brut"
gen sugar_tete=value if simplification=="sucre tête" | simplification=="sucre tête de forme"
gen sugar_common=value if simplification=="sucre commun"
gen sugar_cassonade=value if simplification=="sucre cassonade"|simplification=="sucre cassonade des Indes"
gen sugar_brun=value if simplification=="sucre brun"
gen sugar_pain=value if simplification=="sucre en pain"
gen sugar_raffiné=value if simplification=="sucre raffiné"|simplification=="sucre en pain raffiné"
gen sugar_=value if simplification=="sucre"|simplification=="sucre blanc et sucre terré et sucre tête" |simplification=="sucre terré et sucre tête"
twoway (connected sugar_blanc year) (connected sugar_pain year) (connected sugar_brun year) (connected sugar_cassonade year) (connected sugar_common year) (connected sugar_terre year)(connected sugar_brut year)(connected sugar_tete year) (connected sugar_raffiné year) (connected sugar_ year), title("French Exports (1733-1789)") subtitle("Sugar, value") caption("source : France")
graph save sugarvalue.gph, replace 

restore 


clear

cd "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/"
use "elisa_bdd_courante.dta", replace

*** study not classified marchandises

cd "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/Graph/"

gen notclassified_value = value if classification_hambourg_large==""

preserve

gen classified_value = value if classification_hambourg_large!=""
collapse (sum) value notclassified_value classified_value
gen notclass_to_total=notclassified_value/value
display notclass_to_total
graph pie classified_value notclassified_value, title ("French Exports (1733-1789)") subtitle ("Value in grams of silver") caption ("source : France") plabel(2 percent)
graph save notclass_to_total.gph, replace 

restore


* look at Marchandises which represent less than 0.1% of total value

cd "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/"

preserve

egen valuesum= sum(value)
collapse (sum) notclassified_value, by (simplification valuesum)
gen value_non = notclassified_value/valuesum
keep if value_non>=.0001
outsheet using "not_classified.csv", replace

restore 


* Evolution longitudinale des marchandises importantes oubliées

preserve

collapse (sum) notclassified_value, by (year simplification)
rename notclassified_value value
gen Salt=value if marchandises_normalisees=="Sel" 
gen Syrup=value if marchandises_normalisees=="Sirop" 
gen Syrup_molasses=value if marchandises_normalisees=="Sirop ; mélasse" 
gen Indienne=value if marchandises_normalisees=="Indienne ; guinée" 
gen Misc_goods=value if marchandises_normalisees=="Marchandises" 

twoway (connected Salt year) (connected Syrup year) (connected Syrup_molasses year) (connected Indienne year) (connected Misc_goods year), title("French Exports (1750-1789)") subtitle("Not classified marchandises, value") caption("source : France")
graph export "/Users/patrickaubourg/Desktop/execute dofile/fichiers sauvegardeÃÅs/oubliees/marchandisesimportantesoubliees.png", replace 
graph save "/Users/patrickaubourg/Desktop/execute dofile/fichiers sauvegardeÃÅs/oubliees/marchandisesimportantesoubliees.gph", replace 

collapse (sum) value, by (marchandises_normalisees)
export excel using "/Users/patrickaubourg/Desktop/execute dofile/fichiers sauvegardeÃÅs/oubliees/marchandisesoublieesssss.xls", firstrow(variables) replace


restore























































