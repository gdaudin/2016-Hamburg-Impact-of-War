
capture program drop composition_trade_graph
program composition_trade_graph 
args period direction 

	preserve 
	
	use "$hamburg/database_dta/`period'_`direction'_temp.dta", clear
	
	qui graph 	pie value if exportsimports=="Exports", over(product_sitc_simplen) ///
			plabel(_all name, size(*0.7) color(white)) legend(off) ///
			by(war, legend(off) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			note("Exports")) 
		
	graph export "$hamburggit/Paper - Impact of War/Paper/`period'_composition_X.pdf", replace

	qui graph 	pie value if exportsimports=="Imports", over(product_sitc_simplen) ///
			plabel(_all name, size(*0.7) color(white)) ///
			by(war, legend(off) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			note("Imports")) 
		
	graph export "$hamburggit/Paper - Impact of War/Paper/`period'_composition_I.pdf", replace
	
	egen sitc_war = group(product_sitc_num war), label

	levelsof exportsimports, local(levels)
	foreach i of local levels{
		
		if exportsimports=="Exports" local name X
		if exportsimports=="Imports" local name I

		vioplot ln_percent if exportsimports=="`i'", over(sitc_war) hor ylabel(,angle(0) labsize(vsmall)) ///
				plotregion(fcolor(white)) graphregion(fcolor(white)) ///
				note("`i' " "Hotelling test pvalue with plantation foodstuff: ${`period'_1_`direction'_pval_`name'}" ///
				"Hotelling test pvalue without plantation foodstuff: ${`period'_0_`direction'_pval_`name'} " ///
				, size(vsmall)) ///
				xtitle("Log Percentage share")
				///title(`title')
		
		graph export "$hamburggit/Paper - Impact of War/Paper/`period'_`direction'_distribution_`name'.pdf", replace
	}
	
end


