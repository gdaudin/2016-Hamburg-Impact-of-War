***This create a .dta (FR_silver.dta") of total French trade in silver
/*------------------------------------------------------------------------------
				FEDERICO TENA POST 1820 VALUES
------------------------------------------------------------------------------*/



*global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"

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


*******import database with US dollars

import delimited "$hamburggit/External Data/RICardo - Country - France - 1787 - 1850 - Original currency.csv", clear 

drop if year<1820

rename total total_usfr

drop reporting partnertype import export

drop if source==""

save "$hamburg/database_dta/USfederico_tena.dta", replace

********importa database with pound sterling conversion

import delimited "$hamburggit/External Data/RICardo - Country - France - 1787 - 1850.csv", clear 

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


import delimited "$hamburggit/External Data/Silver equivalent of the lt and franc (Hoffman).csv", clear

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

import delimited "$hamburggit/External Data/Silver equivalent of the pound sterling (see colum CI _ CH).csv", clear
drop v1-v85
drop v90-v172
drop v88
drop v86
rename v89 year
rename v87 ST_silver
drop if ST_silver=="market price"
drop if year=="Year"
drop if year==""
drop if  ST_silver==""
destring year, replace
destring ST_silver, replace
drop if year<1716
save "$hamburg/database_dta/ST_silver.dta", replace


/*------------------------------------------------------------------------------
				BRITISH DATA
------------------------------------------------------------------------------*/

import delimited "$hamburggit/External Data/English and Brisith trade 1697-1800.csv", clear
sort year
keep if year>1715
collapse (sum) value, by(year)

preserve 
import delimited "$hamburggit/External Data/RICardo - Country - UnitedKingdom - 1796 - 1938.csv", clear
keep if partner=="WorldFedericoTena"
drop if year>1840
drop if year==1800
collapse (sum) total, by(year)
rename total value
save "$hamburg/database_dta/UKfederico_tena.dta", replace
restore

append using "$hamburg/database_dta/UKfederico_tena.dta"

merge m:1 year using "$hamburg/database_dta/ST_silver.dta"

drop if _merge==2
drop _merge

gen vaulueST_silver=value*ST_silver
rename value valueST
gen log10_valueST_silver=log10(vaulueST_silver)

save "$hamburg/database_dta/UKfederico_tena.dta", replace


/*------------------------------------------------------------------------------
				VOLUME OF TRADE BETWEEN 1716 AND 1820
------------------------------------------------------------------------------*/

if "`c(username)'" =="guillaumedaudin" {
use "/Users/guillaumedaudin/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
}

if "`c(username)'" =="Tirindelli" use "/Users/Tirindelli/Desktop/hambourg/bdd courante.dta", clear

 
keep if sourcetype == "Tableau Général" | sourcetype=="Résumé"
drop if sitc18_rev3=="9a"

collapse (sum) value, by (year)
generate log10_value = log10(value)
insobs 1
replace year=1793 if year==.
append using "$hamburg/database_dta/FRfederico_tena.dta"
drop if year>1840
replace year=1806 if year==1805.75

merge m:1 year using "$hamburg/database_dta/FR_silver.dta"

drop if _merge==2
drop _merge
gen valueFR_silver=FR_silver*value
gen log10_valueFR_silver = log10(valueFR_silver)

rename value valueFR
rename log10_value log10_valueFR

merge m:1 year using "$hamburg/database_dta/UKfederico_tena.dta"

drop _merge

sort year

twoway (connected log10_valueFR_silver year) ///
	(lfit log10_valueST_silver year if year < 1772) ///
	(connected log10_valueST_silver year if year >= 1772 & year <1801) ///
	(connected log10_valueST_silver year if year >1800)

save "$hamburg/database_dta/Total silver trade FR GB.dta", replace






