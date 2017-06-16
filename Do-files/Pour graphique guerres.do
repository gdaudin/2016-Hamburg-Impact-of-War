 use "/Users/guillaumedaudin/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
 
keep if sourcetype == "Tableau Général" | sourcetype=="Résumé"
drop if sitc18_rev3=="9a"

collapse (sum) value, by (year)
generate log10_value = log10(value)

local maxvalue 9.4

generate war1=`maxvalue' if year >=1744 & year <=1748
generate war2=`maxvalue' if year >=1756 & year <=1763
generate war3=`maxvalue' if year >=1778 & year <=1783
generate war4=`maxvalue' if year >=1793 & year <=1815

graph twoway (area war1 year, color(gs12)) (area war2 year, color(gs12)) ///
 (area war3 year, color(gs12)) (area war4 year, color(gs12))  ///
 (connected log10_value year, msize(small)) (lfit log10_value year), ///
 legend(off) ytitle("Value of French trade in livres, log10") xtitle("Year: Anglo-French wars are shaded.")
 
 
 graph export "/Users/guillaumedaudin/Documents/Recherche/2016-Hamburg-Impact-of-War/tex/Total French trade and wars.png", replace



