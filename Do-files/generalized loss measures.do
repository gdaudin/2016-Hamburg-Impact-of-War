


if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}



set more off




capture program drop loss_function
program loss_function
args  interet inorout outremer country_of_interest

*Exemple : loss_function  Blockade Exports 1 all
*Exemple : loss_function Blockade  XI 1 Allemagne

clear

 local explained_variable "lnvalue" 


use "$hamburg/database_dta/Best guess FR bilateral trade.dta", clear

drop if pays_grouping=="Inconnu" | pays_grouping=="Divers" | pays_grouping=="France"

collapse (sum) valueFR_silver, by(year exportsimports pays_grouping)
rename valueFR_silver value


encode pays_grouping, gen(pays)

merge m:1 pays_grouping year using "$hamburg/database_dta/WarAndPeace.dta"
drop if _merge==2
drop _merge




**Pour les périodes de paix

*replace war_status = "Peace" if war_status==""

if `outremer'==0 drop if pays_grouping=="Outre-mers"


if "`inorout'"=="XI" {
	order exportsimports value
	collapse (sum) value, by(year pays_grouping pays war_status)
	gen exportsimports="XI"
}



keep if exportsimports=="`inorout'"



gen period_str=""

replace period_str ="Peace 1716-1744" if year <= 1744
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
keep if year >= 1716

gen war = 1
replace war = 0 if year <= 1744 | (year >= 1749 & year <=1755) | (year >= 1763 & year <=1777) | (year >= 1784 & year <=1792) | year >=1816

local maxvalue 4.5

generate wara=`maxvalue' if year >=1733 & year <=1738 
generate warb=`maxvalue' if year >=1740 & year <=1744
generate war1=`maxvalue' if year >=1744 & year <=1748
generate war2=`maxvalue' if year >=1756 & year <=1763
generate war3=`maxvalue' if year >=1778 & year <=1783
generate war4=`maxvalue' if year >=1793 & year <=1802
generate war5=`maxvalue' if year >=1803 & year <=1815


*********Fin préparation des données



order value pays_grouping pays war_status
if "`country_of_interest'"=="all" {
	collapse (sum) value, by(year-war5)
	gen pays_grouping ="All"
}

if "`country_of_interest'"!="all" keep if ustrpos("`country_of_interest'",pays_grouping)!=0



gen ln_value=ln(value)
replace ln_value=ln(0.00000000000001) if value==0


reg ln_value year if year <= 1744 & war==0
predict ln_value_peace1
reg ln_value year if year <=1755 & war==0
predict ln_value_peace1_2
reg ln_value year if year <=1777  & war==0
predict ln_value_peace1_3
reg ln_value year if year <=1792  & war==0
predict ln_value_peace1_4
*reg ln_value year if war==0
*predict ln_value_peace_all


reg ln_value year if (year >= 1749 & year <=1755) & war==0
predict ln_value_peace2
reg ln_value year if (year >= 1763 & year <=1777) & war==0
predict ln_value_peace3
reg ln_value year if (year >= 1784 & year <=1792) & war==0
predict ln_value_peace4



*twoway (line ln_value_peace1 year) (line ln_value_peace1_2 year) (line ln_value_peace1_3 year) (line ln_value_peace1_4 year) (line ln_value_peace_all year) ///
*		(line ln_value year)
		
gen     loss_war = max(0,ln_value_peace1-ln_value) if year >=1745 & year <=1755
replace loss_war = max(0,ln_value_peace1_2-ln_value) if year >=1756 & year <=1777
replace loss_war = max(0,ln_value_peace1_3-ln_value) if year >=1778 & year <=1792
replace loss_war = max(0,ln_value_peace1_4-ln_value) if year >=1793
replace loss_war=. if ln_value==.


gen     loss_war_nomemory = max(0,ln_value_peace1-ln_value) if year >=1745 & year <=1755
replace loss_war_nomemory = max(0,ln_value_peace2-ln_value) if year >=1756 & year <=1777
replace loss_war_nomemory = max(0,ln_value_peace3-ln_value) if year >=1778 & year <=1792
replace loss_war_nomemory = max(0,ln_value_peace4-ln_value) if year >=1793
replace loss_war_nomemory =. if ln_value==.


replace war1=6 if war1!=.
replace war2=6 if war2!=.
replace war3=6 if war3!=.
replace war4=6 if war4!=.
replace war5=6 if war5!=.
keep if year >=1740

graph twoway (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4)) ///
			 (connected loss_war year, cmissing(n) lcolor(black) mcolor(black) msize(vsmall)) ///
			 (connected loss_war_nomemory year, cmissing(n) lcolor(red) mcolor(red) msize(vsmall)) ///
			 , ///
			 legend(order (6 7) label(6 "Difference with all past peace periods trend") label(7 "Difference with preceeding peace period trend") rows(2)) ///
			 ytitle("Log")
			 
			 
egen loss_war1=mean(loss_war) if year >=1745 & year <=1748
egen loss_peace1=mean(loss_war) if year >=1749 & year <=1755
egen loss_war2=mean(loss_war) if year >=1756 & year <=1762
egen loss_peace2=mean(loss_war) if year >=1763 & year <=1777
egen loss_war3=mean(loss_war) if year >=1778 & year <=1783
egen loss_peace3=mean(loss_war) if year >=1784 & year <=1792
egen loss_war4=mean(loss_war) if year >=1793 & year <=1815
egen loss_peace4=mean(loss_war) if year >=1816

egen loss = rmax(loss_war1 loss_war2 loss_war3 loss_war4 loss_peace1 loss_peace2 loss_peace3 loss_peace4)

graph twoway (area loss year)

egen loss_war_nomemory1=mean(loss_war_nomemory) if year >=1745 & year <=1748
egen loss_peace_nomemory1=mean(loss_war_nomemory) if year >=1749 & year <=1755
egen loss_war_nomemory2=mean(loss_war_nomemory) if year >=1756 & year <=1762
egen loss_peace_nomemory2=mean(loss_war_nomemory) if year >=1763 & year <=1777
egen loss_war_nomemory3=mean(loss_war_nomemory) if year >=1778 & year <=1783
egen loss_peace_nomemory3=mean(loss_war_nomemory) if year >=1784 & year <=1792
egen loss_war_nomemory4=mean(loss_war_nomemory) if year >=1793 & year <=1815
egen loss_peace_nomemory4=mean(loss_war_nomemory) if year >=1816

egen loss_nomemory = rmax(loss_war_nomemory1 loss_war_nomemory2 loss_war_nomemory3 loss_war_nomemory4 loss_peace_nomemory1 loss_peace_nomemory2 loss_peace_nomemory3 loss_peace_nomemory4)

graph twoway (area loss_nomemory year)

graph twoway (line loss year) (line loss_nomemory year)






end

*loss_function R&N Imports 1 "Flandre et autres états de l'Empereur"



local i 0

set graphic off



foreach breakofinterest in R&N Blockade {
	foreach inoroutofinterest in Imports Exports XI {
		foreach outremerofinterest in 0 1 {
			loss_function `breakofinterest' `inoroutofinterest' `outremerofinterest' all
			collapse (mean) loss, by(pays_grouping period_str period exportsimports) 
			gen outremer = `outremerofinterest'
			gen breakofinterest = "`breakofinterest'"
			if `i'!= 0 {
				append using "$hamburggit/Results/Loss measure.dta"
				
			}
			save "$hamburggit/Results/Loss measure.dta", replace
			local i 1
		}
	}
}


use "$hamburg/database_dta/Best guess FR bilateral trade.dta", clear

foreach breakofinterest in R&N Blockade {
	foreach inoroutofinterest in Imports Exports XI {
		foreach countryofinterest in "Flandre et autres états de l'Empereur" Allemagne Angleterre Espagne  ///
			"Hollande" "Italie" "Levant et Barbarie" "Nord" "Outre-mers" "Portugal" ///
			"Suisse"  {
			display "`breakofinterest' `inoroutofinterest' 1 `countryofinterest'"
			loss_function `breakofinterest' `inoroutofinterest' 1 `"`countryofinterest'"'
			collapse (mean) loss, by(pays_grouping period_str period exportsimports war_status) 
			gen breakofinterest = "`breakofinterest'"
			append using "$hamburggit/Results/Loss measure.dta"
			save "$hamburggit/Results/Loss measure.dta", replace
		}
	}
}

set graphic on

/*
				

loss_function R&N XI 1 all
collapse (mean) loss,by(pays_grouping period_str exportsimports) 
save "$hamburggit/Results/Loss measure.dta", replace

loss_function R&N XI 0 all
collapse (mean) loss,by(pays_grouping period_str exportsimports) 
gen outremer = 0
append using "$hamburggit/Results/Loss measure.dta"
save "$hamburggit/Results/Loss measure.dta", replace





/*

foreach countryofinterest in Allemagne Angleterre Espagne "Flandre et autres états de l'Empereur" ///
			"Hollande" "Italie" "Levant et Barbarie" "Nord" "Outre-mers" "Portugal" ///
			"Suisse" "États-Unis d'Amérique" {
			loss_function R&N XI 1 `countryofinterest'
			collapse (mean) loss,by(pays_grouping period_str exportsimports war_status)
			generate break_of_interest ="`interet'"

		}





