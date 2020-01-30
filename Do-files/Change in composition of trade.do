
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

***************pie chart and violin chart for all war periods***************************
do "$hamburggit/Do-files/To see results/Composition of trade test.do"
do "$hamburggit/Do-files/To create graphs/Composition of trade graph.do"

////those commented cannot be run because of too few obs

composition_trade_test peace war 1 national Exports
matrix hotelling_test=A
composition_trade_test peace war 0 national Exports
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 1 national Imports
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 0 national Imports
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 1 national I_X
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 0 national I_X
matrix hotelling_test=A+hotelling_test
matrix list hotelling_test
matrix colnames hotelling_test = "Exports_1" "Exports_0" "Imports_1" "Imports_0" "X_I_1" "X_I_0"
composition_trade_graph peace war national
// it is importand to use the same order when launching the test and the graphs cause I use macro to report pvalues on the graphs


composition_trade_test seven peace1764_1777 1 national Exports
matrix B=A
composition_trade_test seven peace1764_1777 0 national Exports
matrix B=A+B
composition_trade_test seven peace1764_1777 1 national Imports
matrix B=A+B
composition_trade_test seven peace1764_1777 0 national Imports
matrix B=A+B
composition_trade_test seven peace1764_1777 1 national I_X
matrix B=A+B
composition_trade_test seven peace1764_1777 0 national I_X
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph seven peace1764_1777 national



composition_trade_test peace1764_1777 indep 1 national Exports
matrix B=A
composition_trade_test peace1764_1777 indep 0 national Exports
matrix B=A+B
composition_trade_test peace1764_1777 indep 1 national Imports
matrix B=A+B
composition_trade_test peace1764_1777 indep 0 national Imports
matrix B=A+B
composition_trade_test peace1764_1777 indep 1 national I_X
matrix B=A+B
composition_trade_test peace1764_1777 indep 0 national I_X
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1764_1777 indep national



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

composition_trade_test rev block 1 national Exports
matrix B=A
composition_trade_test rev block 0 national Exports
matrix B=A+B
composition_trade_test rev block 1 national Imports
matrix B=A+B
composition_trade_test rev block 0 national Imports
matrix B=A+B
composition_trade_test rev block 1 national I_X
matrix B=A+B
composition_trade_test rev block 0 national I_X
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph rev block indep national



composition_trade_test peace1816_1840 block 1 national Exports
matrix B=A
composition_trade_test peace1816_1840 block 0 national Exports
matrix B=A+B
composition_trade_test peace1816_1840 block 1 national Imports
matrix B=A+B
composition_trade_test peace1816_1840 block 0 national Imports
matrix B=A+B
composition_trade_test peace1816_1840 block 1 national I_X
matrix B=A+B
composition_trade_test peace1816_1840 block 0 national I_X
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1816_1840 block indep national



outtable using "$hamburggit/Paper - Impact of War/Paper/manova_test", ///
				mat(hotelling_test) clabel(manova_test) ///
				caption("Multivariate Analisys of Variance") replace 









