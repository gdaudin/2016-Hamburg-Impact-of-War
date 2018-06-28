global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"


set more off

use "$thesis/database_dta/allcountry2_sitc", clear

replace sitc18_en="Raw mat fuel oils" if sitc18_en=="Raw mat; fuel; oils"

encode grouping_classification, gen(pays)
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


