
clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"


***merge with units--> it is about quantities and database are really old so I'll leave it for now



***STUDY MARCHANDISES

use "$thesis/Data/database_dta/elisa_bdd_courante.dta", clear

gen notclassified_value = value if classification_hamburg_large==""
gen classified_value = value if classification_hamburg_large!=""

label var notclassified_value "Value of non classified goods"
label var classified_value "Value of classified goods"





*** LOOK AT CLASSIFIED VERSUS NON CLASSIFIED MARHCANDISES

cd "/$thesis/Data/Graph/"
preserve
collapse (sum) value notclassified_value classified_value
graph pie classified_value notclassified_value, title ("French Exports (1733-1789)") subtitle ("Value in grams of silver") caption ("source : France") plabel(_all percent, format(%3.1f))
graph save notclass_to_total.gph, replace 

***REMEMBER HERE TO FIX LEGEND!

restore

****CLASSIFIED MARCHANDISES REPRESENT 96% OF TOTAL VALUE--> STUDY CLASSIFIED MARCH. COMPOSITION






***STUDY CLASSIFIED MARCHANDISES

preserve
collapse (sum) classified_value, by (classification_hamburg_large)
gen classification_hamburg_graph= classification_hamburg_large
replace classification_hamburg_pie="Other" if classification_hamburg_large!="Café" & classification_hamburg_large!="Vin ; de France" & classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Indigo" & classification_hamburg_large!="Eau ; de vie"
graph pie classified_value , over (classification_hamburg_pie) title("Aggregate French Exports (1750-1789)") subtitle("Product decomposition") plabel(1 "Coffee", gap(8)) plabel(2 "Indigo", gap(8)) plabel(3 "Sugar", gap(8)) plabel(4 "Eau de vie", gap(8)) plabel(5 "Other", gap(8)) plabel(6 "Wine", gap(8)) plabel(_all percent, format(%2.0f))
graph save composition_by_prod.gph, replace  

***FIX NAME IN THE PIE CHART

restore


preserve 
collapse (sum) classified_value, by (year classification_hamburg_large)
gen other=classified_value if classification_hamburg_large!="Café" & classification_hamburg_large!="Vin ; de France" & classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Indigo" & classification_hamburg_large!="Eau ; de vie"
gen wine=classified_value if classification_hamburg_large=="Vin ; de France"
gen sugar=classified_value if classification_hamburg_large!="Sucre ; cru ; du Bresil"
gen indigo=classified_value if classification_hamburg_large!="Indigo"
gen eau_de_vie=classified_value if classification_hamburg_large!="Eau ; de vie"
twoway (connected other year) (connected wine year) (connected sugar year) (connected indigo year) (connected eau_de_vie year)
graph save composition_by_prod.gph, replace  

restore


***coffee
preserve

keep if classification_hamburg_large=="Café"
collapse (sum) value, by (year simplification)

gen coffee_=value if simplification=="café"
gen coffee_bourbon=value if simplification=="café de Bourbon"
gen coffee_moka=value if simplification=="café de Moka"
gen coffee_indes=value if simplification=="café des Indes"
gen coffee_levant=value if simplification=="café du Levant"
twoway (connected coffee_ year) (connected coffee_bourbon year)(connected coffee_moka year)(connected coffee_indes year) (connected coffee_levant year), title("French Exports (1750-1789)") subtitle("coffee, value") caption("source : France")
graph save coffeevalue.gph, replace 
***fix pie charte
restore 

***sugar
preserve

keep if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
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


****study wine

preserve

collapse (sum) value, by (year simplification)
twoway (connected value year) title("French Exports (1733-1789)") subtitle("Wine value") caption("source : France")
graph save winevalue.gph, replace

restore

clear


*** longitudinal evolution of classiefied products by sector

cd "/$thesis/Data/Graph"

graph pie classified_value, over (sitc_rev2) title ("French Exports (1750-1789)") subtitle ("Not classified marchandises, value, grammes d'argent") plabel(_all percen, format(%2.0f) color(white) gap(8)) plabel(_all name, color(white) gap(-8)) caption ("source : France")
graph save Class_sector, replace

preserve

collapse (sum) classified_value, by (year sitc_rev2)
rename classified_value value
gen sector_0a=value if sitc_rev2=="0a" 
gen sector_0b=value if sitc_rev2=="0b" 
gen sector_1=value if sitc_rev2=="1" 
gen sector_2=value if sitc_rev2=="2" 
gen sector_4=value if sitc_rev2=="4" 
gen sector_5=value if sitc_rev2=="5" 
gen sector_6=value if sitc_rev2=="6" 
gen sector_6a=value if sitc_rev2=="6a" 
gen sector_6b=value if sitc_rev2=="6b" 
gen sector_6c=value if sitc_rev2=="6c" 
gen sector_6d=value if sitc_rev2=="6d" 
gen sector_7=value if sitc_rev2=="7" 
gen sector_8=value if sitc_rev2=="8" 
gen sector_9=value if sitc_rev2=="9" 

twoway (connected sector_0a year) (connected sector_0b year) (connected sector_1 year) (connected sector_5 year) (connected sector_4 year) (connected sector_5 year), title("French Exports (1750-1789)") subtitle("Not classified marchandises, sectors, value") caption("source : France")
graph save not_class_sector_evolution, replace
 
restore









***LOOK AT NON CLASSIFID MARCHANDISES 

*** look at not classified marchandises which represent more than 0.1% of total value

cd "$thesis/Data/database_csv/"

preserve

egen valuesum= sum(value)
collapse (sum) notclassified_value, by (simplification valuesum)
gen value_non = notclassified_value/valuesum
keep if value_non>=.0001
outsheet using "not_classified.csv", replace

restore 


*** longitudinal evolution of non classified marchandises 

preserve

collapse (sum) notclassified_value, by (year simplification)
rename notclassified_value value
gen salt=value if simplification=="sel" | simplification=="sel d'Angleterre"
gen guinee=value if simplification=="guinée" | simplification=="indienne guinée blanc"
gen coton_laine=value if simplification=="coton de laine" 

cd "$thesis/Data/Graph/"
twoway (connected salt year) (connected guinee year) (connected coton_laine year), title("French Exports (1733-1789)") subtitle("Value of major not classified goods") caption("source : France")
graph save not_classified.gph, replace
collapse (sum) value, by (year simplification)
cd "/$thesis/Data/database.csv"
outsheet using "year_not_classified.csv", replace

restore


*** longitudinal evolution of not classiefied products by sector

cd "/$thesis/Data/Graph"

graph pie notclassified_value, over (sitc_rev2) title ("French Exports (1750-1789)") subtitle ("Not classified marchandises, value, grammes d'argent") plabel(_all percen, format(%2.0f) color(white) gap(8)) plabel(_all name, color(white) gap(-8)) caption ("source : France")
graph save not_class_sector, replace

preserve

collapse (sum) notclassified_value, by (year sitc_rev2)
rename notclassified_value value
gen sector_0a=value if sitc_rev2=="0a" 
gen sector_0b=value if sitc_rev2=="0b" 
gen sector_1=value if sitc_rev2=="1" 
gen sector_2=value if sitc_rev2=="2" 
gen sector_4=value if sitc_rev2=="4" 
gen sector_5=value if sitc_rev2=="5" 
gen sector_6=value if sitc_rev2=="6" 
gen sector_6a=value if sitc_rev2=="6a" 
gen sector_6b=value if sitc_rev2=="6b" 
gen sector_6c=value if sitc_rev2=="6c" 
gen sector_6d=value if sitc_rev2=="6d" 
gen sector_7=value if sitc_rev2=="7" 
gen sector_8=value if sitc_rev2=="8" 
gen sector_9=value if sitc_rev2=="9" 
so year

twoway (connected sector_0a year) (connected sector_0b year) (connected sector_1 year) (connected sector_5 year) (connected sector_4 year) (connected sector_5 year), title("French Exports (1750-1789)") subtitle("Not classified marchandises, sectors, value") caption("source : France")
graph save not_class_sector_evolution, replace
 
restore

*** no sensible result on this becuase stic rev doens't cover not class goods--> complete classification


























































