
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



capture program drop prepar_data
program prepar_data
args outremer freq


use "$hamburggit/Results/`freq' loss measure.dta", clear
gen peacewar="peace" if strmatch(period_str,"Peace*")==1
replace peacewar = "war" if peacewar=="" 

drop if grouping_classification=="All" | grouping_classification=="All_ss_outremer"
if `outremer'==0 drop if grouping_classification=="Outre-mers"

tab grouping_classification

gen ln_loss = ln(1-loss)
gen ln_loss_nomemory = ln(1-loss_nomemory)

merge m:1 grouping_classification exportsimports using "$hamburg/database_dta/Share of land trade 1792.dta"
drop if _merge==2 
drop _merge

tab grouping_classification


if "`freq'"=="Mean" {
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
}


if "`freq'"=="Yearly" {
	merge m:1 year using "$hamburg/database_dta/warships_wide.dta"
	drop if _merge!=3 
	drop _merge

	merge m:1 year using "$hamburg/database_dta/Neutral legislation.dta"
	drop if _merge!=3 
	drop _merge

	merge m:1 year using "$hamburggit/External Data/Colonies loss.dta"
	rename weight_france colonies_loss
	drop if _merge!=3 
	drop _merge
}



gen country_exportsimports = grouping_classification+"_"+exportsimports

foreach var in peacewar country_exportsimports grouping_classification exportsimports war_status {

	encode `var', gen(`var'_num)

}



******************FIN DE LA PRÉPARATION DES DONNÉÉS

if "`freq'"=="Mean" local weight [fweight=nbr_of_years]


reg ln_loss i.war_status_num#peacewar_num ///
		`weight' 

		
reg ln_loss i.war_status_num#peacewar_num if year<=1815  ///
		`weight' 
reg ln_loss i.war_status_num#peacewar_num if year<=1807	 ///
		`weight' 	
reg ln_loss i.war_status_num#peacewar_num if year<=1793  ///
		`weight' 


/*
areg ln_loss i.war_status_num#peacewar_num ///
		`weight' ///
		, absorb(country_exportsimports_num)

*/
		
		
		

end


*prepar_data 1 R&N Mean
prepar_data 1 Yearly

/*

use "$hamburggit/Results/temp.dta", clear


areg ln_loss i.peacewar_num i.war_status_num i.war_status_num#peacewar_num ///
		if breakofinterest=="R&N", absorb(country_exportsimports_num)
areg ln_loss i.peacewar_num i.war_status_num i.war_status_num#peacewar_num ///
		[fweight=nbr_of_years] ///
		if breakofinterest=="R&N", absorb(country_exportsimports_num)


reg ln_loss i.peacewar_num#exportsimports_num i.grouping_classification_num#exportsimports_num colonies_loss


reg ln_loss i.peacewar_num#exportsimports_num i.grouping_classification_num#exportsimports_num colonies_loss neutral_policy




