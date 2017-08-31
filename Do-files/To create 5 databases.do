
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


********************************************************************************
***************************CREATE 5 DATABASES***********************************
********************************************************************************
use "$hamburg/database_dta/elisa_bdd_courante", replace
/* LEGEND OF SOURCETYPE
- Colonies: 1787, 1788, 1789
- Divers: 1839
- Divers - in: 1783, 1784
- Local: 1718-1741, 1744-1780 
- National par Direction: 1750, 1789
- National par Direction (-): 1749, 1751, 1777, 1787
- Objet Général: 1752, 1754-1761, 1767-1780, 1782, 1787, 1788
- Résumé: 1787-1789, 1797-1821
- Tableau Général: 1716-1775, 1777-1782 (aggregate)
- Tableau de marchandises: 1821
- Tableau des quantités: 1822
*/



/*------------------------------------------------------------------------------
				save db with no product differentiation
------------------------------------------------------------------------------*/


preserve
***drop double counting 
foreach i of num 1716/1782{
drop if sourcetype!="Tableau Général" & year==`i'
}

foreach i of num 1782/1822{
drop if sourcetype!="Résumé" & year==`i'
}

collapse (sum) value, by(year pays_grouping exportsimports)

save "$hamburg/database_dta/allcountry1", replace

keep if pays_grouping=="Nord"
drop pays_grouping
save "$hamburg/database_dta/hamburg1", replace
restore


/*------------------------------------------------------------------------------
					save db with classification hamburg
------------------------------------------------------------------------------*/

collapse (sum) value, by(sourcetype year direction pays_grouping ///
		classification_hamburg_large exportsimports)



su value if value!=0
local min_value=r(min)

preserve
keep if sourcetype!="National par direction (-)"
fillin exportsimport year pays_grouping direction classification_hamburg_large
bysort year direction exportsimports: egen test_year=total(value), missing
drop if value==0 & test_year==.
drop test_year
save blif.dta, replace
restore


keep if sourcetype=="National par direction (-)"
fillin exportsimport year pays_grouping direction classification_hamburg_large
bysort year pays exportsimports: egen test_year=total(value), missing
drop if value==0 & test_year==.
drop test_year

append using blif.dta
erase blif.dta


collapse (sum) value, by(year pays_grouping ///
classification_hamburg_large exportsimports)

*****merge with imputed data 
merge m:1 exportsimports year pays_grouping classification_hamburg_large ///
using "$hamburg/database_dta/product_estimation"
drop _merge

replace value = pred_value if pred_value!=.
drop pred_value*

save "$hamburg/database_dta/allcountry2", replace

keep if pays_grouping=="Nord" 
drop pays_grouping 
save "$hamburg/database_dta/hamburg2", replace

/*------------------------------------------------------------------------------
				save db with sict classification
------------------------------------------------------------------------------*/
use "$hamburg/database_dta/elisa_bdd_courante", replace

collapse (sum) value, by(sourcetype year direction pays_grouping ///
		sitc18_en exportsimports)


su value if value!=0
local min_value=r(min)

preserve
keep if sourcetype!="National par direction (-)"
fillin exportsimport year pays_grouping direction sitc18_en
bysort year direction exportsimports: egen test_year=total(value), missing
drop if value==0 & test_year==.
drop test_year
save blif.dta, replace
restore


keep if sourcetype=="National par direction (-)"
fillin exportsimport year pays_grouping direction sitc18_en
bysort year pays exportsimports: egen test_year=total(value), missing
drop if value==0 & test_year==.
drop test_year

append using blif.dta

erase blif.dta


collapse (sum) value, by(year pays_grouping ///
sitc18_en exportsimports)

*****merge with imputed data 
merge m:1 exportsimports year pays_grouping sitc18_en ///
using "$hamburg/database_dta/sector_estimation"
drop _merge

replace value = pred_value if pred_value!=.
drop pred_value*

save "$hamburg/database_dta/allcountry2_sitc", replace



