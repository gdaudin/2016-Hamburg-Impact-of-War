
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Volumes/GoogleDrive/My Drive/Hamburg"
	global hamburggit "/Volumes/GoogleDrive/My Drive/Hamburg/Paper"
}



set more off



use "$hamburg/database_dta/warships.dta", clear


bys war_status year : keep if _n==1

drop partner_grouping warships /*war*/

reshape wide side_warships, i(year) j(war_status) string

rename side_warships* *


replace ally=0 if ally ==.
replace foe=0 if foe ==.

gen France_vs_GB = France/Angleterre
gen ally_vs_foe = (ally+France)/(foe+Angleterre)
gen allyandneutral_vs_foe=(ally+neutral+France)/(foe+Angleterre)
*drop if year == 1792 | year <=1740


local maxvalue 3

generate wara		=`maxvalue' if year >=1733 & year <=1738 
generate warb		=`maxvalue' if year >=1740 & year <=1744
generate war1		=`maxvalue' if year >=1744 & year <=1748
generate war2		=`maxvalue' if year >=1756 & year <=1762
generate war3		=`maxvalue' if year >=1778 & year <=1782
generate war4		=`maxvalue' if year >=1793 & year <=1802
generate war5		=`maxvalue' if year >=1803 & year <=1807
generate blockade	=`maxvalue' if year >=1807 & year <=1815

sort year
export delimited "$hamburg/database_csv/naval_supremacy.csv", replace


graph twoway (area wara year, color(gs14%30)) ///
			 (area warb year, color(gs14%30)) ///
			 (area war1 year, color(gs9%30)) (area war2 year, color(gs9%30)) ///
			 (area war3 year, color(gs9%30)) (area war4 year, color(gs9%30)) ///
			 (area war5 year, color(gs9%30)) (area blockade year, color(gs4%30))  ///
			 (line France_vs_GB year, lpattern(dash)) ///
			 (line ally_vs_foe year, lpattern(dot) lcolor(gray)) ///
			 (line allyandneutral_vs_foe year) if (year!=1792 & year >=1740) , ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 yline(1, lwidth(medium) lcolor(grey)) ///
			 yscale(range(0 2.5)) ///
			 legend (position(bottom) order(9 "France/GB" 10 "France and its allies/GB and its allies" 11 "France and its allies and neutrals/GB and its allies") rows(3)) 
			 
graph export "$hamburggit/Paper - Impact of War/Paper/naval_supremacy_ratios_old.png", as(png) replace


*egen war=rowmax(war* blockade)
replace war = 0 if (year <=1720 & year >=1718) | (year <=1739 & year >=1733)
replace France_vs_GB = . if war==0
replace ally_vs_foe = . if war==0
replace allyandneutral_vs_foe = . if war==0

graph twoway (area wara year, color(gs14%30)) ///
			 (area warb year, color(gs14%30)) ///
			 (area war1 year, color(gs9%30)) (area war2 year, color(gs9%30)) ///
			 (area war3 year, color(gs9%30)) (area war4 year, color(gs9%30)) ///
			 (area war5 year, color(gs9%30)) (area blockade year, color(gs4%30)) ///
			 (line France_vs_GB year,  cmissing(n) lwidth(medium) lcolor(black)) ///
			 (line ally_vs_foe year, cmissing(n) lpattern(dash) lwidth(medium) lcolor(black)) ///
			 (line allyandneutral_vs_foe year , lpattern(shortdash)  lwidth(medium) lcolor(black) cmissing(n)) if (year!=1792 & year >=1740), ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 yline(1, lwidth(medium) lcolor(grey)) ///
			 yscale(range(0.33 2.5) log) ylabel(0.33 0.5 0.75 1.33 2 3) ///
			 ytitle(ship ratio) ///
			 legend (position(bottom) order(9 "France/GB" 10 "France and its allies/GB and its allies" 11 "France and its allies and neutrals/GB and its allies") rows(3)) ///
			 scheme(s1mono)
			 
graph export "$hamburggit/Paper - Impact of War/Paper/naval_supremacy_ratios.png", as(png) replace


graph twoway (line France_vs_GB year,   cmissing(n) lwidth(medium) lcolor(black)) ///
			 (line ally_vs_foe year, lpattern(dash) cmissing(n) lwidth(medium) lcolor(black)) ///
			 (line allyandneutral_vs_foe year , lpattern(shortdash) lwidth(medium) lcolor(black) cmissing(n)) if (year!=1792), ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 yline(1, lwidth(medium) lcolor(grey)) ///
			 yscale(range(0.33 2.5) log) ylabel(0.33 0.5 0.75 1.33 2 3) ///
			 ytitle(ship ratio) xlabel(1680(20)1820) ///
			 legend (position(bottom) order(1 "France/GB" 2 "France and its allies/GB and its allies" 3 "France and its allies and neutrals/GB and its allies") rows(3)) ///
			 scheme(s1mono)

			 
graph export "$hamburggit/Paper - Impact of War/Paper/naval_supremacy_ratios_from1688.png", as(png) replace

keep year France_vs_GB ally_vs_foe allyandneutral_vs_foe
export delimited using "~/Library/CloudStorage/Dropbox/2022 Economic Warfare/2025 02 Graphs/DataFigure2.csv", delimiter(,) replace
