capture ssc install vioplot
capture ssc install outtable

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

drop if product_sitc_simplen == "Precious metals"

gen war=.

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

gen sitc_aggr=product_sitc_simplen
replace sitc_aggr="Other threads and fabrics" if product_sitc_simplen=="Wool threads and fabrics"
replace sitc_aggr="Other industrial products" if product_sitc_simplen=="Leather, wood and paper products"
replace sitc_aggr="Other foodstuff and live animals" if product_sitc_simplen=="Oils"
replace sitc_aggr="Other foodstuff and live animals" if product_sitc_simplen=="Drinks and tobacco"
replace sitc_aggr="Other" if product_sitc_simplen=="Chemical products"

save temp_for_hotelling.dta, replace

***************pie chart and violin chart for all war periods***************************
do "$hamburggit/Do-files/To see results/Composition of trade test.do"
do "$hamburggit/Do-files/To create graphs/Composition of trade graph.do"
***********These just to put the programs in memory

////those commented cannot be run because of too few obs

/// possible values for classification: product_sitc_simplen sitc_aggr partner_grouping

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

use temp_for_hotelling.dta, replace
composition_trade_graph peace war national product_sitc_simplen
// it is importand to use the same order when launching the test and the graphs cause I use macro to report pvalues on the graphs



use temp.dta, clear
keep year export_import product_sitc_simplen percent ln_percent
rename product_sitc_simplen sitc_simplen
merge m:1 sitc_simplen using "$hamburg//2016-Hamburg-Impact-of-War/External Data/classification_product_simplEN_simplEN_short.dta"
keep if _merge==3
drop _merge

gen id=export_import+ sitc_simplen_short
replace id=subinstr(id," ","",.)
drop export_import sitc_simplen sitc_simplen_short

rename percent p
rename ln_percent ln_p

reshape wide p ln_p, i(year) j(id) string 


merge 1:1 year using "$hamburg/database_dta/FR_loss.dta"
drop if _merge==2
regress loss p*
regress loss_nomemory p*

regress loss ln_p*
regress loss_nomemory ln_p*


blif
// it is importand to use the same order when launching the test and the graphs cause I use macro to report pvalues on the graphs

use temp_for_hotelling.dta, replace
composition_trade_test seven peace1764_1777 1 national Exports product_sitc_simplen
**First one that has an issue, I think
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

use temp_for_hotelling.dta, replace
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

use temp_for_hotelling.dta, replace
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

use temp_for_hotelling.dta, replace
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

use temp_for_hotelling.dta, replace
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

use temp_for_hotelling.dta, replace
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

use temp_for_hotelling.dta, replace
composition_trade_graph peace1764_1777 peace1784_1792 national product_sitc_simplen


outtable using "$hamburggit/Paper - Impact of War/Paper/manova_test_sitc", ///
				mat(hotelling_test) clabel(tab:manova_test_sitc) ///
				caption("Multivariate Analisys of Variance - by SITC") replace 

capture erase temp.dat
capture erase temp_for_hotelling.dta

/// by geography 

composition_trade_test peace war 1 national Exports partner_grouping_8
matrix hotelling_test=A
composition_trade_test peace war 0 national Exports partner_grouping_8
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 1 national Imports partner_grouping_8
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 0 national Imports partner_grouping_8
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 1 national I_X partner_grouping_8
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 0 national I_X partner_grouping_8
matrix hotelling_test=A+hotelling_test
matrix list hotelling_test
matrix colnames hotelling_test = "Exports_1" "Exports_0" "Imports_1" "Imports_0" "X_I_1" "X_I_0"

composition_trade_graph peace war national partner_grouping_8
// it is importand to use the same order when launching the test and the graphs cause I use macro to report pvalues on the graphs


composition_trade_test seven peace1764_1777 1 national Exports partner_grouping_8
matrix B=A
composition_trade_test seven peace1764_1777 0 national Exports partner_grouping_8
matrix B=A+B
composition_trade_test seven peace1764_1777 1 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test seven peace1764_1777 0 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test seven peace1764_1777 1 national I_X partner_grouping_8
matrix B=A+B
composition_trade_test seven peace1764_1777 0 national I_X partner_grouping_8
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph seven peace1764_1777 national partner_grouping_8



composition_trade_test peace1764_1777 indep 1 national Exports partner_grouping_8
matrix B=A
composition_trade_test peace1764_1777 indep 0 national Exports partner_grouping_8
matrix B=A+B
composition_trade_test peace1764_1777 indep 1 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test peace1764_1777 indep 0 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test peace1764_1777 indep 1 national I_X partner_grouping_8
matrix B=A+B
composition_trade_test peace1764_1777 indep 0 national I_X partner_grouping_8
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1764_1777 indep national partner_grouping_8



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

composition_trade_test rev block 1 national Exports partner_grouping_8
matrix B=A
composition_trade_test rev block 0 national Exports partner_grouping_8
matrix B=A+B
composition_trade_test rev block 1 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test rev block 0 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test rev block 1 national I_X partner_grouping_8
matrix B=A+B
composition_trade_test rev block 0 national I_X partner_grouping_8
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph rev block national partner_grouping_8



composition_trade_test peace1816_1840 block 1 national Exports partner_grouping_8
matrix B=A
composition_trade_test peace1816_1840 block 0 national Exports partner_grouping_8
matrix B=A+B
composition_trade_test peace1816_1840 block 1 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test peace1816_1840 block 0 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test peace1816_1840 block 1 national I_X partner_grouping_8
matrix B=A+B
composition_trade_test peace1816_1840 block 0 national I_X partner_grouping_8
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1816_1840 block national partner_grouping_8


composition_trade_test peace1749_1755 peace1764_1777 1 national Exports partner_grouping_8
matrix B=A
composition_trade_test peace1749_1755 peace1764_1777 0 national Exports partner_grouping_8
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 1 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 0 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 1 national I_X partner_grouping_8
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 0 national I_X partner_grouping_8
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1749_1755 peace1764_1777 national partner_grouping_8


composition_trade_test peace1764_1777 peace1784_1792 1 national Exports partner_grouping_8
matrix B=A
composition_trade_test peace1764_1777 peace1784_1792 0 national Exports partner_grouping_8
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 1 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 0 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 1 national I_X partner_grouping_8
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 0 national I_X partner_grouping_8
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1764_1777 peace1784_1792 national partner_grouping_8


composition_trade_test peace1784_1792 peace1816_1840 1 national Exports partner_grouping_8
matrix B=A
composition_trade_test peace1784_1792 peace1816_1840 0 national Exports partner_grouping_8
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 1 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 0 national Imports partner_grouping_8
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 1 national I_X partner_grouping_8
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 0 national I_X partner_grouping_8
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1784_1792 peace1816_1840 national partner_grouping_8


outtable using "$hamburggit/Paper - Impact of War/Paper/manova_test_pays", ///
				mat(hotelling_test) clabel(tab:manova_test_pays) ///
				caption("Multivariate Analisys of Variance - by geography") replace 

capture erase temp.dat


/// by  product_re_aggregate 

composition_trade_test peace war 1 national Exports sitc_aggr
matrix hotelling_test=A
composition_trade_test peace war 0 national Exports sitc_aggr
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 1 national Imports sitc_aggr
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 0 national Imports sitc_aggr
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 1 national I_X sitc_aggr
matrix hotelling_test=A+hotelling_test
composition_trade_test peace war 0 national I_X sitc_aggr
matrix hotelling_test=A+hotelling_test
matrix list hotelling_test
matrix colnames hotelling_test = "Exports_1" "Exports_0" "Imports_1" "Imports_0" "X_I_1" "X_I_0"
composition_trade_graph peace war national sitc_aggr
// it is importand to use the same order when launching the test and the graphs cause I use macro to report pvalues on the graphs


composition_trade_test seven peace1764_1777 1 national Exports sitc_aggr
matrix B=A
composition_trade_test seven peace1764_1777 0 national Exports sitc_aggr
matrix B=A+B
composition_trade_test seven peace1764_1777 1 national Imports sitc_aggr
matrix B=A+B
composition_trade_test seven peace1764_1777 0 national Imports sitc_aggr
matrix B=A+B
composition_trade_test seven peace1764_1777 1 national I_X sitc_aggr
matrix B=A+B
composition_trade_test seven peace1764_1777 0 national I_X sitc_aggr
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph seven peace1764_1777 national sitc_aggr



composition_trade_test peace1764_1777 indep 1 national Exports sitc_aggr
matrix B=A
composition_trade_test peace1764_1777 indep 0 national Exports sitc_aggr
matrix B=A+B
composition_trade_test peace1764_1777 indep 1 national Imports sitc_aggr
matrix B=A+B
composition_trade_test peace1764_1777 indep 0 national Imports sitc_aggr
matrix B=A+B
composition_trade_test peace1764_1777 indep 1 national I_X sitc_aggr
matrix B=A+B
composition_trade_test peace1764_1777 indep 0 national I_X sitc_aggr
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1764_1777 indep national sitc_aggr


composition_trade_test rev block 1 national Exports sitc_aggr
matrix B=A
composition_trade_test rev block 0 national Exports sitc_aggr
matrix B=A+B
composition_trade_test rev block 1 national Imports sitc_aggr
matrix B=A+B
composition_trade_test rev block 0 national Imports sitc_aggr
matrix B=A+B
composition_trade_test rev block 1 national I_X sitc_aggr
matrix B=A+B
composition_trade_test rev block 0 national I_X sitc_aggr
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph rev block national sitc_aggr



composition_trade_test peace1816_1840 block 1 national Exports sitc_aggr
matrix B=A
composition_trade_test peace1816_1840 block 0 national Exports sitc_aggr
matrix B=A+B
composition_trade_test peace1816_1840 block 1 national Imports sitc_aggr
matrix B=A+B
composition_trade_test peace1816_1840 block 0 national Imports sitc_aggr
matrix B=A+B
composition_trade_test peace1816_1840 block 1 national I_X sitc_aggr
matrix B=A+B
composition_trade_test peace1816_1840 block 0 national I_X sitc_aggr
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1816_1840 block national sitc_aggr


composition_trade_test peace1749_1755 peace1764_1777 1 national Exports sitc_aggr
matrix B=A
composition_trade_test peace1749_1755 peace1764_1777 0 national Exports sitc_aggr
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 1 national Imports sitc_aggr
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 0 national Imports sitc_aggr
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 1 national I_X sitc_aggr
matrix B=A+B
composition_trade_test peace1749_1755 peace1764_1777 0 national I_X sitc_aggr
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1749_1755 peace1764_1777 national sitc_aggr


composition_trade_test peace1764_1777 peace1784_1792 1 national Exports sitc_aggr
matrix B=A
composition_trade_test peace1764_1777 peace1784_1792 0 national Exports sitc_aggr
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 1 national Imports sitc_aggr
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 0 national Imports sitc_aggr
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 1 national I_X sitc_aggr
matrix B=A+B
composition_trade_test peace1764_1777 peace1784_1792 0 national I_X sitc_aggr
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1764_1777 peace1784_1792 national sitc_aggr

composition_trade_test peace1784_1792 peace1816_1840 1 national Exports sitc_aggr
matrix B=A
composition_trade_test peace1784_1792 peace1816_1840 0 national Exports sitc_aggr
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 1 national Imports sitc_aggr
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 0 national Imports sitc_aggr
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 1 national I_X sitc_aggr
matrix B=A+B
composition_trade_test peace1784_1792 peace1816_1840 0 national I_X sitc_aggr
matrix B=A+B
matrix hotelling_test=hotelling_test\B
composition_trade_graph peace1784_1792 peace1816_1840 national sitc_aggr


outtable using "$hamburggit/Paper - Impact of War/Paper/manova_test_aggr", ///
				mat(hotelling_test) clabel(tab:manova_test_aggr) ///
				caption("Multivariate Analisys of Variance - by aggregate SITC") replace 

capture erase temp.dat


