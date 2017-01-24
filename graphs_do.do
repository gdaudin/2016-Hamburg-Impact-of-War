****Various graphs

*global ete "/Users/Tirindelli/Google Drive/ETE"
global ete "C:\Users\TIRINDEE\Google Drive\ETE"

set more off

****hamburg1
use "$ete/Thesis2/database_dta/hamburg1", clear

drop if year<1734

label var value Value
twoway (connected value year), title("Hamburg series") yscale(off)
graph export "$ete/Thesis/Data/do_files/Hamburg/tex/growth_rate.png", replace as(png) 

****hamburg2
use "$ete/Thesis2/database_dta/hamburg2", clear
drop if value==.
drop pays_regroupes
drop if year<1734
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
	year<1780 & year>1749, title("Product trend between 1750 and 1780") ///
	caption("Values indexed at product average")
graph export "$ete/Thesis/Data/do_files/Hamburg/tex/hamburg_product_1780.png", replace as(png) 
	
twoway (connected indexed_1 year) (connected indexed_2 year) ///
	(connected indexed_3 year) (connected indexed_4 year) if year>1779, ///
	title("Product trend between 1780 and 1820") ///
	caption("Values indexed at product average")
graph export "$ete/Thesis/Data/do_files/Hamburg/tex/hamburg_product_1820.png", replace as(png) 













