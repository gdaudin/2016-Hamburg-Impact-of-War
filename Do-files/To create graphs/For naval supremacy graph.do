
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}



set more off



use "$hamburg/database_dta/warships.dta", clear



bys war_status year : keep if _n==1
drop country_grouping warships

reshape wide side_warships, i(year) j(war_status) string

rename side_warships* *
replace foe=Angleterre if foe ==. & year >=1740 
replace ally=France if ally==. & year>=1740

gen France_vs_GB = France/Angleterre
gen ally_vs_foe = (ally+France)/(foe+Angleterre)
gen allyandneutral_vs_foe=(ally+neutral+France)/(foe+Angleterre)
drop if year == 1792 | year <=1740


local maxvalue 2.5

generate wara		=`maxvalue' if year >=1733 & year <=1738 
generate warb		=`maxvalue' if year >=1740 & year <=1744
generate war1		=`maxvalue' if year >=1744 & year <=1748
generate war2		=`maxvalue' if year >=1756 & year <=1763
generate war3		=`maxvalue' if year >=1778 & year <=1783
generate war4		=`maxvalue' if year >=1793 & year <=1802
generate war5		=`maxvalue' if year >=1803 & year <=1807
generate blockade	=`maxvalue' if year >=1807 & year <=1815



sort year

graph twoway (area wara year, color(gs14%30)) ///
			 (area warb year, color(gs14%30)) ///
			 (area war1 year, color(gs9%30)) (area war2 year, color(gs9%30)) ///
			 (area war3 year, color(gs9%30)) (area war4 year, color(gs9%30)) ///
			 (area war5 year, color(gs9%30)) (area blockade year, color(gs4%30))  ///
			 (line France_vs_GB year, lpattern(dash)) ///
			 (line ally_vs_foe year, lpattern(dot)) ///
			 (line allyandneutral_vs_foe year), ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 yline(1, lwidth(medium) lcolor(grey)) ///
			 yscale(range(0 2.5)) ///
			 legend (order(9 "France/GB" 10 "France and its allies/GB and its allies" 11 "France and its allies and neutrals/GB and its allies") rows(3))
			 
graph export "$hamburggit/Paper - Impact of War/Paper/naval_supremacy_ratios_old.png", as(png) replace

egen war=rowmax(war* blockade)
replace France_vs_GB = . if war==.
replace ally_vs_foe = . if war==.
replace allyandneutral_vs_foe = . if war==.

graph twoway (area wara year, color(gs14%30)) ///
			 (area warb year, color(gs14%30)) ///
			 (area war1 year, color(gs9%30)) (area war2 year, color(gs9%30)) ///
			 (area war3 year, color(gs9%30)) (area war4 year, color(gs9%30)) ///
			 (area war5 year, color(gs9%30)) (area blockade year, color(gs4%30)) ///
			 (line France_vs_GB year,  lpattern(dot) cmissing(n)) ///
			 (line ally_vs_foe year, cmissing(n) lwidth(thick)) ///
			 (line allyandneutral_vs_foe year, lpattern(dash) cmissing(n)), ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 yline(1, lwidth(medium) lcolor(grey)) ///
			 yscale(range(0 2.5)) ylabel(0 (0.5) 2.5) ///
			 xtitle(ship ratio) ///
			 legend (order(9 "France/GB" 10 "France and its allies/GB and its allies" 11 "France and its allies and neutrals/GB and its allies") rows(3))
			 
graph export "$hamburggit/Paper - Impact of War/Paper/naval_supremacy_ratios.png", as(png) replace
