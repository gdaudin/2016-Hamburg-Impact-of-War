
capture program drop composition_trade_ind_reg
program composition_trade_ind_reg
args direction X_I classification period

	use temp_for_hotelling.dta, clear

	if "`direction'"=="national"{
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
	
	generate ln_loss = ln(loss)
	generate ln_loss_nomemory=ln(loss_nomemory)
	

	
	if "`classification'" == "product_sitc_simplEN" {
		local class sitc
		local macro p ln_p
		foreach i of local macro{
			label var `i'`X_I'0a "Other foodstuff"
			label var `i'`X_I'1 "Drinks and tobacco"
			label var `i'`X_I'2 "Crude material"
			label var `i'`X_I'4 "Oils"
			label var `i'`X_I'5 "Chemical products"
			label var `i'`X_I'6a_c "Leather wood and paper product"
			label var `i'`X_I'6d_h_i "Other threads and fabric"
			label var `i'`X_I'6e "Wool threads and fabric"
			label var `i'`X_I'6f "Silk threads and fabric"
			label var `i'`X_I'6g "Cotton threads and fabric"
			label var `i'`X_I'6j_k_7_8_9c "Other industrial products"
			label var `i'`X_I'0b "Plantation foodstuff"
		}
	}
	else if "`classification'" == "partner_grouping_8" local class pays8
	
	
	if "`X_I'"=="Exports" rename *Exports* *E*
	if "`X_I'"=="Imports" rename *Imports* *I*
	rename *6j_k_7_8_9c* *other*
	
	capture erase "$hamburggit/Results/Structural change/Individual_reg_`classification'_`X_I'.csv"
	capture erase "$hamburggit/Paper - Impact of War/Paper/Individual_reg_`classification'_`X_I'.tex"
	
	local i = 0
	
	foreach var of varlist ln_p* {
			eststo `var'_loss: regress loss `var'
			eststo `var'_loss_nom: regress loss_nomemory `var'
			eststo `var'_ln_loss: regress ln_loss `var'
			eststo `var'_ln_loss_nom: regress ln_loss_nomemory `var'
			
			if `i' ==0 esttab ln_p* using "$hamburggit/Results/Structural change/Individual_reg_`classification'_`X_I'.csv", append csv label compress b(%8.2f) ///
					noconstant noobs nonumber nonotes nolines noeqlines

			else esttab ln_p* using "$hamburggit/Results/Structural change/Individual_reg_`classification'_`X_I'.csv", append csv label compress b(%8.2f) ///
					noconstant noobs nonumber nomtitle nonotes  nolines noeqlines
					
			if `i' ==0 esttab ln_p* using "$hamburggit/Paper - Impact of War/Paper/Individual_reg_`classification'_`X_I'.tex", append tex label compress b(%8.2f) ///
					noconstant noobs nonumber nonotes nolines noeqlines

			else esttab ln_p* using "$hamburggit/Paper - Impact of War/Paper/Individual_reg_`classification'_`X_I'.tex", append tex label compress b(%8.2f) ///
					noconstant noobs nonumber nomtitle nonotes  nolines noeqlines
			eststo clear
			local i = `i'+1
	}

  *esttab ln_p* using "$hamburggit/Results/Structural change/Individual_reg_`classification'_`X_I'.csv", replace csv label
	

end
eststo clear
composition_trade_ind_reg  national Exports product_sitc_simplEN all

