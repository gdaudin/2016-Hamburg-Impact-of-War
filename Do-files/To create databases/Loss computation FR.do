version 18


*global hamburg "/Users/Tirindelli/Google Drive/Hamburg"


if "`c(username)'" =="guillaumedaudin" {
	global hamburg "/Users/guillaumedaudin/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\tirindee\Google Drive\ETE/Thesis/Data/do_files/Hamburg/"
}

if "`c(username)'" =="rober" {
	global hamburg "G:\Il mio Drive\Hamburg"
	global hamburggit "G:\Il mio Drive\Hamburg\Paper"
}

if "`c(username)'" =="Tirindelli" {
	global hamburg "/Volumes/GoogleDrive/My Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Desktop/HamburgPaper"
}


use "$hamburg/database_dta/Total silver trade FR GB.dta", clear

global vardinteret value /*Imports Exports reexports Imports_special Exports_special*/

foreach var of global vardinteret {
	gen ln_`var'=ln(`var'FR_silver)
} 



gen period_str=""

replace period_str ="Peace 1716-1743" if year <= 1743
replace period_str ="War 1744-1748" if year   >= 1744 & year <=1748
replace period_str ="Peace 1749-1755" if year >= 1749 & year <=1755
replace period_str ="War 1756-1763" if year   >= 1756 & year <=1763
replace period_str ="Peace 1763-1777" if year >= 1763 & year <=1777
replace period_str ="War 1778-1783" if year   >= 1778 & year <=1783
replace period_str ="Peace 1784-1792" if year >= 1784 & year <=1792
replace period_str ="War 1793-1807" if year   >= 1793 & year <=1807
replace period_str ="Blockade 1808-1815" if year   >= 1808 & year <=1815
replace period_str ="Peace 1816-1840" if year >= 1816

keep if year >= 1716

gen war = 1
replace war = 0 if year <= 1743 | (year >= 1749 & year <=1755) | (year >= 1763 & year <=1777) | (year >= 1784 & year <=1792) | year >=1816

replace war1=1 if war1!=.
replace war2=1 if war2!=.
replace war3=1 if war3!=.
replace war4=1 if war4!=.
replace war5=1 if war5!=.
replace blockade=1 if blockade!=.
capture drop minwar* minblockade
gen minwar1=-0.2 if war1!=.
gen minwar2=-0.2 if war2!=.
gen minwar3=-0.2 if war3!=.
gen minwar4=-0.2 if war4!=.
gen minwar5=-0.2 if war5!=.
gen minblockade=-0.2 if blockade!=.



encode period_str, gen(period)
foreach var of global vardinteret {
	reg ln_`var' i.period#c.year i.period year
	foreach per of num 1/10 {
		gen log10_`var'_period`per'=log10_`var'FR_silver if period==`per'
	}
/*
graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (lfit log10_`var'_period1 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_`var'_period2 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_`var'_period3 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_`var'_period4 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_`var'_period5 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_`var'_period6 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_`var'_period7 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_`var'_period8 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_`var'_period9 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_`var'_period10 year, lpattern(line) lcolor(black)), ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 legend (off) ///
			 ytitle("Time trends of French trade in tons of silver, log10") ///
			 xtitle("Year: Mercantilist and R&N wars") ///
			 title("`var'")

graph export "$hamburggit/Paper - Impact of War/Paper/Time trends of French trade `var'- with blockade.png", as(png) replace

*/
}

save temp.dta, replace



************Now to compute the losses


foreach var of global vardinteret {
	reg ln_`var' year if year <= 1743 & war==0
	predict ln_`var'_peace1
	reg ln_`var' year if year <=1755 & war==0
	predict ln_`var'_peace1_2
	reg ln_`var' year if year <=1777  & war==0
	predict ln_`var'_peace1_3
	reg ln_`var' year if year <=1791  & war==0
	predict ln_`var'_peace1_4
	reg ln_`var' year if war==0
	predict ln_`var'_peace_all


	reg ln_`var' year if (year >= 1749 & year <=1755) & war==0
	predict ln_`var'_peace2
	reg ln_`var' year if (year >= 1763 & year <=1777) & war==0
	predict ln_`var'_peace3
	reg ln_`var' year if (year >= 1784 & year <=1791) & war==0
	predict ln_`var'_peace4


	*twoway (line ln_value_peace1 year) (line ln_value_peace1_2 year) (line 	ln_value_peace1_3 year) (line ln_value_peace1_4 year) (line ln_value_peace_all year) ///
	*		(line ln_value year)
	capture drop loss	
	capture drop predicted_trade
	
	gen     predicted_trade = exp(ln_`var'_peace1) 	if year >=1744 & year <=1755
	replace predicted_trade = exp(ln_`var'_peace1_2) if year >=1756 & year <=1777
	replace predicted_trade = exp(ln_`var'_peace1_3) if year >=1778 & year <=1792
	replace predicted_trade = exp(ln_`var'_peace1_4) if year >=1793
	replace predicted_trade = . if ln_`var'==.
	replace predicted_trade =. if year <=1743

	gen     loss = 1-(`var'FR_silver/predicted_trade) 	if year >=1744
	replace loss =. if ln_`var'==.
	replace loss=max(-.2,loss)
	replace loss =. if year <=1743
	
	
	capture drop loss_nomemory
	capture drop predicted_trade_nomemory

	gen     predicted_trade_nomemory = exp(ln_`var'_peace1) if year >=1744 & year <=1755
	replace predicted_trade_nomemory = exp(ln_`var'_peace2) if year >=1756 & year <=1777
	replace predicted_trade_nomemory = exp(ln_`var'_peace3) if year >=1778 & year <=1792
	replace predicted_trade_nomemory = exp(ln_`var'_peace4) if year >=1793
	replace predicted_trade_nomemory = . if ln_`var'==.
	replace predicted_trade_nomemory =. if year <=1743


	gen     loss_nomemory  = 1-(`var'FR_silver/predicted_trade_nomemory) if year >=1744
	replace loss_nomemory  =. if ln_`var'==.
	replace loss_nomemory=max(-.2,loss_nomemory)
	replace loss_nomemory  =. if ln_`var'==.
	replace loss_nomemory =. if year <=1743



	replace war1=1 if war1!=.
	replace war2=1 if war2!=.
	replace war3=1 if war3!=.
	replace war4=1 if war4!=.
	replace war5=1 if war5!=.
	replace blockade=1 if blockade!=.
	capture drop minwar* minblockade
	gen minwar1=-0.2 if war1!=.
	gen minwar2=-0.2 if war2!=.
	gen minwar3=-0.2 if war3!=.
	gen minwar4=-0.2 if war4!=.
	gen minwar5=-0.2 if war5!=.
	gen minblockade=-0.2 if blockade!=.
	keep if year >=1741
	export delimited "$hamburg/database_csv/mean_annual_loss `var'.csv", replace
	
	
	if "`var'"=="value" local title "Total trade"
	if "`var'"=="Imports" | "`var'"=="Exports" local title "`var'"
	if "`var'"=="reexports" local title "Reexports"
	if "`var'"=="Imports_special" local title "Special imports"
	if "`var'"=="Exports_special" local title "Special exports"
	

	graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
			 (connected loss year, cmissing(n) lcolor(black) mcolor(black) msize(vsmall) lpattern(dash)) ///
			 (connected loss_nomemory  year, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 , ///
			 legend(order (13 14) label(13 "Using all past peace periods for the peace trend") label(14 "Using the preceeding peace period for the peace trend") rows(2)) ///
			 ytitle("1-(predicted trade based on peace trend)/(actual trade)", size(small)) ylabel(-0.2 (0.2) 1) ///
			 yline(0, lwidth(medium) lcolor(gray)) xtitle("")  ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 title("`title'") scheme(stsj)
 
	graph export "$hamburggit/Paper - Impact of War/Paper/Annual_loss_function `title'.png", as(png) replace


	if "`var'"=="value" {
		save "$hamburg/database_dta/Loss_values.dta", replace	
	}
}

*********************Travail sur les moyennes


use "$hamburg/database_dta/Loss_values.dta", clear
			 
egen loss_war1		=mean(loss) if year >=1744 & year <=1748
egen loss_peace1	=mean(loss) if year >=1749 & year <=1755
egen loss_war2		=mean(loss) if year >=1756 & year <=1762
egen loss_peace2	=mean(loss) if year >=1763 & year <=1777
egen loss_war3		=mean(loss) if year >=1778 & year <=1783
egen loss_peace3	=mean(loss) if year >=1784 & year <=1792
egen loss_war4		=mean(loss) if year >=1793 & year <=1807
egen loss_blockade	=mean(loss) if year >=1808 & year <=1815
egen loss_peace4	=mean(loss) if year >=1816

egen loss_mean = rmax(loss_war1 loss_war2 loss_war3 loss_war4 loss_peace1 loss_peace2 loss_peace3 loss_peace4 loss_blockade)

graph twoway (area loss_mean year) (line loss year)



egen loss_war_nomemory1		=mean(loss_nomemory) if year >=1744 & year <=1748
egen loss_peace_nomemory1	=mean(loss_nomemory) if year >=1749 & year <=1755
egen loss_war_nomemory2		=mean(loss_nomemory) if year >=1756 & year <=1762
egen loss_peace_nomemory2	=mean(loss_nomemory) if year >=1763 & year <=1777
egen loss_war_nomemory3		=mean(loss_nomemory) if year >=1778 & year <=1783
egen loss_peace_nomemory3	=mean(loss_nomemory) if year >=1784 & year <=1792
egen loss_war_nomemory4		=mean(loss_nomemory) if year >=1793 & year <=1807
egen loss_blockade_nomemory	=mean(loss_nomemory) if year >=1808 & year <=1815
egen loss_peace_nomemory4	=mean(loss_nomemory) if year >=1816

egen loss_mean_nomemory = rmax(loss_war_nomemory1 loss_war_nomemory2 loss_war_nomemory3 loss_war_nomemory4 ///
			loss_peace_nomemory1 loss_peace_nomemory2 loss_peace_nomemory3 loss_peace_nomemory4 ///
			loss_blockade_nomemory)

graph twoway (area loss_mean_nomemory year) (line loss_nomemory year)


replace war1=1 if war1!=.
replace war2=1 if war2!=.
replace war3=1 if war3!=.
replace war4=1 if war4!=.
replace war5=1 if war5!=.
replace blockade=1 if blockade!=.
replace minwar1=-0.2 if war1!=.
replace minwar2=-0.2 if war2!=.
replace minwar3=-0.2 if war3!=.
replace minwar4=-0.2 if war4!=.
replace minwar5=-0.2 if war5!=.
replace minblockade=-0.2 if blockade!=.
keep if year >=1741

/*
graph twoway 	(area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
				(area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
				(area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
				(area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
				(area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
				(area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
				(line loss_mean year, lpattern(dash) lcolor(black)) ///
				(line loss_mean_nomemory year,lcolor(red)) ///
				,plotregion(fcolor(white)) graphregion(fcolor(white)) ///
				legend(order (13 14) label(13 "Using all past peace periods for the peace trend") ///
				label(14 "Using the preceeding peace period for the peace trend") rows(2)) ///
				ytitle("Mean loss by war or peace period") yline(0, lwidth(medium) lcolor(gray)) ///
				ylabel(-0.2 (0.2) 1) xtitle("")

graph export "$hamburggit/Paper - Impact of War/Paper/Mean_loss_function.png", as(png) replace
*/


keep year loss loss_nomemory loss_mean loss_mean_nomemory

save "$hamburg/database_dta/FR_loss.dta", replace








