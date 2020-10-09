
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hamburg/"
	global hamburggit "~/Documents/Recherche/2016 Hamburg/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
}


********************************************************************************
***************************CREATE 5 DATABASES***********************************
********************************************************************************
use "$hamburg/database_dta/elisa_bdd_courante", replace
/* LEGEND OF source_type
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
drop if source_type!="Tableau Général" & year==`i'
}

foreach i of num 1782/1822{
drop if source_type!="Résumé" & year==`i'
}

collapse (sum) value, by(year partner_grouping export_import)

save "$hamburg/database_dta/allcountry1", replace

keep if partner_grouping=="Nord"
drop partner_grouping
save "$hamburg/database_dta/hamburg1", replace
restore


/*------------------------------------------------------------------------------
				save db with classification
------------------------------------------------------------------------------*/

capture program drop integrate_predicted
program integrate_predicted
args class_goods

*exemple integrate_predicted sitc18_en
use "$hamburg/database_dta/elisa_bdd_courante", replace

collapse (sum) value, by(source_type year direction partner_grouping ///
		`class_goods' export_import)

keep if direction=="total" | (source=="National par direction" & year==1750)

tab source_type if year==1750

collapse (sum) value, by(year partner_grouping ///
		`class_goods' export_import)

tab year if value!=.

gen imputed = 0		
fillin exportsimport year partner_grouping `class_goods'
bysort year export_import: egen test_year=total(value), missing
replace imputed = 1 if value==. & test_year!=.
replace value=0 if value==. & test_year!=.


drop test_year

tab year if value!=.

*****merge with imputed data 

if "`class_goods'"=="sitc18_en" merge m:1 export_import year partner_grouping `class_goods' ///
using "$hamburg/database_dta/sector_estimation"

if "`class_goods'"=="hamburg_classification" merge m:1 export_import year partner_grouping `class_goods' ///
using "$hamburg/database_dta/product_estimation"

drop if partner_grouping=="États-Unis d'Amérique" & year <=1777

drop _merge

gen predicted=0
replace predicted = 1 if value==.
replace value = pred_value if value==.
drop pred_value*

if "`class_goods'"=="sitc18_en" save "$hamburg/database_dta/allcountry2_sitc", replace
if "`class_goods'"=="hamburg_classification" save "$hamburg/database_dta/allcountry2", replace

keep if partner_grouping=="Nord" 
drop partner_grouping 
save "$hamburg/database_dta/hamburg2", replace

if "`class_goods'"=="sitc18_en" save "$hamburg/database_dta/hamburg2_sitc", replace
if "`class_goods'"=="hamburg_classification" save "$hamburg/database_dta/hamburg2", replace


end



 integrate_predicted sitc18_en
 integrate_predicted hamburg_classification


