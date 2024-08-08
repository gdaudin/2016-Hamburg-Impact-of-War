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
    gen normalized_m_`var' = `var'/predicted_trade
    gen normalized_nm_`var' = `var'/predicted_trade_nomemory
    gen normalized_m_cum_`var' = cum_`var'/predicted_trade
    gen normalized_nm_cum_`var' = cum_`var'/predicted_trade_nomemory
}

twoway (line normalized_m_cum_val_prizes_All year) (line normalized_m_cum_val_prizes_FR year), scheme(stsj)

save "`HamburgDir'database_dta/English&French_prizes_transformed.dta", replace

