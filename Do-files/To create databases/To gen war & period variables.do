version 18
clear all


if "`c(username)'" =="guillaumedaudin" {
	global path "~/Documents/Recherche/2016 Hambourg et Guerre"
	global git_path "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

set obs 152
gen year = _n + 1687

gen period_str=""
replace period_str ="War 1688-1697" if year >= 1688 & year <= 1697
replace period_str ="Peace 1698-1701" if year >= 1698 & year <= 1701
replace period_str ="War 1702-1713" if year >= 1702 & year <= 1713
replace period_str ="Peace 1716-1744" if year >= 1716 & year <= 1744
replace period_str ="War 1745-1748" if year   >= 1745 & year <=1748
replace period_str ="Peace 1749-1755" if year >= 1749 & year <=1755
replace period_str ="War 1756-1763" if year   >= 1756 & year <=1763
replace period_str ="Peace 1763-1777" if year >= 1763 & year <=1777
replace period_str ="War 1778-1783" if year   >= 1778 & year <=1783
replace period_str ="Peace 1784-1792" if year >= 1784 & year <=1792
replace period_str ="War 1793-1807" if year   >= 1793 & year <=1807
replace period_str ="Blockade 1808-1815" if year   >= 1808 & year <=1815
replace period_str ="Peace 1816-1840" if year >= 1816

encode period_str, gen(period)


gen war = 1
replace war = 0 if year <= 1744 | (year >= 1749 & year <=1755) | (year >= 1763 & year <=1777) | (year >= 1784 & year <=1792) | year >=1816

generate warla=1 if year >=1688 & year <=1697 
generate warsp=1 if year >=1702 & year <=1713 
generate wara=1 if year >=1733 & year <=1738 
generate warb=1 if year >=1740 & year <=1744
generate war1=1 if year >=1744 & year <=1748
generate war2=1 if year >=1756 & year <=1763
generate war3=1 if year >=1778 & year <=1783
generate war4=1 if year >=1793 & year <=1802
generate war5=1 if year >=1803 & year <=1807
generate blockade=1 if year >=1807 & year <=1815


gen minwarla=0 if warla!=.
gen minwarsp=0 if warsp!=.
gen minwara=0 if wara!=.
gen minwarb=0 if warb!=.
gen minwar1=0 if war1!=.
gen minwar2=0 if war2!=.
gen minwar3=0 if war3!=.
gen minwar4=0 if war4!=.
gen minwar5=0 if war5!=.
gen minblockade=-0.2 if blockade!=.


save "$path/database_dta/Wars_and_Periods.dta", replace