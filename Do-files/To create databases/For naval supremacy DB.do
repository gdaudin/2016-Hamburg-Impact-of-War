
if "`c(username)'" =="guillaumedaudin" {
		global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
		global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
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



reshape long warships, i(year) j(partner_grouping) string



replace partner_grouping="Angleterre" if partner_grouping=="GreatBritain"
replace partner_grouping="Hollande" if partner_grouping=="Netherlands"
replace partner_grouping="Espagne" if partner_grouping=="Spain"
replace partner_grouping="Italie" if partner_grouping=="Venice"
replace partner_grouping="Levant et Barbarie" if partner_grouping=="OttomanEmpire"
replace partner_grouping="Russiapourmemoire" if partner_grouping=="Russia"
replace partner_grouping="Swedenpourmemoire" if partner_grouping=="Sweden"
replace partner_grouping="Denmarkpourmemoire" if partner_grouping=="Denmark"

*replace country="Portugal

collapse (sum) warships, by(year partner_grouping)

merge 1:1 partner_grouping year using "$hamburg/database_dta/WarAndPeace.dta", keep (1 3)
drop if year <=1732 | year >=1822


drop _merge

replace war_status = "France" if partner_grouping=="France"
replace war_status = "Angleterre" if partner_grouping=="Angleterre"
egen side_warships=total(warships), by(war_status year)

save "$hamburg/database_dta/warships.dta", replace
