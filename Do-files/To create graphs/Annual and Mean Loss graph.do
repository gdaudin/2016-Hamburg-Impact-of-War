


*global hamburg "/Users/Tirindelli/Google Drive/Hamburg"

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "/Users/guillaumedaudin/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\tirindee\Google Drive\ETE/Thesis/Data/do_files/Hamburg/"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg/"
}


use "$hamburg/database_dta/Total silver trade FR GB.dta", clear




gen ln_value=ln(valueFR_silver)



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

reg ln_value i.period#c.year i.period year

foreach per of num 1/10 {
	gen log10_value_period`per'=log10_valueFR_silver if period==`per'
}



/*
graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (lfit log10_value_period1 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_period2 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_period3 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_period4 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_period5 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_period6 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_period7 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_period8 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_period9 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_period10 year, lpattern(line) lcolor(black)), ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 legend (off) ytitle("Time trends of French trade in tons of silver, log10") xtitle("Year: Mercantilist and R&N wars") 

graph export "$hamburggit/Paper - Impact of War/Paper/Time trends of French trade - with blockade.png", as(png) replace
*/

************Now to compute the losses
keep if year >= 1716

gen war = 1
replace war = 0 if year <= 1744 | (year >= 1749 & year <=1755) | (year >= 1763 & year <=1777) | (year >= 1784 & year <=1792) | year >=1816

reg ln_value year if year <= 1744 & war==0
predict ln_value_peace1

reg ln_value year if year <=1755 & war==0
predict ln_value_peace1_2
reg ln_value year if year <=1777  & war==0
predict ln_value_peace1_3
reg ln_value year if year <=1791  & war==0
predict ln_value_peace1_4
reg ln_value year if war==0
predict ln_value_peace_all


reg ln_value year if (year >= 1749 & year <=1755) & war==0
predict ln_value_peace2
reg ln_value year if (year >= 1763 & year <=1777) & war==0
predict ln_value_peace3
reg ln_value year if (year >= 1784 & year <=1791) & war==0
predict ln_value_peace4


*twoway (line ln_value_peace1 year) (line ln_value_peace1_2 year) (line ln_value_peace1_3 year) (line ln_value_peace1_4 year) (line ln_value_peace_all year) ///
*		(line ln_value year)
		
gen     loss = 1-(valueFR_silver/exp(ln_value_peace1)) 	if year >=1745 & year <=1755
replace loss = 1-(valueFR_silver/exp(ln_value_peace1_2)) if year >=1756 & year <=1777
replace loss = 1-(valueFR_silver/exp(ln_value_peace1_3)) if year >=1778 & year <=1792
replace loss = 1-(valueFR_silver/exp(ln_value_peace1_4)) if year >=1793
replace loss =. if ln_value==.

gen     loss_nomemory  = 1-(valueFR_silver/exp(ln_value_peace1)) if year >=1745 & year <=1755
replace loss_nomemory  = 1-(valueFR_silver/exp(ln_value_peace2)) if year >=1756 & year <=1777
replace loss_nomemory  = 1-(valueFR_silver/exp(ln_value_peace3)) if year >=1778 & year <=1792
replace loss_nomemory  = 1-(valueFR_silver/exp(ln_value_peace4)) if year >=1793
replace loss_nomemory  =. if ln_value==.



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
			 (connected loss year, cmissing(n) lcolor(black) mcolor(black) msize(vsmall) lpattern(dash)) ///
			 (connected loss_nomemory  year, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 , ///
			 legend(order (13 14) label(13 "Using all past peace periods for the peace trend") label(14 "Using the preceeding peace period for the peace trend") rows(2)) ///
			 ytitle("1-(predicted trade base on peace trend)/(actual trade)", size(small)) ylabel(-0.2 (0.2) 1) ///
			 yline(0, lwidth(medium) lcolor(grey)) xtitle("") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white))
 
graph export "$hamburggit/Paper - Impact of War/Paper/Annual_loss_function.png", as(png) replace


************* Pour les graphiques avec les dépenses britanniques


merge 1:1 year using "$hamburg/database_dta/MitchellGBPublicFinance.dta" 

gen     loss_abs = log10(valueFR_silver*loss/(1-loss)) if loss > 0
*replace loss_abs = -log10(-valueFR_silver*loss/(1-loss)) if loss < 0
replace loss_abs=. if valueFR_silver==.



gen     loss_nm_abs = log10(valueFR_silver*loss_nomemory/(1-loss_nomemory)) if loss_nomemory > 0
*replace loss_nm_abs = -log10(-valueFR_silver*loss_nomemory/(1-loss_nomemory)) if loss_nomemory < 0
replace loss_nm_abs=. if ln_value==.


replace war1=4 if war1!=.
replace war2=4 if war2!=.
replace war3=4 if war3!=.
replace war4=4 if war4!=.
replace war5=4 if war5!=.
replace blockade=4 if blockade!=.
replace minwar1=1 if war1!=.
replace minwar2=1 if war2!=.
replace minwar3=1 if war3!=.
replace minwar4=1 if war4!=.
replace minwar5=1 if war5!=.
replace minblockade=1 if blockade!=.
keep if year >=1740




graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
			 (connected loss_abs year, cmissing(n) lcolor(black) mcolor(black) msize(vsmall) lpattern(dash)) ///
			 (connected loss_nm_abs year, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 (line NavyGross year, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ ) ///
			 (line NavyNet year, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ lpattern(dash)), ///
			 legend(order (13 14 16 15) label(13 "Using all past peace periods for the peace trend") ///
			 label(14 "Using the preceeding peace period for the peace trend") ///
			 label(15 "Gross Royal Navy expenditures") label(16 "Net Royal Navy expenditures")   rows(4)) ///
			 ytitle("Tons of silver, log10", size(small)) ylabel(1 (1) 4) ///
			 /*yline(0, lwidth(medium) lcolor(grey))*/ xtitle("") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white))



replace loss_abs=10^loss_abs
replace loss_abs = valueFR_silver*loss/(1-loss) if loss < 0
replace loss_nm_abs = 10^loss_nm_abs
replace loss_nm_abs = valueFR_silver*loss_nomemory/(1-loss_nomemory) if loss_nomemory < 0


replace war1=10000 if war1!=.
replace war2=10000 if war2!=.
replace war3=10000 if war3!=.
replace war4=10000 if war4!=.
replace war5=10000 if war5!=.
replace blockade=10000 if blockade!=.
replace minwar1=0 if war1!=.
replace minwar2=0 if war2!=.
replace minwar3=0 if war3!=.
replace minwar4=0 if war4!=.
replace minwar5=0 if war5!=.
replace minblockade=0 if blockade!=.
keep if year >=1740




replace NavyGross=10^NavyGross
replace NavyNet=10^NavyNet			 

graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
			 (connected loss_abs year if year <=1825, cmissing(n) lcolor(black) mcolor(black) msize(vsmall) lpattern(dash) ) ///
			 (connected loss_nm_abs year if year <=1825, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 (line NavyGross year if year <=1825, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ ) ///
			 (line NavyNet year if year <=1825, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ lpattern(dash)), ///
			 legend(order (13 14 16 15) label(13 "Using all past peace periods for the peace trend") ///
			 label(14 "Using the preceeding peace period for the peace trend") ///
			 label(15 "Gross Royal Navy expenditures") label(16 "Net Royal Navy expenditures")   rows(4)) ///
			 ytitle("Tons of silver", size(small)) /*ylabel(1 (1) 4)*/ ///
			 /*yline(0, lwidth(medium) lcolor(grey))*/ xtitle("") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white))

			 

graph export "$hamburggit/Paper - Impact of War/Paper/BR_Expenditures_Annual_Loss.png", as(png) replace

generate loss_abs_cum    = log10(sum(loss_abs))
generate loss_nm_abs_cum = log10(sum(loss_nm_abs))
generate Navy_Net_cum    = sum(NavyNet)
replace Navy_Net_cum = Navy_Net_cum + (1229+1428)/2 if year >=1800
generate Navy_Gross_cum  = sum(NavyGross)
generate Navy_cum=log10(Navy_Gross_cum+Navy_Net_cum)


replace war1=6 if war1!=.
replace war2=6 if war2!=.
replace war3=6 if war3!=.
replace war4=6 if war4!=.
replace war5=6 if war5!=.
replace blockade=6 if blockade!=.
replace minwar1=2 if war1!=.
replace minwar2=2 if war2!=.
replace minwar3=2 if war3!=.
replace minwar4=2 if war4!=.
replace minwar5=2 if war5!=.
replace minblockade=2 if blockade!=.


graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
		(connected loss_abs_cum year if year <=1825, cmissing(n) lcolor(black) mcolor(black) msize(vsmall) lpattern(dash) ) ///
			 (connected loss_nm_abs_cum year if year <=1825, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 (line Navy_cum year if year <=1825, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ ), ///
			 legend(order (13 14 15) label(13 "Using all past peace periods for the peace trend") ///
			 label(14 "Using the preceeding peace period for the peace trend") ///
			 label(15 "Royal Navy expenditures")  rows(3)) ///
			 ytitle("Tons of silver", size(small)) /*ylabel(1 (1) 4)*/ ///
			 /*yline(0, lwidth(medium) lcolor(grey))*/ xtitle("") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white))


			 
generate ratio_abs    = 10^loss_abs_cum/10^Navy_cum
generate ratio_nm_abs = 10^loss_nm_abs_cum/10^Navy_cum


replace war1=4 if war1!=.
replace war2=4 if war2!=.
replace war3=4 if war3!=.
replace war4=4 if war4!=.
replace war5=4 if war5!=.
replace blockade=4 if blockade!=.


graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
			 (connected ratio_abs year if year <=1825, cmissing(n) lcolor(black) mcolor(black) msize(vsmall) lpattern(dash) ) ///
			 (connected ratio_nm_abs year if year <=1825, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)), ///
			 legend(order (13 14) label(13 "Using all past peace periods for the peace trend") ///
			 label(14 "Using the preceeding peace period for the peace trend") rows(2)) ///
			 ytitle("Ratio between cumulated French trade losses" "and the cumulated Navy budget", size(small)) /*ylabel(1 (1) 4)*/ ///
			 /*yline(0, lwidth(medium) lcolor(grey))*/ xtitle("") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white))		 
			 
			
graph export "$hamburggit/Paper - Impact of War/Paper/Ratio_BR_Expenditures_Annual_Loss.png", as(png) replace

*********************Travail sur les moyennes
			 
egen loss_war1		=mean(loss) if year >=1745 & year <=1748
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



egen loss_war_nomemory1		=mean(loss_nomemory) if year >=1745 & year <=1748
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
keep if year >=1740


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
				ytitle("Mean loss by war or peace period") yline(0, lwidth(medium) lcolor(grey)) ///
				ylabel(-0.2 (0.2) 1) xtitle("")

graph export "$hamburggit/Paper - Impact of War/Paper/Mean_loss_function.png", as(png) replace








