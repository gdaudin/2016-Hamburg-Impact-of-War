
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

else if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE\Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Volumes/GoogleDrive/My Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Desktop/HamburgPaper"
}

*************British budget

insheet using "$hamburggit/External Data/MitchellGBPublicFinance.csv", case clear

rename v1 year

replace TotalGrossExpendituresMillion  	=usubinstr(TotalGrossExpendituresMillion,",",".",.)
replace ArmyandOrdnanceGrossMillion  	=usubinstr(ArmyandOrdnanceGrossMillion,",",".",.)
replace NavyGrossMillion  				=usubinstr(NavyGrossMillion,",",".",.)

destring TotalGrossExpendituresMillion ArmyandOrdnanceGrossMillion NavyGrossMillion, replace

generate ArmyandOrdnanceNetthsd = ArmyNetthsd+ OrdnanceNetthsd  

merge 1:1 year using "$hamburg/database_dta/ST_silver.dta"
drop if _merge==2
drop _merge


generate TotalNet=log10(TotatnetexpendituresThsd*1000/1000000*ST_silver)

generate ArmyandOrdnanceNet = log10(ArmyandOrdnanceNetthsd*1000/1000000*ST_silver)
generate NavyNet = log10(NavyNetthsd*1000/1000000*ST_silver)
generate TotalGross = log10(TotalGrossExpendituresMillion*1000000/1000000*ST_silver)
generate ArmyandOrdnanceGross = log10(ArmyandOrdnanceGrossMillion*1000000/1000000*ST_silver)
generate NavyGross = log10(NavyGrossMillion*1000000/1000000*ST_silver)

twoway (line TotalNet  year) (line TotalGross  year)
twoway (line NavyNet  year) (line NavyGross  year)



save "$hamburg/database_dta/Expenditures.dta",  replace


*******French Budget

insheet using "$hamburggit/External Data/FRBudgetMarine.csv", case clear
replace FrenchBudget  	=usubinstr(FrenchBudget,",",".",.)
destring FrenchBudget, replace

drop Source

merge m:1 year using "$hamburg/database_dta/FR_silver.dta"
drop if _merge==2
drop _merge

replace FrenchBudget=log10(FrenchBudget*1000000*FR_silver/1000000)

reshape wide FrenchBudget, i(year) j(SourceID)

rename FrenchBudget* Source*

keep if year >=1740

**Après 1740, les sources actives sont : 1,2,6,10,11,13,14,16-19
*** 2 est redondante (Acerra-Meyer). 17 (Necker) n’est pas plausible pour 1781 : out
***16 de Marion out d’après Dull / Villiers (2002) p 497
***18 de Braesch isolé et seul
***19 d’après Villiers (2002) comprend les colonies

twoway (line Source1 year) /*(line Source3 year) (line Source4 year) (line Source5 year)*/ /*
	*/ (line Source6 year) /*(line Source7 year) (line Source8 year) (line Source9 year)*/ (line Source10 year) (line Source11 year)/*
	*/ /*(line Source12 year)*/ (line Source13 year) /*
	*/ (line Source14 year) /*(line Source16 year) (line Source17 year) (line Source18 year) (line Source19 year)*/
	
twoway (connected Source1 year) /*(connected Source3 year) (connected Source4 year) (connected Source5 year)*/ /*
	*/ (connected Source6 year) /*(connected Source7 year) (connected Source9 year)*/ /*
	*/ (connected Source10 year) (connected Source11 year)/*
	*/ /*(connected Source12 year)*/ (connected Source13 year) /*
	*/ (connected Source14 year) /*(connected Source16 year) (connected Source17 year) (connected Source18 year) (connected Source19 year)*/

generate diff_11_6 = (Source11-Source6)/Source6
generate diff_10_6 = (Source10-Source6)/Source6
	
	
summ diff_11_6, det
summ diff_10_6, det
egen FrenchBudget=rowmax(Source1 Source10 Source11 Source13 Source14)
replace FrenchBudget=Source6*1.025 if FrenchBudget==. & year <=1750
replace FrenchBudget=Source6*1.06 if FrenchBudget==. & year <=1789
set obs `=_N+8' 
replace year=1793 if _n==79
replace year=1794 if _n==80
replace year=1795 if _n==81
replace year=1796 if _n==82
replace year=1797 if _n==83
replace year=1798 if _n==84
replace year=1799 if _n==85
replace year=1800 if _n==87
replace FrenchBudget=2.2477+(2.6235-2.2477)*(year-1792)*1/9 if FrenchBudget==. & year <=1801
sort year
twoway (connected FrenchBudget year)

***********Graphique
merge 1:1 year using "$hamburg/database_dta/Expenditures.dta"
drop _merge
sort year
merge 1:1 year using "$hamburg/database_dta/Total silver trade FR GB.dta"
drop _merge

replace war1=3.5 if war1!=.
replace war2=3.5 if war2!=.
replace war3=3.5 if war3!=.
replace war4=3.5 if war4!=.
replace war5=3.5 if war5!=.
replace blockade=3.5 if blockade!=.
gen minwar1=1.5 if war1!=.
gen minwar2=1.5 if war2!=.
gen minwar3=1.5 if war3!=.
gen minwar4=1.5 if war4!=.
gen minwar5=1.5 if war5!=.
gen minblockade=1.5 if blockade!=.
drop if year >=1825

graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
			 (line NavyNet  year,lcolor(red)) (line NavyGross  year,lcolor(red) lpattern(dash)) ///
			 (line FrenchBudget year, lcolor(blue)) ///
			 if year >=1740 & year<=1830, scheme(s1color) ///
			 legend(order (13 14 15) label(13 "Net British Navy expenditures") label(14 "Gross British Navy expenditures") ///
			 label(15 "French Navy expenditures") rows(3)) ///
			 ytitle("Tons of silver, log(10)")
	
	
	
graph export "$hamburggit/Paper - Impact of War/Paper/FR_GB_Budget.png", replace

save "$hamburg/database_dta/Expenditures.dta",  replace

