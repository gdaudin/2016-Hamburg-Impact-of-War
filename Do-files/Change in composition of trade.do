capture ssc install vioplot
capture ssc install outtable
capture ssc install estout

if "`c(username)'"=="guillaumedaudin" ///
		global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
		global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"

if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE\Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}

use "$hamburg/database_dta/bdd courante reduite2.dta", clear
		
gen period_str=""
replace period_str ="Peace 1749-1755" if year >= 1749 & year <=1755
replace period_str ="War 1756-1763" if year   >= 1756 & year <=1763
replace period_str ="Peace 1764-1777" if year >= 1764 & year <=1777
replace period_str ="War 1778-1783" if year   >= 1778 & year <=1783
replace period_str ="Peace 1784-1792" if year >= 1784 & year <=1792
replace period_str ="War 1793-1807" if year   >= 1793 & year <=1807
replace period_str ="Blockade 1808-1815" if year   >= 1808 & year <=1815
replace period_str ="Peace 1816-1840" if year >= 1816

drop if product_sitc_simplEN == "Precious metals"

gen partner_grouping_8=""
replace partner_grouping_8="Italy" if partner_grouping=="Italie"
replace partner_grouping_8="United Kingdom" if partner_grouping=="Angleterre"
replace partner_grouping_8="Spain" if partner_grouping=="Espagne"
replace partner_grouping_8="Holland" if partner_grouping=="Hollande"
replace partner_grouping_8="Germany" if partner_grouping=="Allemagne"
replace partner_grouping_8="Ottoman Empire" if partner_grouping=="Levant et Barbarie"
replace partner_grouping_8="Spain" if partner_grouping=="Portugal"
replace partner_grouping_8="Germany" if partner_grouping=="Suisse"
replace partner_grouping_8="United States" if partner_grouping=="États-Unis d'Amérique"
replace partner_grouping_8="Holland" if partner_grouping=="Flandre et autres états de l'Empereur" & year < 1792
replace partner_grouping_8="Germany" if partner_grouping=="Flandre et autres états de l'Empereur" & year > 1797
replace partner_grouping_8="Baltic, Scandinavia and Russia" if partner_grouping=="Nord"
replace partner_grouping_8="Ialie" if partner_simplification=="Autriche" & year > 1814

gen sitc_aggr=product_sitc_simplEN
replace sitc_aggr="Other threads and fabrics" if product_sitc_simplEN=="Wool threads and fabrics"
replace sitc_aggr="Other industrial products" if product_sitc_simplEN=="Leather, wood and paper products"
replace sitc_aggr="Other foodstuff and live animals" if product_sitc_simplEN=="Oils"
replace sitc_aggr="Other foodstuff and live animals" if product_sitc_simplEN=="Drinks and tobacco"
replace sitc_aggr="Other" if product_sitc_simplEN=="Chemical products"

save temp_for_hotelling.dta, replace


***************pie chart and violin chart for all war periods***************************
do "$hamburggit/Do-files/To see results/Composition of trade test.do"
do "$hamburggit/Do-files/To create graphs/Composition of trade graph.do"
do "$hamburggit/Do-files/To see results/Composition of trade reg.do"
do "$hamburggit/Do-files/To see results/Composition of trade corr.do"

***********These just to put the programs in memory

////those commented cannot be run because of too few obs

/// possible values for classification: product_sitc_simplEN sitc_aggr partner_grouping

capture program drop test_graph_launcher
program test_graph_launcher 
args launcher_period1 launcher_period2 launcher_class

	composition_trade_test `launcher_period1' `launcher_period2' 1 national Exports `launcher_class'
	matrix hotelling_test=A
	composition_trade_test `launcher_period1' `launcher_period2' 0 national Exports `launcher_class'
	matrix hotelling_test=A+hotelling_test
	composition_trade_test `launcher_period1' `launcher_period2' 1 national Imports `launcher_class'
	matrix hotelling_test=A+hotelling_test
	composition_trade_test `launcher_period1' `launcher_period2' 0 national Imports `launcher_class'
	matrix hotelling_test=A+hotelling_test
	composition_trade_test `launcher_period1' `launcher_period2' 1 national I_X `launcher_class'
	matrix hotelling_test=A+hotelling_test
	composition_trade_test `launcher_period1' `launcher_period2' 0 national I_X `launcher_class'
	matrix hotelling_test=A+hotelling_test
	matrix list hotelling_test
	matrix colnames hotelling_test = "Exports_1" "Exports_0" "Imports_1" "Imports_0" "X_I_1" "X_I_0"

	composition_trade_graph `launcher_period1' `launcher_period2' national `launcher_class'
// it is importand to use the same order when launching the test and the graphs cause I use macro to report pvalues on the graphs

end

capture program drop reg_launcher
program reg_launcher 
args  X_I classification period
	if "`classification'"=="product_sitc_simplEN" local class sitc
	if "`X_I'"=="Exports" local name X
	else if "`X_I'"=="Imports" local name I
	else local name I_X
	composition_trade_reg 1 national `X_I' `classification' `period'
	composition_trade_reg 0 national `X_I' `classification' `period'
	
	esttab 	ln_p`name'`class'1 ln_pnm`name'`class'1 ln_p`name'`class'0 ln_pnm`name'`class'0, ///
	mtitles("Loss" "Loss no memory" "Loss" "Loss no memory") nonumber 
	
	esttab 	p`name'`class'1 pnm`name'`class'1 p`name'`class'0 pnm`name'`class'0, ///
	mtitles("Loss" "Loss no memory" "Loss" "Loss no memory") nonumber 
end

capture program drop corr_launcher
program corr_launcher 
args  X_I classification period
	if "`classification'"=="product_sitc_simplEN" local class sitc
	if "`X_I'"=="Exports" local name X
	else if "`X_I'"=="Imports" local name I
	else local name I_X
	composition_trade_corr 1 national `X_I' `classification' `period'
	composition_trade_corr 0 national `X_I' `classification' `period'
end

/*
test_graph_launcher peace war product_sitc_simplEN
test_graph_launcher seven peace1764_1777 product_sitc_simplEN
test_graph_launcher peace1764_1777 indep product_sitc_simplEN
*test_graph_launcher indep peace1784_1792
test_graph_launcher rev block product_sitc_simplEN
test_graph_launcher peace1816_1840 block product_sitc_simplEN
*test_graph_launcher peace1749_1755 peace1764_1777 product_sitc_simplEN
test_graph_launcher peace1764_1777 peace1784_1792 product_sitc_simplEN


outtable using "$hamburggit/Paper - Impact of War/Paper/manova_test_sitc", ///
				mat(hotelling_test) clabel(tab:manova_test_sitc) ///
				caption("Multivariate Analisys of Variance - by SITC") replace 
*/

reg_launcher  Exports product_sitc_simplEN pre1795
reg_launcher  Exports product_sitc_simplEN all

reg_launcher  Imports product_sitc_simplEN pre1795
reg_launcher  Imports product_sitc_simplEN all

corr_launcher  Exports product_sitc_simplEN pre1795
corr_launcher  Exports product_sitc_simplEN all 

corr_launcher  Imports product_sitc_simplEN pre1795
corr_launcher  Imports product_sitc_simplEN all 


/// by geography 

use temp_for_hotelling.dta, replace
test_graph_launcher peace war partner_grouping_8

use temp_for_hotelling.dta, replace
test_graph_launcher seven peace1764_1777 partner_grouping_8

use temp_for_hotelling.dta, replace
test_graph_launcher peace1764_1777 indep partner_grouping_8

/*
use temp_for_hotelling.dta, replace
test_graph_launcher indep peace1784_1792 partner_grouping_8
*/

use temp_for_hotelling.dta, replace
test_graph_launcher rev block partner_grouping_8

use temp_for_hotelling.dta, replace
test_graph_launcher peace1816_1840 block partner_grouping_8

use temp_for_hotelling.dta, replace
test_graph_launcher peace1749_1755 peace1764_1777 partner_grouping_8

use temp_for_hotelling.dta, replace
test_graph_launcher peace1764_1777 peace1784_1792 partner_grouping_8

use temp_for_hotelling.dta, replace
test_graph_launcher peace1784_1792 peace1816_1840 partner_grouping_8


outtable using "$hamburggit/Paper - Impact of War/Paper/manova_test_pays", ///
				mat(hotelling_test) clabel(tab:manova_test_pays) ///
				caption("Multivariate Analisys of Variance - by geography") replace 

capture erase temp.dat


/// by  product_RE_aggregate 

use temp_for_hotelling.dta, replace
test_graph_launcher peace war sitc_aggr

use temp_for_hotelling.dta, replace
test_graph_launcher seven peace1764_1777 sitc_aggr

use temp_for_hotelling.dta, replace
test_graph_launcher peace1764_1777 indep sitc_aggr

use temp_for_hotelling.dta, replace
test_graph_launcher indep peace1784_1792 sitc_aggr

use temp_for_hotelling.dta, replace
test_graph_launcher rev block sitc_aggr

use temp_for_hotelling.dta, replace
test_graph_launcher peace1816_1840 block sitc_aggr

use temp_for_hotelling.dta, replace
test_graph_launcher peace1749_1755 peace1764_1777 sitc_aggr

use temp_for_hotelling.dta, replace
test_graph_launcher peace1764_1777 peace1784_1792 sitc_aggr

use temp_for_hotelling.dta, replace
test_graph_launcher peace1784_1792 peace1816_1840 sitc_aggr

outtable using "$hamburggit/Paper - Impact of War/Paper/manova_test_aggr", ///
				mat(hotelling_test) clabel(tab:manova_test_aggr) ///
				caption("Multivariate Analisys of Variance - by aggregate SITC") replace 

capture erase temp.dat


