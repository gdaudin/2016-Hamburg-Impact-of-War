***This create a .dta (FR_silver.dta") of total French trade in silver
/*------------------------------------------------------------------------------
				FEDERICO TENA POST 1820 VALUES
------------------------------------------------------------------------------*/



*global hamburg "/Users/Tirindelli/Google Drive/Hamburg"

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires Git/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}

if "`c(username)'" =="rober" {
	global hamburg "G:\Il mio Drive\Hamburg"
	global hamburggit "G:\Il mio Drive\Hamburg\Paper"
}

if "`c(username)'" =="Tirindelli" {
	global hamburg "/Volumes/GoogleDrive/My Drive/Hamburg"
	global hamburggit "/Volumes/GoogleDrive/My Drive/Hamburg/Paper"
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
keep year value
drop if year==1820 | year==1821

save "$hamburg/database_dta/FRfederico_tena.dta", replace

/*------------------------------------------------------------------------------
				CONVERSION TO SILVER
------------------------------------------------------------------------------*/


import delimited "$hamburggit/External Data/Silver equivalent of the lt and franc (Hoffman).csv", clear

/*
rename v1 year
rename v4 FR_silver
drop v5-v12 
drop v2 v3
drop if year=="Source:"
drop if year==""
drop if FR_silver==""
*/
rename value_of_livre FR_silver
replace FR_silver=subinstr(FR_silver,",",".",.)
destring year, replace
destring FR_silver, replace
drop if year<1668 
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
save "$hamburg/database_dta/ST_silver.dta", replace


/*------------------------------------------------------------------------------
				BRITISH DATA
------------------------------------------------------------------------------*/

import delimited "$hamburggit/External Data/English and British trade 1697-1800.csv", clear
sort year
drop if source=="From McCusker, 1971, table II" /*This has only exports*/
collapse (sum) value, by(year country source)

preserve 
import delimited "$hamburggit/External Data/RICardo - Country - UnitedKingdom - 1796 - 1938.csv", clear
keep if partner=="WorldFedericoTena"
drop if year>1840
drop if year==1800
collapse (sum) total, by(year)
gen source="Federico_Tena"
save "$hamburg/database_dta/UKfederico_tena.dta", replace
restore

append using "$hamburg/database_dta/UKfederico_tena.dta"

***Comparaison des sources



merge m:1 year using "$hamburg/database_dta/ST_silver.dta"

drop if _merge==2
drop _merge

replace value=total if source=="Federico_Tena"
graph twoway (line value year if source=="Cuenca") (line value year if strmatch(source,"*Cole*")==1 & country=="England-official") (line value year if strmatch(source,"*Cole*")==1 & country=="Great-Britain-official") (connected value year if source=="Brezis via Crouzet") (line value year if source=="Federico_Tena")
gen value_ST_silver = value * ST_silver/(1000*1000)
gen log10_valueST_silver = log10(value_ST_silver)

graph twoway (line log10_valueST_silver year if source=="Cuenca") ///
	(line log10_valueST_silver year if strmatch(source,"*Cole*")==1 & country=="England-official") ///
	(line log10_valueST_silver year if strmatch(source,"*Cole*")==1 & country=="Great-Britain-official") ///
	(connected log10_valueST_silver year if source=="Brezis via Crouzet") ///
	(line log10_valueST_silver year if source=="Federico_Tena"), ///
	legend (order(2 "England (official values)" 3 "Great-Britain (official values)" 1 "Cuenca" 5 "Federico_Tena" 4 "Brezis via Crouzet" )) ///
	scheme(stsj)



gen valueST_silver_tena=value_ST_silver  if source=="Federico_Tena" & year >=1823
gen valueST_silver_cuenca=value_ST_silver  if source=="Cuenca" & year <=1822 & year >=1764
gen valueST_silverEN= value_ST_silver if country=="England-official" & year <=1763

gen log10_valueST_silver_tena=log10(valueST_silver_tena)
gen log10_valueST_silver_cuenca=log10(valueST_silver_cuenca)
gen log10_valueST_silverEN=log10(valueST_silverEN)


collapse (sum) log10_valueST_silver_cuenca log10_valueST_silverEN ///
				log10_valueST_silver_tena ///
				valueST_silver_cuenca valueST_silverEN ///
				valueST_silver_tena, by(year)
				
replace log10_valueST_silver_cuenca=. 	if log10_valueST_silver_cuenca==0
replace log10_valueST_silverEN=. 		if log10_valueST_silverEN==0
replace log10_valueST_silver_tena=. 	if log10_valueST_silver_tena==0

save "$hamburg/database_dta/UK_trade_Best_Guess.dta", replace


/*------------------------------------------------------------------------------
				VALUE OF TRADE BETWEEN 1716 AND 1821
------------------------------------------------------------------------------*/

******For bilateral trade
if "`c(username)'" =="guillaumedaudin"{
	/*
	tempfile bdd_courante
	unzipfile "~/Répertoires Git/toflit18_data_GIT/base/bdd courante.csv.zip", replace
	import delimited using "~/Répertoires Git/toflit18_data_GIT/base/bdd courante.csv", clear
	*/
	use "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
}

if "`c(username)'" !="guillaumedaudin"{
use "$hamburg/Données Stata/bdd courante.dta", clear
}



keep if best_guess_national_partner==1 
 

drop if product_sitc=="9a"

replace year=1806 if year==1805.75
merge m:1 year using "$hamburg/database_dta/FR_silver.dta"

drop if _merge==2
drop _merge
gen valueFR_silver=FR_silver*value/(1000*1000)
drop if year>1840




replace partner_grouping="Outre-mers" if partner_grouping=="Afrique" | partner_grouping=="Asie" | partner_grouping=="Amériques"

collapse (sum) valueFR_silver value, by (year export_import ///
				partner_grouping FR_silver)

fillin partner_grouping export_import year
drop if partner_grouping =="États-Unis d'Amérique" & year <=1777
replace value = 0 if partner_grouping !="États-Unis d'Amérique" & value==.
replace value=0 if partner_grouping =="États-Unis d'Ambérique" & value==. & year >=1777
replace valueFR_silver=0 if value==0


save "$hamburg/database_dta/Best guess FR bilateral trade.dta", replace

******For total trade
if "`c(username)'" =="guillaumedaudin"{
	/*
	tempfile bdd_courante
	unzipfile "~/Répertoires Git/toflit18_data_GIT/base/bdd courante.csv.zip", replace
	import delimited using "~/Répertoires Git/toflit18_data_GIT/base/bdd courante.csv", clear
	*/
	use "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
}

if "`c(username)'" !="guillaumedaudin"{
use "$hamburg/Données Stata/bdd courante.dta", clear
}



keep if best_guess_national==1 

replace year=1806 if year==1805.75
merge m:1 year using "$hamburg/database_dta/FR_silver.dta"

drop if _merge==2
drop _merge
gen valueFR_silver=FR_silver*value/(1000*1000)
drop if year>1840


collapse (sum) value , by (year export_import)



insobs 1

drop if year==.
drop if year==1793
reshape wide value,i(year) j(export_import) string
rename value* *
gen value=Exports+Imports



merge 1:1 year using "$hamburg/database_dta/National Reexports.dta"
gen Exports_special=Exports-reexports
gen Imports_special=Imports-reexports
drop _merge






merge 1:1 year using "$hamburg/database_dta/FRfederico_tena.dta", update

drop if year >1840
drop if value==.
drop _merge


merge 1:1 year using "$hamburg/database_dta/FR_silver.dta"



drop if _merge==2
drop _merge

foreach var of varlist value Imports Exports reexports Imports_special Exports_special {
	gen `var'FR_silver=FR_silver*`var'/(1000*1000)
	gen log10_`var'FR_silver=log10(`var'FR_silver)
}


drop if year>1840


rename value valueFR


merge m:1 year using "$hamburg/database_dta/UK_trade_Best_Guess.dta"


drop _merge

sort year


local maxvalue 4.5


generate warla=`maxvalue' if year >=1688 & year <=1697 
generate warsp=`maxvalue' if year >=1702 & year <=1713 
generate wara=`maxvalue' if year >=1733 & year <=1738 
generate warb=`maxvalue' if year >=1740 & year <=1744
generate war1=`maxvalue' if year >=1744 & year <=1748
generate war2=`maxvalue' if year >=1756 & year <=1763
generate war3=`maxvalue' if year >=1778 & year <=1783
generate war4=`maxvalue' if year >=1793 & year <=1802
generate war5=`maxvalue' if year >=1803 & year <=1807
generate blockade=`maxvalue' if year >=1807 & year <=1815

sort year
export delimited "$hamburg/database_csv/Total_silver_trade_FR_GB.csv", replace
save "$hamburg/database_dta/Total silver trade FR GB.dta", replace

/*Color graph
graph twoway (area warla year, color(gs9)) ///
			 (area warsp year, color(gs9)) ///
			 (area wara year, color(gs14)) ///
			 (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (connected log10_valueFR_silver year, lcolor(blue) ///
			 msize(tiny) mcolor(blue) ) ///
			 (line log10_valueST_silverEN year, lcolor(black)) ///
			 (line log10_valueST_silverGB year, lcolor(black)) ///
			 (line log10_valueST_silver_tena year, lcolor(black)), ///
			 legend(order(11 "French trade" 12 "English/GB/UK trade")) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 ytitle("Tons of silver, log10")

*/
graph twoway (area warla year, color(gs9)) ///
			 (area warsp year, color(gs9)) ///
			 (area wara year, color(gs14)) ///
			 (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (line log10_valueFR_silver year, lpattern(solid) msize(large)) ///
			 (line log10_valueST_silverEN year, lpattern(shortdash)  lcolor(black)) ///
			 (line log10_valueST_silver_cuenca year, lpattern(shortdash)  lcolor(black)) ///
			 (line log10_valueST_silver_tena year, lpattern(shortdash)  lcolor(black)), ///
			 legend(order(11 "French trade" 12 "English/GB/UK trade")) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 ytitle("Tons of silver, log10") scheme(stsj)

*graph save "$hamburggit/Paper/Total silver trade FR GB.png", replace
graph export "$hamburggit/Paper - Impact of War/Paper/Total silver trade FR GB.png", as(png) replace

preserve
keep year war* blockade* log10_value*
codebook
export delimited using "~/Library/CloudStorage/Dropbox/2022 Economic Warfare/2025 02 Graphs/DataFigure4.csv", delimiter(,) replace
restore

		 
gen log10_Imps_Exps_silver = log10(Imports_specialFR_silver + Exports_specialFR_silver)

graph twoway (area wara year, color(gs14)) ///
			 (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (connected log10_valueFR_silver year, lcolor(blue) msize(tiny) mcolor(blue) ) ///
			 (connected log10_Imps_Exps_silver year, lcolor(red) msize(tiny) mcolor(red)) ///
			 (connected log10_Imports_specialFR_silver year, lcolor(green) msize(tiny) mcolor(green)) ///
			 (area warsp year, color(gs9)), ///
			 legend(order(11 "Special imports" 10 "Special trade (I+X)" ///
			 9 "Total trade")) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 ytitle("Tons of silver, log10")


graph export "$hamburggit/Paper - Impact of War/Paper/Breakdown of FR trade (log10-silver).png", as(png) replace

local maxvalue 10000


replace warla=`maxvalue' if year >=1688 & year <=1697 
replace warsp=`maxvalue' if year >=1702 & year <=1713 
replace wara=`maxvalue' if year >=1733 & year <=1738 
replace warb=`maxvalue' if year >=1740 & year <=1744
replace war1=`maxvalue' if year >=1744 & year <=1748
replace war2=`maxvalue' if year >=1756 & year <=1763
replace war3=`maxvalue' if year >=1778 & year <=1783
replace war4=`maxvalue' if year >=1793 & year <=1802
replace war5=`maxvalue' if year >=1803 & year <=1807
replace blockade=`maxvalue' if year >=1807 & year <=1815

gen Imps_Exps_silver = Imports_specialFR_silver + Exports_specialFR_silver
graph twoway (area wara year, color(gs14)) ///
			 (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (connected valueFR_silver year, lcolor(blue) msize(tiny) mcolor(blue) ) ///
			 (connected Imps_Exps_silver year, lcolor(red) msize(tiny) mcolor(red)) ///
			 (connected Imports_specialFR_silver year, lcolor(green) msize(tiny) mcolor(green)) ///
			 (area warsp year, color(gs9)), ///
			 legend(order(11 "Special imports" 10 "Special trade (I+X)" ///
			 9 "Total trade")) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 ytitle("Tons of silver")
			 
graph export "$hamburggit/Paper - Impact of War/Paper/Breakdown of FR trade (silver).png", as(png) replace






