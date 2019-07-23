macro drop _all 

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
replace period_str ="Peace 1763-1777" if year >= 1763 & year <=1777
replace period_str ="War 1778-1783" if year   >= 1778 & year <=1783
replace period_str ="Peace 1784-1792" if year >= 1784 & year <=1792
replace period_str ="War 1793-1807" if year   >= 1793 & year <=1807
replace period_str ="Blockade 1808-1815" if year   >= 1808 & year <=1815
replace period_str ="Peace 1816-1840" if year >= 1816

drop if product_sitc_simplen == "Precious metals"
drop if product_sitc_simplen==""

label define peacewar 0 "Peace" 1 "War"
label define blockwar 0 "Blockade" 1 "War"

gen war=.

***************pie chart and violin chart for all war periods***************************
do "$hamburggit/Do-files/To see results/Composition of trade test.do"
do "$hamburggit/Do-files/To create graphs/Composition of trade graph.do"

////those commented cannot be run because of too few obs
composition_trade_test peace_war 1 national
composition_trade_test peace_war 0 national
composition_trade_graph peace_war national 

*composition_trade_test pre_seven 1 national
*composition_trade_test pre_seven 0 national
*composition_trade_graph pre_seven national

composition_trade_test post_seven 1 national
composition_trade_test post_seven 0 national
composition_trade_graph post_seven  national

composition_trade_test pre_independence 1 national
composition_trade_test pre_independence 0 national
composition_trade_graph pre_independence national

*composition_trade_test post_independence 1 national
*composition_trade_test post_independence 0 national
*composition_trade_graph post_independence  national

*composition_trade_test pre_revolutionary 1 national
*composition_trade_test pre_revolutionary 0 national
*composition_trade_graph pre_revolutionary  national

composition_trade_test revolutionary_block 1 national
composition_trade_test revolutionary_block 0 national
composition_trade_graph revolutionary_block national

composition_trade_test post_blockade 1 national
composition_trade_test post_blockade 0 national
composition_trade_graph post_blockade national



