if "`c(username)'" =="guillaumedaudin" {
	global hamburg "/Users/guillaumedaudin/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\tirindee\Google Drive\ETE/Thesis/Data/do_files/Hamburg/"
}

if "`c(username)'" =="rober" {
	global hamburg "G:\Il mio Drive\Hamburg"
	global hamburggit "G:\Il mio Drive\Hamburg\Paper"
}

if "`c(username)'" =="Tirindelli" {
	global hamburg "/Volumes/GoogleDrive/My Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Desktop/HamburgPaper"
}

/*
The files "Indice_global_filtre_ville_imports.csv" and "Indice_global_filtre_ville_exports.csv" are coming from Edouard Pignede’s work (https://github.com/gdaudin/Divers-autour-de-Toflit18.git/Edouard/Indice_global_value)
*/


insheet using "$hamburggit/External Data/Indice_global_filtre_ville_imports.csv", delimiter(";") case clear
rename Index Import_prices
keep year Import_prices

save "$hamburg/database_dta/Prices.dta", replace

insheet using "$hamburggit/External Data/Indice_global_filtre_ville_exports.csv", delimiter(";") case clear
rename Index Export_prices
keep year Export_prices

merge 1:1 year using "$hamburg/database_dta/Prices.dta"
drop _merge


gen war = 1
replace war = 0 if year <= 1744 | (year >= 1749 & year <=1755) | (year >= 1763 & year <=1777) | (year >= 1784 & year <=1792) | year >=1816

foreach i in Export Import {

	replace `i'_prices="" if `i'_prices=="NA"
	replace `i'_prices = subinstr(`i'_prices,",",".",.)
	destring `i'_prices, replace
	gen log_`i'_prices = ln(`i'_prices)
	reg log_`i'_prices year war
	reg log_`i'_prices year war if year >=1741
}


replace Export_prices = Export_prices/452.6394216279
replace Import_prices = Import_prices/261.0481743658

gen Terms_of_trade = Export_prices/Import_prices

gen log_Terms_of_trade=ln(Terms_of_trade)
reg log_Terms_of_trade year war
reg log_Terms_of_trade year war if year >=1741

gen war1=2 if year >=1744 & year<=1748
gen war2=2 if year >=1756 & year<=1762
gen war3=2 if year >=1778 & year<=1782

graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) ///
			 (connected Export_prices year) (connected Import_prices year) ///
			 (line Terms_of_trade year), ////
			 scheme(s1color) /// 
			 legend(order(4 5 6) label(4 "Export prices") label( 5 "Import prices") label (6 "Terms of trade"))


graph export "$hamburggit/Paper - Impact of War/Paper/Prices.png", as(png) replace



