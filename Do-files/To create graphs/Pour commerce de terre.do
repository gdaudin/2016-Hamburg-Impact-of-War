




if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\tirindee\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
}









use "/Users/guillaumedaudin/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta",  clear
keep if year==1792 & sourcetype=="Tableau Général" 
gen par_mer=1
replace par_mer=0 if strpos(pays,"par terre")!=0
collapse (sum) value, by(country_grouping par_mer)
reshape wide value,i(country_grouping) j(par_mer)
gen share_par_mer=0 if value0 !=. & value1==.
replace share_par_mer=1 if value1 !=. & value0==.
replace share_par_mer=value1/(value0+value1) if share_par_mer!=0 & share_par_mer!=1
drop value0 value1



merge 1:m country_grouping using "$hamburg/database_dta/Best guess FR bilateral trade.dta"
drop if country_grouping=="France" | country_grouping=="Inconnu"
assert _merge==3

gen value_sea=value*share_par_mer
gen value_land=value*(1-share_par_mer)

collapse (sum) value_sea value_land, by(year)

gen share_sea=value_sea/(value_sea+value_land)


local maxvalue 1

generate wara=`maxvalue' if year >=1733 & year <=1738 
generate warb=`maxvalue' if year >=1740 & year <=1744
generate war1=`maxvalue' if year >=1744 & year <=1748
generate war2=`maxvalue' if year >=1756 & year <=1763
generate war3=`maxvalue' if year >=1778 & year <=1783
generate war4=`maxvalue' if year >=1793 & year <=1802
generate war5=`maxvalue' if year >=1803 & year <=1807
generate blockade=`maxvalue' if year >=1807 & year <=1815

sort year

graph twoway (area wara year, color(gs14)) ///
			 (area warb year, color(gs14)) ///
			 (area war1 year, color(gs9)) (area war2 year, color(gs9)) ///
			 (area war3 year, color(gs9)) (area war4 year, color(gs9)) ///
			 (area war5 year, color(gs9)) (area blockade year, color(gs4)) ///
			 (connected share_sea year, lcolor(black) ///
			 msize(tiny) mcolor(black) ) ///
			,legend(off) ///
			 plotregion(fcolor(white)) graphregion(fcolor(white)) ///
			 ytitle("Imputed share of total trade")
		
		
		*note("Source: TOFLIT and 1792 data on the share of sea trade per country in AN F/12/1834 B")
		*	 title("Share of French trade conducted by sea") ///
			 
graph export "$hamburggit/Paper - Impact of War/Paper/Share_by_sea.png", as(png) replace			 
	

			 
