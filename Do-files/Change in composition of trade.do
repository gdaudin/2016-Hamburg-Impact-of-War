
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

gen war = 1
replace war = 0 if year <= 1744 | (year >= 1749 & year <=1755) | ///
		(year >= 1763 & year <=1777) | (year >= 1784 & year <=1792) | year >=1816
drop if product_sitc_simplen == "Precious metals"

label define peacewar 0 "Peace" 1 "War"
label value war peacewar

collapse (sum) value, by(year product_sitc_simplen war exportsimports)
drop if product_sitc_simplen==""
graph 	pie value if exportsimports=="Exports", over(product_sitc_simplen) ///
		plabel(_all name, size(*0.7) color(white)) ///
		by(war, legend(off) plotregion(fcolor(white)) graphregion(fcolor(white))) 
		
graph export "$hamburggit/Paper - Impact of War/Paper/warpeace_composition_X.pdf", replace

graph 	pie value if exportsimports=="Imports", over(product_sitc_simplen) ///
		plabel(_all name, size(*0.7) color(white)) ///
		by(war, legend(off) plotregion(fcolor(white)) graphregion(fcolor(white))) 
		
graph export "$hamburggit/Paper - Impact of War/Paper/warpeace_composition_I.pdf", replace



preserve

drop if exportsimports=="Exports"

collapse (sum) value, by(year product_sitc_simplen war)

bysort year war: egen total=sum(value)
gen percent= value/total
gen ln_percent=ln(percent)

encode product_sitc_simplen, gen(product_sitc_num)
egen sitc_war = group(product_sitc_num war), label
 
vioplot ln_percent, over(sitc_war) hor ylabel(,angle(0) labsize(small) ///
		plotregion(fcolor(white)) graphregion(fcolor(white))
		
restore
