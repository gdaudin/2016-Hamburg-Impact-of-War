
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
*************************ESTIMATE SECTORS BEFORE 1750**************************
********************************************************************************
use "$hamburg/database_dta/elisa_bdd_courante", replace

collapse (sum) value, by(sourcetype year direction pays_grouping ///
		sitc18_en exportsimports)

****drop pays if there are too few obs
bys pays_grouping direction: drop if _N<=2
 
*****drop direction that appear only once
bys exportsimports direction: drop if _N==1

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


***gen weight
gen forweight=value if direction=="total"
bysort year exportsimports pays sitc: egen weight_total=max(forweight)
drop forweight
gen share = value/weight_total
bysort exportsimports pays sitc direction: egen weight=mean(share)
replace weight = min(1,weight) /* Pour enlever les valeurs trop élevées */


*tab weight direction
encode direction, gen(dir)
encode pays_grouping, gen(pays)
encode sitc18_en, gen(sitc) label(order)


levelsof exportsimports, local(exportsimports)
*local exportsimports Imports


*For the graphs, compute observed value
bysort year exportsimports pays sitc: gen value_for_obs = value if direction=="total"
		
gen blink = value if direction !="total" 
replace blink=. if sourcetype=="National par direction (-)" &  ///
				(year==1749 | year==1751 | year==1777 )
bysort year exportsimports pays sitc: egen blouf=total(blink), missing
replace value_for_obs=blouf if value_for_obs==.
drop blink blouf
bysort year exportsimports pays sitc direction:replace value_for_obs=. if _n!=1
replace value_for_obs = `min_value'/100 if value_for_obs<`min_value'


*I introduce a max admissible predicted value, which is twice the max observed flow
bys sitc exportsimports pays : egen max_admiss_pred = max(value)
replace max_admiss_pred=max_admiss_pred*2

gen pred_value=.


sort year
foreach ciao in `exportsimports'{


levelsof pays, local(levels) 	/*levelsof is just in case we add more pays 
								to pays_grouping and I do 
								not update this do_file, not important
								`: word count `levels''*/

foreach i of num 1/6{
	foreach j of num 1/`: word count `levels''{
		summarize lnvalue if sitc==`i' & pays==`j' & exportsimports=="`ciao'"
		if r(N)>1{
			qui reg lnvalue i.year i.dir [iw=weight] if ///
				exportsimports=="`ciao'" & pays==`j' & sitc==`i', robust 
				
			
			predict value_pred if ///
				exportsimports=="`ciao'" & pays==`j' & sitc==`i'
			
			*value_test vérifie s'il y a des observations de flux pour cette année 
			*	pour ce produit, ce sens et ce pays.
				
			gen value_test=value if ///
				exportsimports=="`ciao'" & pays==`j' & sitc==`i'
				
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
			replace pred_value=value_pred if sitc==`i' & pays==`j' ///
				& direction=="total" & exportsimports=="`ciao'"
			*drop value2* value_test value3 test*
			drop value_pred*
			/*
			*Graphique pour vérifier
			twoway (scatter pred_value value) 
			
 			
			*have a look at imputed export data
			sort year
			twoway (connected pred_value year, msize(tiny) legend(label(1 "Predicted"))) ///
					(connected value_for_obs year, msize(tiny) legend(label(2 "Observed"))) ///
					if pays==`j' & sitc==`i' & exportsimports=="`ciao'" & direction=="total", title(`ciao') ///
					subtitle("`: label (pays) `j'', `: label (sitc) `i''") ///
					plotregion(fcolor(white)) graphregion(fcolor(white)) ///
					caption("Values in tons of silver") 
			graph export "$hamburg/Graph/Estimation_sector/`ciao'_sitc`i'_pay`j'.png", as(png) replace			
			*/						
			}
		}
	}


}



drop if year==1752 |year==1754
drop if year>1753 & year<1762
drop if year>1767 & year<1783
drop if year>1786

su pred_value
replace pred_value=0 if pred_value==r(min)

collapse (sum) pred_value, by(year exportsimports pays_grouping sitc18_en)

save "$hamburg/database_dta/sector_estimation", replace
