
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\tirindee\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
}



set more off



capture program drop prepar_data
program prepar_data
args outremer freq


use "$hamburggit/Results/`freq' loss measure.dta", clear
gen peacewar="peace" if strmatch(period_str,"Peace*")==1
replace peacewar = "war" if peacewar=="" 


*drop if grouping_classification=="All" | grouping_classification=="All_ss_outremer"
if `outremer'==0 drop if grouping_classification=="Outre-mers"

tab grouping_classification

*****ln_loss ranges from -infinty to +infinity, that's why we take logs. 
*****We add a minus in fron for coeherence (we have talked about loss function all the way)
gen ln_loss = -ln(1-loss)
gen ln_loss_nomemory = -ln(1-loss_nomemory)

merge m:1 grouping_classification exportsimports using "$hamburg/database_dta/Share of land trade 1792.dta"
drop if _merge==2 & grouping_classification!="All" & grouping_classification!="All_ss_outremer"
drop _merge

tab grouping_classification


if "`freq'"=="Mean" {
	preserve
	use "$hamburg/database_dta/Neutral legislation.dta", clear
	collapse (mean) neutral_policy, by(period_str)
	save temp.dta, replace
	restore
	merge m:1 period_str using temp.dta
	erase temp.dta
	drop if _merge!=3 
	drop _merge

	preserve
	use "$hamburg/database_dta/warships_wide.dta", clear
	collapse (mean) warships*, by(period_str)
	save temp.dta, replace
	restore
	merge m:1 period_str using temp.dta
	erase temp.dta
	drop if _merge!=3 
	drop _merge

	preserve
	use "$hamburggit/External Data/Colonies loss.dta", clear
	gen  colonies_loss=1-weight_france
	collapse (mean) colonies_loss, by(period_str)
	save temp.dta, replace
	restore
	merge m:1 period_str using temp.dta
	erase temp.dta
	drop if _merge!=3 
	drop _merge
	
	preserve
	use "$hamburg/database_dta/English_prizes.dta",  clear
	collapse (mean) Number_of_prizes_Total_All, by(period_str)
	save temp.dta, replace
	restore
	merge m:1 period_str using temp.dta
	erase temp.dta
	drop if _merge!=3 
	drop _merge
}


if "`freq'"=="Yearly" {
	merge m:1 year using "$hamburg/database_dta/warships_wide.dta"
	drop if _merge!=3 
	drop _merge

	merge m:1 year using "$hamburg/database_dta/Neutral legislation.dta"
	drop if _merge!=3 
	drop _merge

	merge m:1 year using "$hamburggit/External Data/Colonies loss.dta"
	rename weight_france colonial_power
	*gen  colonies_loss=1-weight_france
	drop if _merge!=3 
	drop _merge
	
	merge m:1 year using "$hamburg/database_dta/English_prizes.dta"
	drop if _merge!=3 
	drop _merge
}
	
	



gen country_exportsimports = grouping_classification+"_"+exportsimports

foreach var in peacewar country_exportsimports grouping_classification exportsimports war_status {

	encode `var', gen(`var'_num)

}

gen colonies= (grouping_classification=="Outre-mers")
bys year exportsimports war_status : gen nbr_pays=_N if ///
	grouping_classification!="All" & grouping_classification!="All_ss_outremer"

egen tot_trade = sum(value) if grouping_classification!="All" & ///
	 grouping_classification!="All_ss_outremer",by(year exportsimports war_status)
gen trade_share = value/tot_trade
 
gen trade_share_x_loss=trade_share*loss
gen trade_share_x_mean_loss=trade_share*mean_loss

egen weighted_mean_loss =sum(trade_share_x_mean_loss) if grouping_classification!="All" & ///
	 grouping_classification!="All_ss_outremer", by(year exportsimports war_status nbr_pays)
egen average_mean_loss  =mean(mean_loss) if grouping_classification!="All" & ///
	 grouping_classification!="All_ss_outremer", by(year exportsimports war_status nbr_pays)
codebook mean_loss average_mean_loss


egen weighted_loss =sum(trade_share_x_loss) if grouping_classification!="All" & ///
	 grouping_classification!="All_ss_outremer", by(year exportsimports war_status nbr_pays)
egen average_loss  =mean(loss) if grouping_classification!="All" & ///
	 grouping_classification!="All_ss_outremer", by(year exportsimports war_status nbr_pays)
	 
replace neutral_policy=1 if neutral_policy==2	 

******************FIN DE LA PRÉPARATION DES DONNÉÉS
/*
if "`freq'"=="Mean" local weight [fweight=nbr_of_years]


reg ln_loss i.war_status_num#peacewar_num  ///
		`weight' 

		
reg ln_loss i.war_status_num#peacewar_num if year<=1815  ///
		`weight' 
reg ln_loss i.war_status_num#peacewar_num if year<=1807	 ///
		`weight' 	
reg ln_loss i.war_status_num#peacewar_num if year<=1793  ///
		`weight' 


areg ln_loss i.war_status_num#peacewar_num ///
		`weight' ///
		, absorb(country_exportsimports_num)

*/
		
		
		

end


*prepar_data 1 R&N Mean
prepar_data 1 Yearly

/*
reg ln_loss i.neutral_policy i.neutral_policy#c.colonial_power ///
			i.neutral_policy#c.warships_France_vs_GB ///
			if country_exportsimports == "All_XI" & peacewar=="peace", nocons robust
			
reg ln_loss i.neutral_policy i.neutral_policy#c.colonial_power colonial_power ///
			i.neutral_policy#c.warships_allyandneutral_vs_foe ///
			warships_allyandneutral_vs_foe if country_exportsimports == "All_XI" ///
			& peacewar=="peace", nocons robust 
			
			
reg ln_loss i.neutral_policy i.neutral_policy#c.colonial_power colonial_power ///
			i.neutral_policy#c.warships_allyandneutral_vs_foe ///
			warships_allyandneutral_vs_foe if country_exportsimports == "All_XI" ///
			& peacewar=="war", nocons robust 

reg ln_loss i.neutral_policy colonial_power ///
			warships_allyandneutral_vs_foe ///
			if country_exportsimports == "All_XI" ///
			& peacewar=="war", nocons robust			
*/

****Four variables separated
reg ln_loss colonial_power i.peacewar_num   c.colonial_power#i.peacewar_num ///
	if country_exportsimports == "All_XI", robust     cluster(period_str)
reg ln_loss warships_allyandneutral_vs_foe i.peacewar_num  ///
	c.warships_allyandneutral_vs_foe#i.peacewar_num if ///
	country_exportsimports == "All_XI", robust cluster(period_str)    
reg ln_loss i.neutral_policy i.peacewar_num i.neutral_policy#i.peacewar_num ///
	if country_exportsimports == "All_XI", robust  cluster(period_str)  
reg ln_loss Number_of_prizes_Total_All i.peacewar_num  ///
	if country_exportsimports == "All_XI", robust  cluster(period_str)  
	
****Three variables together but peace and war separated	
eststo reg1: reg ln_loss i.neutral_policy i.neutral_policy#c.colonial_power colonial_power ///
			i.neutral_policy#c.warships_allyandneutral_vs_foe ///
			warships_allyandneutral_vs_foe Number_of_prizes_Total_All /// 
			if country_exportsimports == "All_XI" ///
			& peacewar=="peace",  nocons robust 			
eststo reg2: reg ln_loss i.neutral_policy i.neutral_policy#c.colonial_power colonial_power ///
			i.neutral_policy#c.warships_allyandneutral_vs_foe  Number_of_prizes_Total_All /// 
			warships_allyandneutral_vs_foe Number_of_prizes_Total_All /// 
			if country_exportsimports == "All_XI" ///
			& peacewar=="war", nocons robust 
esttab 	reg1 reg2, drop(0.*) mtitles(Peace War) varlab(1.neutral_policy "Neutral policy" ///
		1.neutral_policy#c.colonial_power "Neutral#Colonial" colonial_power "Colonial power" ///
		1.neutral_policy#c.warships_allyandneutral_vs_foe "Neutral#Warship" ///
		warships_allyandneutral_vs_foe "Warship" Number_of_prizes_Total_All)
eststo clear
	
blif
reg ln_loss i.neutral_policy i.war_status_num war_status_num#i.neutral_policy ///
	i.neutral_policy#c.colonial_power colonial_power  ///
	c.warships_allyandneutral_vs_foe#i.neutral_policy warships_allyandneutral_vs_foe ///
	if peacewar=="peace" & exportsimports == "XI", robust nocons
	
reg ln_loss i.neutral_policy i.war_status_num war_status_num#i.neutral_policy ///
	i.neutral_policy#c.colonial_power colonial_power  ///
	c.warships_allyandneutral_vs_foe#i.neutral_policy warships_allyandneutral_vs_foe ///
	if peacewar=="war" & exportsimports == "XI", robust nocons
			
preserve 
bys weighted_mean_loss average_mean_loss weighted_loss average_loss year ///
	exportsimports war_status war nbr_pays : keep if _n==1
	
eststo reg1: reg ln_loss i.neutral_policy i.war_status_num i.war_status_num#neutral_policy ///
			i.neutral_policy#c.colonial_power warships_allyandneutral_vs_foe ///
			i.neutral_policy#c.warships_allyandneutral_vs_foe colonial_power ///
			if exportsimports == "XI" & peacewar=="war", nocons robust
			
eststo reg2: reg ln_loss i.neutral_policy i.war_status_num i.war_status_num#neutral_policy ///
			i.neutral_policy#c.colonial_power warships_allyandneutral_vs_foe ///
			i.neutral_policy#c.warships_allyandneutral_vs_foe colonial_power ///
			if exportsimports == "XI" & peacewar=="peace", nocons robust
			
esttab 	reg1 reg2, drop(0.* 1.war_status_num 1.war_status_num#0.neutral_policy) ///
		mtitles(Peace War) varlab(1.neutral_policy "NeutralP" ///
		1.neutral_policy#c.colonial_power "Neutral#Colonial" colonial_power "Colonial power" ///
		1.neutral_policy#c.warships_allyandneutral_vs_foe "Neutral#Warship" ///
		warships_allyandneutral_vs_foe "Warship" 2.war_status_num "Foe" ///
		3.war_status_num "Neutral" ///
		1.war_status_num#1.neutral_policy "Foe#NeutralP" ///
		1.war_status_num#1.neutral_policy "Neutral#NeutralP") 

restore

/*

use "$hamburggit/Results/temp.dta", clear


areg ln_loss i.peacewar_num i.war_status_num i.war_status_num#peacewar_num ///
		if breakofinterest=="R&N", absorb(country_exportsimports_num)
areg ln_loss i.peacewar_num i.war_status_num i.war_status_num#peacewar_num ///
		[fweight=nbr_of_years] ///
		if breakofinterest=="R&N", absorb(country_exportsimports_num)


reg ln_loss i.peacewar_num#exportsimports_num i.grouping_classification_num#exportsimports_num colonies_loss


reg ln_loss i.peacewar_num#exportsimports_num i.grouping_classification_num#exportsimports_num colonies_loss neutral_policy




