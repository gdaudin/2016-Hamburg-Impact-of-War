* CREATION D'UNE BASE REDUITE (NE PAS RELANCER (SAUF EN CAS DE PROBLEME AVEC BDD COURANTE REDUITE))

* Ne pas oublier de mettre la base de données utilisée 
* Dans cette base, on considère que les produits de même dénomination sont les mêmes quelques soient leurs provenance / origine

if "`c(username)'"=="guillaumedaudin" ///
        use "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear

if "`c(username)'" =="Tirindelli" {
use "/Users/Tirindelli/Google Drive/ETE/Thesis/Données Stata/bdd courante.dta", clear
}
		

* Keep only necessary variables

keep year direction exportsimports quantit prix_unitaire marchandises_simplification value quantites_metric quantity_unit_ajustees quantity_unit_ortho u_conv q_conv
sort marchandises_simplification year
order marchandises_simplification year prix_unitaire quantit quantity_unit_ajustees u_conv q_conv value direction exportsimports
label var quantites_metric "Quantities in kg (q_conv)" 

*Drop if missing price

drop if prix_unitaire==.
drop if prix_unitaire==0
drop if marchandises_simplification=="" | marchandises_simplification=="???"
drop if value==.
 
 
 * Essai : ou qui apparaissent moins de 1000 fois dans la base /
 * ou bien on supprime les marchandises dont la valeur totale échangée sur la période est inférieure à 100 000
 * encode marchandises_simplification, gen(marchandises_simplification_num)
 * bysort marchandises_simplification_num: drop if _N<=1000 
 * sort marchandises_simplification year
	

* Calculer la valeur totale échangée par marchandise sur la période

*by marchandises_simplification direction exportsimports u_conv, sort: egen valeur_totale_par_marchandise=total(value)	
*label var valeur_totale_par_marchandise "Somme variable valeur par march_simpli, dir, expimp, u_conv" 	
*drop if valeur_totale_par_marchandise<=100000
*sort marchandises_simplification year
	

* On convertit les prix dans leur unité conventionnelle
	
generate prix_unitaire_converti=prix_unitaire/q_conv 
drop if prix_unitaire_converti==.
label var prix_unitaire_converti "Prix unitaire par marchandise en unité métrique p_conv" 

* Calcul de la moyenne des prix par année en pondérant en fonction des quantités échangées pour un produit.unitée métrique

*drop if quantites_metric==.
*by year direction exportsimports u_conv marchandises_simplification, sort: egen quantite_echangee=total(quantites_metric)
*label var quantite_echangee "Quantités métric par dir expimp u_conv march_simpli"

*generate prix_unitaire_pondere=(quantites_metric/quantite_echangee)*prix_unitaire_converti
*label var prix_unitaire_pondere "Prix de chaque observation en u métrique en % de la quantit échangée totale" 


collapse (sum) value quantites_metric,by(year direction exportsimports u_conv marchandises_simplification)

* by year direction exportsimports u_conv marchandises_simplification, sort: egen prix_pondere_annuel=total(prix_unitaire_pondere)


gen prix_pondere_annuel = value/quantites_metric
label var prix_pondere_annuel "Prix moyen d'une mrchd pour une année, march, dir, expimp, u_conv"
sort marchandises_simplification year

*drop prix_unitaire_pondere

* Encode panvar (sinon prend trop de temps) 
gen panvar = marchandises_simplification + exportsimports + direction + u_conv
encode panvar, gen(panvar_num)
drop if year>1787 & year<1788
tsset panvar_num year

* On sauvegarde la base de donnée désormais réduite (A REMPLACER SI ON PREND FINALEMENT LES MARCHANDISES DONT VALEUR > 100 000)
 
if "`c(username)'"=="maellestricot" save   "/Users/maellestricot/Documents/STATA MAC/bdd courante reduite2.dta", replace
if "`c(username)'"=="guillaumedaudin" save "~/Documents/Recherche/TOFLIT18/Indices de prix - travail Maëlle Stricot/bdd courante reduite2.dta", replace
if "`c(username)'" =="Tirindelli" save "/Users/Tirindelli/Google Drive/ETE/Thesis/Données Stata/bdd courante reduite2.dta", replace


