


*global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hamburg/"
	global hamburggit "~/Documents/Recherche/2016 Hamburg/2016-Hamburg-Impact-of-War"
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




gen ln_value=ln(valueFR)

reg ln_value year if year <= 1744
reg ln_value year if year >= 1749 & year <=1755
reg ln_value year if year >= 1763 & year <=1777
reg ln_value year if year >= 1784 & year <=1792
reg ln_value year if year >= 1816

gen period_str=""

replace period_str ="Peace 1716-1744" if year <= 1744
replace period_str ="War 1745-1748" if year   >= 1745 & year <=1748
replace period_str ="Peace 1749-1755" if year >= 1749 & year <=1755
replace period_str ="War 1756-1763" if year   >= 1756 & year <=1763
replace period_str ="Peace 1763-1777" if year >= 1763 & year <=1777
replace period_str ="War 1778-1783" if year   >= 1778 & year <=1783
replace period_str ="Peace 1784-1792" if year >= 1784 & year <=1792
replace period_str ="War 1793-1815" if year   >= 1793 & year <=1815
*replace period_str ="Blockade 1808-1815" if year   >= 1808 & year <=1815
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
			 , ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 legend (off) ytitle("Time trends of French trade in tons of silver, log10") xtitle("Year: Mercantilist and R&N wars") 

graph export "$hamburggit/tex/Paper/Time trends of French trade.png", as(png) replace













