
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
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



reshape long warships, i(year) j(country_grouping) string



replace country_grouping="Angleterre" if country_grouping=="GreatBritain"
replace country_grouping="Hollande" if country_grouping=="Netherlands"
replace country_grouping="Espagne" if country_grouping=="Spain"
replace country_grouping="Italie" if country_grouping=="Venice"
replace country_grouping="Levant et Barbarie" if country_grouping=="OttomanEmpire"
replace country_grouping="Russiapourmemoire" if country_grouping=="Russia"
replace country_grouping="Swedenpourmemoire" if country_grouping=="Sweden"
replace country_grouping="Denmarkpourmemoire" if country_grouping=="Denmark"

*replace country="Portugal

collapse (sum) warships, by(year country_grouping)

merge 1:1 country_grouping year using "$hamburg/database_dta/WarAndPeace.dta", keep (1 3)
drop if year <=1732 | year >=1822


drop _merge

replace war_status = "France" if country_grouping=="France"
replace war_status = "Angleterre" if country_grouping=="Angleterre"
egen side_warships=total(warships), by(war_status year)

save "$hamburg/database_dta/warships.dta", replace
