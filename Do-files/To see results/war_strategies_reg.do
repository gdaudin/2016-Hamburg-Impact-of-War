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

import delimited using "`HamburgDir'database_csv/prizes.csv", clear case(preserve)
keep year Number_of_prizes_* importofprizegoodspoundsterling
tempfile prizes
save `prizes'

*import delimited using "`HamburgDir'database_csv/temp_for_hotelling.csv", clear /// I am not sure what this is for

// Merge datasets
use `loss', clear
merge 1:1 year using `colony_loss'
drop _merge
merge 1:1 year using `naval_sup'
drop _merge
merge 1:1 year using `prizes'
drop _merge

// Rename variables
rename importofprizegoodspoundsterling prizes_import
rename Number_of_prizes_Total_All num_prizes_All
rename Number_of_prizes_Total_FR num_prizes_FR
rename Number_of_prizes_Privateers_All num_prizes_priv_All
rename Number_of_prizes_Privateers_FR num_prizes_priv_FR

rename weight_france colonial_empire

// Create war variable

generate byte wara=1 if year >=1733 & year <=1738 
generate byte warb=1 if year >=1740 & year <=1744
generate byte war1=1 if year >=1744 & year <=1748
generate byte war2=1 if year >=1756 & year <=1763
generate byte war3=1 if year >=1778 & year <=1783
generate byte war4=1 if year >=1793 & year <=1802
generate byte war5=1 if year >=1803 & year <=1807
generate blockade=1 if year >=1807 & year <=1815

gen war_all = max(wara, warb, war1, war2, war3, war4, war5, blockade)
gen war= max(war1, war2, war3, war4, war5, blockade)

// Create major battle variable
gen byte battle = .
replace battle = 1 if inlist(year, 1739)
replace battle = 2 if inlist(year, 1746)
replace battle = 3 if inlist(year, 1747)
replace battle = 4 if inlist(year, 1758)
replace battle = 5 if inlist(year, 1760)
replace battle = 6 if inlist(year, 1761)
replace battle = 7 if inlist(year, 1762)
replace battle = 8 if inlist(year, 1793)
replace battle = 9 if inlist(year, 1794)
replace battle = 10 if inlist(year, 1797)
replace battle = 11 if inlist(year, 1798)
replace battle = 12 if inlist(year, 1804)
replace battle = 13 if inlist(year, 1806)
replace battle = 14 if inlist(year, 1808)
replace battle = 15 if inlist(year, 1809)
replace battle = 16 if inlist(year, 1821)

gen battle_dummy = 1 if battle !=.
replace battle_dummy = 0 if battle ==.

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
gen priv_prizes_share_All = num_prizes_priv_All/num_prizes_All
gen num_prizes_RN_All = num_prizes_All-num_prizes_priv_All
gen num_prizes_RN_FR = num_prizes_FR-num_prizes_priv_FR




foreach var in num_prizes_All num_prizes_RN_All num_prizes_priv_All num_prizes_FR num_prizes_RN_FR num_prizes_priv_FR {
    replace `var'=0 if `var'==.
    foreach year of numlist 1740(1)1815 {
        levelsof `var' if year == `year', local(blif) clean
        gen cum_`var'_`year' = `blif'*max(0,(1- 0.05*(year-`year'))) if year>=`year'
    }
    egen cum_`var' = rowtotal(cum_`var'_*)
    drop cum_`var'_*
}

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

twoway (line cum_num_prizes_All year) (line cum_num_prizes_RN_All year) (line cum_num_prizes_priv_All year) /*
    */ (line cum_num_prizes_FR year) (line cum_num_prizes_RN_FR year) (line cum_num_prizes_priv_FR year), scheme(stsj)

twoway (line cum_num_prizes_All year) (line cum_num_prizes_FR year), scheme(stsj)


blif



regress loss cum_num_prizes_RN cum_num_prizes_priv if war==1
regress loss cum_num_prizes_RN cum_num_prizes_priv

regress loss num_prizes_RN cum_num_prizes_RN num_prizes_priv cum_num_prizes_priv if war==1
regress loss num_prizes_RN cum_num_prizes_RN num_prizes_priv cum_num_prizes_priv

**All this suggests that num_prizes_RN explains better that num_prizes_priv, but I am not sure we can make much of that. It is very much a time trend.
**Certainly, and that is interesting, the cumulated measure is much better than the single shock measure. 

regress loss num_prizes_All cum_num_prizes_All num_prizes_FR cum_num_prizes_FR if war==1 & year >=1740
regress loss num_prizes_All cum_num_prizes_All num_prizes_FR cum_num_prizes_FR if year >=1740
**En temps de guerre, les pertes (cumulées) françaises sont plus importantes que les pertes totales
**Sur l’ensemble des périodes, c’est l’inverse.


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

gen running_battle = 0
local runningbattle =0
local n = _N
foreach i of numlist 1(1)`n' {
    local runningbattle = battle_dummy[`i']+`runningbattle'*0.75
    replace running_battle = `runningbattle' in `i'
}

regress loss battle_dummy running_battle ln_year if war == 1
regress loss battle_dummy running_battle ln_year


**What about integration issues ?



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
