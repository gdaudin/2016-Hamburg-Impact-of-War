
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

import delimited "$hamburggit/External Data/Loss of colonies.csv", clear

replace france=0

replace france=1 if year>=1763 & year<=1810 & colonies=="Guadeloupe"
replace france=1 if year<1760 & colonies=="Guadeloupe"
replace france=1 if year>=1816 & colonies=="Guadeloupe"
replace france=1 if year<=1809 & colonies=="Guyana"
replace france=1 if year>=1817 & colonies=="Guyana"
replace france=1 if year<=1804 & colonies=="St. Domingue"
replace france=1 if colonies=="Martinique"
replace france=1 if colonies=="Maurice" & year>=1722 & year<=1810
replace france=1 if colonies=="Reunion" & year<=1810
replace france=1 if colonies=="Reunion" & year>=1815
replace france=1 if colonies=="Inde" & year<=1810
replace france=1 if colonies=="Inde" & year>=1815
replace france=1 if year>=1713 & year<=1793 & colonies=="Tobago"

*my own rule to determine when more or less production from Hait was lost
replace france=0 if  year>1792 & year<=1795 & colonies=="St. Domingue"
replace france=.5 if  year>1795 & year<=1804 & colonies=="St. Domingue"

gen source=""
replace source="Objet Général -- 1788 -- AN_F12_1835_100" if ///
	colonies=="St. Domingue" | ///
	colonies=="Martinique" | colonies=="Guadeloupe"
	
replace source = "Commerce avec les Indes - 1788- ANOM Col F 2B 13_2" ///
	if colonies=="Maurice" | colonies =="Reunion"
	
replace source="Objet Général -- 1788 -- AN_F12_1835_100" if missing(source)

gen weight=0
replace weight=0.75 if colonies=="St. Domingue"	
replace weight=0.11 if colonies=="Martinique"
replace weight=0.06 if colonies=="Guadeloupe"
replace weight=0.002 if colonies=="Guayana"
replace weight=0.015 if colonies=="Reunion"
replace weight=0.015 if colonies=="Maurice"
replace weight = 0.03 if colonies=="Inde"
replace weight = 0.02 if colonies=="Tobago"


gen weight_france=weight*france

collapse (sum) weight_france, by(year)

label var weight_france "Measure of colonial power"
label var year Year

preserve 

drop if year<1740

local maxvalue 1
generate warb=`maxvalue' if year >=1740 & year <=1744
generate war1=`maxvalue' if year >=1744 & year <=1748
generate war2=`maxvalue' if year >=1756 & year <=1763
generate war3=`maxvalue' if year >=1778 & year <=1783
generate war4=`maxvalue' if year >=1793 & year <=1802
generate war5=`maxvalue' if year >=1803 & year <=1815


graph twoway ///
			 (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs4)) ///
			 (area war5 year, color(gs4))  ///
			 (connected weight_france year if year>1739, ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 msize(vsmall) legend(order(7 "Measure of colonial empire")) ///
			 xlabel(1740(20)1820) xscale(ra(1740 1820)) )
			 
graph export "$hamburggit/Impact of War/Paper/colony_loss.png", as(png) replace

restore

save "$hamburggit/External Data/Colonies loss.dta", replace
