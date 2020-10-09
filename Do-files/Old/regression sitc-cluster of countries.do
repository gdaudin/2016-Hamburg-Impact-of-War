global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"


set more off

use "$thesis/database_dta/allcountry2_sitc", clear

replace sitc18_en="Raw mat fuel oils" if sitc18_en=="Raw mat; fuel; oils"

encode partner_grouping, gen(pays)
encode sitc18_en, gen(sitc)

********************************************************************************
***************REGRESSION WITH SITC AND NEW GROUPS******************************
********************************************************************************

gen groups=""			/*gen var with three groups of countries*/
replace groups="Colonies" if partner_grouping=="Colonies françaises"
replace groups="North" if partner_grouping=="Nord" | partner_grouping=="Hollande" ///
	| partner_grouping=="Angleterre" | partner_grouping=="Suisse" ///
	| partner_grouping=="Flandre et autres états de l'Empereur" 
replace group="South" if partner_grouping=="Allemagne et Pologne (par terre)" ///
	| partner_grouping=="Espagne" | partner_grouping=="Italie" ///
	| partner_grouping=="Portugal" | partner_grouping=="Levant et Barbarie" 
encode groups, gen(group)

preserve 		/*calculate average share of shares of each sitc per group*/
collapse (sum) value, by(sitc group export_import pays)
bysort export_import pays: egen tot=sum(value)
gen share=value/tot
egen expimp_group = concat (group export_import), punct("")
collapse (mean) share, by(expimp_group sitc) /*export it as a csv cause 
											I didn't find a way to tabulate 
											it properly*/
local lsitc : variable label sitc
levelsof sitc, local(sitc_levels)
foreach val of local sitc_levels{
local sitcvl`val' : label sitc `val'
}
reshape wide share, i(expimp_group) j(sitc) 
local variablelist "share"
foreach variable of local variablelist{
foreach value of local sitc_levels{
label variable `variable'`value' "`l`variable'' `sitcvl`value''"
}
}

esttab using "$thesis/Data/do_files/Hamburg/Tables/group_shares", ///
label replace
restore



********************************************************************************
***************RE-RUN REGRESSIONS WITH CLUSTERS*********************************
********************************************************************************

collapse (sum) value, by(sitc year pays partner_grouping export_import group)
replace export_import="Exports" if export_import=="Exportations"

*****gen war dummy
gen war=0
foreach i of num 1733/1738{
replace war=1 if year==`i'
}
foreach i of num 1740/1748{
replace war=1 if year==`i'
}
foreach i of num 1756/1763{
replace war=1 if year==`i'
}
foreach i of num 1778/1782{
replace war=1 if year==`i'
}
foreach i of num 1792/1802{
replace war=1 if year==`i'
}
foreach i of num 1803/1814{
replace war=1 if year==`i'
}

gen break=(year>1795 & sitc==3)

/*------------------------------------------------------------------------------
								regress with EXPORTS
------------------------------------------------------------------------------*/
/*	ALL	REGRESSIONS ARE FIRST RUN WITH NO BREAKS AND THEN WITH ONE BREAK	*/

****wars interacted with sitc and with groups
eststo export_groupsitc1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group#i.sitc ///
	if export_import=="Exports", vce(robust) iterate(40)
eststo export_groupsitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group#i.sitc i.pays#1.break c.year#1.break ///
	if export_import=="Exports", vce(robust) iterate(40)

****wars interacted with groups only
eststo export_group1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group ///
	if export_import=="Exports", vce(robust) iterate(40)
eststo export_group2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group i.pays#1.break c.year#1.break if ///
	export_import=="Exports", vce(robust) iterate(40)

****wars interacted with sitc only
eststo export_sitc1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.sitc if export_import=="Exports", ///
	vce(robust) iterate(40)
eststo export_sitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.sitc i.pays#1.break c.year#1.break ///
	if export_import=="Exports", vce(robust) iterate(40)
	

esttab export_groupsitc1 export_groupsitc2 export_group1 export_group2 ///
	export_sitc1 export_sitc2 using ///
	"$thesis/Data/do_files/Hamburg/Tables/allcountry2_clustersitc_export.csv", ///
	label replace mtitles("SITC#group#war no breaks" ///
	"SITC#group#war 1795 break" "group#war no breaks" "group#war 1795 breaks" ///
	"SITC#war no breaks" "SITC#war 1795 breaks")
		
/*------------------------------------------------------------------------------
								regress with IMPORTS
------------------------------------------------------------------------------*/
/*	ALL	REGRESSIONS ARE FIRST RUN WITH NO BREAKS AND THEN WITH ONE BREAK	*/

****wars interacted with sitc and with groups
eststo import_groupsitc1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group#i.sitc ///
	if export_import=="Imports", vce(robust) iterate(40)
eststo import_groupsitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group#i.sitc i.pays#1.break c.year#1.break ///
	if export_import=="Imports", vce(robust) iterate(40)
	
****wars interacted with groups only	
eststo import_group1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group if export_import=="Imports", ///
	vce(robust) iterate(40)
eststo import_group2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group i.pays#1.break c.year#1.break ///
	if export_import=="Imports", vce(robust) iterate(40)
	
****wars interacted with sitc only	
eststo import_sitc1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.sitc if export_import=="Imports", ///
	vce(robust) iterate(40)
eststo import_sitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.sitc i.pays#1.break c.year#1.break ///
	if export_import=="Imports", vce(robust) iterate(40)
	

esttab import_groupsitc1 import_groupsitc2 import_group1 import_group2 ///
	import_sitc1 import_sitc2 using ///
	"$thesis/Data/do_files/Hamburg/Tables/allcountry2_clustersitc_import.csv", ///
	label replace mtitles("SITC#group#war no breaks" ///
	"SITC#group#war 1795 break" ///
	"group#war no breaks" "group#war 1795 breaks" ///
	"SITC#war no breaks" "SITC#war 1795 breaks")


	
