
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



capture program drop data
program data
args outremer


use "$hamburggit/Results/Mean loss measure.dta", clear
gen peacewar="peace" if strmatch(period_str,"Peace*")==1
replace peacewar = "war" if peacewar=="" 

*keep if breakofinterest=="`break'"


tab grouping_classification

gen ln_loss = ln(1-loss)
gen ln_loss_nomemory = ln(1-loss_nomemory)

merge m:1 grouping_classification exportsimports using "$hamburg/database_dta/Share of land trade 1792.dta"
drop if _merge==2 
drop _merge

tab grouping_classification

preserve
use "$hamburg/database_dta/Neutral legislation.dta", clear
collapse (mean) neutral_policy, by(period_str)
save temp.dta, replace
restore
merge m:1 period_str using temp.dta

erase temp.dta
drop if _merge!=3 
drop _merge




preserve
use "$hamburg/database_dta/warships_wide.dta", clear
collapse (mean) warships*, by(period_str)
save temp.dta, replace
restore
merge m:1 period_str using temp.dta
erase temp.dta
drop if _merge!=3 
drop _merge

preserve
use "$hamburggit/External Data/Colonies loss.dta", clear
gen  colonies_loss=1-weight_france
collapse (mean) colonies_loss, by(period_str)
save temp.dta, replace
restore
merge m:1 period_str using temp.dta
erase temp.dta
drop if _merge!=3 
drop _merge


if `outremer'==0 {
drop if grouping_classification=="Outre-mers"
drop if outremer==1
}

if `outremer'==1 drop if outremer==0

if "`break'"=="blockade" drop if breakofinterest=="R&N"
if "`break'"=="R&N" drop if breakofinterest=="Blockade" 

save temp.dta, replace


end


data 1

use temp.dta, clear

foreach var in peacewar grouping_classification exportsimports {

	encode `var', gen(`var'_num)

}

drop if grouping_classification=="All"
	
reg ln_loss i.peacewar_num#exportsimports_num i.grouping_classification_num#exportsimports_num

reg ln_loss i.peacewar_num#exportsimports_num i.grouping_classification_num#exportsimports_num colonies_loss neutral_policy




