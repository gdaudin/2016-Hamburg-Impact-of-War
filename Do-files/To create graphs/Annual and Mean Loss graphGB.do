version 18

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\tirindee\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
}



set more off

clear

use "$hamburg/database_dta/Total silver trade FR GB.dta", clear

replace log10_valueST_silverEN = log10_valueST_silverGB if log10_valueST_silverEN==.
replace log10_valueST_silverEN = log10_valueST_silver_tena if log10_valueST_silverEN==.

rename log10_valueST_silverEN ln_value

keep ln_value year wara-blockade

gen period_str=""
replace period_str ="Peace 1716-1744" if year <= 1744
replace period_str ="War 1745-1748" if year   >= 1745 & year <=1748
replace period_str ="Peace 1749-1755" if year >= 1749 & year <=1755
replace period_str ="War 1756-1763" if year   >= 1756 & year <=1763
replace period_str ="Peace 1763-1777" if year >= 1763 & year <=1777
replace period_str ="War 1778-1783" if year   >= 1778 & year <=1783
replace period_str ="Peace 1784-1792" if year >= 1784 & year <=1792
replace period_str ="War 1793-1807" if year   >= 1793 & year <=1807
replace period_str ="Blockade 1808-1815" if year   >= 1808 & year <=1815
replace period_str ="Peace 1816-1840" if year >= 1816

encode period_str, gen(period)
keep if year >= 1716

gen war = 1
replace war = 0 if year <= 1744 | (year >= 1749 & year <=1755) | (year >= 1763 & year <=1777) | (year >= 1784 & year <=1792) | year >=1816

reg ln_value year if year <= 1744 & war==0
predict ln_value_peace1

reg ln_value year if year <=1755 & war==0
predict ln_value_peace1_2
reg ln_value year if year <=1777  & war==0
predict ln_value_peace1_3
reg ln_value year if year <=1792  & war==0
predict ln_value_peace1_4
reg ln_value year if war==0
predict ln_value_peace_all


reg ln_value year if (year >= 1749 & year <=1755) & war==0
predict ln_value_peace2
reg ln_value year if (year >= 1763 & year <=1777) & war==0
predict ln_value_peace3
reg ln_value year if (year >= 1784 & year <=1792) & war==0
predict ln_value_peace4

		
gen     loss_war = 1-(exp(ln_value)/exp(ln_value_peace1)) 	 if year >=1745 & year <=1755
replace loss_war = 1-(exp(ln_value)/exp(ln_value_peace1_2)) if year >=1756 & year <=1777
replace loss_war = 1-(exp(ln_value)/exp(ln_value_peace1_3)) if year >=1778 & year <=1792
replace loss_war = 1-(exp(ln_value)/exp(ln_value_peace1_4)) if year >=1793
replace loss_war=. if ln_value==.

gen     loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace1)) if year >=1745 & year <=1755
replace loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace2)) if year >=1756 & year <=1777
replace loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace3)) if year >=1778 & year <=1792
replace loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace4)) if year >=1793
replace loss_war_nomemory =. if ln_value==.


replace war1=1 if war1!=.
replace war2=1 if war2!=.
replace war3=1 if war3!=.
replace war4=1 if war4!=.
replace war5=1 if war5!=.
replace blockade=1 if blockade!=.
gen minwar1=-0.2 if war1!=.
gen minwar2=-0.2 if war2!=.
gen minwar3=-0.2 if war3!=.
gen minwar4=-0.2 if war4!=.
gen minwar5=-0.2 if war5!=.
gen minblockade=-0.2 if blockade!=.
keep if year >=1740

graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
			 (connected loss_war year, cmissing(n) lcolor(black) mcolor(black) ///
			 msize(vsmall) lpattern(dash)) ///
			 (connected loss_war_nomemory year, cmissing(n) lpattern(solid) lcolor(red) mcolor(red) msize(vsmall)), ///
			 legend(order (13 14) label(13 "Using all past peace periods for the peace trend") ///
			 label(14 "Using the preceeding peace period for the peace trend") rows(2)) ///
			 ylabel(-0.2 (0.2) 1) ytitle("1-(predicted trade based on peace trend/actual trade)", size(small)) ///
			 yline(0, lwidth(medium) lcolor(gray)) name("GB_annual_loss", replace) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) xtitle("") scheme(stsj)
 
graph export "$hamburggit/Results/Loss graphs/GBAnnual_loss_function.png", replace
graph export "$hamburggit/Paper - Impact of War/Paper/GBAnnual_loss_function.png", replace



egen loss_war1		=mean(loss_war) if year >=1745 & year <=1748
egen loss_peace1	=mean(loss_war) if year >=1749 & year <=1755
egen loss_war2		=mean(loss_war) if year >=1756 & year <=1762
egen loss_peace2	=mean(loss_war) if year >=1763 & year <=1777
egen loss_war3		=mean(loss_war) if year >=1778 & year <=1783
egen loss_peace3	=mean(loss_war) if year >=1784 & year <=1792
egen loss_war4		=mean(loss_war) if year >=1793 & year <=1807
egen loss_blockade	=mean(loss_war) if year >=1808 & year <=1815
egen loss_peace4	=mean(loss_war) if year >=1816

egen loss = rmax(loss_war1 loss_war2 loss_war3 loss_war4 loss_peace1 loss_peace2 loss_peace3 loss_peace4 loss_blockade)

graph twoway (area loss year) (line loss_war year), scheme(stsj)



egen loss_war_nomemory1		=mean(loss_war_nomemory) if year >=1745 & year <=1748
egen loss_peace_nomemory1	=mean(loss_war_nomemory) if year >=1749 & year <=1755
egen loss_war_nomemory2		=mean(loss_war_nomemory) if year >=1756 & year <=1762
egen loss_peace_nomemory2	=mean(loss_war_nomemory) if year >=1763 & year <=1777
egen loss_war_nomemory3		=mean(loss_war_nomemory) if year >=1778 & year <=1783
egen loss_peace_nomemory3	=mean(loss_war_nomemory) if year >=1784 & year <=1792
egen loss_war_nomemory4		=mean(loss_war_nomemory) if year >=1793 & year <=1807
egen loss_blockade_nomemory	=mean(loss_war_nomemory) if year >=1808 & year <=1815
egen loss_peace_nomemory4	=mean(loss_war_nomemory) if year >=1816

egen loss_nomemory = rmax(loss_war_nomemory1 loss_war_nomemory2 loss_war_nomemory3 loss_war_nomemory4 ///
			loss_peace_nomemory1 loss_peace_nomemory2 loss_peace_nomemory3 loss_peace_nomemory4 ///
			loss_blockade_nomemory)

graph twoway (area loss_nomemory year), scheme(stsj)

graph twoway 	(area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
				(area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
				(area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
				(area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
				(area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
				(area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
				(line loss year, lpattern(dash) lcolor(black)) ///
				(line loss_nomemory year,lpattern(solid) lcolor(red)) ///
				,plotregion(fcolor(white)) graphregion(fcolor(white)) ///
				legend(order (13 14) label(13 "Using all past peace periods for the peace trend") ///
				label(14 "Using the preceeding peace period for the peace trend") rows(2)) ///
				yline(0, lwidth(medium) lcolor(gray)) ///
				ytitle("1-(predicted trade based on peace trend/actual trade)", size(small)) ///
				ylabel(-0.2 (0.2) 1) name("GB_mean_loss", replace) xtitle("") scheme(stsj)
graph export "$hamburggit/Results/Loss graphs/GBMean_loss_function.png", replace
graph export "$hamburggit//Paper - Impact of War/Paper/GBMean_loss_function.png", replace


/*
grc1leg GB_mean_loss GB_annual_loss, cols(1) xcommon ycommon ///
		name(XI, replace) legendfrom(GB_mean_loss) pos(5) ///
		plotregion(fcolor(white)) graphregion(fcolor(white)) ///
		l1(Loss)
graph export "$hamburggit/Paper - Impact of War/Paper/Loss graphs/GBLoss_function.pdf", replace
*/
