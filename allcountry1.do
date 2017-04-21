global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"

set more off

use "$thesis/database_dta/allcountry1", clear

collapse (sum) value, by(year pays exportsimports) 

/*gen one dummy for each war and 3 dummies for three groups of wars 
(Polish Austrian1 // Austrian2 Seven American // Revolutionary Napoleonic)
I generate them as string and then encode them to avoid creating 
and labelling a 1000 dummies*/

gen each_war_status="Peace"
gen all_war_status="Peace"

foreach i of num 1733/1738{
replace each_war_status="War1 adversary" ///
	if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'

replace each_war_status="War1 neutral" if pays_grouping=="Hollande" & year==`i'
replace each_war_status="War1 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War1 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War1 neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="War1 neutral" if pays_grouping=="Portugal" & year==`i'
replace each_war_status="War1 neutral" if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War1 neutral" if pays_grouping=="Italie" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
}

foreach i of num 1733/1738{
replace each_war_status="War1 allied" if ///
	each_war_status!="War1 neutral" & ///
	each_war_status!="War1 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}


foreach i of num 1740/1743{
replace each_war_status="War1 adversary" ///
	if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War1 adversary" ///
	if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="War1 adversary" ///
	if pays_grouping=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==`i'

replace each_war_status="War1 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War1 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War1 neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="War1 neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="War1 neutral" if pays_grouping=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
}

foreach i of num 1740/1743{
replace each_war_status="War1 allied" if each_war_status!="War1 neutral" ///
	& each_war_status!="War1 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}


foreach i of num 1744/1748{
replace each_war_status="War2 adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War2 adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="War2 adversary" if ///
	pays_grouping=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==`i'

replace each_war_status="War2 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
}

foreach i of num 1744/1748{
replace each_war_status="War2 allied" if ///
	each_war_status!="War2 neutral" & ///
	each_war_status!="War2 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}

foreach i of num 1756/1763{
replace each_war_status="War2 adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War2 adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace each_war_status="War2 adversary" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'

replace each_war_status="War2 neutral" if pays_grouping=="Hollande" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Suisse" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
}

foreach i of num 1756/1763{
replace each_war_status="War2 allied" if ///
	each_war_status!="War2 neutral" & ///
	each_war_status!="War2 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}

foreach i of num 1778/1782{
replace each_war_status="War2 adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'

replace each_war_status="War2 neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Portugal" & year==`i'

replace all_war_status="Neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
}

foreach i of num 1778/1782{
replace each_war_status="War2 allied" if each_war_status!="War2 neutral" ///
	& each_war_status!="War2 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & ///
	all_war_status!="Neutral" & year==`i'
}

foreach i of num 1792/1795{
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Espagne" & year==`i'
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Hollande" & year==`i'
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Italie" & year==`i'


replace all_war_status="Adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Espagne" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Italie" & year==`i'


replace each_war_status="War3 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War3 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War3 neutral" if pays_grouping=="Suisse" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
}

foreach i of num 1792/1795{
replace each_war_status="War3 allied" if each_war_status!="War3 neutral" ///
	& each_war_status!="War3 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & ///
	all_war_status!="Neutral" & year==`i'
}

foreach i of num 1796/1802{
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Italie" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Italie" & year==`i'

replace each_war_status="War3 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War3 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War3 neutral" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}

foreach i of num 1796/1802{
replace each_war_status="War3 allied" if each_war_status!="War3 neutral" ///
	& each_war_status!="War3 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}


foreach i of num 1803/1814{
replace each_war_status="War3 allied" if year==`i'
replace all_war_status="Allied" if year==`i'
}

foreach i of num 1803/1814{
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
}

foreach i in 1805 1809{
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1805/1809{
replace each_war_status="War3 allied" if ///
	each_war_status!="Napoleonic neutral" & ///
	each_war_status!="Napoleonic adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}

foreach i in 1806 1807{
replace each_war_status="War3 neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1813/1815{
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1800/1807{
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
}
foreach i of num 1809/1815{
replace each_war_status="War3 adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Portugal" & year==`i'
}

*****1806-1812 germany is allied
foreach i of num 1806/1807{
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}
foreach i of num 1813/1815{
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}

foreach i of num 1808/1815{
replace each_war_status="War3 adversary" if pays_grouping=="Espagne" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Espagne" & year==`i'
}

foreach i of num 1803/1815{
replace each_war_status="War3 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War3 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War3 neutral" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'
}

replace each_war_status="War3 adversary" if ///
	pays_grouping=="Suisse" & year==1815
replace each_war_status="War3 adversary" if ///
	pays_grouping=="Hollande" & year==1815

replace all_war_status="Adversary" if pays_grouping=="Suisse" & year==1815
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==1815

label define order_war  1 "Peace" 2 "Adversary" 3 "Allied" 4 "Neutral"

encode each_war_status, gen(each_status) 
encode all_war_status, gen(all_status) label(order_war)
encode pays_grouping, gen(pays)


gen break=(year>1795)

/*
label var value Value
foreach i in 5 6 8 9 11{
gen country`i'=(year>1795 & pays==`i')
gen year_country`i'=country`i'*year_pays`i'
}
*/

****regress with common time trend and with pays specific time trends for exports
eststo: poisson value i.pays#c.year i.pays i.all_status if ///
	exportsimports=="Exports", vce(robust) iterate(40)
eststo: poisson value i.pays#c.year i.pays break#pays i.break#i.pays#c.year ///
	i.all_status if exportsimports=="Exports", vce(robust) iterate(40)
*eststo: poisson value i.pays year_pays1-year_pays12 country5-country11 ///
*i.all_status, vce(robust) difficult 

eststo: poisson value i.pays#c.year i.pays i.each_status if ///
	exportsimports=="Exports", vce(robust) iterate(40)
eststo: poisson value i.pays#c.year i.pays break#pays i.break#i.pays#c.year ///
	i.each_status if exportsimports=="Exports", vce(robust) iterate(40)

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

esttab using "$thesis/Data/do_files/Hamburg/tex/allcountry1_reg.tex", label not alignment(D{.}{.}{-1}) ///
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
	
*/
eststo clear

****regress with common time trend and with pays specific time trends for exports
eststo: poisson value c.year#i.pays i.pays i.all_status if ///
	exportsimports=="Imports", vce(robust) iterate(40)
eststo: poisson value c.year#i.pays i.pays break#pays i.break#i.pays#c.year ///
	i.all_status if exportsimports=="Imports", vce(robust) iterate(40)
*eststo: poisson value i.pays year_pays1-year_pays12 country5-country11 i.all_status, vce(robust) difficult 

eststo: poisson value c.year#i.pays i.pays i.each_status if ///
	exportsimports=="Imports", iterate(40) vce(robust)
eststo: poisson value c.year#i.pays i.pays break#pays i.break#i.pays#c.year ///
	i.each_status if exportsimports=="Imports", vce(robust) iterate(40)

esttab, label

