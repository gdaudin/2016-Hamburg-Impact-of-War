
/*------------------------------------------------------------------------------
				FEDERICO TENA POST 1820 VALUES
------------------------------------------------------------------------------*/



global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"

if "`c(username)'" =="guillaumedaudin" {
	global hamburg ~/Documents/Recherche/2016 Hamburg
}

if "`c(username)'" =="TIRINDEE" {
	global hamburg"C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}

*******import database with US dollars

import delimited "$hamburg/Data/do_files/Hamburg/csv_files/RICardo - Country - France - 1787 - 1850 - Original currency.csv", clear 

drop if year<1820

rename total total_usfr

drop reporting partnertype import export

drop if source==""

save "$hamburg/database_dta/USfederico_tena.dta", replace

********importa database with pound sterling conversion

import delimited "$hamburg/Data/do_files/Hamburg/csv_files/RICardo - Country - France - 1787 - 1850.csv", clear 

drop if year<1820

drop reporting partnertype import export currency

rename total total_ST

merge m:1 year partner source using "$hamburg/database_dta/USfederico_tena.dta"

drop _merge

drop if partner!= "WorldFedericoTena" & partner!="Austria"

gen UStoST= total_usfr/total_ST if currency=="us dollar"
gen FRtoST= total_usfr/total_ST if currency=="french franc"
replace total_usfr=0 if partner=="Austria"
collapse (sum) total_usfr UStoST FRtoST, by(year)
gen UStoFR=FRtoST/UStoST
gen totalFR=total_usfr*UStoFR
rename totalFR value
generate log10_value = log10(value)
keep year value log10_value
drop if year==1820 | year==1821

save "$hamburg/database_dta/FRfederico_tena.dta", replace

/*------------------------------------------------------------------------------
				CONVERSION TO SILVER
------------------------------------------------------------------------------*/


import delimited "$thesis/Data/do_files/Hamburg/csv_files/Silver equivalent of the lt and franc (Hoffman).csv", clear

/*------------------------------------------------------------------------------
				GRAPHIQUES GUERRE
------------------------------------------------------------------------------*/

if "`c(username)'" =="guillaumedaudin" {
use "/Users/guillaumedaudin/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
global hamburg "/Users/guillaumedaudin/Documents/Recherche/2016 Hamburg/2016-Hamburg-Impact-of-War/tex/Paper"
}

use "/Users/Tirindelli/Desktop/hambourg/bdd courante.dta", clear

 
keep if sourcetype == "Tableau Général" | sourcetype=="Résumé"
drop if sitc18_rev3=="9a"

collapse (sum) value, by (year)
generate log10_value = log10(value)
insobs 1
replace year=1793 if year==.
sort year
append using "$hamburg/database_dta/FRfederico_tena.dta"
drop if year>1840


local maxvalue 9.4



generate wara=`maxvalue' if year >=1733 & year <=1738 
generate warb=`maxvalue' if year >=1740 & year <=1744
generate war1=`maxvalue' if year >=1744 & year <=1748
generate war2=`maxvalue' if year >=1756 & year <=1763
generate war3=`maxvalue' if year >=1778 & year <=1783
generate war4=`maxvalue' if year >=1793 & year <=1802
generate war5=`maxvalue' if year >=1803 & year <=1815

sort year

graph twoway (area wara year, color(gs14)) (area warb year, color(gs14)) ///
 (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
 (area war3 year, color(gs9)) (area war4 year, color(gs4)) (area war5 year, color(gs4))  ///
 (connected log10_value year, msize(small) color(black)) (lfit log10_value year, lpattern(dash)), ///
 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
 legend(off) ytitle("Value of French trade in livres, log10") xtitle("Year: Land, Mercantilist and R&N wars")
 
graph export "$tex/Total French trade and wars.png", as(png) replace


