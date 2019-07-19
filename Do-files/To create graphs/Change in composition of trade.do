
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

label define peacewar 0 "Peace" 1 "War"

***************pie chart and violin chart for all war periods***************************

capture program drop composition_trade_graph
program composition_trade_graph
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
		local note "Peace 1749-1755 and Seven Years War"
		}
	
	if "`period'"=="post_seven"{
		replace war=1 if period_str=="War 1756-1763" 
		replace war=0 if period_str=="Peace 1763-1777"
		local note "Seven Years War and Peace 1763-1777"
		}
	
	if "`period'"=="pre_revolutionary"{
		replace war=0 if period_str=="Peace 1763-1777" 
		replace war=1 if period_str=="War 1778-1783" 
		local note "Peace 1763-1777 and Revolutionary War"
		}
	
	if "`period'"=="post_revolutionary"{
		replace war=1 if period_str=="War 1778-1783" 
		replace war=0 if period_str=="Peace 1784-1792" 
		local note "Revolutionary War and Peace 1784-1792"
		}
	
	if "`period'"=="pre_napoleonic"{
		replace war=0 if period_str=="Peace 1784-1792" 
		replace war=1 if period_str=="War 1793-1807" 
		local note "Peace 1784-1792 and Napoleonic War"
		}
	
	if "`period'"=="napoleonic_blockade"{
		replace war=1 if period_str=="War 1793-1807" 
		replace war=0 if period_str=="Blockade 1808-1815" 
		local note "Napoleonic War and Continental Blockade"
		}
	
	if "`period'"=="post_blockade"{
		replace war=1 if period_str=="Blockade 1808-1815" 
		replace war=0 if period_str=="Peace 1816-1840" 
		local note "Continental Blockade and Peace 1816-1840"
		}

	label value war peacewar
			 
	graph 	pie value if exportsimports=="Exports", over(product_sitc_simplen) ///
			plabel(_all name, size(*0.7) color(white)) legend(off) ///
			by(war, legend(off) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			note("Exports")) 
		
	graph export "$hamburggit/Paper - Impact of War/Paper/`period'_composition_X.pdf", replace

	graph 	pie value if exportsimports=="Imports", over(product_sitc_simplen) ///
			plabel(_all name, size(*0.7) color(white)) ///
			by(war, legend(off) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			note("Imports")) 
		
	graph export "$hamburggit/Paper - Impact of War/Paper/`period'_composition_I.pdf", replace

	levelsof exportsimports, local(levels)

	foreach i of local levels{
		
		preserve

		drop if exportsimports!="`i'"
		if exportsimports=="Exports" local name X
		if exportsimports=="Imports" local name I

		collapse (sum) value, by(year product_sitc_simplen war)

		bysort year war: egen total=sum(value)
		gen percent= value/total
		gen ln_percent=ln(percent)

		encode product_sitc_simplen, gen(product_sitc_num)
		egen sitc_war = group(product_sitc_num war), label
 
		gsort - sitc_war
		vioplot ln_percent, over(sitc_war) hor ylabel(,angle(0) labsize(vsmall)) ///
				plotregion(fcolor(white)) graphregion(fcolor(white)) ///
				title("`i'") note(`note')
		
		graph export "$hamburggit/Paper - Impact of War/Paper/`period'_distribution_`name'.pdf", replace
		restore
	}
	
	drop war

end

composition_trade_graph peace_war
composition_trade_graph pre_seven
composition_trade_graph post_seven
composition_trade_graph pre_revolutionary
composition_trade_graph post_revolutionary
composition_trade_graph pre_napoleonic
composition_trade_graph napoleonic_blockade
composition_trade_graph post_blockade

