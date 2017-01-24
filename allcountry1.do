*global ete "/Users/Tirindelli/Google Drive/ETE"
global ete "C:\Users\TIRINDEE\Google Drive\ETE"

set more off

use "$ete/thesis2/database_dta/bdd_courante2", clear

drop if year<1733
drop if pays_regroupes=="France"
drop if pays_regroupes=="Indes"
drop if pays_regroupes=="Espagne-Portugal"
drop if pays_regroupes=="Nord-Hollande"

collapse (sum) value, by(year pays) 

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

foreach i of num 1733/1738{
replace each_war_status="Polish allied" if each_war_status!="Polish neutral" & each_war_status!="Polish adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
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

foreach i of num 1740/1743{
replace each_war_status="Austrian1 allied" if each_war_status!="Austrian1 neutral" & each_war_status!="Austrian1 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
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

foreach i of num 1744/1748{
replace each_war_status="Austrian2 allied" if each_war_status!="Austrian2 neutral" & each_war_status!="Austrian2 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
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

foreach i of num 1756/1763{
replace each_war_status="Seven allied" if each_war_status!="Seven neutral" & each_war_status!="Seven adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
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

foreach i of num 1778/1782{
replace each_war_status="American allied" if each_war_status!="American neutral" & each_war_status!="American adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
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

foreach i of num 1792/1795{
replace each_war_status="Revolutionary allied" if each_war_status!="Revolutionary neutral" & each_war_status!="Revolutionary adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
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

foreach i of num 1796/1802{
replace each_war_status="Revolutionary allied" if each_war_status!="Revolutionary neutral" & each_war_status!="Revolutionary adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
}


foreach i of num 1803/1814{
replace each_war_status="Napoleonic allied" if year==`i'
replace all_war_status="Allied" if year==`i'
}

foreach i of num 1803/1814{
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'
}

foreach i in 1805 1809{
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1805/1809{
replace each_war_status="Napoleonic allied" if each_war_status!="Napoleonic neutral" & each_war_status!="Napoleonic adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
}

foreach i in 1806 1807{
replace each_war_status="Napoleonic neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
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
replace each_war_status="Napoleonic neutral" if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="États-Unis d'Amérique" & year==`i'
}

replace each_war_status="Napoleonic adversary" if pays_regroupes=="Suisse" & year==1815
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Hollande" & year==1815

replace all_war_status="Adversary" if pays_regroupes=="Suisse" & year==1815
replace all_war_status="Adversary" if pays_regroupes=="Hollande" & year==1815


label define order_war  1 "Polish adversary"  2 "Austrian1 adversary"  3 "Austrian2 adversary" ///
	4 "Seven adversary" 5 "American adversary"  6 "Revolutionary adversary" 7 "Napoleonic adversary"  ///
	8 "Polish neutral"  9 "Austrian1 neutral"  10 "Austrian2 neutral" 11 "Seven neutral" 12 "American neutral" ///
	13 "Revolutionary neutral" 14 "Napoleonic neutral" ///
	15 "Polish allied"  16 "Austrian1 allied"  17 "Austrian2 allied" 18 "Seven allied" /// 
	19 "American allied"  20 "Revolutionary allied" 21 "Napoleonic allied"

encode each_war_status, gen(each_status) label(order_war)
tab each_war_status, gen(each_status)
foreach i of num 1/14{
replace each_status`i'=0 if each_status`i'==.
label var each_status`i' "`: label (each_status) `i''"
}
replace each_status=0 if each_status==.
 
encode all_war_status, gen(all_status)
/*tab all_war_status, gen(all_status)
foreach i of num 1/2{
replace all_status`i'=0 if all_status`i'==.
label var all_status`i' "`: label (all_status) `i''"
}
*/
replace all_status=0 if all_status==.

encode pays_regroupes, gen(pays)

foreach i of num 1/12{
gen year_pays`i'=0
replace year_pays`i'=year if pays==`i'
}


/*
foreach i of num 1/12{
gen year2_pays`i'=0
replace year2_pays`i'=(year_pays`i')^(2) if pays==`i'
label var year2_pays`i' "Quadratic trend country `i'"
}
gen year2=(year)^(2)

local pays_qfit year2_pays3 year2_pays4 year2_pays5 year2_pays8 year2_pays9 year2_pays11 year2_pays12
*/

gen break=(year>1795)
foreach i of num 1/12{
gen break_year_pays`i'=break*year_pays`i'
}
label var value Value
foreach i in 5 6 8 9 11{
gen country`i'=(year>1795 & pays==`i')
gen year_country`i'=country`i'*year_pays`i'
}

****regress with common time trend and with pays specific time trends
eststo: poisson value year_pays1-year_pays12 i.pays i.all_status, vce(robust)
eststo: poisson value year_pays1-year_pays12 i.pays break#pays break_year_pays1-break_year_pays12 i.all_status, vce(robust)
*eststo: poisson value i.pays year_pays1-year_pays12 country5-country11 i.all_status, vce(robust) difficult 

eststo: poisson value year_pays1-year_pays12 i.pays i.each_status, vce(robust)
eststo: poisson value year_pays1-year_pays12 i.pays break#pays break_year_pays1-break_year_pays12 i.each_status, vce(robust)

esttab, label
/*esttab with allies and adversaries as well
esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/allcountry1_reg.tex", label not alignment(D{.}{.}{-1}) ///
	indicate("Country FE= *.pays" "Country time trend=year_pays*" "Chow test=*break_year_pays*") varlab( _cons "Cons" ///
	1.all_status "Adversary" 2.all_status "Allied" 3.all_status "Neutral" ///
	1.each_status "Polish Adversary" 2.each_status "Austrian1 Adversary" 3.each_status "Austrian2 Adversary" ///
	4.each_status "Seven Adversary" 5.each_status "American Adversary" 6.each_status "Revolutionary Adversary" ///
	7.each_status "Napoleonic Adversary" ///
	8.each_status "Polish Neutral" 9.each_status "Austrian1 Neutral" 10.each_status "Austrian2 Neutral" ///
	11.each_status "Seven Neutral" 12.each_status "American Neutral" 13.each_status "Revolutionary Neutral" ///
	14.each_status "Napoleonic Neutral" ///
	15.each_status "Polish Allied" 16.each_status "Austrian1 Allied" 17.each_status "Austrian2 Allied" ///
	18.each_status "Seven Allied" 19.each_status "American Allied" 20.each_status "Revolutionary Allied" ///
	21.each_status "Napoleonic Allied") ///
	drop(0b.*) pr2 nonumbers mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(All countries: aggregate\label{tab1}) replace	
*/
esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/allcountry1_reg.tex", label not alignment(D{.}{.}{-1}) ///
	indicate("Country FE= *.pays" "Country time trend=year_pays*" "Chow test=*break_year_pays*") varlab( _cons "Cons" ///
	1.all_status "Adversary" 2.all_status "Allied" 3.all_status "Neutral" ///
	1.each_status "Polish Adversary" 2.each_status "Austrian1 Adversary" 3.each_status "Austrian2 Adversary" ///
	4.each_status "Seven Adversary" 5.each_status "American Adversary" 6.each_status "Revolutionary Adversary" ///
	7.each_status "Napoleonic Adversary" ///
	8.each_status "Polish Neutral" 9.each_status "Austrian1 Neutral" 10.each_status "Austrian2 Neutral" ///
	11.each_status "Seven Neutral" 12.each_status "American Neutral" 13.each_status "Revolutionary Neutral" ///
	14.each_status "Napoleonic Neutral" ///
	15.each_status "Polish Allied" 16.each_status "Austrian1 Allied" 17.each_status "Austrian2 Allied" ///
	18.each_status "Seven Allied" 19.each_status "American Allied" 20.each_status "Revolutionary Allied" ///
	21.each_status "Napoleonic Allied") ///
	keep(3.all_status 8.each_status 9.each_status 10.each_status 11.each_status 12.each_status ///
	13.each_status 14.each_status) pr2 nonumbers mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(All countries: aggregate\label{tab1}) replace
eststo clear

****gen war lags

gen each_war_lag=""
foreach i of num 1/5{
****austrian
replace each_war_lag="`i' lags Austrian2 adversary" if pays_regroupes=="Angleterre" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 adversary" if pays_regroupes=="Hollande" & year==1748+`i'

replace each_war_lag="`i' lags Austrian2 neutral" if pays_regroupes=="Levats" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_regroupes=="Nord" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_regroupes=="Suisse" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_regroupes=="Italie" & year==1748+`i'
replace each_war_lag="`i' lags Austrian2 neutral" if pays_regroupes=="Portugal" & year==1748+`i'

replace each_war_lag="`i' lags Austrian2 allies" if each_war_lag=="" & year==1748+`i'


****seven
replace each_war_lag="`i' lags Seven adversary" if pays_regroupes=="Angleterre" & year==1763+`i'
replace each_war_lag="`i' lags Seven adversary" if pays_regroupes=="Portugal" & year==1763+`i'

replace each_war_lag="`i' lags Seven neutral" if pays_regroupes=="Hollande" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_regroupes=="Italie" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_regroupes=="Levant" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_regroupes=="Nord" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_regroupes=="Suisse" & year==1763+`i'

replace each_war_lag="`i' lags Seven allies" if each_war_lag=="" & year==1763+`i'

****napoleonic
replace each_war_lag="`i' lags Napoleonic adversary" if pays_regroupes=="Angleterre" & year==1814+`i'

replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Italue" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Levant" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Nord" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Suisse" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Portuga" & year==1814+`i'

replace each_war_lag="`i' lags Napoleonic allies" if each_war_lag=="" & year==1814+`i'
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

replace all_war_lag="`i' lags Allies" if all_war_lag=="" & year==1748+`i'

***seven
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Angleterre" & year==1763+`i'
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Portugal" & year==1763+`i'

replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Hollande" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Italie" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Levant" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Nord" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Suisse" & year==1763+`i'

replace all_war_lag="`i' lags Allies" if all_war_lag=="" & year==1763+`i'


***napoleonic
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Angleterre" & year==1814+`i'

replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Italue" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Levant" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Nord" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Suisse" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Portugal" & year==1814+`i'

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
esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/allcountry1_lag.tex", label not alignment(D{.}{.}{-1}) ///
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

exit
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

eststo: poisson value year i.pays i.all_status i.all_pre, vce(robust)
eststo: poisson value year i.pays year_pays1-year_pays11 i.all_status  i.all_pre, vce(robust)

****reg with lags each wars
eststo: poisson value year i.pays i.each_status i.each_pre, vce(robust)
eststo: poisson value year i.pays year_pays1-year_pays11 i.each_status i.each_pre, vce(robust)


esttab using "$thesis2/reg_table/allcountry1/pre1/pre1.tex",label noomitted varlab( _cons "Cons") not indicate("Country FE= *.pays" "Country time trend=*year_pays*"  "Country quadratic trend=*year2_pays*" "Total quadratic trend=year2") drop(0.* 5.* year *each_status* *all_status*) pr2 nonumbers mtitles("All wars" "Quadratic" "Quadratic" "War by war" "Quadratic" "Qaudratic") title(Regression table\label{tab1}) replace

eststo clear






