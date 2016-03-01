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


*********************************longitudinal evolution of total export
preserve 
collapse (sum) value_fr value_hb, by(year)

gen vf=value_fr/271156.3
gen vh=value_hb/114567.7

replace vf=. if vf==0
replace vh=. if vh==0

label var vf "French source"
label var vh "Hambour source"

capture corr vf vh
local corr : display %3.2f r(rho)

twoway (connected vf year) (connected vh year), title("Sum of French exports") subtitle("Value in Grams of silver, correlation: `corr'")
graph save "long_evolution", replace

restore


**********************************comparison at sector level 

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
keep if value_fr!=0 & value_hb!=0
collapse (sum) value_fr value_hb, by(sitc_rev2)
capture corr value_fr value_hb
local corr : display %3.2f r(rho)
restore

preserve
keep if value_fr!=0 & value_hb!=0
collapse (sum) value, by(sitc_rev2 sourceFRHB)
replace sitc_rev2="Other" if sitc_rev2!="0b: Foodstuff, Exotic" & sitc_rev2!="1: Beverages and tobacco" & sitc_rev2!="2: Raw materials" & sitc_rev2!="Not classified" & sitc_rev2!="0a: Foodstuff, European"
graph pie value, over (sitc_rev2) by(sourceFRHB, title("French Exports (1750-1789)") subtitle("Sectoral decomposition for common years only. Correlation : `corr'")) plabel(_all percen, format(%2.0f) color(white) gap(8))
graph save "commonyears_sector", replace
restore


**********longitudinal evolution 

*****exotic foodstuff
preserve

keep if sitc_rev2=="0b: Foodstuff, Exotic"
collapse (sum) value_fr value_hb, by(sitc_rev2 year)
gen vf=value_fr/217122.13
gen vh=value_hb/100648.1
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Exotic foodstuff") subtitle("Correlation: `corr'")

restore


*****beverages and tobacco
preserve

keep if sitc_rev2=="1: Beverages and tobacco"
collapse (sum) value_fr value_hb, by(sitc_rev2 year)
gen vf=value_fr/217122.13
gen vh=value_hb/100648.1
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Beverages and tobacco") subtitle("Correlation: `corr'")

restore


******Raw material
preserve

keep if sitc_rev2=="2: Raw materials"
collapse (sum) value_fr value_hb, by(sitc_rev2 year)
gen vf=value_fr/217122.13
gen vh=value_hb/100648.1
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Raw material") subtitle("Correlation: `corr'")

restore

*********European Foodstuff


preserve

keep if sitc_rev2=="0a: Foodstuff, European"
collapse (sum) value_fr value_hb, by(sitc_rev2 year)
gen vf=value_fr/217122.13
gen vh=value_hb/100648.1
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("European Foodstuff") subtitle("Correlation: `corr'")

restore


********Not classified

preserve

keep if sitc_rev2=="Not classified"
collapse (sum) value_fr value_hb, by(sitc_rev2 year)
gen vf=value_fr/217122.13
gen vh=value_hb/100648.1
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway (connected vf year) (connected vh year), title("Not classified") subtitle("Correlation: `corr'")

restore






**********************************comparison at product level 

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
collapse (sum) value value_fr value_hb, by(classification_hamburg_large sourceFRHB year)
keep if value_fr!=0 & value_hb!=0
replace classification_hamburg_large="Other" if classification_hamburg_large!="Café" & classification_hamburg_large!="Vin ; de France" & classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Indigo" & classification_hamburg_large!="Eau ; de vie"
graph pie value, over (classification_hamburg_large) by(sourceFRHB, title("French Exports (1750-1789)") subtitle("Decomposition by products for common years only. Correlation : `corr'")) plabel(_all percen, format(%2.0f) color(white) gap(8))
graph save "commonyears_products", replace
restore



