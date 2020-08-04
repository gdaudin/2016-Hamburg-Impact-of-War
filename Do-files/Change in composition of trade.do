
****Requires ssc install vioplot



if "`c(username)'"=="guillaumedaudin" ///
		global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
		global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"

if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
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

drop if product_sitc_simplen == "Precious metals"
drop if product_sitc_simplen==""

gen war=.
gen country_grouping_7=""
replace country_grouping_7="Italy" if country_grouping=="Italie"
replace country_grouping_7="United Kingdom" if country_grouping=="Angleterre"
replace country_grouping_7="Spain" if country_grouping=="Espagne"
replace country_grouping_7="Central Europe" if country_grouping=="Hollande"
replace country_grouping_7="Central Europe" if country_grouping=="Allemagne"
replace country_grouping_7="Ottoman Empire" if country_grouping=="Levant et Barbarie"
replace country_grouping_7="Spain" if country_grouping=="Portugal"
replace country_grouping_7="Central Europe" if country_grouping=="Suisse"
replace country_grouping_7="United States" if country_grouping=="États-Unis d'Amérique"
replace country_grouping_7="Central Europe" if country_grouping=="Flandre et autres états de l'Empereur"
replace country_grouping_7="Baltic, Scandinavia and Russia" if country_grouping=="Nord"
replace country_grouping_7="Ialie" if country_simplification=="Autriche" & year > 1814

***************pie chart and violin chart for all war periods***************************
do "$hamburggit/Do-files/To see results/Composition of trade test.do"
do "$hamburggit/Do-files/To create graphs/Composition of trade graph.do"

////those commented cannot be run because of too few obs

/// possible values for classification: product_sitc_simplen product_re_aggregate country_grouping

composition_trade_test peace war 1 national Exports product_sitc_simplen
matrix hotelling_test=A
composition_trade_test peace war 0 national Exports product_sitc_simplen
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 1 national Imports product_sitc_simplen
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 0 national Imports product_sitc_simplen
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 1 national I_X product_sitc_simplen
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 0 national I_X product_sitc_simplen
matrix hotelling_test=A+hotelling_test
matrix list hotelling_test
matrix colnames hotelling_test = "Exports_1" "Exports_0" "Imports_1" "Imports_0" "X_I_1" "X_I_0"
composition_trade_graph peace war national product_sitc_simplen
// it is importand to use the same order when launching the test and the graphs cause I use macro to report pvalues on the graphs


composition_trade_test seven peace1764_1777 1 national Exports product_sitc_simplen
matrix B=A
composition_trade_test seven peace1764_1777 0 national Exports product_sitc_simplen
matrix B=A+B
composition_trade_test seven peace1764_1777 1 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test seven peace1764_1777 0 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test seven peace1764_1777 1 national I_X product_sitc_simplen
matrix B=A+B
composition_trade_test seven peace1764_1777 0 national I_X product_sitc_simplen
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph seven peace1764_1777 national product_sitc_simplen



composition_trade_test peace1764_1777 indep 1 national Exports product_sitc_simplen
matrix B=A
composition_trade_test peace1764_1777 indep 0 national Exports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1764_1777 indep 1 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1764_1777 indep 0 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1764_1777 indep 1 national I_X product_sitc_simplen
matrix B=A+B
composition_trade_test peace1764_1777 indep 0 national I_X product_sitc_simplen
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1764_1777 indep national product_sitc_simplen



/*
composition_trade_test indep peace1784_1792 1 national Exports
matrix B=A
composition_trade_test indep peace1784_1792 0 national Exports
matrix B=A+B
composition_trade_test indep peace1784_1792 1 national Imports
matrix B=A+B
composition_trade_test indep peace1784_1792 0 national Imports
matrix B=A+B
composition_trade_test indep peace1784_1792 1 national I_X
matrix B=A+B
composition_trade_test indep peace1784_1792 0 national I_X
matrix B=A+B
matrix hotelling_test=hotelling_test\B
*/

composition_trade_test rev block 1 national Exports product_sitc_simplen
matrix B=A
composition_trade_test rev block 0 national Exports product_sitc_simplen
matrix B=A+B
composition_trade_test rev block 1 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test rev block 0 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test rev block 1 national I_X product_sitc_simplen
matrix B=A+B
composition_trade_test rev block 0 national I_X product_sitc_simplen
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph rev block national product_sitc_simplen



composition_trade_test peace1816_1840 block 1 national Exports product_sitc_simplen
matrix B=A
composition_trade_test peace1816_1840 block 0 national Exports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1816_1840 block 1 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1816_1840 block 0 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1816_1840 block 1 national I_X product_sitc_simplen
matrix B=A+B
composition_trade_test peace1816_1840 block 0 national I_X product_sitc_simplen
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1816_1840 block national product_sitc_simplen


composition_trade_test peace1749_1755 peace1764_1777 1 national Exports product_sitc_simplen
matrix B=A
composition_trade_test peace1749_1755 peace1764_1777 0 national Exports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 1 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 0 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 1 national I_X product_sitc_simplen
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 0 national I_X product_sitc_simplen
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1749_1755 peace1764_1777 national product_sitc_simplen


composition_trade_test peace1764_1777 peace1784_1792 1 national Exports product_sitc_simplen
matrix B=A
composition_trade_test peace1764_1777 peace1784_1792 0 national Exports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 1 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 0 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 1 national I_X product_sitc_simplen
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 0 national I_X product_sitc_simplen
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1764_1777 peace1784_1792 national product_sitc_simplen


composition_trade_test peace1784_1792 peace1816_1840 1 national Exports product_sitc_simplen
matrix B=A
composition_trade_test peace1784_1792 peace1816_1840 0 national Exports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 1 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 0 national Imports product_sitc_simplen
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 1 national I_X product_sitc_simplen
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 0 national I_X product_sitc_simplen
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1784_1792 peace1816_1840 national product_sitc_simplen


outtable using "$hamburggit/Paper - Impact of War/Paper/manova_test_sitc", ///
				mat(hotelling_test) clabel(manova_test) ///
				caption("Multivariate Analisys of Variance") replace 

capture erase temp.dat

/// by geography 

composition_trade_test peace war 1 national Exports country_grouping_7
matrix hotelling_test=A
composition_trade_test peace war 0 national Exports country_grouping_7
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 1 national Imports country_grouping_7
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 0 national Imports country_grouping_7
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 1 national I_X country_grouping_7
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 0 national I_X country_grouping_7
matrix hotelling_test=A+hotelling_test
matrix list hotelling_test
matrix colnames hotelling_test = "Exports_1" "Exports_0" "Imports_1" "Imports_0" "X_I_1" "X_I_0"
composition_trade_graph peace war national country_grouping_7
// it is importand to use the same order when launching the test and the graphs cause I use macro to report pvalues on the graphs


composition_trade_test seven peace1764_1777 1 national Exports country_grouping_7
matrix B=A
composition_trade_test seven peace1764_1777 0 national Exports country_grouping_7
matrix B=A+B
composition_trade_test seven peace1764_1777 1 national Imports country_grouping_7
matrix B=A+B
composition_trade_test seven peace1764_1777 0 national Imports country_grouping_7
matrix B=A+B
composition_trade_test seven peace1764_1777 1 national I_X country_grouping_7
matrix B=A+B
composition_trade_test seven peace1764_1777 0 national I_X country_grouping_7
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph seven peace1764_1777 national country_grouping_7



composition_trade_test peace1764_1777 indep 1 national Exports country_grouping_7
matrix B=A
composition_trade_test peace1764_1777 indep 0 national Exports country_grouping_7
matrix B=A+B
composition_trade_test peace1764_1777 indep 1 national Imports country_grouping_7
matrix B=A+B
composition_trade_test peace1764_1777 indep 0 national Imports country_grouping_7
matrix B=A+B
composition_trade_test peace1764_1777 indep 1 national I_X country_grouping_7
matrix B=A+B
composition_trade_test peace1764_1777 indep 0 national I_X country_grouping_7
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1764_1777 indep national country_grouping_7



/*
composition_trade_test indep peace1784_1792 1 national Exports
matrix B=A
composition_trade_test indep peace1784_1792 0 national Exports
matrix B=A+B
composition_trade_test indep peace1784_1792 1 national Imports
matrix B=A+B
composition_trade_test indep peace1784_1792 0 national Imports
matrix B=A+B
composition_trade_test indep peace1784_1792 1 national I_X
matrix B=A+B
composition_trade_test indep peace1784_1792 0 national I_X
matrix B=A+B
matrix hotelling_test=hotelling_test\B
*/

composition_trade_test rev block 1 national Exports country_grouping_7
matrix B=A
composition_trade_test rev block 0 national Exports country_grouping_7
matrix B=A+B
composition_trade_test rev block 1 national Imports country_grouping_7
matrix B=A+B
composition_trade_test rev block 0 national Imports country_grouping_7
matrix B=A+B
composition_trade_test rev block 1 national I_X country_grouping_7
matrix B=A+B
composition_trade_test rev block 0 national I_X country_grouping_7
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph rev block national country_grouping_7



composition_trade_test peace1816_1840 block 1 national Exports country_grouping_7
matrix B=A
composition_trade_test peace1816_1840 block 0 national Exports country_grouping_7
matrix B=A+B
composition_trade_test peace1816_1840 block 1 national Imports country_grouping_7
matrix B=A+B
composition_trade_test peace1816_1840 block 0 national Imports country_grouping_7
matrix B=A+B
composition_trade_test peace1816_1840 block 1 national I_X country_grouping_7
matrix B=A+B
composition_trade_test peace1816_1840 block 0 national I_X country_grouping_7
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1816_1840 block national country_grouping_7


composition_trade_test peace1749_1755 peace1764_1777 1 national Exports country_grouping_7
matrix B=A
composition_trade_test peace1749_1755 peace1764_1777 0 national Exports country_grouping_7
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 1 national Imports country_grouping_7
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 0 national Imports country_grouping_7
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 1 national I_X country_grouping_7
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 0 national I_X country_grouping_7
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1749_1755 peace1764_1777 national country_grouping_7


composition_trade_test peace1764_1777 peace1784_1792 1 national Exports country_grouping_7
matrix B=A
composition_trade_test peace1764_1777 peace1784_1792 0 national Exports country_grouping_7
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 1 national Imports country_grouping_7
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 0 national Imports country_grouping_7
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 1 national I_X country_grouping_7
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 0 national I_X country_grouping_7
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1764_1777 peace1784_1792 national country_grouping_7


composition_trade_test peace1784_1792 peace1816_1840 1 national Exports country_grouping_7
matrix B=A
composition_trade_test peace1784_1792 peace1816_1840 0 national Exports country_grouping_7
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 1 national Imports country_grouping_7
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 0 national Imports country_grouping_7
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 1 national I_X country_grouping_7
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 0 national I_X country_grouping_7
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1784_1792 peace1816_1840 national country_grouping_7


outtable using "$hamburggit/Paper - Impact of War/Paper/manova_test_pays", ///
				mat(hotelling_test) clabel(manova_test) ///
				caption("Multivariate Analisys of Variance") replace 

capture erase temp.dat




