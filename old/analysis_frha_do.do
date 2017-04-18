*******************************************COMPARISON OF DATABASE************************************************
*****************************************************************************************************************
*****************************************************************************************************************


clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"

use "$thesis/database_dta/elisa_frhb_database.dta", clear

drop if year==.

gen value=value_fr
replace value=value_hb if sourceFRHB=="Hamburg"

**************************look at classified versus not classfied
***all years

cd "$thesis/Graph/Comparison_new/"

preserve
replace classification_hamburg_large="Not classified goods" if classification_hamburg_large=="Marchandises non classifiées"
replace classification_hamburg_large="Classified goods" if classification_hamburg_large!="Not classified goods"
collapse (sum) value, by(sourceFRHB classification_hamburg_large)
graph pie value, over(classification_hamburg_large) by(sourceFRHB, ///
legend(off) title("Classified versus unclassified goods") ///
caption("All years")) plabel(_all percen, format(%2.0f) color(white) ///
gap(8)) plabel(_all name, color(white) gap(-8)) ///
scheme(s1color)
graph export notclass_to_total_allyear.png, replace as(png)
*graph save notclass_to_total.gph, replace
restore

***common years
preserve
keep if year== 1733 | year==1734 | year==1736 | year==1737 | ///
year==1738 | year==1739 | year==1740 | year==1747 | year==1753| ///
year==1755| year==1756| year==1760| year==1762| year==1763| ///
year==1769| year==1770| year==1771| year==1773| year==1776| ///
year==1782| year==1787| year==1788| year==1789
replace classification_hamburg_large="Not classified goods" if classification_hamburg_large=="Marchandises non classifiées"
replace classification_hamburg_large="Classified goods" if classification_hamburg_large!="Not classified goods"
collapse (sum) value, by(sourceFRHB classification_hamburg_large)
graph pie value, over(classification_hamburg_large) by(sourceFRHB, ///
legend(off) title("Classified versus unclassified goods") ///
caption("Common years only")) plabel(_all percen, format(%2.0f) color(white) ///
gap(8)) plabel(_all name, color(white) gap(-8)) ///
scheme(s1color)
graph export notclass_to_total_commonyears.png, replace as(png)
restore

****evolution of ratio of two datasets
preserve
collapse (sum) value_fr value_hb, by(year)
gen ratio= value_hb/value_fr
replace ratio=. if ratio==0
twoway (connected ratio year), plotregion(fcolor(white)) graphregion(fcolor(white)) ///
title("Evolution of the ratio of value between two database")
graph export long_ratio.png, replace as(png)
restore

***longitudinal evolution of share of not classified
preserve
egen total_fr=sum(value_fr), by(year)
egen total_hb=sum(value_hb), by(year)
gen notclass_share_fr=value_fr/total_fr if classification_hamburg_large=="Marchandises non classifiées"
gen notclass_share_hb=value_hb/total_hb if classification_hamburg_large=="Marchandises non classifiées"
collapse (sum) notclass_share_fr notclass_share_hb, by(year)
replace notclass_share_fr=. if notclass_share_fr==0
replace notclass_share_hb=. if notclass_share_hb==0
capture corr notclass_share_fr notclass_share_hb
local corr : display %3.2f r(rho)
twoway (bar notclass_share_fr year)(connected notclass_share_hb year), ///
title("Share of not classified products") subtitle("Correlation: `corr'") ///
xlabel(1733(4)1789) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export notclass_share_long.png, replace as(png)
restore

**************************look at absolute value of export 

****for all years
preserve 
collapse (sum) value_fr value_hb
gen vf=1
gen vh=value_hb/value_fr
graph bar vf vh, title("Sum of French exports") ///
subtitle ("Value in Grams of silver") caption ("All years: 1733-1789") ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export value_total_fr_hb.png, replace as(png)
*graph save value_total_fr_hb, replace
restore

****for common years
preserve
collapse (sum) value_fr value_hb, by(year)
keep if year== 1733 | year==1734 | year==1736 | year==1737 | ///
year==1738 | year==1739 | year==1740 | year==1747 | year==1753| ///
year==1755| year==1756| year==1760| year==1762| year==1763| ///
year==1769| year==1770| year==1771| year==1773| year==1776| ///
year==1782| year==1787| year==1788| year==1789 
collapse (sum) value_fr value_hb
gen vf=1
gen vh=value_hb/value_fr
graph bar vf vh, title("Sum of French exports") subtitle("Value in Grams of silver") ///
caption("Common years: 1756, 1769, 1770, 1771, 1773, 1776, 1782, 1787, 1788, 1789") ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export value_total_fr_hb_commonyears.png, replace as(png)
*graph save value_total_fr_hb_commonyears, replace
restore

* --> France value result much higher because destination is "North"


*********************************longitudinal evolution of total export**************************************************************
preserve 
collapse (sum) value_fr value_hb, by(year)
su value_fr if year==1787
gen vf=value_fr/r(mean)
su value_hb if year==1787
gen vh=value_hb/r(mean)
replace vf=. if vf==0
replace vh=. if vh==0
corr vf vh
capture corr vf vh
local corr : display %3.2f r(rho)

twoway (connected vf year) (connected vh year), title("Sum of French exports") ///
subtitle("Value in Grams of silver, correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export long_evolution.png, replace as(png)
*graph save long_evolution, replace
restore


**********************************comparison at sector level****************************************************************** 

*******for all years
preserve
collapse (sum) value_fr value_hb, by(sitc_rev)
corr value_fr value_hb
capture corr value_fr value_hb
local corr : display %3.2f r(rho)
replace sitc_rev2="Other" if sitc_rev2!="0b: Foodstuff, Exotic" & ///
sitc_rev2!="1: Beverages and tobacco" & sitc_rev2!="2: Raw materials" ///
& sitc_rev2!="Not classified" & sitc_rev2!="0a: Foodstuff, European"
collapse (sum) value_fr value_hb, by(sitc_rev)
rename value_fr value1
rename value_hb value0
reshape long value, i(sitc_rev2)
label define source 1 "France" 0 "Hamburg"
label values _j source
graph pie value, over (sitc_rev2) by(_j, title("French Exports (1750-1789)") ///
subtitle("Decomposition by sector. Correlation : `corr'")) ///
caption("All years") plabel(_all percen, format(%2.0f) color(white) gap(8)) ///
scheme(s1color)
graph export allyears_sector.png, replace as(png)
*graph save commonyears_sector, replace
restore

*********only for common years
preserve
collapse (sum) value_fr value_hb , by(sitc_rev2 year)
keep if year== 1733 | year==1734 | year==1736 | year==1737 | year==1738 | ///
year==1739 | year==1740 | year==1747 | year==1753| year==1755| ///
year==1756| year==1760| year==1762| year==1763| year==1769| year==1770| ///
year==1771| year==1773| year==1776| year==1782| year==1787| year==1788| year==1789 
collapse (sum) value_fr value_hb, by(sitc_rev)
corr value_fr value_hb
capture corr value_fr value_hb
local corr : display %3.2f r(rho)
replace sitc_rev2="Other" if sitc_rev2!="0b: Foodstuff, Exotic" & ///
sitc_rev2!="1: Beverages and tobacco" & sitc_rev2!="2: Raw materials" ///
& sitc_rev2!="Not classified" & sitc_rev2!="0a: Foodstuff, European"
collapse (sum) value_fr value_hb, by(sitc_rev)
rename value_fr value1
rename value_hb value0
reshape long value, i(sitc_rev2)
label define source 1 "France" 0 "Hamburg"
label values _j source
graph pie value, over (sitc_rev2) by(_j, title("French Exports (1750-1789)") ///
subtitle("Decomposition by sector. Correlation : `corr'")) ///
caption("Common years only") plabel(_all percen, format(%2.0f) color(white) gap(8)) ///
scheme(s1color)
graph export commonyears_sector.png, replace as(png)
*graph save commonyears_sector, replace
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
twoway (bar vf year) (connected vh year), title("Exotic foodstuff") ///
subtitle("Correlation: `corr'")  xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export exotic_food_long.png, replace as(png)
*graph save exotic_food_long, replace
restore

preserve
collapse (sum) value_fr value_hb, by(year sitc_rev2)
egen total_fr=sum(value_fr), by(year)
gen exotic_share_fr=value_fr/total_fr
replace exotic_share_fr=. if sitc_rev2!="2: Raw materials"
replace exotic_share_fr=. if exotic_share_fr==0
egen total_hb=sum(value_hb), by(year)
gen exotic_share_hb=value_hb/total_hb
replace exotic_share_hb=. if sitc_rev2!="2: Raw materials"
replace exotic_share_hb=. if exotic_share_hb==0
capture corr exotic_share_hb exotic_share_fr
local corr : display %3.2f r(rho)
twoway (bar exotic_share_fr year) (connected exotic_share_hb year), ///
title("Evolution of the share of exotic foodstuff") ///
subtitle("Correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export exotic_food_share.png, replace as(png)
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
twoway (bar vf year) (connected vh year), title("Beverages and tobacco") ///
subtitle("Correlation: `corr'")  xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export bev_tobacco_long.png, replace as(png)
*graph save bev_tobacco_long, replace
restore

preserve
collapse (sum) value_fr value_hb, by(year sitc_rev2)
egen total_fr=sum(value_fr), by(year)
gen bev_share_fr=value_fr/total_fr
replace bev_share_fr=. if sitc_rev2!="2: Raw materials"
replace bev_share_fr=. if bev_share_fr==0
egen total_hb=sum(value_hb), by(year)
gen bev_share_hb=value_hb/total_hb
replace bev_share_hb=. if sitc_rev2!="2: Raw materials"
replace bev_share_hb=. if bev_share_hb==0
capture corr bev_share_hb bev_share_fr
local corr : display %3.2f r(rho)
twoway (bar bev_share_fr year) (connected bev_share_hb year), ///
title("Evolution of the share of beverages and tobacco") ///
subtitle("Correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export bev_tobacco_share.png, replace as(png)
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
twoway (bar vf year) (connected vh year), title("Raw material") ///
subtitle("Correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export raw_mat_long.png, replace as(png)
*graph save raw_mat_long, replace
restore

preserve
collapse (sum) value_fr value_hb, by(year sitc_rev2)
egen total_fr=sum(value_fr), by(year)
gen rawmat_share_fr=value_fr/total_fr
replace rawmat_share_fr=. if sitc_rev2!="2: Raw materials"
replace rawmat_share_fr=. if rawmat_share_fr==0
egen total_hb=sum(value_hb), by(year)
gen rawmat_share_hb=value_hb/total_hb
replace rawmat_share_hb=. if sitc_rev2!="2: Raw materials"
replace rawmat_share_hb=. if rawmat_share_hb==0
capture corr rawmat_share_hb rawmat_share_fr
local corr : display %3.2f r(rho)
twoway (bar rawmat_share_fr year) (connected rawmat_share_hb year), ///
title("Evolution of the share of raw material") ///
subtitle("Correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export rawmat_share.png, replace as(png)
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
twoway (bar vf year) (connected vh year), title("European Foodstuff") ///
subtitle("Correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export europ_food_long.png, replace as(png)
*graph save europ_food_long, replace
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
twoway (bar vf year) (connected vh year), title("Not classified") ///
subtitle("Correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export notclass_long.png, replace as(png)
*graph save not_class_long, replace
restore

*** --> problem with data on not classified (-.34) beverages and tobacco (0.01) and on raw material (-.23) 




**********************************comparison at product level********************************************************************

*******for all years

preserve
collapse (sum) value_fr value_hb, by(classification_hamburg_large)
capture corr value_fr value_hb
local corr : display %3.2f r(rho)
rename value_fr value1
rename value_hb value0
reshape long value, i(classification_hamburg_large)
label define source 1 "France" 0 "Hamburg"
label values _j source
replace classification_hamburg_large="Other" if ///
classification_hamburg_large!="Café" & ///
classification_hamburg_large!="Vin ; de France" & ///
classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" ///
& classification_hamburg_large!="Indigo" & classification_hamburg_large!="Eau ; de vie"
graph pie value, over (classification_hamburg_large) by(_j, ///
title("French Exports (1733-1789)") subtitle("Decomposition by products. Correlation : `corr'")) ///
caption("All years") plabel(_all percen, format(%2.0f) color(white) gap(8)) ///
scheme(s1color) ///
legend(label(1 "Coffee") label(2 "Eau de vie") label(3 "Indigo") ///
label(4 "Other") label(5 "Sugar") label(6 "Wine"))
graph export allyears_products.png, as(png) replace 
*graph save allyears_products, replace
restore


*********only for common years
preserve
collapse (sum) value_fr value_hb, by(classification_hamburg_large year)
keep if year== 1733 | year==1734 | year==1736 | year==1737 | year==1738 ///
| year==1739 | year==1740 | year==1747 | year==1753| year==1755| year==1756| ///
year==1760| year==1762| year==1763| year==1769| year==1770| year==1771| year==1773| ///
year==1776| year==1782| year==1787| year==1788| year==1789 
capture corr value_fr value_hb
local corr : display %3.2f r(rho)
collapse (sum) value_fr value_hb, by(classification_hamburg_large)
rename value_fr value1
rename value_hb value0
reshape long value, i(classification_hamburg_large)
label define source 1 "France" 0 "Hamburg"
label values _j source
replace classification_hamburg_large="Other" if classification_hamburg_large!="Café" ///
& classification_hamburg_large!="Vin ; de France" & ///
classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & ///
classification_hamburg_large!="Indigo" & classification_hamburg_large!="Eau ; de vie"
graph pie value, over (classification_hamburg_large) ///
by(_j, title("French Exports (1733-1789)") ///
subtitle("Decomposition by products. Correlation : `corr'")) ///
caption("Common years only") scheme(s1color) ///
legend(label(1 "Coffee") label(2 "Eau de vie") label(3 "Indigo") ///
label(4 "Other") label(5 "Sugar") label(6 "Wine")) ///
plabel(_all percen, format(%2.0f) color(white) gap(8))
graph export commonyears_products.png, replace as(png)
*graph save commonyears_products, replace
restore


*********evolution of coffee
preserve
keep if classification_hamburg_large=="Café"
collapse (sum) value_fr value_hb, by(year)
su value_fr if year==1787
gen vf=value_fr/r(mean)
su value_hb if year==1787
gen vh=value_hb/r(mean)
replace vf=. if vf==0
replace vh=. if vh==0
capture corr vf vh
local corr : display %3.2f r(rho)
twoway scatter value_fr value_hb || lfit value_fr value_hb
twoway (bar vf year) (connected vh year), title("Coffee") ///
subtitle("Correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export coffee_long.png, replace as(png)
*graph save coffee_long, replace
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
twoway (bar vf year) (connected vh year), ///
title("Wine") subtitle("Correlation: `corr'") ///
xlabel(1733(4)1789) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export wine_long.png, replace as(png)
*graph save wine_long, replace
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
twoway (bar vf year) (connected vh year), title("Sugar") ///
subtitle("Correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export sugar_long.png, replace as(png)
*graph save  sugar_long, replace
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
twoway (bar vf year) (connected vh year), title("Indigo") ///
subtitle("Correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export indigo_long.png, replace as(png)
*graph save indigo_long, replace
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
twoway (bar vf year) (connected vh year), title("Eau de vie") ///
subtitle("Correlation: `corr'") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export eaudevie_long.png, replace as(png)
*graph save eaudevie_long, replace
restore


*** --> problem with data on indigo (-.19) wine (0.0) and on raw material (-.23) 




**********************************evolution of share of main products********************************************************************

*preserve
replace classification_hamburg_large="Other" if classification_hamburg_large!="Café" ///
& classification_hamburg_large!="Vin ; de France" & ///
classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" ///
& classification_hamburg_large!="Indigo" & classification_hamburg_large!="Eau ; de vie"
collapse (sum) value_fr value_hb, by(year classification_hamburg_large)
egen tot_year_fr=sum(value_fr), by(year)
egen tot_year_hb=sum(value_hb), by(year)

gen coffee_share_fr=value_fr/tot_year_fr if classification_hamburg_large=="Café"
gen coffee_share_hb=value_hb/tot_year_hb if classification_hamburg_large=="Café"
capture corr coffee_share_hb coffee_share_fr
local corr : display %3.2f r(rho)
twoway (bar coffee_share_fr year) (connected coffee_share_hb year), ///
title("Evolution of the share of Coffee") subtitle("Correlation: `corr'") ///
xlabel(1733(4)1789) plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export coffee_share_long.png, replace as(png)
*graph save coffee_share_long, replace

gen wine_share_fr=value_fr/tot_year_fr if classification_hamburg_large=="Vin ; de France"
gen wine_share_hb=value_hb/tot_year_hb if classification_hamburg_large=="Vin ; de France"
capture corr wine_share_hb wine_share_fr
local corr : display %3.2f r(rho)
twoway (bar wine_share_fr year) (connected wine_share_hb year), ///
title("Evolution of the share of Wine") subtitle("Correlation: `corr'") ///
xlabel(1733(4)1789) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export wine_share_long.png, replace as(png)
*graph save wine_share_long, replace

gen sugar_share_fr=value_fr/tot_year_fr if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
gen sugar_share_hb=value_hb/tot_year_hb if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
capture corr sugar_share_hb sugar_share_fr
local corr : display %3.2f r(rho)
twoway (bar sugar_share_fr year) (connected sugar_share_hb year), ///
title("Evolution of the share of Sugar") subtitle("Correlation: `corr'") ///
xlabel(1733(4)1789) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export sugar_share_long.png, replace as(png)
*graph save sugar_share_long, replace

gen indigo_share_fr=value_fr/tot_year_fr if classification_hamburg_large=="Indigo"
gen indigo_share_hb=value_hb/tot_year_hb if classification_hamburg_large=="Indigo"
replace indigo_share_hb=. if classification_hamburg_large!="Indigo"| indigo_share_hb==0
capture corr indigo_share_hb indigo_share_fr
local corr : display %3.2f r(rho)
twoway (bar indigo_share_fr year) (connected indigo_share_hb year), ///
title("Evolution of the share of Indigo") subtitle("Correlation: `corr'") ///
xlabel(1733(4)1789) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export indigo_share_long.png, replace as(png)
*graph save indigo_share_long, replace

gen eaudevie_share_fr=value_fr/tot_year_fr if classification_hamburg_large=="Eau ; de vie"
gen eaudevie_share_hb=value_hb/tot_year_hb if classification_hamburg_large=="Eau ; de vie"
capture corr eaudevie_share_hb eaudevie_share_fr
local corr : display %3.2f r(rho)
twoway (bar eaudevie_share_fr year)(connected eaudevie_share_hb year), ///
title("Evolution of the share of Eau de vie") subtitle("Correlation: `corr'") ///
xlabel(1733(4)1789) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export eaudevie_share_long.png, replace as(png)
*graph save eaudevie_share_long, replace

gen other_share_fr=value_fr/tot_year_fr if classification_hamburg_large=="Other"
gen other_share_hb=value_hb/tot_year_hb if classification_hamburg_large=="Other"
capture corr other_share_fr other_share_hb
local corr : display %3.2f r(rho)
twoway (bar other_share_fr year)(connected other_share_hb year), ///
title("Evolution of the share of other goods") subtitle("Correlation: `corr'") ///
xlabel(1733(4)1789) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "France") label(2 "Hamburg"))
graph export other_share_long.png, replace as(png)
*graph save eaudevie_share_long, replace


twoway (bar coffee_share_hb year) (bar wine_share_hb year) ///
(bar sugar_share_hb year) (bar indigo_share_hb year) ///
(bar eaudevie_share_hb year)(bar other_share_hb year), ///
title("Evolution of the share of important goods") ///
subtitle("Source: Hamburg") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "Coffee") label(2 "Wine") label(3 "Sugar") ///
label(4 "Indigo") label(5 "Eau de vie") label(6 "Other"))
graph export long_share_product_hb.png, replace as(png)
*graph save long_share_product_hb, replace

twoway (connected coffee_share_fr year) (connected wine_share_fr year) ///
(connected sugar_share_fr year) (connected indigo_share_fr year) ///
(connected eaudevie_share_fr year)(connected other_share_fr year), ///
title("Evolution of the share of important goods") ///
subtitle("Source: France") xlabel(1733(4)1789) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
legend(label(1 "Coffee") label(2 "Wine") label(3 "Sugar") ///
label(4 "Indigo") label(5 "Eau de vie") label(6 "Other"))
graph export long_share_product_fr.png, replace as(png)
*graph save long_share_product_hb, replace

restore


**********************************evolution of share of main sectors********************************************************************

preserve
collapse (sum) value_fr value_hb, by(year sitc_rev2)
egen tot_year_fr=sum(value_fr), by(year)
egen tot_year_hb=sum(value_hb), by(year)

gen european_food_fr=value_fr/tot_year_fr if sitc_rev2=="0a: Foodstuff, European"
gen exotic_food_fr=value_fr/tot_year_fr if sitc_rev2=="0b: Foodstuff, Exotic"
gen bev_tobacco_fr=value_fr/tot_year_fr if sitc_rev2=="1: Beverages and tobacco"
gen raw_mat_fr=value_fr/tot_year_fr if sitc_rev2=="2: Raw materials"
gen oil_fr=value_fr/tot_year_fr if sitc_rev2=="4: Oils"
gen fiveb_fr=value_fr/tot_year_fr if sitc_rev2=="5b"
gen manuf_material_fr=value_fr/tot_year_fr if sitc_rev2=="6: Manuf. goods, by material"
gen manuf_mix_fr=value_fr/tot_year_fr if sitc_rev2=="8: Misc. manuf. goods"
gen not_class_fr=value_fr/tot_year_fr if sitc_rev2=="Not classified"

gen european_food_hb=value_hb/tot_year_hb if sitc_rev2=="0a: Foodstuff, European"
gen exotic_food_hb=value_hb/tot_year_hb if sitc_rev2=="0b: Foodstuff, Exotic"
gen bev_tobacco_hb=value_hb/tot_year_hb if sitc_rev2=="1: Beverages and tobacco"
gen raw_mat_hb=value_hb/tot_year_hb if sitc_rev2=="2: Raw materials"
gen oil_hb=value_hb/tot_year_hb if sitc_rev2=="4: Oils"
gen fiveb_hb=value_hb/tot_year_hb if sitc_rev2=="5b"
gen manuf_material_hb=value_hb/tot_year_hb if sitc_rev2=="6: Manuf. goods, by material"
gen manuf_mix_hb=value_hb/tot_year_hb if sitc_rev2=="8: Misc. manuf. goods"
gen not_class_hb=value_hb/tot_year_hb if sitc_rev2=="Not classified"


twoway (bar european_food_fr year) (bar exotic_food_fr year) ///
(bar bev_tobacco_fr year) (bar raw_mat_fr year) ///
(bar oil_fr year)(bar fiveb_fr year) (bar manuf_material_fr year) ///
(bar manuf_mix_fr year) (bar not_class_fr year), ///
title("Evolution of the share of sectors") ///
subtitle("Source: France") xlabel(1733(4)1789) ///
legend(label(1 "Foodstuff, European") label(2 "Foodstuff, Exotic") ///
label(3 "Beverages and tobacco") label(4 "Raw materials") ///
label(5 "Oils") label(6 "5b") label(7 "Manuf. goods, by material") ///
label(8 "Misc. manuf. goods") label(9 "Not classified")) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) 
graph export long_share_sector_fr.png, replace as(png)
*graph save long_share_product_hb, replace

twoway (bar european_food_hb year) (bar exotic_food_hb year) ///
(bar bev_tobacco_hb year) (bar raw_mat_hb year) ///
(bar oil_hb year)(bar fiveb_hb year) (bar manuf_material_hb year) ///
(bar manuf_mix_hb year) (bar not_class_hb year), ///
title("Evolution of the share of sectors") ///
subtitle("Source: Hamburg") xlabel(1733(4)1789) ///
legend(label(1 "Foodstuff, European") label(2 "Foodstuff, Exotic") ///
label(3 "Beverages and tobacco") label(4 "Raw materials") ///
label(5 "Oils") label(6 "5b") label(7 "Manuf. goods, by material") ///
label(8 "Misc. manuf. goods") label(9 "Not classified")) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) 
graph export long_share_sector_hb.png, replace as(png)
*graph save long_share_product_hb, replace

restore






