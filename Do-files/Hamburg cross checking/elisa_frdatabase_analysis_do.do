
clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"


***merge with units--> it is about quantities and database are really old so I'll leave it for now



***STUDY MARCHANDISES

use "$thesis/Data/database_dta/elisa_bdd_courante.dta", clear

/*collapse (sum) value, by(year unit_price sitc_rev2 simplification hamburg_classification)
gen baseyear = 1 if year == 1787
bysort baseyear (year simplification) : gen class_value_index = value / value[1]
replace value=. if value==0
replace class_value_index=. if class_value_index==0
drop value
rename class_value_index value
sort year simplification

*/replace hamburg_classification="Marchandises non classifiées" if  hamburg_classification==""
replace value=. if value==0
gen notclassified_value = value if hamburg_classification=="Marchandises non classifiées"
gen classified_value = value if hamburg_classification!="Marchandises non classifiées"

label var notclassified_value "Value of non classified goods"
label var classified_value "Value of classified goods"




*******************************LOOK AT CLASSIFIED VERSUS NON CLASSIFIED MARHCANDISES**********************************

/*preserve
collapse (sum) value notclassified_value classified_value
graph pie classified_value notclassified_value, title ("French Exports (1733-1789)") subtitle ("Value in grams of silver") caption ("source : France") plabel(_all percent, format(%3.1f))
graph export notclass_to_total.png, replace as(png)
*graph save notclass_to_total.gph, replace 
restore

****CLASSIFIED MARCHANDISES REPRESENT 96% OF TOTAL VALUE--> STUDY CLASSIFIED MARCH. COMPOSITION






*******************************STUDY CLASSIFIED MARCHANDISES***********************************************************

***look at composition of exports by product on sum sum of all years

*/cd "/$thesis/Data/Graph/France/"

preserve
collapse (sum) classified_value, by (hamburg_classification)
replace hamburg_classification="Other" if hamburg_classification!="Café" & hamburg_classification!="Vin ; de France" & hamburg_classification!="Sucre ; cru blanc ; du Brésil" & hamburg_classification!="Indigo" & hamburg_classification!="Eau ; de vie"
graph pie classified_value, over (hamburg_classification) title("Aggregate French Exports (1750-1789)") subtitle("Decomposition by product") caption("Classified products") plabel(1 "Coffee", gap(8)) plabel(2 "Indigo", gap(8)) plabel(3 "Sugar", gap(8)) plabel(4 "Eau de vie", gap(8)) plabel(5 "Other", gap(8)) plabel(6 "Wine", gap(8)) plabel(_all percent, format(%2.0f))
graph export class_byproduct.png, replace as(png)
*graph save composition_by_prod.png, replace
restore


***look at longitudinal evolution of major classified products
preserve
collapse (sum) value, by (year hamburg_classification)
replace value=. if value==0
gen other=value if hamburg_classification!="Café" & hamburg_classification!="Vin ; de France" & hamburg_classification!="Sucre ; cru blanc ; du Brésil" & hamburg_classification!="Indigo" & hamburg_classification!="Eau ; de vie"
gen wine=value if hamburg_classification=="Vin ; de France"
gen sugar=value if hamburg_classification=="Sucre ; cru ; du Bresil"
gen indigo=value if hamburg_classification=="Indigo"
gen eau_de_vie=value if hamburg_classification=="Eau ; de vie"
gen coffee=value if hamburg_classification=="Café"
*twoway (connected sugar year)
twoway (connected coffee year) (connected wine year) (connected sugar year) (connected indigo year) (connected eau_de_vie year), title("Longitudinal evolution of major products") caption("Classified products")
graph export class_byproduct_long.png, replace as(png)
*graph save composition_by_prod.gph, replace  

restore


***coffee
preserve
keep if hamburg_classification=="Café"
collapse (sum) value, by (year simplification)
replace value=. if value==0
gen coffee_=value if simplification=="café"
gen coffee_bourbon=value if simplification=="café de Bourbon"
gen coffee_moka=value if simplification=="café de Moka"
gen coffee_indes=value if simplification=="café des Indes"
gen coffee_levant=value if simplification=="café du Levant"
twoway (connected coffee_ year) (connected coffee_bourbon year)(connected coffee_moka year)(connected coffee_indes year) (connected coffee_levant year), title("Evolution of value of coffee") caption("Major classified products")
graph export coffee_long.png, replace as(png)
*graph save coffeev_long.gph, replace 
restore

preserve
keep if hamburg_classification=="Café"
collapse (sum) unit_price, by (year simplification)
replace unit_price=. if unit_price==0
gen coffee_=unit_price if simplification=="café"
gen coffee_bourbon=unit_price if simplification=="café de Bourbon"
gen coffee_moka=unit_price if simplification=="café de Moka"
gen coffee_indes=unit_price if simplification=="café des Indes"
gen coffee_levant=unit_price if simplification=="café du Levant"
twoway (connected coffee_ year) (connected coffee_bourbon year)(connected coffee_moka year)(connected coffee_indes year) (connected coffee_levant year), title("Evolution of price of coffee") caption("Major classified products")
graph export coffeeprice_long.png, replace as(png)
*graph save coffeeprice_long.gph, replace 
restore 


***sugar
preserve

keep if hamburg_classification=="Sucre ; cru blanc ; du Brésil"
collapse (sum) value, by (year simplification)
replace value=. if value==0
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
twoway (connected sugar_blanc year) (connected sugar_pain year) (connected sugar_brun year) (connected sugar_cassonade year) (connected sugar_common year) (connected sugar_terre year)(connected sugar_brut year)(connected sugar_tete year) (connected sugar_raffiné year) (connected sugar_ year), title("Evolution of value of sugar") caption("Major classified products")
graph export sugar_long.png, replace as(png)
*graph save sugar_long.gph, replace 

restore 


****wine

preserve

collapse (sum) value, by (year simplification)
replace value=. if value==0
twoway (connected value year), title("French Exports (1733-1789)") subtitle("Wine value") caption("source : France")
graph export wine_long.png, replace as(png)
*graph save wine_long.gph, replace

restore



************** look at classiefied products by sector

cd "/$thesis/Data/Graph/France/"

***composition by sector on sum of all years
graph pie classified_value, over (sitc_rev2) title("Aggregate French exports") subtitle("Decomposition by sector") caption("Classified products") plabel(_all percen, format(%2.0f) color(white) gap(8)) plabel(_all name, color(white) gap(-8))
graph export class_bysector.png, replace as(png)
*graph save class_bysector, replace

***longitudinal evolution of sector composition 
preserve
collapse (sum) classified_value, by (year sitc_rev2)
replace classified_value=. if classified_value==0
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

twoway (connected sector_0a year) (connected sector_0b year) (connected sector_1 year) (connected sector_5 year) (connected sector_4 year) (connected sector_5 year), title("Longitudinal evolution of major sectors") caption("Classified products")
graph export class_bysector_long.png, replace as(png)
*graph save not_class_sector_long, replace
 
restore









**********************************LOOK AT NON CLASSIFID MARCHANDISES**************************************************

*** look at not classified marchandises which represent more than 0.1% of total value

/*cd "$thesis/Data/database_csv/"

preserve

egen valuesum= sum(value)
collapse (sum) notclassified_value, by (simplification valuesum)
gen value_non = notclassified_value/valuesum
keep if value_non>=.0001
outsheet using "not_classified.csv", replace

restore 


*** longitudinal evolution of non classified marchandises 

*/preserve

collapse (sum) notclassified_value value, by (year simplification)

replace notclassified_value=. if notclassified_value==0
gen salt=notclassified_value if simplification=="sel" | simplification=="sel d'Angleterre"
gen siroup=notclassified_value if simplification=="sirop de mélasse"  

cd "$thesis/Data/Graph/France/"
twoway (connected salt year) (connected siroup year), title("Longitudinal evolution of major not classified products") caption("Major not classified products")
graph export notclass.png, replace as(png)
*graph save not_classified.gph, replace

egen notclass_total=sum(value), by(year)
replace notclass_total=. if notclass_total==0
gen salt_share=salt/notclass_total
replace salt_share=. if salt_share==0
twoway (connected salt_share year), title("Longitudinal evolution of the share of salt") caption("Major not classified products")
graph export salt.png, replace as(png)
*graph save salt.gph, replace

*/restore


*** longitudinal evolution of not classiefied products by sector


graph pie notclassified_value, over (sitc_rev2) title ("Aggregate French exports") subtitle ("Decomposition by sector") caption("Not classified products") plabel(_all percen, format(%2.0f) color(white) gap(8)) plabel(_all name, color(white) gap(-8))
graph export notclass_sector.png, replace as(png)
*graph save notclass_sector, replace

preserve

collapse (sum) notclassified_value, by (year sitc_rev2)
rename notclassified_value value
replace value=. if value==0
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

twoway (connected sector_0a year) (connected sector_0b year) (connected sector_1 year) (connected sector_5 year) (connected sector_4 year) (connected sector_5 year), title("Longitudinal evolution of major sectors") caption("Major not classified products")
graph export not_class_sector_long, replace as(png)
 
restore

*** no sensible result on this becuase stic rev doens't cover not class goods--> complete classification



***********************************************LOOK AT PRICES OF COFFEE AND SUGAR*******************************






















































