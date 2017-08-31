


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




capture program drop reg_choc_diff
program reg_choc_diff
args product_class interet  inourout predicted

*Exemple : reg_choc_dif sitc Blockade Exports 1 1 



if "`product_class'"=="sitc" use "$hamburg/database_dta/allcountry2_sitc.dta", clear

replace sitc18_en="Raw mat fuel oils" if sitc18_en=="Raw mat; fuel; oils"

encode pays_grouping, gen(pays)
encode sitc18_en, gen(sitc)

merge m:1 pays_grouping year using "$hamburg/database_dta/WarAndPeace.dta"

drop if _merge==2

gen break=(year>1795)

*gen lnvalue=ln(value)



if `predicted'==0 drop if predicted==1

encode war_status, gen(war_status_num)
gen war_peace=""


if "`interet'" =="R&N" {
	replace war_peace = "Mercantilist_War" if war_status_num!=. & year>=1744
	replace war_peace = "R&N War" if war_status_num!=. & year>=1808
	encode war_peace, gen(war_peace_num)
}


if "`interet'" =="Blockade" {
	replace war_peace = "Mercantilist_War" if war_status_num!=. & year>=1744
	replace war_peace = "Blockade" if war_status_num!=. & year>=1808
	encode war_peace, gen(war_peace_num)
}




eststo choc_diff_status: poisson value /// 
	i.war_status_num#i.war_peace_num  c.year#i.war_status_num#i.war_peace_num ///
	i.pays#i.sitc  c.year#i.pays#i.sitc ///	
	if exportsimports=="`inourout'", vce(robust) iterate(40)

	
eststo choc_diff_goods: poisson value /// 
	i.sitc#i.war_peace_num  c.year#i.sitc#i.war_peace_num ///
	i.pays#i.sitc  c.year#i.pays#i.sitc ///	
	if exportsimports=="`inourout'", vce(robust) iterate(40)
		
	
	/*
	
eststo `inourout'_eachsitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status_sitc i.pays#1.break c.year#1.break ///
	if exportsimports=="`inourout'", vce(robust) iterate(40)	
eststo `inourout'_eachsitc3: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status i.pays#1.break c.year#1.break if ///
	exportsimports=="`inourout'", vce(robust) iterate(40)
	
*/

esttab choc_diff_status ///
	choc_diff_goods ///
/*	`inourout'_eachsitc2 ///
	`inourout'_eachsitc3  ///
*/	using "$hamburggit/Tables/reg_choc_diff_`product_class'_`interet'_`inourout'_`predicted'.csv", ///
	label replace mtitles("war # status" ///
	"war #goods") ///

	
eststo clear



end

codebook value
codebook value
codebook value
codebook value

reg_choc_diff sitc Blockade Exports 1 1 
