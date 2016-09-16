global thesis2 "/Users/Tirindelli/Google Drive/ETE/Thesis2"

set more off

use "$thesis2/database_dta/bdd_courante2", clear

drop if year<1733
drop if year==1766 & classification_hamburg_large=="Sugar"
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
*replace each_war_status="Revolutionary neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="Revolutionary neutral" if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
*replace each_war_status="Revolutionary neutral" if pays_regroupes=="Hollande" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
*replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
*replace all_war_status="Neutral" if pays_regroupes=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Allemagne et Pologne (par terre)" & year==`i'
}

****switzerland and holland become allies at some point 1796(bit sooner)

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

replace each_war_status="Napoleonic adversary" if pays_regroupes=="Suisse" & year==1815
replace each_war_status="Napoleonic adversary" if pays_regroupes=="Hollande" & year==1815

replace all_war_status="Adversary" if pays_regroupes=="Suisse" & year==1815
replace all_war_status="Adversary" if pays_regroupes=="Hollande" & year==1815

****suisse holland allied till 1814, adversary in 1815

****gen country dummies and year trend
encode pays_regroupes, gen(pays)

foreach i of num 1/12{
gen year_pays`i'=0
replace year_pays`i'=year if pays==`i'
}
foreach i of num 1/12{
gen year2_pays`i'=0
replace year2_pays`i'=(year_pays`i')^(2) if pays==`i'
}

****gen product dummies and year trend
label define order_class 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order_class)
foreach i of num 1/5{
gen year_class`i'=0
replace year_class`i'=year if class==`i'
}
foreach i of num 1/5{
gen year2_class`i'=0
replace year2_class`i'=(year_class`i')^(2) if class==`i'
}
****gen country product fe
egen pays_class=group(pays class), label 


***gen war dummies
label define order_war  1 "Polish adversary"  2 "Austrian1 adversary"  3 "Austrian2 adversary" 4 "Seven adversary" 5 "American adversary"  6 "Revolutionary adversary" 7 "Napoleonic adversary" 8 "Polish neutral"  9 "Austrian1 neutral"  10 "Austrian2 neutral" 11 "Seven neutral" 12 "American neutral"  13 "Revolutionary neutral" 14 "Napoleonic neutral"
encode each_war_status, gen(each_status) label(order_war)
egen each_status_class=group(each_status class), label

/*
tab each_status_class, gen(each_status_class)
foreach i of num 1/68{
replace each_status_class`i'=0 if each_status_class`i'==.
label var each_status_class`i' "`: label (each_status_class) `i''"
}
*/
replace each_status=0 if each_status==.
replace each_status_class=0 if each_status_class==.

encode all_war_status, gen(all_status)
egen all_status_class=group(all_status class), label
/*
tab all_status_class, gen(all_status_class)
foreach i of num 1/10{
replace all_status_class`i'=0 if all_status_class`i'==.
label var all_status_class`i' "`: label (all_status_class) `i''"
}
*/
replace all_status=0 if all_status==.
replace all_status_class=0 if all_status_class==.

local macro1 each_status_class4 each_status_class9 each_status_class14 each_status_class19 each_status_class24 each_status_class29 each_status_class34 each_status_class39 each_status_class43 each_status_class48 each_status_class53 each_status_class58 each_status_class63 each_status_class68
local macro2 all_status_class5 all_status_class10

/*
local pays_qfit year2_pays3 year2_pays4 year2_pays5 year2_pays8 year2_pays9 year2_pays11 year2_pays12
eststo: poisson value year i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_class1 all_status_class1-all_status_class10, vce(robust) 
eststo: poisson value year i.pays_class year_pays1-year_pays12 year_class1-year_class5 `pays_qfit' all_status_class1-all_status_class10, vce(robust) difficult
eststo: poisson value year i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_class1 each_status_class1-each_status_class68, vce(robust) difficult
eststo: poisson value year i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_class1 `pays_qfit' each_status_class1-each_status_class68, vce(robust) difficult
*/

gen coffee=(year>1790 & class==1)
gen sugar=(year>1790 & class==3)

foreach i in 2 3 5 8 9 10{
gen country`i'=(year>1790 & pays==`i')
gen year_country`i'=country`i'*year_pays`i'
}

****regress
eststo: poisson value year i.pays_class year_pays1-year_pays12 year_class1-year_class5 i.all_status_class, vce(robust)
eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 0.coffee#c.year_class1 0.sugar#c.year_class3 i.all_status_class, vce(robust) difficult 
eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 0.coffee#c.year_class1 0.sugar#c.year_class3 year_country2-year_country10 i.all_status_class, vce(robust) difficult 
esttab using "$thesis2/reg_table/allcountry2/dummies1/dummies1.tex",label drop(`macro2') longtable noomitted not indicate("Country-product FE= *.pays_class" "Country time trend= *year_pays*" "Product time trend=*year_class*") pr2 nonumbers mtitles("All wars" "Quadratic" "War by war" "Qaudratic" "Quadratic") title(Regression table\label{tab1}) replace

eststo clear

eststo: poisson value year i.pays_class year_pays1-year_pays12 year_class1-year_class5 i.each_status_class, vce(robust)
eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 0.coffee#c.year_class1 0.sugar#c.year_class3 i.each_status_class, vce(robust) difficult
eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 0.coffee#c.year_class1 0.sugar#c.year_class3 year_country2-year_country10 i.each_status_class, vce(robust) difficult 
esttab using "$thesis2/reg_table/allcountry2/dummies1/dummies2.tex",label drop(`macro1') longtable noomitted not indicate("Country-product FE= *.pays_class" "Country time trend= *year_pays*" "Product time trend=*year_class*") pr2 nonumbers mtitles("All wars" "Quadratic" "War by war" "Qaudratic" "Quadratic") title(Regression table\label{tab1}) replace

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

****seven
replace each_war_lag="`i' lags Seven adversary" if pays_regroupes=="Angleterre" & year==1763+`i'
replace each_war_lag="`i' lags Seven adversary" if pays_regroupes=="Portugal" & year==1763+`i'

replace each_war_lag="`i' lags Seven neutral" if pays_regroupes=="Hollande" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_regroupes=="Italie" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_regroupes=="Levant" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_regroupes=="Nord" & year==1763+`i'
replace each_war_lag="`i' lags Seven neutral" if pays_regroupes=="Suisse" & year==1763+`i'

****napoleonic
replace each_war_lag="`i' lags Napoleonic adversary" if pays_regroupes=="Angleterre" & year==1814+`i'

replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Italue" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Levant" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Nord" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Suisse" & year==1814+`i'
replace each_war_lag="`i' lags Napoleonic neutral" if pays_regroupes=="Portuga" & year==1814+`i'
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
egen each_lag_class=group(each_lag class), label
replace each_lag=0 if each_lag==.
replace each_lag_class=0 if each_lag_class==.

encode all_war_lag, gen(all_lag)
egen all_lag_class=group(all_lag class), label
replace all_lag=0 if all_lag==.
replace all_lag_class=0 if all_lag_class==.

local macro1 14.each_lag_class 19.each_lag_class 23.each_lag_class 27.each_lag_class 32.each_lag_class 37.each_lag_class 41.each_lag_class 46.each_lag_class 49.each_lag_class 54.* 59.* 64.* 68.* 73.* 77.* 81.* 86.* 91.* 96.* 101.* 104.* 107.* 112.* 117.* 122.* 127.* 130.* 134.*
local macro2 15.all_lag_class 20.all_lag_class 25.all_lag_class 30.all_lag_class 35.all_lag_class 40.all_lag_class 45.all_lag_class 50.all_lag_class
****reg with lags

eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 i.all_status_class i.all_lag_class, vce(robust)
eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_class1-year2_class5 all_status_class1-all_status_class10 i.all_lag_class, vce(robust) difficult
eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_pays1-year2_pays12 all_status_class1-all_status_class10 i.all_lag_class, vce(robust) difficult

eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 i.each_status_class i.each_lag_class, vce(robust)
eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_class1-year2_class5 i.each_status_class i.each_lag_class, vce(robust) difficult
eststo: poisson value i.pays_class year_pays1-year_pays12 year_class1-year_class5 year2_pays1-year2_pays12 i.each_status_class i.each_lag_class, vce(robust) difficult

esttab using "$thesis2/reg_table/allcountry2/lag1/lag1.tex",label longtable noomitted not drop(0.* 5.* 10.* `macro1' `macro2' *.all_status* *.each_status*) indicate("Country-product FE= *.pays_class" "Country time trend= *year_pays*" "Product time trend=*year_class*" "Country quadratic trend= *year2_pays*" "Product quadratic trend= *year2_class*") pr2 nonumbers mtitles("All wars" "Quadratic" "War by war" "Qaudratic" "Quadratic") title(Regression table\label{tab1}) replace

eststo clear
****gen prewar effects

gen each_war_pre=""
foreach i of num 1/4{
****seven
replace each_war_pre="`i' pre Seven adversary" if pays_regroupes=="Angleterre" & year==1756-`i'
replace each_war_pre="`i' pre Seven adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1756-`i'
replace each_war_pre="`i' pre Seven adversary" if pays_regroupes=="Hollande" & year==1756-`i'

replace each_war_pre="`i' pre Seven neutral" if pays_regroupes=="Levats" & year==1756-`i'
replace each_war_pre="`i' pre Seven neutral" if pays_regroupes=="Nord" & year==1756-`i'
replace each_war_pre="`i' pre Seven neutral" if pays_regroupes=="Suisse" & year==1756-`i'
replace each_war_pre="`i' pre Seven neutral" if pays_regroupes=="Italie" & year==1756-`i'
replace each_war_pre="`i' pre Seven neutral" if pays_regroupes=="Portugal" & year==1756-`i'

****american
replace each_war_pre="`i' pre American adversary" if pays_regroupes=="Angleterre" & year==1778-`i'
replace each_war_pre="`i' pre American adversary" if pays_regroupes=="Portugal" & year==1778-`i'

replace each_war_pre="`i' pre American neutral" if pays_regroupes=="Hollande" & year==1778-`i'
replace each_war_pre="`i' pre American neutral" if pays_regroupes=="Italie" & year==1778-`i'
replace each_war_pre="`i' pre American neutral" if pays_regroupes=="Levant" & year==1778-`i'
replace each_war_pre="`i' pre American neutral" if pays_regroupes=="Nord" & year==1778-`i'
replace each_war_pre="`i' pre American neutral" if pays_regroupes=="Suisse" & year==1778-`i'

****revolutionary
replace each_war_pre="`i' pre Revolutionary adversary" if pays_regroupes=="Angleterre" & year==1792-`i'

replace each_war_pre="`i' pre Revolutionary neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1792-`i'
replace each_war_pre="`i' pre Revolutionary neutral" if pays_regroupes=="Italue" & year==1792-`i'
replace each_war_pre="`i' pre Revolutionary neutral" if pays_regroupes=="Levant" & year==1792-`i'
replace each_war_pre="`i' pre Revolutionary neutral" if pays_regroupes=="Nord" & year==1792-`i'
replace each_war_pre="`i' pre Revolutionary neutral" if pays_regroupes=="Suisse" & year==1792-`i'
replace each_war_pre="`i' pre Revolutionary neutral" if pays_regroupes=="Portugal" & year==1792-`i'
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

esttab using "$thesis2/reg_table/allcountry2/pre1/pre1.tex",label longtable noomitted not drop(0.* 5.* 10.* `macro' all_status_class* *all_status* *.each_status*) indicate("Country-product FE= *.pays_class" "Country time trend= *year_pays*" "Product time trend=*year_class*" "Country quadratic trend= *year2_pays*" "Product quadratic trend= *year2_class*") pr2 nonumbers mtitles("All wars" "Quadratic" "War by war" "Qaudratic" "Quadratic") title(Regression table\label{tab1}) replace

