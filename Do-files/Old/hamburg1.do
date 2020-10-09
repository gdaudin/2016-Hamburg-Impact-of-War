
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

gen ln_value = ln(value)


/*
twoway (connected value year)
twoway (connected value year if export_import=="Exports") (lfit value year if export_import=="Exports")

graph export hamburg_trend.png, as(png) replace
*/


eststo p1: reg ln_value year i.all if export_import=="Exports"
eststo p2: reg ln_value year year2 year3 i.all if export_import=="Exports"
eststo p3: reg ln_value year year3 i.all if export_import=="Exports"

eststo p4: reg ln_value year i.each if export_import=="Exports"
eststo p5: reg ln_value year year2 year3 i.each if export_import=="Exports"
eststo p6: reg ln_value year year3 i.each if export_import=="Exports"

esttab

capture esttab p1 p3 p4 p6 using "$thesis/Data/do_files/Hamburg/tex/hamburg1_exp.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(_cons "Constant" 1.all "All" 1.each "Group 1" 2.each "Group 2" 3.each "Group 3") ///
	drop(year _cons *3) not pr2 nonumbers ///
	mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(Hamburg Aggregate\label{tab1}) replace
	
esttab p1 p3 p4 p6 using "~/Dropbox/Partage ET-GD/Results Hamburg/hamburg1_exp.csv",label csv alignment(D{.}{.}{-1}) ///
	varlab(_cons "Constant" year "Time trend" year3 "Time trend after 1795" 1.all "All wars" 2.each "Land wars" 3.each "Mercantilist wars" 4.each "R&N wars") ///
	order (year year3 1.all 2.each 3.each 4.each _cons) ///
	drop (1.each 0.all) ///
	mtitles("No breaks" "One break" "No breaks" "One break") ///
	r2(%9.2f) nonumbers depvar se(%9.2f)  b(%9.2f)  ///
	title("French exports to the North in logs") replace 
 
eststo clear

eststo p1: reg ln_value year i.all if export_import=="Imports"
eststo p2: reg ln_value year year2 year3 i.all if export_import=="Imports"
eststo p3: reg ln_value year year3 i.all if export_import=="Imports"

eststo p4: reg ln_value year i.each if export_import=="Imports"
eststo p5: reg ln_value year year2 year3 i.each if export_import=="Imports"
eststo p6: reg ln_value year3 i.each if export_import=="Imports"

esttab

capture esttab p1 p3 p4 p6 using "$thesis/Data/do_files/Hamburg/tex/hamburg1_imp.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(_cons "Constant" 1.all "All" 1.each "Group 1" 2.each "Group 2" 3.each "Group 3") ///
	drop(year _cons *3) not pr2 nonumbers ///
	mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(Hamburg Aggregate\label{tab1}) replace
 
eststo clear

