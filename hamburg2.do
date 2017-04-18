clear

global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"

set more off

use "$thesis/database_dta/hamburg2", clear

drop if value==.
drop if year<1733
label define order_class 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order_class)

label var value Value

****GEN 7 WAR DUMMIES	
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


****gen one dummy for all wars
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


encode war_each, gen(each)

gen c1=(year<1745 & class==1)
gen c2=(year>1744 & year<1790 & class==1)
gen c3=(year>1795 & class==1)

gen s1=(year<1745 & class==3)
gen s2=(year>1744 & year<1790 & class==3)
gen s3=(year>1795 & class==3)

gen year_class1=0
replace year_class1=year*class if class==1
gen year_class3=0
replace year_class3=year*class if class==3

foreach i of num 1/3{
gen year_c`i'=year_class1*c`i'
gen year_s`i'=year_class3*s`i'
}


****reg all wars exports
eststo: poisson value i.class i.class#c.year i.all#i.class if exportsimports=="Exports", vce(robust)
*eststo: poisson value i.class year_class1-year_class5 c2 year_c2 c3 year_c3 s2 year_s2 s3 year_s3 i.all_class, noconstant vce(robust) iterate(40)
eststo: poisson value i.class i.class#c.year c2 year_c2 i.all#i.class if exportsimports=="Exports", vce(robust) iterate(40)
eststo: poisson value i.class i.class#c.year c3 year_c3 s3 year_s3 i.all#i.class if exportsimports=="Exports", vce(robust)

esttab, label
/*
esttab using "$thesis/Data/do_files/Hamburg/tex/hamburg2_all_reg.tex", label booktabs alignment(D{.}{.}{-1}) ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Break Coffee=*year_c*" "Break Sugar=*year_s*") ///
	varlab( _cons "Cons" 1.all_class "Coffee" 2.all_class "Eau de vie" 3.all_class "Sugar" 4.all_class "Wine") ///
	keep(1.all_class 2.all_class 3.all_class 4.all_class) pr2 not nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	title(Hamburg: All wars on each product\label{tab1}) replace
*/
eststo clear

****reg each war separately
eststo: poisson value i.class i.class#c.year i.each#i.class if exportsimports=="Exports", vce(robust)
eststo: poisson value i.class i.class#c.year c2 year_c2 i.each#i.class if exportsimports=="Exports", vce(robust) iterate(40)
eststo: poisson value i.class i.class#c.year c3 year_c3 s3 year_s3 i.each#i.class if exportsimports=="Exports", vce(robust)

esttab, label

/*
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
*/
eststo clear

****reg all wars imports
eststo: poisson value i.class i.class#c.year i.all#i.class if exportsimports=="Imports", vce(robust)
*eststo: poisson value i.class year_class1-year_class5 c2 year_c2 c3 year_c3 s2 year_s2 s3 year_s3 i.all_class, noconstant vce(robust) iterate(40)
eststo: poisson value i.class i.class#c.year c2 year_c2 i.all#i.class if exportsimports=="Imports", vce(robust) iterate(40)
eststo: poisson value i.class i.class#c.year c3 year_c3 s3 year_s3 i.all#i.class if exportsimports=="Imports", vce(robust)

esttab, label
/*
esttab using "$thesis/Data/do_files/Hamburg/tex/hamburg2_all_reg.tex", label booktabs alignment(D{.}{.}{-1}) ///
	indicate("Product FE= *.class" "Product time trend=*year_class*" "Break Coffee=*year_c*" "Break Sugar=*year_s*") ///
	varlab( _cons "Cons" 1.all_class "Coffee" 2.all_class "Eau de vie" 3.all_class "Sugar" 4.all_class "Wine") ///
	keep(1.all_class 2.all_class 3.all_class 4.all_class) pr2 not nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	title(Hamburg: All wars on each product\label{tab1}) replace
*/
eststo clear

****reg each war separately
eststo: poisson value i.class i.class#c.year i.each#i.class if exportsimports=="Imports", vce(robust)
eststo: poisson value i.class i.class#c.year c2 year_c2 i.each#i.class if exportsimports=="Imports", vce(robust) iterate(40)
eststo: poisson value i.class i.class#c.year c3 year_c3 s3 year_s3 i.each#i.class if exportsimports=="Imports", vce(robust)

esttab, label

/*
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
*/
eststo clear
