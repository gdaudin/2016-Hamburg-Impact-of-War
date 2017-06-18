
global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"



if "`c(username)'" =="guillaumedaudin" {
	global thesis ~/Documents/Recherche/2016 Hamburg
}


set more off

capture use "$thesis/Données Stata/bdd courante.dta", clear

if "`c(username)'" =="guillaumedaudin" {
	use "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
}



set more off

use "$thesis/database_dta/hamburg1", clear

drop if year<1718

****gen war dummies
gen war_each="Peace" 

foreach i of num 1733/1738{
replace war_each="War1" if year==`i'
}

foreach i of num 1740/1743{
replace war_each="War1" if year==`i'
}

foreach i of num 1744/1748{
replace war_each="War2" if year==`i'
}

foreach i of num 1756/1763{
replace war_each="War2" if year==`i'
}

foreach i of num 1778/1782{
replace war_each="War2" if year==`i'
}

foreach i of num 1792/1802{
replace war_each="War3" if year==`i'
}

foreach i of num 1803/1814{
replace war_each="War3" if year==`i'
}



gen all=0
foreach i of num 1733/1738{
replace all=1 if year==`i'
}
foreach i of num 1740/1748{
replace all=1 if year==`i'
}
foreach i of num 1756/1763{
replace all=1 if year==`i'
}
foreach i of num 1778/1782{
replace all=1 if year==`i'
}
foreach i of num 1792/1802{
replace all=1 if year==`i'
}
foreach i of num 1803/1814{
replace all=1 if year==`i'
}



encode war_each, gen(each) label(order)


gen group=0 
replace group=1 if year<1740
replace group=2 if year>1739
replace group=3 if year>1795

gen g2=(group==2)
gen g3=(group==3)
gen year2=g2*year
gen year3=g3*year

label var value Value

/*
twoway (connected value year)
graph export hamburg_trend.png, as(png) replace
*/


eststo p1: poisson value year i.all if exportsimports=="Exports", vce(robust)
eststo p2: poisson value year g2 year2 g3 year3 i.all if exportsimports=="Exports", vce(robust)
eststo p3: poisson value year g3 year3 i.all if exportsimports=="Exports", vce(robust)

eststo p4: poisson value year i.each if exportsimports=="Exports", vce(robust)
eststo p5: poisson value year g2 year2 g3 year3 i.each if exportsimports=="Exports", vce(robust)
eststo p6: poisson value g3 year3 i.each if exportsimports=="Exports", vce(robust)

esttab

esttab p1 p3 p4 p6 using "$thesis/Data/do_files/Hamburg/tex/hamburg1_exp.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(_cons "Constant" 1.all "All" 1.each "Group 1" 2.each "Group 2" 3.each "Group 3") ///
	drop(year _cons *3) not pr2 nonumbers ///
	mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(Hamburg Aggregate\label{tab1}) replace
 
eststo clear

eststo p1: poisson value year i.all if exportsimports=="Imports", vce(robust)
eststo p2: poisson value year g2 year2 g3 year3 i.all if exportsimports=="Imports", vce(robust)
eststo p3: poisson value year g3 year3 i.all if exportsimports=="Imports", vce(robust)

eststo p4: poisson value year i.each if exportsimports=="Imports", vce(robust)
eststo p5: poisson value year g2 year2 g3 year3 i.each if exportsimports=="Imports", vce(robust)
eststo p6: poisson value g3 year3 i.each if exportsimports=="Imports", vce(robust)

esttab

esttab p1 p3 p4 p6 using "$thesis/Data/do_files/Hamburg/tex/hamburg1_imp.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(_cons "Constant" 1.all "All" 1.each "Group 1" 2.each "Group 2" 3.each "Group 3") ///
	drop(year _cons *3) not pr2 nonumbers ///
	mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(Hamburg Aggregate\label{tab1}) replace
 
eststo clear

