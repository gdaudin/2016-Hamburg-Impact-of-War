
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


collapse (sum) value, by(year sourcetype pays_grouping sitc18_en ///
	classification_hamburg_large exportsimports)

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

***drop double counting 
drop if sourcetype=="Colonies" | sourcetype=="Divers" ///
	| sourcetype=="Divers - in" | sourcetype=="National par direction" ///
	| sourcetype=="Tableau Général" | sourcetype=="Tableau des quantités"

foreach i of num 1716/1751{
drop if sourcetype!="Local" & year==`i'
}
drop if sourcetype!="Objet Général" & year==1752
drop if sourcetype!="Local" & year==1753
foreach i of num 1754/1761{
drop if sourcetype!="Objet Général" & year==`i'
}
foreach i of num 1762/1766{
drop if sourcetype!="Local" & year==`i'
}
foreach i of num 1767/1780{
drop if sourcetype!="Objet Général" & year==`i'
}

foreach i in 1782 1787 1788{
drop if sourcetype!="Objet Général" & year==`i'
}
foreach i of num 1789/1821{
drop if sourcetype!="Résumé" & year==`i'
}


preserve
collapse (sum) value, by(year pays_grouping ///
classification_hamburg_large exportsimports)

*****merge with imputed data 
merge m:1 exportsimports year pays_grouping classification_hamburg_large ///
using "$hamburg/database_dta/product_estimation"
drop _merge

replace value = pred_value_Exports if exportsimports=="Exports"
replace value=pred_value_Imports if exportsimports=="Imports"
drop pred_value*

save "$hamburg/database_dta/allcountry2", replace

keep if pays_grouping=="Nord" 
drop pays_grouping 
save "$hamburg/database_dta/hamburg2", replace
restore
/*------------------------------------------------------------------------------
				save db with sict classification
------------------------------------------------------------------------------*/

preserve
collapse (sum) value, by(year pays_grouping ///
sitc18_en exportsimports)

*****merge with imputed data 
merge m:1 exportsimports year pays_grouping sitc18_en ///
using "$hamburg/database_dta/sector_estimation"
drop _merge

replace value = pred_value_Exports if exportsimports=="Exports"
replace value=pred_value_Imports if exportsimports=="Imports"
drop pred_value*

save "$hamburg/database_dta/allcountry2_new", replace
restore


