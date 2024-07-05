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
keep year Number_of_prizes_Total_All Number_of_prizes_Privateers_All importofprizegoodspoundsterling
tempfile prizes
save `prizes'

import delimited using "`HamburgDir'database_csv/temp_for_hotelling.csv", clear

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
rename Number_of_prizes_Total_All num_prizes
rename Number_of_prizes_Privateers_All num_prizes_priv
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

// Apply function to all wartime strategies var of interest for only war years and no running sum
gen byte onlywar = 1
gen byte running_sum = 0
* Add the function call to `fwartime_corr_df' and its outputs, adapt them for Stata

// Prepare the table with the results
local outpath = "`HamburgPaperDir'`PaperDir'max_wartime_nosum_mreg.tex"

// Run the regression
if running_sum == 0 {
    regress loss num_prizes num_prizes_priv colonial_empire France_vs_GB ally_vs_foe allyandneutral_vs_foe battle_dummy if war == 1
    estimates store est_1
    
    esttab est_1 using `outpath', ///
        title("Single and multivariate regressions for war years only") ///
        keep(num_prizes num_prizes_priv colonial_empire France_vs_GB ally_vs_foe allyandneutral_vs_foe battle_dummy) ///
        label replace
}

clear all
```