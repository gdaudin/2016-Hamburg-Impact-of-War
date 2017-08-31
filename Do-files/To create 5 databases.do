
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
				save db with classification
------------------------------------------------------------------------------*/

capture program drop integrate_predicted
program integrate_predicted
args class_goods

*exemple integrate_predicted sitc18_en
use "$hamburg/database_dta/elisa_bdd_courante", replace

collapse (sum) value, by(sourcetype year direction pays_grouping ///
		`class_goods' exportsimports)

keep if direction=="total" | (source=="National par direction" & year==1750)

tab sourcetype if year==1750

collapse (sum) value, by(year pays_grouping ///
		`class_goods' exportsimports)

tab year if value!=.
		
fillin exportsimport year pays_grouping `class_goods'
bysort year exportsimports: egen test_year=total(value), missing
replace value=0 if value==. & test_year!=.
drop test_year
drop if pays_grouping=="États-Unis d'Amérique" & year <=1777

tab year if value!=.

collapse (sum) value, by(year pays_grouping ///
`class_goods' exportsimports)

*****merge with imputed data 

if "`class_goods'"=="sitc18_en" merge m:1 exportsimports year pays_grouping `class_goods' ///
using "$hamburg/database_dta/sector_estimation"

if "`class_goods'"=="classification_hamburg_large" merge m:1 exportsimports year pays_grouping `class_goods' ///
using "$hamburg/database_dta/product_estimation"


drop _merge

replace value = pred_value if value==.
drop pred_value*

if "`class_goods'"=="sitc18_en" save "$hamburg/database_dta/allcountry2_sitc", replace
if "`class_goods'"=="classification_hamburg_large" save "$hamburg/database_dta/allcountry2", replace

keep if pays_grouping=="Nord" 
drop pays_grouping 
save "$hamburg/database_dta/hamburg2", replace

if "`class_goods'"=="sitc18_en" save "$hamburg/database_dta/hamburg2_sitc", replace
if "`class_goods'"=="classification_hamburg_large" save "$hamburg/database_dta/hamburg2", replace


end



 integrate_predicted sitc18_en
 integrate_predicted classification_hamburg_large


