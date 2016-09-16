global thesis2 "/Users/Tirindelli/Google Drive/ETE/Thesis2"

set more off

use "$thesis2/database_dta/bdd_courante2", clear

drop if year<1733
drop if pays_regroupes=="France"
drop if pays_regroupes=="Indes"
drop if pays_regroupes=="Espagne-Portugal"
drop if pays_regroupes=="Nord-Hollande"

gen each_war_status=""
gen all_war_status=""

foreach i of num 1733/1738{
replace each_war_status="Polish adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'

replace each_war_status="Polish neutral" if pays_regroupes=="Hollande" & year==`i'
replace each_war_status="Polish neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="Polish neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="Polish neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="Polish neutral" if pays_regroupes=="Portugal" & year==`i'
replace each_war_status="Polish neutral" if pays_regroupes=="Angleterre" & year==`i'
replace each_war_status="Polish neutral" if pays_regroupes=="Italie" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Portugal" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
}

foreach i of num 1740/1743{
replace each_war_status="Austrian1 adversary" if pays_regroupes=="Angleterre" & year==`i'
replace each_war_status="Austrian1 adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="Austrian1 adversary" if pays_regroupes=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Hollande" & year==`i'

replace each_war_status="Austrian1 neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="Austrian1 neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="Austrian1 neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="Austrian1 neutral" if pays_regroupes=="Italie" & year==`i'
replace each_war_status="Austrian1 neutral" if pays_regroupes=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Portugal" & year==`i'
}

foreach i of num 1744/1748{
replace each_war_status="Austrian2 adversary" if pays_regroupes=="Angleterre" & year==`i'
replace each_war_status="Austrian2 adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="Austrian2 adversary" if pays_regroupes=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Hollande" & year==`i'

replace each_war_status="Austrian2 neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="Austrian2 neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="Austrian2 neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="Austrian2 neutral" if pays_regroupes=="Italie" & year==`i'
replace each_war_status="Austrian2 neutral" if pays_regroupes=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Portugal" & year==`i'
}

foreach i of num 1756/1763{
replace each_war_status="Seven adversary" if pays_regroupes=="Angleterre" & year==`i'
replace each_war_status="Seven adversary" if pays_regroupes=="Portugal" & year==`i'
replace each_war_status="Seven adversary" if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace each_war_status="Seven neutral" if pays_regroupes=="Hollande" & year==`i'
replace each_war_status="Seven neutral" if pays_regroupes=="Italie" & year==`i'
replace each_war_status="Seven neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="Seven neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="Seven neutral" if pays_regroupes=="Suisse" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
}

foreach i of num 1778/1782{
replace each_war_status="American adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'

replace each_war_status="American neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="American neutral" if pays_regroupes=="Italie" & year==`i'
replace each_war_status="American neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="American neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="American neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="American neutral" if pays_regroupes=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Portugal" & year==`i'
}

foreach i of num 1792/1795{
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Angleterre" & year==`i'
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Espagne" & year==`i'
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Hollande" & year==`i'
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Portugal" & year==`i'
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Italie" & year==`i'


replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Espagne" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Hollande" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Italie" & year==`i'


replace each_war_status="Revolutionary neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="Revolutionary neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="Revolutionary neutral" if pays_regroupes=="Suisse" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
}

foreach i of num 1796/1802{
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Angleterre" & year==`i'
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Portugal" & year==`i'
replace each_war_status="Revolutionary adversary" if pays_regroupes=="Italie" & year==`i'

replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Italie" & year==`i'

replace each_war_status="Revolutionary neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="Revolutionary neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="Revolutionary neutral" if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
}


foreach i of num 1803/1814{
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Angleterre" & year==`i'
*replace each_war_status="Napoleonic adversary" if pays_regroupes=="Italie" & year==`i'

replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'
*replace all_war_status="Adversary" if pays_regroupes=="Italie" & year==`i'
}

foreach i in 1805 1809{
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i in 1806 1807{
austria is neutral
}

foreach i of num 1813/1815{
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1800/1807{
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Portugal" & year==`i'
}
foreach i of num 1809/1815{
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Portugal" & year==`i'
}

*replace each_war_status="Napoleonic neutral" if pays_regroupes=="Portugal" & year==1808
*replace all_war_status="Adversary" if pays_regroupes=="Portugal" & year==1808

*****1806-1812 germany is allied
foreach i of num 1806/1807{
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
}
foreach i of num 1813/1815{
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
}

foreach i of num 1808/1815{
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Espagne" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Espagne" & year==`i'
}

foreach i of num 1803/1815{
replace each_war_status="Napoleonic neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="Napoleonic neutral" if pays_regroupes=="Nord" & year==`i'
*replace each_war_status="Napoleonic neutral" if pays_regroupes=="Suisse" & year==`i'
*replace each_war_status="Napoleonic neutral" if pays_regroupes=="Hollande" & year==`i'
replace each_war_status="Napoleonic neutral" if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
*replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
*replace all_war_status="Neutral" if pays_regroupes=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="États-Unis d'Amérique" & year==`i'
}

replace each_war_status="Napoleonic advversary" if pays_regroupes=="Suisse" & year==1815
replace each_war_status="Napoleonic advversary" if pays_regroupes=="Hollande" & year==1815

replace all_war_status="Advversary" if pays_regroupes=="Suisse" & year==1815
replace all_war_status="Advversary" if pays_regroupes=="Hollande" & year==1815



label define order_war  1 "Polish adversary"  2 "Austrian1 adversary"  3 "Austrian2 adversary" 4 "Seven adversary" 5 "American adversary"  6 "Revolutionary adversary" 7 "Napoleonic adversary" 8 "Polish neutral"  9 "Austrian1 neutral"  10 "Austrian2 neutral" 11 "Seven neutral" 12 "American neutral"  13 "Revolutionary neutral" 14 "Napoleonic neutral"

encode each_war_status, gen(each_status) label(order_war)
tab each_war_status, gen(each_status)
foreach i of num 1/14{
replace each_status`i'=0 if each_status`i'==.
label var each_status`i' "`: label (each_status) `i''"
}
replace each_status=0 if each_status==.
 
encode all_war_status, gen(all_status)
tab all_war_status, gen(all_status)
foreach i of num 1/2{
replace all_status`i'=0 if all_status`i'==.
label var all_status`i' "`: label (all_status) `i''"
}
replace all_status=0 if all_status==.

encode pays_regroupes, gen(pays)

foreach i of num 1/12{
gen year_pays`i'=0
replace year_pays`i'=year if pays==`i'
}

foreach i of num 1/12{
gen year2_pays`i'=0
replace year2_pays`i'=(year_pays`i')^(2) if pays==`i'
label var year2_pays`i' "Quadratic trend country `i'"
}
gen year2=(year)^(2)

local pays_qfit year2_pays3 year2_pays4 year2_pays5 year2_pays8 year2_pays9 year2_pays11 year2_pays12

eststo: poisson value year i.pays year_pays1-year_pays12 i.all_status, vce(robust)
eststo: poisson value year i.pays year_pays1-year_pays12 `pays_qfit' i.all_status, vce(robust)
 
****each war
eststo: poisson value year i.pays year_pays1-year_pays12 i.each_status, vce(robust)
eststo: poisson value year i.pays year_pays1-year_pays12 `pays_qfit' i.each_status, vce(robust)

esttab using "$thesis2/reg_table/allcountry1/dummies1/dummies1.tex",label booktabs alignment(D{.}{.}{-1}) noomitted varlab( _cons "Cons") not indicate("Country FE= *.pays" "Country time trend=*year_pays*" "Country quadratic trend= *year2_pays*") drop(0.* 5.* year) pr2 nonumbers mtitles("All wars" "Quadratic" "Quadratic" "War by war" "Qaudratic" "Quadratic") title(Regression table\label{tab1}) replace
eststo clear

****gen war lags

gen each_war_lag=""
foreach i of num 1/5{
****austrian
replace each_war_lag="`i' lags 3Austria2 adversary" if pays_regroupes=="Angleterre" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 adversary" if pays_regroupes=="Hollande" & year==1748+`i'

replace each_war_lag="`i' lags 3Austria2 neutral" if pays_regroupes=="Levats" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 neutral" if pays_regroupes=="Nord" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 neutral" if pays_regroupes=="Suisse" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 neutral" if pays_regroupes=="Italie" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 neutral" if pays_regroupes=="Portugal" & year==1748+`i'

****seven
replace each_war_lag="`i' lags 4Seven adversary" if pays_regroupes=="Angleterre" & year==1763+`i'
replace each_war_lag="`i' lags 4Seven adversary" if pays_regroupes=="Portugal" & year==1763+`i'

replace each_war_lag="`i' lags 4Seven neutral" if pays_regroupes=="Hollande" & year==1763+`i'
replace each_war_lag="`i' lags 4Seven neutral" if pays_regroupes=="Italie" & year==1763+`i'
replace each_war_lag="`i' lags 4Seven neutral" if pays_regroupes=="Levant" & year==1763+`i'
replace each_war_lag="`i' lags 4Seven neutral" if pays_regroupes=="Nord" & year==1763+`i'
replace each_war_lag="`i' lags 4Seven neutral" if pays_regroupes=="Suisse" & year==1763+`i'

****napoleonic
replace each_war_lag="`i' lags 7Napoleonic adversary" if pays_regroupes=="Angleterre" & year==1814+`i'

replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Italue" & year==1814+`i'
replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Levant" & year==1814+`i'
replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Nord" & year==1814+`i'
replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Suisse" & year==1814+`i'
replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Portuga" & year==1814+`i'
}

gen all_war_lag=""
foreach i of num 1/5{
***austrian
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Angleterre" & year==1748+`i'
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1748+`i'
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Hollande" & year==1748+`i'

replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Levats" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Nord" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Suisse" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Italie" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Portugal" & year==1748+`i'

***seven
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Angleterre" & year==1763+`i'
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Portugal" & year==1763+`i'

replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Hollande" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Italie" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Levant" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Nord" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Suisse" & year==1763+`i'

***napoleonic
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Angleterre" & year==1814+`i'

replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Italue" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Levant" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Nord" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Suisse" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Portugal" & year==1814+`i'
}

encode each_war_lag, gen(each_lag)
replace each_lag=0 if each_lag==.
encode all_war_lag, gen(all_lag)
replace all_lag=0 if all_lag==.


****reg with lags all wars
eststo: poisson value i.pays year_pays1-year_pays12 i.all_status i.all_lag, vce(robust)
eststo: poisson value year year2 i.pays year_pays1-year_pays12 i.all_status  i.all_lag, vce(robust)
eststo: poisson value i.pays year_pays1-year_pays12 year2_pays1-year2_pays12 i.all_status i.all_lag, vce(robust)

****reg with lags each wars
eststo: poisson value i.pays year_pays1-year_pays12 i.each_status i.each_lag, vce(robust)
eststo: poisson value year year2 i.pays year_pays1-year_pays12 i.each_status i.each_lag, vce(robust)
eststo: poisson value i.pays year_pays1-year_pays12 year2_pays1-year2_pays12 i.each_status i.each_lag, vce(robust)


esttab using "$thesis2/reg_table/allcountry1/lag1/lag1.tex",label noomitted varlab( _cons "Cons") not indicate("Country FE= *.pays" "Country time trend=*year_pays*" "Country quadratic trend= *year2_pays*" "Total quadratic trend=year2") drop(0.* 5.* year *each_status* *all_status*) pr2 nonumbers mtitles("All wars" "Quadratic" "Quadratic" "War by war" "Quadratic" "Qaudratic") title(Regression table\label{tab1}) replace

eststo clear
****gen prewar effects

gen each_war_pre=""
foreach i of num 1/4{
****seven
replace each_war_pre="`i' pre 4Seven adversary" if pays_regroupes=="Angleterre" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven adversary" if pays_regroupes=="Hollande" & year==1756-`i'

replace each_war_pre="`i' pre 4Seven neutral" if pays_regroupes=="Levats" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_regroupes=="Nord" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_regroupes=="Suisse" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_regroupes=="Italie" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_regroupes=="Portugal" & year==1756-`i'

****american
replace each_war_pre="`i' pre 5American adversary" if pays_regroupes=="Angleterre" & year==1778-`i'
replace each_war_pre="`i' pre 5American adversary" if pays_regroupes=="Portugal" & year==1778-`i'

replace each_war_pre="`i' pre 5American neutral" if pays_regroupes=="Hollande" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_regroupes=="Italie" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_regroupes=="Levant" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_regroupes=="Nord" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_regroupes=="Suisse" & year==1778-`i'

****revolutionary
replace each_war_pre="`i' pre 6Revolutionary adversary" if pays_regroupes=="Angleterre" & year==1792-`i'

replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Italue" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Levant" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Nord" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Suisse" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Portugal" & year==1792-`i'
}

gen all_war_pre=""
foreach i of num 1/4{
***seven
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Angleterre" & year==1756-`i'
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1756-`i'
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Hollande" & year==1756-`i'

replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Levats" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Nord" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Suisse" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Italie" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Portugal" & year==1756-`i'

***american
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Angleterre" & year==1778-`i'
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Portugal" & year==1778-`i'

replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Hollande" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Italie" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Levant" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Nord" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Suisse" & year==1778-`i'

***revolutionary
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Angleterre" & year==1792+`i'

replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Italue" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Levant" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Nord" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Suisse" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Portugal" & year==1792-`i'
}

encode each_war_pre, gen(each_pre)
replace each_pre=0 if each_pre==.
encode all_war_pre, gen(all_pre)
replace all_pre=0 if all_pre==.


****reg with prewar

eststo: poisson value i.pays year_pays1-year_pays12 i.all_status i.all_pre, vce(robust)
eststo: poisson value year year2 i.pays year_pays1-year_pays12 i.all_status  i.all_pre, vce(robust)
eststo: poisson value i.pays year_pays1-year_pays12 year2_pays1-year2_pays12 i.all_status i.all_pre, vce(robust)

****reg with lags each wars
eststo: poisson value i.pays year_pays1-year_pays12 i.each_status i.each_pre, vce(robust)
eststo: poisson value year year2 i.pays year_pays1-year_pays12 i.each_status i.each_pre, vce(robust)
eststo: poisson value i.pays year_pays1-year_pays12 year2_pays1-year2_pays12 i.each_status i.each_pre, vce(robust)


esttab using "$thesis2/reg_table/allcountry1/pre1/pre1.tex",label noomitted varlab( _cons "Cons") not indicate("Country FE= *.pays" "Country time trend=*year_pays*"  "Country quadratic trend=*year2_pays*" "Total quadratic trend=year2") drop(0.* 5.* year *each_status* *all_status*) pr2 nonumbers mtitles("All wars" "Quadratic" "Quadratic" "War by war" "Quadratic" "Qaudratic") title(Regression table\label{tab1}) replace

eststo clear






