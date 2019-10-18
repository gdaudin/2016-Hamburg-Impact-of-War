
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

else if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE\Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


else if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}

insheet using "$hamburggit/External Data/HCA34_prizes.csv", case clear

save "$hamburg/database_dta/HCA34_prizes.dta",  replace

histogram yearofsentence, discrete

keep yearofsentence
rename yearofsentence year
gen source ="HCA34"

save "$hamburg/database_dta/English_prizes.dta",  replace

**************************

insheet using "$hamburggit/External Data/GBNavy_prizes.csv", case clear

gen year=real(substr(YeartoNavy,1,4))



save "$hamburg/database_dta/GBNavy_prizes.dta",  replace


histogram year, discrete

keep if HowtoNavy=="Taken"

histogram year, discrete freq

keep year
gen source ="GBNavy"
append using "$hamburg/database_dta/English_prizes.dta"
save "$hamburg/database_dta/English_prizes.dta",  replace


**************************


insheet using "$hamburggit/External Data/Other_prizes.csv", case clear
rename Year year
histogram year, discrete freq

save "$hamburg/database_dta/Other_prizes.dta",  replace

keep year
keep if year >=1650
generate source="Other"
append using "$hamburg/database_dta/English_prizes.dta"
save "$hamburg/database_dta/English_prizes.dta",  replace

histogram year, discrete freq


****************

insheet using "$hamburggit/External Data/Ashton_Schumpeter_Prize_data.csv", case clear
drop v3
generate source="Prize_imports"
save "$hamburg/database_dta/Ashton_Schumpeter_Prize_data.dta",  replace


***********************

use "$hamburg/database_dta/English_prizes.dta",  clear

bys year source : generate Nbr_ = _N
bys year source : keep if _n==1

reshape wide Nbr_,i(year) j(source) string
merge 1:1 year using "$hamburg/database_dta/Ashton_Schumpeter_Prize_data.dta"
drop source _merge

merge 1:1 year using "$hamburg/database_dta/ST_silver.dta", keep(3)
drop _merge

gen importofprizegoodssilvertons=importofprizegoodspoundsterling*1000*ST_silver/1000000

merge 1:1 year using "$hamburg/database_dta/Total silver trade FR GB.dta"
drop _merge

gen share_prizes= importofprizegoodssilvertons/valueFR_silver
replace share_prizes = 0 if share_prizes ==.
replace share_prizes = . if valueFR_silver ==.
replace Nbr_HCA34 = 0 if Nbr_HCA34 ==.


twoway (line share_prizes year) 


 twoway (connected share_prizes year,cmissing(n) msize(small)) (connected Nbr_HCA34 year,cmissing(n) yaxis(2) msize(small)) if year >=1740 & year <=1815, /*
	*/ legend(rows(2) order (1 "Official value of prize goods imported in Britain as a share of French trade" 2 "Number of prize ships reports in the British Court of Admiralty (HCA34)") size(small)) /*
	*/ytitle(share of French trade) ytitle(number of ships, axis(2)) /*
	*/ scheme(s1mono)

graph export "$hamburggit/Paper - Impact of War/Paper/Prizes.pdf", replace	

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

	
save "$hamburg/database_dta/English_prizes.dta",  replace
