
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



use "$hamburg/database_dta/Total silver trade FR GB.dta", clear


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

/*
graph twoway (area warla year, color(gs9)) ///
			 (area warsp year, color(gs9)) ///
			 (area wara year, color(gs14)) ///
///			 (area warb year, color(gs14)) ///
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

*/
local maxvalue 25000


replace warla=`maxvalue' if year >=1688 & year <=1697 
replace warsp=`maxvalue' if year >=1702 & year <=1713 
replace wara=`maxvalue' if year >=1733 & year <=1738 
replace warb=`maxvalue' if year >=1741 & year <=1744
replace war1=`maxvalue' if year >=1744 & year <=1748
replace war2=`maxvalue' if year >=1756 & year <=1763
replace war3=`maxvalue' if year >=1778 & year <=1783
replace war4=`maxvalue' if year >=1793 & year <=1802
replace war5=`maxvalue' if year >=1803 & year <=1807
replace blockade=`maxvalue' if year >=1807 & year <=1815


replace valueST_silverEN  =. if valueST_silverEN  ==0
replace valueST_silver_tena  =. if valueST_silver_tena==0
replace valueST_silver_cuenca  =. if valueST_silver_cuenca==0


graph twoway (area warla year, color(gs9)) ///
			 (area warsp year, color(gs9)) ///
			 /// (area wara year, color(gs14)) ///
			 (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (line valueFR_silver year, lpattern(solid) msize(large)) ///
			 (line valueST_silverEN year, lpattern(shortdash)  lcolor(black)) ///
			 (line valueST_silver_cuenca year, lpattern(shortdash)  lcolor(black)) ///
			 (line valueST_silver_tena year, lpattern(shortdash)  lcolor(black)), ///
			 legend(order(11 "French trade" 12 "English/GB/UK trade")) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 ytitle("Tons of silver") scheme(stsj) ///
			 yscale(range(500 20000) log) ylabel (500 1000 2500 5000 10000 25000)

graph export "$hamburggit/Paper - Impact of War/Paper/Total silver trade FR GB.png", as(png) replace

preserve
keep year war* blockade* value*
codebook
export delimited using "~/Library/CloudStorage/Dropbox/2022 Economic Warfare/2025 02 Graphs/DataFigure4.csv", delimiter(,) replace
restore

		 
gen log10_Imps_Exps_silver = log10(Imports_specialFR_silver + Exports_specialFR_silver)

graph twoway /// (area wara year, color(gs14)) ///
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
replace warb=`maxvalue' if year >=1741 & year <=1744
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

