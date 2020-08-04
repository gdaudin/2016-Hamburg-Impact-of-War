capture program drop composition_trade_test
program composition_trade_test
args period1 period2 plantation_yesno direction X_I classification

	preserve
	
	if "`direction'"=="national"{
		keep if national_product_best_guess==1 
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
		collapse (sum) value, by(year war product_sitc_simplen exportsimports period_str)
	}
	
	if `plantation_yesno'==0 drop if product_sitc_simplen=="Plantation foodstuff"

	if "`X_I'"=="Exports" | "`X_I'"=="Imports" keep if exportsimports=="`X_I'"
	else collapse (sum) value, by(`classification' year period_str war)					
	
	//the negative values for war is for creating labels in the graph do file

	if "`period1'"=="peace" | "`period2'"=="peace" {
		replace war=0 if period_str!="War 1756-1763" | period_str !="War 1778-1783" | ///
						 period_str!="War 1793-1807" | period_str !="Blockade 1808-1815"
		}
		
	if "`period1'"=="war" | "`period2'"=="war" {
		replace war=1 if period_str=="War 1756-1763" | period_str =="War 1778-1783" | ///
						 period_str=="War 1793-1807" | period_str =="Blockade 1808-1815"
		}	
	
	if "`period1'"=="peace1749_1755" | "`period2'"=="peace1749_1755"{
		replace war=2 if period_str=="Peace 1749-1755"
		}
		
	if "`period1'"=="seven" | "`period2'"=="seven"{
		replace war=3 if period_str=="War 1756-1763" 
		}
		
	if "`period1'"=="peace1764_1777" | "`period2'"=="peace1764_1777"{
		replace war=4 if period_str=="Peace 1764-1777"
		}
		
	if "`period1'"=="indep" | "`period2'"=="indep"{
		replace war=5 if period_str=="War 1778-1783"
		}		
	
	if "`period1'"=="peace1784_1792" | "`period2'"=="peace1784_1792"{
		replace war=6 if period_str=="Peace 1784-1792" 
		}
	
	if "`period1'"=="rev" | "`period2'"=="rev"{
		replace war=7 if period_str=="War 1793-1807" 
		}
	
	if "`period1'"=="block" | "`period2'"=="block"{
		replace war=8 if period_str=="Blockade 1808-1815" 
		}
	
	if "`period1'"=="peace1816_1840" | "`period2'"=="peace1816_1840"{
		replace war=9 if period_str=="Peace 1816-1840" 
		}


	if "`X_I'"=="Exports" local name X
	else if "`X_I'"=="Imports" local name I
	else local name I_X
	
	keep if war!=.
	collapse (sum) value, by(year `classification' war)
		
	bysort year: egen total=sum(value)
	gen percent= value/total
	
	fillin year `classification'
	levelsof year, local(year)
	foreach j of local year{
			qui su percent if year==`j' 
			replace percent=r(min)/2 if percent==. & year==`j' 
	}
	replace war =war[_n-1] if war[_n]==. & year[_n]==year[_n-1]
	replace war =war[_n+1] if war[_n]==. & year[_n]==year[_n+1]	
	drop _fillin
		
	gen ln_percent=ln(percent)
	encode `classification', gen(class_num)
	
	*save "$hamburg/database_dta/`period1'_`period2'_`direction'_temp.dta", replace
	
	egen year_war = group(year war), label
	
	drop if `classification'==""
	
	drop value percent `classification' year total

	reshape wide ln_percent, i(year_war) j(class_num)
	
	di "************************`X_I' `period1' `period2' `plantation_yesno' `direction'*************************************"
		
	if "`X_I'"=="Exports" local name X
	if "`X_I'"=="Imports" local name I
	if "`X_I'"=="I_X" local name XI
	if "`direction'"== "national" local dir nat
	else local dir loc
	
	if "`classification'"=="product_sitc_simplen"{
		if "`period1'"=="peace1784_1792" & "`period2'"=="peace1816_1840" | "`period2'"=="peace1784_1792" & "`period1'"=="peace1816_1840"{
			if `plantation_yesno'==1 mvtest means ln_percent1-ln_percent7, by(war) het
			else mvtest means ln_percent1-ln_percent6, by(war) het
		}
		else{
			if `plantation_yesno'==1 mvtest means ln_percent1-ln_percent12, by(war) het
			else mvtest means ln_percent1-ln_percent11, by(war) het
		}
	}
	
	if "`classification'"=="country_grouping" mvtest means ln_percent1-ln_percent12, by(war) het
	
	if "`classification'"=="country_grouping_7"{
	
		if "`period1'"=="seven" & "`period2'"=="peace1764_1777" | "`period1'"=="peace1764_1777" & "`period2'"=="seven"{
			mvtest means ln_percent1-ln_percent6, by(war) het
		}
		
		else if "`period1'"=="peace1749_1755" & "`period2'"=="peace1764_1777" | "`period1'"=="peace1764_1777" & "`period2'"=="peace1749_1755"{
			mvtest means ln_percent1-ln_percent6, by(war) het
		}
		
		else mvtest means ln_percent1-ln_percent7, by(war) het

	}
		
	if "`classification'"=="product_re_aggregate" mvtest means ln_percent1-ln_percent7, by(war) het

	
	// I am excluding one category from the test cause they sum uo to a 100 
		
	global `name'`plantation_yesno'`dir'=round(r(p_F),0.01)
	global temp= ${`name'`plantation_yesno'`dir'}
	di ${`period1'`period2'`plantationyesno'`dir'`name'}
	// I am storing it as a global macro because I am reporting it in the graphs, so the graph.do can use them
	// I copy the macro in temp for simplicity of use in this do file
	
	if "`X_I'"=="Exports" & `plantation_yesno'==1{
		matrix A= ($temp, 0,0,0,0,0)
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}
	if "`X_I'"=="Exports" & `plantation_yesno'==0{
		matrix A= (0, $temp ,0,0,0,0)
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}
		
	if "`X_I'"=="Imports" & `plantation_yesno'==1{
		matrix A= (0, 0, $temp, 0,0,0)
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}
	if "`X_I'"=="Imports" & `plantation_yesno'==0{
		matrix A= (0, 0,0,$temp, 0,0)
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}
		
	if "`X_I'"=="I_X" & `plantation_yesno'==1{
		matrix A= (0, 0,0,0,$temp, 0)
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}
	if "`X_I'"=="I_X" & `plantation_yesno'==0{
		matrix A= (0, 0,0,0,0,$temp )
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}	

	restore

end



 
