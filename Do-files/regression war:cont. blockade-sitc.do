


if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hamburg/"
	global hamburggit "~/Documents/Recherche/2016 Hamburg/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="TIRINDEE" {
	global hamburg "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}



set more off


use "$hamburg/database_dta/allcountry2_sitc.dta", clear

replace sitc18_en="Raw mat fuel oils" if sitc18_en=="Raw mat; fuel; oils"

encode pays_grouping, gen(pays)
encode sitc18_en, gen(sitc)

merge m:1 pays_grouping year using "$hamburg/database_dta/WarAndPeace.dta"

drop if _merge==2

gen break=(year>1795 & sitc==3)
encode each_war_status, gen(each_status) 
egen each_status_sitc=group(each_status sitc), label
replace each_status_sitc=0 if each_status_sitc==. /* I do this to have peace 
														as reference cat*/

encode all_war_status, gen(all_status) 
egen all_status_sitc=group(all_status sitc), label
replace all_status_sitc=0 if all_status_sitc==.   /* I do this to have peace 
														as reference cat*/

/*------------------------------------------------------------------------------
					regress with GROUPS OF WAR
------------------------------------------------------------------------------*/
/*	ALL	REGRESSIONS ARE FIRST RUN WITH NO BREAKS AND THEN WITH ONE BREAK	*/

gen lnvalue=ln(value)
replace exportsimports="Exports" if exportsimports=="Exportations"

levelsof exportsimports, local(exportsimports) 

foreach inourout in `exportsimports'{

****groups of wars interacted with sitc and with groups
eststo `inourout'_eachsitc1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status_sitc ///
	if exportsimports=="`inourout'", vce(robust) iterate(40)
eststo `inourout'_eachsitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status_sitc i.pays#1.break c.year#1.break ///
	if exportsimports=="`inourout'", vce(robust) iterate(40)	
eststo `inourout'_eachsitc3: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status i.pays#1.break c.year#1.break if ///
	exportsimports=="`inourout'", vce(robust) iterate(40)
	


esttab `inourout'_eachsitc1 `inourout'_eachsitc2 ///
	`inourout'_eachsitc3 using ///
	"$hamburggit/Tables/allcountry2_2wars_sitc_`inourout'.csv", ///
	label replace mtitles("SITC#each_war no breaks" ///
	"SITC#each_war 1795 break" "each_war no breaks")
eststo clear

}

codebook value
codebook value
codebook value
codebook value
