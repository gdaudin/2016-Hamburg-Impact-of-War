global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"


set more off

use "$thesis/database_dta/allcountry2_new", clear

replace sitc18_en="Raw mat fuel oils" if sitc18_en=="Raw mat; fuel; oils"

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
cluster dendrogram clust3, plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$thesis/Graph/factor_cluster/dendrogram_share3.png", ///
	as(png) replace
cluster singlelinkage share* if pays!=1 & pays!=13, ///
	name(clust4) 
cluster dendrogram clust4, plotregion(fcolor(white)) graphregion(fcolor(white)) 
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
cluster dendrogram clust3, plotregion(fcolor(white)) graphregion(fcolor(white))
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

collapse (sum) value, by(sitc year pays pays_grouping exportsimports group)
replace exportsimports="Exports" if exportsimports=="Exportations"

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


	
	
	
********************************************************************************
***************RE-RUN REGRESSIONS WITH GROUPS OF WARS***************************
********************************************************************************


/*gen one dummy for each war and 3 dummies for three groups of wars 
(Polish Austrian1 // Austrian2 Seven American // Revolutionary Napoleonic)
I generate them as string and then encode them to avoid creating 
and labelling a 1000 dummies*/

gen each_war_status=""
gen all_war_status=""

foreach i of num 1733/1738{
replace each_war_status="Land_war adversary" ///
	if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'

replace each_war_status="Land_war neutral" if pays_grouping=="Hollande" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Portugal" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Italie" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
}

foreach i of num 1733/1738{
replace each_war_status="Land_war allied" if ///
	each_war_status!="Land_war neutral" & ///
	each_war_status!="Land_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}


foreach i of num 1740/1743{
replace each_war_status="Land_war adversary" ///
	if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="Land_war adversary" ///
	if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="Land_war adversary" ///
	if pays_grouping=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==`i'

replace each_war_status="Land_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
}

foreach i of num 1740/1743{
replace each_war_status="Land_war allied" if each_war_status!="Land_war neutral" ///
	& each_war_status!="Land_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}


foreach i of num 1744/1748{
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==`i'

replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
}

foreach i of num 1744/1748{
replace each_war_status="Mercantilist_war allied" if ///
	each_war_status!="Mercantilist_war neutral" & ///
	each_war_status!="Mercantilist_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}

foreach i of num 1756/1763{
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'

replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Hollande" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Suisse" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
}

foreach i of num 1756/1763{
replace each_war_status="Mercantilist_war allied" if ///
	each_war_status!="Mercantilist_war neutral" & ///
	each_war_status!="Mercantilist_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}

foreach i of num 1778/1782{
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'

replace each_war_status="Mercantilist_war neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Portugal" & year==`i'

replace all_war_status="Neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
}

foreach i of num 1778/1782{
replace each_war_status="Mercantilist_war allied" if each_war_status!="Mercantilist_war neutral" ///
	& each_war_status!="Mercantilist_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & ///
	all_war_status!="Neutral" & year==`i'
}

foreach i of num 1792/1795{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Espagne" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Hollande" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace each_war_status="R&N_war adversary" if pays_grouping=="Italie" & year==`i'


replace all_war_status="Adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Espagne" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Italie" & year==`i'


replace each_war_status="R&N_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="R&N_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="R&N_war neutral" if pays_grouping=="Suisse" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
}

foreach i of num 1792/1795{
replace each_war_status="R&N_war allied" if each_war_status!="R&N_war neutral" ///
	& each_war_status!="R&N_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & ///
	all_war_status!="Neutral" & year==`i'
}

foreach i of num 1796/1802{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace each_war_status="R&N_war adversary" if pays_grouping=="Italie" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Italie" & year==`i'

replace each_war_status="R&N_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="R&N_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="R&N_war neutral" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}

foreach i of num 1796/1802{
replace each_war_status="R&N_war allied" if each_war_status!="R&N_war neutral" ///
	& each_war_status!="R&N_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}


foreach i of num 1803/1814{
replace each_war_status="R&N_war allied" if year==`i'
replace all_war_status="Allied" if year==`i'
}

foreach i of num 1803/1814{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
}

foreach i in 1805 1809{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1805/1809{
replace each_war_status="R&N_war allied" if ///
	each_war_status!="Napoleonic neutral" & ///
	each_war_status!="Napoleonic adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}

foreach i in 1806 1807{
replace each_war_status="R&N_war neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1813/1815{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1800/1807{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
}
foreach i of num 1809/1815{
replace each_war_status="R&N_war adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Portugal" & year==`i'
}

*****1806-1812 germany is allied
foreach i of num 1806/1807{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}
foreach i of num 1813/1815{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}

foreach i of num 1808/1815{
replace each_war_status="R&N_war adversary" if pays_grouping=="Espagne" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Espagne" & year==`i'
}

foreach i of num 1803/1815{
replace each_war_status="R&N_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="R&N_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="R&N_war neutral" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'
}

replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Suisse" & year==1815
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Hollande" & year==1815

replace all_war_status="Adversary" if pays_grouping=="Suisse" & year==1815
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==1815

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
eststo `inourout'_eachsitc1: reg lnvalue i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status_sitc ///
	if exportsimports=="`inourout'", vce(robust) 
eststo `inourout'_eachsitc2: reg lnvalue i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status_sitc i.pays#1.break c.year#1.break ///
	if exportsimports=="`inourout'", vce(robust) 	
eststo `inourout'_allsitc3: reg lnvalue i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status i.pays#1.break c.year#1.break if ///
	exportsimports=="`inourout'", vce(robust) 
	
****wars interacted with groups only
eststo `inourout'_allsitc1: reg lnvalue i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.all_status_sitc ///
	if exportsimports=="`inourout'", vce(robust) 
eststo `inourout'_allsitc2: reg lnvalue i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.all_status_sitc i.pays#1.break c.year#1.break if ///
	exportsimports=="`inourout'", vce(robust) 



esttab `inourout'_eachsitc1 `inourout'_eachsitc2 ///
	`inourout'_allsitc1 `inourout'_allsitc2 using ///
	"$thesis/Data/do_files/Hamburg/Tables/allcountry2_groupsitc_export.csv", ///
	label replace mtitles("SITC#group#war no breaks" ///
	"SITC#group#war 1795 break" "group#war no breaks" "group#war 1795 breaks" ///
	"SITC#war no breaks" "SITC#war 1795 breaks")

eststo clear

}

codebook value
codebook value
codebook value
codebook value
