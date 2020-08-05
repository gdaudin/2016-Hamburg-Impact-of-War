

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hamburg/"
	global hamburggit "~/Documents/Recherche/2016 Hamburg/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
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
drop if product_sitc=="9a" /*To remove flows of species*/


drop if country_grouping=="?" | country_grouping=="????" ///
	| country_grouping=="Prises" | country_grouping=="Épaves et échouements" ///
	| country_grouping=="France" | country_grouping=="Indes" ///
	| country_grouping=="Colonies françaises et étrangères" ///
	| country_grouping=="Espagne-Portugal" | country_grouping=="" ///
	| country_grouping=="Divers" ///

****keep only 5 categories of goods
replace hamburg_classification="Not classified" ///
	if hamburg_classification==""
drop if hamburg_classification=="Blanc ; de baleine" | ///
	hamburg_classification=="Huile ; de baleine" | ///
	hamburg_classification=="Minum"
replace hamburg_classification="Sugar" if ///
	hamburg_classification=="Sucre ; cru blanc ; du Brésil"
replace hamburg_classification="Coffee" if ///
	hamburg_classification=="Café"
replace hamburg_classification="Wine" if ///
	hamburg_classification=="Vin ; de France"
replace hamburg_classification="Eau de vie" if ///
	hamburg_classification=="Eau ; de vie"
replace hamburg_classification="Other" if ///
	hamburg_classification!="Sugar" & ///
	hamburg_classification!="Coffee" & ///
	hamburg_classification!="Wine" & ///
	hamburg_classification!="Eau de vie" 


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
	country_grouping exportsimports product_simplification ///
	hamburg_classification sitc18_en)

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
collapse (sum) value, by(year country_grouping hamburg_classification exportsimports product_simplification sitc18_en)
gen direction="total"
save blif.dta, replace

restore
append using blif.dta
erase blif.dta


**Parce que dans l'objet général de 1788, les importations coloniales sont par direction : je le transforme en total d'une part.
**et National par direction(-) d'autre part
preserve
keep if year==1788 & sourcetype=="Objet Général" & country_grouping=="Outre-mers" & exportsimports=="Imports"
collapse (sum) value, by(year country_grouping hamburg_classification exportsimports product_simplification sitc18_en)
gen direction="total"
save blif.dta, replace

restore
replace sourcetype="National par direction (-)" if year==1788 & sourcetype=="Objet Général" & country_grouping=="Outre-mers" ///
		& exportsimports=="Imports" & direction !="total"
append using blif.dta
erase blif.dta


***save temporary database for comparison with hamburg dataset
save "$hamburg/database_dta/elisa_bdd_courante", replace


