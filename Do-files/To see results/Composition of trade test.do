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

collapse (sum) value, by(year product_sitc_simplen exportsimports period_str)
drop if product_sitc_simplen==""

capture program drop composition_trade_test
program composition_trade_test
args period

	gen war=. 
	if "`period'"=="peace_war"{
		replace war=1 if period_str=="War 1756-1763" | period_str =="War 1778-1783" | ///
						 period_str=="War 1793-1807" | period_str =="Blockade 1808-1815"
		replace war=0 if war!=1
		}
	
	if "`period'"=="pre_seven"{
		replace war=0 if period_str=="Peace 1749-1755"
		replace war=1 if period_str=="War 1756-1763" 
		}
	
	if "`period'"=="post_seven"{
		replace war=1 if period_str=="War 1756-1763" 
		replace war=0 if period_str=="Peace 1763-1777"
		}
	
	if "`period'"=="pre_independence"{
		replace war=0 if period_str=="Peace 1763-1777" 
		replace war=1 if period_str=="War 1778-1783" 
		}
	
	if "`period'"=="post_independence"{
		replace war=1 if period_str=="War 1778-1783" 
		replace war=0 if period_str=="Peace 1784-1792" 
		}
	
	if "`period'"=="pre_revolutionary"{
		replace war=0 if period_str=="Peace 1784-1792" 
		replace war=1 if period_str=="War 1793-1807" 
		}
	
	if "`period'"=="revolutionary_blockade"{
		replace war=1 if period_str=="War 1793-1807" 
		replace war=0 if period_str=="Blockade 1808-1815" 
		}
	
	if "`period'"=="post_blockade"{
		replace war=1 if period_str=="Blockade 1808-1815" 
		replace war=0 if period_str=="Peace 1816-1840" 
		}


	levelsof exportsimports, local(levels)

	foreach i of local levels{
		
		preserve

		keep if exportsimports=="`i'"
		keep if war!=.
		collapse (sum) value, by(year product_sitc_simplen war)

		bysort year war: egen total=sum(value)
		gen percent= value/total
		gen ln_percent=ln(percent)

		encode product_sitc_simplen, gen(product_sitc_num)
		egen year_war = group(year war), label
	
		drop value percent product_sitc_simplen year
	
		reshape wide ln_percent, i(year_war) j(product_sitc_num)
		
		di "***************************`i' `period'**************************************"
		hotelling ln_percent1-ln_percent12, by(war)
		reg war ln_percent1-ln_percent12, robust
		
		restore
		
	}
	drop war
end

composition_trade_test peace_war
composition_trade_test pre_seven
composition_trade_test post_seven
composition_trade_test pre_independence
composition_trade_test post_independence
composition_trade_test pre_revolutionary
composition_trade_test revolutionary_blockade
composition_trade_test post_blockade

 
