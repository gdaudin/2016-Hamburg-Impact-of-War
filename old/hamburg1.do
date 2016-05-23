*************************************ESTIMATE VALUE FOR HAMBURG**************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

****ESTIMATE GRAVITY MODEL
clear
global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

use "$thesis/Data/database_dta/elisa_hamburg1", clear

set more off

drop if year<1733
*****estimate total value of trade wiht no product differentiation******************************************************************

collapse (sum) value, by(year)
gen lnvalue=ln(value)
gen war=0

****POLISH SUCCESION WAR
foreach i of num 1733/1738{
replace war=1 if year==`i'
}

gen year_war=year*war


***regress with war dummies - polish 
reg lnvalue year war, robust 
est2vec dummies1, e(r2 F) shvars(year war) replace

***regress with time trends
reg lnvalue year war year_war, robust 
est2vec trend1, e(r2 F) shvars(year war year_war) replace



****AUSTRIAN SUCCESION WAR - not colonial

replace war=0
foreach i of num 1740/1744{
replace war=1 if year==`i'
}

replace year_war=year*war


***regress with war dummies - austrian a 
reg lnvalue year war, robust 
est2vec dummies1, addto(dummies1) name(austrian_a)

***regress with time trends
reg lnvalue year war year_war, robust 
est2vec trend1, addto(trend1) name(austrian_a)




****AUSTRIAN SUCCESION WAR - colonial phase

replace war=0
foreach i of num 1744/1748{
replace war=1 if year==`i'
}

replace year_war=year*war


***regress with war dummies - austrian b
reg lnvalue year war, robust 
est2vec dummies1, addto(dummies1) name(austrian_b)

***regress with time trends
reg lnvalue year war year_war, robust 
est2vec trend1, addto(trend1) name(austrian_b)

****gen lag

foreach i of num 1/5{
gen war_lag`i'=0
}

foreach i of num 1/5{
replace war_lag`i'=1 if year==(1748+`i')
}
***run reg with lag austrian b
reg lnvalue year war war_lag1-war_lag5 , robust 
est2vec lag1, e(r2 F) shvars(war_lag1-war_lag5) replace


****SEVEN YEARS WAR WAR

replace war=0
foreach i of num 1756/1763{
replace war=1 if year==`i'
}

replace year_war=year*war


***regress with war dummies - seven 
reg lnvalue year war , robust 
est2vec dummies1, addto(dummies1) name(seven)

***regress with time trends
reg lnvalue year war year_war , robust 
est2vec trend1, addto(trend1) name(seven)

****gen lag and pre seven

foreach i of num 1/5{
replace war_lag`i'=0
}

foreach i of num 1/5{
replace war_lag`i'=1 if year==(1763+`i')
}

foreach i of num 1/4{
gen war_pre`i'=0
}

foreach i of num 1/4{
replace war_pre`i'=1 if year==(1756-`i')
}
***run reg with lag seven
reg lnvalue year war war_lag1-war_lag5 , robust 
est2vec lag1, addto(lag1) name(seven)

***run reg with pre seven
reg lnvalue year war war_pre1-war_pre4 , robust 
est2vec pre1, e(r2 F) shvars(war_pre1-war_pre4) replace



****AMERICAN WAR

replace war=0
foreach i of num 1778/1782{
replace war=1 if year==`i'
}

replace year_war=year*war


***regress with war dummies - american 
reg lnvalue year war , robust 
est2vec dummies1, addto(dummies1) name(american)

***regress with time trends
reg lnvalue year war year_war , robust 
est2vec trend1, addto(trend1) name(american)

****gen lag and pre seven

foreach i of num 1/5{
replace war_lag`i'=0
}

foreach i of num 1/5{
replace war_lag`i'=1 if year==(1782+`i')
}

foreach i of num 1/4{
replace war_pre`i'=0
}

foreach i of num 1/4{
replace war_pre`i'=1 if year==(1778-`i')
}
***run reg with lag seven
reg lnvalue year war war_lag1-war_lag5 , robust 
est2vec lag1, addto(lag1) name(american)

***run reg with pre seven
reg lnvalue year war war_pre1-war_pre4 , robust 
est2vec pre1, addto(pre1) name(american)



****ALL WAR

replace war=0
foreach i of num 1733/1738{
replace war=1 if year==`i'
}
foreach i of num 1740/1748{
replace war=1 if year==`i'
}
foreach i of num 1756/1763{
replace war=1 if year==`i'
}
foreach i of num 1778/1782{
replace war=1 if year==`i'
}
replace year_war=year*war


***regress with war dummies - all 
reg lnvalue year war , robust 
est2vec dummies1, addto(dummies1) name(all)

***regress with time trends
reg lnvalue year war year_war , robust 
est2vec trend1, addto(trend1) name(all)

****gen lag and pre all

foreach i of num 1/5{
replace war_lag`i'=0
}

foreach i of num 1/5{
replace war_lag`i'=1 if year==(1748+`i')
replace war_lag`i'=1 if year==(1763+`i')
replace war_lag`i'=1 if year==(1782+`i')
}

foreach i of num 1/4{
replace war_pre`i'=0
}

foreach i of num 1/4{
replace war_pre`i'=1 if year==(1756-`i')
replace war_pre`i'=1 if year==(1778-`i')
}
***run reg with lag seven
reg lnvalue year war war_lag1-war_lag5 , robust 
est2vec lag1, addto(lag1) name(all)

***run reg with pre seven
reg lnvalue year war war_pre1-war_pre4 , robust 
est2vec pre1, addto(pre1) name(all)


*****save to latex
*est2rowlbl year war, saving replace path("$thesis/Data/reg_table/hamburg1/dummies") addto(dummies1)
est2tex dummies1, preserve dropall path("$thesis/Data/reg_table/hamburg1/dummies") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace


*est2rowlbl year war year_war, saving replace path("$thesis/Data/reg_table/hamburg1/trend") addto(trend1)
est2tex trend1, preserve dropall path("$thesis/Data/reg_table/hamburg1/trend") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace



*est2rowlbl war war_lag1-war_lag5, saving replace path("$thesis/Data/reg_table/hamburg1/lag") addto(lag1)
est2tex lag1, preserve dropall path("$thesis/Data/reg_table/hamburg1/lag") mark(stars) fancy collabels(Austrian2 Seven~years American All) replace



*est2rowlbl war war_pre1-war_pre4, saving replace path("$thesis/Data/reg_table/hamburg1/pre") addto(pre1)
est2tex pre1, preserve dropall path("$thesis/Data/reg_table/hamburg1/pre") mark(stars) fancy collabels(Seven~years American All) replace



*************************************ROBUSTNESS CHECK - same with more obs**************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

****ESTIMATE GRAVITY MODEL
clear
global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

use "$thesis/Data/database_dta/elisa_frhb_database.dta", clear

set more off

drop if year<1733

*****estimate total value of trade wiht no product differentiation******************************************************************

rename value_fr value
replace classification_hamburg_large="other" if classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Café" & classification_hamburg_large!="Eau ; de vie" & classification_hamburg_large!="Vin ; de France" 
replace classification_hamburg_large="Sugar" if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
replace classification_hamburg_large="Coffee" if classification_hamburg_large=="Café"
replace classification_hamburg_large="Wine" if classification_hamburg_large=="Vin ; de France"
replace classification_hamburg_large="Eau de vie" if classification_hamburg_large=="Eau ; de vie"
replace classification_hamburg_large="Zother" if classification_hamburg_large=="other"
collapse (sum) value, by(year classification_hamburg_large)

gen lnvalue=ln(value)
tab classification_hamburg_large, gen(class_)
encode classification_hamburg_large, gen(class)
gen war=0

****POLISH SUCCESION WAR
foreach i of num 1733/1738{
replace war=1 if year==`i'
}

gen year_war=year*war


***regress with war dummies - polish 
reg lnvalue year war class_1-class_4, robust 
est2vec dummies2, e(r2 F) shvars(year war) replace

***regress with time trends
reg lnvalue year war year_war class_1-class_4, robust 
est2vec trend2, e(r2 F) shvars(year war year_war) replace



****AUSTRIAN SUCCESION WAR - not colonial

replace war=0
foreach i of num 1740/1744{
replace war=1 if year==`i'
}

replace year_war=year*war


***regress with war dummies - austrian a 
reg lnvalue year war class_1-class_4, robust 
est2vec dummies2, addto(dummies2) name(austrian_a)

***regress with time trends
reg lnvalue year war year_war class_1-class_4, robust 
est2vec trend2, addto(trend2) name(austrian_a)




****AUSTRIAN SUCCESION WAR - colonial phase

replace war=0
foreach i of num 1744/1748{
replace war=1 if year==`i'
}

replace year_war=year*war


***regress with war dummies - austrian b
reg lnvalue year war class_1-class_4, robust 
est2vec dummies2, addto(dummies2) name(austrian_b)

***regress with time trends
reg lnvalue year war year_war class_1-class_4, robust 
est2vec trend2, addto(trend2) name(austrian_b)

****gen lag

foreach i of num 1/5{
gen war_lag`i'=0
}

foreach i of num 1/5{
replace war_lag`i'=1 if year==(1748+`i')
}
***run reg with lag austrian b
reg lnvalue year war war_lag2-war_lag5 class_1-class_4, robust 
est2vec lag2, e(r2 F) shvars(war_lag2-war_lag5) replace


****SEVEN YEARS WAR WAR

replace war=0
foreach i of num 1756/1763{
replace war=1 if year==`i'
}

replace year_war=year*war


***regress with war dummies - seven 
reg lnvalue year war class_1-class_4, robust 
est2vec dummies2, addto(dummies2) name(seven)

***regress with time trends
reg lnvalue year war year_war class_1-class_4, robust 
est2vec trend2, addto(trend2) name(seven)

****gen lag and pre seven

foreach i of num 1/5{
replace war_lag`i'=0
}

foreach i of num 1/5{
replace war_lag`i'=1 if year==(1763+`i')
}

foreach i of num 1/4{
gen war_pre`i'=0
}

foreach i of num 1/4{
replace war_pre`i'=1 if year==(1756-`i')
}
***run reg with lag seven
reg lnvalue year war war_lag2-war_lag5 class_1-class_4, robust 
est2vec lag2, addto(lag2) name(seven)

***run reg with pre seven
reg lnvalue year war war_pre2-war_pre4 class_1-class_4, robust 
est2vec pre2, e(r2 F) shvars(war_pre2-war_pre4) replace



****AMERICAN WAR

replace war=0
foreach i of num 1778/1782{
replace war=1 if year==`i'
}

replace year_war=year*war


***regress with war dummies - american 
reg lnvalue year war class_1-class_4, robust 
est2vec dummies2, addto(dummies2) name(american)

***regress with time trends
reg lnvalue year war year_war class_1-class_4, robust 
est2vec trend2, addto(trend2) name(american)

****gen lag and pre seven

foreach i of num 1/5{
replace war_lag`i'=0
}

foreach i of num 1/5{
replace war_lag`i'=1 if year==(1782+`i')
}

foreach i of num 1/4{
replace war_pre`i'=0
}

foreach i of num 1/4{
replace war_pre`i'=1 if year==(1778-`i')
}
***run reg with lag seven
reg lnvalue year war war_lag2-war_lag5 class_1-class_4, robust 
est2vec lag2, addto(lag2) name(american)

***run reg with pre seven
reg lnvalue year war war_pre2-war_pre4 class_1-class_4, robust 
est2vec pre2, addto(pre2) name(american)



****ALL WAR

replace war=0
foreach i of num 1733/1738{
replace war=1 if year==`i'
}
foreach i of num 1740/1748{
replace war=1 if year==`i'
}
foreach i of num 1756/1763{
replace war=1 if year==`i'
}
foreach i of num 1778/1782{
replace war=1 if year==`i'
}
replace year_war=year*war


***regress with war dummies - all 
reg lnvalue year war class_1-class_4, robust 
est2vec dummies2, addto(dummies2) name(all)

***regress with time trends
reg lnvalue year war year_war class_1-class_4, robust 
est2vec trend2, addto(trend2) name(all)

****gen lag and pre seven

foreach i of num 1/5{
replace war_lag`i'=0
}

foreach i of num 1/5{
replace war_lag`i'=1 if year==(1748+`i')
replace war_lag`i'=1 if year==(1763+`i')
replace war_lag`i'=1 if year==(1782+`i')
}

foreach i of num 1/4{
replace war_pre`i'=0
}

foreach i of num 1/4{
replace war_pre`i'=1 if year==(1756-`i')
replace war_pre`i'=1 if year==(1778-`i')
}
***run reg with lag seven
reg lnvalue year war war_lag2-war_lag5 class_1-class_4, robust 
est2vec lag2, addto(lag2) name(all)

***run reg with pre seven
reg lnvalue year war war_pre2-war_pre4 class_1-class_4, robust 
est2vec pre2, addto(pre2) name(all)


*****save to latex
*est2rowlbl year war, saving replace path("$thesis/Data/reg_table/hamburg1/dummies") addto(dummies2)
est2tex dummies2, preserve dropall path("$thesis/Data/reg_table/hamburg1/dummies") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace


*est2rowlbl year war year_war, saving replace path("$thesis/Data/reg_table/hamburg1/trend") addto(trend2)
est2tex trend2, preserve dropall path("$thesis/Data/reg_table/hamburg1/trend") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace



*est2rowlbl war war_lag2-war_lag5, saving replace path("$thesis/Data/reg_table/hamburg1/lag") addto(lag2)
est2tex lag2, preserve dropall path("$thesis/Data/reg_table/hamburg1/lag") mark(stars) fancy collabels(Austrian2 Seven~years American All) replace



*est2rowlbl war war_pre2-war_pre4, saving replace path("$thesis/Data/reg_table/hamburg1/pre") addto(pre2)
est2tex pre2, preserve dropall path("$thesis/Data/reg_table/hamburg1/pre") mark(stars) fancy collabels(Seven~years American All) replace


*************************************ALTERNATIVE SPECIFICATION**************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************


****ESTIMATE GRAVITY MODEL
clear
global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

use "$thesis/Data/database_dta/elisa_hamburg1", clear

set more off

drop if year<1733

*****estimate total value of trade wiht no product differentiation******************************************************************


collapse (sum) value, by(year)
gen lnvalue=ln(value)

***gen war dummies
foreach i of num 1/6{
gen war`i'=0
}

****POLISH SUCCESION WAR
foreach i of num 1733/1738{
replace war1=1 if year==`i'
}
label var war1 Polish

****AUSTRIAN SUCCESION WAR - non colonial
foreach i of num 1740/1744{
replace war2=1 if year==`i'
}
label var war2 Austrian1

****AUSTRIAN SUCCESION WAR - colonial
foreach i of num 1744/1748{
replace war3=1 if year==`i'
}
label var war3 Austrian2

****SEVEN YEARS WAR
foreach i of num 1756/1763{
replace war4=1 if year==`i'
}
label var war4 Seven

****AMERICAN WAR
foreach i of num 1778/1782{
replace war5=1 if year==`i'
}
label var war5 American

****ALL WAR
foreach i of num 1733/1738{
replace war6=1 if year==`i'
}
foreach i of num 1740/1748{
replace war6=1 if year==`i'
}
foreach i of num 1756/1763{
replace war6=1 if year==`i'
}
foreach i of num 1778/1782{
replace war6=1 if year==`i'
}
label var war6 All

****gen time trends
foreach i of num 1/6{
gen year_war`i'=year*war`i'
}

***gen war lags

foreach i of num 1/5{
gen war3_lag`i'=0
replace war3_lag`i'=1 if year==(1748+`i')
label var war3_lag`i' "Austrian2: lag `i'"
}
foreach i of num 1/5{
gen war4_lag`i'=0
replace war4_lag`i'=1 if year==(1763+`i')
label var war4_lag`i' "Seven: lag `i'"
}
foreach i of num 1/5{
gen war5_lag`i'=0
replace war5_lag`i'=1 if year==(1763+`i')
label var war5_lag`i' "American: lag `i'"
}
foreach i of num 1/5{
gen war6_lag`i'=0
replace war6_lag`i'=1 if year==(1748+`i')
replace war6_lag`i'=1 if year==(1763+`i')
replace war6_lag`i'=1 if year==(1782+`i')
label var war6_lag`i' "All: lag `i'"
}

***gen pre war effects

foreach i of num 1/4{
gen war4_pre`i'=0
replace war4_pre`i'=1 if year==(1756-`i')
label var war4_pre`i' "Seven: pre `i'"
}
foreach i of num 1/4{
gen war5_pre`i'=0
replace war5_pre`i'=1 if year==(1778-`i')
label var war5_pre`i' "American: pre `i'"
}
foreach i of num 1/4{
gen war6_pre`i'=0
replace war6_pre`i'=1 if year==(1756-`i')
replace war6_pre`i'=1 if year==(1778-`i')
label var war6_pre`i' "All: pre `i'"
}

****separetly
***regress with war dummies separately
reg lnvalue year war6, robust 
est2vec reg1_dummies, e(r2 F) shvars(war6 war1-war5) replace

***regress with lags separately
reg lnvalue year war6 war6_lag1-war6_lag5, robust 
est2vec reg1_lag, e(r2 F) shvars(war6_lag1-war6_lag5 war3_lag1-war4_lag5) replace

***regress with pre separately
reg lnvalue year war6 war6_pre1-war6_pre4, robust 
est2vec reg1_pre, e(r2 F) shvars(war6_pre1-war6_pre4 war4_pre1-war5_pre4) replace


****together
***regress with war dummies together
reg lnvalue year war1-war5, robust 
est2vec reg1_dummies, addto(reg1_dummies) name(reg1_dummies)

***regress with lags together
reg lnvalue year war1-war5 war3_lag1-war5_lag5, robust 
est2vec reg1_lag, addto(reg1_lag) name(reg1_lag)

***regress with pre together
reg lnvalue year war1-war5 war4_pre1-war5_pre4, robust 
est2vec reg1_pre, addto(reg1_pre) name(reg1_pre)

****ppml
***regress with ppml
poisson value year war6, robust 
est2vec reg1_dummies, addto(reg1_dummies) name(ppml1)

poisson value year war1-war5, robust 
est2vec reg1_dummies, addto(reg1_dummies) name(ppml2)




*****save to latex
*est2rowlbl year war, saving replace path("$thesis/Data/reg_table/hamburg/dummies") addto(dummies1)
est2tex reg1_dummies, preserve dropall path("$thesis/Data/reg_table/hamburg1/alternative") mark(stars) fancy label collabels(All War~by~war PPML~All PPML~war~by~war) replace

est2rowlbl war3_lag1-war6_lag5, saving replace path("$thesis/Data/reg_table/hamburg1/alternative") addto(reg1_lag)
est2tex reg1_lag, preserve dropall path("$thesis/Data/reg_table/hamburg1/alternative") mark(stars) fancy label collabels(All War~by~war) replace

est2rowlbl war4_pre1-war6_pre4, saving replace path("$thesis/Data/reg_table/hamburg1/alternative") addto(reg1_pre)
est2tex reg1_pre, preserve dropall path("$thesis/Data/reg_table/hamburg1/alternative") mark(stars) fancy label collabels(All War~by~war) replace
