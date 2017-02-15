********************************************************************************
***********************HAMBURG1*************************************************
********************************************************************************
*global ete "/Users/Tirindelli/Google Drive/ETE"
global ete "C:\Users\TIRINDEE\Google Drive\ETE"

set more off

use "$ete/Thesis2/database_dta/hamburg1", clear

drop if year<1733
gen lnvalue=ln(value)
label var lnvalue Value

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

gen lnyear=ln(year)
gen g2=(group==2)
gen g3=(group==3)
gen year2=g2*lnyear
gen year3=g3*lnyear


eststo p1: reg lnvalue lnyear i.all, vce(robust)
eststo p2: reg lnvalue lnyear g2 year2 g3 year3 i.all, vce(robust)
eststo p3: reg lnvalue lnyear g3 year3 i.all, vce(robust)


eststo p4: reg lnvalue lnyear i.each, vce(robust)
eststo p5: reg lnvalue lnyear g2 year2 g3 year3 i.each, vce(robust)
eststo p6: reg lnvalue lnyear g3 year3 i.each, vce(robust)

esttab

esttab p1 p3 p4 p6 using "$ete/Thesis/Data/do_files/Hamburg/tex/hamburg1_rob.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(_cons "Constant" 1.all "All" 1.each "Polish" 2.each "Austrian1" 3.each "Austrian2" 4.each "Seven" ///
	5.each "American" 6.each "Revolutionary" 7.each "Napoleonic") drop(0b.all 0b.each lnyear _cons *3 ) not pr2 nonumbers ///
	 mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(Robustness check: Hamburg Aggregate\label{tab1}) replace
 
eststo clear

***rereun hamburg1 regressions on  the disaggregate by products
use "$ete/Thesis2/database_dta/hamburg2", clear

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


eststo p1: poisson value year i.all, vce(robust)
eststo p2: poisson value year g2 year2 g3 year3 i.all, vce(robust)
eststo p3: poisson value year g3 year3 i.all, vce(robust)


eststo p4: poisson value year i.each, vce(robust)
eststo p5: poisson value year g2 year2 g3 year3 i.each, vce(robust)
eststo p6: poisson value g3 year3 i.each, vce(robust)

esttab

esttab p1 p3 p4 p6 using "$ete/Thesis/Data/do_files/Hamburg/tex/hamburg1_rob2.tex",label booktabs alignment(D{.}{.}{-1}) ///
	varlab(_cons "Constant" 1.all "All" 1.each "Polish" 2.each "Austrian1" 3.each "Austrian2" 4.each "Seven" ///
	5.each "American" 6.each "Revolutionary" 7.each "Napoleonic") drop(0b.all 0b.each year _cons *3) not pr2 nonumbers ///
	 mtitles("No breaks" "One break" "No breaks" "One break") ///
	title(Robustness check: Hamburg Aggregate on the disaggregate by products\label{tab1}) replace
 
eststo clear


********************************************************************************
***********************HAMBURG2*************************************************
********************************************************************************

clear

*global ete "/Users/Tirindelli/Google Drive/ETE"
global ete "C:\Users\TIRINDEE\Google Drive\ETE"

set more off

use "$ete/Thesis2/database_dta/hamburg2", clear

drop if value==.
drop pays_regroupes
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


label define order_war  1 Polish  2 Austrian1  3 Austrian2  4 Seven  5 American  6 Revolutionary 7 Napoleonic

encode war_each, gen(each) label(order_war)
egen each_class=group(each class), label
replace each_class=0 if each_class==.

encode war_all, gen(all)
egen all_class=group(all class), label
replace all=0 if all==.
replace all_class=0 if all_class==.

gen lnyear=ln(year)
foreach i of num 1/5{
gen year_class`i'=0
replace year_class`i'=lnyear if class==`i'
}

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

gen lnvalue=ln(value)
label var lnvalue Value


****reg all wars
eststo: reg lnvalue i.class year_class1-year_class5 i.all_class, vce(robust)
*eststo: reg lnvalue i.class year_class1-year_class5 c2 year_c2 c3 year_c3 s2 year_s2 s3 year_s3 i.all_class, noconstant vce(robust) iterate(40)
eststo: reg lnvalue i.class year_class1-year_class5 c2 year_c2 i.all_class, vce(robust) 
eststo: reg lnvalue i.class year_class1-year_class5 c3 year_c3 s3 year_s3 i.all_class, vce(robust)

esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/hamburg2_all_rob.tex", label booktabs alignment(D{.}{.}{-1}) ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Break Coffee=*year_c*" "Break Sugar=*year_s*") ///
	varlab( _cons "Cons" 1.all_class "Coffee" 2.all_class "Eau de vie" 3.all_class "Sugar" 4.all_class "Wine") ///
	keep(1.all_class 2.all_class 3.all_class 4.all_class) pr2 not nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	title(Robustness check: Hamburg: All wars on each product\label{tab1}) replace
eststo clear

****reg each war separately
eststo: reg lnvalue i.class year_class1-year_class5 i.each_class, vce(robust)
eststo: reg lnvalue i.class year_class1-year_class5 c2 year_c2 i.each_class, vce(robust) 
eststo: reg lnvalue i.class year_class1-year_class5 c3 year_c3 s3 year_s3 i.each_class, vce(robust)

esttab, label
local macro 5.* 10.* 15.* 20.* 25.* 30.* 35.* s* c*
esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/hamburg2_each_rob.tex",label alignment(D{.}{.}{-1}) not ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Break Coffee=*year_c*" "Break Sugar=*year_s*") ///
	varlab(_cons "Cons" 1.each_class "Polish Coffee" 2.each_class "Polish Eau de vie" 3.each_class "Polish Sugar" 4.each_class "Polish Wine" ///
	6.each_class "Austrian1 Coffee" 7.each_class "Austrian1 Eau de vie" 8.each_class "Austrian1 Sugar" 9.each_class "Austrian1 Wine" ///
	11.each_class "Austrian2 Coffee" 12.each_class "Austrian2 Eau de vie" 13.each_class "Austrian2 Sugar" 14.each_class "Austrian2 Wine" ///
	16.each_class "Seven Coffee" 17.each_class "Seven Eau de vie" 18.each_class "Seven Sugar" 19.each_class "Seven Wine" ///
	21.each_class "American Coffee" 22.each_class "American Eau de vie" 23.each_class "American Sugar" 24.each_class "American Wine" ///
	26.each_class "Revolutionary Coffee" 27.each_class "Revolutionary Eau de vie" 28.each_class "Revolutionary Sugar" 29.each_class "Revolutionary Wine" ///
	31.each_class "Napoleonic Coffee" 32.each_class "Napoleonic Eau de vie" 33.each_class "Napoleonic Sugar" 34.each_class "Napoleonic Wine") ///
	drop(0b.* `macro') pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	title(Robustness check: Hamburg: Each wars on each product\label{tab1}) replace

eststo clear



********************************************************************************
***********************ALLCOUNTRIES1********************************************
********************************************************************************


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

replace all_status=0 if all_status==.

encode pays_regroupes, gen(pays)

gen lnyear=ln(year)
foreach i of num 1/12{
gen year_pays`i'=0
replace year_pays`i'=lnyear if pays==`i'
}



gen break=(year>1795)
foreach i of num 1/12{
gen break_year_pays`i'=break*year_pays`i'
}
label var value Value
foreach i in 5 6 8 9 11{
gen country`i'=(year>1795 & pays==`i')
gen year_country`i'=country`i'*year_pays`i'
}

gen lnvalue=ln(value)

****regress with common time trend and with pays specific time trends
eststo: reg lnvalue year_pays1-year_pays12 i.pays i.all_status, vce(robust)
eststo: reg lnvalue year_pays1-year_pays12 i.pays break#pays break_year_pays1-break_year_pays12 i.all_status, vce(robust)

eststo: reg lnvalue year_pays1-year_pays12 i.pays i.each_status, vce(robust)
eststo: reg lnvalue year_pays1-year_pays12 i.pays break#pays break_year_pays1-break_year_pays12 i.each_status, vce(robust)

esttab, label

esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/allcountry1_rob.tex", label not alignment(D{.}{.}{-1}) ///
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
	title(Robustness check: All countries: aggregate\label{tab1}) replace
eststo clear




********************************************************************************
***********************ALLCOUNTRIES2********************************************
********************************************************************************
global ete "C:\Users\TIRINDEE\Google Drive\ETE"


set more off

use "$ete/thesis2/database_dta/bdd_courante2", clear

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


****gen country dummies and year trend
encode pays_regroupes, gen(pays)

gen lnyear=ln(year)
foreach i of num 1/12{
gen year_pays`i'=0
replace year_pays`i'=lnyear if pays==`i'
}


****gen product dummies and year trend
label define order_class 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order_class)
foreach i of num 1/5{
gen year_class`i'=0
replace year_class`i'=lnyear if class==`i'
}

****gen country product fe
egen pays_class=group(pays class), label 


***gen war dummies
label define order_war  1 "Polish adversary"  2 "Austrian1 adversary"  3 "Austrian2 adversary" 4 "Seven adversary" 5 "American adversary"  6 "Revolutionary adversary" 7 "Napoleonic adversary" 8 "Polish neutral"  9 "Austrian1 neutral"  10 "Austrian2 neutral" 11 "Seven neutral" 12 "American neutral"  13 "Revolutionary neutral" 14 "Napoleonic neutral"
encode each_war_status, gen(each_status) label(order_war)
egen each_status_class=group(each_status class), label


replace each_status=0 if each_status==.
replace each_status_class=0 if each_status_class==.

encode all_war_status, gen(all_status)
egen all_status_class=group(all_status class), label

replace all_status=0 if all_status==.
replace all_status_class=0 if all_status_class==.

local macro1 each_status_class4 each_status_class9 each_status_class14 each_status_class19 each_status_class24 each_status_class29 each_status_class34 each_status_class39 each_status_class43 each_status_class48 each_status_class53 each_status_class58 each_status_class63 each_status_class68
local macro2 all_status_class5 all_status_class10



gen coffee=(year>1795 & class==1)
gen sugar=(year>1795 & class==3)

gen lnvalue=ln(value)
label var lnvalue Value
****regress first no break, then break for coffee only and then both sugar and coffee (=experiment)
eststo: reg lnvalue i.pays_class year_pays1-year_pays12 year_class1-year_class5 i.all_status_class, vce(robust)
eststo: reg lnvalue i.pays_class 0.coffee#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 i.all_status_class, vce(robust) 
eststo: reg lnvalue i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 i.all_status_class, vce(robust)  

esttab, label

esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/allcountry2_all_rob.tex",label not ///
	indicate("Country-product FE= *.pays_class" "Country time trend= *year_pays*" "Product time trend=*year_class*" ///
	"Coffee break=*coffee*" "Sugar break=*sugar*") ///
	pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") varlab(_cons Constant ///
	1.all_status_class "Adversary Coffee" 2.all_status_class "Adversary Eau de vie" 3.all_status_class "Adversary Sugar" 4.all_status_class "Adversary Wine" ///
	6.all_status_class "Allied Coffee" 7.all_status_class "Allied Eau de vie" 8.all_status_class "Allied Sugar" 9.all_status_class "Allied Wine" ///
	11.all_status_class "Neutral Coffee" 12.all_status_class "Neutral Eau de vie" 13.all_status_class "Neutral Sugar" 14.all_status_class "Neutral Wine")	///
	keep(11.all_status_class 12.all_status_class 13.all_status_class 14.all_status_class)	///
	title(Robustness check: All countries: All wars on each product\label{tab1}) replace

eststo clear

eststo: reg lnvalue year i.pays_class year_pays1-year_pays12 year_class1-year_class5 i.each_status_class, vce(robust)
eststo: reg lnvalue i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 i.each_status_class, vce(robust)  
eststo: reg lnvalue i.pays_class 0.coffee#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 i.each_status_class, vce(robust)  

esttab, label
local macro 34.* 35.* 36.* 37.* 39.* 40.* 41.* 42.* 44.* 45.* 46.* 47.* 49.* 50.* 51.* 52.* 54.* 55.* 56.* 57.* ///
	59.* 60.* 61.* 62.* 64.* 65.* 66.* 67.*
esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/allcountry2_each_rob.tex",label not ///
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
	title(Robustness check: All countries: Each war on each product\label{tab1}) replace

eststo clear

*****reg with country-product fe
label var value Value
eststo: poisson value i.pays_class i.pays_class#c.year i.all_status_class, vce(robust)
eststo: poisson value i.pays_class 0.coffee#pays i.pays_class#c.year ///
	0.coffee#i.pays#c.year i.all_status_class, vce(robust) 
eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays i.pays_class#c.year ///
	0.coffee#i.pays#c.year 0.sugar#i.pays#c.year i.all_status_class, vce(robust)  iterate(40)

esttab, label

esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/allcountry2_all_rob2.tex",label not ///
	indicate("Country-product FE= *.pays_class"  ///
	"Coffee break=*coffee*" "Sugar break=*sugar*") ///
	pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") varlab(_cons Constant ///
	1.all_status_class "Adversary Coffee" 2.all_status_class "Adversary Eau de vie" 3.all_status_class "Adversary Sugar" 4.all_status_class "Adversary Wine" ///
	6.all_status_class "Allied Coffee" 7.all_status_class "Allied Eau de vie" 8.all_status_class "Allied Sugar" 9.all_status_class "Allied Wine" ///
	11.all_status_class "Neutral Coffee" 12.all_status_class "Neutral Eau de vie" 13.all_status_class "Neutral Sugar" 14.all_status_class "Neutral Wine")	///
	keep(11.all_status_class 12.all_status_class 13.all_status_class 14.all_status_class)	///
	title(Robustness check: All countries: country product FE\label{tab1}) replace

	eststo clear

eststo: poisson value i.pays_class i.pays_class#c.year i.each_status_class, vce(robust)
eststo: poisson value i.pays_class 0.coffee#pays i.pays_class#c.year ///
	0.coffee#i.pays#c.year i.each_status_class, vce(robust) 
eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays i.pays_class#c.year ///
	0.coffee#i.pays#c.year 0.sugar#i.pays#c.year i.each_status_class, vce(robust)  iterate(40)


esttab, label
local macro 34.* 35.* 36.* 37.* 39.* 40.* 41.* 42.* 44.* 45.* 46.* 47.* 49.* 50.* 51.* 52.* 54.* 55.* 56.* 57.* ///
	59.* 60.* 61.* 62.* 64.* 65.* 66.* 67.*
esttab using "$ete/Thesis/Data/do_files/Hamburg/tex/allcountry2_each_rob2.tex",label not ///
	indicate("Country-product FE= *pays_class*" ///
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
	title(Robustness check: All countries: country product FE\label{tab1}) replace

eststo clear




