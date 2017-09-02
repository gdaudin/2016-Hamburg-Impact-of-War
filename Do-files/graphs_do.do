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
encode classification_hamburg_large, gen(class) label(order_class)
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


****allcountry2

<<<<<<< HEAD
=======
capture program drop graph_per_goods
program graph_per_goods
args predicted

*exemple graph_per_goods 0 without the predicted
*graph_per_goods 1 with the predicted

use "$hamburg/database_dta/allcountry2", clear

/*
drop if year<1752
>>>>>>> origin/master
drop if year==1766 & classification_hamburg_large=="Sugar"
drop if pays_grouping=="France"
drop if pays_grouping=="Indes"
drop if pays_grouping=="Espagne-Portugal"
drop if pays_grouping=="Nord-Hollande"
*/

local obs_num=_N+1
set obs `obs_num'
replace year=1793 if year==.

collapse (sum) value, by(year classification_hamburg_large predicted)

label define order_class 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order_class)


foreach i of num 1/5{
su value if class==`i'
gen indexed_`i'=value/r(mean) if class==`i'
}

label var indexed_1 Coffee
label var indexed_2 "Eau de vie"
label var indexed_3 Sugar
label var indexed_4 Wine

if `predicted' == 0 {
	keep if predicted==0
}

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

replace value=log10(value)

foreach i of num 1/5{

su value if class==`i'
local maxvalue r(max)

<<<<<<< HEAD
generate wara=`maxvalue' if year >=1733 & year <=1738 
generate warb=`maxvalue' if year >=1740 & year <=1744
=======
>>>>>>> origin/master
generate war1=`maxvalue' if year >=1744 & year <=1748
generate war2=`maxvalue' if year >=1756 & year <=1763
generate war3=`maxvalue' if year >=1778 & year <=1783
generate war4=`maxvalue' if year >=1793 & year <=1802
generate war5=`maxvalue' if year >=1803 & year <=1815

sort year

<<<<<<< HEAD
graph twoway (area wara year, color(gs14)) ///
			 (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9))(area war2 year, color(gs9)) ///
=======
graph twoway (area war1 year, color(gs9)) ///
			 (area war2 year, color(gs9)) ///
>>>>>>> origin/master
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4))  ///
			 (connected value year if class==`i', lcolor(blue) ///
			 msize(tiny) mcolor(blue)), legend(off) ///
			 title("`: label (class) `i''") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 ytitle("Tons of silver, log10") ///
			 legend(off)
			 
graph export "$hamburggit/tex/Paper/class`i'_trend_p`predicted'.png", as(png) replace	

drop war*		 
	

}

end

graph_per_goods 0








