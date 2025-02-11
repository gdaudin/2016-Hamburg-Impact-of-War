version 18

**il y a peut-être un  problème à régler avec Cumulated_Costs_and_benefits.png, du côté des gains nets britanniques. Je ne sais pas pourquoi cela a tant changé
**Voir "Cumulated_Costs_and_benefits -- Old for memory.png" qui date du 29 juin 2022.


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



************* Pour les graphiques avec les dépenses
use "$hamburg/database_dta/Loss_values.dta", clear

/*
local var value
capture drop loss
capture drop loss_nomemory
capture drop ln_value_p*

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


	
gen     loss = 1-(`var'FR_silver/exp(ln_`var'_peace1)) 	if year >=1744 & year <=1755
replace loss = 1-(`var'FR_silver/exp(ln_`var'_peace1_2)) if year >=1756 & year <=1777
replace loss = 1-(`var'FR_silver/exp(ln_`var'_peace1_3)) if year >=1778 & year <=1792
replace loss = 1-(`var'FR_silver/exp(ln_`var'_peace1_4)) if year >=1793
replace loss =. if ln_`var'==.
replace loss=max(-.2,loss)
replace loss =. if ln_`var'==.
replace loss =. if year <=1743
	
	

gen     loss_nomemory  = 1-(`var'FR_silver/exp(ln_`var'_peace1)) if year >=1744 & year <=1755
replace loss_nomemory  = 1-(`var'FR_silver/exp(ln_`var'_peace2)) if year >=1756 & year <=1777
replace loss_nomemory  = 1-(`var'FR_silver/exp(ln_`var'_peace3)) if year >=1778 & year <=1792
replace loss_nomemory  = 1-(`var'FR_silver/exp(ln_`var'_peace4)) if year >=1793
replace loss_nomemory  =. if ln_`var'==.
replace loss_nomemory=max(-.2,loss_nomemory)
replace loss_nomemory  =. if ln_`var'==.
replace loss_nomemory =. if year <=1743

*/

merge 1:1 year using "$hamburg/database_dta/Expenditures.dta" 
drop _merge

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
keep if year >=1741




graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
			 (connected loss_abs year, cmissing(n) lcolor(black) mcolor(black) msize(vsmall) lpattern(dash)) ///
			 (connected loss_nm_abs year, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 (line NavyGross year, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ ) ///
			 (line NavyNet year, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ lpattern(dash)) ///
			 (line FrenchBudget year, cmissing(n) lcolor(blue) /*mcolor(red) msize(vsmall)*/), ///
			 legend(order (13 14 16 15 17) label(13 "Using all past peace periods for the peace trend") ///
			 label(14 "Using the preceeding peace period for the peace trend") ///
			 label(15 "Gross Royal Navy expenditures") label(16 "Net Royal Navy expenditures") ///
			 label(17 "French Navy expenditures") rows(5)) ///
			 ytitle("Tons of silver, log10", size(small)) ylabel(1 (1) 4) ///
			 /*yline(0, lwidth(medium) lcolor(gray))*/ xtitle("") xscale(range(1740 1830)) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) scheme(stsj)
			 



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


merge 1:1 year using "$hamburg/database_dta/English&French_prizes.dta"
drop _merge
keep if year >=1741
keep if year <=1825
replace NavyGross=10^NavyGross
replace NavyNet=10^NavyNet		
replace FrenchBudget = 10^FrenchBudget	 

***Assume that the costs on the robbed person are twice the value for the privateer
generate BR_predation_gain = Total_Prize_value - Privateers_Investment - Frenchincome*2
generate FR_predation_loss = Frenchinvestment+FR_Prize_value*2-Frenchincome


graph twoway (connected BR_predation_gain year, cmissing(n) ) (connected FR_predation_loss year, cmissing(n))


replace FR_Prize_value=. if FR_Prize_value==0
export delimited "$hamburg/database_csv/expenditures_annual_loss.csv", replace




graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
			 (connected loss_abs year if year <=1825, cmissing(n) lcolor(black) mcolor(black) msize(vsmall) lpattern(dash) ) ///
			 (connected loss_nm_abs year if year <=1825, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 (line NavyGross year if year <=1825, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ ) ///
			 (line NavyNet year if year <=1825, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ lpattern(dash)) ///
			 (line FrenchBudget year, cmissing(n) lcolor(blue)) /*mcolor(red) msize(vsmall)*/ ///
			 (line BR_predation_gain year, cmissing(n) lcolor(gray)) ///
			 (connected FR_predation_loss year, cmissing(n) lcolor(gray) msize(tiny)), ///
			 legend(order (13 14 16 15 17 18 19) label(13 "Using all past peace periods for the peace trend") ///
			 label(14 "Using the preceeding peace period for the peace trend") ///
			 label(15 "Gross British Navy expenditures") label(16 "Net British Navy expenditures")   ///
			 label(17 "French Navy expenditures") label(18 "Net British predation gains")  ///
			 label(19 "Net French predation losses") rows(7)) ///
			 ytitle("Tons of silver", size(small)) /*ylabel(1 (1) 4)*/ ///
			 /*yline(0, lwidth(medium) lcolor(gray))*/ xtitle("")  ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) scheme(stsj)

graph export "$hamburggit/Paper - Impact of War/Paper/Expenditures_Annual_Loss.png", as(png) replace




replace war1=3000 if war1!=.
replace war2=3000 if war2!=.
replace war3=3000 if war3!=.
replace war4=3000 if war4!=.
replace war5=3000 if war5!=.
replace blockade=3000 if blockade!=.

/*
graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
			 (line NavyGross year if year <=1825, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ ) ///
			 (line NavyNet year if year <=1825, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ lpattern(dash)) ///
			 (line FrenchBudget year, cmissing(n) lcolor(blue)) /*mcolor(red) msize(vsmall)*/ ///
			 (line FR_Prize_value year, cmissing(n) lcolor(gray)), ///
			 legend(order (13 14 16 15) ///
			 label(13 "Gross British Navy expenditures") label(14 "Net British Navy expenditures")   ///
			 label(15 "French Navy expenditures") label(16 "Value of French prizes captured by Britain") rows(4)) ///
			 ytitle("Tons of silver", size(small)) /*ylabel(1 (1) 4)*/ ///
			 /*yline(0, lwidth(medium) lcolor(gray))*/ xtitle("")  ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) 

graph export "$hamburggit/Paper - Impact of War/Paper/Costs_and_benefits.png", as(png) replace
*/



sort year





replace loss_abs = 0 if loss_abs==. & year <=1792 & year >=1781
replace loss_abs = 3200 if loss_abs==. & year <=1799 & year >=1793
generate loss_abs_cum    = log10(sum(loss_abs))

replace loss_nm_abs = 0 if loss_nm_abs==. & year <=1792 & year >=1781
replace loss_nm_abs = 2500 if loss_nm_abs==. & year <=1799 & year >=1793

generate loss_nm_abs_cum = log10(sum(loss_nm_abs))




generate Navy_Net_cum    = sum(NavyNet)
replace Navy_Net_cum = Navy_Net_cum + (1229+1428)/2 if year >=1800
*As we have two measures for 1800
generate Navy_Gross_cum  = sum(NavyGross)
generate log_Navy_cum=log10(Navy_Gross_cum+Navy_Net_cum)
generate Navy_cum=Navy_Gross_cum+Navy_Net_cum

generate log_BR_predation_gain_cum = log10(sum(BR_predation_gain))
generate BR_predation_gain_cum = sum(BR_predation_gain)

generate log_FRbudget_cum = log10(sum(FrenchBudget))
generate FRbudget_cum = sum(FrenchBudget)

generate log_FR_Prize_value_cum = log10(sum(FR_Prize_value))
generate FR_Prize_value_cum = sum(FR_Prize_value)

generate log_FR_predation_loss_cum = log10(sum(FR_predation_loss))
generate FR_predation_loss_cum = sum(FR_predation_loss)


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
export delimited "$hamburg/database_csv/cumulated_costs_and_benefits.csv", replace


graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
		(connected loss_abs_cum year if year <=1825, cmissing(n) lcolor(blue) mcolor(blue) msize(vsmall) lpattern(dash) ) ///
			 (line loss_nm_abs_cum year if year <=1825, cmissing(n) lcolor(blue) mcolor(blue) msize(vsmall) lpattern(line)) ///
			 (line log_Navy_cum year if year <=1825, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ lpattern(line) ) ///
			 (line log_FRbudget_cum year, cmissing(n) lcolor(green) /*mcolor(red) msize(vsmall)*/ lpattern(dash)) ///
			 (line log_BR_predation_gain_cum year, cmissing(n) lcolor(red) mcolor(red)/* msize(vsmall)*/ lpattern(line)) ///
			 (line log_FR_predation_loss_cum year, cmissing(n) lcolor(red) mcolor(red) msize(tiny) lpattern(dash)) ///
			, ///
			 legend(order (13 14 15 16 17 18) label(13 "Using all past peace periods for the peace trend") ///
			 label(14 "Using the preceeding peace period for the peace trend") ///
			 label(15 "Royal Navy expenditures")  ///
			 label(16 "French Navy expenditures") ///
			 label(17 "Net British predation gains") ///
			 label(18 "Net French predation losses") rows(6)) ///
			 ytitle("Tons of silver, log(10)", size(small)) /*ylabel(1 (1) 4)*/ ///
			 /*yline(0, lwidth(medium) lcolor(gray))*/ xtitle("")  ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) scheme(stsj)
			 
graph export "$hamburggit/Paper - Impact of War/Paper/Cumulated_Costs_and_benefits.png", as(png) replace


			 
generate ratio_abs    = 10^loss_abs_cum/Navy_cum
generate ratio_nm_abs = 10^loss_nm_abs_cum/Navy_cum


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
			 ytitle("Ratio between cumulated French trade losses" "and the cumulated British Navy budget", size(small)) /*ylabel(1 (1) 4)*/ ///
			 /*yline(0, lwidth(medium) lcolor(gray))*/ xtitle("") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) scheme(stsj) 
			 
			 
generate Total_Prize_value_cum=sum(Total_Prize_value)
		
generate ratio_abs_v2    = (10^loss_abs_cum+FR_predation_loss_cum)/(Navy_cum-BR_predation_gain_cum)
generate ratio_nm_abs_v2 = (10^loss_nm_abs_cum+FR_predation_loss_cum)/(Navy_cum-BR_predation_gain_cum)

generate ratio_abs_v3    = (10^loss_abs_cum+FR_predation_loss_cum+FRbudget_cum) /(Navy_cum-BR_predation_gain_cum)
generate ratio_nm_abs_v3 = (10^loss_nm_abs_cum+FR_predation_loss_cum+10^FRbudget_cum) /(Navy_cum-BR_predation_gain_cum)

replace war1=10 if war1!=.
replace war2=10 if war2!=.
replace war3=10 if war3!=.
replace war4=10 if war4!=.
replace war5=10 if war5!=.
replace blockade=10 if blockade!=.



/*
graph twoway (area war1 year , color(gs9)) (area war2 year , color(gs9)) ///
			 (area war3 year , color(gs9)) (area war4 year , color(gs9)) ///
			 (area war5 year , color(gs9)) (area blockade year , color(gs4)) ///
			 (area minwar1 year , color(gs9)) (area minwar2 year , color(gs9)) ///
			 (area minwar3 year , color(gs9)) (area minwar4 year , color(gs9)) ///
			 (area minwar5 year , color(gs9)) (area minblockade year , color(gs4)) ///
			 (line ratio_abs year , cmissing(n) lcolor(blue) mcolor(black) msize(vsmall) lpattern(dash) ) ///
			 (line ratio_nm_abs year , cmissing(n) lcolor(blue) mcolor(black) msize(vsmall)) ///
			 (line ratio_abs_v2 year , cmissing(n) lcolor(red) mcolor(red) msize(vsmall) lpattern(dash) ) ///
			 (line ratio_nm_abs_v2 year , cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
		(line ratio_abs_v3 year , cmissing(n) lcolor(green) mcolor(green) msize(vsmall) lpattern(dash) ) ///
			 (line ratio_nm_abs_v3 year , cmissing(n) lcolor(green) mcolor(green) msize(vsmall)) ///		 
			 , ///
			 legend(order (14 16 18) label(13 "PT with memory -- British costs=British budget") ///
			 label(14 "British costs = British Navy budget")  ///
			 label(16 "British costs = idem - value of captured French prizes")  ///
			 label(18 "British costs = idem - French Navy budget") note ("Line: Using all past peace periods for the peace trend" "Dash: Using the preceeding peace period for the peace trend")  ///
			 rows(8)) ///
			 ytitle("Ratio between cumulated French trade losses" "and the cumulated British costs", size(small)) /*ylabel(1 (1) 4)*/ ///
			 /*yline(0, lwidth(medium) lcolor(gray))*/ xtitle("") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) scheme(stsj)	 
*/
			 
			 
replace ratio_abs		=	ratio_abs*0.35
replace ratio_nm_abs		=	ratio_nm_abs*0.35	 

replace ratio_abs_v2    = ((10^loss_abs_cum)*0.35+FR_predation_loss_cum)/(Navy_cum-BR_predation_gain_cum)
replace ratio_nm_abs_v2 = ((10^loss_nm_abs_cum)*0.35+FR_predation_loss_cum)/(Navy_cum-BR_predation_gain_cum)

replace ratio_abs_v3    = ((10^loss_abs_cum)*0.35+FR_predation_loss_cum+FRbudget_cum)/(Navy_cum-BR_predation_gain_cum)
replace ratio_nm_abs_v3 = ((10^loss_nm_abs_cum)*0.35+FR_predation_loss_cum+FRbudget_cum)/(Navy_cum-BR_predation_gain_cum)

replace war1=2.5 if war1!=.
replace war2=2.5 if war2!=.
replace war3=2.5 if war3!=.
replace war4=2.5 if war4!=.
replace war5=2.5 if war5!=.
replace blockade=2.5 if blockade!=.


export delimited "$hamburg/database_csv/ratio_BR_expenditures_annual_lossH.csv", replace


graph twoway (area war1 year , color(gs9)) (area war2 year , color(gs9)) ///
			 (area war3 year , color(gs9)) (area war4 year , color(gs9)) ///
			 (area war5 year , color(gs9)) (area blockade year , color(gs4)) ///
			 (area minwar1 year , color(gs9)) (area minwar2 year , color(gs9)) ///
			 (area minwar3 year , color(gs9)) (area minwar4 year , color(gs9)) ///
			 (area minwar5 year , color(gs9)) (area minblockade year , color(gs4)) ///
			 (line ratio_abs year , cmissing(n) lcolor(blue) mcolor(black) msize(vsmall) lpattern(dash) ) ///
			 (line ratio_nm_abs year , cmissing(n) lcolor(blue) mcolor(black) msize(vsmall)) ///
			 (line ratio_abs_v2 year , cmissing(n) lcolor(red) mcolor(red) msize(vsmall) lpattern(dash) ) ///
			 (line ratio_nm_abs_v2 year , cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
		(line ratio_abs_v3 year , cmissing(n) lcolor(green) mcolor(green) msize(vsmall) lpattern(dash) ) ///
			 (line ratio_nm_abs_v3 year , cmissing(n) lcolor(green) mcolor(green) msize(vsmall)) ///		 
			 , ///
			 legend(order (14 16 18)  ///
			 label(14 "French losses = French trade losses*0.35 ")  ///
			 label(16 "French losses = idem + French predation losses")  ///
			 label(18 "French losses = idem + French Navy budget") note ("Dash: Using all preceeding peace periods for the peace trend" "Line: Using the preceeding peace period for the peace trend")  ///
			 rows(8)) ///
			 ytitle("Ratio between cumulated French losses" "and the cumulated British costs" "British navy budget (- British predation gains for" "red and green lines)" , size(small)) /*ylabel(1 (1) 4)*/ ///
			 /*yline(0, lwidth(medium) lcolor(gray))*/ xtitle("") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) scheme(stsj)
			 
			
graph export "$hamburggit/Paper - Impact of War/Paper/Ratio_BR_Expenditures_Annual_LossH.png", as(png) replace


replace ratio_abs		=	ratio_abs*0.14/0.35
replace ratio_nm_abs		=	ratio_nm_abs*0.14/0.35 

replace ratio_abs_v2    = ((10^loss_abs_cum)*0.14+FR_predation_loss_cum)/(Navy_cum-BR_predation_gain_cum)
replace ratio_nm_abs_v2 = ((10^loss_nm_abs_cum)*0.14+FR_predation_loss_cum)/(Navy_cum-BR_predation_gain_cum)

replace ratio_abs_v3    = ((10^loss_abs_cum)*0.14+FR_predation_loss_cum+FRbudget_cum)/(Navy_cum-FR_Prize_value_cum)
replace ratio_nm_abs_v3 = ((10^loss_nm_abs_cum)*0.14+FR_predation_loss_cum+FRbudget_cum)/(Navy_cum-FR_Prize_value_cum)


export delimited "$hamburg/database_csv/ratio_BR_expenditures_annual_lossL.csv", replace


graph twoway (area war1 year , color(gs9)) (area war2 year , color(gs9)) ///
			 (area war3 year , color(gs9)) (area war4 year , color(gs9)) ///
			 (area war5 year , color(gs9)) (area blockade year , color(gs4)) ///
			 (area minwar1 year , color(gs9)) (area minwar2 year , color(gs9)) ///
			 (area minwar3 year , color(gs9)) (area minwar4 year , color(gs9)) ///
			 (area minwar5 year , color(gs9)) (area minblockade year , color(gs4)) ///
			 (line ratio_abs year , cmissing(n) lcolor(blue) mcolor(black) msize(vsmall) lpattern(dash) ) ///
			 (line ratio_nm_abs year , cmissing(n) lcolor(blue) mcolor(black) msize(vsmall)) ///
			 (line ratio_abs_v2 year , cmissing(n) lcolor(red) mcolor(red) msize(vsmall) lpattern(dash) ) ///
			 (line ratio_nm_abs_v2 year , cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
		(line ratio_abs_v3 year , cmissing(n) lcolor(green) mcolor(green) msize(vsmall) lpattern(dash) ) ///
			 (line ratio_nm_abs_v3 year , cmissing(n) lcolor(green) mcolor(green) msize(vsmall)) ///		 
			 , ///
			 legend(order (14 16 18)  ///
			 label(14 "French losses = French trade losses*0.14 ")  ///
			 label(16 "French losses = idem + French predation losses")  ///
			 label(18 "French losses = idem + French Navy budget") note ("Dash: Using all preceeding peace periods for the peace trend" "Line: Using the preceeding peace period for the peace trend")  ///
			 rows(8)) ///
			 ytitle("Ratio between cumulated French losses" "and the cumulated British costs" "British navy budget (- predation gains for" "red and green lines)", size(small)) /*ylabel(1 (1) 4)*/ ///
			 /*yline(0, lwidth(medium) lcolor(gray))*/ xtitle("") ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) scheme(stsj) 
			 
			
graph export "$hamburggit/Paper - Impact of War/Paper/Ratio_BR_Expenditures_Annual_LossL.png", as(png) replace










