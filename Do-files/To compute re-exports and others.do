*capture ssc install vioplot
*capture ssc install outtable
*capture ssc install estout

if "`c(username)'"=="guillaumedaudin" ///
		global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
		global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
		global toflit18_stata "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata"

if "`c(username)'" =="Tirindelli" {
	global hamburg "/Volumes/GoogleDrive/My Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Desktop/HamburgPaper"
	global toflit18_stata "/Volumes/GoogleDrive/My Drive/Hamburg/Données Stata"
}

if "`c(username)'" =="tirindee" {
	global hamburg "G:\Il mio Drive\Hamburg"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


/*
**Do a db of reexports share
use "$toflit18_stata/bdd courante.dta", clear
gen reexports = value if product_reexportations=="Réexportation" & export_import=="Exports" & best_guess_national_prodxpart==1
gen OM_imports = value if (partner_grouping=="Outre-mers" | partner_grouping=="Asie"  | partner_grouping=="Afrique" | partner_grouping=="Amériques") ///
	& export_import=="Imports" & best_guess_national_partner==1
	
	
collapse (sum) reexports OM_imports (max) best_guess_national_prodxpart best_guess_national_partner, by(year)
replace reexports=. if best_guess_national_prodxpart!=1
replace OM_imports=. if best_guess_national_partner!=1

graph twoway (connected reexports year) (connected OM_imports year)

gen reexport_share = reexports/OM_imports
graph twoway (connected reexport_share year)

save "$hamburg/database_dta/National Reexports", replace
*/
**Do a db of reexports share by port
use "$toflit18_stata/bdd courante.dta", clear
keep if best_guess_region_prodxpart==1
gen reexports_local = value if product_reexportations=="Réexportation" & export_import=="Exports"
gen OM_imports_local = value if (partner_grouping=="Outre-mers" | partner_grouping=="Asie"  | partner_grouping=="Afrique" | partner_grouping=="Amériques") ///
	& export_import=="Imports"
	

collapse (sum) reexports_local OM_imports_local, by(year customs_region_grouping)	
drop if reexports_local==0 | OM_imports_local==0
gen reexport_share_local = reexports_local/OM_imports_local


****Merge them to get a weight
merge m:1 year using "$hamburg/database_dta/National Reexports"
gen weight = OM_imports_local/OM_imports
drop _merge

drop if year >=1783 | year==1714 | customs_region_grouping==""

encode customs_region_grouping, gen(customs_region_grouping_num)
gen ln_reexport_share_local=ln(reexport_share_local)

regress ln_reexport_share_local i.year i.customs_region_grouping_num if year <=1782 /*[iweight=weight]*/

fillin year customs_region_grouping_num
keep if customs_region_grouping_num==2


predict ln_reexport_predict

***Re-merge them to compare
merge m:1 year using "$hamburg/database_dta/National Reexports"
drop _merge
drop if year >=1783 | year==1714 | customs_region_grouping_num==.


gen reexport_predict=exp(ln_reexport_predict)

corr reexport_predict reexport_share

graph twoway (connect reexport_share year if year <=1782) (connect reexport_predict year if year <=1782)

reg reexport_share reexport_predict, noconstant
predict reexport_nat_share_predict
graph twoway (connect reexport_share year if year <=1782) (connect reexport_predict year if year <=1782) (connect reexport_nat_share_predict year if year <=1782)

keep year  reexport_nat_share_predict

***Re-merge for final computations
merge m:1 year using "$hamburg/database_dta/National Reexports"
drop _merge
sort year

generate imputed_reexports=1 if OM_imports*reexport_nat_share_predict!=. & reexports==.
replace reexports=OM_imports*reexport_nat_share_predict if reexports==.
replace imputed_reexports=reexports if imputed_reexports==1


gen period_str=""
replace period_str ="Peace 1749-1755" if year >= 1749 & year <=1755
replace period_str ="War 1756-1763" if year   >= 1756 & year <=1763
replace period_str ="Peace 1764-1777" if year >= 1764 & year <=1777
replace period_str ="War 1778-1783" if year   >= 1778 & year <=1783
replace period_str ="Peace 1784-1792" if year >= 1784 & year <=1792 
replace period_str ="War 1793-1807" if year   >= 1793 & year <=1807
replace period_str ="Blockade 1808-1815" if year   >= 1808 & year <=1815
replace period_str ="Peace 1816-1840" if year >= 1816

gen war=0
replace war=1 if year   >= 1744 & year <=1748 | year   >= 1756 & year <=1763 | year   >= 1778 & year <=1783 | year   >= 1793 & year <=1801 | year   >= 1803 & year <=1815

gen war1=4.3e+08 if year >=1744 & year<=1748
gen war2=4.3e+08 if year >=1756 & year<=1762
gen war3=4.3e+08 if year >=1778 & year<=1782
gen war4=4.3e+08 if year >=1793 & year<=1803
gen war5=4.3e+08 if year >=1804 & year<=1808
gen blockade=4.3e+08 if year >=1808 & year<=1814


graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) ///
			 (area war4 year, color(gs9)) (area war5 year, color(gs9)) ///
			 (area blockade year, color(gs18)) ///
			 (connected reexports year, msize(tiny) lcolor(red) mcolor(red)) ///
			 (connected imputed_reexports year, msize(tiny) cmissing(n) lcolor(green) mcolor(green)) ///
			 (connected OM_imports year, msize(tiny) lcolor(blue) mcolor(blue)), ///
			 legend(order (9 7 8) label(9 "Colonial imports") label(7 "Colonial re-exports") label(8 "Imputed colonial re-exports")) ///
			 scheme(s1color)
			 



