global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"


set more off

use "$thesis/database_dta/allcountry2", clear

/*gen one dummy for each war and 3 dummies for three groups of wars 
(Polish Austrian1 // Austrian2 Seven American // Revolutionary Napoleonic)
I generate them as string and then encode them to avoid creating 
and labelling a 1000 dummies*/

gen each_war_status=""
gen all_war_status=""

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


/*Encode all strings to use them as factor variables in the regression */

encode pays_grouping, gen(pays)

label define order_class 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order_class)

egen pays_class=group(pays class), label 

encode each_war_status, gen(each_status) 
egen each_status_class=group(each_status class), label
replace each_status_class=0 if each_status_class==. /* I do this to have peace 
														as reference cat*/

encode all_war_status, gen(all_status) 
egen all_status_class=group(all_status class), label
replace all_status_class=0 if all_status_class==.   /* I do this to have peace 
														as reference cat*/

														
/*Generate breaks for coffee and sugar after Haitian revolution  */
gen coffee=(year>1795 & class==1)
gen sugar=(year>1795 & class==3)

gen year_class1=coffee*year
gen year_class3=sugar*year

/*gen weights*/
bysort pays: egen pays_aggregate_exports=sum(value) if exportsimports=="Exports"
gen aggregate_exports=sum(value) if exportsimports=="Exports"
gen weight_exports=pays_aggregate_exports/aggregate_exports

bysort pays: egen pays_aggregate_imports=sum(value) if exportsimports=="Imports"
gen aggregate_imports=sum(value) if exportsimports=="Imports"
gen weight_imports=pays_aggregate_imports/aggregate_imports



/*
find countries with trend break?? 
foreach i in 2 3 5 8 9 10{
gen country`i'=(year>1795 & pays==`i')
gen year_country`i'=country`i'*year_pays`i'
}
*/

label var value Value

/*------------------------------------------------------------------------------
								regress with exports
------------------------------------------------------------------------------*/

/*Regress first no break, then break for coffee only and 
then both sugar and coffee (+experiment) with on dummy for all wars */

eststo export_all1: poisson value i.pays_class c.year#i.pays ///
	c.year#i.class i.all_status_class if exportsimports=="Exports" ///
	[iweight=weight_exports], vce(robust) iterate(40)
eststo export_all2: poisson value i.pays_class i.coffee#pays c.year#i.pays ///
	c.year#i.class i.coffee#c.year_class1 i.all_status_class if ///
	exportsimports=="Exports" [iweight=weight_exports], vce(robust) iterate(40)
eststo export_all3: poisson value i.pays_class i.coffee#i.pays ///
	i.sugar#i.pays c.year#i.pays c.year#i.class i.coffee#c.year_class1 ///
	i.sugar#c.year_class3 i.all_status_class if exportsimports=="Exports" ///
	[iweight=weight_exports], vce(robust) iterate(40) 
/*eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays ///
	year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 ///
	year_country2-year_country10 i.all_status_class, ///
	vce(robust) iterate(40) 
*/
esttab export_all1 export_all2 export_all3, label
esttab export_all1 export_all2 export_all3 ///
	using "$thesis/Data/do_files/Hamburg/Tables/allcountry2_all_export.csv", ///
	replace label mtitles("No breaks" "Break coffee" "Break coffee & sugar")


/*
esttab using "$thesis/Data/do_files/Hamburg/tex/allcountry2_all_reg.tex", ///
	label not indicate("Country-product FE= *.pays_class" ///
	"Country time trend= *year_pays*" "Product time trend=*year_class*" ///
	"Coffee break=*coffee*" "Sugar break=*sugar*") ///
	pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	varlab(_cons Constant 1.all_status_class "Adversary Coffee" ///
	2.all_status_class "Adversary Eau de vie" 3.all_status_class ///
	"Adversary Sugar" 4.all_status_class "Adversary Wine" ///
	6.all_status_class "Allied Coffee" 7.all_status_class "Allied Eau de vie" ///
	8.all_status_class "Allied Sugar" 9.all_status_class "Allied Wine" ///
	11.all_status_class "Neutral Coffee" 12.all_status_class ///
	"Neutral Eau de vie" 13.all_status_class "Neutral Sugar" ///
	14.all_status_class "Neutral Wine")	keep(11.all_status_class ///
	12.all_status_class 13.all_status_class 14.all_status_class)	///
	title(All countries: All wars on each product\label{tab1}) replace
*/

/*Regress first no break, then break for coffee only and then both sugar and 
coffee (+experiment) with on dummy for each of the three groups of wars*/

eststo export_each1: poisson value i.pays_class c.year#i.pays ///
	c.year#i.class i.each_status_class if exportsimports=="Exports" ///
	[iweight=weight_exports], vce(robust) iterate(40)
eststo export_each2: poisson value i.pays_class 0.coffee#pays ///
	0.sugar#i.pays c.year#i.pays c.year#i.class 0.coffee#c.year_class1 ///
	0.sugar#c.year_class3 i.each_status_class if exportsimports=="Exports" ///
	[iweight=weight_exports], vce(robust) iterate(40) 
eststo export_each3: poisson value i.pays_class 0.coffee#i.pays ///
	c.year#i.pays c.year#i.class 0.coffee#c.year_class1 ///
	i.each_status_class if exportsimports=="Exports" ///
	[iweight=weight_exports], vce(robust) iterate(40) 
/*eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays ///
	year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 ///
	year_country2-year_country10 i.each_status_class, vce(robust) iterate(40)  
*/
	
esttab, label
esttab export_each1 export_each2 export_each3 ///
	using "$thesis/Data/do_files/Hamburg/Tables/allcountry2_each_export.csv", ///
	replace label mtitles("No breaks" "Break coffee" "Break coffee & sugar")


/*
local macro 34.* 35.* 36.* 37.* 39.* 40.* 41.* 42.* 44.* ///
	45.* 46.* 47.* 49.* 50.* 51.* 52.* 54.* 55.* 56.* 57.* ///
	59.* 60.* 61.* 62.* 64.* 65.* 66.* 67.*
esttab using "$thesis/Data/do_files/Hamburg/tex/allcountry2_each_export.tex", ///
	label not indicate("Country-product FE= *.pays_class" ///
	"Country time trend= *year_pays*" "Product time trend=*year_class*" ///
	"Coffee break=*coffee*" "Sugar break=*sugar*") ///
	pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	varlab(_cons Constant 34.each_status_class "Polish Neutral Coffee" ///
	35.each_status_class "Polish Neutral Eau de vie" 36.each_status_class ///
	"Polish Neutral Sugar" 37.each_status_class "Polish Neutral Wine" ///
	39.each_status_class "Austrian1 Neutral Coffee" 40.each_status_class ///
	"Austrian1 Neutral Eau de vie" 41.each_status_class ///
	"Austrian1 Neutral Sugar" 42.each_status_class "Austrian1 Neutral Wine" ///
	44.each_status_class "Austrian2 Neutral Coffee" 45.each_status_class ///
	"Austrian2 Neutral Eau de vie" 46.each_status_class ///
	"Austrian2 Neutral Sugar" 47.each_status_class "Austrian2 Neutral Wine" ///
	49.each_status_class "Seven Neutral Coffee" 50.each_status_class ///
	"Seven Neutral Eau de vie" 51.each_status_class "Seven Neutral Sugar" ///
	52.each_status_class "Seven Neutral Wine" ///
	54.each_status_class "American Neutral Coffee" 55.each_status_class ///
	"American Neutral Eau de vie" 56.each_status_class ///
	"American Neutral Sugar" 57.each_status_class "American Neutral Wine" ///
	59.each_status_class "Revolutionary Neutral Coffee" 60.each_status_class ///
	"Revolutionary Neutral Eau de vie" 61.each_status_class ///
	"Revolutionary Neutral Sugar" 62.each_status_class ///
	"Revolutionary Neutral Wine" 64.each_status_class ///
	"Napoleonic Neutral Coffee" 65.each_status_class ///
	"Napoleonic Neutral Eau de vie" 66.each_status_class ///
	"Napoleonic Neutral Sugar" 67.each_status_class ///
	"Napoleonic Neutral Wine") keep(`macro') ///
	title(All countries: Each war on each product\label{tab1}) replace
*/

/*------------------------------------------------------------------------------
								regress with exports
------------------------------------------------------------------------------*/

/*Regress first no break, then break for coffee only and then both sugar and 
coffee (+experiment) with one dummy for all wars*/

eststo import_all1: poisson value i.pays_class c.year#i.pays ///
	c.year#i.class i.all_status_class if exportsimports=="Imports" ///
	[iweight=weight_imports], vce(robust) iterate(40)
eststo import_all2: poisson value i.pays_class c.year#i.pays ///
	c.year#i.class 0.coffee#c.year_class1 0.coffee#pays  ///
	i.all_status_class if exportsimports=="Imports" ///
	[iweight=weight_imports], vce(robust) iterate(40)
eststo import_all3: poisson value i.pays_class c.year#i.pays ///
	c.year#i.class 0.coffee#c.year_class1 0.coffee#pays ///
	0.sugar#pays 0.sugar#c.year_class3 i.all_status_class if ///
	exportsimports=="Imports" [iweight=weight_imports], vce(robust) iterate(40) 
/*eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays ///
	year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 ///
	year_country2-year_country10 i.all_status_class, vce(robust) difficult 
*/
esttab import_all1 import_all2 import_all3, label
esttab import_all1 import_all2 import_all3 ///
	using "$thesis/Data/do_files/Hamburg/Tables/allcountry2_all_import.csv", ///
	label replace mtitles("No breaks" "Break coffee" "Break coffee & sugar")

/*Regress first no break, then break for coffee only and then both sugar and 
coffee (+experiment) with on dummy for each of the three groups of wars*/

eststo import_each1: poisson value year i.pays_class c.year#i.pays ///
	c.year#i.class i.each_status_class if exportsimports=="Imports" ///
	[iweight=weight_imports], vce(robust) iterate(40)
eststo import_each2: poisson value i.pays_class 0.coffee#pays ///
	0.sugar#pays c.year#i.pays c.year#i.class 0.coffee#c.year_class1 ///
	0.sugar#c.year_class3 i.each_status_class if exportsimports=="Imports" ///
	[iweight=weight_imports], vce(robust) iterate(40) 
eststo import_each3: poisson value i.pays_class 0.coffee#pays ///
	c.year#i.pays c.year#i.class 0.coffee#c.year_class1 ///
	i.each_status_class if exportsimports=="Imports" ///
	[iweight=weight_imports], vce(robust) iterate(40) 
/*eststo: poisson value i.pays_class 0.coffee#pays 0.sugar#pays ///
	year_pays1-year_pays12 year_class1-year_class5 ///
	0.coffee#c.year_class1 0.sugar#c.year_class3 ///
	year_country2-year_country10 i.each_status_class, vce(robust) iterate(40)  
*/
	
esttab import_each1 import_each2 import_each3, label
esttab import_each1 import_each2 import_each3 ///
	using "$thesis/Data/do_files/Hamburg/Tables/allcountry2_each_import.csv", ///
	label replace mtitles("No breaks" "Break coffee" "Break coffee & sugar")


/*
esttab using "$thesis/Data/do_files/Hamburg/tex/allcountry2_all_reg.tex", ///
	label not indicate("Country-product FE= *.pays_class" ///
	"Country time trend= *year_pays*" "Product time trend=*year_class*" ///
	"Coffee break=*coffee*" "Sugar break=*sugar*") ///
	pr2 nonumbers mtitles("No breaks" "One break" "Two breaks") ///
	varlab(_cons Constant 1.all_status_class "Adversary Coffee" ///
	2.all_status_class "Adversary Eau de vie" 3.all_status_class ///
	"Adversary Sugar" 4.all_status_class "Adversary Wine" ///
	6.all_status_class "Allied Coffee" 7.all_status_class ///
	"Allied Eau de vie" 8.all_status_class "Allied Sugar" ///
	9.all_status_class "Allied Wine" 11.all_status_class "Neutral Coffee" ///
	12.all_status_class "Neutral Eau de vie" 13.all_status_class ///
	"Neutral Sugar" 14.all_status_class "Neutral Wine")	///
	keep(11.all_status_class 12.all_status_class 13.all_status_class ///
	14.all_status_class) title(All countries: All wars on each ///
	product\label{tab1}) replace
*/

eststo clear
