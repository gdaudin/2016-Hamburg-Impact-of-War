****Various graphs

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"

set more off

****hamburg1
use "$thesis/database_dta/hamburg1", clear

drop if year<1734

label var value Value
twoway (connected value year), title("Hamburg series") ///
yscale(off) plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$thesis/Data/do_files/Hamburg/tex/growth_rate.png", replace as(png) 

****hamburg2
use "$thesis/database_dta/hamburg2", clear
drop if value==.
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
	caption("Values indexed at product average") plotregion(fcolor(white)) ///
	graphregion(fcolor(white)) subtitle("Hamburg")
graph export "$thesis/Data/do_files/Hamburg/tex/hamburg_product_1780.png", replace as(png) 
	
twoway (connected indexed_1 year) (connected indexed_2 year) ///
	(connected indexed_3 year) (connected indexed_4 year) if year>1779, ///
	title("Product trend between 1780 and 1820") subtitle("Hamburg") plotregion(fcolor(white)) ///
	graphregion(fcolor(white)) caption("Values indexed at product average")
graph export "$thesis/Data/do_files/Hamburg/tex/hamburg_product_1820.png", replace as(png) 


****allcountry2
use "$thesis/database_dta/bdd_courante2", clear

drop if year<1733
drop if year==1766 & classification_hamburg_large=="Sugar"
drop if pays_regroupes=="France"
drop if pays_regroupes=="Indes"
drop if pays_regroupes=="Espagne-Portugal"
drop if pays_regroupes=="Nord-Hollande"

collapse (sum) value, by(year classification_hamburg_large)

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

twoway (connected indexed_1 year) (connected indexed_2 year) ///
	(connected indexed_3 year) (connected indexed_4 year) if ///
	year<1780 & year>1749, title("Product trend between 1750 and 1780") ///
	caption("Values indexed at product average") plotregion(fcolor(white)) ///
	graphregion(fcolor(white)) subtitle("All countries")
graph export "$thesis/Data/do_files/Hamburg/tex/allcountry_product_1780.png", replace as(png) 
	
twoway (connected indexed_1 year) (connected indexed_2 year) ///
	(connected indexed_3 year) (connected indexed_4 year) if year>1779, ///
	title("Product trend between 1780 and 1820") plotregion(fcolor(white)) ///
	graphregion(fcolor(white)) caption("Values indexed at product average") ///
	subtitle("All countries")
graph export "$thesis/Data/do_files/Hamburg/tex/allcountry_product_1820.png", replace as(png) 











