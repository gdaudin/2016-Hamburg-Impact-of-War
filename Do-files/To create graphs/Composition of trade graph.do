
capture program drop composition_trade_graph
program composition_trade_graph 
args period1 period2 direction 

	save temp.dta, replace 				

	if "`period1'"=="peace" | "`period2'"=="peace" {
		replace war=-1 if period_str!="War 1756-1763" | period_str !="War 1778-1783" | ///
						 period_str!="War 1793-1807" | period_str !="Blockade 1808-1815"
		}
		
	if "`period1'"=="war" | "`period2'"=="war" {
		replace war=1 if period_str=="War 1756-1763" | period_str =="War 1778-1783" | ///
						 period_str=="War 1793-1807" | period_str =="Blockade 1808-1815"
		}	
	
	if "`period1'"=="peace1749_1755" | "`period2'"=="peace1749_1755"{
		replace war=-2 if period_str=="Peace 1749-1755"
		}
		
	if "`period1'"=="seven" | "`period2'"=="seven"{
		replace war=2 if period_str=="War 1756-1763" 
		}
		
	if "`period1'"=="peace1764_1777" | "`period2'"=="peace1764_1777"{
		replace war=-3 if period_str=="Peace 1764-1777"
		}
		
	if "`period1'"=="indep" | "`period2'"=="indep"{
		replace war=3 if period_str=="War 1778-1783"
		}		
	
	if "`period1'"=="peace1784_1792" | "`period2'"=="peace1784_1792"{
		replace war=-4 if period_str=="Peace 1784-1792" 
		}
	
	if "`period1'"=="rev" | "`period2'"=="rev"{
		replace war=4 if period_str=="War 1793-1807" 
		}
	
	if "`period1'"=="block" | "`period2'"=="block"{
		replace war=5 if period_str=="Blockade 1808-1815" 
		}
	
	if "`period1'"=="peace1816_1840" | "`period2'"=="peace1816_1840"{
		replace war=-6 if period_str=="Peace 1816-1840" 
		}


		
	
	if "`direction'"=="national"{
		gen commerce_national = 1 if (sourcetype=="Objet Général" & year<=1786) | ///
			(sourcetype=="Résumé") | sourcetype=="National toutes directions tous partenaires"
	
		keep if commerce_national==1 
		collapse (sum) value, by(year war product_sitc_simplen period_str exportsimports)
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
	
	
	
	keep if war!=.
	
	capture label drop peacewar
	
	///loop to assign label to graphs 
	
	su war 	
	if `r(min)' != 5 & `r(max)'!= 5{
					
		if `r(min)'<0 & `r(max)'>0 {
			qui su war
			label define peacewar `r(min)' "Peace" `r(max)' "War"
		}
			
		if `r(min)'>0 & `r(max)'>0 {
			qui su war
			label define peacewar `r(max)' "War1" `r(min)' "War2"
		}
			
		if `r(min)'<0 & `r(max)'<0 {
			qui su war
			label define peacewar `r(max)' "Peace1" `r(min)' "Peace2"
		}
	}
		
		
		else if `r(max)'==5 & `r(min)'<0{
			qui su war
			label define peacewar 5 "Blockade" `r(min)' "Peace"
		}
		
		else if `r(max)'==5 & `r(min)' >0{
			qui su war
			label define peacewar 5 "Blockade" `r(min)' "War"
		}		
		
		else if `r(min)'==5 & `r(max)' >0{
			qui su war
			label define peacewar 5 "Blockade" `r(max)' "War"
			
		}

	
	label values war peacewar
	
	collapse (sum) value, by(year product_sitc_simplen war exportsimports)
		
	bysort year exportsimports: egen total=sum(value)
	gen percent= value/total
	
	bysort year product_sitc_simplen: egen value_XI=sum(value)
	replace value_XI=. if exportsimports=="Exports"
	bysort year: egen total_XI=sum(value)
	gen percent_XI=value_XI/total_XI
		
	
	fillin year exportsimports product_sitc_simplen 
	levelsof year, local(year)
	foreach j of local year{
			qui su percent if year==`j'
			replace percent=r(min)/2 if percent==. & year==`j' 
			qui su percent_XI if year==`j'
			replace percent_XI=r(min)/2 if percent_XI==. & year==`j' & exportsimports=="Imports"
	}
	replace war =war[_n-1] if war[_n]==. & year[_n]==year[_n-1]
	replace war =war[_n+1] if war[_n]==. & year[_n]==year[_n+1]	
	gen ln_percent=log(percent)
	gen ln_percent_XI=log(percent_XI)
	drop _fillin
	
	qui graph 	pie value if exportsimports=="Exports", over(product_sitc_simplen) ///
			plabel(_all name, size(*0.7) color(white)) legend(off) ///
			by(war, legend(off) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			note("Exports")) 
		
	graph export "$hamburggit/Paper - Impact of War/Paper/`period1'_`period2'_composition_X.pdf", replace

	qui graph 	pie value if exportsimports=="Imports", over(product_sitc_simplen) ///
			plabel(_all name, size(*0.7) color(white)) ///
			by(war, legend(off) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			note("Imports")) 
		
	graph export "$hamburggit/Paper - Impact of War/Paper/`period1'_`period2'_composition_I.pdf", replace
	
	encode product_sitc_simplen, gen(product_sitc_num)
	label define peacewar -1 "-- Peace" 1 "-- War", replace
	egen sitc_war = group(product_sitc_num war), label

	levelsof exportsimports, local(levels)
	foreach i of local levels{
		
		///these are necessary to call the global macro with the pvalue of the MANOVA to insert in the violin graphs 
		if exportsimports=="Exports" local name X
		if exportsimports=="Imports" local name I
		if "`direction'"== "national" local dir nat
		else local dir loc

		vioplot ln_percent if exportsimports=="`i'", over(sitc_war) hor ylabel(,angle(0) labsize(vsmall)) ///
				plotregion(fcolor(white)) graphregion(fcolor(white)) ///
				note("`i' " "MANOVA with plantation foodstuff: ${`period1'`period2'1`dir'`name'}" ///
				"MANOVA without plantation foodstuff: ${`period1'`period2'0`dir'`name'} " ///
				, size(vsmall)) ///
				xtitle("Log Percentage share of trade flows")
				///title(`title')
		
		graph export "$hamburggit/Paper - Impact of War/Paper/`period1'_`period2'_`direction'_distribution_`name'.pdf", replace
	}
	

	if "`direction'"== "national" local dir nat
	else local dir loc
	local name XI

	vioplot ln_percent, over(sitc_war) hor ylabel(,angle(0) labsize(vsmall)) ///
			plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			note("Exports and Imports" "MANOVA with plantation foodstuff: ${`period1'`period2'1`dir'`name'}" ///
			"MANOVA without plantation foodstuff: ${`period1'`period2'0`dir'`name'} " ///
			, size(vsmall)) ///
			xtitle("Log Percentage share of trade flows")
				///title(`title')
		
	graph export "$hamburggit/Paper - Impact of War/Paper/`period1'_`period2'_`direction'_distribution_`name'.pdf", replace
	if "`period1'"=="peace" | "`period2'"=="peace" /* 
	*/ graph export "$hamburggit/Abstracts/`period1'_`period2'_`direction'_distribution_`name'.pdf", replace
		
	
	use temp.dta, clear
	
end


