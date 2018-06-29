***This create a .dta (FR_silver.dta") of total French trade in silver
/*------------------------------------------------------------------------------
				FEDERICO TENA POST 1820 VALUES
------------------------------------------------------------------------------*/



*global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "$hamburg/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
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
keep year value
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
save "$hamburg/database_dta/ST_silver.dta", replace


/*------------------------------------------------------------------------------
				BRITISH DATA
------------------------------------------------------------------------------*/

import delimited "$hamburggit/External Data/English and Brisith trade 1697-1800.csv", clear
sort year
collapse (sum) value, by(year country)

preserve 
import delimited "$hamburggit/External Data/RICardo - Country - UnitedKingdom - 1796 - 1938.csv", clear
keep if partner=="WorldFedericoTena"
drop if year>1840
drop if year==1800
collapse (sum) total, by(year)
save "$hamburg/database_dta/UKfederico_tena.dta", replace
restore

append using "$hamburg/database_dta/UKfederico_tena.dta"

merge m:1 year using "$hamburg/database_dta/ST_silver.dta"

drop if _merge==2
drop _merge

gen vaulueST_silver_tena=total*ST_silver/(1000*1000) 
gen vaulueST_silverGB= value*ST_silver/(1000*1000) if country=="Great-Britain"
gen vaulueST_silverEN= value*ST_silver/(1000*1000) if country=="England"

gen log10_valueST_silverGB=log10(vaulueST_silverGB)
gen log10_valueST_silverEN=log10(vaulueST_silverEN)
gen log10_valueST_silver_tena=log10(vaulueST_silver_tena)


collapse (sum) log10_valueST_silverGB log10_valueST_silverEN ///
				log10_valueST_silver_tena ///
				vaulueST_silverGB vaulueST_silverEN ///
				vaulueST_silver_tena, by(year)
				
replace log10_valueST_silverGB=. if log10_valueST_silverGB==0
replace log10_valueST_silverEN=. if log10_valueST_silverEN==0
replace log10_valueST_silver_tena=. if log10_valueST_silver_tena==0


save "$hamburg/database_dta/UKfederico_tena.dta", replace


/*------------------------------------------------------------------------------
				VOLUME OF TRADE BETWEEN 1716 AND 1820
------------------------------------------------------------------------------*/

if "`c(username)'" =="guillaumedaudin" {
use "$hamburg/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
}

if "`c(username)'" =="Tirindelli"{
use "$hamburg/Données Stata/bdd courante.dta", clear
}
 
keep if sourcetype == "Tableau Général" | sourcetype=="Résumé"
drop if sitc_classification=="9a"


replace year=1806 if year==1805.75
merge m:1 year using "$hamburg/database_dta/FR_silver.dta"

drop if _merge==2
drop _merge
gen valueFR_silver=FR_silver*value/(1000*1000)
drop if year>1840




collapse (sum) valueFR_silver value, by (year exportsimports ///
				simplification_classification classification_country_wars ///
				grouping_classification FR_silver)

fillin grouping_classification exportsimports year
drop if grouping_classification =="États-Unis d'Amérique" & year <=1777
replace value = 0 if grouping_classification !="États-Unis d'Amérique" & value==.
replace value=0 if grouping_classification =="États-Unis d'Ambérique" & value==. & year >=1777
replace valueFR_silver=0 if value==0


save "$hamburg/database_dta/Best guess FR bilateral trade.dta", replace


collapse (sum) value , by (year)

insobs 1
replace year=1793 if year==.

append using "$hamburg/database_dta/FRfederico_tena.dta"

merge m:1 year using "$hamburg/database_dta/FR_silver.dta"

drop if _merge==2
drop _merge
gen valueFR_silver=FR_silver*value/(1000*1000)

drop if year>1840

gen log10_valueFR_silver = log10(valueFR_silver)


rename value valueFR


merge m:1 year using "$hamburg/database_dta/UKfederico_tena.dta"


drop _merge

sort year

local maxvalue 4.5


generate wara=`maxvalue' if year >=1733 & year <=1738 
generate warb=`maxvalue' if year >=1740 & year <=1744
generate war1=`maxvalue' if year >=1744 & year <=1748
generate war2=`maxvalue' if year >=1756 & year <=1763
generate war3=`maxvalue' if year >=1778 & year <=1783
generate war4=`maxvalue' if year >=1793 & year <=1802
generate war5=`maxvalue' if year >=1803 & year <=1815

sort year

graph twoway (area wara year, color(gs14)) ///
			 (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4))  ///
			 (connected log10_valueFR_silver year, lcolor(blue) ///
			 msize(tiny) mcolor(blue) ) ///
			 (line log10_valueST_silverEN year, lcolor(black)) ///
			 (line log10_valueST_silverGB year, lcolor(black)) ///
			 (line log10_valueST_silver_tena year, lcolor(black)), ///
			 legend(order(8 "French trade" 9 "English/GB/UK trade")) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 ytitle("Tons of silver, log10")

			 
*graph save "$hamburggit/Paper/Total silver trade FR GB.png", replace
graph export "$hamburggit/Impact of War/Paper/Total silver trade FR GB.png", as(png) replace			 
	
save "$hamburg/database_dta/Total silver trade FR GB.dta", replace









