global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"


set more off

use "$thesis/database_dta/allcountry2_new", clear

encode pays_grouping, gen(pays)
encode sitc18_en, gen(sitc)


********************************************************************************
***************K-CLUSTERING and FACTOR ANALYSIS BY SITC TRADE COMPOSITION********
********************************************************************************
/*------------------------------------------------------------------------------
								WITH SHARE
------------------------------------------------------------------------------*/

preserve
collapse (sum) value , by(pays sitc exportsimports)

******gen shares
gen value_export=value if exportsimports=="Exports"
gen value_import=value if exportsimports=="Imports"
collapse (sum) value_export value_import , by(pays sitc)
bysort pays: egen tot_export=sum(value_export)
bysort pays: egen tot_import=sum(value_import)
gen share_export=value_export/tot_export
gen share_import=value_import/tot_import
drop value*

****store labels in macro to keep them after reshape
local lsitc : variable label sitc
levelsof sitc, local(sitc_levels)
foreach val of local sitc_levels{
local sitcvl`val' : label sitc `val'
}

*****reshape to cluster 
reshape wide share_export share_import, i(pays) j(sitc)

*****apply labels to reshaped dataset
local variablelist "share_export share_import"
foreach variable of local variablelist{
foreach value of local sitc_levels{
label variable `variable'`value' "`l`variable'' `sitcvl`value''"
}
}



/*----------------------------cluster analysis----------------------------*/

*****try different kinds of clusters
sort pays
cluster kmeans share*, k(3) name(clust1) 
sort clust1
list pays clust1
cluster kmeans share*, k(4) name(clust2) 
sort clust2
list pays clust1
cluster singlelinkage share*, name(clust3)
list pays clust1
cluster dendrogram clust3
graph export "$thesis/Graph/factor_cluster/dendrogram_share3.png", ///
	as(png) replace
cluster singlelinkage share* if pays!=1 & pays!=13, ///
	name(clust4) 
cluster dendrogram clust4 plotregion(fcolor(white)) graphregion(fcolor(white)) 
graph export "$thesis/Graph/factor_cluster/dendrogram_share4.png", as(png) replace

/*----------------------------factor analysis-------------------------------*/
factor share*
rotate
predict factor1 factor2 factor3 factor4
scatter factor1 factor2 in 1/13, mlabel(pays) ///
	plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$thesis/Graph/factor_cluster/factor1_2.png", as(png) replace
scatter factor1 factor3 in 1/13, mlabel(pays) ///
	plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$thesis/Graph/factor_cluster/factor1_3.png", as(png) replace
scatter factor1 factor4 in 1/13, mlabel(pays) ///
	plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$thesis/Graph/factor_cluster/factor1_4.png", as(png) replace
scatter factor2 factor3 in 1/13, mlabel(pays) ///
	plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$thesis/Graph/factor_cluster/factor2_3.png", as(png) replace
scatter factor2 factor4 in 1/13, mlabel(pays) ///
	plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$thesis/Graph/factor_cluster/factor2_4.png", as(png) replace
scatter factor3 factor4 in 1/13, mlabel(pays) ///
	plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$thesis/Graph/factor_cluster/factor3_4.png", as(png) replace
restore


/*------------------------------------------------------------------------------
								WITH VALUE
------------------------------------------------------------------------------*/
preserve
collapse (sum) value , by(pays sitc exportsimports)
gen value_export=value if exportsimports=="Exports"
gen value_import=value if exportsimports=="Imports"
collapse (sum) value_export value_import , by(pays sitc)
local lsitc : variable label sitc
levelsof sitc, local(sitc_levels)
foreach val of local sitc_levels{
local sitcvl`val' : label sitc `val'
}
reshape wide value_export value_import, i(pays) j(sitc)
local variablelist "value_export value_import"
foreach variable of local variablelist{
foreach value of local sitc_levels{
label variable `variable'`value' "`l`variable'' `sitcvl`value''"
}
}

/*----------------------------cluster analysis----------------------------*/
sort pays
cluster kmeans value*, k(3) name(clust1) 
list pays clust1
cluster kmeans value*, k(4) name(clust2) 
list pays clust1
cluster singlelinkage value*, name(clust3)
list pays clust1
cluster dendrogram clust3
graph export "$thesis/Graph/factor_cluster/dendrogram_value.png", as(png) replace
cluster singlelinkage value*, name(clust4)
list pays clust1
restore



********************************************************************************
***************REGRESSION WITH SITC AND NEW GROUPS******************************
********************************************************************************

gen groups=""			/*gen var with three groups of countries*/
replace groups="Colonies" if pays_grouping=="Colonies françaises"
replace groups="North" if pays_grouping=="Nord" | pays_grouping=="Hollande" ///
	| pays_grouping=="Angleterre" | pays_grouping=="Suisse" ///
	| pays_grouping=="Flandre et autres états de l'Empereur" 
replace group="South" if pays_grouping=="Allemagne et Pologne (par terre)" ///
	| pays_grouping=="Espagne" | pays_grouping=="Italie" ///
	| pays_grouping=="Portugal" | pays_grouping=="Levant et Barbarie" 
encode groups, gen(group)

preserve 		/*calculate average share of shares of each sitc per group*/
collapse (sum) value, by(sitc group exportsimports pays)
bysort exportsimports pays: egen tot=sum(value)
gen share=value/tot
egen expimp_group = concat (group exportsimports), punct("")
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

collapse (sum) value, by(sitc year pays exportsimports group)

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
	if exportsimports=="Exports", vce(robust) iterate(40)
eststo export_groupsitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group#i.sitc i.pays#1.break c.year#1.break ///
	if exportsimports=="Exports", vce(robust) iterate(40)

****wars interacted with groups only
eststo export_group1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group ///
	if exportsimports=="Exports", vce(robust) iterate(40)
eststo export_group2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group i.pays#1.break c.year#1.break if ///
	exportsimports=="Exports", vce(robust) iterate(40)

****wars interacted with sitc only
eststo export_sitc1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.sitc if exportsimports=="Exports", ///
	vce(robust) iterate(40)
eststo export_sitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.sitc i.pays#1.break c.year#1.break ///
	if exportsimports=="Exports", vce(robust) iterate(40)
	

esttab export_groupsitc1 export_groupsitc2 export_group1 export_group2 ///
	export_sitc1 export_sitc2 using ///
	"$thesis/Data/do_files/Hamburg/Tables/allcountry2_groupsitc_export.csv", ///
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
	if exportsimports=="Imports", vce(robust) iterate(40)
eststo import_groupsitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group#i.sitc i.pays#1.break c.year#1.break ///
	if exportsimports=="Imports", vce(robust) iterate(40)
	
****wars interacted with groups only	
eststo import_group1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group if exportsimports=="Imports", ///
	vce(robust) iterate(40)
eststo import_group2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.group i.pays#1.break c.year#1.break ///
	if exportsimports=="Imports", vce(robust) iterate(40)
	
****wars interacted with sitc only	
eststo import_sitc1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.sitc if exportsimports=="Imports", ///
	vce(robust) iterate(40)
eststo import_sitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc 1.war#i.sitc i.pays#1.break c.year#1.break ///
	if exportsimports=="Imports", vce(robust) iterate(40)
	

esttab import_groupsitc1 import_groupsitc2 import_group1 import_group2 ///
	import_sitc1 import_sitc2 using ///
	"$thesis/Data/do_files/Hamburg/Tables/allcountry2_groupsitc_import.csv", ///
	label replace mtitles("SITC#group#war no breaks" ///
	"SITC#group#war 1795 break" ///
	"group#war no breaks" "group#war 1795 breaks" ///
	"SITC#war no breaks" "SITC#war 1795 breaks")

