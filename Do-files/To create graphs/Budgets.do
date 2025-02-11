
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

else if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE\Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Volumes/GoogleDrive/My Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Desktop/HamburgPaper"
}







**********Graphique

use "$hamburg/database_dta/FR&EN naval budgets.dta", clear 
merge 1:1 year using "$hamburg/database_dta/Total silver trade FR GB.dta"
drop _merge

local maxvalue = 3000


replace warb=`maxvalue' if warb!=.
replace war1=`maxvalue' if war1!=.
replace war2=`maxvalue' if war2!=.
replace war3=`maxvalue' if war3!=.
replace war4=`maxvalue' if war4!=.
replace war5=`maxvalue' if war5!=.
replace blockade=`maxvalue' if blockade!=.




graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (line NavyNet  year,lcolor(red)) (line NavyGross  year,lcolor(red) lpattern(dash)) ///
			 (line FrenchBudget year, lcolor(blue)) ///
			 if year >=1741 & year<=1830, scheme(s1color) ///
			 legend(order (13 14 15) label(13 "Net British Navy expenditures") label(14 "Gross British Navy expenditures") ///
			 label(15 "French Navy expenditures") rows(3)) ///
			 ytitle("Tons of silver, log(10)") xlabel(1740(20)1820) ///
	
graph export "$hamburggit/Paper - Impact of War/Paper/FR_GB_Budget.png", replace

local maxvalue = 3000

gen warminus1=`maxvalue' if year >=1702 & year<=1713
gen warminus2=`maxvalue' if year >=1688 & year<=1697

graph twoway (area warminus1 year, color(gs9)) (area warminus2 year, color(gs9)) /// 
             (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (line NavyNet  year, lcolor(black)) (line NavyGross  year, lcolor(black) lpattern(dash)) ///
			 (line FrenchBudget year, lcolor(gray)) ///
			 if year >=1680 & year<=1830, scheme(s1mono) ///
			 legend(order (10 11 12) label(10 "Net British Navy expenditures") label(11 "Gross British Navy expenditures") ///
			 label(12 "French Navy expenditures") rows(3)) ///
			 ytitle("Tons of silver") yscale(log) ylabel(25 50 100 250 500 1000 2500) /// 
             xlabel(1680(20)1820) 
	
graph export "$hamburggit/Paper - Impact of War/Paper/FR_GB_Budgetfrom1688.png", replace



keep  if year > 1680 & year <=1815
keep year war* NavyNet NavyGross FrenchBudget blockade

export delimited using "~/Library/CloudStorage/Dropbox/2022 Economic Warfare/2025 02 Graphs/DataFigure3.csv", delimiter(,) replace
