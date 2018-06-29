
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

import delimited using "$hamburggit/External Data/Modelski Thompson -- Sea Power -- Number of warships.csv", clear case(preserve) numericcols(_all)

rename * warships*

rename warshipsv1 year

foreach country in Spain Sweden Venice OttomanEmpire Denmark Portugal {


	ipolate warships`country' year, gen(warships`country'_ipol)
	drop warships`country'
	rename warships`country'_ipol warships`country'
}
keep if year >=1700 & year <1830



reshape long warships, i(year) j(grouping_classification) string



replace grouping_classification="Angleterre" if grouping_classification=="GreatBritain"
replace grouping_classification="Hollande" if grouping_classification=="Netherlands"
replace grouping_classification="Espagne" if grouping_classification=="Spain"
replace grouping_classification="Italie" if grouping_classification=="Venice"
replace grouping_classification="Levant et Barbarie" if grouping_classification=="OttomanEmpire"
replace grouping_classification="Russiapourmemoire" if grouping_classification=="Russia"
replace grouping_classification="Swedenpourmemoire" if grouping_classification=="Sweden"
replace grouping_classification="Denmarkpourmemoire" if grouping_classification=="Denmark"

*replace country="Portugal

collapse (sum) warships, by(year grouping_classification)

merge 1:1 grouping_classification year using "$hamburg/database_dta/WarAndPeace.dta", keep (1 3)
drop if year <=1732 | year >=1822


drop _merge

replace war_status = "France" if grouping_classification=="France"
replace war_status = "Angleterre" if grouping_classification=="Angleterre"
egen side_warships=total(warships), by(war_status year)

save "$hamburg/database_dta/warships.dta", replace


bys war_status year : keep if _n==1
drop grouping_classification warships

reshape wide side_warships, i(year) j(war_status) string

rename side_warships* *
replace foe=Angleterre if foe ==. & year >=1740 
replace ally=France if ally==. & year>=1740

gen France_vs_GB = France/Angleterre
gen ally_vs_foe = (ally+France)/(foe+Angleterre)
gen allyandneutral_vs_foe=(ally+neutral+France)/(foe+Angleterre)
drop if year == 1792 | year <=1740


local maxvalue 2.5

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
			 (line France_vs_GB year, lpattern(dash)) ///
			 (line ally_vs_foe year, lpattern(dot)) ///
			 (line allyandneutral_vs_foe year), ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 legend (order(8 "France/GB" 9 "France and its allies/GB and its allies" 10 "France and its allies and neutrals/GB and its allies") rows(3))
			 
graph export "$hamburggit/Impact of War/Paper/naval_supremacy_ratios.png", as(png) replace

