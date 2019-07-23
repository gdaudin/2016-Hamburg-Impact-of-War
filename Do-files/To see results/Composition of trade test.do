macro drop _all 

capture program drop composition_trade_test
program composition_trade_test
args period plantation_yesno direction

		if "`period'"=="peace_war"{
		replace war=1 if period_str=="War 1756-1763" | period_str =="War 1778-1783" | ///
						 period_str=="War 1793-1807" | period_str =="Blockade 1808-1815"
		replace war=0 if war!=1
		}
	
	if "`period'"=="pre_seven"{
		replace war=0 if period_str=="Peace 1749-1755"
		replace war=1 if period_str=="War 1756-1763" 
		}
	
	if "`period'"=="post_seven"{
		replace war=1 if period_str=="War 1756-1763" 
		replace war=0 if period_str=="Peace 1763-1777"
		}
	
	if "`period'"=="pre_independence"{
		replace war=0 if period_str=="Peace 1763-1777" 
		replace war=1 if period_str=="War 1778-1783" 
		}
	
	if "`period'"=="post_independence"{
		replace war=1 if period_str=="War 1778-1783" 
		replace war=0 if period_str=="Peace 1784-1792" 
		}
	
	if "`period'"=="pre_revolutionary"{
		replace war=0 if period_str=="Peace 1784-1792" 
		replace war=1 if period_str=="War 1793-1807" 
		}
	
	if "`period'"=="revolutionary_block"{
		replace war=1 if period_str=="War 1793-1807" 
		replace war=0 if period_str=="Blockade 1808-1815" 
		}
	
	if "`period'"=="post_blockade"{
		replace war=1 if period_str=="Blockade 1808-1815" 
		replace war=0 if period_str=="Peace 1816-1840" 
		}

	if "`period'"!="revolutionary_block"{ 
		label value war peacewar
		}
	else label value war blockwar
	
	
	preserve
	
	if "`direction'"=="national"{
		gen commerce_national = 1 if (sourcetype=="Objet Général" & year<=1786) | ///
			(sourcetype=="Résumé") | sourcetype=="National toutes directions tous partenaires"
	
		keep if commerce_national==1
		collapse (sum) value, by(year product_sitc_simplen exportsimports period_str)
	}
	
	else{
		gen commerce_local = 1 if sourcetype=="Local" & year!=1750 | ///
			sourcetype=="National toutes directions tous partenaires" | ////
			(sourcetype=="National toutes directions partenaires manquants" & year==1788 & country_grouping=="Outre-mers") | ////
			(sourcetype=="National toutes directions partenaires manquants" & year==1789 & country_grouping=="Pas Outre-mers")
	
		keep if commerce_local==1
		drop commerce_local
		if "`direction'"=="mars" keep if direction=="Marseille"
		if "`direction'"=="nant" keep if direction=="Nantes"
		if "`direction'"=="renn" keep if direction=="Rennes"
		if "`direction'"=="bord" keep if direction=="Bordeaux"
		if "`direction'"=="LR" keep if direction=="La Rochelle"	
		if "`direction'"=="bayo" keep if direction=="Bayonne"
		collapse (sum) value, by(year product_sitc_simplen exportsimports period_str)
	}
		
	if exportsimports=="Exports" local name X
	if exportsimports=="Imports" local name I
	keep if war!=.
	collapse (sum) value, by(year product_sitc_simplen war exportsimports)
		
	bysort year exportsimports: egen total=sum(value)
	gen percent= value/total
		
	fillin year exportsimports product_sitc_simplen
	levelsof year, local(year)
	levelsof exportsimports, local(X_I)
	foreach j of local year{
		foreach k of local X_I{
			qui su percent if year==`j' & exportsimports=="`k'"
			replace percent=r(min)/2 if percent==. & year==`j' & exportsimports=="`k'"
			qui su war if year==`j'
			replace war=r(max) if war==. & year==`j'
		}	
	}

	gen ln_percent=ln(percent)
	encode product_sitc_simplen, gen(product_sitc_num)
	
	save "$hamburg/database_dta/`period'_`direction'_temp.dta", replace
	
	if `plantation_yesno'==0 drop if product_sitc_simplen=="Plantation foodstuff"

	egen year_war = group(year war), label
	egen year_war_exportsimports = group(year_war exportsimports), label
	
	drop value percent product_sitc_simplen year _fillin total
	
	reshape wide ln_percent, i(year_war_exportsimports) j(product_sitc_num)
		
	di "************************`i' `period' `plantation_yesno' `direction'*************************************"
		
	levelsof exportsimports, local(X_I)
	foreach i of local X_I{
		if `plantation_yesno'==1 mvtest means ln_percent1-ln_percent12 if exportsimports==`i', by(war)	
		else mvtest means ln_percent1-ln_percent11if if exportsimports==`i', by(war)
		
		global `period'_`plantation_yesno'_`direction'_pval_`name'=round(r(p_F),0.001)
		di ${`period'_`plantation_yesno'_`direction'_pval_`name'}
	}
		
		
	restore

end



 
