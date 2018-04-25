


*global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "/Users/guillaumedaudin/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="TIRINDEE" {
	global hamburg "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg/"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "\Users\Tirindelli\Google Drive\ETE/Thesis"
	global hamburggit "\Users\Tirindelli\Google Drive\ETE/Thesis/Data/do_files/Hamburg/"
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




graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4)) ///
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

graph export "$hamburggit/Impact of War/Paper/Time trends of French trade - with blockade.png", as(png) replace


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


*twoway (line ln_value_peace1 year) (line ln_value_peace1_2 year) (line ln_value_peace1_3 year) (line ln_value_peace1_4 year) (line ln_value_peace_all year) ///
*		(line ln_value year)
		
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
keep if year >=1740

graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4)) ///
			 (connected loss_war year, cmissing(n) lcolor(black) mcolor(black) msize(vsmall) lpattern(dash)) ///
			 (connected loss_war_nomemory year, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 , ///
			 legend(order (6 7) label(6 "Using all past peace periods for the peace trend") label(7 "Using the preceeding peace period for the peace trend") rows(2)) ///
			 ytitle("1-(predicted trade base on peace trend)/(actual trade)", size(small)) ylabel(-0.2 (0.2) 1) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white))

graph export "$hamburggit/Impact of War/Paper/Annual loss function.png", as(png) replace
			 
			 
egen loss_war1=mean(loss_war) if year >=1745 & year <=1748
egen loss_peace1=mean(loss_war) if year >=1749 & year <=1755
egen loss_war2=mean(loss_war) if year >=1756 & year <=1762
egen loss_peace2=mean(loss_war) if year >=1763 & year <=1777
egen loss_war3=mean(loss_war) if year >=1778 & year <=1783
egen loss_peace3=mean(loss_war) if year >=1784 & year <=1792
egen loss_war4=mean(loss_war) if year >=1793 & year <=1815
egen loss_peace4=mean(loss_war) if year >=1816

egen loss = rmax(loss_war1 loss_war2 loss_war3 loss_war4 loss_peace1 loss_peace2 loss_peace3 loss_peace4)

graph twoway (area loss year)

egen loss_war_nomemory1=mean(loss_war_nomemory) if year >=1745 & year <=1748
egen loss_peace_nomemory1=mean(loss_war_nomemory) if year >=1749 & year <=1755
egen loss_war_nomemory2=mean(loss_war_nomemory) if year >=1756 & year <=1762
egen loss_peace_nomemory2=mean(loss_war_nomemory) if year >=1763 & year <=1777
egen loss_war_nomemory3=mean(loss_war_nomemory) if year >=1778 & year <=1783
egen loss_peace_nomemory3=mean(loss_war_nomemory) if year >=1784 & year <=1792
egen loss_war_nomemory4=mean(loss_war_nomemory) if year >=1793 & year <=1815
egen loss_peace_nomemory4=mean(loss_war_nomemory) if year >=1816

egen loss_nomemory = rmax(loss_war_nomemory1 loss_war_nomemory2 loss_war_nomemory3 loss_war_nomemory4 loss_peace_nomemory1 loss_peace_nomemory2 loss_peace_nomemory3 loss_peace_nomemory4)

graph twoway (area loss_nomemory year)

graph twoway (line loss year, lpattern(dash) lcolor(black)) (line loss_nomemory year,lcolor(red)), plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	 legend(order (1 2) label(1 "Using all past peace periods for the peace trend") label(2 "Using the preceeding peace period for the peace trend") rows(2)) ///
	  ytitle("Mean loss by war or peace period")

graph export "$hamburggit/Impact of War/Paper/Mean loss function.png", as(png) replace
















