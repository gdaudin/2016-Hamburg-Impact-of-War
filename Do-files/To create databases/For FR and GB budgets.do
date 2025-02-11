
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


generate TotalNet=TotatnetexpendituresThsd*1000/1000000*ST_silver

generate ArmyandOrdnanceNet = ArmyandOrdnanceNetthsd*1000/1000000*ST_silver
generate NavyNet = NavyNetthsd*1000/1000000*ST_silver
generate TotalGross = TotalGrossExpendituresMillion*1000000/1000000*ST_silver
generate ArmyandOrdnanceGross = ArmyandOrdnanceGrossMillion*1000000/1000000*ST_silver
generate NavyGross = NavyGrossMillion*1000000/1000000*ST_silver

twoway (line TotalNet  year) (line TotalGross  year), yscale (log)
twoway (line NavyNet  year) (line NavyGross  year), yscale (log)



save "$hamburg/database_dta/Expenditures.dta",  replace


*******French Budget

insheet using "$hamburggit/External Data/FRBudgetMarine.csv", case clear
replace FrenchBudget  	=usubinstr(FrenchBudget,",",".",.)
destring FrenchBudget, replace



drop Source

merge m:1 year using "$hamburg/database_dta/FR_silver.dta"
drop if _merge==2
drop _merge

replace FrenchBudget=FrenchBudget*1000000*FR_silver/1000000

reshape wide FrenchBudget, i(year) j(SourceID)

rename FrenchBudget* Source*

*keep if year >=1741
keep if year >=1680
*Avant 1690, 2 sources (20 et 2). 2 est une moyenne sur plusieurs années, 20 a l’air plus plausible
twoway (connected Source20 year) (connected Source2 year), yscale(log)

generate FrenchBudget=Source20 if year <1690


**1690-1716 les sources actives sont  3, 4, 5, 6, 12 et 9
twoway /*(connected Source1 year)*/ (connected Source3 year) (connected Source4 year) (connected Source5 year) /*
	*/ (connected Source6 year) /*(connected Source7 year)*/ (connected Source9 year) /*
	/**/ (connected Source10 year) (connected Source11 year)/**/
	*/ (connected Source12 year) /*(connected Source13 year)*/ /*
	*//* (connected Source14 year) (connected Source16 year) (connected Source17 year) (connected Source18 year) (connected Source19 year) *//*
	*/ /*(connected Source20 year)*/ if year >=1690 & year<=1740, yscale(log)


twoway /*(connected Source1 year)*/ (connected Source3 year) (connected Source4 year) (connected Source5 year) /*
	*/ (connected Source6 year) /*(connected Source7 year)*/ (connected Source9 year) /*
	/**/ (connected Source10 year) (connected Source11 year)/**/
	*/ (connected Source12 year) /*(connected Source13 year)*/ /*
	*//* (connected Source14 year) (connected Source16 year) (connected Source17 year) (connected Source18 year) (connected Source19 year) *//*
	*/ /*(connected Source20 year)*/ if year >=1690 & year<=1720, yscale(log)


*Bon, les sources sont assez convergentes de toutes les manières. Je prends le max et puis voilà....
egen Blif=rowmax(Source3 Source14 Source5 Source9 Source12)
replace FrenchBudget=Blif if year >=1690 & year<=1716
drop Blif


*1716-1739 : que la source 6

**Après 1740, les sources actives sont : 1,2,6,10,11,13,14,16-19
*** 2 est redondante (Acerra-Meyer). 17 (Necker) n’est pas plausible pour 1781 : out
***16 de Marion out d’après Dull / Villiers (2002) p 497
***18 de Braesch isolé et seul
***19 d’après Villiers (2002) comprend les colonies
***6 est sous-évaluée d’après Villiers

twoway (line Source1 year) /*(line Source3 year) (line Source4 year) (line Source5 year)*/ /*
	*/ (line Source6 year) /*(line Source7 year) (line Source8 year) (line Source9 year)*/ (line Source10 year) (line Source11 year)/*
	*/ /*(line Source12 year)*/ (line Source13 year) /*
	*/ (line Source14 year) /*(line Source16 year) (line Source17 year) (line Source18 year) (line Source19 year)*/ (line Source20 year) , yscale(log)
	
twoway (connected Source1 year) /*(connected Source3 year) (connected Source4 year) (connected Source5 year)*/ /*
	*/ (connected Source6 year) /*(connected Source7 year) (connected Source9 year)*/ /*
	*/ (connected Source10 year) (connected Source11 year)/*
	*/ /*(connected Source12 year)*/ (connected Source13 year) /*
	*/ (connected Source14 year) /*(connected Source16 year) (connected Source17 year) (connected Source18 year) (connected Source19 year)*/ /*
	*/ (connected Source20 year) , yscale(log)

generate diff_11_6 = (Source11-Source6)/Source6
generate diff_10_6 = (Source10-Source6)/Source6
	
	
summ diff_11_6, det
summ diff_10_6, det
egen Blif=rowmax(Source1 Source10 Source11 Source13 Source14)
replace FrenchBudget=Blif if year >=1741
drop Blif


**** Pour prendre en compte la sous-évaluation de la source 6 signalée par Villiers à partir des sources 11 et 10
replace FrenchBudget=Source6*1.025 if FrenchBudget==. & year <=1750 
replace FrenchBudget=Source6*1.06 if FrenchBudget==. & year <=1789
local N = _N
set obs `=_N+8' 
replace year=1793 if _n==`N'+1
replace year=1794 if _n==`N'+2
replace year=1795 if _n==`N'+3
replace year=1796 if _n==`N'+4
replace year=1797 if _n==`N'+5
replace year=1798 if _n==`N'+6
replace year=1799 if _n==`N'+7
replace year=1800 if _n==`N'+8

*replace FrenchBudget=2.2477+(2.6235-2.2477)*(year-1792)*1/9 if FrenchBudget==. & year <=1801 & year >=1793
**growth rate between 1792 and 1801 :
local gr = (420.21/176.9)^(1/9)-1
replace FrenchBudget=176.9*(1+ `gr')^(year-1792) if FrenchBudget==. & year <=1801 & year >=1793
sort year
twoway (connected FrenchBudget year), yscale(log)
drop if year ==.





merge 1:1 year using "$hamburg/database_dta/Expenditures.dta"
drop _merge
sort year

save "$hamburg/database_dta/FR&EN naval budgets.dta", replace
erase "$hamburg/database_dta/Expenditures.dta"
