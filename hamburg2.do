clear

*global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"

set more off

use "$thesis/database_dta/hamburg2", clear

drop if value==.
drop if year<1733
label define order_class 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order_class)

label var value Value

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
replace war_all="War" if year==`i'
}

foreach i of num 1740/1748{
replace war_all="War" if year==`i'
}

foreach i of num 1756/1763{
replace war_all="War" if year==`i'
}
foreach i of num 1778/1782{
replace war_all="War" if year==`i'
}

foreach i of num 1792/1802{
replace war_all="War" if year==`i'
}

foreach i of num 1803/1814{
replace war_all="War" if year==`i'
}

replace war_all="Peace" if war_all==""

label define order_war  1 Polish  2 Austrian1  3 Austrian2  4 Seven  5 American  6 Revolutionary 7 Napoleonic

encode war_each, gen(each) label(order_war)
egen each_class=group(each class), label
replace each_class=0 if each_class==.

encode war_all, gen(all)
egen all_class=group(all class), label
*replace all=0 if all==.
replace all_class=0 if all_class==.

foreach i of num 1/5{
gen year_class`i'=0
replace year_class`i'=year if class==`i'
}

/*gen year2=(year)^(2)

foreach i of num 1/5{
gen year2_class`i'=0
replace year2_class`i'=year2*class if class==`i'
}
*/

gen c1=(year<1745 & class==1)
gen c2=(year>1744 & year<1790 & class==1)
gen c3=(year>1795 & class==1)

gen s1=(year<1745 & class==3)
gen s2=(year>1744 & year<1790 & class==3)
gen s3=(year>1795 & class==3)

foreach i of num 1/3{
gen year_c`i'=year_class1*c`i'
gen year_s`i'=year_class3*s`i'
}


****reg all wars
eststo: poisson value i.class year_class1-year_class5 i.all#i.class, vce(robust)
*eststo: poisson value i.class year_class1-year_class5 c2 year_c2 c3 year_c3 s2 year_s2 s3 year_s3 i.all_class, noconstant vce(robust) iterate(40)
eststo: poisson value i.class year_class1-year_class5 c2 year_c2 i.all#i.class, vce(robust) iterate(40)
eststo: poisson value i.class year_class1-year_class5 c3 year_c3 s3 year_s3 i.all#i.class, vce(robust)

esttab, label

esttab using "$thesis/Data/do_files/Hamburg/tex/hamburg2_all_reg.tex", label booktabs alignment(D{.}{.}{-1}) ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Break Coffee=*year_c*" "Break Sugar=*year_s*") ///
	varlab( _cons "Cons" 1.all_class "Coffee" 2.all_class "Eau de vie" 3.all_class "Sugar" 4.all_class "Wine") ///
	keep(1.all_class 2.all_class 3.all_class 4.all_class) pr2 not nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	title(Hamburg: All wars on each product\label{tab1}) replace
eststo clear

****reg each war separately
eststo: poisson value i.class year_class1-year_class5 i.each_class, vce(robust)
eststo: poisson value i.class year_class1-year_class5 c2 year_c2 i.each_class, vce(robust) iterate(40)
eststo: poisson value i.class year_class1-year_class5 c3 year_c3 s3 year_s3 i.each_class, vce(robust)

esttab, label
local macro 5.* 10.* 15.* 20.* 25.* 30.* 35.* s* c*
esttab using "$thesis/Data/do_files/Hamburg/tex/hamburg2_each_reg.tex",label alignment(D{.}{.}{-1}) not ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Break Coffee=*year_c*" "Break Sugar=*year_s*") ///
	varlab(_cons "Cons" 1.each_class "Polish Coffee" 2.each_class "Polish Eau de vie" 3.each_class "Polish Sugar" 4.each_class "Polish Wine" ///
	6.each_class "Austrian1 Coffee" 7.each_class "Austrian1 Eau de vie" 8.each_class "Austrian1 Sugar" 9.each_class "Austrian1 Wine" ///
	11.each_class "Austrian2 Coffee" 12.each_class "Austrian2 Eau de vie" 13.each_class "Austrian2 Sugar" 14.each_class "Austrian2 Wine" ///
	16.each_class "Seven Coffee" 17.each_class "Seven Eau de vie" 18.each_class "Seven Sugar" 19.each_class "Seven Wine" ///
	21.each_class "American Coffee" 22.each_class "American Eau de vie" 23.each_class "American Sugar" 24.each_class "American Wine" ///
	26.each_class "Revolutionary Coffee" 27.each_class "Revolutionary Eau de vie" 28.each_class "Revolutionary Sugar" 29.each_class "Revolutionary Wine" ///
	31.each_class "Napoleonic Coffee" 32.each_class "Napoleonic Eau de vie" 33.each_class "Napoleonic Sugar" 34.each_class "Napoleonic Wine") ///
	drop(`macro') pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	title(Hamburg: Each wars on each product\label{tab1}) replace

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
egen each_lag_class=group(each_lag class), label
replace each_lag=0 if each_lag==.
replace each_lag_class=0 if each_lag_class==.

local macro 5.* 10.* 15.* 20.* 25.* c* s*
eststo: poisson value i.class year_class1-year_class5 i.all_class i.all_lag_class, vce(robust)
eststo: poisson value i.class year_class1-year_class5 c3 year_c3 i.all_class i.all_lag_class, vce(robust) iterate(40)
eststo: poisson value i.class year_class1-year_class5 c3 year_c3 s3 year_s3 i.all_class i.all_lag_class, vce(robust)

esttab using "$thesis/Data/do_files/Hamburg/tex/hamburg2_all_lag.tex",label alignment(D{.}{.}{-1}) not ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Break Coffee=*year_c*" "Break Sugar=*year_s*") varlab( _cons "Cons" ///
	1.all_lag_class "1 lag Coffee" 2.all_lag_class "1 lag Eau de vie" 3.all_lag_class "1 lag Sugar" 4.all_lag_class "1 lag Wine" ///
	6.all_lag_class "2 lags Coffee" 7.all_lag_class "2 lags Eau de vie" 8.all_lag_class "2 lags Sugar" 9.all_lag_class "2 lags Wine" ///
	11.all_lag_class "3 lags Coffee" 12.all_lag_class "3 lags Eau de vie" 13.all_lag_class "3 lags Sugar" 14.all_lag_class "3 lags Wine" ///
	16.all_lag_class "4 lags Coffee" 17.all_lag_class "4 lags Eau de vie" 18.all_lag_class "4 lags Sugar" 19.all_lag_class "4 lags Wine" ///
	21.all_lag_class "5 lags Coffee" 22.all_lag_class "5 lags Eau de vie" 23.all_lag_class "5 lags Sugar" 24.all_lag_class "5 lags Wine") ///
	drop(*.all_class `macro') pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	title(Hamburg: Lag of all wars on each product\label{tab1}) replace
eststo clear	

eststo: poisson value i.class year_class1-year_class5 i.each_class i.each_lag_class, vce(robust)
eststo: poisson value i.class year_class1-year_class5 c2 year_c2 i.each_class i.each_lag_class, vce(robust) iterate(40)
eststo: poisson value i.class year_class1-year_class5 c3 year_c3 s3 year_s3 i.each_class i.each_lag_class, vce(robust)

local macro 5.each_lag_class 10.each_lag_class 13.each_lag_class 18.each_lag_class 23.each_lag_class 28.* 33.* 38.* 42.* 47.* 52.* 55.* 60.* 65.* 69.* 
/*esttab using "$thesis2/reg_table/hamburg2/lag1/lag1.tex",label booktabs longtable noomitted varlab( _cons "Constant") not ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Chow test Coffee=*year_c*" "Chow test Sugar=*year_s*") ///
	drop(0.* `macro1' `macro2' *each_class* *all_class*) pr2 nonumbers mtitles("All wars" "All wars" "War by war" "War by war") ///
	title(Regression table\label{tab1}) replace
*/	
esttab using "$thesis/Data/do_files/Hamburg/tex/hamburg2_each_lag.tex",label alignment(D{.}{.}{-1}) not longtable ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Break Coffee=*year_c*" "Break Sugar=*year_s*") varlab(_cons "Cons" ///
	1.each_lag_class "1 lag Austrian2 Coffee" 2.each_lag_class "1 lag Austrian2 Eau de vie" 3.each_lag_class "1 lag Austrian2 Sugar" 4.each_lag_class "1 lag Austrian2 Wine" ///
	6.each_lag_class "1 lag Seven Coffee" 7.each_lag_class "1 lag Seven Eau de vie"  8.each_lag_class "1 lag Seven Sugar" 9.each_lag_class "1 lag Seven Wine" ///
	11.each_lag_class "1 lag Napoleonic Eau de vie" 12.each_lag_class "1 lag Napoleonic Wine" ///
	14.each_lag_class "2 lags Austrian2 Coffee" 15.each_lag_class "2 lags Austrian2 Eau de vie" 16.each_lag_class "2 lags Austrian2 Sugar" 17.each_lag_class "2 lags Austrian2 Wine" ///
	19.each_lag_class "2 lags Seven Coffee" 20.each_lag_class "2 lags Seven Eau de vie"  21.each_lag_class "2 lags Seven Sugar" 22.each_lag_class "2 lags Seven Wine" ///
	24.each_lag_class "2 lags Napoleonic Coffee" 25.each_lag_class "2 lags Napoleonic Eau de vie"  26.each_lag_class "2 lags Napoleonic Sugar" 27.each_lag_class "2 lags Napoleonic Wine" ///
	29.each_lag_class "3 lags Austrian2 Coffee" 30.each_lag_class "3 lags Austrian2 Eau de vie" 31.each_lag_class "3 lags Austrian2 Sugar" 32.each_lag_class "3 lags Austrian2 Wine" ///
	34.each_lag_class "3 lags Seven Coffee" 35.each_lag_class "3 lags Seven Eau de vie"  36.each_lag_class "3 lags Seven Sugar" 37.each_lag_class "3 lags Seven Wine" ///
	39.each_lag_class "3 lags Napoleonic Coffee" 40.each_lag_class "3 lags Napoleonic Eau de vie" 41.each_lag_class "3 lags Napoleonic Wine" ///
	43.each_lag_class "4 lags Austrian2 Coffee" 44.each_lag_class "4 lags Austrian2 Eau de vie" 45.each_lag_class "4 lags Austrian2 Sugar" 46.each_lag_class "4 lags Austrian2 Wine" ///
	48.each_lag_class "4 lags Seven Coffee" 49.each_lag_class "4 lags Seven Eau de vie"  50.each_lag_class "4 lags Seven Sugar" 51.each_lag_class "4 lags Seven Wine" ///
	53.each_lag_class "4 lags Napoleonic Eau de vie" 54.each_lag_class "4 lags Napoleonic Wine" ///
	56.each_lag_class "5 lags Austrian2 Coffee" 57.each_lag_class "5 lags Austrian2 Eau de vie" 58.each_lag_class "5 lags Austrian2 Sugar" 59.each_lag_class "5 lags Austrian2 Wine" ///
	61.each_lag_class "5 lags Seven Coffee" 62.each_lag_class "5 lags Seven Eau de vie"  63.each_lag_class "5 lags Seven Sugar" 64.each_lag_class "5 lags Seven Wine" ///
	66.each_lag_class "5 lags Napoleonic Eau de vie" 67.each_lag_class "5 lags Napoleonic Sugar" 68.each_lag_class "5 lags Napoleonic Wine") ///
	drop(`macro' *.each_class c* s* 39o.*) pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	title(Hamburg: Lag of each wars on each product\label{tab1}) replace

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
replace each_war_pre="`i' pre American" if year==(1778-`i')
*replace each_war_pre="`i' pre Revolutionary" if year==(1792-`i')
}
label define order_pre  1 "1 pre Seven"  2 "1 pre American" /// 
	3 "2 pre Seven"  4 "2 pre American" ///
	5 "3 pre Seven"  6 "3 pre American"  ///
	7 "4 pre Seven"  8 "4 pre American" 
	
encode each_war_pre, gen(each_pre) label(order_pre)
egen each_pre_class=group(each_pre class), label
replace each_pre=0 if each_pre==.
replace each_pre_class=0 if each_pre_class==.


eststo: poisson value i.class year_class1-year_class5 i.all_class i.all_pre_class, vce(robust)
eststo: poisson value i.class year_class1-year_class5 c3 year_c3 i.all_class i.all_pre_class, vce(robust) iterate(40)
eststo: poisson value i.class year_class1-year_class5 c3 year_c3 s3 year_s3 i.all_class i.all_pre_class, vce(robust)
local macro 5.* 10.* 15.* 20.* c* s*
esttab using "$thesis/Data/do_files/Hamburg/tex/hamburg2_all_pre.tex",label alignment(D{.}{.}{-1}) not ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Break Coffee=*year_c*" "Break Sugar=*year_s*") varlab( _cons "Cons" ///
	1.all_pre_class "1 pre Coffee" 2.all_pre_class "1 pre Eau de vie" 3.all_pre_class "1 pre Sugar" 4.all_pre_class "1 pre Wine" ///
	6.all_pre_class "2 pre Coffee" 7.all_pre_class "2 pre Eau de vie" 8.all_pre_class "2 pre Sugar" 9.all_pre_class "2 pre Wine" ///
	11.all_pre_class "3 pre Coffee" 12.all_pre_class "3 pre Eau de vie" 13.all_pre_class "3 pre Sugar" 14.all_pre_class "3 pre Wine" ///
	16.all_pre_class "4 pre Coffee" 17.all_pre_class "4 pre Eau de vie" 18.all_pre_class "4 pre Sugar" 19.all_pre_class "4 pre Wine") ///
	drop(*.all_class `macro') pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	title(Hamburg: Pre of all wars on each product\label{tab1}) replace
eststo clear

eststo: poisson value i.class year_class1-year_class5 i.each_class i.each_pre_class, vce(robust)
eststo: poisson value i.class year_class1-year_class5 c3 year_c3 i.each_pre_class, vce(robust) iterate(40)
eststo: poisson value i.class year_class1-year_class5 c3 year_c3 s3 year_s3 i.each_class i.each_pre_class, vce(robust)
local macro 5.* 10.* 15.* 20.* 25.* 30.* 35.* 40.* c* s*
esttab using "$thesis/Data/do_files/Hamburg/tex/hamburg2_each_pre.tex", label booktabs longtable alignment(D{.}{.}{-1}) not ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Chow test Coffee=*year_c*" "Chow test Sugar=*year_s*") varlab(_cons "Constant"  ///
	1.each_pre_class "1 pre Seven Coffee" 2.each_pre_class "1 pre Seven Eau de vie" 3.each_pre_class "1 pre Seven Sugar" 4.each_pre_class "1 pre Seven Wine"  ///
	6.each_pre_class "1 pre American Coffee" 7.each_pre_class "1 pre American Eau de vie" 8.each_pre_class "1 pre American Sugar" 9.each_pre_class "1 pre American Wine"  ///
	11.each_pre_class "2 pre Seven Coffee" 12.each_pre_class "2 pre Seven Eau de vie" 13.each_pre_class "2 pre Seven Sugar" 14.each_pre_class "2 pre Seven Wine"  ///
	16.each_pre_class "2 pre American Coffee" 17.each_pre_class "2 pre American Eau de vie" 18.each_pre_class "2 pre American Sugar" 19.each_pre_class "2 pre American Wine"  ///
	21.each_pre_class "3 pre Seven Coffee" 22.each_pre_class "3 pre Seven Eau de vie" 23.each_pre_class "3 pre Seven Sugar" 24.each_pre_class "3 pre Seven Wine"  ///
	26.each_pre_class "3 pre American Coffee" 27.each_pre_class "3 pre American Eau de vie" 28.each_pre_class "3 pre American Sugar" 29.each_pre_class "3 pre American Wine"  ///
	31.each_pre_class "4 pre Seven Coffee" 32.each_pre_class "4 pre Seven Eau de vie" 33.each_pre_class "4 pre Seven Sugar" 34.each_pre_class "4 pre Seven Wine"  ///
	36.each_pre_class "4 pre American Coffee" 37.each_pre_class "4 pre American Eau de vie" 38.each_pre_class "4 pre American Sugar" 39.each_pre_class "4 pre American Wine")  ///
	drop(`macro' *each_class*) pr2 nonumbers mtitles("No breaks" "One breaks" "Two breaks") ///
	title(Hamburg: Pre of each wars on each product\label{tab1}) replace

eststo clear
















