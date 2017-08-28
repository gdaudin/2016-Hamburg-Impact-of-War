

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hamburg/"
	global hamburggit "~/Documents/Recherche/2016 Hamburg/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="TIRINDEE" {
	global hamburg "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}






set more off

capture use "/Users/Tirindelli/Desktop/hambourg/bdd courante.dta", clear

if "`c(username)'" =="guillaumedaudin" {
	use "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
}


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
*drop if year<1718
drop if sourcepath=="Divers/AD 44/Nantes - Exports - 1734 - bis.csv"


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

merge m:1 year using "$hamburg/database_dta/FR_silver.dta"
drop if _merge==2
drop _merge

replace value=value*FR_silver
replace value=value/1000000


drop if sourcetype!="Local" & sourcetype!="National par direction" ///
	& sourcetype!="National par direction (-)" ///
	& sourcetype!="Objet Général" & sourcetype!="Résumé" 
drop if year==1750 & sourcetype=="Local"
drop if sourcetype=="Résumé" & (year==1788)
drop if sourcetype=="Objet Général" & year==1787
*drop if sourcetype=="Résumé" & (year==1789)


replace direction="total" if direction=="" & (sourcetype =="Objet Général" | sourcetype =="Résumé")
*list if direction==""


preserve
keep if year==1750
assert sourcetype=="National par direction"
collapse (sum) value, by(year pays_grouping classification_hamburg_large exportsimports marchandises_simplification sitc18_en)
gen direction="total"
save blif.dta, replace

restore
append using blif.dta
erase blif.dta


**Parce que dans l'objet général de 1788, les importations coloniales sont par direction : je le transforme en total d'une part.
**et National par direction(-) d'autre part
preserve
keep if year==1788 & sourcetype=="Objet Général" & pays_grouping=="Outre-mers" & exportsimports=="Imports"
collapse (sum) value, by(year pays_grouping classification_hamburg_large exportsimports marchandises_simplification sitc18_en)
gen direction="total"
save blif.dta, replace

restore
replace sourcetype="National par direction (-)" if year==1788 & sourcetype=="Objet Général" & pays_grouping=="Outre-mers" ///
		& exportsimports=="Imports" & direction !="total"
append using blif.dta
erase blif.dta




***save temporary database for comparison with hamburg dataset
save "$hamburg/database_dta/elisa_bdd_courante", replace




********************************************************************************
*************************ESTIMATE PRODUCTS BEFORE 1750**************************
********************************************************************************
use "$hamburg/database_dta/elisa_bdd_courante", replace

*codebook value if pays_grouping=="Afrique" & exportsimports=="Imports" & classification_hamburg_large=="Coffee"


*****keep only sources where I have both national and direction data

*codebook value if pays_grouping=="Afrique" & exportsimports=="Imports" & classification_hamburg_large=="Coffee"




collapse (sum) value, by(sourcetype year direction pays_grouping ///
		classification_hamburg_large exportsimports)

****drop pays if there are too few obs
bys pays_grouping direction: drop if _N<=2
*codebook value if pays_grouping=="Afrique" & exportsimports=="Imports" & classification_hamburg_large=="Coffee"
 
*****drop direction that appear only once
bys exportsimports direction: drop if _N==1
*codebook value if pays_grouping=="Afrique" & exportsimports=="Imports" & classification_hamburg_large=="Coffee"




/*------------------------------------------------------------------------------
						Estimate exports and imports
------------------------------------------------------------------------------*/

su value if value!=0
local min_value=r(min)

*codebook value if pays_grouping=="Afrique" & exportsimports=="Imports" & classification_hamburg_large=="Coffee"

preserve
keep if sourcetype!="National par direction (-)"
fillin exportsimport year pays_grouping direction classification_hamburg_large
bysort year direction exportsimports: egen test_year=total(value), missing
replace value=`min_value'/100 if test_year!=. & value==. 
drop test_year
save blif.dta, replace
restore


keep if sourcetype=="National par direction (-)"
fillin exportsimport year pays_grouping direction classification_hamburg_large
bysort year pays exportsimports: egen test_year=total(value), missing
replace value=`min_value'/100 if test_year!=. & value==. 
drop test_year

append using blif.dta

erase blif.dta

duplicates drop year direction exportsimports pays_grouping classification_hamburg_large, force
*keep year direction exportsimports pays_grouping classification_hamburg_large value

replace sourcetype = "imputed" if _fillin==1 & value !=.

save fortest.dta, replace


gen lnvalue=ln(value)
*codebook lnvalue


***gen weight

**value_test sert à décider qui va dans le calcul du commerce total
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
*br if share >1 & share!=.
bysort exportsimports pays class direction: egen weight=mean(share)
replace weight = min(1,weight) /* Pour enlever les valeurs trop élevées */


*tab weight direction


encode direction, gen(dir)
encode pays_grouping, gen(pays)
label define order 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode classification_hamburg_large, gen(class) label(order)



levelsof exportsimports, local(exportsimports)
*local exportsimports Imports



*For the graphs, compute observed value
bysort year exportsimports pays class: gen value_for_obs = value if direction=="total"
replace value_for_obs=value_for_obs*value_test 		/*avoid double counting Resume and 
													Objet for 1788 and 1789*/
		
gen blink = value if direction !="total" 
replace blink=. if sourcetype=="National par direction (-)" &  ///
				(year==1749 | year==1751 | year==1777 )

bysort year exportsimports pays class: egen blouf=total(blink), missing
replace value_for_obs=blouf if value_for_obs==.
drop blink blouf
			
by year exportsimports pays class:replace value_for_obs=. if _n!=1
replace value_for_obs = `min_value'/100 if value_for_obs<`min_value'
sort year

drop value_test*


foreach ciao in `exportsimports'{
gen pred_value_`ciao'=.


levelsof pays, local(levels) 	/*levelsof is just in case we add more pays 
								to pays_grouping and I do 
								not update this do_file, not important
								`: word count `levels''*/

foreach i of num 5/5{
	foreach j of num 12/12 /*`: word count `levels''*/{
		summarize lnvalue if class==`i' & pays==`j' & exportsimports=="`ciao'"
		if r(N)>1{
			reg lnvalue i.year i.dir [iw=weight] if ///
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
			/*
			twoway (scatter pred_value_`ciao' value) 

 			sort year
			*have a look at imputed export data			
			twoway (connected pred_value_`ciao' year, msize(tiny) legend(label(1 "Predicted"))) ///
					(connected value_for_obs year, msize(tiny) legend(label(2 "Observed"))) ///
					if pays==`j' & class==`i' & exportsimports=="`ciao'", title(`ciao') ///
					subtitle("`: label (pays) `j'', `: label (class) `i''") ///
					plotregion(fcolor(white)) graphregion(fcolor(white)) ///
					caption("Values in tons of silver") 
			graph export "$hamburg/Graph/Estimation_product/`ciao'_class`i'_pay`j'.png", as(png) replace
			*/
									
			}
		}
	}


}


quietly su dir if direction=="total"
*keep if dir==r(mean)

drop if year==1752 |year==1754
drop if year>1753 & year<1762
drop if year>1767 & year<1783
drop if year>1786


collapse (sum) pred_value_Exports pred_value_Imports, by(year pays_grouping classification_hamburg_large exportsimports)
save "$hamburg/database_dta/product_estimation", replace


********************************************************************************
*************************ESTIMATE SECTORS BEFORE 1750**************************
********************************************************************************
use "$hamburg/database_dta/elisa_bdd_courante", replace

collapse (sum) value, by(sourcetype year direction pays_grouping ///
		sitc18_en exportsimports)

****drop pays if there are too few obs
bys pays_grouping direction: drop if _N<=2
 
*****drop direction that appear only once
bys exportsimports direction: drop if _N==1




/*------------------------------------------------------------------------------
						Estimate exports and imports
------------------------------------------------------------------------------*/

su value if value!=0
local min_value=r(min)

*codebook value if pays_grouping=="Afrique" & exportsimports=="Imports" & classification_hamburg_large=="Coffee"

preserve
keep if sourcetype!="National par direction (-)"
fillin exportsimport year pays_grouping direction sitc18_en
bysort year direction exportsimports: egen test_year=total(value), missing
replace value=`min_value'/100 if test_year!=. & value==. 
drop test_year
save blif.dta, replace
restore


keep if sourcetype=="National par direction (-)"
fillin exportsimport year pays_grouping direction sitc18_en
bysort year pays exportsimports: egen test_year=total(value), missing
replace value=`min_value'/100 if test_year!=. & value==. 
drop test_year

append using blif.dta

erase blif.dta

duplicates drop year direction exportsimports pays_grouping sitc18_en, force

replace sourcetype = "imputed" if _fillin==1 & value !=.

save fortest.dta, replace


gen lnvalue=ln(value)
*codebook lnvalue


***gen weight
gen value_test=1
replace value_test=. if year==1787 & sourcetype=="Résumé"
replace value_test=. if year==1788 & sourcetype=="Résumé"
replace value_test=. if year==1777 & sourcetype=="National par direction (-)"
*replace value_test=. if year>1751 & sourcetype=="Local"


gen value_test2=value*value_test
gen forweight=value_test2 if direction=="total"
tab forweight if year==1721
bysort year exportsimports pays sitc: egen weight_total=max(forweight)
drop forweight
gen share = value/weight_total
*br if share >1 & share!=.
bysort exportsimports pays sitc direction: egen weight=mean(share)
replace weight = min(1,weight) /* Pour enlever les valeurs trop élevées */


*tab weight direction


encode direction, gen(dir)
encode pays_grouping, gen(pays)
encode sitc18_en, gen(sitc) 

levelsof exportsimports, local(exportsimports)
*local exportsimports Imports

*For the graphs, compute observed value
bysort year exportsimports pays sitc: gen value_for_obs = value if direction=="total"
replace value_for_obs=value_for_obs*value_test 		/*avoid double counting Resume and 
													Objet for 1788 and 1789*/
		
gen blink = value if direction !="total" 
replace blink=. if sourcetype=="National par direction (-)" &  ///
				(year==1749 | year==1751 | year==1777 )

bysort year exportsimports pays sitc: egen blouf=total(blink), missing
replace value_for_obs=blouf if value_for_obs==.
drop blink blouf
			
by year exportsimports pays sitc:replace value_for_obs=. if _n!=1
replace value_for_obs = `min_value'/100 if value_for_obs<`min_value'
sort year

drop value_test*


foreach ciao in `exportsimports'{
gen pred_value_`ciao'=.


levelsof pays, local(levels) 	/*levelsof is just in case we add more pays 
								to pays_grouping and I do 
								not update this do_file, not important
								`: word count `levels''*/

foreach i of num 1/5{
	foreach j of num 1/`: word count `levels''{
		summarize lnvalue if sitc==`i' & pays==`j' & exportsimports=="`ciao'"
		if r(N)>1{
			qui reg lnvalue i.year i.dir [iw=weight] if ///
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
			
			twoway (scatter pred_value_`ciao' value) 
			/*
 			sort year
			*have a look at imputed export data			
			twoway (connected pred_value_`ciao' year, msize(tiny) legend(label(1 "Predicted"))) ///
					(connected value_for_obs year, msize(tiny) legend(label(2 "Observed"))) ///
					if pays==`j' & class==`i' & exportsimports=="`ciao'", title(`ciao') ///
					subtitle("`: label (pays) `j'', `: label (class) `i''") ///
					plotregion(fcolor(white)) graphregion(fcolor(white)) ///
					caption("Values in tons of silver") 
			graph export "$hamburg/Graph/Estimation_product/`ciao'_class`i'_pay`j'.png", as(png) replace
			*/
									
			}
		}
	}


}


quietly su dir if direction=="total"
keep if dir==r(mean)

drop if year==1752 |year==1754
drop if year>1753 & year<1762
drop if year>1767 & year<1783
drop if year>1786


collapse (sum) pred_value_Exports pred_value_Imports, by(year pays_grouping sitc18_en exportsimports)
save "$hamburg/database_dta/sector_estimation", replace


********************************************************************************
***************************CREATE 4 DATABASES***********************************
********************************************************************************
use "$hamburg/database_dta/elisa_bdd_courante", replace
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

save "$hamburg/database_dta/allcountry1", replace

keep if pays_grouping=="Nord"
drop pays_grouping
save "$hamburg/database_dta/hamburg1", replace
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
using "$hamburg/database_dta/product_estimation"
drop _merge

replace value = pred_value_Exports if exportsimports=="Exports"
replace value=pred_value_Imports if exportsimports=="Imports"
drop pred_value*

save "$hamburg/database_dta/allcountry2", replace

keep if pays_grouping=="Nord" 
drop pays_grouping 
save "$hamburg/database_dta/hamburg2", replace
restore
/*------------------------------------------------------------------------------
				save db with sict classification
------------------------------------------------------------------------------*/

preserve
collapse (sum) value, by(year pays_grouping ///
sitc18_en exportsimports)

*****merge with imputed data 
merge m:1 exportsimports year pays_grouping sitc18_en ///
using "$hamburg/database_dta/sector_estimation"
drop _merge

replace value = pred_value_Exports if exportsimports=="Exports"
replace value=pred_value_Imports if exportsimports=="Imports"
drop pred_value*

save "$hamburg/database_dta/allcountry2_new", replace
restore


