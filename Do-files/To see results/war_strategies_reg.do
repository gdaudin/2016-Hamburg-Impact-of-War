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

/*
// Include external scripts
do `HamburgPaperDir'`RscriptDir'`DataframeDir'fwartime_corr_df
do `HamburgPaperDir'`RscriptDir'`AuxFunctionDir'halt
*/

// Load data
import delimited using "`HamburgDir'database_csv/mean_annual_loss.csv", clear
keep year loss loss_nomemory
tempfile loss
save `loss'

// Load other datasets
import delimited using "`HamburgDir'database_csv/colony_loss.csv", clear
keep year weight_france
tempfile colony_loss
save `colony_loss'

import delimited using "`HamburgDir'database_csv/naval_supremacy.csv", clear case(preserve)
keep year France_vs_GB ally_vs_foe allyandneutral_vs_foe
tempfile naval_sup
save `naval_sup'

*import delimited using "`HamburgDir'database_csv/temp_for_hotelling.csv", clear /// I am not sure what this is for

// Merge datasets
use `loss', clear
merge 1:1 year using `colony_loss'
drop _merge
merge 1:1 year using `naval_sup'
drop _merge
merge 1:1 year using "`HamburgDir'database_dta/English&French_prizes_transformed.dta", keepusing(*prize*)
drop _merge


// Rename variables

rename weight_france colonial_empire


// Create war variable

generate byte wara=1 if year >=1733 & year <=1738 
generate byte warb=1 if year >=1741 & year <=1744
generate byte war1=1 if year >=1744 & year <=1748
generate byte war2=1 if year >=1756 & year <=1763
generate byte war3=1 if year >=1778 & year <=1783
generate byte war4=1 if year >=1793 & year <=1802
generate byte war5=1 if year >=1803 & year <=1807
generate blockade=1 if year >=1807 & year <=1815



gen war_all = max(wara, warb, war1, war2, war3, war4, war5, blockade)
replace war_all = 1 if war_all != .
gen war= max(war1, war2, war3, war4, war5, blockade)
replace war = 1 if war != .



// Define independent labels
local indep_label "Prizes import" "Number of prizes" "Privateers \n prizes" ///
                    "Colonial Empire" "France vs Britain" "France vs Britain (incl. allies of both countries)" ///
                    "France vs Britain (incl. allies of both countries and neutrals as if they were on the French side)" "Battle dummy"

local log_max "max"



*********************** Regressions capture of empire

regress loss colonial_empire if war == 1
estimates store colonial_empire_1
regress loss colonial_empire
estimates store colonial_empire_2

*****************Regressions predation


gen ln_year = ln(year)


regress loss prizes_import if war == 1
regress loss num_prizes_All if war == 1
regress loss num_prizes_FR if war == 1
regress loss num_prizes_priv_All if war == 1
regress loss num_prizes_priv_FR if war == 1
regress loss num_prizes_RN_All if war == 1
regress loss num_prizes_RN_FR if war == 1

regress loss num_prizes_priv_All num_prizes_RN_All if war == 1
regress loss num_prizes_priv_All num_prizes_RN_All year if war == 1
regress loss num_prizes_priv_All num_prizes_RN_All ln_year if war == 1

regress loss num_prizes_priv_FR num_prizes_RN_FR if war == 1
regress loss num_prizes_priv_FR num_prizes_RN_FR year if war == 1
regress loss num_prizes_priv_FR num_prizes_RN_FR ln_year if war == 1



foreach var in num_prizes_All num_prizes_RN_All num_prizes_priv_All num_prizes_FR num_prizes_RN_FR num_prizes_priv_FR {


    regress loss cum_`var' if war==1
    regress loss cum_`var'

    regress loss `var' cum_`var' if war==1
    regress loss `var' cum_`var' 

}

regress loss cum_num_prizes_RN_All cum_num_prizes_priv_All if war==1
regress loss cum_num_prizes_RN_All cum_num_prizes_priv_All

regress loss num_prizes_RN_All cum_num_prizes_RN_All num_prizes_priv_All cum_num_prizes_priv_All if war==1
regress loss num_prizes_RN_All cum_num_prizes_RN_All num_prizes_priv_All cum_num_prizes_priv_All

**All this suggests that num_prizes_RN explains better that num_prizes_priv, but I am not sure we can make much of that. It is very much a time trend.
**Certainly, and that is interesting, the cumulated measure is much better than the single shock measure. 

regress loss num_prizes_All cum_num_prizes_All num_prizes_FR cum_num_prizes_FR if war==1 & year >=1741
regress loss num_prizes_All cum_num_prizes_All num_prizes_FR cum_num_prizes_FR if year >=1741
**En temps de guerre, les pertes (cumulées) françaises sont plus importantes que les pertes totales
**Sur l’ensemble des périodes, c’est l’inverse.

**With the cumulated and normalized value data (no effect in war time ; positive (!) effect in peace time)

regress loss normalized_m_cum_val_prizes_All if war==1 & year >=1741
regress loss normalized_m_cum_val_prizes_FR if war==1 & year >=1741

regress loss normalized_m_cum_val_prizes_All if war!=1 & year >=1741
regress loss normalized_m_cum_val_prizes_FR if war!=1 & year >=1741

regress loss normalized_m_cum_val_prizes_All if year >=1741
regress loss normalized_m_cum_val_prizes_FR if year >=1741

**With the normalized value data (basically no effect)

regress loss normalized_m_val_prizes_All if war==1 & year >=1741
regress loss normalized_m_val_prizes_FR if war==1 & year >=1741

regress loss normalized_m_val_prizes_All if war!=1 & year >=1741
regress loss normalized_m_val_prizes_FR if war!=1 & year >=1741

regress loss normalized_m_val_prizes_All if year >=1741
regress loss normalized_m_val_prizes_FR if year >=1741






****Predation does not resist in front of colonial empire
regress loss cum_num_prizes num_prizes colonial_empire

regress loss cum_num_prizes num_prizes colonial_empire if year <=1820
**Beware : the significativity of num_prizes depends on the end date



*******************Naval Supremacy

regress loss France_vs_GB if war == 1
regress loss ally_vs_foe if war == 1
regress loss allyandneutral_vs_foe if war == 1

regress loss France_vs_GB ally_vs_foe allyandneutral_vs_foe if war == 1
regress loss France_vs_GB ally_vs_foe allyandneutral_vs_foe year if war == 1
regress loss France_vs_GB ally_vs_foe allyandneutral_vs_foe ln_year if war == 1

**Nothing survives with a time trend thrown in...

regress loss France_vs_GB ally_vs_foe allyandneutral_vs_foe ln_year if war != 1
*A placebo regression outside of the war periods is very significant... Worrying. Maybe a common time trend ?
regress loss France_vs_GB ally_vs_foe allyandneutral_vs_foe ln_year if war != 1 & year <=1820

*There must be strange interactions between the NS variables

regress loss allyandneutral_vs_foe ln_year if war != 1
regress loss allyandneutral_vs_foe ln_year if war != 1 & year <=1820

*This is reassuring 

************Major battles
regress loss battle_dummy  if war == 1
regress loss battle_dummy ln_year if war == 1

regress loss battle_dummy running_battle ln_year if war == 1
regress loss battle_dummy running_battle ln_year






*************************************Producing the tables

local wartime_policies colonial_empire

foreach var of local wartime_policies {

    local outpath  `HamburgPaperDir'`PaperDir'univariate_regression_`var'.tex
    display "`outpath'"

esttab `var'* using "`HamburgPaperDir'`PaperDir'univariate_regression_`var'.tex", ///
    cells("b(fmt(2)) se(fmt(2))") ///
    label ///
    stats(N r2_a) ///
    starlevels(* 0.05 ** 0.01 *** 0.001) ///
    replace
}



/*


capture program drop univariate_regression
program univariate_regression
args varname

regress loss `varname' if war == 1
estimates store est_1

tempvar log_varname
gen `log_varname' = log(`varname')

regress loss `log_varname' if war == 1
estimates store est_2

// Prepare the outside with the results
local outpath  `HamburgPaperDir'`PaperDir'univariate_regression_`varname'.tex
display "`outpath'"


esttab est_1 est_2 using "`outpath'", ///
    cells("b(fmt(2)) se(fmt(2))") ///
    varlabels(`indep_label') ///
    label ///
    stats(N r2_a) ///
    starlevels(* 0.05 ** 0.01 *** 0.001) ///
    replace


end

univariate_regression prizes_import
univariate_regression num_prizes
univariate_regression num_prizes_priv
univariate_regression colonial_empire
univariate_regression France_vs_GB
univariate_regression ally_vs_foe
univariate_regression allyandneutral_vs_foe
univariate_regression battle_dummy
