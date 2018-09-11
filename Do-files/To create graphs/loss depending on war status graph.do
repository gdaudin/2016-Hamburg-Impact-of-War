


if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\tirindee\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}


use "$hamburggit/Results/Yearly loss measure.dta", clear
drop if grouping_classification=="All" | grouping_classification=="All_ss_outremer"



replace war_status="colonies" if grouping_classification=="Outre-mers"
bys year exportsimports war_status : gen nbr_pays=_N




**********Graph pour nombre neutres, alliés et foes
replace war=0 if year==1802
gen war_nbr_pays=war*nbr_pays
replace war_nbr_pays=. if war==0


twoway (bar war_nbr_pays year, cmissing(n)) if war_status=="neutral", ///
		yscale(range(0 8)) ytitle("Number of neutral countries or regions") ///
		name(neutral, replace) plotregion(fcolor(white)) graphregion(fcolor(white))

twoway (bar war_nbr_pays year, cmissing(n)) if war_status=="ally", ///
		yscale(range(0 8)) ytitle("Number of allied countries or regions") ///
		name(ally, replace) plotregion(fcolor(white)) graphregion(fcolor(white))
		
twoway (bar war_nbr_pays year, cmissing(n)) if war_status=="foe", ///
		yscale(range(0 8)) ytitle("Number of ennemy countries or regions") ///
		name(foe, replace) plotregion(fcolor(white)) graphregion(fcolor(white))

graph combine (neutral ally foe), ycommon plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$hamburggit/Results/Loss graphs/by war_status/Number of protagonists.pdf", replace
graph export "$hamburggit/Paper - Impact of War/Paper/Number of protagonists.pdf", replace

***********************************






egen tot_trade = sum(value),by(year exportsimports war_status)

gen trade_share = value/tot_trade

***Vérification
egen tot_share = max(trade_share), by(year exportsimports war_status)
codebook tot_share
***
 
gen trade_share_x_loss=trade_share*loss
gen trade_share_x_mean_loss=trade_share*mean_loss

egen weighted_mean_loss =sum(trade_share_x_mean_loss), by(year exportsimports war_status nbr_pays)
egen average_mean_loss  =mean(mean_loss), by(year exportsimports war_status nbr_pays)
codebook mean_loss average_mean_loss


egen weighted_loss =sum(trade_share_x_loss), by(year exportsimports war_status nbr_pays)
egen average_loss  =mean(loss), by(year exportsimports war_status nbr_pays)


bys weighted_mean_loss average_mean_loss weighted_loss average_loss year exportsimports war_status war nbr_pays : keep if _n==1
keep weighted_mean_loss average_mean_loss weighted_loss average_loss year exportsimports war_status war nbr_pays

sort year

*******Et maintenant les graphiques


foreach year in 1783 1784 1785 1786 1790 1791 1793 1794 1795 1796 {
	local new_obs = _N + 1
    set obs `new_obs'
	replace year=`year' if year==.
}
fillin year exportsimports war_status
drop if exportsimports=="" | war_status==""
replace weighted_mean_loss=. if weighted_mean_loss==0 & war_status=="colonies"


foreach loop_war_status in colonies foe ally neutral {
	if "`loop_war_status'" =="neutral" local title2 "neutrals"
	if "`loop_war_status'" =="foe" local title2 "foes"
	if "`loop_war_status'" =="ally" local title2 "allies"
	if "`loop_war_status'" =="colonies" local title2 "colonies"
		
	foreach loop_importsexports in XI Imports Exports {
		if "`loop_importsexports'" =="Imports" local title1 "Imports from "
		if "`loop_importsexports'" =="Exports" local title1 "Exports to "
		if "`loop_importsexports'" =="XI" local title1 "Total trade with "


		graph twoway (line average_mean_loss year, cmissing(n) lcolor(blue)) ///
			(line weighted_mean_loss year, cmissing(n) lcolor(blue%10))  ///
			if war_status=="`loop_war_status'" & exportsimports=="`loop_importsexports'", ///
			yline(0, lwidth(medium) lcolor(grey)) ///
			legend(order (1 2) label(1 "average loss over the period") label(2 "idem, weighted") row(2)) ///
			title("`title1'`title2'") name("`loop_war_status'_`loop_importsexports'", replace) ///
			plotregion(fcolor(white)) graphregion(fcolor(white))
	}
}
		
graph 	combine neutral_XI ally_XI foe_XI colonies_XI, ycommon name(XI, replace) ///
		plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$hamburggit/Results/Loss graphs/by war_status/XI.pdf", replace
graph export "$hamburggit/Paper - Impact of War/Paper/loss_by_war_status_XI.pdf", replace

graph 	combine neutral_Imports ally_Imports foe_Imports colonies_Imports, ///
		ycommon name(Imports, replace) ///
		plotregion(fcolor(white)) graphregion(fcolor(white))
		
graph export "$hamburggit/Results/Loss graphs/by war_status/Imports.pdf", replace
graph 	combine neutral_Exports ally_Exports foe_Exports colonies_Exports, ///
		ycommon name(Exports, replace) ///
		plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$hamburggit/Results/Loss graphs/by war_status/Exports.pdf", replace
			
