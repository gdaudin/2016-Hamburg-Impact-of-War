global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"

if "`c(username)'" =="guillaumedaudin" {
	global hamburg ~/Documents/Recherche/2016 Hamburg
}

if "`c(username)'" =="TIRINDEE" {
	global hamburg"C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}

*******import database with US dollars

import delimited "$hamburg/csv_files/RICardo - Country - France - 1787 - 1850 - Original currency.csv", clear 

drop if year<1820

rename total total_usfr

drop reporting partnertype import export

drop if source==""

save "$hamburg/databases_dta/USfederico_tena.dta", replace

********importa database with pound sterling conversion

import delimited "$hamburg/csv_files/RICardo - Country - France - 1787 - 1850.csv", clear 

drop if year<1820

drop reporting partnertype import export currency

rename total total_ST

merge m:1 year partner source using "$hamburg/databases_dta/USfederico_tena.dta"

drop _merge

drop if partner!= "WorldFedericoTena" & partner!="Austria"

gen UStoST= total_usfr/total_ST if currency=="us dollar"
gen FRtoST= total_usfr/total_ST if currency=="french franc"
replace total_usfr=0 if partner=="Austria"
collapse (sum) total_usfr UStoST FRtoST, by(year)
gen UStoFR=FRtoST/UStoST
gen totalFR=total_usfr*UStoFR

save "$hamburg/databases_dta/FRfederico_tena.dta", replace

