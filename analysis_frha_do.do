*******************************************COMPARISON OF DATABASE************************************************
*****************************************************************************************************************
*****************************************************************************************************************


clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

use "elisa_frhb_database.dta"


**************************look at absolute value of export 

****for all years
graph bar (sum) value_fr value_hb, over(sourceFRHB) title("Sum of French exports") subtitle ("Value in Grams of silver") caption ("All years: 1733-1789")
graph save "value_total_fr_hb", replace

****for common years
preserve 
keep if  year==1756 | year==1760 |  year==1769 | year==1770 | year==1771 | year==1773 | year==1776 | year==1782 | year==1787 |year==1788  | year==1789
graph bar (sum) value_fr value_hb, over(sourceFRHB) title("Sum of French exports") subtitle ("Value in Grams of silver") caption ("Common years: 1756, 1769, 1770, 1771, 1773, 1776, 1782, 1787, 1788, 1789")
graph save "value_total_fr_hb_commonyears", replace
restore

* --> France value result much higher because destination is "North"


*********************************longitudinal evolution of total export**************************************************************
preserve 
collapse (sum) value_fr value_hb, by(year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)

twoway (connected vf year) (connected vh year), title("Sum of French exports") subtitle("Value in Grams of silver, correlation: `corr'")
graph save "long_evolution", replace

restore


**********************************comparison at sector level****************************************************************** 

*******for all years
gen value=value_fr
replace value=value_hb if sourceFRHB=="Hamburg"

preserve
collapse (sum) value_fr value_hb, by(sitc_rev2)
capture corr value_fr value_hb
local corr : display %3.2f r(rho)
restore

preserve
collapse (sum) value, by(sitc_rev2 sourceFRHB)
replace sitc_rev2="Other" if sitc_rev2!="0b: Foodstuff, Exotic" & sitc_rev2!="1: Beverages and tobacco" & sitc_rev2!="2: Raw material" & sitc_rev2!="Not classified" & sitc_rev2!="0a: Foodstuff, European"
graph pie value, over (sitc_rev2) by(sourceFRHB, title("French Exports (1733-1789)") subtitle("Sectoral decomposition for all years. Correlation : `corr'")) plabel(_all percen, format(%2.0f) color(white) gap(8))
graph save "allyears_sector", replace
restore


*********only for common years
preserve
collapse (sum) value_fr value_hb, by(sitc_rev2 year)
keep if value_fr!=0 & value_hb!=0
capture corr value_fr value_hb
local corr : display %3.2f r(rho)
restore

preserve
collapse (sum) value, by(sitc_rev2 year sourceFRHB)
keep if value!=0
collapse (sum) value, by(sitc_rev2 sourceFRHB)
replace sitc_rev2="Other" if sitc_rev2!="0b: Foodstuff, Exotic" & sitc_rev2!="1: Beverages and tobacco" & sitc_rev2!="2: Raw materials" & sitc_rev2!="Not classified" & sitc_rev2!="0a: Foodstuff, European"
graph pie value, over (sitc_rev2) by(sourceFRHB, title("French Exports (1750-1789)") subtitle("Sectoral decomposition for common years only. Correlation : `corr'")) plabel(_all percen, format(%2.0f) color(white) gap(8))
graph save "commonyears_sector", replace
restore


**********longitudinal evolution 

*****exotic foodstuff
preserve

keep if sitc_rev2=="0b: Foodstuff, Exotic"
collapse (sum) value_fr value_hb, by(year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Exotic foodstuff") subtitle("Correlation: `corr'")
graph save "exotic_food_long", replace
restore


*****beverages and tobacco
preserve

keep if sitc_rev2=="1: Beverages and tobacco"
collapse (sum) value_fr value_hb, by(year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Beverages and tobacco") subtitle("Correlation: `corr'")
graph save "bev_tobacco_long", replace
restore


******Raw material
preserve

keep if sitc_rev2=="2: Raw materials"
collapse (sum) value_fr value_hb, by(sitc_rev2 year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Raw material") subtitle("Correlation: `corr'")
graph save "raw_mat_long", replace
restore

*********European Foodstuff


preserve

keep if sitc_rev2=="0a: Foodstuff, European"
collapse (sum) value_fr value_hb, by(sitc_rev2 year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("European Foodstuff") subtitle("Correlation: `corr'")
graph save "europ_food_long", replace
restore


********Not classified

preserve

keep if sitc_rev2=="Not classified"
collapse (sum) value_fr value_hb, by(sitc_rev2 year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Not classified") subtitle("Correlation: `corr'")
graph save "not_class_long", replace
restore

*** --> problem with data on not classified (-.34) beverages and tobacco (0.01) and on raw material (-.23) 




**********************************comparison at product level********************************************************************

*******for all years

preserve
collapse (sum) value_fr value_hb, by(classification_hamburg_large)
capture corr value_fr value_hb
local corr : display %3.2f r(rho)
restore

preserve
collapse (sum) value, by(classification_hamburg_large sourceFRHB)
replace classification_hamburg_large="Other" if classification_hamburg_large!="Café" & classification_hamburg_large!="Vin ; de France" & classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Indigo" & classification_hamburg_large!="Eau ; de vie"
graph pie value, over (classification_hamburg_large) by(sourceFRHB, title("French Exports (1733-1789)") subtitle("Decomposition by products for all years. Correlation : `corr'")) plabel(_all percen, format(%2.0f) color(white) gap(8))
graph save "allyears_products", replace
restore


*********only for common years
preserve
collapse (sum) value_fr value_hb, by(classification_hamburg_large year)
keep if value_fr!=0 & value_hb!=0
capture corr value_fr value_hb
local corr : display %3.2f r(rho)
restore

preserve
collapse (sum) value, by(classification_hamburg_large sourceFRHB year)
keep if value!=0
collapse (sum) value, by(classification_hamburg_large sourceFRHB)
replace classification_hamburg_large="Other" if classification_hamburg_large!="Café" & classification_hamburg_large!="Vin ; de France" & classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Indigo" & classification_hamburg_large!="Eau ; de vie"
graph pie value, over (classification_hamburg_large) by(sourceFRHB, title("French Exports (1733-1789)") subtitle("Decomposition by products for common years only. Correlation : `corr'")) plabel(_all percen, format(%2.0f) color(white) gap(8))
graph save "commonyears_products", replace
restore


*********evolution of coffee
preserve
keep if classification_hamburg_large=="Café"
collapse (sum) value_fr value_hb, by(year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway scatter value_fr value_hb || lfit value_fr value_hb
twoway (connected vf year) (connected vh year), title("Coffee") subtitle("Correlation: `corr'")
graph save "coffee_long", replace
restore

*********evolution of wine

preserve
keep if classification_hamburg_large=="Vin ; de France"
collapse (sum) value_fr value_hb, by(year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Wine") subtitle("Correlation: `corr'")
graph save "wine_long", replace
restore




************evolution of sugar
preserve
keep if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
collapse (sum) value_fr value_hb, by(year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Sugar") subtitle("Correlation: `corr'")
graph save "sugar_long", replace
restore


************evolution of indigo
preserve
keep if classification_hamburg_large=="Indigo"
collapse (sum) value_fr value_hb, by(year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Indigo") subtitle("Correlation: `corr'")
graph save "indigo_long", replace
restore


************evolution of eau de vie
preserve
keep if classification_hamburg_large=="Eau ; de vie"
collapse (sum) value_fr value_hb, by(year)
su value_fr if year==1787
gen index_fr=r(mean)
su value_hb if year==1787
gen index_hb=r(mean)
gen vf=value_fr/index_fr
gen vh=value_hb/index_hb
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Eau de vie") subtitle("Correlation: `corr'")
graph save "eaudevie_long", replace
restore


*** --> problem with data on indigo (-.19) wine (0.0) and on raw material (-.23) 




**********************************evolution of share of main products********************************************************************

preserve
replace classification_hamburg_large="Other" if classification_hamburg_large!="Café" & classification_hamburg_large!="Vin ; de France" & classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Indigo" & classification_hamburg_large!="Eau ; de vie"
collapse (sum) value_fr value_hb, by(year classification_hamburg_large)
egen tot_year_fr=sum(value_fr), by(year)
egen tot_year_hb=sum(value_hb), by(year)

gen coffee_share_fr=value_fr/tot_year_fr
replace coffee_share_fr=. if classification_hamburg_large!="Café"| coffee_share_fr==0
gen coffee_share_hb=value_hb/tot_year_hb
replace coffee_share_hb=. if classification_hamburg_large!="Café"| coffee_share_hb==0

gen wine_share_fr=value_fr/tot_year_fr
replace wine_share_fr=. if classification_hamburg_large!="Vin ; de France"| wine_share_fr==0
gen wine_share_hb=value_hb/tot_year_hb
replace wine_share_hb=. if classification_hamburg_large!="Vin ; de France"| wine_share_hb==0

gen sugar_share_fr=value_fr/tot_year_fr
replace sugar_share_fr=. if classification_hamburg_large!="Sucre ; cru blanc ; du Brésil"| sugar_share_fr==0
gen sugar_share_hb=value_hb/tot_year_hb
replace sugar_share_hb=. if classification_hamburg_large!="Sucre ; cru blanc ; du Brésil"| sugar_share_hb==0

gen indigo_share_fr=value_fr/tot_year_fr
replace indigo_share_fr=. if classification_hamburg_large!="Indigo"| indigo_share_fr==0
gen indigo_share_hb=value_hb/tot_year_hb
replace indigo_share_hb=. if classification_hamburg_large!="Indigo"| indigo_share_hb==0

gen eaudevie_share_fr=value_fr/tot_year_fr
replace eaudevie_share_fr=. if classification_hamburg_large!="Eau ; de vie"| eaudevie_share_fr==0
gen eaudevie_share_hb=value_hb/tot_year_hb
replace eaudevie_share_hb=. if classification_hamburg_large!="Eau ; de vie"| eaudevie_share_hb==0

gen other_share_fr=value_fr/tot_year_fr
replace other_share_fr=. if classification_hamburg_large!="Other"| other_share_fr==0
gen other_share_hb=value_hb/tot_year_hb
replace other_share_hb=. if classification_hamburg_large!="Other"| other_share_hb==0

twoway (connected coffee_share_fr year) (connected coffee_share_hb year), title("Evolution of the share of Coffee")
graph save coffee_share_long, replace
twoway (connected wine_share_fr year) (connected coffee_share_hb year), title("Evolution of the share of Wine")
graph save wine_share_long, replace
twoway (connected sugar_share_fr year) (connected coffee_share_hb year), title("Evolution of the share of Sugar") 
graph save sugar_share_long, replace
twoway (connected indigo_share_fr year) (connected coffee_share_hb year), title("Evolution of the share of Indigo") 
graph save indigo_share_long, replace
twoway (connected eaudevie_share_fr year)(connected coffee_share_hb year), title("Evolution of the share of Eau de vie") 
graph save eaudevie_share_long, replace

twoway (bar coffee_share_hb year) (bar wine_share_hb year) (bar sugar_share_hb year) (bar indigo_share_hb year) (bar eaudevie_share_hb year)(bar other_share_hb year), title("Evolution of the share of important goods") subtitle("Source: Hamburg")
graph save long_share_product_hb, replace

restore












