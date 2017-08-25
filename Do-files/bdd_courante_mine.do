
global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"


if "`c(username)'" =="guillaumedaudin" {
	global thesis ~/Documents/Recherche/2016 Hamburg
}


set more off

capture use "/Users/Tirindelli/Desktop/hambourg/bdd courante.dta", clear

if "`c(username)'" =="guillaumedaudin" {
	use "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
}



********************************************************************************
*****************************TEST BENFORD***************************************
********************************************************************************


drop if value==0
drop if value==.
gen firstdigit = real(substr(string(value), 1, 1))
drop if firstdigit==.
*firstdigit value, percent
contract firstdigit
set obs 9 
gen x = _n 
gen expected = log10(1 + 1/x) 
twoway histogram firstdigit [fw=_freq], plotregion(fcolor(white)) ///
	graphregion(fcolor(white)) barw(0.5) bfcolor(ltblue) blcolor(navy) ///
	discrete fraction || connected expected x, xla(1/9) ///
	title("observed and expected") caption("French source") yla(, ang(h) ///
	format("%02.1f")) legend(off) plotregion(fcolor(white)) ///
	graphregion(fcolor(white))
graph export "$thesis/Graph/Benford/benford_fr.png", as(png) replace


********************************************************************************
*****************************CLEAN DATABASE*************************************
********************************************************************************



capture use "/Users/Tirindelli/Desktop/hambourg/bdd courante.dta", clear

if "`c(username)'" =="guillaumedaudin" {
	use "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
}

drop if year==1805.75 | year==1839
replace year=1780 if year==17780
drop if yearstr=="10 mars-31 décembre 1787"
drop if direction=="France"
drop if year<1718
drop if pays_grouping=="?" | pays_grouping=="????" ///
	| pays_grouping=="Prises" | pays_grouping=="Épaves et échouements" ///
	| pays_grouping=="France" | pays_grouping=="Indes" ///
	| pays_grouping=="Colonies françaises et étrangères" ///
	| pays_grouping=="Espagne-Portugal" | pays_grouping=="" ///
	| pays_grouping=="Divers" ///

****keep only 5 categories of goods
replace classification_hamburg_large="Not classified" ///
	if classification_hamburg_large==""
drop if classification_hamburg_large=="Blanc ; de baleine" | ///
	classification_hamburg_large=="Huile ; de baleine" | ///
	classification_hamburg_large=="Minum"
replace classification_hamburg_large="Sugar" if ///
	classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
replace classification_hamburg_large="Coffee" if ///
	classification_hamburg_large=="Café"
replace classification_hamburg_large="Wine" if ///
	classification_hamburg_large=="Vin ; de France"
replace classification_hamburg_large="Eau de vie" if ///
	classification_hamburg_large=="Eau ; de vie"
replace classification_hamburg_large="Other" if ///
	classification_hamburg_large!="Sugar" & ///
	classification_hamburg_large!="Coffee" & ///
	classification_hamburg_large!="Wine" & ///
	classification_hamburg_large!="Eau de vie" 


****keep only 5 sectors of sitc
drop if sitc18_en=="Precious metals"
replace sitc18_en="Other" if sitc18_en=="Mixed flows" ///
	| sitc18_en=="Unknown products" ///
	| sitc18_en=="Various uncertain" | sitc18_en==""
replace sitc18_en="European foodstuff and beverage" if  ///
	sitc18_en=="Other foodstuff and live animals" ///
	| sitc18_en=="Beverages and tobacco"
replace sitc18_en="Raw mat; fuel; oils" if ///
	sitc18_en=="Raw materials, inedible, except fuels" ///
	| sitc18_en=="Fuels" | sitc18_en=="Oils"
replace sitc18_en="Various manuf" if ///
	sitc18_en=="Leather products except saddlery" ///
	| sitc18_en=="Wood, cork and cane products" ///
	| sitc18_en=="Other industrial products" ///
	| sitc18_en=="Metal products" | sitc18_en=="Paper products" ///
	| sitc18_en=="Machines and transportation" ///
	| sitc18_en=="Various manufactures" ///
	| sitc18_en=="Processed chemical products"
replace sitc18_en="Textile manuf" if sitc18_en=="Linen threads and fabrics" ///
	| sitc18_en=="Wool threads and fabrics" ///
	| sitc18_en=="Silk threads and fabrics" ///
	| sitc18_en=="Coton threads and fabrics" ///
	| sitc18_en=="Other vegetal threads and fabrics" ///
	| sitc18_en=="Other threads and fabrics" 	


collapse (sum) value, by(sourcetype year direction ///
	pays_grouping exportsimports marchandises_simplification ///
	classification_hamburg_large sitc18_en)

merge m:1 year using "$thesis/database_dta/FR_silver.dta"
drop if _merge==2
drop _merge

replace value=value*FR_silver
replace value=value/1000000

***save temporary database for comparison with hamburg dataset
save "$thesis/database_dta/elisa_bdd_courante", replace




********************************************************************************
*************************ESTIMATE PRODUCTS BEFORE 1750**************************
********************************************************************************
use "$thesis/database_dta/elisa_bdd_courante", replace

*****keep only sources where I have both national and direction data

drop if sourcetype!="Local" & sourcetype!="National par direction" ///
	& sourcetype!="National par direction (-)" ///
	& sourcetype!="Objet Général" & sourcetype!="Résumé" 
drop if year==1750 & sourcetype=="Local"
replace direction="total" if direction=="" & sourcetype !="Local" & sourcetype !="National par direction (-)"
list if direction==""


collapse (sum) value, by(sourcetype year direction pays_grouping ///
		classification_hamburg_large exportsimports)

****drop pays if there are too few obs
egen _count=count(value), by(exportsimports pays_grouping)
drop if _count<21
drop _count
 
*****drop direction that appear only once
by exportsimports direction year, sort: gen nvals = _n == 1
by exportsimports direction: replace nvals=sum(nvals)
by exportsimports direction: replace nvals = nvals[_N]
drop if nvals==1
drop nvals


encode direction, gen(dir)
encode pays, gen(pays)
label define order 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order)
gen lnvalue=ln(value)

***gen weight
gen value_test=1
replace value_test=. if year==1787 & sourcetype=="Résumé"
replace value_test=. if year==1788 & sourcetype=="Résumé"
replace value_test=. if year==1777 & sourcetype=="National par direction (-)"
*replace value_test=. if year>1751 & sourcetype=="Local"


gen value_test2=value*value_test

gen forweight=value_test2 if direction=="total"
tab forweight if year==1721
bysort year exportsimports pays class: egen weight_total=max(forweight)

drop forweight
gen share = value/weight_total

br if share >1 & share!=.

aieaie
bysort exportsimports pays class direction: egen weight=mean(share)
tab weight direction


bysort year exportsimports pays class: egen weight_total=total(value_test2), missing
bysort year exportsimports dir pays class: egen weight_dir=total(value_test2), missing
gen value_weight1=weight_total/weight_dir
bysort year exportsimports dir pays class: egen value_weight=mean(value_weight1)


/*------------------------------------------------------------------------------
						Estimate exports and imports
------------------------------------------------------------------------------*/


fillin exportsimport year pays_grouping direction classification_hamburg_large
gen value_test=value 
bysort year direction exportsimports: egen test_year=total(value_test), missing
su value if value!=0
replace value=r(min)/100 if test_year!=. & value==. 
drop value_test test_year



*levelsof exportsimports, local(exportsimports)
local exportsimports Imports
foreach ciao in `exportsimports'{
gen pred_value_`ciao'=.


levelsof pays, local(levels) 	/*levelsof is just in case we add more pays 
								to pays_grouping and I do 
								not update this do_file, not important
								`: word count `levels''*/

foreach i of num 1/1{
foreach j of num 1/1{
su lnvalue if class==`i' & pays==`j' & exportsimports=="`ciao'"
if r(N)>1{
qui reg lnvalue i.year i.dir [iw=value] if ///
	exportsimports=="`ciao'" & pays==`j' & class==`i', robust 
predict value2 if ///
	exportsimports=="`ciao'" & pays==`j' & class==`i'
gen value_test=value if ///
	exportsimports=="`ciao'" & pays==`j' & class==`i'
gen value2_bis=value2
bysort year: egen test_year=total(value_test), missing
replace value2_bis=. if test_year==.
bysort dir: egen test_dir=total(value_test), missing
replace value2_bis=. if test_dir==.
gen value3=exp(value2_bis)
quietly su dir if direction=="total"	/*just in case we add more direction 
										and I do not update this do_file, 
										not important*/ 

replace pred_value_`ciao'=value3 if class==`i' & pays==`j' ///
	& dir==r(mean) & exportsimports=="`ciao'"
drop value2* value_test value3 test*
continue
}
}
}

twoway (scatter pred_value_`ciao' value) 



*have a look at imputed export data
bysort year exportsimports pays class: egen value_graph=total(value_test2), missing
by year exportsimports pays class:replace value_graph=. if _n!=1
sort year
levelsof pays, local(levels)
foreach i of num 1/1{
foreach j of num 1/1{
twoway (connected pred_value_`ciao' year, msize(tiny) legend(label(1 "Predicted"))) ///
	(connected value_graph year, msize(tiny) legend(label(2 "Observed"))) ///
	if pays==`j' & class==`i' & exportsimports=="`ciao'", title(`ciao') ///
	subtitle("`: label (pays) `j'', `: label (class) `i''") ///
	plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	caption("Values in tons of silver") 
graph export "$thesis/Graph/Estimation_product/`ciao'_class`i'_pay`j'.png", as(png) replace

*drop value_test*
*drop value_graph
}
}


}


quietly su dir if direction=="total"
*keep if dir==r(mean)

drop if year==1752 |year==1754
drop if year>1753 & year<1762
drop if year>1767 & year<1783
drop if year>1786


collapse (sum) pred_value_`ciao', by(year pays_grouping classification_hamburg_large exportsimports)
save "$thesis/database_dta/product_estimation", replace


********************************************************************************
*************************ESTIMATE SECTORS BEFORE 1750**************************
********************************************************************************
use "$thesis/database_dta/elisa_bdd_courante", replace

*****keep only sources where I have both national and direction data
replace direction="total" if direction==""
drop if sourcetype!="Local" & sourcetype!="National par direction" ///
	& sourcetype!="National par direction (-)" ///
	& sourcetype!="Objet Général" & sourcetype!="Résumé" 
drop if year>1789


collapse (sum) value, by(sourcetype year direction pays_grouping ///
		sitc18_en exportsimports)

/* HAVE A LOOK AT COUNTRIES SITC EXPORTS/IMPORTS COMPOSITION
cd "/Users/Tirindelli/Google Drive/ETE/Thesis/Graph/Sector_pays"
preserve 
collapse (sum) value, by(sitc18_en)
graph pie value, over(sitc18_en) plabel(_all percent) ///
	title("Aggregate total trade")
graph export total_trade.png, as(png) replace
restore

***find countries for sitc export composition

foreach i of num 1/13{
local label : label (pays) `i'
graph pie value if pays==`i', over(sitc) title("`i'`label'") ///
	plabel(_all percent) subtitle("Total")
graph export "pays`i'_tot.png", replace as(png)
}
foreach i of num 1/13{
local label : label (pays) `i'
graph pie value if pays==`i' & exportsimports=="Exports", over(sitc) ///
	title("`i'`label'") plabel(_all percent) subtitle("Exports")
graph export "pays`i'_export.png", replace as(png)
}

foreach i of num 1/13{
local label : label (pays) `i'
graph pie value if pays==`i' & exportsimports=="Imports", over(sitc) ///
	title("`i'`label'") plabel(_all percent) subtitle("Imports")
graph export "pays`i'_import.png", replace as(png)
}
*/



****drop pays if there are too few obs
egen _count=count(value), by(exportsimports pays_grouping)
drop if _count<21
drop _count
 
*****drop direction that appear only once
by exportsimports direction year, sort: gen nvals = _n == 1
by exportsimports direction: replace nvals=sum(nvals)
by exportsimports direction: replace nvals = nvals[_N]
drop if nvals==1
drop nvals

fillin exportsimport year pays_grouping direction sitc18_en
gen value_test=value 
bysort year direction exportsimports: egen test_year=total(value_test), missing
su value if value!=0
replace value=r(min)/100 if test_year!=. & value==. 
drop value_test test_year

encode direction, gen(dir)
encode pays, gen(pays)
encode sitc18_en, gen(sitc) label(order)
gen lnvalue=ln(value)

/*------------------------------------------------------------------------------
					Estimate exports and imports
------------------------------------------------------------------------------*/

levelsof exportsimports, local(exportsimports)
foreach ciao in `exportsimports'{

gen pred_value_`ciao'=.

levelsof pays, local(levels)

foreach i of num 1/6{
foreach j of num 1/`: word count `levels''{
su lnvalue if sitc==`i' & pays==`j' & exportsimports=="`ciao'"
if r(N)>1{
qui reg lnvalue i.year i.dir [iw=value] if ///
	exportsimports=="`ciao'" & pays==`j' & sitc==`i', robust 
predict value2 if ///
	exportsimports=="`ciao'" & pays==`j' & sitc==`i'
gen value_test=value if ///
	exportsimports=="`ciao'" & pays==`j' & sitc==`i'
gen value2_bis=value2
bysort year: egen test_year=total(value_test), missing
replace value2_bis=. if test_year==.
bysort dir: egen test_dir=total(value_test), missing
replace value2_bis=. if test_dir==.
gen value3=exp(value2_bis)
quietly su dir if direction=="total"	/*just in case we add more direction 
										and I do not update this do_file, 
										not important*/ 

replace pred_value_`ciao'=value3 if sitc==`i' & pays==`j' ///
	& dir==r(mean) & exportsimports=="`ciao'"
drop value2* value_test value3 test*
continue
}
}
}

*****gen var to graph properly
/*
gen value_test=1
replace value_test=0 if year==1787 & sourcetype=="Résumé"
replace value_test=0 if year==1788 & sourcetype=="Résumé"
replace value_test=0 if year==1777 & sourcetype=="National par direction (-)"
replace value_test=0 if year>1751 & sourcetype=="Local"

gen value_test2=value*value_test

bysort year exportsimports pays sitc: egen value_graph=total(value_test2)
by year exportsimports pays sitc:replace value_graph=. if _n!=1

replace value_graph=ln(value_graph)

sort year
levelsof pays, local(levels)
foreach i of num 1/5{
foreach j of num 1/`: word count `levels''{
twoway (connected pred_value_`ciao' year, msize(tiny) legend(label(1 "Predicted")) ///
	(connected value_graph year, msize(tiny) legend(label(2 "Observed")) ///
	if pays==`j' & sitc==`i' & exportsimports=="`ciao'", title(`ciao') ///
	subtitle("`: label (pays) `j'', `: label (sitc) `i''") ///
	plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	caption("Values in tons of silver") 
graph export "$thesis/Graph/Estimation_product/`ciao'_sitc`i'_pay`j'.png", as(png) replace

drop value_test*
drop value_graph
}
}
*/

}


/* HAVE A LOOK AT IMPUTED SITC VALUES
collapse (sum) pred_value value, by(year pays_grouping pays ///
	direction dir sitc)
foreach i of num 1/5{
foreach j of num 1/12{
twoway (connected pred_value year) (connected value year) if pays==`j' ///
	& sitc==`i' & dir==21, title(`: label (pays) `j'') ///
	subtitle( `: label (sitc) `i'')
graph export sict`i'_pay`j'.png, as(png) replace
}
}
*/

quietly su dir if direction=="total"
keep if dir==r(mean)

drop if year==1752 |year==1754
drop if year>1753 & year<1762
drop if year>1767 & year<1783
drop if year>1786


collapse (sum) pred_value`ciao', by(year pays_grouping sitc18_en exportsimports)
save "$thesis/database_dta/sector_estimation", replace


********************************************************************************
***************************CREATE 4 DATABASES***********************************
********************************************************************************
use "$thesis/database_dta/elisa_bdd_courante", replace
/* LEGEND OF SOURCETYPE
- Colonies: 1787, 1788, 1789
- Divers: 1839
- Divers - in: 1783, 1784
- Local: 1718-1741, 1744-1780 
- National par Direction: 1750, 1789
- National par Direction (-): 1749, 1751, 1777, 1787
- Objet Général: 1752, 1754-1761, 1767-1780, 1782, 1787, 1788
- Résumé: 1787-1789, 1797-1821
- Tableau Général: 1716-1775, 1777-1782 (aggregate)
- Tableau de marchandises: 1821
- Tableau des quantités: 1822
*/


collapse (sum) value, by(year sourcetype pays_grouping sitc18_en ///
	classification_hamburg_large exportsimports)

/*------------------------------------------------------------------------------
				save db with no product differentiation
------------------------------------------------------------------------------*/

preserve
***drop double counting 
foreach i of num 1716/1782{
drop if sourcetype!="Tableau Général" & year==`i'
}

foreach i of num 1782/1822{
drop if sourcetype!="Résumé" & year==`i'
}

collapse (sum) value, by(year pays_grouping exportsimports)

save "$thesis/database_dta/allcountry1", replace

keep if pays_grouping=="Nord"
drop pays_grouping
save "$thesis/database_dta/hamburg1", replace
restore

/*------------------------------------------------------------------------------
					save db with classification hamburg
------------------------------------------------------------------------------*/

***drop double counting 
drop if sourcetype=="Colonies" | sourcetype=="Divers" ///
	| sourcetype=="Divers - in" | sourcetype=="National par direction" ///
	| sourcetype=="Tableau Général" | sourcetype=="Tableau des quantités"

foreach i of num 1716/1751{
drop if sourcetype!="Local" & year==`i'
}
drop if sourcetype!="Objet Général" & year==1752
drop if sourcetype!="Local" & year==1753
foreach i of num 1754/1761{
drop if sourcetype!="Objet Général" & year==`i'
}
foreach i of num 1762/1766{
drop if sourcetype!="Local" & year==`i'
}
foreach i of num 1767/1780{
drop if sourcetype!="Objet Général" & year==`i'
}

foreach i in 1782 1787 1788{
drop if sourcetype!="Objet Général" & year==`i'
}
foreach i of num 1789/1821{
drop if sourcetype!="Résumé" & year==`i'
}


preserve
collapse (sum) value, by(year pays_grouping ///
classification_hamburg_large exportsimports)

*****merge with imputed data 
merge m:1 exportsimports year pays_grouping classification_hamburg_large ///
using "$thesis/database_dta/product_estimation"
drop if _merge==2
drop _merge

replace value = pred_value if year<1752 & pred_value!=.
replace value=pred_value if year==1753 & pred_value!=.
replace value = pred_value if year>1761 & year<1768 & pred_value!=.
replace value = pred_value if year==1781 & pred_value!=.
drop pred_value
drop if value==.

save "$thesis/database_dta/allcountry2", replace

keep if pays_grouping=="Nord" 
drop pays_grouping 
save "$thesis/database_dta/hamburg2", replace
restore
/*------------------------------------------------------------------------------
				save db with sict classification
------------------------------------------------------------------------------*/

preserve
collapse (sum) value, by(year pays_grouping ///
sitc18_en exportsimports)

*****merge with imputed data 
merge m:1 exportsimports year pays_grouping sitc18_en ///
using "$thesis/database_dta/sector_estimation"
drop if _merge==2
drop _merge

replace value = pred_value if year<1752 & pred_value!=.
replace value=pred_value if year==1753 & pred_value!=.
replace value = pred_value if year>1761 & year<1768 & pred_value!=.
replace value = pred_value if year==1781 & pred_value!=.
drop pred_value
drop if value==.


save "$thesis/database_dta/allcountry2_new", replace
restore


