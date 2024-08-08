version 18
clear all


if "`c(username)'" =="guillaumedaudin" {
	global path "~/Documents/Recherche/2016 Hambourg et Guerre"
	global git_path "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

set obs 120
gen year = _n + 1719


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

gen running_battle = 0
local runningbattle =0
local n = _N
foreach i of numlist 1(1)`n' {
    local runningbattle = battle_dummy[`i']+`runningbattle'*0.75
    replace running_battle = `runningbattle' in `i'
}

save "$path/database_dta/Battles.dta", replace

twoway (line running_battle year), scheme(stsj)