
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\tirindee\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}



set more off


import delimited "$hamburggit/External Data/Neutral legislation.csv", clear
save "$hamburg/database_dta/Neutral legislation.dta", replace

use "$hamburg/database_dta/warships.dta", clear
bys war_status year : keep if _n==1
drop pays_grouping warships

reshape wide side_warships, i(year) j(war_status) string

rename side_warships* *
replace foe=Angleterre if foe ==. & year >=1740 
replace ally=France if ally==. & year>=1740

gen France_vs_GB = France/Angleterre
gen ally_vs_foe = (ally+France)/(foe+Angleterre)
gen allyandneutral_vs_foe=(ally+neutral+France)/(foe+Angleterre)
drop if year == 1792 | year <=1740
rename * warships_* 
rename warships_year year
save "$hamburg/database_dta/warships_wide.dta", replace

use "$hamburggit/Results/Yearly loss measure.dta", clear

replace loss_war = loss_war*exp(ln_value_peace1)	if year >=1745 & year <=1755
replace loss_war = loss_war*exp(ln_value_peace1_2) if year >=1756 & year <=1777
replace loss_war = loss_war*exp(ln_value_peace1_3) if year >=1778 & year <=1792
replace loss_war = loss_war*exp(ln_value_peace1_4) if year >=1793
replace loss_war=. if ln_value==.

gen ln_loss_war = ln(loss_war)
replace ln_loss_war = ln(0.00000000000001) if ln_loss_war==. 
replace ln_loss_war=. if ln_value==.


replace loss_war_nomemory = loss_war_nomemory*exp(ln_value_peace1) if year >=1745 & year <=1755
replace loss_war_nomemory = loss_war_nomemory*exp(ln_value_peace2) if year >=1756 & year <=1777
replace loss_war_nomemory = loss_war_nomemory*exp(ln_value_peace3) if year >=1778 & year <=1792
replace loss_war_nomemory = loss_war_nomemory*exp(ln_value_peace4) if year >=1793
replace loss_war_nomemory =. if ln_value==.

gen ln_loss_war_nomemory = ln(loss_war_nomemory)
replace ln_loss_war_nomemory = ln(0.00000000000001) if ln_loss_war_nomemory==. 
replace ln_loss_war_nomemory=. if ln_value==.

merge m:1 year using "$hamburg/database_dta/warships_wide.dta"


drop if _merge!=3 
drop _merge

merge m:1 year using "$hamburg/database_dta/Neutral legislation.dta"

drop if _merge!=3 
drop _merge

merge m:1 year using "$hamburg/database_dta/Colonies loss.dta"
rename weight_france colonies_loss

drop if _merge!=3 
drop _merge









