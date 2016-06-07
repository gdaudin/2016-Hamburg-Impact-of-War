clear

global thesis2 "/Users/Tirindelli/Google Drive/ETE/Thesis2"

set more off

use "$thesis2/database_dta/hamburg2"

drop if value==.
drop pays_regroupes
drop if year<1733
label define order_class 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order_class)

****GEN 7 WAR DUMMIES	
gen war_each=""

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

****gen one dummy for all wars
gen war_all=""
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

label define order_war  1 Polish  2 Austrian1  3 Austrian2  4 Seven  5 American  6 Napoleonic 7 Revolutionary

encode war_each, gen(each) label(order_war)
egen each_class=group(each class), label
replace each=0 if each==.
replace each_class=0 if each_class==.

encode war_all, gen(all)
egen all_class=group(all class), label
replace all=0 if all==.
replace all_class=0 if all_class==.


foreach i of num 1/5{
gen year_class`i'=0
replace year_class`i'=year if class==`i'
}

foreach i of num 1/5{
gen year2_class`i'=0
replace year2_class`i'=(year_class`i')^(2) if class==`i'
}

gen year2=(year)^(2)

local macro 5.* 10.* 15.* 20.* 25.* 30.* 35.*

****reg all wars
eststo: poisson value i.class year_class1-year_class5 i.all_class, vce(robust)
eststo: poisson value i.class year_class1-year_class5 year2_class1-year2_class5 i.all_class, vce(robust)


****reg each war separately
eststo: poisson value i.class year_class1-year_class5 i.each_class, vce(robust)
eststo: poisson value i.class year_class1-year_class5 year2_class1-year2_class5 i.each_class, vce(robust)

esttab using "$thesis2/reg_table/hamburg2/dummies1/dummies1.tex",label noomitted varlab( _cons "Cons") not indicate("Product FE= *.class" "Product time trend=*year_class*" "Quadratic trend= *year2_class*") drop(0.* `macro') pr2 nonumbers mtitles("All wars" "Quadratic" "War by war" "Qaudratic" "Quadratic") title(Regression table\label{tab1}) replace
eststo clear

****gen war lags
gen all_war_lag=""

foreach i of num 1/5{
replace all_war_lag="`i' lags All" if year==(1748+`i')
replace all_war_lag="`i' lags All" if year==(1763+`i')
replace all_war_lag="`i' lags All" if year==(1814+`i')
}

encode all_war_lag, gen(all_lag)
egen all_lag_class=group(all_lag class), label
replace all_lag=0 if all_lag==.
replace all_lag_class=0 if all_lag_class==.


gen each_war_lag=""

foreach i of num 1/5{
replace each_war_lag="`i' lags Austrian2" if year==(1748+`i')
replace each_war_lag="`i' lags Seven" if year==(1763+`i')
replace each_war_lag="`i' lags Napoleaonic" if year==(1814+`i')
}

encode each_war_lag, gen(each_lag)
egen each_lag_class=group(each_lag class), label
replace each_lag=0 if each_lag==.
replace each_lag_class=0 if each_lag_class==.

local macro1 5.each_lag_class 8.each_lag_class 13.each_lag_class 18.each_lag_class 23.each_lag_class 28.* 33.* 37.* 42.* 47.* 50.* 55.* 60.* 64.* 69.* 
local macro2 5.* 10.* 15.* 20.* 25.*
eststo: poisson value i.class year_class1-year_class5 i.all_class i.all_lag_class, vce(robust)
*eststo: poisson value i.class year_class1-year_class5 year2_class1-year2_class5 i.all_class i.all_lag_class, vce(robust)

eststo: poisson value i.class year_class1-year_class5 i.each_class i.each_lag_class, vce(robust)
*eststo: poisson value i.class year_class1-year_class5 year2_class1-year2_class5 i.each_class i.each_lag_class, vce(robust)

esttab using "$thesis2/reg_table/hamburg2/lag1/lag1.tex",label longtable noomitted varlab( _cons "Cons") not indicate("Product FE= *.class" "Product time trend=*year_class*") drop(0.* `macro1' `macro2' *each_class* *all_class*) pr2 nonumbers mtitles("All wars" "War by war") title(Regression table\label{tab1}) replace

eststo clear

****gen prewar effects

gen all_war_pre=""

foreach i of num 1/4{
replace all_war_pre="`i' pre All" if year==(1756-`i')
replace all_war_pre="`i' pre All" if year==(1778-`i')
replace all_war_pre="`i' pre All" if year==(1792-`i')
}

encode all_war_pre, gen(all_pre)
egen all_pre_class=group(all_pre class), label
replace all_pre=0 if all_pre==.
replace all_pre_class=0 if all_pre_class==.



gen each_war_pre=""

foreach i of num 1/4{
replace each_war_pre="`i' pre Seven" if year==(1756-`i')
replace each_war_pre="`i' pre America" if year==(1778-`i')
replace each_war_pre="`i' pre Revolutionary" if year==(1792-`i')
}

encode each_war_pre, gen(each_pre)
egen each_pre_class=group(each_pre class), label
replace each_pre=0 if each_pre==.
replace each_pre_class=0 if each_pre_class==.

local macro 5.* 10.* 15.* 20.* 25.* 30.* 35.* 40.* 45.* 50.*

eststo: poisson value i.class year_class1-year_class5 i.all_class i.all_pre_class, vce(robust)
eststo: poisson value i.class year_class1-year_class5 year2_class1-year2_class5 i.all_class i.all_pre_class, vce(robust)

eststo: poisson value i.class year_class1-year_class5 i.each_class i.each_pre_class, vce(robust)
eststo: poisson value i.class year_class1-year_class5 year2_class1-year2_class5 i.each_class i.each_pre_class, vce(robust)

esttab using "$thesis2/reg_table/hamburg2/pre1/pre1.tex",label longtable noomitted varlab( _cons "Cons") not indicate("Product FE= *.class" "Product time trend=*year_class*" "Quadratic trend= *year2_class*") drop(0.* `macro' *each_class* *all_class*) pr2 nonumbers mtitles("All wars" "Quadratic" "War by war" "Quadratic") title(Regression table\label{tab1}) replace

eststo clear
















