
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
