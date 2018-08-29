


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

generate wara=`maxvalue' if year >=1733 & year <=1738 
generate warb=`maxvalue' if year >=1740 & year <=1744
generate war1=`maxvalue' if year >=1744 & year <=1748
generate war2=`maxvalue' if year >=1756 & year <=1763
generate war3=`maxvalue' if year >=1778 & year <=1783
generate war4=`maxvalue' if year >=1793 & year <=1802
generate war5=`maxvalue' if year >=1803 & year <=1815


*********Fin préparation des données


order value grouping_classification pays war_status
if "`country_of_interest'"=="all"  {
	collapse (sum) value, by(year-war5)
	gen grouping_classification ="All"
}

if "`country_of_interest'"=="all_ss_outremer"  {
	collapse (sum) value, by(year-war5)
	gen grouping_classification ="All_ss_outremer"
}






gen ln_value=ln(value)
*replace ln_value=ln(14169) if value==0
*replace ln_value=ln(0.00000001) if value==0


reg ln_value year if year <= 1744 & war==0
predict ln_value_peace1
reg ln_value year if year <=1755 & war==0
predict ln_value_peace1_2
reg ln_value year if year <=1777  & war==0
predict ln_value_peace1_3
reg ln_value year if year <=1792  & war==0
predict ln_value_peace1_4
*reg ln_value year if war==0
*predict ln_value_peace_all


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
replace loss_war = 1 if value==0

gen     loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace1)) if year >=1745 & year <=1755
replace loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace2)) if year >=1756 & year <=1777
replace loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace3)) if year >=1778 & year <=1792
replace loss_war_nomemory = 1-(exp(ln_value)/exp(ln_value_peace4)) if year >=1793
replace loss_war_nomemory = 1 if value==0


replace war1=-1 if war1!=.
replace war2=-1 if war2!=.
replace war3=-1 if war3!=.
replace war4=-1 if war4!=.
replace war5=-1 if war5!=.
keep if year >=1740

/*
graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4)) ///
			 (connected loss_war year, cmissing(n) lcolor(black) mcolor(black) msize(vsmall)) ///
			 (connected loss_war_nomemory year, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 , ///
			 legend(order (6 7) label(6 "Difference with all past peace periods trend") label(7 "Difference with preceeding peace period trend") rows(2)) ///
			 title("`country_of_interest'_`inorout'")
*/

graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4)) ///
			 (connected loss_war year, cmissing(n) lcolor(black) mcolor(black) msize(vsmall)) ///
			 , ///
			 legend(order (6) label(6 "Difference with all past peace periods trend")) ///
			 title("`country_of_interest'_`inorout'")
graph export "$hamburggit/Results/Loss graph/yearlyloss_`country_of_interest'_`inorout'.pdf", replace
			 
			 
egen loss_war1=mean(loss_war) if year >=1745 & year <=1748
egen loss_peace1=mean(loss_war) if year >=1749 & year <=1755
egen loss_war2=mean(loss_war) if year >=1756 & year <=1762
egen loss_peace2=mean(loss_war) if year >=1763 & year <=1777
egen loss_war3=mean(loss_war) if year >=1778 & year <=1783
egen loss_peace3=mean(loss_war) if year >=1784 & year <=1792
egen loss_war4=mean(loss_war) if year >=1793 & year <=1815
egen loss_peace4=mean(loss_war) if year >=1816

egen mean_loss = rmax(loss_war1 loss_war2 loss_war3 loss_war4 loss_peace1 loss_peace2 loss_peace3 loss_peace4)
drop loss_war1 loss_war2 loss_war3 loss_war4 loss_peace1 loss_peace2 loss_peace3 loss_peace4

graph twoway (area mean_loss year), title("`country_of_interest'_`inorout'")

egen loss_war_nomemory1=mean(loss_war_nomemory) if year >=1745 & year <=1748
egen loss_peace_nomemory1=mean(loss_war_nomemory) if year >=1749 & year <=1755
egen loss_war_nomemory2=mean(loss_war_nomemory) if year >=1756 & year <=1762
egen loss_peace_nomemory2=mean(loss_war_nomemory) if year >=1763 & year <=1777
egen loss_war_nomemory3=mean(loss_war_nomemory) if year >=1778 & year <=1783
egen loss_peace_nomemory3=mean(loss_war_nomemory) if year >=1784 & year <=1792
egen loss_war_nomemory4=mean(loss_war_nomemory) if year >=1793 & year <=1815
egen loss_peace_nomemory4=mean(loss_war_nomemory) if year >=1816

egen mean_loss_nomemory = rmax(loss_war_nomemory1 loss_war_nomemory2 loss_war_nomemory3 loss_war_nomemory4 loss_peace_nomemory1 loss_peace_nomemory2 loss_peace_nomemory3 loss_peace_nomemory4)
drop loss_war_nomemory1 loss_war_nomemory2 loss_war_nomemory3 loss_war_nomemory4 loss_peace_nomemory1 loss_peace_nomemory2 loss_peace_nomemory3 loss_peace_nomemory4

graph twoway (area mean_loss_nomemory year), title("`country_of_interest'_`inorout'")

graph twoway (line mean_loss year) (line mean_loss_nomemory year), title("`country_of_interest'_`inorout'")
graph twoway (line mean_loss year), title("`country_of_interest'_`inorout'")
graph export "$hamburggit/Results/Loss graph/meanloss_`country_of_interest'_`inorout'.pdf", replace

rename loss_war loss
rename loss_war_nomemory loss_nomemory


*gen breakofinterest = "`interet'"




end

loss_function Imports  "Portugal"


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
		foreach countryofinterest in "Flandre et autres états de l'Empereur" Allemagne Angleterre Espagne  ///
			"Hollande" "Italie" "Levant et Barbarie" "Nord" "Outre-mers" "Portugal" ///
			"Suisse"  {
			display "`inoroutofinterest' `countryofinterest'"
			loss_function `inoroutofinterest' `"`countryofinterest'"'
			append using "$hamburggit/Results/Yearly loss measure.dta"
			save "$hamburggit/Results/Yearly loss measure.dta", replace
		}
	}



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



