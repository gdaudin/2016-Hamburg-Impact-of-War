version 18
clear all

// Set directories based on username
if (c(username) == "Tirindelli") {
    local HamburgPaperDir "/Users/Tirindelli/Desktop/HamburgPaper/"
    local HamburgDir "/Volumes/GoogleDrive/My Drive/Hamburg/"
}

if "`c(username)'" =="guillaumedaudin" {
	local HamburgDir "~/Documents/Recherche/2016 Hambourg et Guerre/"
	local  HamburgPaperDir"~/Répertoires GIT/2016-Hamburg-Impact-of-War/"
}




local RscriptDir "Do-files/Rscripts/"
local GraphDir "Graphs/"
local DataframeDir "Dataframe/"
local NewgraphsDir "New graphs/"
local PaperDir "Paper - Impact of War/Paper/"
local AuxFunctionDir "AuxFunction/"


use "`HamburgDir'database_dta/English&French_prizes.dta", clear




// Rename variables
rename importofprizegoodspoundsterling prizes_import
rename Number_of_prizes_Total_All num_prizes_All
rename Number_of_prizes_Total_FR num_prizes_FR
rename Number_of_prizes_Privateers_All num_prizes_priv_All
rename Number_of_prizes_Privateers_FR num_prizes_priv_FR
rename Total_Prize_value val_prizes_All
rename FR_Prize_value val_prizes_FR



//Some variations on the variables
gen priv_prizes_share_All = num_prizes_priv_All/num_prizes_All
gen num_prizes_RN_All = num_prizes_All-num_prizes_priv_All
gen num_prizes_RN_FR = num_prizes_FR-num_prizes_priv_FR



foreach var in num_prizes_All num_prizes_RN_All num_prizes_priv_All num_prizes_FR num_prizes_RN_FR num_prizes_priv_FR val_prizes_All val_prizes_FR{
    replace `var'=0 if `var'==.
    foreach year of numlist 1740(1)1815 {
        levelsof `var' if year == `year', local(blif) clean
        gen cum_`var'_`year' = `blif'*max(0,(1- 0.05*(year-`year'))) if year>=`year'
    }
    egen cum_`var' = rowtotal(cum_`var'_*)
    drop cum_`var'_*
}

*twoway (line cum_num_prizes_All year) (line cum_num_prizes_RN_All year) (line cum_num_prizes_priv_All year) /*
    */ (line cum_num_prizes_FR year) (line cum_num_prizes_RN_FR year) (line cum_num_prizes_priv_FR year) /*
    */ (line cum_val_prizes_FR year, yaxis(2)) (line cum_val_prizes_All year, yaxis(2)), scheme(stsj)



twoway (line cum_num_prizes_All year) (line cum_num_prizes_FR year) /*
    */ (line cum_val_prizes_FR year, yaxis(2)) (line cum_val_prizes_All year, yaxis(2)), scheme(stsj)


twoway (line cum_num_prizes_All year) (line cum_num_prizes_RN_All year) (line cum_num_prizes_priv_All year) /*
    */ (line cum_num_prizes_FR year) (line cum_num_prizes_RN_FR year) (line cum_num_prizes_priv_FR year), scheme(stsj)

twoway (line cum_num_prizes_All year) (line cum_num_prizes_FR year), scheme(stsj)

***We import predicted trade

merge 1:1 year using "$hamburg/database_dta/Loss_values.dta", keepusing(predicted_trade*)

foreach var in val_prizes_All val_prizes_FR  {
    if "`var'"=="val_prizes_All" local blif "all prizes"
    if "`var'"=="val_prizes_FR" local blif "French prizes"
    gen normalized_m_`var'      = `var'/predicted_trade
    label var normalized_m_`var' "Value of `blif' normalized by predicted trade (with memory)"
    gen normalized_nm_`var'     = `var'/predicted_trade_nomemory
    label var normalized_nm_`var' "Value of `blif' normalized by predicted trade (no memory)"
    gen normalized_m_cum_`var'  = cum_`var'/predicted_trade
    label var normalized_m_cum_`var' "Cumulated value of `blif' normalized by predicted trade (with memory)"
    gen normalized_nm_cum_`var' = cum_`var'/predicted_trade_nomemory 
    label var normalized_nm_cum_`var' "Cumulated value of `blif' normalized by predicted trade (no memory)"
}

**To normalize (and insist the value of the normalized variables cannot be interpreted)
levelsof normalized_m_cum_val_prizes_FR if year==1744, local(base) clean

foreach var in val_prizes_All val_prizes_FR  {
    replace normalized_m_`var'      = normalized_m_`var'/`base'
    replace normalized_nm_`var'     = normalized_nm_`var'/`base'
    replace normalized_m_cum_`var'  = normalized_m_cum_`var'/`base'
    replace normalized_nm_cum_`var' = normalized_nm_cum_`var'/`base'
}

save "`HamburgDir'database_dta/English&French_prizes_transformed.dta", replace

drop if year < 1740


replace war1=8 if war1!=.
replace war2=8 if war2!=.
replace war3=8 if war3!=.
replace war4=8 if war4!=.
replace war5=8 if war5!=.
replace blockade=8 if blockade!=.
generate minwar1=0 if war1!=.
generate minwar2=0 if war2!=.
generate minwar3=0 if war3!=.
generate minwar4=0 if war4!=.
generate minwar5=0 if war5!=.
generate minblockade=0 if blockade!=.

twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (area minwar1 year, color(gs9)) (area minwar2 year, color(gs9)) ///
			 (area minwar3 year, color(gs9)) (area minwar4 year, color(gs9)) ///
			 (area minwar5 year, color(gs9)) (area minblockade year, color(gs4)) ///
             (line normalized_m_cum_val_prizes_All year, lpattern(line)) (line normalized_m_cum_val_prizes_FR year, lpattern(dash)), ///
                title("Prizes captured by the British") ytitle("Base 1 in 1744 (French prizes)") legend (order(13 14) rows(2) size(small)) scheme(stsj)

graph export "$hamburggit/Paper - Impact of War/Paper/normalized_cum_val_prizes.png", as(png) replace



