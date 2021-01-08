
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

else if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE\Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
}





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

keep if year >=1710

twoway (line Source1 year) (line Source3 year) (line Source4 year) (line Source5 year) /*
	*/ (line Source6 year) (line Source7 year) (line Source9 year) (line Source12 year) (line Source13 year) /*
	*/ (line Source14 year) (line Source16 year) (line Source17 year) (line Source19 year)
	
twoway (connected Source1 year) (connected Source3 year) (connected Source4 year) (connected Source5 year) /*
	*/ (connected Source6 year) (connected Source7 year) (connected Source9 year) (connected Source12 year) (connected Source13 year) /*
	*/ (connected Source14 year) (connected Source16 year) (connected Source17 year) (connected Source19 year)

blif



merge 1:1 year using "$hamburg/database_dta/Expenditures.dta"
drop _merge
sort year
twoway (line NavyNet  year) (line NavyGross  year) (line FrenchBudget year)

save "$hamburg/database_dta/Expenditures.dta",  replace

