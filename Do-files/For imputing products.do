
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


********************************************************************************
*************************ESTIMATE PRODUCTS BEFORE 1750**************************
********************************************************************************
use "$hamburg/database_dta/elisa_bdd_courante", replace

*codebook value if country_grouping=="Afrique" & exportsimports=="Imports" & hamburg_classification=="Coffee"


*****keep only sources where I have both national and direction data

*codebook value if country_grouping=="Afrique" & exportsimports=="Imports" & hamburg_classification=="Coffee"




collapse (sum) value, by(sourcetype year direction country_grouping ///
		hamburg_classification exportsimports)

****drop pays if there are too few obs
bys country_grouping direction: drop if _N<=2
*codebook value if country_grouping=="Afrique" & exportsimports=="Imports" & hamburg_classification=="Coffee"
 
*****drop direction that appear only once
bys exportsimports direction: drop if _N==1
*codebook value if country_grouping=="Afrique" & exportsimports=="Imports" & hamburg_classification=="Coffee"

*Drop direction if 6 years or less

levelsof direction, local(liste_de_direction)
foreach dir of local liste_de_direction {
	tab year if direction=="`dir'"
	if r(r)<=7 drop if direction=="`dir'"
}

*Drop year if only one direction
levelsof year, local(liste_of_year)
foreach yr of local liste_of_year {
	quietly tab direction if year==`yr' & direction !="total"
	if r(r)<=1 & r(r)!=. drop if year==`yr' & direction !="total"
}


/*------------------------------------------------------------------------------
						Estimate exports and imports
------------------------------------------------------------------------------*/

su value if value!=0
local min_value=r(min)
gen value_for_log=value

*codebook value if country_grouping=="Afrique" & exportsimports=="Imports" & hamburg_classification=="Coffee"

preserve
keep if sourcetype!="National par direction (-)"
fillin exportsimport year country_grouping direction hamburg_classification
bysort year direction exportsimports: egen test_year=total(value), missing
replace value_for_log=`min_value'/100 if test_year!=. & value==. 
replace value=. if value==0 & test_year==.
drop test_year
save blif.dta, replace
restore


keep if sourcetype=="National par direction (-)"
fillin exportsimport year country_grouping direction hamburg_classification
bysort year pays exportsimports: egen test_year=total(value), missing
replace value_for_log=`min_value'/100 if test_year!=. & value==. 
replace value=. if value==0 & test_year==.
drop test_year

append using blif.dta
erase blif.dta


duplicates drop year direction exportsimports country_grouping hamburg_classification, force
*keep year direction exportsimports country_grouping hamburg_classification value

replace sourcetype = "imputed" if _fillin==1 & value !=.

replace value =. if country_grouping=="États-Unis d'Amérique" & year <=1778

save fortest.dta, replace


gen lnvalue=ln(value_for_log)
*codebook lnvalue


***gen weight

gen forweight=value if direction=="total"
tab forweight if year==1721
bysort year exportsimports pays class: egen weight_total=max(forweight)
drop forweight
gen share = value/weight_total
*br if share >1 & share!=.
bysort exportsimports pays class direction: egen weight=mean(share)
replace weight = min(1,weight) /* Pour enlever les valeurs trop élevées */


*tab weight direction


encode direction, gen(dir)
encode country_grouping, gen(pays)
label define order 1 Coffee 2 "Eau de vie" 3 Sugar 4 Wine 5 Other
encode hamburg_classification, gen(class) label(order)



levelsof exportsimports, local(exportsimports)
*local exportsimports Imports



*For the graphs, compute observed value

bysort year exportsimports pays class: gen value_for_obs = value if direction=="total"
		
gen blink = value if direction !="total" 
replace blink=. if sourcetype=="National par direction (-)" &  ///
				(year==1749 | year==1751 | year==1777 )
bysort year exportsimports pays class: egen blouf=total(blink), missing
replace value_for_obs=blouf if value_for_obs==.
drop blink blouf
bysort year exportsimports pays class direction:replace value_for_obs=. if _n!=1
replace value_for_obs = `min_value'/100 if value_for_obs<`min_value'


*I introduce a max admissible predicted value, which is twice the max observed flow
bys class exportsimports pays : egen max_admiss_pred = max(value)
replace max_admiss_pred=max_admiss_pred*2

gen pred_value=.


sort year
foreach ciao in `exportsimports'{


levelsof pays, local(levels) 	/*levelsof is just in case we add more pays 
								to country_grouping and I do 
								not update this do_file, not important
								`: word count `levels''*/

foreach i of num 1/5{
	foreach j of num 1/`: word count `levels''{
		summarize lnvalue if class==`i' & pays==`j' & exportsimports=="`ciao'"
		if r(N)>1{
			qui reg lnvalue i.year i.dir [iw=weight] if ///
				exportsimports=="`ciao'" & pays==`j' & class==`i', robust 
				
			
			predict value_pred if ///
				exportsimports=="`ciao'" & pays==`j' & class==`i'
			
			*value_test vérifie s'il y a des observations de flux pour cette année 
			*	pour ce produit, ce sens et ce pays.
				
			gen value_test=value if ///
				exportsimports=="`ciao'" & pays==`j' & class==`i'
				
			bysort year: egen test_year=total(value_test), missing
			replace value_test = 0 if value_test==.
			replace value_test = 1 if value_test !=0
			
			
			*Cela annule la prédiction s'il n'y a pas d'observation pour cette année ///
				/// pour ce produit, ce sens et ce pays
			
			replace value_pred=. if test_year==0
			drop test_year
			
			
			*Idem, mais mais par direction
			bysort dir: egen test_dir=total(value_test), missing
			drop value_test
			replace value_pred=. if test_dir==.
			drop test_dir
			
			*Passage de log en normal
			replace value_pred = exp(value_pred)
			
			*J'introduit le max admissible value
			replace value_pred = max_admiss_pred if value_pred >= max_admiss_pred
			
			
			*Restreint aux observations d'intérêt
			replace pred_value=value_pred if class==`i' & pays==`j' ///
				& direction=="total" & exportsimports=="`ciao'"
			*drop value2* value_test value3 test*
			drop value_pred*
			
			*Graphique pour vérifier
			/*twoway (scatter pred_value value) 
			
			*have a look at imputed export data
			sort year
			twoway (connected pred_value year, msize(tiny) legend(label(1 "Predicted"))) ///
					(connected value_for_obs year, msize(tiny) legend(label(2 "Observed"))) ///
					if pays==`j' & class==`i' & exportsimports=="`ciao'" & direction=="total", title(`ciao') ///
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

drop if year==1752 |year==1754
drop if year>1753 & year<1762
drop if year>1767 & year<1783
drop if year>1786

su pred_value
replace pred_value=0 if pred_value==r(min)

collapse (sum) pred_value, by(year exportsimports country_grouping hamburg_classification)

save "$hamburg/database_dta/product_estimation", replace

