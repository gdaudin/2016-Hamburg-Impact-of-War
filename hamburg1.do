
*global ete "/Users/Tirindelli/Google Drive/ETE"
global ete "C:\Users\TIRINDEE\Google Drive\ETE"

set more off

use "$ete/Thesis2/database_dta/hamburg1", clear

drop if year<1733

****gen war dummies
gen war_each=""
gen war_all=""

foreach i of num 1733/1738{
replace war_each="Polish" if year==`i'
}

foreach i of num 1740/1743{
replace war_each="Austrian1" if year==`i'
}

foreach i of num 1744/1748{
replace war_each="Austrian2" if year==`i'
}

foreach i of num 1756/1763{
replace war_each="Seven" if year==`i'
}

foreach i of num 1778/1782{
replace war_each="American" if year==`i'
}

foreach i of num 1792/1802{
replace war_each="Revolutionary" if year==`i'
}

foreach i of num 1803/1814{
replace war_each="Napoleonic" if year==`i'
}

foreach i of num 1733/1738{
replace war_all="All" if year==`i'
}
foreach i of num 1740/1748{
replace war_all="All" if year==`i'
}
foreach i of num 1756/1763{
replace war_all="All" if year==`i'
}
foreach i of num 1778/1782{
replace war_all="All" if year==`i'
}
foreach i of num 1792/1802{
replace war_all="All" if year==`i'
}
foreach i of num 1803/1814{
replace war_all="All" if year==`i'
}

label define order  1 Polish  2 Austrian1  3 Austrian2  4 Seven  5 American  6 Revolutionary 7 Napoleonic

encode war_each, gen(each) label(order)
replace each=0 if each==. 

encode war_all, gen(all)
replace all=0 if all==.


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


eststo p1: poisson value year i.all, vce(robust)
eststo p2: poisson value year g2 year2 g3 year3 i.all, vce(robust)
eststo p3: poisson value year g3 year3 i.all, vce(robust)


eststo p4: poisson value year i.each, vce(robust)
eststo p5: poisson value year g2 year2 g3 year3 i.each, vce(robust)
eststo p6: poisson value g3 year3 i.each, vce(robust)

esttab

esttab p1 p3 p4 p6 using "$ete/Thesis/Data/do_files/Hamburg/tex/hamburg1_reg.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(_cons "Constant" 1.all "All" 1.each "Polish" 2.each "Austrian1" 3.each "Austrian2" 4.each "Seven" ///
	5.each "American" 6.each "Revolutionary" 7.each "Napoleonic") drop(0b.all 0b.each year _cons *3) not pr2 nonumbers ///
	 mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(Hamburg Aggregate\label{tab1}) replace
 
eststo clear

******* gen war lags

gen all_war_lag=""

foreach i of num 1/5{
replace all_war_lag="`i' lags All" if year==(1748+`i')
replace all_war_lag="`i' lags All" if year==(1763+`i')
replace all_war_lag="`i' lags All" if year==(1814+`i')
}

encode all_war_lag, gen(all_lag)
replace all_lag=0 if all_lag==.


gen each_war_lag=""

replace each_war_lag="1 lag Austrian2" if year==(1748+1)
replace each_war_lag="1 lag Seven" if year==(1763+1)
replace each_war_lag="1 lag Napoleonic" if year==(1814+1)
foreach i of num 2/5{
replace each_war_lag="`i' lags Austrian2" if year==(1748+`i')
replace each_war_lag="`i' lags Seven" if year==(1763+`i')
replace each_war_lag="`i' lags Napoleonic" if year==(1814+`i')
}

label define order_lag  1 "1 lag Austrian2"  2 "1 lag Seven"  3 "1 lag Napoleonic"  /// 
	4 "2 lags Austrian2"  5 "2 lags Seven"  6 "2 lags Napoleonic" ///
	7 "3 lags Austrian2"  8 "3 lags Seven"  9 "3 lags Napoleonic" ///
	10 "4 lags Austrian2"  11 "4 lags Seven"  12 "4 lags Napoleonic" ///
	13 "5 lags Austrian2"  14 "5 lags Seven"  15 "5 lags Napoleonic" 

encode each_war_lag, gen(each_lag) label(order_lag)
replace each_lag=0 if each_lag==.

eststo: poisson value year i.all i.all_lag, vce(robust)
eststo: poisson value year g3 year3 i.all i.all_lag, vce(robust)

eststo: poisson value year i.each i.each_lag, vce(robust)
eststo: poisson value year g3 year3 i.each i.each_lag, vce(robust)

esttab
esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/hamburg1_lag.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(1.all_lag "1 lag" 2.all_lag "2 lags" 3.all_lag "3 lags" 4.all_lag "4 lags" 5.all_lag "5 lags" ///
	1.each_lag "1 lag Austrian2" 2.each_lag "1 lag Seven" 3.each_lag "1 lag Napoleonic" ///
	4.each_lag "2 lags Austrian2" 5.each_lag "2 lags Seven" 6.each_lag "2 lags Napoleonic" ///
	7.each_lag "3 lags Austrian2" 8.each_lag "3 lags Seven" 9.each_lag "3 lags Napoleonic" ///
	10.each_lag "4 lags Austrian2" 11.each_lag "4 lags Seven" 12.each_lag "4 lags Napoleonic" ///
	13.each_lag "5 lags Austrian2" 14.each_lag "5 lags Seven" 15.each_lag "5 lags Napoleonic") ///
	keep(*all_lag *each_lag) drop(0b.all_lag 0b.each_lag) not pr2 nonumbers ///
	mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(Lags Hamburg Aggregate\label{tab1}) replace	
 
eststo clear

*****gen prewar

gen all_war_pre=""

foreach i of num 1/5{
replace all_war_pre="`i' pre All" if year==(1756-`i')
replace all_war_lag="`i' pre All" if year==(1778-`i')
}

encode all_war_pre, gen(all_pre)
replace all_pre=0 if all_pre==.


gen each_war_pre=""

foreach i of num 1/5{
replace each_war_pre="`i' pre Austrian2" if year==(1748+`i')
replace each_war_pre="`i' pre Seven" if year==(1763+`i')
}

encode each_war_pre, gen(each_pre)
replace each_pre=0 if each_pre==.


eststo: poisson value year i.all i.all_pre, vce(robust)
eststo: poisson value year g3 year3  i.all i.all_pre, vce(robust)

eststo: poisson value year i.each i.each_pre, vce(robust)
eststo: poisson value year g3 year3  i.each i.each_pre, vce(robust)

esttab

esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/hamburg1_pre.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(1.all_pre "1 pre" 2.all_pre "2 pre" 3.all_pre "3 pre" 4.all_pre "4 pre" 5.all_pre "5 pre" ///
	1.each_pre "1 pre Austrian2" 2.each_pre "1 pre Seven" ///
	3.each_pre "2 pre Austrian2" 4.each_pre "2 pre Seven" ///
	5.each_pre "3 pre Austrian2" 6.each_pre "3 pre Seven" ///
	7.each_pre "4 pre Austrian2" 8.each_pre "4 pre Seven" ///
	9.each_pre "5 pre Austrian2" 10.each_pre "5 pre Seven") ///	
	keep(*all_pre *each_pre) drop(0b.all_pre 0b.each_pre) not pr2 nonumbers ///
	mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(Prewar Hamburg Aggregate\label{tab1}) replace	
eststo clear







