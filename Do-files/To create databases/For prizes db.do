
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



insheet using "$hamburggit/External Data/PrizeNationalities.csv", case clear


save "$hamburg/database_dta/PrizeNationalities.dta",  replace


insheet using "$hamburggit/External Data/HCA34_prizes.csv", case clear

rename yearofsentence year

merge m:1 Prizeshiporigin using "$hamburg/database_dta/PrizeNationalities.dta"
rename AggregatedOrigin AggregatedOrigin_source

replace Prizeshiporigin= OriginbasedonName if OriginbasedonName !=""
drop _merge 

merge m:1 Prizeshiporigin using "$hamburg/database_dta/PrizeNationalities.dta"
rename AggregatedOrigin AggregatedOrigin_hypothesis
drop Prizeshiporigin

/*
preserve
bysort Prizeshiporigin : egen Nbrbis=_N
replace Nbr =Nbrbis
drop Nbrbis 
bys Prizeshiporigin : keep if _n==1
keep Prizeshiporigin Nbr AggregatedOrigin
gsort - Nbr
outsheet "$hamburggit/External Data/PrizeNationalities.csv", replace
restore
*/
drop Nbr _merge

save "$hamburg/database_dta/HCA34_prizes.dta",  replace

histogram year, discrete name(HCA34_prizes, replace)

keep year AggregatedOrigin_source AggregatedOrigin_hypothesis

gen source ="HCA34_w_duplicates"

save "$hamburg/database_dta/English_prizes_list.dta",  replace


use "$hamburg/database_dta/HCA34_prizes.dta",  clear


replace Prizeshipmaster= Prizeshipmasternormalized if Prizeshipmasternormalized !=""
replace Prizeshipname= Prizeshipnamenormalized if Prizeshipnamenormalized !=""

sort year
bys Prizeshipname Prizeshipmaster: keep if _n==1


keep year AggregatedOrigin*
gen source="HCA34_wo_duplicates"

histogram year, discrete name(English_prizes, replace)

append using "$hamburg/database_dta/English_prizes_list.dta"

save "$hamburg/database_dta/English_prizes_list.dta",  replace

tab AggregatedOrigin_source if AggregatedOrigin_source!="Unknown"
tab AggregatedOrigin_hypothesis if AggregatedOrigin_hypothesis!="Unknown"



**************************

insheet using "$hamburggit/External Data/GBNavy_prizes.csv", case clear

gen year=real(substr(YeartoNavy,1,4))



save "$hamburg/database_dta/GBNavy_prizes.dta",  replace


histogram year, discrete name(GBNavy_prizes, replace)

keep if HowtoNavy=="Taken"

histogram year, discrete freq name(GBNavy_prizes_Taken, replace)

keep year
gen source ="GBNavy"
append using "$hamburg/database_dta/English_prizes_list.dta"
save "$hamburg/database_dta/English_prizes_list.dta",  replace


**************************


insheet using "$hamburggit/External Data/Other_prizes.csv", case clear
rename Year year
**Drop the British ships taken by the yankee or the French and the early ones

drop if Shiporigin=="britain" | Shiporigin=="liverpool" | year <=1738

histogram year, discrete freq name(Other_prizes, replace)

save "$hamburg/database_dta/Other_prizes.dta",  replace

keep year
keep if year >=1650
generate source="Other"
append using "$hamburg/database_dta/English_prizes_list.dta"
save "$hamburg/database_dta/English_prizes_list.dta",  replace

histogram year, discrete freq name(All_prizes, replace)


****************

insheet using "$hamburggit/External Data/Ashton_Schumpeter_Prize_data.csv", case clear
drop v3
generate source="Prize_imports"
twoway (bar importofprizegoodspoundsterling year), name(Prize_imports, replace)
save "$hamburg/database_dta/Ashton_Schumpeter_Prize_data.dta",  replace


*******************
insheet using "$hamburggit/External Data/Starkey -- Nbr of prizes -- 1990.csv", case clear
rename Year year
rename Privateers Starkey_captor_Privateers
rename Navy Starkey_captor_Navy

twoway (connected Starkey_captor_Privateers year, cmissing(n)) (connected Starkey_captor_Navy year, cmissing(n)), name(Starkey, replace)
save "$hamburg/database_dta/Starkey -- Nbr of prizes -- 1990.dta",  replace



***********************

use "$hamburg/database_dta/English_prizes_list.dta",  clear



bys year source AggregatedOrigin_hypothesis : generate Nbr_ = _N 
bys year source AggregatedOrigin_hypothesis : keep if _n==1
drop AggregatedOrigin_source

replace AggregatedOrigin_hypothesis = "US" if AggregatedOrigin_hypothesis=="United States"
replace AggregatedOrigin_hypothesis = "Neth" if AggregatedOrigin_hypothesis=="Netherlands"

replace source= source+"_"+AggregatedOrigin_hypothesis if source !="GBNavy" & source !="Other"
drop AggregatedOrigin_hypothesis
list if year==11

reshape wide Nbr_,i(year) j(source ) string
replace Nbr_Other = 0 if Nbr_Other==. & (year  ==1742 | year==1760 | year==1761 | year == 1782 | year==1814)

merge 1:1 year using "$hamburg/database_dta/Ashton_Schumpeter_Prize_data.dta"
drop source _merge

merge 1:1 year using "$hamburg/database_dta/Starkey -- Nbr of prizes -- 1990.dta"
drop _merge

merge 1:1 year using "$hamburg/database_dta/ST_silver.dta", keep(3)
drop _merge

gen importofprizegoodssilvertons=importofprizegoodspoundsterling*1000*ST_silver/1000000

merge 1:1 year using "$hamburg/database_dta/Total silver trade FR GB.dta"
drop _merge

gen share_prizes= importofprizegoodssilvertons/valueFR_silver
replace share_prizes = 0 if share_prizes ==.
replace share_prizes = . if valueFR_silver ==.

replace Nbr_HCA34_wo_duplicates_France = 0 if Nbr_HCA34_wo_duplicates_France ==.
replace Nbr_HCA34_wo_duplicates_Neth = 0 if Nbr_HCA34_wo_duplicates_Neth ==.
replace Nbr_HCA34_wo_duplicates_Other = 0 if Nbr_HCA34_wo_duplicates_Other ==.
replace Nbr_HCA34_wo_duplicates_Spain = 0 if Nbr_HCA34_wo_duplicates_Spain ==.
replace Nbr_HCA34_wo_duplicates_US = 0 if Nbr_HCA34_wo_duplicates_US ==.
replace Nbr_HCA34_wo_duplicates_Unknown = 0 if Nbr_HCA34_wo_duplicates_Unknown ==.

sort year 
twoway (line share_prizes year), name(Share_prizes, replace)

sort year

gen Nbr_HCA34_wod = Nbr_HCA34_wo_duplicates_France+ Nbr_HCA34_wo_duplicates_Neth+ Nbr_HCA34_wo_duplicates_Other+ Nbr_HCA34_wo_duplicates_Spain+ Nbr_HCA34_wo_duplicates_US+ Nbr_HCA34_wo_duplicates_Unknown 
replace Nbr_HCA34_wod=. if Nbr_HCA34_wod==0



save "$hamburg/database_dta/English_prizes.dta",  replace

graph twoway (connected Nbr_GBNavy year, cmissing(n)) (connected Starkey_captor_Navy year, cmissing(n)), /*
	*/ legend(order (1 "Number of Navy prizes included in the fleet " 2 "Number of Navy prizes")) /*
	*/ name(Comp_Navy_prizes_and_Starkey, replace)
	
	
graph twoway (connected Nbr_HCA34_wod year, cmissing(n)) (connected Starkey_captor_Privateers year, cmissing(n)) /*
	*/ if year >=1735 & year <=1790 , /*
	*/ legend(rows(2) order (1 "Number of prizes in the HCA34 (without duplicates)" 2 "Number of Privateers prizes (Starkey)")) /*
	*/ name(Comp_HCA34_prizes_and_Starkey, replace)
	
graph twoway (connected Nbr_HCA34_wod year, cmissing(n)) (connected Nbr_Other year, cmissing(n)) if year >= 1739 & year<=1816, /*
	*/ legend(rows(2) order (1 "Number of prize ships reports in the High Court of Admiralty (HCA34)" "(no duplicates)" 2 "Number of prizes (other sources)")) /*
	*/ name(Comp_HCA34_Other, replace)
	
replace Nbr_HCA34_wod = 0 if Nbr_HCA34_wod ==.

generate Nbr_HCA34_and_other = 	Nbr_HCA34_wod + Nbr_Other if year >= 1739
generate Nbr_HCA34_and_other_FR = 	Nbr_HCA34_wo_duplicates_France + Nbr_Other if year >= 1739

graph twoway (connected Nbr_HCA34_and_other year, cmissing(n)) (connected Nbr_HCA34_and_other_FR year, cmissing(n)) if year >= 1739 & year<=1816, /*
	*/ legend( rows(2) order (1 "Number of prize ships reports in the High Court of Admiralty (HCA34)" "(no duplicates) + Number of prizes (other sources)" 2 "Number of French prize ships reports in the High Court of Admiralty" " (HCA34) (no duplicates) + Number of prizes (other sources)")) /*
	*/ scheme(s1mono) name(HCA34_and_Other, replace)	
	

 twoway (connected share_prizes year,cmissing(n) msize(small)) (connected Nbr_HCA34_wod year,cmissing(n) yaxis(2) msize(small)) (connected Nbr_HCA34_wo_duplicates_France year,cmissing(n) yaxis(2) msize(small)) if year >=1739 & year <=1815, /*
	*/ legend(rows(3) order (1 "Official value of prize goods imported in Britain as a share of French trade" /*
	*/2 "Number of prize ships reports in the High Court of Admiralty (HCA34) (no duplicates)" 3 "idem, but only French ships") size(vsmall)) /*
	*/ytitle(share of French trade) ytitle(number of ships, axis(2)) /*
	*/ scheme(s1mono) name(HCA34_and_imports, replace)
	

save "$hamburg/database_dta/English_prizes.dta",  replace



*=Sur le graphique, on veut : total number of prizes (including RN and privateers) ; total estimated number of French prizes ; total number of privateer prizes ; total number of French privateer prizes

gen total_number_of_prizes = Nbr_HCA34_and_other + Starkey_captor_Navy if year > 1735 & year <= 1790 
gen estimated_number_of_prizes_FR = (Nbr_HCA34_and_other + Starkey_captor_Navy)*Nbr_HCA34_and_other_FR/Nbr_HCA34_and_other if year > 1735 & year <= 1790



 twoway (connected  estimated_number_of_prizes_FR year,cmissing(n)  msize(small) lpattern(solid) msymbol(circle)) /*
    */  (connected total_number_of_prizes year,cmissing(n) msize(small) lpattern(dot) msymbol(circle)) /*
	*/  (connected Nbr_HCA34_and_other_FR year,cmissing(n)  msize(small) lpattern(solid) msymbol(square)) /*
	*/  (connected Nbr_HCA34_and_other year,cmissing(n)  msize(small) lpattern(dot) msymbol(square)) /*
	*/  if year >=1739 & year <=1815, /*
	*/  legend(rows(4) order (2 "Total number of prizes" /*
	*/  1  "Estimated total number of French prizes" 4 "Total number of prizes captured by privateers" /*
	*/  3 "Total number of French prizes captured by privateers") size(vsmall)) /*
	*/  ytitle(number of ships) /*
	*/  name(for_paper, replace) /*
	*/ scheme(s1mono)


*****DEAL WITH NATIONALITY OF OTHERS


erase "$hamburg/database_dta/HCA34_prizes.dta"
erase "$hamburg/database_dta/GBNavy_prizes.dta"
erase "$hamburg/database_dta/Other_prizes.dta"
erase "$hamburg/database_dta/Ashton_Schumpeter_Prize_data.dta"
erase "$hamburg/database_dta/PrizeNationalities.dta"
erase "$hamburg/database_dta/Starkey -- Nbr of prizes -- 1990.dta"


/*
	
graph export "$hamburggit/Paper - Impact of War/Paper/Prizes.png", replace	

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

	

