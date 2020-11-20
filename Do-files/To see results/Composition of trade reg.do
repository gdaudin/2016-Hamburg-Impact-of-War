
capture program drop composition_trade_reg
program composition_trade_reg
args plantation_yesno direction X_I classification period

	use temp_for_hotelling.dta, clear

	if "`direction'"=="national"{
		blif
		if "`classification'"=="product_sitc_simplEN" keep if best_guess_national_product==1 
		if "`classification'"=="sitc_aggr" keep if best_guess_national_product==1 
		if "`classification'"=="partner_grouping_8" keep if best_guess_national_partner==1 
	}
	
	else{
		gen commerce_local = 1 if source_type=="Local" & year!=1750 | ///
			source_type=="National toutes directions tous partenaires" | ////
			(source_type=="National toutes directions partenaires manquants" & year==1788 & partner_grouping=="Outre-mers") | ////
			(source_type=="National toutes directions partenaires manquants" & year==1789 & partner_grouping=="Pas Outre-mers")
	
		keep if commerce_local==1
		drop commerce_local
		if "`direction'"=="mars" keep if direction=="Marseille"
		if "`direction'"=="nant" keep if direction=="Nantes"
		if "`direction'"=="renn" keep if direction=="Rennes"
		if "`direction'"=="bord" keep if direction=="Bordeaux"
		if "`direction'"=="LR" keep if direction=="La Rochelle"	
		if "`direction'"=="bayo" keep if direction=="Bayonne"
	}
	collapse (sum) value, by(year product_sitc_simplEN export_import period_str)
	if `plantation_yesno'==0 & "`classification'"=="product_sitc_simplEN" drop if product_sitc_simplEN=="Plantation foodstuff"
	if "`period'"=="pre1795" drop if year >= 1795
	

	if "`X_I'"=="Exports" | "`X_I'"=="Imports"{
		keep if export_import=="`X_I'"
		bysort year: egen total=sum(value)
		gen percent= value/total
	}

	else{
		bysort year: egen total=sum(value)
		gen percent= value/total
	}
		
	if `plantation_yesno'==0 & "`classification'"!="product_sitc_simplEN" drop if product_sitc_simplEN=="Plantation foodstuff"
			
	gen ln_percent=ln(percent)
	if "`classification'" == "product_sitc_simplEN" drop if product_sitc_simplEN == "Other"
	
	keep year export_import `classification' percent ln_percent
	
	if "`classification'" == "product_sitc_simplEN"{
		rename product_sitc_simplEN sitc_simplen
		merge m:1 sitc_simplen using "$hamburggit/External Data/classification_product_simplEN_simplEN_short.dta"
		keep if _merge==3
		drop _merge
		drop sitc_simplen
		rename sitc_simplen_short product_sitc_simplEN 
	}
		
	gen id=export_import+ `classification'
	replace id=subinstr(id," ","",.)
	drop export_import `classification'
	
	rename percent p
	rename ln_percent ln_p

	reshape wide p ln_p, i(year) j(id) string 
	merge 1:1 year using "$hamburg/database_dta/FR_loss.dta"
	drop if _merge==2
	
	if "`X_I'"=="Exports" local name X
	else if "`X_I'"=="Imports" local name I
	else local name I_X
	
	if "`classification'" == "product_sitc_simplEN" local class sitc
	else if "`classification'" == "partner_grouping_8" local class pays8
	
	eststo ln_p`name'`class'`plantation_yesno': regress loss ln_p*
	
	if `plantation_yesno' == 1 test ln_pExports0a ln_pExports0b ln_pExports1 ln_pExports2 ln_pExports4 ln_pExports5 ///
		ln_pExports6a_c ln_pExports6d_h_i ln_pExports6e 		ln_pExports6f ln_pExports6g ln_pExports6j_k_7_8_9c
	if `plantation_yesno' == 0 test ln_pExports0a ln_pExports1 ln_pExports2 ln_pExports4 ln_pExports5 ///
		ln_pExports6a_c ln_pExports6d_h_i ln_pExports6e 		ln_pExports6f ln_pExports6g ln_pExports6j_k_7_8_9c
	local ln_p`name'`class'`plantation_yesno'_joint_test=r(p)
	
	corr ln_p* loss
	
	
	
	eststo ln_pnm`name'`class'`plantation_yesno': regress loss_nomemory ln_p*
	
	if `plantation_yesno' == 1 test ln_pExports0a ln_pExports0b ln_pExports1 ln_pExports2 ln_pExports4 ln_pExports5 ///
		ln_pExports6a_c ln_pExports6d_h_i ln_pExports6e 		ln_pExports6f ln_pExports6g ln_pExports6j_k_7_8_9c
	if `plantation_yesno' == 0 test ln_pExports0a ln_pExports1 ln_pExports2 ln_pExports4 ln_pExports5 ///
		ln_pExports6a_c ln_pExports6d_h_i ln_pExports6e 		ln_pExports6f ln_pExports6g ln_pExports6j_k_7_8_9c
	local ln_pnm`name'`class'`plantation_yesno'_joint_test=r(p)
	corr ln_p* loss_nomemory
	
	

	eststo p`name'`class'`plantation_yesno':  regress loss_nomemory p*
	
	if `plantation_yesno' == 1 test pExports0a pExports0b pExports1 pExports2 pExports4 pExports5 ///
		pExports6a_c pExports6d_h_i pExports6e 		pExports6f pExports6g pExports6j_k_7_8_9c
	if `plantation_yesno' == 0 test pExports0a pExports1 pExports2 pExports4 pExports5 ///
		pExports6a_c pExports6d_h_i pExports6e 		pExports6f pExports6g pExports6j_k_7_8_9c
	local p`name'`class'`plantation_yesno'_joint_test=r(p)
	corr p* loss
	
	
	
	eststo pnm`name'`class'`plantation_yesno':  regress loss p*
	
	if `plantation_yesno' == 1 test pExports0a pExports0b pExports1 pExports2 pExports4 pExports5 ///
		pExports6a_c pExports6d_h_i pExports6e 		pExports6f pExports6g pExports6j_k_7_8_9c
	if `plantation_yesno' == 0 test pExports0a pExports1 pExports2 pExports4 pExports5 ///
		pExports6a_c pExports6d_h_i pExports6e 		pExports6f pExports6g pExports6j_k_7_8_9c
	local pnm`name'`class'`plantation_yesno'_joint_test=r(p)
	corr p* loss_nomemory
	
	

end



