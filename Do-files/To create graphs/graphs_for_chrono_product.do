****Various graphs




if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hamburg/"
	global hamburggit "~/Documents/Recherche/2016 Hamburg/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="TIRINDEE" {
	global hamburg "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}



set more off
/*
****hamburg1
use "$hamburg/database_dta/hamburg1", clear

drop if year<1752

label var value Value
twoway (connected value year), title("Hamburg series") ///
yscale(off) plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$hamburggit/tex/growth_rate.png", replace as(png) 

****hamburg2
use "$hamburg/database_dta/hamburg2", clear
drop if value==.
drop if year<1752
label define order_class 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode hamburg_classification, gen(class) label(order_class)
label var value Value

foreach i of num 1/5{
su value if class==`i'
gen indexed_`i'=value/r(mean) if class==`i'
}

label var indexed_1 Coffee
label var indexed_2 "Eau de vie"
label var indexed_3 Sugar
label var indexed_4 Wine

twoway (connected indexed_1 year) (connected indexed_2 year) ///
	(connected indexed_3 year) (connected indexed_4 year) if ///
	year<1780 & year>1752, title("Product trend between 1750 and 1780") ///
	caption("Values indexed at product average") plotregion(fcolor(white)) ///
	graphregion(fcolor(white)) subtitle("Hamburg")
graph export "$hamburggit/tex/hamburg_product_1780.png", replace as(png) 
	
twoway (connected indexed_1 year) (connected indexed_2 year) ///
	(connected indexed_3 year) (connected indexed_4 year) if year>1779, ///
	title("Product trend between 1780 and 1820") subtitle("Hamburg") plotregion(fcolor(white)) ///
	graphregion(fcolor(white)) caption("Values indexed at product average")
graph export "$hamburggit/tex/hamburg_product_1820.png", replace as(png) 

*/
****allcountry2



capture program drop graph_per_goods
program graph_per_goods
args prod_typo predicted

*exemple graph_per_goods hamburg/sitc 0/1 without the predicted
*graph_per_goods hamburg 1 with the predicted

display "`prod_typo'"

if "`prod_typo'" == "hamburg" use "$hamburg/database_dta/allcountry2.dta", clear
if "`prod_typo'" == "sitc" use "$hamburg/database_dta/allcountry2_sitc.dta", clear

if "`prod_typo'" == "hamburg" local prod_var hamburg_classification
if "`prod_typo'" == "sitc" local prod_var sitc18_en


/*
drop if year<1752
drop if year==1766 & hamburg_classification=="Sugar"
drop if country_grouping=="France"
drop if country_grouping=="Indes"
drop if country_grouping=="Espagne-Portugal"
drop if country_grouping=="Nord-Hollande"
*/

local obs_num=_N+1
set obs `obs_num'
replace year=1793 if year==.



collapse (sum) value, by(year `prod_var' predicted)

if `predicted' == 0 {
	keep if predicted==0
}


/*

label define order_class 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode hamburg_classification, gen(class) label(order_class)


foreach i of num 1/5{
su value if class==`i'
gen indexed_`i'=value/r(mean) if class==`i'
}

label var indexed_1 Coffee
label var indexed_2 "Eau de vie"
label var indexed_3 Sugar
label var indexed_4 Wine


twoway (connected indexed_1 year) (connected indexed_2 year) ///
	(connected indexed_3 year) (connected indexed_4 year) if ///
	year<1780 & year>1749, title("Product trend between 1750 and 1780") ///
	caption("Values indexed at product average") plotregion(fcolor(white)) ///
	graphregion(fcolor(white)) subtitle("All countries")
graph export "$hamburggit/tex/allcountry_product_1780.png", replace as(png) 
	
twoway (connected indexed_1 year) (connected indexed_2 year) ///
	(connected indexed_3 year) (connected indexed_4 year) if year>1779, ///
	title("Product trend between 1780 and 1820") plotregion(fcolor(white)) ///
	graphregion(fcolor(white)) caption("Values indexed at product average") ///
	subtitle("All countries")
graph export "$hamburggit/tex/allcountry_product_1820.png", replace as(png) 


*/
replace value=log10(value)


levelsof `prod_var', local(prod_list)

foreach prod of local prod_list{

su value if `prod_var'=="`prod'"
local maxvalue =r(max)+0.2
local minvalue =r(min)+0.2


generate wara=`maxvalue' if year >=1733 & year <=1738 
generate warb=`maxvalue' if year >=1740 & year <=1744
generate war1=`maxvalue' if year >=1744 & year <=1748
generate war2=`maxvalue' if year >=1756 & year <=1763
generate war3=`maxvalue' if year >=1778 & year <=1783
generate war4=`maxvalue' if year >=1793 & year <=1802
generate war5=`maxvalue' if year >=1803 & year <=1815

sort year
display "`prod'"
display `maxvalue'
display "yscale(range(`minvalue' `maxvalue'))"


graph twoway (area wara year, color(gs14)) ///
			 (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9)) ///
			 (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4))  ///
			 (connected value year if `prod_var'=="`prod'", lcolor(blue) ///
			 msize(tiny) mcolor(blue)), ///
			 title("`prod'") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 ytitle("Tons of silver, log10") ///
			 yscale(range(`minvalue' `maxvalue')) ///
			 ylabel(`minvalue' (0.5) `maxvalue') ///
			 legend(off)
			 
local prod=subinstr("`prod'"," ","_",10)
local prod=subinstr("`prod'",";","_",10)
local prod=subinstr("`prod'","__","_",10)
local prod=subinstr("`prod'","__","_",10)
local prod=subinstr("`prod'","__","_",10)
			 
graph export "$hamburggit/tex/Paper/class_`prod_typo'_`prod'_chrono_p`predicted'.png", as(png) replace	

drop war*		 
	

}

end

graph_per_goods sitc 0
graph_per_goods sitc 1
graph_per_goods hamburg 0
graph_per_goods hamburg 1








