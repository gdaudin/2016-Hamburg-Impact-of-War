clear

global thesis2 "/Users/Tirindelli/Google Drive/ETE/Thesis2"

set more off

use "$thesis2/database_dta/hamburg2"

drop if value==.
drop pays_regroupes
drop if year<1733
encode classification_hamburg_large, gen(class)

****GEN 7 WAR DUMMIES	
gen war_each=""

foreach i of num 1733/1738{
replace war_each="1Polish" if year==`i'
}

foreach i of num 1740/1743{
replace war_each="2Austrian1" if year==`i'
}

foreach i of num 1744/1748{
replace war_each="2Austrian2" if year==`i'
}

foreach i of num 1756/1763{
replace war_each="3Seven" if year==`i'
}

foreach i of num 1778/1782{
replace war_each="4American" if year==`i'
}

foreach i of num 1792/1802{
replace war_each="5Revolutionary" if year==`i'
}

foreach i of num 1803/1814{
replace war_each="6Napoleonic" if year==`i'
}

****gen one dummy for all wars
gen all=""
foreach i of num 1733/1738{
replace all="All" if year==`i'
}

foreach i of num 1740/1748{
replace all="All" if year==`i'
}

foreach i of num 1756/1763{
replace all="All" if year==`i'
}
foreach i of num 1778/1782{
replace war="All" if year==`i'
}

foreach i of num 1792/1802{
replace all="All" if year==`i'
}

foreach i of num 1803/1814{
replace all="All" if year==`i'
}

encode war_each, gen(wars)
egen war_class=group(wars class), label
replace wars=0 if wars==.
replace war_class=0 if war_class==.

encode all, gen(all_)
egen all_class=group(all_ class), label
replace all_=0 if all_==.
replace all_class=0 if all_class==.


foreach i of num 1/5{
gen year_class`i'=0
replace year_class`i'=year if class==`i'
}


****reg 
poisson value i.class year_class1-year_class5 i.all_class

poisson value i.class year_class1-year_class5 i.war_class

****gen war lags
gen all_war_lag=""

foreach i of num 1/5{
replace all_war_lag="`i' lags All" if year==(1748+`i')
replace all_war_lag="`i' lags All" if year==(1763+`i')
replace all_war_lag="`i' lags All" if year==(1814+`i')
}

encode all_war_lag, gen(war_lag)
egen war_lag_class=group(war_lag class), label
replace war_lag=0 if war_lag==.
replace war_lag_class=0 if war_lag_class==.



gen each_war_lag=""

foreach i of num 1/5{
replace each_war_lag="`i' lags 1Austrian2" if year==(1748+`i')
replace each_war_lag="`i' lags 2Seven" if year==(1763+`i')
replace each_war_lag="`i' lags 3Napoleaonic" if year==(1814+`i')
}

encode each_war_lag, gen(wars_lag)
egen wars_lag_class=group(wars_lag class), label
replace wars_lag=0 if wars_lag==.
replace wars_lag_class=0 if wars_lag_class==.

poisson value i.class year_class1-year_class5 i.all_class i.war_lag_class

poisson value i.class year_class1-year_class5 i.war_class i.wars_lag_class



****gen prewar effects

gen all_war_pre=""

foreach i of num 1/4{
replace all_war_pre="`i' pre All" if year==(1756-`i')
replace all_war_pre="`i' pre All" if year==(1778-`i')
replace all_war_pre="`i' pre All" if year==(1792-`i')
}

encode all_war_pre, gen(war_pre)
egen war_pre_class=group(war_pre class), label
replace war_pre=0 if war_pre==.
replace war_pre_class=0 if war_pre_class==.



gen each_war_pre=""

foreach i of num 1/4{
replace each_war_pre="`i' pre 1Seven" if year==(1756-`i')
replace each_war_pre="`i' pre 2America" if year==(1778-`i')
replace each_war_pre="`i' pre 3Revolutionary" if year==(1792-`i')
}

encode each_war_pre, gen(wars_pre)
egen wars_pre_class=group(wars_pre class), label
replace wars_pre=0 if wars_pre==.
replace wars_pre_class=0 if wars_pre_class==.

poisson value i.class year_class1-year_class5 i.all_class i.war_pre_class

poisson value i.class year_class1-year_class5 i.war_class i.wars_pre_class
















