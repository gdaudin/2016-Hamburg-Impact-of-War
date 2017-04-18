******hamburg1


/*
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
esttab using "$thesis/Data/do_files/Hamburg/tex/hamburg1_lag.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(1.all_lag "1 lag" 2.all_lag "2 lags" 3.all_lag "3 lags" 4.all_lag "4 lags" 5.all_lag "5 lags" ///
	1.each_lag "1 lag Austrian2" 2.each_lag "1 lag Seven" 3.each_lag "1 lag Napoleonic" ///
	4.each_lag "2 lags Austrian2" 5.each_lag "2 lags Seven" 6.each_lag "2 lags Napoleonic" ///
	7.each_lag "3 lags Austrian2" 8.each_lag "3 lags Seven" 9.each_lag "3 lags Napoleonic" ///
	10.each_lag "4 lags Austrian2" 11.each_lag "4 lags Seven" 12.each_lag "4 lags Napoleonic" ///
	13.each_lag "5 lags Austrian2" 14.each_lag "5 lags Seven" 15.each_lag "5 lags Napoleonic") ///
	keep(*all_lag *each_lag) not pr2 nonumbers ///
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

esttab using "$thesis/Data/do_files/Hamburg/tex/hamburg1_pre.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(1.all_pre "1 pre" 2.all_pre "2 pre" 3.all_pre "3 pre" 4.all_pre "4 pre" 5.all_pre "5 pre" ///
	1.each_pre "1 pre Austrian2" 2.each_pre "1 pre Seven" ///
	3.each_pre "2 pre Austrian2" 4.each_pre "2 pre Seven" ///
	5.each_pre "3 pre Austrian2" 6.each_pre "3 pre Seven" ///
	7.each_pre "4 pre Austrian2" 8.each_pre "4 pre Seven" ///
	9.each_pre "5 pre Austrian2" 10.each_pre "5 pre Seven") ///	
	keep(*all_pre *each_pre) not pr2 nonumbers ///
	mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(Prewar Hamburg Aggregate\label{tab1}) replace	
eststo clear

*****hamburg2

/*
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


******allcountry1

/*
****gen war lags

gen each_war_lag=""
foreach i of num 1/5{
****austrian
replace each_war_lag="`i' lags Austrian2 adversary" if pays_grouping=="Angleterre" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 adversary" if pays_grouping=="Hollande" & year==1748+`i'

replace each_war_lag="`i' lags Austrian2 neutral" if pays_grouping=="Levats" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_grouping=="Nord" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_grouping=="Suisse" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_grouping=="Italie" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_grouping=="Portugal" & year==1748+`i'

replace each_war_lag="`i' lags Austrian2 allies" if each_war_lag=="" & year==1748+`i'


****seven
replace each_war_lag="`i' lags Seven adversary" if pays_grouping=="Angleterre" & year==1763+`i'
replace each_war_lag="`i' lags Seven adversary" if pays_grouping=="Portugal" & year==1763+`i'

replace each_war_lag="`i' lags Seven neutral" if pays_grouping=="Hollande" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_grouping=="Italie" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_grouping=="Levant" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_grouping=="Nord" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_grouping=="Suisse" & year==1763+`i'

replace each_war_lag="`i' lags Seven allies" if each_war_lag=="" & year==1763+`i'

****napoleonic
replace each_war_lag="`i' lags Napoleonic adversary" if pays_grouping=="Angleterre" & year==1814+`i'

replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Italue" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Levant" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Nord" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Suisse" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Portuga" & year==1814+`i'

replace each_war_lag="`i' lags Napoleonic allies" if each_war_lag=="" & year==1814+`i'
}

gen all_war_lag=""
foreach i of num 1/5{
***austrian
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Angleterre" & year==1748+`i'
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1748+`i'
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Hollande" & year==1748+`i'

replace all_war_lag="`i' lags Neutral" if pays_grouping=="Levats" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Nord" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Suisse" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Italie" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Portugal" & year==1748+`i'

replace all_war_lag="`i' lags Allies" if all_war_lag=="" & year==1748+`i'

***seven
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Angleterre" & year==1763+`i'
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Portugal" & year==1763+`i'

replace all_war_lag="`i' lags Neutral" if pays_grouping=="Hollande" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Italie" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Levant" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Nord" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Suisse" & year==1763+`i'

replace all_war_lag="`i' lags Allies" if all_war_lag=="" & year==1763+`i'


***napoleonic
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Angleterre" & year==1814+`i'

replace all_war_lag="`i' lags Neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Italue" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Levant" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Nord" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Suisse" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Portugal" & year==1814+`i'

replace all_war_lag="`i' lags Allies" if all_war_lag=="" & year==1814+`i'
}

label define order_lag  1 "1 lags Austrian2 neutral"  2 "2 lags Austrian2 neutral"  3 "3 lags Austrian2 neutral" ///
	4 "4 lags Austrian2 neutral" 5 "5 lags Austrian2 neutral"  ///
	6 "1 lags Seven neutral" 7 "2 lags Seven neutral"  8 "3 lags Seven neutral"  ///
	9 "4 lags Seven neutral"  10 "5 lags Seven neutral" ///
	11 "1 lags Napoleonic neutral" 12 "2 lags Napoleonic neutral" 13 "3 lags Napoleonic neutral" ///
	14 "4 lags Napoleonic neutral" 15 "5 lags Napoleonic neutral"  ///
	
encode each_war_lag, gen(each_lag) label(order_lag)
replace each_lag=0 if each_lag==.
encode all_war_lag, gen(all_lag)
replace all_lag=0 if all_lag==.

****reg with lags all wars
eststo: poisson value year_pays1-year_pays12 i.pays i.all_status i.all_lag, vce(robust)
eststo: poisson value year_pays1-year_pays12 i.pays break#pays break_year_pays1-break_year_pays12 i.all_status i.all_lag, vce(robust)
*eststo: poisson value i.pays year_pays1-year_pays12 country5-country11 i.all_status, vce(robust) difficult 

eststo: poisson value year_pays1-year_pays12 i.pays i.each_status i.each_lag, vce(robust)
eststo: poisson value year_pays1-year_pays12 i.pays break#pays break_year_pays1-break_year_pays12 i.each_status i.each_lag, vce(robust)

local macro 1.each_lag 2.each_lag 3.each_lag 4.each_lag 5.each_lag 6.each_lag 7.each_lag 8.each_lag 9.each_lag 10.each_lag ///
	 11.each_lag 12.each_lag 13.each_lag 14.each_lag 15.each_lag
esttab using "$thesis/Data/do_files/Hamburg/tex/allcountry1_lag.tex", label not alignment(D{.}{.}{-1}) ///
	indicate("Country FE= *.pays" "Country time trend=year_pays*" "Chow test=*break_year_pays*") varlab( _cons "Cons" ///
	3.all_lag "1 lag neutral" 6.all_lag "2 lags neutral" 9.all_lag "3 lags neutral" 12.all_lag "4 lags neutral" 15.all_lag "5 lags neutral" ///
	1.each_lag "1 lag Austrian2 neutral" 2.each_lag "2 lags Austrian2 neutral" 3.each_lag "3 lags Austrian2 neutral" ///
	4.each_lag "4 lags Austrian2 neutral" 5.each_lag "5 lags Austrian2 neutral" ///
	6.each_lag "1 lag Seven neutral" 7.each_lag "2 lags Seven neutral" 8.each_lag "3 lags Seven neutral" ///
	9.each_lag "4 lags Seven neutral" 10.each_lag "5 lags Seven neutral" ///
	11.each_lag "1 lag Napoleonic neutral" 12.each_lag "2 lags Napoleonic neutral" 13.each_lag "3 lags Napoleonic neutral" ///
	14.each_lag "4 lags Napoleonic neutral" 15.each_lag "5 lags Napoleonic neutral") ///
	keep(3.all_lag 6.all_lag 9.all_lag 12.all_lag 15.all_lag `macro') ///
	pr2 nonumbers mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(All countries: lags\label{tab1}) replace
eststo clear

****gen prewar effects

gen each_war_pre=""
foreach i of num 1/4{
****seven
replace each_war_pre="`i' pre 4Seven adversary" if pays_grouping=="Angleterre" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven adversary" if pays_grouping=="Hollande" & year==1756-`i'

replace each_war_pre="`i' pre 4Seven neutral" if pays_grouping=="Levats" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_grouping=="Nord" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_grouping=="Suisse" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_grouping=="Italie" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_grouping=="Portugal" & year==1756-`i'

****american
replace each_war_pre="`i' pre 5American adversary" if pays_grouping=="Angleterre" & year==1778-`i'
replace each_war_pre="`i' pre 5American adversary" if pays_grouping=="Portugal" & year==1778-`i'

replace each_war_pre="`i' pre 5American neutral" if pays_grouping=="Hollande" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_grouping=="Italie" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_grouping=="Levant" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_grouping=="Nord" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_grouping=="Suisse" & year==1778-`i'

****revolutionary
replace each_war_pre="`i' pre 6Revolutionary adversary" if pays_grouping=="Angleterre" & year==1792-`i'

replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_grouping=="Italue" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_grouping=="Levant" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_grouping=="Nord" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_grouping=="Suisse" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_grouping=="Portugal" & year==1792-`i'
}

gen all_war_pre=""
foreach i of num 1/4{
***seven
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Angleterre" & year==1756-`i'
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1756-`i'
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Hollande" & year==1756-`i'

replace all_war_pre="`i' pre Neutral" if pays_grouping=="Levats" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Nord" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Suisse" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Italie" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Portugal" & year==1756-`i'

***american
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Angleterre" & year==1778-`i'
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Portugal" & year==1778-`i'

replace all_war_pre="`i' pre Neutral" if pays_grouping=="Hollande" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Italie" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Levant" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Nord" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Suisse" & year==1778-`i'

***revolutionary
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Angleterre" & year==1792+`i'

replace all_war_pre="`i' pre Neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Italue" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Levant" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Nord" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Suisse" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Portugal" & year==1792-`i'
}

encode each_war_pre, gen(each_pre)
replace each_pre=0 if each_pre==.
encode all_war_pre, gen(all_pre)
replace all_pre=0 if all_pre==.


****reg with prewar

eststo: poisson value year i.pays i.all_status i.all_pre, vce(robust)
eststo: poisson value year i.pays year_pays1-year_pays11 i.all_status  i.all_pre, vce(robust)

****reg with lags each wars
eststo: poisson value year i.pays i.each_status i.each_pre, vce(robust)
eststo: poisson value year i.pays year_pays1-year_pays11 i.each_status i.each_pre, vce(robust)

/*
esttab using "$thesis2/reg_table/allcountry1/pre1/pre1.tex",label ///
noomitted varlab( _cons "Cons") not indicate("Country FE= *.pays" ///
"Country time trend=*year_pays*"  "Country quadratic trend=*year2_pays*" ///
"Total quadratic trend=year2") drop(0.* 5.* year *each_status* *all_status*) ///
pr2 nonumbers mtitles("All wars" "Quadratic" "Quadratic" "War by war" ///
"Quadratic" "Qaudratic") title(Regression table\label{tab1}) replace
*/

eststo clear






******allcountry2

/*
****gen war lags

gen each_war_lag=""
foreach i of num 1/5{
****austrian
replace each_war_lag="`i' lags Austrian2 adversary" if pays_grouping=="Angleterre" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 adversary" if pays_grouping=="Hollande" & year==1748+`i'

replace each_war_lag="`i' lags Austrian2 neutral" if pays_grouping=="Levats" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_grouping=="Nord" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_grouping=="Suisse" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_grouping=="Italie" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_grouping=="Portugal" & year==1748+`i'

replace each_war_lag="`i' lags Austrian2 allies" if each_war_lag=="" & year==1748+`i'

****seven
replace each_war_lag="`i' lags Seven adversary" if pays_grouping=="Angleterre" & year==1763+`i'
replace each_war_lag="`i' lags Seven adversary" if pays_grouping=="Portugal" & year==1763+`i'

replace each_war_lag="`i' lags Seven neutral" if pays_grouping=="Hollande" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_grouping=="Italie" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_grouping=="Levant" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_grouping=="Nord" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_grouping=="Suisse" & year==1763+`i'

replace each_war_lag="`i' lags Seven allies" if each_war_lag=="" & year==1763+`i'

****napoleonic
replace each_war_lag="`i' lags Napoleonic adversary" if pays_grouping=="Angleterre" & year==1814+`i'

replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Italue" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Levant" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Nord" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Suisse" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_grouping=="Portuga" & year==1814+`i'

replace each_war_lag="`i' lags Napoleonic allies" if each_war_lag=="" & year==1814+`i'
}

gen all_war_lag=""
foreach i of num 1/5{
***austrian
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Angleterre" & year==1748+`i'
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1748+`i'
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Hollande" & year==1748+`i'

replace all_war_lag="`i' lags Neutral" if pays_grouping=="Levats" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Nord" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Suisse" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Italie" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Portugal" & year==1748+`i'

replace all_war_lag="`i' lags Allies" if all_war_lag=="" & year==1748+`i'

***seven
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Angleterre" & year==1763+`i'
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Portugal" & year==1763+`i'

replace all_war_lag="`i' lags Neutral" if pays_grouping=="Hollande" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Italie" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Levant" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Nord" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Suisse" & year==1763+`i'

replace all_war_lag="`i' lags Allies" if all_war_lag=="" & year==1763+`i'

***napoleonic
replace all_war_lag="`i' lags Adversary" if pays_grouping=="Angleterre" & year==1814+`i'

replace all_war_lag="`i' lags Neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Italue" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Levant" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Nord" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Suisse" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_grouping=="Portugal" & year==1814+`i'

replace all_war_lag="`i' lags Allies" if all_war_lag=="" & year==1814+`i'
}

label define order_each_lag  1 "1 lags Austrian2 neutral"  2 "2 lags Austrian2 neutral"  3 "3 lags Austrian2 neutral" ///
	4 "4 lags Austrian2 neutral" 5 "5 lags Austrian2 neutral"  ///
	6 "1 lags Seven neutral" 7 "2 lags Seven neutral"  8 "3 lags Seven neutral"  ///
	9 "4 lags Seven neutral"  10 "5 lags Seven neutral" ///
	11 "1 lags Napoleonic neutral" 12 "2 lags Napoleonic neutral" 13 "3 lags Napoleonic neutral" ///
	14 "4 lags Napoleonic neutral" 15 "5 lags Napoleonic neutral"  ///

encode each_war_lag, gen(each_lag) label(order_each_lag)
egen each_lag_class=group(each_lag class), label
replace each_lag=0 if each_lag==.
replace each_lag_class=0 if each_lag_class==.

label define order_all_lag  1 "1 lags Neutral"  2 "2 lags Neutral"  3 "3 lags Neutral" ///
	4 "4 lags Neutral" 5 "5 lags Neutral"  ///
	
encode all_war_lag, gen(all_lag) label(order_all_lag)
egen all_lag_class=group(all_lag class), label
replace all_lag=0 if all_lag==.
replace all_lag_class=0 if all_lag_class==.

local macro2 15.all_lag_class 20.all_lag_class 25.all_lag_class 30.all_lag_class 35.all_lag_class 40.all_lag_class 45.all_lag_class 50.all_lag_class

****reg with lags
eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 i.all_status_class i.all_lag_class, vce(robust)
eststo: poisson value i.pays_class 0.coffee#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 i.all_status_class i.all_lag_class, vce(robust) difficult
eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 i.all_status_class i.all_lag_class, vce(robust) difficult 
/*eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 year_country2-year_country10 i.all_status_class i.all_lag_class, vce(robust) difficult 
*/
esttab, label

local macro1 1.all_lag_class 2.all_lag_class  ///
	3.all_lag_class 4.all_lag_class  6.all_lag_class 7.all_lag_class  ///
	8.all_lag_class  9.all_lag_class 11.all_lag_class  12.all_lag_class ///
	13.all_lag_class  14.all_lag_class 	16.all_lag_class  17.all_lag_class  ///
	18.all_lag_class  19.all_lag_class 21.all_lag_class 22.all_lag_class ///
	23.all_lag_class  24.all_lag_class
		
esttab using "$thesis/Data/do_files/Hamburg/tex/allcountry2_all_lag.tex",label not ///
	indicate("Country-product FE= *.pays_class" "Country time trend= *year_pays*" "Product time trend=*year_class*" ///
	"Coffee break=*coffee*" "Sugar break=*sugar*") ///
	pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") varlab(_cons Constant ///
	1.all_lag_class "1 lag neutral Coffee" 2.all_lag_class "1 lag neutral Eau de vie" ///
	3.all_lag_class "1 lag neutral Sugar" 4.all_lag_class "1 lag neutral Wine" ///
	6.all_lag_class "2 lags neutral Coffee" 7.all_lag_class "2 lags neutral Eau de vie" ///
	8.all_lag_class "2 lags neutral Sugar" 9.all_lag_class "2 lags neutral Wine" ///
	11.all_lag_class "3 lags neutral Coffee" 12.all_lag_class "3 lags neutral Eau de vie" ///
	13.all_lag_class "3 lags neutral Sugar" 14.all_lag_class "3 lags neutral Wine"	///
	16.all_lag_class "4 lags neutral Coffee" 17.all_lag_class "4 lags neutral Eau de vie" ///
	18.all_lag_class "4 lags neutral Sugar" 19.all_lag_class "4 lags neutral Wine" ///
	21.all_lag_class "5 lags neutral Coffee" 22.all_lag_class "5 lags neutral Eau de vie" ///
	23.all_lag_class "5 lags neutral Sugar" 24.all_lag_class "5 lags neutral Wine")	///
	drop(*.all_status_class 0b.* 5.* 10.* 15.* 20.*)	keep(`macro') ///
	title(All countries: Lag of all wars on each product\label{tab1}) replace

eststo clear
exit
eststo: poisson value year i.pays_class year_pays1-year_pays12 year_class1-year_class5 i.each_status_class i.each_lag_class, vce(robust)
eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 i.each_status_class i.each_lag_class, vce(robust) difficult 
eststo: poisson value i.pays_class 0.coffee#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 i.each_status_class i.each_lag_class, vce(robust) difficult 
/*eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 year_country2-year_country10 i.each_status_class i.each_lag_class, vce(robust) difficult 
*/
esttab, label
local macro 34.* 35.* 36.* 37.* 39.* 40.* 41.* 42.* 44.* 45.* 46.* 47.* 49.* 50.* 51.* 52.* 54.* 55.* 56.* 57.* ///
	59.* 60.* 61.* 62.* 64.* 65.* 66.* 67.*
esttab using "$thesis/Data/do_files/Hamburg/tex/allcountry2_each_lag.tex",label not ///
	indicate("Country-product FE= *.pays_class" "Country time trend= *year_pays*" "Product time trend=*year_class*" ///
	"Coffee break=*coffee*" "Sugar break=*sugar*") ///
	pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") varlab(_cons Constant ///
	34.each_status_class "Polish Neutral Coffee" 35.each_status_class "Polish Neutral Eau de vie" 36.each_status_class "Polish Neutral Sugar" 37.each_status_class "Polish Neutral Wine" ///
	39.each_status_class "Austrian1 Neutral Coffee" 40.each_status_class "Austrian1 Neutral Eau de vie" 41.each_status_class "Austrian1 Neutral Sugar" 42.each_status_class "Austrian1 Neutral Wine" ///
	44.each_status_class "Austrian2 Neutral Coffee" 45.each_status_class "Austrian2 Neutral Eau de vie" 46.each_status_class "Austrian2 Neutral Sugar" 47.each_status_class "Austrian2 Neutral Wine" ///
	49.each_status_class "Seven Neutral Coffee" 50.each_status_class "Seven Neutral Eau de vie" 51.each_status_class "Seven Neutral Sugar" 52.each_status_class "Seven Neutral Wine" ///
	54.each_status_class "American Neutral Coffee" 55.each_status_class "American Neutral Eau de vie" 56.each_status_class "American Neutral Sugar" 57.each_status_class "American Neutral Wine" ///
	59.each_status_class "Revolutionary Neutral Coffee" 60.each_status_class "Revolutionary Neutral Eau de vie" 61.each_status_class "Revolutionary Neutral Sugar" 62.each_status_class "Revolutionary Neutral Wine" ///
	64.each_status_class "Napoleonic Neutral Coffee" 65.each_status_class "Napoleonic Neutral Eau de vie" 66.each_status_class "Napoleonic Neutral Sugar" 67.each_status_class "Napoleonic Neutral Wine") ///
	keep(`macro') ///
	title(All countries: Each war on each product\label{tab1}) replace

eststo clear

****gen prewar effects

gen each_war_pre=""
foreach i of num 1/4{
****seven
replace each_war_pre="`i' pre Seven adversary" if pays_grouping=="Angleterre" & year==1756-`i'
replace each_war_pre="`i' pre Seven adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1756-`i'
replace each_war_pre="`i' pre Seven adversary" if pays_grouping=="Hollande" & year==1756-`i'

replace each_war_pre="`i' pre Seven neutral" if pays_grouping=="Levats" & year==1756-`i'
replace each_war_pre="`i' pre Seven neutral" if pays_grouping=="Nord" & year==1756-`i'
replace each_war_pre="`i' pre Seven neutral" if pays_grouping=="Suisse" & year==1756-`i'
replace each_war_pre="`i' pre Seven neutral" if pays_grouping=="Italie" & year==1756-`i'
replace each_war_pre="`i' pre Seven neutral" if pays_grouping=="Portugal" & year==1756-`i'

****american
replace each_war_pre="`i' pre American adversary" if pays_grouping=="Angleterre" & year==1778-`i'
replace each_war_pre="`i' pre American adversary" if pays_grouping=="Portugal" & year==1778-`i'

replace each_war_pre="`i' pre American neutral" if pays_grouping=="Hollande" & year==1778-`i'
replace each_war_pre="`i' pre American neutral" if pays_grouping=="Italie" & year==1778-`i'
replace each_war_pre="`i' pre American neutral" if pays_grouping=="Levant" & year==1778-`i'
replace each_war_pre="`i' pre American neutral" if pays_grouping=="Nord" & year==1778-`i'
replace each_war_pre="`i' pre American neutral" if pays_grouping=="Suisse" & year==1778-`i'

****revolutionary
replace each_war_pre="`i' pre Revolutionary adversary" if pays_grouping=="Angleterre" & year==1792-`i'

replace each_war_pre="`i' pre Revolutionary neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1792-`i'
replace each_war_pre="`i' pre Revolutionary neutral" if pays_grouping=="Italue" & year==1792-`i'
replace each_war_pre="`i' pre Revolutionary neutral" if pays_grouping=="Levant" & year==1792-`i'
replace each_war_pre="`i' pre Revolutionary neutral" if pays_grouping=="Nord" & year==1792-`i'
replace each_war_pre="`i' pre Revolutionary neutral" if pays_grouping=="Suisse" & year==1792-`i'
replace each_war_pre="`i' pre Revolutionary neutral" if pays_grouping=="Portugal" & year==1792-`i'
}

gen all_war_pre=""
foreach i of num 1/4{
***seven
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Angleterre" & year==1756-`i'
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1756-`i'
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Hollande" & year==1756-`i'

replace all_war_pre="`i' pre Neutral" if pays_grouping=="Levats" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Nord" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Suisse" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Italie" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Portugal" & year==1756-`i'

***american
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Angleterre" & year==1778-`i'
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Portugal" & year==1778-`i'

replace all_war_pre="`i' pre Neutral" if pays_grouping=="Hollande" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Italie" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Levant" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Nord" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Suisse" & year==1778-`i'

***revolutionary
replace all_war_pre="`i' pre Adversary" if pays_grouping=="Angleterre" & year==1792+`i'

replace all_war_pre="`i' pre Neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Italue" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Levant" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Nord" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Suisse" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_grouping=="Portugal" & year==1792-`i'
}

encode each_war_pre, gen(each_pre)
egen each_pre_class=group(each_pre class), label
replace each_pre=0 if each_pre==.
replace each_pre_class=0 if each_pre_class==.

encode all_war_pre, gen(all_pre)
egen all_pre_class=group(all_pre class), label
replace all_pre=0 if all_pre==.
replace all_pre_class=0 if all_pre_class==.

local macro *0.* *5.*

****reg with prewar

eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 i.all_status_class i.all_pre_class, vce(robust)
eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_class1-year2_class5 all_status_class1-all_status_class10 i.all_pre_class, vce(robust) difficult
eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_pays1-year2_pays12 i.all_status_class i.all_pre_class, vce(robust) difficult

eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 i.each_status_class i.each_pre_class, vce(robust)
eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_class1-year2_class5 i.each_status_class i.each_pre_class, vce(robust) difficult
eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_pays1-year2_pays12 i.each_status_class i.each_pre_class, vce(robust) difficult

*esttab using "$thesis/reg_table/allcountry2/pre1/pre1.tex",label longtable noomitted not drop(0.* 5.* 10.* `macro' all_status_class* *all_status* *.each_status*) indicate("Country-product FE= *.pays_class" "Country time trend= *year_pays*" "Product time trend=*year_class*" "Country quadratic trend= *year2_pays*" "Product quadratic trend= *year2_class*") pr2 nonumbers mtitles("All wars" "Quadratic" "War by war" "Qaudratic" "Quadratic") title(Regression table\label{tab1}) replace





















