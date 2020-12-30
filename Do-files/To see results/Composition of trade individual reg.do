
capture program drop composition_trade_ind_reg
program composition_trade_ind_reg
args direction X_I classification period

	use "$hamburg/database_dta/temp_for_hotelling.dta", clear

	if period=="pre1795" keep if year <=1795
	
	if "`direction'"=="national"{
		if "`classification'"=="product_sitc_simplEN" keep if best_guess_national_product==1 
		if "`classification'"=="sitc_aggr" keep if best_guess_national_product==1 
		if "`classification'"=="partner_grouping_8" keep if best_guess_national_partner==1 
	}
	
	
	else if "`direction'"=="regional"{
		**Computing total trade
		gen pour_calcul_national = best_guess_national_partner*value
		bysort year export_import : egen commerce_national = total(pour_calcul_national)
		drop pour_calcul_national
		
		**Keeping nationl by department when available
		generate source_tout_department_one = 1 if source_type=="National toutes directions tous partenaires" | source_type=="National toutes directions sans produits"
		bysort year : egen source_tout_department = max(source_tout_department_one)
		drop if source_tout_department==1 & source_type != "National toutes directions tous partenaires" & source_type !="National toutes directions sans produits"
		
		**Keeping best_guess_department_prodxpart (or the next best thing for 1789) otherwise. Nantes is 1789 is not complete
		drop if best_guess_department_prodxpart !=1 & source_tout_department!=1 & year!=1789
		drop if year==1789 & best_guess_national_department ==0
		drop if year==1789 & tax_department =="Nantes"
		
		**Various
		drop if year==1714
		
		**Now to compute the share of trade
		collapse (sum) value, by(tax_department_grouping export_import year commerce_national period_str war)
		gen percent=value/commerce_national
		drop if tax_department_grouping =="France" |  tax_department_grouping =="Colonies Françaises de l'Amérique"  |  tax_department_grouping =="" 
		
		
		rename tax_department_grouping regional
		replace regional = "Saint_Quentin" if regional=="Saint-Quentin"s
	}
	
	
	if "`X_I'"=="Exports" | "`X_I'"=="Imports" keep if export_import=="`X_I'"

	
	
	if "`period'"=="pre1795" drop if year >= 1795
	
	if "`direction'"!="regional" {
		collapse (sum) value, by(year `classification' export_import period_str war)
		bysort year: egen total=sum(value)
		gen percent= value/total
	}
		
	gen ln_percent=ln(percent)
	if "`classification'" == "product_sitc_simplEN" drop if product_sitc_simplEN == "Other"
	if "`classification'" == "partner_grouping_8" drop if partner_grouping_8 == ""
	
	
	
	keep year export_import `classification' percent ln_percent war
	
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
		foreach i of local macro {
			label var `i'`X_I'0a "Other foodstuff"
			label var `i'`X_I'0b "Plantation foodstuff"
			label var `i'`X_I'1 "Drinks and tobacco"
			label var `i'`X_I'2 "Crude material"
			label var `i'`X_I'4 "Oils"
			label var `i'`X_I'5 "Chemical products"
			label var `i'`X_I'6a_c "Leather wood and paper products"
			label var `i'`X_I'6d_h_i "Other threads and fabrics"
			label var `i'`X_I'6e "Wool threads and fabrics"
			label var `i'`X_I'6f "Silk threads and fabrics"
			label var `i'`X_I'6g "Cotton threads and fabrics"
			label var `i'`X_I'6j_k_7_8 "Other industrial products"
		}
		rename *6j_k_7_8* *other*
		local textitle "\shortstack{Other\\foodstuff}" "\shortstack{Plantation\\foodstuff}" "\shortstack{Drinks\\and\\tobacco}" "\shortstack{Crude\\material}" "Oils" "\shortstack{Chemical\\products}" "\shortstack{Leather\\wood and\\paper\\products}" "\shortstack{Other\\threads\\and fabric}"  "\shortstack{Wool\\threads\\and fabrics}" "\shortstack{Silk\\threads\\and fabrics}" "\shortstack{Cotton\\threads\\and fabrics}" "\shortstack{Other\\industrial\\products}"
		local tabular_columns  p{1.5cm} p{1.7cm} p{1.7cm} p{1.7cm}  p{1.7cm} p{1.7cm} p{1.7cm} p{1.7cm} p{1.7cm}  p{1.7cm} p{1.7cm} p{1.7cm} p{1.7cm}
	}
	
	
	if "`classification'" == "partner_grouping_8" {
		local textitle "\shortstack{Germany\\and\\Switzerland}" "Iberia" "Italy" "\shortstack{Low\\Countries}" "\shortstack{North\\of\\Holland}" "Overseas" "\shortstack{United\\Kingdom}"  "\shortstack{United\\States}"
		local tabular_columns  p{1.5cm} p{2cm} p{1.7cm} p{1.7cm}  p{1.7cm} p{1.7cm} p{1.7cm} p{1.7cm} p{1.7cm}
	}
	
	if "`classification'" == "regional" {

	}

	
	
	if "`X_I'"=="Exports" rename *Exports* *E*
	if "`X_I'"=="Imports" rename *Imports* *I*
	
	capture erase "$hamburggit/Results/Structural change/Individual_reg_`classification'_`X_I'_`period'.csv"
	capture erase "$hamburggit/Paper - Impact of War/Paper/Individual_reg_`classification'_`X_I'_`period'.tex"
	
	local i = 0
	
	label var loss "loss"
	label var loss_nomemory "loss_nm"
	label var ln_loss "ln(loss)"
	label var ln_loss_nomemory "ln(loss_nm)"
	
*	replace loss= 0 if loss==.
*	replace loss_nomemory= 0 if loss_nomemory==.
	
	egen min_ln_loss=min(ln_loss)
	replace ln_loss=min_ln_loss if ln_loss==. & loss!=.

	egen min_ln_loss_nomemory=min(ln_loss_nomemory)
	replace ln_loss_nomemory=min_ln_loss_nomemory if ln_loss_nomemory==. & loss_nomemory!=.

	
	
	quietly describe ln_p*
	local nbr_var = r(k)
	foreach loss in loss loss_nomemory ln_loss ln_loss_nomemory {
		local i = `i'+1
		foreach var of varlist ln_p* {
			eststo `var'_loss: regress `var' `loss' war year
		}
				
		if `i' ==1 esttab ln_p* using "$hamburggit/Results/Structural change/Individual_reg_`classification'_`X_I'_`period'.csv", append csv compress b(%8.2f) ///
				noconstant noobs nonumber nonotes nolines noeqlines

		else esttab ln_p* using "$hamburggit/Results/Structural change/Individual_reg_`classification'_`X_I'_`period'.csv", append csv label compress b(%8.2f) ///
				noconstant noobs nonumber nomtitle nonotes  nolines noeqlines
				
		if `i' ==1 esttab ln_p* using "$hamburggit/Paper - Impact of War/Paper/Individual_reg_`classification'_`X_I'_`period'.tex", ///
				append tex label compress b(%8.3f) wrap nogaps ///
				noconstant noobs nonumber nonotes   /*r2(%8.2f)*/ alignment(c) ///
				mtitle("`textitle'")  ///
				prehead(`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
				`"\begin{tabular}{`tabular_columns'}"') ///
				postfoot(`"\end{tabular}"')
									
		else esttab ln_p* using "$hamburggit/Paper - Impact of War/Paper/Individual_reg_`classification'_`X_I'_`period'.tex", ///
				append tex label compress b(%8.3f) wrap nogaps ///
				noconstant noobs nonumber nonotes  nomtitle /*r2(%8.2f)*/ alignment(c) ///
				prehead(`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
				`"\begin{tabular}{`tabular_columns'}"') ///
				postfoot(`"\end{tabular}"')

		eststo clear
	
	}

  *esttab ln_p* using "$hamburggit/Results/Structural change/Individual_reg_`classification'_`X_I'_`period'.csv", replace csv label
	

end

eststo clear


composition_trade_ind_reg  national Exports product_sitc_simplEN all

*composition_trade_ind_reg  regional Exports regional all
composition_trade_ind_reg  regional Imports regional all

/*
composition_trade_ind_reg  national Exports partner_grouping_8 all

/*

composition_trade_ind_reg  national Imports product_sitc_simplEN all
*/

