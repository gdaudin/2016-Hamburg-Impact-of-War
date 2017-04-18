global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"


set more off

use "$thesis/database_dta/bdd_courante2", clear
drop if year<1718
drop if pays_grouping=="?"
drop if pays_grouping=="????"
drop if pays_grouping=="Colonies françaises et étrangères" 
drop if pays_grouping=="Divers"
drop if pays_grouping=="Prises" 
drop if pays_grouping=="Russie" 
drop if pays_grouping=="Épaves et échouements" 
drop if pays_grouping=="France"  
drop if pays_grouping=="Indes" 
drop if pays_grouping=="Espagne-Portugal" 
drop if pays_grouping=="" 


gen each_war_status=""
gen all_war_status=""

foreach i of num 1733/1738{
replace each_war_status="War1 adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'

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
replace each_war_status="War1 allied" if each_war_status!="War1 neutral" & each_war_status!="War1 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
}


foreach i of num 1740/1743{
replace each_war_status="War1 adversary" if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War1 adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="War1 adversary" if pays_grouping=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
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
replace each_war_status="War1 allied" if each_war_status!="War1 neutral" & each_war_status!="War1 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
}


foreach i of num 1744/1748{
replace each_war_status="War2 adversary" if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War2 adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="War2 adversary" if pays_grouping=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
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
replace each_war_status="War2 allied" if each_war_status!="War2 neutral" & each_war_status!="War2 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
}

foreach i of num 1756/1763{
replace each_war_status="War2 adversary" if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War2 adversary" if pays_grouping=="Portugal" & year==`i'
replace each_war_status="War2 adversary" if pays_grouping=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="États-Unis d'Amérique" & year==`i'

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
replace each_war_status="War2 allied" if each_war_status!="War2 neutral" & each_war_status!="War2 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
}

foreach i of num 1778/1782{
replace each_war_status="War2 adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'

replace each_war_status="War2 neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="War2 neutral" if pays_grouping=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
}

foreach i of num 1778/1782{
replace each_war_status="War2 allied" if each_war_status!="War2 neutral" & each_war_status!="War2 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
}

foreach i of num 1792/1795{
replace each_war_status="War3 adversary" if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Espagne" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Hollande" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Portugal" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Italie" & year==`i'


replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Espagne" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Italie" & year==`i'


replace each_war_status="War3 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War3 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War3 neutral" if pays_grouping=="Suisse" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
}

foreach i of num 1792/1795{
replace each_war_status="War3 allied" if each_war_status!="War3 neutral" & each_war_status!="War3 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
}

foreach i of num 1796/1802{
replace each_war_status="War3 adversary" if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Portugal" & year==`i'
replace each_war_status="War3 adversary" if pays_grouping=="Italie" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Italie" & year==`i'

replace each_war_status="War3 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War3 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War3 neutral" if pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}

foreach i of num 1796/1802{
replace each_war_status="War3 allied" if each_war_status!="War3 neutral" & each_war_status!="War3 adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
}


foreach i of num 1803/1814{
replace each_war_status="War3 allied" if year==`i'
replace all_war_status="Allied" if year==`i'
}

foreach i of num 1803/1814{
replace each_war_status="War3 adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
}

foreach i in 1805 1809{
replace each_war_status="War3 adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1805/1809{
replace each_war_status="War3 allied" if each_war_status!="Napoleonic neutral" & each_war_status!="Napoleonic adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & all_war_status!="Neutral" & year==`i'
}

foreach i in 1806 1807{
replace each_war_status="War3 neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1813/1815{
replace each_war_status="War3 adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1800/1807{
replace each_war_status="War3 adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
}
foreach i of num 1809/1815{
replace each_war_status="War3 adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
}

*****1806-1812 germany is allied
foreach i of num 1806/1807{
replace each_war_status="War3 adversary" if pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}
foreach i of num 1813/1815{
replace each_war_status="War3 adversary" if pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}

foreach i of num 1808/1815{
replace each_war_status="War3 adversary" if pays_grouping=="Espagne" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Espagne" & year==`i'
}

foreach i of num 1803/1815{
replace each_war_status="War3 neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="War3 neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="War3 neutral" if pays_grouping=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="États-Unis d'Amérique" & year==`i'
}

replace each_war_status="War3 adversary" if pays_grouping=="Suisse" & year==1815
replace each_war_status="War3 adversary" if pays_grouping=="Hollande" & year==1815

replace all_war_status="Adversary" if pays_grouping=="Suisse" & year==1815
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==1815


****gen country dummies and year trend
encode pays_grouping, gen(pays)


****gen product dummies and year trend
label define order_class 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order_class)

****gen country product fe
egen pays_class=group(pays class), label 


***gen war dummies

encode each_war_status, gen(each_status) 
egen each_status_class=group(each_status class), label
replace each_status_class=0 if each_status_class==.

encode all_war_status, gen(all_status) 
egen all_status_class=group(all_status class), label
replace all_status_class=0 if all_status_class==.


gen coffee=(year>1795 & class==1)
gen sugar=(year>1795 & class==3)

gen year_class1=coffee*year
gen year_class3=sugar*year

****gen weights
bysort pays: egen aggregate_exports=sum(value) if exportsimports=="Exports"
bysort pays class: egen products_exports=sum(value) if exportsimports=="Exports"
gen weight_exports=products_exports/aggregate_exports

bysort pays: egen aggregate_imports=sum(value) if exportsimports=="Imports"
bysort pays class: egen products_imports=sum(value) if exportsimports=="Imports"
gen weight_imports=products_imports/aggregate_imports

/*
find countries which export more sugar and coffee
foreach i of num 1/12{
local label : label (pays) `i'
graph pie value if pays==`i', over(class) title("`i'`label'") plabel(_all percent)
graph export "$ete/Thesis/Data/Graph/Product_pays/pays`i'.ps", replace
}
find countries with trend break?? 
foreach i in 2 3 5 8 9 10{
gen country`i'=(year>1795 & pays==`i')
gen year_country`i'=country`i'*year_pays`i'
}
*/

label var value Value
****regress first no break, then break for coffee only and then both sugar and coffee (+experiment) exports
eststo export_all1: poisson value i.pays_class c.year#i.pays c.year#i.class i.all_status_class ///
	if exportsimports=="Exports" [iweight=weight_exports], vce(robust)
eststo export_all2: poisson value i.pays_class i.coffee#pays c.year#i.pays c.year#i.class ///
	i.coffee#c.year_class1 i.all_status_class if exportsimports=="Exports" ///
	[iweight=weight_exports], vce(robust) iterate(40)
eststo export_all3: poisson value i.pays_class i.coffee#i.pays i.sugar#i.pays ///
	c.year#i.pays c.year#i.class i.coffee#c.year_class1 i.sugar#c.year_class3 ///
	i.all_status_class if exportsimports=="Exports" [iweight=weight_exports], vce(robust) iterate(40) 
/*eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 year_country2-year_country10 i.all_status_class, vce(robust) difficult 
*/
esttab, label

/*
esttab using "$thesis/Data/do_files/Hamburg/tex/allcountry2_all_reg.tex",label not ///
	indicate("Country-product FE= *.pays_class" "Country time trend= *year_pays*" "Product time trend=*year_class*" ///
	"Coffee break=*coffee*" "Sugar break=*sugar*") ///
	pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") varlab(_cons Constant ///
	1.all_status_class "Adversary Coffee" 2.all_status_class "Adversary Eau de vie" 3.all_status_class "Adversary Sugar" 4.all_status_class "Adversary Wine" ///
	6.all_status_class "Allied Coffee" 7.all_status_class "Allied Eau de vie" 8.all_status_class "Allied Sugar" 9.all_status_class "Allied Wine" ///
	11.all_status_class "Neutral Coffee" 12.all_status_class "Neutral Eau de vie" 13.all_status_class "Neutral Sugar" 14.all_status_class "Neutral Wine")	///
	keep(11.all_status_class 12.all_status_class 13.all_status_class 14.all_status_class)	///
	title(All countries: All wars on each product\label{tab1}) replace
*/

eststo export_each1: poisson value i.pays_class c.year#i.pays c.year#i.class i.each_status_class ///
	if exportsimports=="Exports" [iweight=weight_exports], vce(robust) iterate(40)
eststo export_each2: poisson value i.pays_class 0.coffee#pays 0.sugar#i.pays c.year#i.pays c.year#i.class ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 i.each_status_class if ///
	exportsimports=="Exports" [iweight=weight_exports], vce(robust) iterate(40) 
eststo export_each3: poisson value i.pays_class 0.coffee#i.pays c.year#i.pays c.year#i.class ///
	0.coffee#c.year_class1 i.each_status_class if exportsimports=="Exports" [iweight=weight_exports], ///
	vce(robust) iterate(40) 
/*eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 year_country2-year_country10 i.each_status_class, vce(robust) difficult 
*/
	
esttab, label

/*
local macro 34.* 35.* 36.* 37.* 39.* 40.* 41.* 42.* 44.* 45.* 46.* 47.* 49.* 50.* 51.* 52.* 54.* 55.* 56.* 57.* ///
	59.* 60.* 61.* 62.* 64.* 65.* 66.* 67.*
esttab using "$thesis/Data/do_files/Hamburg/tex/allcountry2_each_reg.tex",label not ///
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
*/


eststo import_all1: poisson value i.pays_class c.year#i.pays c.year#i.class i.all_status_class ///
	if exportsimports=="Imports" [iweight=weight_imports], vce(robust) iterate(40)
eststo import_all2: poisson value i.pays_class c.year#i.pays c.year#i.class 0.coffee#c.year_class1 ///
	0.coffee#pays  i.all_status_class if exportsimports=="Imports" [iweight=weight_imports], vce(robust) iterate(40)
eststo import_all3: poisson value i.pays_class c.year#i.pays c.year#i.class 0.coffee#c.year_class1 ///
	0.coffee#pays 0.sugar#pays 0.sugar#c.year_class3 i.all_status_class if exportsimports=="Imports" ///
	[iweight=weight_imports], vce(robust) iterate(40) 
/*eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 year_country2-year_country10 i.all_status_class, vce(robust) difficult 
*/

eststo import_each1: poisson value year i.pays_class c.year#i.pays c.year#i.class i.each_status_class ///
	if exportsimports=="Imports" [iweight=weight_imports], vce(robust) iterate(40)
eststo import_each2: poisson value i.pays_class 0.coffee#pays 0.sugar#pays c.year#i.pays c.year#i.class ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 i.each_status_class if ///
	exportsimports=="Imports" [iweight=weight_imports], vce(robust) iterate(40) 
eststo import_each3: poisson value i.pays_class 0.coffee#pays c.year#i.pays c.year#i.class ///
	0.coffee#c.year_class1 i.each_status_class if exportsimports=="Imports" ///
	[iweight=weight_imports], vce(robust) iterate(40) 
/*eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 year_country2-year_country10 i.each_status_class, vce(robust) difficult 
*/
	
esttab, label

/*
esttab using "$thesis/Data/do_files/Hamburg/tex/allcountry2_all_reg.tex",label not ///
	indicate("Country-product FE= *.pays_class" "Country time trend= *year_pays*" "Product time trend=*year_class*" ///
	"Coffee break=*coffee*" "Sugar break=*sugar*") ///
	pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") varlab(_cons Constant ///
	1.all_status_class "Adversary Coffee" 2.all_status_class "Adversary Eau de vie" 3.all_status_class "Adversary Sugar" 4.all_status_class "Adversary Wine" ///
	6.all_status_class "Allied Coffee" 7.all_status_class "Allied Eau de vie" 8.all_status_class "Allied Sugar" 9.all_status_class "Allied Wine" ///
	11.all_status_class "Neutral Coffee" 12.all_status_class "Neutral Eau de vie" 13.all_status_class "Neutral Sugar" 14.all_status_class "Neutral Wine")	///
	keep(11.all_status_class 12.all_status_class 13.all_status_class 14.all_status_class)	///
	title(All countries: All wars on each product\label{tab1}) replace
*/

eststo clear


********************************************************************************
********************K-CLUSTERING BY SITC TRADE COMPOSITION**********************
********************************************************************************
*preserve
keep if exportsimports=="Exports"
drop if sitc18_rev3=="???"
drop if sitc18_rev3=="[???]"
drop if sitc18_rev3==""
encode sitc18_rev3, gen(sitc) 
collapse (sum) value, by(pays sitc)
local lsitc : variable label sitc
levelsof sitc, local(sitc_levels)       /* create local list of all values of `var' */
foreach val of local sitc_levels {       /* loop over all values in local list `var'_levels */
local sitcvl`val' : label sitc `val'    /* create macro that contains label for each value */
}
reshape wide value, i(pays) j(sitc)
local variablelist "value"
foreach variable of local variablelist{
foreach value of local sitc_levels{
label variable `variable'`value' "`l`variable'' `sitcvl`value''"
}
}

cluster kmeans value*, k(3) name(clust1) 
cluster list clus1
restore

preserve
keep if exportsimports=="Imports"
drop if sitc18_rev3=="???"
drop if sitc18_rev3=="[???]"
drop if sitc18_rev3==""
encode sitc18_rev3, gen(sitc) 
collapse (sum) value, by(pays sitc)
local lsitc : variable label sitc
levelsof sitc, local(sitc_levels)       /* create local list of all values of `var' */
foreach val of local sitc_levels {       /* loop over all values in local list `var'_levels */
local sitcvl`val' : label sitc `val'    /* create macro that contains label for each value */
}
reshape wide value, i(pays) j(sitc)
local variablelist "value"
foreach variable of local variablelist{
foreach value of local sitc_levels{
label variable `variable'`value' "`l`variable'' `sitcvl`value''"
}
}

cluster kmeans value*, k(3) name(clustn) 
cluster list clus1
restore
