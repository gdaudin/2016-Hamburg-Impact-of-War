






global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"


if "`c(username)'" =="guillaumedaudin" {
	global thesis ~/Documents/Recherche/2016 Hamburg
}


set more off

capture use "$thesis/Données Stata/bdd courante.dta", clear

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



capture use "$thesis/Données Stata/bdd courante.dta", clear

if "`c(username)'" =="guillaumedaudin" {
	use "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
}

drop if year==1805.75 | year==1839
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

***save temporary database for comparison with hamburg dataset
save "$thesis/database_dta/elisa_bdd_courante", replace




********************************************************************************
*************************ESTIMATE PRODUCTS BEFORE 1750**************************
********************************************************************************
use "$thesis/database_dta/elisa_bdd_courante", replace

*****keep only sources where I have both national and direction data
replace direction="total" if direction==""
drop if sourcetype!="Local" & sourcetype!="National par direction" ///
	& sourcetype!="National par direction (-)" ///
	& sourcetype!="Objet Général" & sourcetype!="Résumé" 
drop if year>1789


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

fillin exportsimport year pays_grouping direction classification_hamburg_large

encode direction, gen(dir)
encode pays, gen(pays)
label define order 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order)
gen lnvalue=ln(value)
gen pred_value=.

/*------------------------------------------------------------------------------
								Estimate exports
------------------------------------------------------------------------------*/


levelsof pays, local(levels) 	/*levelsof is just in case we add more pays 
								to pays_grouping and I do 
								not update this do_file, not important*/

foreach i of num 1/5{
foreach j of num 1/`: word count `levels''{
su lnvalue if class==`i' & pays==`j' & exportsimports=="Exports"
if r(N)>1{
quietly reg lnvalue i.year i.dir [iw=value] if ///
	exportsimports=="Exports" & pays==`j' & class==`i', robust 
predict value2 
gen value3=exp(value2)
quietly su dir if direction=="total"	/*just in case we add more direction 
										and I do not update this do_file, 
										not important*/ 

replace pred_value=value3 if class==`i' & pays==`j' ///
	& dir==r(mean) & exportsimports=="Exports"
drop value2 value3
continue
}
}
}

/*------------------------------------------------------------------------------
								Estimate imports
------------------------------------------------------------------------------*/


levelsof pays, local(levels)
*di "`: word count `levels''"
foreach i of num 1/5{
foreach j of num 1/`: word count `levels''{
di "`: label (pays) `j'' `: label (class) `i''"
su lnvalue if class==`i' & pays==`j' & exportsimports=="Imports"
if r(N)>1{
quietly reg lnvalue i.year i.dir [iw=value] if ///
	exportsimports=="Imports" & pays==`j' & ///
	class==`i', robust 
predict value2 
gen value3=exp(value2)
quietly su dir if direction=="total"
replace pred_value=value3 if class==`i' & pays==`j' ///
	& dir==r(mean) & exportsimports=="Imports" 
drop value2 value3
continue
}
}
}


/*
have a look at imputed data
collapse (sum) pred_value value, by(year pays_grouping pays ///
	direction dir classification_hamburg_large class)
foreach i of num 1/5{
foreach j of num 1/12{
twoway (connected pred_value year) (connected value year) if pays==`j' ///
	& class==`i' & dir==21, title(`: label (pays) `j'') ///
	subtitle( `: label (class) `i'')
graph export class`i'_pay`j'.png, as(png) replace
}
}
*/
quietly su dir if direction=="total"
keep if dir==r(mean)

drop if year==1752 |year==1754
drop if year>1753 & year<1762
drop if year>1767 & year<1783
drop if year>1786

/* drop imputed data which look implausible?
drop if pays==12
drop if pays==8 
drop if class==1 & pays==10
drop if class==2 & pays==1
drop if class==2 & pays==7
drop if class==2 & pays==10
drop if class==2 & pays==11
drop if class==3 & pays==1
drop if class==3 & pays==2
drop if class==3 & pays==10
drop if class==4 & pays==1
drop if class==4 & pays==7
drop if class==4 & pays==11
*/

collapse (sum) pred_value, by(year pays_grouping ///
	exportsimports classification_hamburg_large)
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

encode direction, gen(dir)
encode pays, gen(pays)
encode sitc18_en, gen(sitc) label(order)
gen lnvalue=ln(value)
gen pred_value=.

/*------------------------------------------------------------------------------
								Estimate exports
------------------------------------------------------------------------------*/

levelsof pays, local(levels)

foreach i of num 1/6{
foreach j of num 1/`: word count `levels''{
su lnvalue if sitc==`i' & pays==`j' & exportsimports=="Exports"
if r(N)>1{
quietly reg lnvalue i.year i.dir [iw=value] if ///
	exportsimports=="Exports" & pays==`j' & sitc==`i', robust 
predict value2 
gen value3=exp(value2)
quietly su dir if direction=="total"
replace pred_value=value3 if sitc==`i' & pays==`j' ///
	& dir==r(mean) & exportsimports=="Exports"
drop value2 value3
continue
}
}
}

/*------------------------------------------------------------------------------
								Estimate imports
------------------------------------------------------------------------------*/

levelsof pays, local(levels)
di "`: word count `levels''"
foreach i of num 1/6{
foreach j of num 1/`: word count `levels''{
di "`: label (pays) `j'' `: label (sitc) `i''"
su lnvalue if sitc==`i' & pays==`j' & exportsimports=="Imports"
if r(N)>1{
quietly reg lnvalue i.year i.dir [iw=value] if ///
	exportsimports=="Imports" & pays==`j' & ///
	sitc==`i', robust 
predict value2 
gen value3=exp(value2)
quietly su dir if direction=="total"
replace pred_value=value3 if sitc==`i' & pays==`j' ///
	& dir==r(mean) & exportsimports=="Imports" 
drop value2 value3
continue
}
}
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


collapse (sum) pred_value, by(year pays_grouping sitc18_en exportsimports)
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


