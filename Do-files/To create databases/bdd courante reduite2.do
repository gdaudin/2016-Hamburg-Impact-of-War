
if "`c(username)'"=="guillaumedaudin" ///
		global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
		global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
		global toflit18_data_git "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/toflit18_data_git"

if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global toflit18_data_git "$hamburg/toflit18_data_GIT"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE\Thesis"
	global toflit18_data_git "$hamburg/toflit18_data_GIT"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}
		
import delimited "$toflit18_data_git/base/bdd courante.csv", ///
	   encoding(UTF-8) clear varname(1) stringcols(_all)		

* Keep only necessary variables

keep year exportsimports product_simplification value sourcetype direction ///
	 product_sitc_en product_sitc_simplen country_grouping country_simplification ///
	 national_product_best_guess
	 
destring value, replace
destring year, replace
replace year=1806 if year==1805.75
replace year=1787 if year==1787.2

drop if product_simplification=="" | product_simplification=="???"
drop if value==.
drop if country_grouping=="????" | country_grouping=="Divers" | country_grouping=="France" | ///
		country_grouping=="Inconnu" | country_grouping=="Monde"
		
		
		
		
gen national_product_best_guess = 1 if (sourcetype=="Objet Général" & year<=1786) | ///
		(sourcetype=="Résumé") | sourcetype=="National toutes directions tous partenaires"

egen year_CN = max(national_product_best_guess), by(year)
replace national_product_best_guess=1 if year_CN == 1 & sourcetype=="Compagnie des Indes" & direction=="France par la Compagnie des Indes"
		
	
		
save "$hamburg/database_dta/bdd courante reduite2.dta", replace 

/*
 * Essai : ou qui apparaissent moins de 1000 fois dans la base /
 * ou bien on supprime les marchandises dont la valeur totale échangée sur la période est inférieure à 100 000
 * encode product_simplification, gen(product_simplification_num)
 * bysort product_simplification_num: drop if _N<=1000 
 * sort product_simplification year
	

* Calculer la valeur totale échangée par marchandise sur la période

*by product_simplification direction exportsimports u_conv, sort: egen valeur_totale_par_marchandise=total(value)	
*label var valeur_totale_par_marchandise "Somme variable valeur par march_simpli, dir, expimp, u_conv" 	
*drop if valeur_totale_par_marchandise<=100000
*sort product_simplification year
	

* On convertit les prix dans leur unité conventionnelle
	
*generate prix_unitaire_converti=prix_unitaire/q_conv 
*drop if prix_unitaire_converti==.
*label var prix_unitaire_converti "Prix unitaire par marchandise en unité métrique p_conv" 

* Calcul de la moyenne des prix par année en pondérant en fonction des quantités échangées pour un produit.unitée métrique

*drop if quantities_metric==.
*by year direction exportsimports u_conv product_simplification, sort: egen quantite_echangee=total(quantities_metric)
*label var quantite_echangee "Quantités métric par dir expimp u_conv march_simpli"

*generate prix_unitaire_pondere=(quantities_metric/quantite_echangee)*prix_unitaire_converti
*label var prix_unitaire_pondere "Prix de chaque observation en u métrique en % de la quantit échangée totale" 


*collapse (sum) value quantities_metric,by(year direction exportsimports u_conv product_simplification)

* by year direction exportsimports u_conv product_simplification, sort: egen prix_pondere_annuel=total(prix_unitaire_pondere)


gen prix_pondere_annuel = value/quantities_metric
label var prix_pondere_annuel "Prix moyen d'une mrchd pour une année, march, dir, expimp, u_conv"
sort product_simplification year

*drop prix_unitaire_pondere

* Encode panvar (sinon prend trop de temps) 
gen panvar = product_simplification + exportsimports + direction + u_conv
encode panvar, gen(panvar_num)
drop if year>1787 & year<1788
tsset panvar_num year

* On sauvegarde la base de donnée désormais réduite (A REMPLACER SI ON PREND FINALEMENT LES MARCHANDISES DONT VALEUR > 100 000)
 
if "`c(username)'"=="maellestricot" save   "/Users/maellestricot/Documents/STATA MAC/bdd courante reduite2.dta", replace
if "`c(username)'"=="guillaumedaudin" save "~/Documents/Recherche/TOFLIT18/Indices de prix - travail Maëlle Stricot/bdd courante reduite2.dta", replace
if "`c(username)'" =="Tirindelli" save "/Users/Tirindelli/Google Drive/ETE/Thesis/Données Stata/bdd courante reduite2.dta", replace
if "`c(username)'" =="tirindee" save "C:\Users\TIRINDEE\Google Drive/ETE/Thesis/Données Stata/bdd courante reduite2.dta", replace

*/
