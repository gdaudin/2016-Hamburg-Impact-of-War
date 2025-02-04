version 18

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

else if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE\Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Volumes/GoogleDrive/My Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Desktop/HamburgPaper"
}




***********
*******************************
****************Prize import data

insheet using "$hamburggit/External Data/Ashton_Schumpeter_Prize_data.csv", case clear
drop v3
generate source="Prize_imports"
twoway (bar importofprizegoodspoundsterling year, cmissing(n)), name(Prize_imports, replace) scheme(stsj) ytitle("Imports of prize goods (£000)")
*save "$hamburg/database_dta/Ashton_Schumpeter_Prize_data.dta",  replace

merge 1:1 year using "$hamburg/database_dta/ST_silver.dta", keep(3)
drop _merge

gen importofprizegoodssilvertons=importofprizegoodspoundsterling*1000*ST_silver/1000000

merge 1:1 year using "$hamburg/database_dta/Total silver trade FR GB.dta", keepusing(valueFR_silver)
drop _merge


gen share_totFT_prize_imports= importofprizegoodssilvertons/valueFR_silver
replace share_totFT_prize_imports = 0 if share_totFT_prize_imports ==.
replace share_totFT_prize_imports = . if valueFR_silver ==.

sort year 

replace share_totFT_prize_imports = . if share_totFT_prize_imports ==0

export delimited "$hamburg/database_csv/prizes_imports.csv", replace
save "$hamburg/database_dta/Prizes_imports.dta",  replace


twoway (bar importofprizegoodspoundsterling year, cmissing(n)) (connected share_totFT_prize_imports year,yaxis(2) lpattern(solid) mcolor(black) cmissing(n))/*
		*/ if year>=1740 & year <=1801 /*
		*/, name(Prize_imports, replace) scheme(stsj) ytitle("Imports of prize goods (£000)") ytitle("Share of French trade", axis(2)) /*
		*/ legend(order (1 "Absolute value" 2 "Share of French trade"))  
		
graph export "$hamburggit/Paper - Impact of War/Paper/Prizes_imports.png", replace



*****************************
** Now for prizes (ships and values) rather than imports



insheet using "$hamburggit/External Data/PrizeNationalities.csv", case clear
// This comes from the following file («Data for Guillaume.xlsx», using the first two sheets): I have done the "AggregatedOrigin" column by myself (GD)
// It is a correspondence table to unify the nationalities of the prizes


save "$hamburg/database_dta/PrizeNationalities.dta",  replace


insheet using "$hamburggit/External Data/HCA34_prizes.csv", case clear // This comes from an xlsx file send by Hillmann on July 31st 2019 «Data for Guillaume.xlsx»
//I had to do some adjustement for Le Pierre Andre (1744) because of wandering semicolon.

rename yearofsentence year

replace year=1748 if year==1750
replace year=1762 if year==1763
replace year=1783 if inlist(year,1784,1785,1786,1787)
///I associate post-war prizes with the preceeding war (1 case 1750, 8 cases 1763, 35 cases in 1784, 5 cases if 1786 and 2 cases in 1787) on the last year of the war


drop if year==.



merge m:1 Prizeshiporigin using "$hamburg/database_dta/PrizeNationalities.dta", keep(1 3)
rename AggregatedOrigin AggregatedOrigin_source
drop _merge 

replace Prizeshiporigin= OriginbasedonName if OriginbasedonName !="" & Prizeshiporigin=="" // I have worked this OriginbasedonName by myself (GD)


merge m:1 Prizeshiporigin using "$hamburg/database_dta/PrizeNationalities.dta", keep(1 3)
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
capture drop Nbr
capture _merge

save "$hamburg/database_dta/HCA34_prizes.dta",  replace

histogram year, discrete name(HCA34_prizes, replace)

keep year AggregatedOrigin_source AggregatedOrigin_hypothesis

gen source ="HCA34_w_duplicates"

/// Now we drop duplicates

save "$hamburg/database_dta/English_prizes_list.dta",  replace


use "$hamburg/database_dta/HCA34_prizes.dta",  clear


replace Prizeshipmaster= Prizeshipmasternormalized if Prizeshipmasternormalized !=""
replace Prizeshipname= Prizeshipnamenormalized if Prizeshipnamenormalized !=""


sort year
bys Prizeshipname Prizeshipmaster: keep if _n==1
///456 drops out of 2586

keep year AggregatedOrigin*
gen source="HCA34_wo_duplicates"

histogram year, discrete name(English_prizes, replace)

append using "$hamburg/database_dta/English_prizes_list.dta"

save "$hamburg/database_dta/English_prizes_list.dta",  replace

tab AggregatedOrigin_source if AggregatedOrigin_source!="Unknown"
tab AggregatedOrigin_hypothesis if AggregatedOrigin_hypothesis!="Unknown"

**************************


insheet using "$hamburggit/External Data/Other_prizes.csv", case clear // This comes from an xlsx file send by Hillmann on July 31st 2019 «Data for Guillaume.xlsx
rename Year year
**Drop the British ships taken by the yankee or the French and the early ones
**As the big work done by Hillmann et Gathmann on HC34 only covers 1740-1809 (not a big deal for the latter years as private prizes become small)
**For earlier years, their data (Other_prizes) is very incomplete. We will not try to do the Nine Years War and use Starkey’s for the War of Spanish Succession

drop if Shiporigin=="britain" | Shiporigin=="liverpool" | year <=1688

histogram year, discrete freq name(Other_prizes, replace)

rename Shiporigin Prizeshiporigin


merge m:1 Prizeshiporigin using "$hamburg/database_dta/PrizeNationalities.dta", keep (1 3)
rename AggregatedOrigin AggregatedOrigin_hypothesis

drop _merge


keep year AggregatedOrigin*
keep if year >=1689
generate source="Other"
assert year !=.
append using "$hamburg/database_dta/English_prizes_list.dta"
assert year !=.
save "$hamburg/database_dta/English_prizes_list.dta",  replace

histogram year, discrete freq name(All_prizes, replace)


*******
*To the Navy

**************************

insheet using "$hamburggit/External Data/GBNavy_prizes.csv", case clear // This comes from an xlsx file send by Hillmann on July 31st 2019 «Data for Guillaume.xlsx»
///Ultimate source : David Lyon. Sailing Navy List: All the Ships of the Royal Navy - Built, Purchased and Captured, 1688-1860. Conway Maritime Press, 1993. ISBN 0-85177-617-5.

gen year=real(substr(YeartoNavy,1,4))

drop if year==.


//According to https://en.wikipedia.org/wiki/Rating_system_of_the_Royal_Navyhttps://en.wikipedia.org/wiki/Rating_system_of_the_Royal_Navy, we assume
///that rated ships + everything including "sloop" are combattant ships, and the rest former civilian vessels. 
gen warship=0
replace warship=1 if strmatch(Type,"*rate*")==1 | strmatch(Type,"*loop*")==1
***524 warships out of c.1,900 ships
//we do not keep the warships
keep if warship==0
drop warship

gen prize=0
replace prize=1 if HowtoNavy=="Taken"

preserve
collapse (sum) prize (count) Dummy_Prize, by(year)
///Dummy Prize is actually 1 for all observations. I am not sure why. I will use it for a total count of entry into the Navy
twoway (connected prize year) (connected Dummy_Prize year)
restore

keep if HowtoNavy=="Taken"

replace year=1697 if year == 1701
//To replace by actual war years
//The rest (including 1755) seems plausible
keep year

gen source ="GBNavy_Lyon"
append using "$hamburg/database_dta/English_prizes_list.dta"
save "$hamburg/database_dta/English_prizes_list.dta",  replace

*******************
insheet using "$hamburggit/External Data/Starkey -- Nbr of prizes -- 1990.csv", case clear // From Starkey

///Hillmann & Gathmann, 1990, note 73, p. 757 : Unfortunately, we cannot compare the number of prizes captured by the Royal Navy and privateers consistently 
/// over time. The number of prizes taken by British privateers in the 1689–1815 period is consistently recorded in PRO, HCA 30 
/// (from lists prepared for the Customs Commissioners) and HCA 34 (from the Admiralty Court prize sentences). 
/// However, no directly comparable data exist for the Royal Navy over the same period. 
/// Starkey, British Privateering, reports the number of prizes seized by the Royal Navy for the period 1702–1785. 
/// Hill, Prizes of War, reconstructed the number of navy prizes between 1793 and 1815 using the HCA 2/300 series. 
/// Yet, his source appears to include all prize actions of Royal Navy warships, including prizes condemned in colonial courts or captured warships 
/// that are not included in the other records.

rename Year year
rename Privateers Starkey_prizes_Privateers
rename Navy Starkey_prizes_Navy

**This is to allocate the prizes to actual war years
generate year_new=year
replace year_new=1713 if year==1714
replace year_new=1748 if inlist(year,1749, 1750, 1751)
replace year_new=1762 if inlist(year,1763)
replace year_new=1783 if inlist(year,1784,1785)
///I associate post-war prizes with the preceeding war -- As with the data presented before

collapse (sum) Starkey_prizes_Privateers Starkey_prizes_Navy, by(year_new)
rename year_new year
drop if Starkey_prizes_Privateers==0 & Starkey_prizes_Navy==0




twoway (connected Starkey_prizes_Privateers year, cmissing(n)) (connected Starkey_prizes_Navy year, cmissing(n)), name(Starkey, replace)
save "$hamburg/database_dta/Starkey -- Nbr of prizes -- 1990.dta",  replace



***********************
insheet using "$hamburggit/External Data/Benjamin RN prizes.csv", case clear
drop share
rename number Benjamin_prizes_Navy

twoway (connected Benjamin_prizes_Navy year, cmissing(n)), name(Benjamin_prizes_Navy, replace)
save "$hamburg/database_dta/Benjamin_prizes_Navy.dta",  replace

****************
**End of primary sources
***********************

use "$hamburg/database_dta/English_prizes_list.dta",  clear

keep if year >=1702

assert year !=.

drop if AggregatedOrigin_hypothesis == "Britain"

drop AggregatedOrigin_source
bys year source AggregatedOrigin_hypothesis : generate Nbr_ = _N 
bys year source AggregatedOrigin_hypothesis : keep if _n==1


replace AggregatedOrigin_hypothesis = "US" if AggregatedOrigin_hypothesis=="United States"
replace AggregatedOrigin_hypothesis = "Neth" if AggregatedOrigin_hypothesis=="Netherlands"

replace source= source+"_"+AggregatedOrigin_hypothesis if source !="GBNavy_Lyon"
 

drop AggregatedOrigin_hypothesis

tab source

reshape wide Nbr_,i(year) j(source) string

save "$hamburg/database_dta/English_prizes.dta",  replace


*********************** Merging data files

merge 1:1 year using "$hamburg/database_dta/ST_silver.dta", keep(3)
drop _merge


merge 1:1 year using "$hamburg/database_dta/Total silver trade FR GB.dta", keepusing(valueFR_silver)
drop _merge

merge 1:1 year using "$hamburg/database_dta/Prizes_imports.dta"
drop _merge

save "$hamburg/database_dta/English_prizes.dta",  replace

******  Starkey and Benjamin to decide on a Navy prize series

use "$hamburg/database_dta/English_prizes.dta",  replace

merge 1:1 year using "$hamburg/database_dta/Starkey -- Nbr of prizes -- 1990.dta"
drop _merge

egen Nbr_Hillman=rsum(Nbr_HCA34_wo_duplicates_France-Nbr_Other_Unknown)
corr Starkey_prizes_Privateers Nbr_Hillman if year >=1739 & (Starkey_prizes_Privateers !=0 | Nbr_Hillman  !=0)



merge 1:1 year using "$hamburg/database_dta/Benjamin_prizes_Navy.dta"
drop _merge

**Checking the consistency of the different sources on Navy prizes
corr Starkey_prizes_Navy Nbr_GBNavy_Lyon if year >=1739 & (Starkey_prizes_Navy !=0 | Nbr_GBNavy_Lyon  !=0)
egen Tot_Starkey_Navy = total(Starkey_prizes_Navy) if  year <=1790
egen Tot_Lyon_Navy_FirstPeriod = total(Nbr_GBNavy_Lyon) if year <=1790

corr Benjamin_prizes_Navy Nbr_GBNavy_Lyon if year >=1739 & (Benjamin_prizes_Navy !=0 | Nbr_GBNavy_Lyon  !=0)
egen Tot_Benjamin_Navy = total(Benjamin_prizes_Navy) if year >=1793
egen Tot_Lyon_Navy_SecondPeriod = total(Nbr_GBNavy_Lyon) if year >=1793

***But actually, the number of prizes taken into the navy (Lyon’s numbers) seem to be only a small fraction of the total number of prizes (5.6 \% of Starkey’s and 4.8\% of Hill’s), and so we use Starkey’s and Hill’s numbers.
***To adjust Hill’s number, we assume the share of prizes taken into the navy is constant and multiply its numbers by 0.87 (= 0.048/0.056).

gen blif = 0.87*Benjamin_prizes_Navy
gen Nbr_prizes_GBNavy = Starkey_prizes_Navy if year <=1790
replace Nbr_prizes_GBNavy = blif if year >=1791
drop blif

corr Nbr_prizes_GBNavy Nbr_GBNavy_Lyon if year >=1739 & (Nbr_prizes_GBNavy !=0 | Nbr_GBNavy_Lyon  !=0)


graph twoway (connected Nbr_GBNavy_Lyon year, cmissing(n)) (connected Nbr_prizes_GBNavy year, cmissing(n)), /*
	*/ legend(order (1 "Number of Navy prizes included in the fleet " 2 "Number of Navy prizes")) /*
	*/ name(Comp_Navy_prizes_and_GBNavy, replace)


*****Some more comparisons on the number of privateer’s prizes



sort year

egen Nbr_HCA34_wod 	= rsum(Nbr_HCA34_wo_duplicates*), missing
egen Nbr_Other		= rsum(Nbr_Other*), missing
*replace Nbr_HCA34_wod=. if Nbr_HCA34_wod==0

recode Nbr* (miss=0 ) if year >=1689 & year <=1697
recode Nbr* (miss=0 ) if year >=1702 & year <=1713
recode Nbr* (miss=0 ) if year >=1739 & year <=1748
recode Nbr* (miss=0 ) if year >=1756 & year <=1762
recode Nbr* (miss=0 ) if year >=1777 & year <=1784
recode Nbr* (miss=0 ) if year >=1793 & year <=1815

/*
graph twoway (connected Nbr_HCA34_wod year, cmissing(n)) (connected Starkey_prizes_Privateers year, cmissing(n)) /*
	*/  , /*
	*/ legend(rows(2) order (1 "Number of prizes in the HCA34 (without duplicates)" 2 "Number of Privateers prizes (Starkey)")) /*
	*/ name(Comp_HCA34_prizes_and_Starkey, replace)
*/	
graph twoway (connected Nbr_HCA34_wod year, cmissing(n)) (connected Nbr_Other year, cmissing(n)) (connected Starkey_prizes_Privateers year, cmissing(n)) /*
	*/ , /*
	*/ legend(rows(3) order (1 "Number of prize ships reports in the High Court of Admiralty (HCA34)" "(no duplicates)" /*
	*/ 2 "Number of prizes (other sources)" 3 "Number of Privateers prizes (Starkey)" )) /*
	*/ name(Comp_HCA34_Other, replace) scheme(stsj)

***This graphs shows that Starkey’s numbers are very close to HCA34 1740-1785
***And that "Other" numbers are very missing a lot of captures


	
generate Nbr_HCA34_and_other = 	Nbr_HCA34_wod + Nbr_Other 
generate Nbr_HCA34_and_other_FR = 	Nbr_HCA34_wo_duplicates_France + Nbr_Other_France 
generate Nbr_HCA34_and_other_Spain = 	Nbr_HCA34_wo_duplicates_Spain + Nbr_Other_Spain 
generate Nbr_HCA34_and_other_Neth = 	Nbr_HCA34_wo_duplicates_Neth + Nbr_Other_Neth 
generate Nbr_HCA34_and_other_US = 	Nbr_HCA34_wo_duplicates_US + Nbr_Other_US 
generate Nbr_HCA34_and_other_Other = 	Nbr_HCA34_wo_duplicates_Other + Nbr_Other_Other 
generate Nbr_HCA34_and_other_Unknown = 	Nbr_HCA34_wo_duplicates_Unknown + Nbr_Other_Unknown

graph twoway (connected Nbr_HCA34_and_other year, cmissing(n)) (connected Nbr_HCA34_and_other_FR year, cmissing(n)) if year >= 1739 & year<=1816, /*
	*/ legend( rows(2) order (1 "Number of prize ships reports in the High Court of Admiralty (HCA34)" "(no duplicates) + Number of prizes (other sources)" 2 "Number of French prize ships reports in the High Court of Admiralty" " (HCA34) (no duplicates) + Number of prizes (other sources)")) /*
	*/ scheme(stsj) name(HCA34_and_Other, replace)	
	

 twoway (connected share_totFT_prize_imports year,cmissing(n) msize(small)) (connected Nbr_HCA34_wod year,cmissing(n) yaxis(2) msize(small)) (connected Nbr_HCA34_wo_duplicates_France year,cmissing(n) yaxis(2) msize(small)) if year >=1739 & year <=1815, /*
	*/ legend(rows(3) order (1 "Official value of prize goods imported in Britain as a share of French trade" /*
	*/2 "Number of prize ships reports in the High Court of Admiralty (HCA34) (no duplicates)" 3 "idem, but only French ships") size(vsmall)) /*
	*/ytitle(share of French trade) ytitle(number of ships, axis(2)) /*
	*/ scheme(stsj) name(HCA34_and_imports, replace)

gen Nbr_BestGuess_privateers= Nbr_HCA34_and_other
replace Nbr_BestGuess_privateers = Starkey_prizes_Privateers if year >=1702 & year <=1720


save "$hamburg/database_dta/English_prizes.dta",  replace

*=Sur le graphique, on veut : total number of prizes (including RN and privateers) ; total estimated number of French prizes ; total number of privateer prizes ; total number of French privateer prizes

gen Number_of_prizes_Total_All = Nbr_BestGuess_privateers + Nbr_prizes_GBNavy

**for some descriptive statistics
egen blif = total(Number_of_prizes_Total_All)
egen blouf = total (Nbr_HCA34_and_other_Unknown)
gen share_of_unknown_prizes = blouf/blif if year >=1739 & year <=1815
codebook share_of_unknown_prizes
drop blif blouf share_of_unknown_prizes
//All pre-1739 prizes are unknown



gen Nbr_HCA34_and_other_Non_FR = Nbr_HCA34_and_other_Spain + Nbr_HCA34_and_other_Neth + Nbr_HCA34_and_other_US + Nbr_HCA34_and_other_Other
gen share_of_non_FR_prizes = 1-Nbr_HCA34_and_other_FR/(Nbr_HCA34_and_other_Non_FR+Nbr_HCA34_and_other_FR) /*
	*/ if year >=1744 & year <=1809 & Nbr_HCA34_and_other >=5



**for some descriptive statistics
egen blif = total(Nbr_HCA34_and_other_Non_FR+Nbr_HCA34_and_other_FR)
egen blouf = total (Nbr_HCA34_and_other_FR)
gen share_of_FR_prizes = blouf/blif if year >=1739 & year <=1815
codebook share_of_FR_prizes
drop blif blouf share_of_FR_prizes


 
**pour les années manquantes, je prends la moyenne de la période
sum share_of_non_FR_prizes if year >=1793 & year <=1802 
replace share_of_non_FR_prizes = r(mean) if year >=1793 & year <=1802 & share_of_non_FR_prizes==.



sum share_of_non_FR_prizes if year >=1803 & year <=1815 
replace share_of_non_FR_prizes = r(mean) if year >=1803 & year <=1815 & share_of_non_FR_prizes==.


gen estimated_number_of_prizes_FR = (Nbr_HCA34_and_other + Nbr_prizes_GBNavy)*(1-share_of_non_FR_prizes) if year >=1739 & year <=1815

 twoway (bar  estimated_number_of_prizes_FR year,cmissing(n)  msize(small) lpattern(solid) msymbol(circle)) /*
    */  (bar Number_of_prizes_Total_All year,cmissing(n) msize(small) lpattern(dot) msymbol(circle)) /*
	*/  (bar Nbr_HCA34_and_other_FR year,cmissing(n)  msize(small) lpattern(solid) msymbol(square)) /*
	*/  (bar Nbr_HCA34_and_other year,cmissing(n)  msize(small) lpattern(dot) msymbol(square)) /*
	*/  if year >=1739 & year <=1815, /*
	*/  legend(rows(4) order (2 "Total number of prizes" /*
	*/  1  "Estimated total number of French prizes" 4 "Total number of prizes captured by privateers" /*
	*/  3 "Total number of French prizes captured by privateers") size(vsmall)) /*
	*/  ytitle(number of ships) /*
	*/  name(for_paper, replace) /*
	*/ 	scheme(stsj)
	


rename estimated_number_of_prizes_FR Number_of_prizes_Total_FR
rename Nbr_HCA34_and_other_FR Number_of_prizes_Privateers_FR



export delimited "$hamburg/database_csv/prizes.csv", replace

drop if year >=1816 | year<=1702  
 twoway (bar Number_of_prizes_Total_All year, color(gs10)) /*
	*/  (bar Nbr_BestGuess_privateers year, color(gs5)) /*
	*/  (connected share_of_non_FR_prizes year, lpattern(solid) mcolor(black) cmissing(n) msymbol(diamond) msize(vsmall) yaxis(2)) /*
	*/ if year >=1702 & year <=1815 /*
	*/  ,legend(rows(3) order ( 2 "Privateers’ prizes"  /*
	*/  1 "Navy’s prizes" 3 "Share of non-French prizes among privateers’ prizes"  /*
	*/  ) size(small)) /*
	*/  ytitle("number of prizes", axis(1)) ytitle("share of privateers’ prizes", axis(2))/*
	*/  name(Prizes_for_paper, replace) /*
	*/ note("Unless otherwise specified, the date is the year the prize was adjudicated") /*
	*/ scheme(stsj) xlabel(1700(20)1820)

graph export "$hamburggit/Paper - Impact of War/Paper/Prizes.png", replace	


erase "$hamburg/database_dta/HCA34_prizes.dta"
erase "$hamburg/database_dta/PrizeNationalities.dta"
erase "$hamburg/database_dta/Starkey -- Nbr of prizes -- 1990.dta"



recode Nbr_HCA34_and_other_* (0=.), 

export delimited "$hamburg/database_csv/prizes_nationality.csv", replace

/*
twoway (connected Nbr_HCA34_and_other_Other year, cmissing(n) msize(small)) /*
	*/ (connected Nbr_HCA34_and_other_Spain year, cmissing(n) msize(small)) (connected Nbr_HCA34_and_other_Neth year, cmissing(n) msize(small)) /*
	*/ (connected Nbr_HCA34_and_other_US year, cmissing(n) msize(small)) /*
	*/ if year >=1739 & year <=1815 /*
	*/ ,legend(rows(2) order (2 "Spanish prizes" 3 "Dutch prizes" 4 "US prizes" 1 "Other prizes")) /*
	*/ scheme(stsj) name(Prize_nationality, replace)
	
graph export "$hamburggit/Paper - Impact of War/Paper/Prizes_nationality.png", replace
*/

save "$hamburg/database_dta/English_prizes.dta",  replace

************************
	
*insheet using "$hamburggit/External Data/Value of British prizes.xlsx", case clear names
///Data come from Hillman and Gathmann (2011) for the mean value of privateer’s prizes by period
///From Benjamin (2009, figure 2) for the mean value of Navy’s prizes by year 
import excel "$hamburggit/External Data/Value of British prizes.xlsx", clear firstrow
rename Year year
rename TotalSilverTonsPrizeValue Navy_Total_Prize_value

*replace Navy_Total_Prize_value  =usubinstr(Navy_Total_Prize_value,",",".",.)
*destring Navy_Total_Prize_value, replace

drop if year==.
merge 1:1 year using "$hamburg/database_dta/English_prizes.dta"
drop _merge

generate Privateers_Total_Prize_value = MedianValuePrivateers * Nbr_BestGuess_privateers*ST_silver/1000000
generate Privateers_Investment = Privateers_Total_Prize_value/1.7
replace Privateers_Investment = Privateers_Investment*0.34/1.25 if year >=1689 & year <=1697
replace Privateers_Investment = Privateers_Investment*0.34/0.73 if year >=1702 & year <=1713
replace Privateers_Investment = Privateers_Investment*0.34/0.23 if year >=1756 & year <=1763
replace Privateers_Investment = Privateers_Investment*0.34/0.49 if year >=1775 & year <=1783
replace Privateers_Investment = Privateers_Investment*0.34/0.12 if year >=1793 & year <=1802
replace Privateers_Investment = Privateers_Investment*0.34/0.10 if year >=1803 & year <=1815
**This assumes the British privateers are more successfull than the French ones during the War of Austrian Succession
**See "Résultats de la course française.xlsx"
**And adjuste with Hillmann and Gathmann (2011), table 6

generate Total_Prize_value = MedianValuePrivateers * Number_of_prizes_Total_All*ST_silver/1000000 if year <=1792

replace Total_Prize_value = Navy_Total_Prize_value+Privateers_Total_Prize_value if year >=1793
generate FR_Prize_value = Total_Prize_value*(1-share_of_non_FR_prizes)


save "$hamburg/database_dta/English_prizes.dta",  replace
drop if year >=1816
*twoway(connected Total_Prize_value year) (connected FR_Prize_value year) (connected Privateers_Total_Prize_value year) (connected Navy_Total_Prize_value year) 
twoway(bar Total_Prize_value year) (bar FR_Prize_value year) (line Privateers_Investment year, cmissing (n)) /*
  */ if year >=1702 & year <=1815, /* 
  */ ytitle("tons of silver", axis(1)) scheme(stsj) xlabel(1700(20)1820) /*
  */ legend(rows(2) order (1 "Total prize value" 2 "French prize value" 3 "Outfitting of privateers" )) 
 
 graph export "$hamburggit/Paper - Impact of War/Paper/Prizes_value.png", replace
 
 twoway(bar Total_Prize_value year) (bar FR_Prize_value year) (line Privateers_Investment year, cmissing (n)) /*
  */ , /* 
  */ ytitle("tons of silver", axis(1)) scheme(stsj) /*
  */ legend(rows(2) order (1 "Total prize value" 2 "French prize value" 3 "Outfitting of privateers" )) 
 
 ******
 *****END OF BRITISH DATA
 ****** For prizes by both sides
 import excel "$hamburggit/External Data/Résultats de la course française.xlsx", sheet("Output") firstrow clear
 drop D F G

 merge 1:1 year using "$hamburg/database_dta/English_prizes.dta"
 drop _merge
 *keep if year >=1740 & year <=1820
capture drop FR_silver
 merge 1:1 year using "$hamburg/database_dta/FR_silver.dta"
 drop _merge

 *replace FR_silver = 4.5 if year ==1793 | year==1794 | year==1795 | year==1796

 gen Frenchincome = Frenchincomeprivateers + Frenchincomenavy if Frenchincomenavy !=.
 replace Frenchincome = Frenchincomeprivateers if Frenchincomenavy ==. & Frenchincomeprivateers !=.
 label var Frenchincome "French gross predation income (including the Navy from 1756)"
 label var Frenchinvestment "French privateers’ outfitting"
 
 replace Frenchincome = Frenchincome*FR_silver/1000
 replace Frenchinvestment= Frenchinvestment*FR_silver/1000
 **Les données françaises sont en milliers de livres tournois. * la valeur en grammes, cela donne des kg. Il faut donc diviser encore par 1000 pour avoir des tonnes.

sort year
generate French_net_income = Frenchincome-Frenchinvestment
generate English_net_income= Total_Prize_value-Privateers_Investment
replace Frenchinvestment=-Frenchinvestment
replace Privateers_Investment=-Privateers_Investment
save "$hamburg/database_dta/English&French_prizes.dta",  replace


*****For Paper with Loïc

twoway(line Total_Prize_value year, cmissing (n)) (line FR_Prize_value year, cmissing (n)) (line Frenchincome year, cmissing (n)) /*
  */ if year >=1680& year <=1815, /* 
  */ ytitle("tons of silver", axis(1)) scheme(stsj) xlabel(1680(20)1820) /*
  */ legend(rows(3) order (1 "English income from all prizes" 2 "English income from French prizes" 3 "French income (including the Navy from 1756)")) /*
  */ ytitle(,margin(medium))

 
graph export "$hamburggit/Paper - Impact of War/Paper/Prizes_for_paper_with_Loic.png", replace

keep if year > 1680 & year <=1815
keep Total_Prize_value FR_Prize_value Frenchincome year
rename Total_Prize_value Englishincomefromallprizes 
rename FR_Prize_value EnglishincomefromFrenchprizes
rename Frenchincome FrenchincomeincludingtheNavy
export delimited using "~/Library/CloudStorage/Dropbox/2022 Economic Warfare/2025 02 Graphs/DataFigure1.csv", delimiter(,) replace


