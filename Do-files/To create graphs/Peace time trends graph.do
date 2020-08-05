


*global hamburg "/Users/Tirindelli/Google Drive/Hamburg"

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hamburg/"
	global hamburggit "~/Documents/Recherche/2016 Hamburg/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="TIRINDEE" {
	global hamburg "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg/"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg/"
}


use "$hamburg/database_dta/Total silver trade FR GB.dta", clear





gen ln_value=ln(valueFR)

reg ln_value year if year <= 1744
reg ln_value year if year >= 1749 & year <=1755
reg ln_value year if year >= 1763 & year <=1777
reg ln_value year if year >= 1784 & year <=1792
reg ln_value year if year >= 1816

gen peace_str=""

replace peace_str ="Peace 1716-1744" if year <= 1744
replace peace_str ="Peace 1749-1755" if year >= 1749 & year <=1755
replace peace_str ="Peace 1763-1777" if year >= 1763 & year <=1777
replace peace_str ="Peace 1784-1792" if year >= 1784 & year <=1792
replace peace_str ="Peace 1816-1840" if year >= 1816

encode peace_str, gen(peace)

reg ln_value i.peace#c.year i.peace year


gen log10_value_peace1=log10_valueFR_silver if year <= 1744
gen log10_value_peace2=log10_valueFR_silver if year >= 1749 & year <=1755
gen log10_value_peace3=log10_valueFR_silver if year >= 1763 & year <=1777
gen log10_value_peace4=log10_valueFR_silver if year >= 1784 & year <=1792
gen log10_value_peace5=log10_valueFR_silver if year >= 1816


graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4)) ///
			 (lfit log10_value_peace1 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_peace2 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_peace3 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_peace4 year, lpattern(line) lcolor(black)) ///
			 (lfit log10_value_peace5 year, lpattern(line) lcolor(black)), ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 legend (off) ytitle("Peace-time trends of French trade in tons of silver, log10") xtitle("Year: Mercantilist and R&N wars") 

graph export "$hamburggit/tex/Paper/Peace-time trends of French trade.png", as(png) replace













