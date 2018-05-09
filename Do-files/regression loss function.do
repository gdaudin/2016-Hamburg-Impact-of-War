
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

capture program drop reg_loss_function
program reg_loss_function
args outremer break

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

replace loss_war = ln(1-loss_war)
replace loss_war_nomemory = ln(1-loss_war_nomemory)


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

if `outremer'==0{
drop if pays_grouping=="Outre-mers"
drop if outremer==1
}

if `outremer'==1 drop if outremer==0

if "`break'"=="blockade" drop if breakofinterest=="R&N"
if "`break'"=="R&N" drop if breakofinterest=="Blockade" 


foreach i in Imports Exports XI{
	foreach explained_var in loss_war loss_war_nomemory{
		reg `explained_var' i.war#c.colonies_loss ///
		i.war#i.neutral_policy i.neutral_policy ///
		i.war#c.warships_allyandneutral_vs_foe ///
		if pays_grouping =="All" & exportsimports == "`i'"
	}
}
replace war=1 if year>=1745 & year<=1748
replace war=2 if year>=1756 & year<=1763
replace war=3 if year>=1778 & year<=1783
replace war=4 if year>=1793 & year<=1802
replace war=5 if year>=1803 & year<=1815


foreach i in Imports Exports XI{
	foreach explained_var in loss_war loss_war_nomemory{
		reg `explained_var' i.war#c.colonies_loss ///
		i.war#i.neutral_policy ///
		i.war#c.warships_allyandneutral_vs_foe ///
		if pays_grouping =="All" & exportsimports == "`i'" 
	}
}


foreach i in Imports Exports XI{
	foreach explained_var in loss_war loss_war_nomemory{
		reg `explained_var' colonies_loss ///
		i.neutral_policy i.war ///
		warships_allyandneutral_vs_foe ///
		if pays_grouping =="All" & exportsimports == "`i'"
	}
}
exit
foreach i in Imports Exports XI{
	foreach explained_var in loss_war loss_war_nomemory{
		reg `explained_var' c.colonies_loss i.war ///
		i.neutral_policy ///
		warships_allyandneutral_vs_foe ///
		c.warships_allyandneutral_vs_foe#i.neutral_policy ///
		if pays_grouping =="All" & exportsimports == "`i'"
	}
}



replace war=1 if year>=1745 & year<=1748
replace war=2 if year>=1756 & year<=1763
replace war=1 if year>=1778 & year<=1783
replace war=2 if year>=1793 & year<=1802
replace war=2 if year>=1803 & year<=1815

foreach i in Imports Exports XI{
	foreach explained_var in loss_war loss_war_nomemory{
		reg `explained_var' i.war#c.colonies_loss ///
		i.war#i.neutral_policy ///
		i.war#c.warships_allyandneutral_vs_foe ///
		if pays_grouping =="All" & exportsimports == "`i'"
	}
}

end

reg_loss_function 1 blockade
