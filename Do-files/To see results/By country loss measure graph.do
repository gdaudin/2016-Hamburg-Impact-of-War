


if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\tirindee\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}



set more off




capture program drop loss_function
program loss_function
args inorout country_of_interest

*Exemple : loss_function  Exports all
*Exemple : loss_function  XI Allemagne

clear

local explained_variable "lnvalue" 


use "$hamburg/database_dta/Best guess FR bilateral trade.dta", clear

if "`country_of_interest'"!="all" & "`country_of_interest'"!="all_ss_outremer" keep if ustrpos("`country_of_interest'",grouping_classification)!=0
if "`country_of_interest'"=="all_ss_outremer" drop if grouping_classification=="Outre-mers"


collapse (sum) valueFR_silver, by(year exportsimports grouping_classification)
rename valueFR_silver value



encode grouping_classification, gen(pays)

tab pays

merge m:1 grouping_classification year using "$hamburg/database_dta/WarAndPeace.dta"
drop if _merge==2
drop _merge


**Pour les périodes de paix

*replace war_status = "Peace" if war_status==""




if "`inorout'"=="XI" {
	order exportsimports value
	collapse (sum) value, by(year grouping_classification pays war_status)
	gen exportsimports="XI"
}


keep if exportsimports=="`inorout'"



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

local maxvalue 4.5

generate wara		=`maxvalue' if year >=1733 & year <=1738 
generate warb		=`maxvalue' if year >=1740 & year <=1744
generate war1		=`maxvalue' if year >=1744 & year <=1748
generate war2		=`maxvalue' if year >=1756 & year <=1763
generate war3		=`maxvalue' if year >=1778 & year <=1783
generate war4		=`maxvalue' if year >=1793 & year <=1802
generate war5		=`maxvalue' if year >=1803 & year <=1807
generate blockade	=`maxvalue' if year >=1807 & year <=1815

drop if grouping_classification=="Flandre et autres états de l'Empereur" & year >= 1795
drop if grouping_classification=="Hollande" & year >= 1815

*********Fin préparation des données


order value grouping_classification pays war_status
if "`country_of_interest'"=="all"  {
	collapse (sum) value, by(year-war5 blockade)
	gen grouping_classification ="All"
}

if "`country_of_interest'"=="all_ss_outremer"  {
	collapse (sum) value, by(year-war5 blockade)
	gen grouping_classification ="All_ss_outremer"
}






gen ln_value=ln(value)
*replace ln_value=ln(14169) if value==0
*replace ln_value=ln(0.00000001) if value==0



if "`country_of_interest'"!="États-Unis d'Amérique" {
	reg ln_value year if year <= 1744 & war==0
	predict ln_value_peace1
	reg ln_value year if year <=1755 & war==0
	predict ln_value_peace1_2
	reg ln_value year if year <=1777  & war==0
	predict ln_value_peace1_3
}
reg ln_value year if year <=1792  & war==0
predict ln_value_peace1_4
*reg ln_value year if war==0
*predict ln_value_peace_all

if "`country_of_interest'"!="États-Unis d'Amérique" {
	reg ln_value year if (year >= 1749 & year <=1755) & war==0
	predict ln_value_peace2
	reg ln_value year if (year >= 1763 & year <=1777) & war==0
	predict ln_value_peace3
}
reg ln_value year if (year >= 1784 & year <=1792) & war==0
predict ln_value_peace4



*twoway (line ln_value_peace1 year) (line ln_value_peace1_2 year) (line ln_value_peace1_3 year) (line ln_value_peace1_4 year) (line ln_value_peace_all year) ///
*		(line ln_value year)

gen loss_war = .
if "`country_of_interest'"!="États-Unis d'Amérique" {		
	replace loss_war = 1-(exp(ln_value)/exp(ln_value_peace1)) 	 if year >=1745 & year <=1755
	replace loss_war = 1-(exp(ln_value)/exp(ln_value_peace1_2)) if year >=1756 & year <=1777
	replace loss_war = 1-(exp(ln_value)/exp(ln_value_peace1_3)) if year >=1778 & year <=1792
}
replace loss_war = 1-(exp(ln_value)/exp(ln_value_peace1_4)) if year >=1793
replace loss_war = 1 if value==0


gen loss_war_nomemory =.
if "`country_of_interest'"!="États-Unis d'Amérique" {
	replace loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace1)) if year >=1745 & year <=1755
	replace loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace2)) if year >=1756 & year <=1777
	replace loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace3)) if year >=1778 & year <=1792
}
replace loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace4)) if year >=1793
replace loss_war_nomemory = 1 if value==0

summarize loss_war
local min =r(min)
summarize loss_war_nomemory
local min_nomemory=r(min)

replace war1=1 if war1!=.
replace war2=1 if war2!=.
replace war3=1 if war3!=.
replace war4=1 if war4!=.
replace war5=1 if war5!=.
replace blockade = 1 if blockade!=.

gen warmin1=`min' if war1!=.
gen warmin2=`min' if war2!=.
gen warmin3=`min' if war3!=.
gen warmin4=`min' if war4!=.
gen warmin5=`min' if war5!=.
gen blockademin = `min' if blockade!=.

gen warminl1=`min_nomemory' if war1!=.
gen warminl2=`min_nomemory' if war2!=.
gen warminl3=`min_nomemory' if war3!=.
gen warminl4=`min_nomemory' if war4!=.
gen warminl5=`min_nomemory' if war5!=.
gen blockademinl = `min_nomemory' if blockade!=.





keep if year >=1740

/*
graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4)) ///
			 (connected loss_war year, cmissing(n) lcolor(black) mcolor(black) msize(vsmall)) ///
			 (connected loss_war_nomemory year, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)), ///
			 legend(order (6 7) label(6 "Difference with all past peace periods trend") label(7 "Difference with preceeding peace period trend") rows(2)) ///
			 title("`country_of_interest'_`inorout'")


graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area warmin1 year, color(gs9)) (area warmin2 year, color(gs9)) ///
			 (area warmin3 year, color(gs9)) (area warmin4 year, color(gs9)) ///
			 (area warmin5 year, color(gs9)) (area blockademin year, color(gs4)) ///
			 (connected loss_war year, cmissing(n) lcolor(black) mcolor(black) msize(vsmall)), ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 legend(order (13) label(13 "Difference with all past peace periods trend")) ///
			 title("`country_of_interest'_`inorout'") ///
			 yline(0, lwidth(medium) lcolor(grey)) yscale(range(`min' 1))

graph export "$hamburggit/Results/Loss graphs/yearlyloss_`country_of_interest'_`inorout'.pdf", replace
*/		 
if "`country_of_interest'"!="États-Unis d'Amérique" {			 
	egen loss_war1=mean(loss_war) if year >=1745 & year <=1748
	egen loss_peace1=mean(loss_war) if year >=1749 & year <=1755
	egen loss_war2=mean(loss_war) if year >=1756 & year <=1762
	egen loss_peace2=mean(loss_war) if year >=1763 & year <=1777
	egen loss_war3=mean(loss_war) if year >=1778 & year <=1783
	egen loss_peace3=mean(loss_war) if year >=1784 & year <=1792
}
egen loss_war4=mean(loss_war) if year >=1793 & year <=1807
egen loss_blockade=mean(loss_war) if year >=1808 & year <=1815
egen loss_peace4=mean(loss_war) if year >=1816

if "`country_of_interest'"!="États-Unis d'Amérique" ///
			egen mean_loss = rmax(loss_war1 loss_war2 loss_war3 loss_war4 ///
			loss_peace1 loss_peace2 loss_peace3 loss_peace4 ///
			loss_blockade)			

if "`country_of_interest'"=="États-Unis d'Amérique" ///
			egen mean_loss = rmax(loss_war4 ///
			loss_peace4 ///
			loss_blockade)

capture drop loss_war1 loss_war2 loss_war3 loss_war4 ///
			loss_peace1 loss_peace2 loss_peace3 loss_peace4 ///
			loss_blockade
/*
graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area warmin1 year, color(gs9)) (area warmin2 year, color(gs9)) ///
			 (area warmin3 year, color(gs9)) (area warmin4 year, color(gs9)) ///
			 (area warmin5 year, color(gs9)) (area blockademin year, color(gs4)) ///
			 (line mean_loss year), plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 title("`country_of_interest'_`inorout'") ///
			 yline(0, lwidth(medium) lcolor(grey)) yscale(range(`min' 1))
*/

if "`country_of_interest'"!="États-Unis d'Amérique" {	
	egen loss_war_nomemory1=mean(loss_war_nomemory) if year >=1745 & year <=1748
	egen loss_peace_nomemory1=mean(loss_war_nomemory) if year >=1749 & year <=1755
	egen loss_war_nomemory2=mean(loss_war_nomemory) if year >=1756 & year <=1762
	egen loss_peace_nomemory2=mean(loss_war_nomemory) if year >=1763 & year <=1777
	egen loss_war_nomemory3=mean(loss_war_nomemory) if year >=1778 & year <=1783
	egen loss_peace_nomemory3=mean(loss_war_nomemory) if year >=1784 & year <=1792
}
egen loss_war_nomemory4=mean(loss_war_nomemory) if year >=1793 & year <=1807
egen loss_blockade_nomemory=mean(loss_war_nomemory) if year >=1808 & year <=1815
egen loss_peace_nomemory4=mean(loss_war_nomemory) if year >=1816

if "`country_of_interest'"!="États-Unis d'Amérique" ///
		egen mean_loss_nomemory = rmax(loss_war_nomemory1 loss_war_nomemory2 loss_war_nomemory3 loss_war_nomemory4 ///
		loss_peace_nomemory1 loss_peace_nomemory2 loss_peace_nomemory3 loss_peace_nomemory4 ///
		loss_blockade_nomemory)
if "`country_of_interest'"=="États-Unis d'Amérique" ///
		egen mean_loss_nomemory = rmax(loss_war_nomemory4 ///
		loss_peace_nomemory4 ///
		loss_blockade_nomemory)



capture drop loss_war_nomemory1 loss_war_nomemory2 loss_war_nomemory3 loss_war_nomemory4 ///
		loss_peace_nomemory1 loss_peace_nomemory2 loss_peace_nomemory3 loss_peace_nomemory4 ///
		loss_blockade_nomemory
/*
graph twoway (area mean_loss_nomemory year), title("`country_of_interest'_`inorout'")

graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area warmin1 year, color(gs9)) (area warmin2 year, color(gs9)) ///
			 (area warmin3 year, color(gs9)) (area warmin4 year, color(gs9)) ///
			 (area warmin5 year, color(gs9)) (area blockademin year, color(gs4)) ///
			 (line mean_loss year) (line mean_loss_nomemory year), ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 title("`country_of_interest'_`inorout'") ///
			 yline(0, lwidth(medium) lcolor(grey)) yscale(range(`min' 1))

			 
			 
graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area warmin1 year, color(gs9)) (area warmin2 year, color(gs9)) ///
			 (area warmin3 year, color(gs9)) (area warmin4 year, color(gs9)) ///
			 (area warmin5 year, color(gs9)) (area blockademin year, color(gs4)) ///
			 (line mean_loss year), plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 title("`country_of_interest'_`inorout'") ///
			 yline(0, lwidth(medium) lcolor(grey)) yscale(range(`min' 1))
			 
graph export "$hamburggit/Results/Loss graphs/meanloss_`country_of_interest'_`inorout'.pdf", replace
*/
rename loss_war loss
rename loss_war_nomemory loss_nomemory


*gen breakofinterest = "`interet'"




end


*set graphic off

local i 0

foreach inoroutofinterest in Imports Exports XI {
	foreach countryofinterest in all all_ss_outremer {
		loss_function  `inoroutofinterest' `countryofinterest'
		if `i'!= 0 {
			append using "$hamburggit/Results/Yearly loss measure.dta"
		}
		save "$hamburggit/Results/Yearly loss measure.dta", replace
		local i = 1
	}
}

	
use "$hamburg/database_dta/Best guess FR bilateral trade.dta", clear


foreach inoroutofinterest in Imports Exports XI {
	foreach countryofinterest in "États-Unis d'Amérique" ///
		"Flandre et autres états de l'Empereur" Allemagne Angleterre Espagne  ///
		"Hollande" "Italie" "Levant et Barbarie" "Nord" "Outre-mers" "Portugal" ///
		"Suisse"  {
		display "`inoroutofinterest' `countryofinterest'"
		loss_function `inoroutofinterest' `"`countryofinterest'"'
		append using "$hamburggit/Results/Yearly loss measure.dta" 
		save "$hamburggit/Results/Yearly loss measure.dta", replace
	}
}

drop pays
sort grouping_classification
encode grouping_classification, gen(pays)
save "$hamburggit/Results/Yearly loss measure.dta", replace



collapse (mean) mean_loss mean_loss_nomemory (mean) value (count) year, ///
					by(grouping_classification period_str period exportsimports war_status)
rename year nbr_of_years
save "$hamburggit/Results/Mean loss measure.dta", replace			


set graphic on

/*
				

loss_function R&N XI 1 all
collapse (mean) loss,by(grouping_classification period_str exportsimports) 
save "$hamburggit/Results/Loss measure.dta", replace

loss_function R&N XI 0 all
collapse (mean) loss,by(grouping_classification period_str exportsimports) 
gen outremer = 0
append using "$hamburggit/Results/Loss measure.dta"
save "$hamburggit/Results/Loss measure.dta", replace





/*

foreach countryofinterest in Allemagne Angleterre Espagne "Flandre et autres états de l'Empereur" ///
			"Hollande" "Italie" "Levant et Barbarie" "Nord" "Outre-mers" "Portugal" ///
			"Suisse" "États-Unis d'Amérique" {
			loss_function R&N XI 1 `countryofinterest'
			collapse (mean) loss,by(grouping_classification period_str exportsimports war_status)
			generate break_of_interest ="`interet'"

		}

-----------------
Pour illustrer pourquoi il ne faut pas utiliser "loss_nomemory"
use "$hamburg/database_dta/Best guess FR bilateral trade.dta", clear
twoway (line value year) if grouping_classification=="Portugal" & exportsimports=="Imports"
C'est parce que le commerce avec le Portugal baisse en 1792 par rapport aux années précédentes.
----------------------



