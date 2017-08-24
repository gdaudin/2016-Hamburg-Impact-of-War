
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


import delimited "$hamburg/Data/do_files/Hamburg/csv_files/Silver equivalent of the lt and franc (Hoffman).csv", clear

rename v1 year
rename v4 FR_silver
drop v5-v12 
drop v2 v3
drop if year=="Source:"
drop if year==""
drop if FR_silver==""
destring year, replace
destring FR_silver, replace
drop if year<1716 
drop if year>1840

save "$hamburg/database_dta/FR_silver.dta", replace

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

merge m:1 year using "$hamburg/database_dta/FR_silver.dta"

replace FR_silver=4.5 if year==1805.75
drop if _merge==2
drop _merge
replace value=FR_silver*value
replace log10_value = log10(value)

rename value valueFR
rename log10_value log10_valueFR


