
if "`c(username)'"=="guillaumedaudin" ///
		global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
		global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
		global toflit18 "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France"

if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global toflit18_data_git "$hamburg/toflit18_data"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
}

if "`c(username)'" =="rober" {
	global hamburg "D:\Eli_git\Hamburg"
	global toflit18 "D:\Eli_git\Hamburg\toflit18_data"
	global hamburggit "D:\Eli_git\Hamburg\Paper"
}

		
use "$toflit18/Données Stata/bdd courante.dta", clear	
if "`c(username)'" =="rober" {
	use "G:\Il mio Drive\Hamburg\Données Stata\bdd courante.dta", clear
}

* Keep only necessary variables

keep year export_import product_simplification value source_type customs_region ///
	 product_sitc_EN product_sitc_simplEN partner_grouping partner_simplification product_RE_aggregate ///
	 best_guess*
	 
	 
destring value, replace
destring year, replace
replace year=1806 if year==1805.75
replace year=1787 if year==1787.2

*drop if product_simplification=="" | product_simplification=="???"
*drop if value==.
*drop if partner_grouping=="????" | partner_grouping=="Divers" | partner_grouping=="France" | ///
*		partner_grouping=="Inconnu" | partner_grouping=="Monde"

keep if best_guess_national_partner==1 | best_guess_national_product==1
		
/*		
capture drop national_product_best_guess
gen national_product_best_guess = 0		
replace national_product_best_guess = 1 if (source_type=="Objet Général" & year<=1786) | ///
		(source_type=="Résumé") | source_type=="National toutes customs_regions tous partenaires" 

egen year_CN = max(national_product_best_guess), by(year)
replace national_product_best_guess=1 if year_CN == 1 & source_type=="Compagnie des Indes" & customs_region=="France par la Compagnie des Indes"

capture drop national_geography_best_guess
gen national_geography_best_guess = 0
replace national_geography_best_guess = 1 if source_type=="Tableau Général" | source_type=="Résumé"
*/		

if "`c(username)'" =="rober"{
	save "G:\Il mio Drive\Hamburg\database_dta\bdd courante reduite2.dta", replace
}		
save "$hamburg/database_dta/bdd courante reduite2.dta", replace 

/*
 * Essai : ou qui apparaissent moins de 1000 fois dans la base /
 * ou bien on supprime les marchandises dont la valeur totale échangée sur la période est inférieure à 100 000
 * encode product_simplification, gen(product_simplification_num)
 * bysort product_simplification_num: drop if _N<=1000 
 * sort product_simplification year
	

* Calculer la valeur totale échangée par marchandise sur la période

*by product_simplification customs_region export_import u_conv, sort: egen valeur_totale_par_marchandise=total(value)	
*label var valeur_totale_par_marchandise "Somme variable valeur par march_simpli, dir, expimp, u_conv" 	
*drop if valeur_totale_par_marchandise<=100000
*sort product_simplification year
	

* On convertit les prix dans leur unité conventionnelle
	
*generate prix_unitaire_converti=prix_unitaire/q_conv 
*drop if prix_unitaire_converti==.
*label var prix_unitaire_converti "Prix unitaire par marchandise en unité métrique p_conv" 

* Calcul de la moyenne des prix par année en pondérant en fonction des quantités échangées pour un produit.unitée métrique

*drop if quantities_metric==.
*by year customs_region export_import u_conv product_simplification, sort: egen quantite_echangee=total(quantities_metric)
*label var quantite_echangee "Quantités métric par dir expimp u_conv march_simpli"

*generate prix_unitaire_pondere=(quantities_metric/quantite_echangee)*prix_unitaire_converti
*label var prix_unitaire_pondere "Prix de chaque observation en u métrique en % de la quantit échangée totale" 


*collapse (sum) value quantities_metric,by(year customs_region export_import u_conv product_simplification)

* by year customs_region export_import u_conv product_simplification, sort: egen prix_pondere_annuel=total(prix_unitaire_pondere)


gen prix_pondere_annuel = value/quantities_metric
label var prix_pondere_annuel "Prix moyen d'une mrchd pour une année, march, dir, expimp, u_conv"
sort product_simplification year

*drop prix_unitaire_pondere

* Encode panvar (sinon prend trop de temps) 
gen panvar = product_simplification + export_import + customs_region + u_conv
encode panvar, gen(panvar_num)
drop if year>1787 & year<1788
tsset panvar_num year

* On sauvegarde la base de donnée désormais réduite (A REMPLACER SI ON PREND FINALEMENT LES MARCHANDISES DONT VALEUR > 100 000)
 
if "`c(username)'"=="maellestricot" save   "/Users/maellestricot/Documents/STATA MAC/bdd courante reduite2.dta", replace
if "`c(username)'"=="guillaumedaudin" save "~/Documents/Recherche/TOFLIT18/Indices de prix - travail Maëlle Stricot/bdd courante reduite2.dta", replace
if "`c(username)'" =="Tirindelli" save "/Users/Tirindelli/Google Drive/ETE/Thesis/Données Stata/bdd courante reduite2.dta", replace
if "`c(username)'" =="tirindee" save "C:\Users\TIRINDEE\Google Drive/ETE/Thesis/Données Stata/bdd courante reduite2.dta", replace

*/
