
global thesis2 "/Users/Tirindelli/Google Drive/ETE/Thesis2"

set more off

use "$thesis2/database_dta/hamburg1", clear

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

label define order  1 Polish  2 Austrian1  3 Austrian2  4 Seven  5 American  6 Napoleonic 7 Revolutionary

encode war_each, gen(each) label(order)
replace each=0 if each==. 

encode war_all, gen(all)
replace all=0 if all==.

gen year2=(year)^(2)

eststo: xi: poisson value year i.all, vce(robust)
eststo: xi: poisson value year year2 i.all, vce(robust)

eststo: xi: poisson value year i.each, vce(robust)
eststo: xi: poisson value year year2 i.each, vce(robust)

foreach i of num 1/7{
label var _Ieach_`i' "`: label (each) `i'' "
}


esttab using "$thesis2/reg_table/hamburg1/dummies1/dummies1.tex",label order(year year2 _Iall_1) varlab( _Iall_1 "All wars" _cons "Constant") not pr2 nonumbers mtitles("All wars" "Quadratic" "War by war" "Quadratic") title(Regression table\label{tab1}) replace
 
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

foreach i of num 1/5{
replace each_war_lag="`i' lags Austrian2" if year==(1748+`i')
replace each_war_lag="`i' lags Seven" if year==(1763+`i')
replace each_war_lag="`i' lags Napoleaonic" if year==(1814+`i')
}

encode each_war_lag, gen(each_lag)
replace each_lag=0 if each_lag==.


eststo: poisson value year i.all i.all_lag, vce(robust)
eststo: poisson value year year2 i.all i.all_lag, vce(robust)

eststo: poisson value year i.each i.each_lag, vce(robust)
eststo: poisson value year year2 i.each i.each_lag, vce(robust)

esttab using "$thesis2/reg_table/hamburg1/lag1/lag1.tex",label noomitted drop(0.*) order(year year2 _Iall_1) varlab( _Iall_1 "All wars" _cons "Constant") not pr2 nonumbers mtitles("All wars" "Quadratic" "War by war" "Quadratic") title(Regression table\label{tab1}) replace
 
eststo clear


*****gen prewar

gen all_war_pre=""

foreach i of num 1/5{
replace all_war_pre="`i' lags All" if year==(1756-`i')
replace all_war_lag="`i' lags All" if year==(1778-`i')
}

encode all_war_pre, gen(all_pre)
replace all_pre=0 if all_pre==.


gen each_war_pre=""

foreach i of num 1/5{
replace each_war_pre="`i' lags Austrian2" if year==(1748+`i')
replace each_war_pre="`i' lags Seven" if year==(1763+`i')
}

encode each_war_pre, gen(each_pre)
replace each_pre=0 if each_pre==.


eststo: poisson value year i.all i.all_pre, vce(robust)
eststo: poisson value year year2 i.all i.all_pre, vce(robust)

eststo: poisson value year i.each i.each_pre, vce(robust)
eststo: poisson value year year2 i.each i.each_pre, vce(robust)

esttab using "$thesis2/reg_table/hamburg1/pre1/pre1.tex",label noomitted drop(0.*) order(year year2 _Iall_1) varlab( _Iall_1 "All wars" _cons "Constant") not pr2 nonumbers mtitles("All wars" "Quadratic" "War by war" "Quadratic") title(Regression table\label{tab1}) replace
 
eststo clear







