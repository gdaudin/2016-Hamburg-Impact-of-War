*************************************************************************************************************************************
*************************************************************************************************************************************
*******************************ESTIMATE WITH PRODUCT DIFFERENTIATION******************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************


clear
global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

use "$thesis/Data/database_dta/elisa_hamburg2.dta", clear

set more off

merge m:1 year classification_hamburg_large using "$thesis/Data/database_dta/prediction_product"
replace value=pred_value if year<1752
replace value=pred_value if year==1753 
foreach i of num 1762/1766{
replace value=pred_value if year==`i'
}
drop pred_value _merge
drop if year<1733

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

foreach i of num 1/5{
gen war_class_`i'=war*class_`i'
}

foreach i of num 1/5{
gen year_class_`i'=year*class_`i'
}
foreach i of num 1/5{
gen year_war_class_`i'=year*war*class_`i'
}

***regress with war dummies - polish 
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5, robust 
est2vec dummies1, e(r2 F) shvars(war_class_1-war_class_5) replace


***regress with time trend, fe and war dummies with time trends
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 year_war_class_1-year_war_class_5, robust 
est2vec trend1, e(r2 F) shvars(war_class_1-war_class_5 year_war_class_1-year_war_class_5) replace





****AUSTRIAN SUCCESION WAR - not colonial

replace war=0

foreach i of num 1740/1744{
replace war=1 if year==`i'
}

foreach i of num 1/5{
replace war_class_`i'=war*class_`i'
}

foreach i of num 1/5{
replace year_class_`i'=year*class_`i'
}
foreach i of num 1/5{
replace year_war_class_`i'=year*war*class_`i'
}

***regress with war dummies - austrian a  
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5, robust 
est2vec dummies1, addto(dummies1) name(austrian_a)

***regress with time trend, fe and war dummies with time trends
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 year_war_class_1-year_war_class_5, robust 
est2vec trend1, addto(trend1) name(austrian_a)






****AUSTRIAN SUCCESION WAR - colonial phase

replace war=0

foreach i of num 1744/1748{
replace war=1 if year==`i'
}

foreach i of num 1/5{
replace war_class_`i'=war*class_`i'
}

foreach i of num 1/5{
replace year_class_`i'=year*class_`i'
}
foreach i of num 1/5{
replace year_war_class_`i'=year*war*class_`i'
}

***regress with war dummies - austrian a  
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5, robust 
est2vec dummies1, addto(dummies1) name(austrian_b)

***regress with time trend, fe and war dummies with time trends
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 year_war_class_1-year_war_class_5, robust 
est2vec trend1, addto(trend1) name(austrian_b)

****gen lag
foreach i of num 1/5{
foreach j of num 1/5{
gen lag`j'_class`i'=0
}
}

foreach i of num 1/5{
foreach j of num 1/5{
replace lag`j'_class`i'=1 if year==(1748+`j') & class==`i'
}
}

****run reg with lag
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 lag1_class1-lag5_class5, robust 
est2vec lag1, e(r2 F) shvars(lag1_class1-lag5_class4) replace



****SEVEN YEARS WAR WAR
replace war=0

foreach i of num 1756/1763{
replace war=1 if year==`i'
}

foreach i of num 1/5{
replace war_class_`i'=war*class_`i'
}

foreach i of num 1/5{
replace year_class_`i'=year*class_`i'
}
foreach i of num 1/5{
replace year_war_class_`i'=year*war*class_`i'
}

***regress with war dummies - austrian a  
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5, robust 
est2vec dummies1, addto(dummies1) name(seven)

***regress with time trend, fe and war dummies with time trends
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 year_war_class_1-year_war_class_5, robust 
est2vec trend1, addto(trend1) name(seven)

****gen lag
foreach i of num 1/5{
foreach j of num 1/5{
replace lag`j'_class`i'=0
}
}

foreach i of num 1/5{
foreach j of num 1/5{
replace lag`j'_class`i'=1 if year==(1763+`j') & class==`i'
}
}

***gen prewar
foreach i of num 1/5{
foreach j of num 1/4{
gen pre`j'_class`i'=0
}
}

foreach i of num 1/5{
foreach j of num 1/4{
replace pre`j'_class`i'=1 if year==(1756-`j') & class==`i'
}
}

****run reg with lag
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 lag1_class1-lag5_class5, robust 
est2vec lag1, addto(lag1) name(seven)

****run reg with pre
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 pre1_class1-pre4_class5, robust 
est2vec pre1, e(r2 F) shvars(pre1_class1-pre4_class4) replace





****AMERICAN WAR

replace war=0

foreach i of num 1778/1782{
replace war=1 if year==`i'
}

foreach i of num 1/5{
replace war_class_`i'=war*class_`i'
}

foreach i of num 1/5{
replace year_class_`i'=year*class_`i'
}
foreach i of num 1/5{
replace year_war_class_`i'=year*war*class_`i'
}

***regress with war dummies - austrian a  
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5, robust 
est2vec dummies1, addto(dummies1) name(american)

***regress with time trend, fe and war dummies with time trends
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 year_war_class_1-year_war_class_5, robust 
est2vec trend1, addto(trend1) name(american)

****gen lag
foreach i of num 1/5{
foreach j of num 1/5{
replace lag`j'_class`i'=0
}
}

foreach i of num 1/5{
foreach j of num 1/5{
replace lag`j'_class`i'=1 if year==(1782+`j') & class==`i'
}
}

***gen prewar
foreach i of num 1/5{
foreach j of num 1/4{
replace pre`j'_class`i'=0
}
}

foreach i of num 1/5{
foreach j of num 1/4{
replace pre`j'_class`i'=1 if year==(1778-`j') & class==`i'
}
}
****run reg with lag
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 lag1_class1-lag4_class5, robust 
est2vec lag1, addto(lag1) name(american)

****run reg with pre
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 pre1_class1-pre4_class5, robust 
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

foreach i of num 1/5{
replace war_class_`i'=war*class_`i'
}

foreach i of num 1/5{
replace year_class_`i'=year*class_`i'
}
foreach i of num 1/5{
replace year_war_class_`i'=year*war*class_`i'
}

***regress with war dummies - all
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5, robust 
est2vec dummies1, addto(dummies1) name(all)

***regress with time trend, fe and war dummies with time trends
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 year_war_class_1-year_war_class_5, robust 
est2vec trend1, addto(trend1) name(all)

****gen lag
foreach i of num 1/5{
foreach j of num 1/5{
replace lag`j'_class`i'=0
}
}

foreach i of num 1/5{
foreach j of num 1/5{
replace lag`j'_class`i'=1 if year==(1748+`j') & class==`i'
replace lag`j'_class`i'=1 if year==(1763+`j') & class==`i'
replace lag`j'_class`i'=1 if year==(1782+`j') & class==`i'
}
}

***gen prewar
foreach i of num 1/5{
foreach j of num 1/4{
replace pre`j'_class`i'=0
}
}

foreach i of num 1/5{
foreach j of num 1/4{
replace pre`j'_class`i'=1 if year==(1756-`j') & class==`i'
replace pre`j'_class`i'=1 if year==(1778-`j') & class==`i'
replace pre`j'_class`i'=1 if year==(1782-`j') & class==`i'
}
}
****run reg with lag
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 lag1_class1-lag5_class5, robust 
est2vec lag2, addto(lag1) name(all)

****run reg with pre
reg lnvalue class_1-class_4 year_class_1-year_class_5 war_class_1-war_class_5 pre1_class1-pre4_class5, robust 
est2vec pre2, addto(pre1) name(all)



*****save to latex
*est2rowlbl year war_class_1-war_class_5, saving replace path("$thesis/Data/reg_table/hamburg1/dummies") addto(dummies1)
est2tex dummies1, preserve dropall path("$thesis/Data/reg_table/hamburg2/dummies") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace


***save to latex
*est2rowlbl year war1-war6 year_war1-year_war6, saving replace path("$thesis/Data/reg_table/hamburg1/trend") addto(trend1)
est2tex trend1, preserve dropall path("$thesis/Data/reg_table/hamburg2/trend") mark(stars) fancy collabels(Polish Austrian1 Austrian2 Seven~years American All) replace


*est2rowlbl war1-war6 war3-war6 war4_lag1-war6_lag5, saving replace path("$thesis/Data/reg_table/hamburg1/lag") addto(lag1)
est2tex lag1, preserve dropall path("$thesis/Data/reg_table/hamburg2/lag") mark(stars) fancy collabels(Austrian2 Seven~years American All) replace


*est2rowlbl war1-war6 war4_pre1-war6_pre5, saving replace path("$thesis/Data/reg_table/hamburg1/pre") addto(pre1)
est2tex pre1, preserve dropall path("$thesis/Data/reg_table/hamburg2/pre") mark(stars) fancy collabels(Seven~years American All) replace


*************************************DIFFERENT SPECIFICATION******************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************
clear
global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis/"

use "$thesis/Data/database_dta/elisa_hamburg2.dta", clear

set more off

merge m:1 year classification_hamburg_large using "$thesis/Data/database_dta/prediction_product"
drop if _merge==2

drop if year<1733
drop if year>1789

replace direction="total" if direction==""
sort (year) direction
egen _count=sum(value), by(year direction)
replace pred_value=0 if _count!=0 & value==0

replace value=pred_value if year<1752
replace value=pred_value if year==1753 
foreach i of num 1762/1766{
replace value=pred_value if year==`i'
}
 
drop pred_value _merge _count



replace classification_hamburg_large="other" if classification_hamburg_large!="Sucre ; cru blanc ; du Brésil" & classification_hamburg_large!="Café" & classification_hamburg_large!="Eau ; de vie" & classification_hamburg_large!="Vin ; de France" 
replace classification_hamburg_large="Sugar" if classification_hamburg_large=="Sucre ; cru blanc ; du Brésil"
replace classification_hamburg_large="Coffee" if classification_hamburg_large=="Café"
replace classification_hamburg_large="Wine" if classification_hamburg_large=="Vin ; de France"
replace classification_hamburg_large="Eau de vie" if classification_hamburg_large=="Eau ; de vie"
replace classification_hamburg_large="Zother" if classification_hamburg_large=="other"

collapse (sum) value, by(year classification_hamburg_large)
gen lnvalue=ln(value)

encode classification_hamburg_large, gen(class)
tab classification_hamburg_large, gen(class_)


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

****gen class time trend
foreach i of num 1/5{
gen year_class_`i'=year*class_`i'
}

***gen war product interaction
foreach i of num 1/6{
foreach j of num 1/5{
gen war`i'_class`j'=war`i'*class_`j'
}
}

foreach i of num 1/6{
foreach j of num 1/5{
local lab `: var label war`i''
label var war`i'_class`j' "`lab': `: label (class) `j''"
}
}

***gen war lags

foreach i of num 1/5{
foreach j of num 1/5{
gen war3_lag`j'_class`i'=0
replace war3_lag`j'_class`i'=1 if year==(1748+`j') & class==`i'
label var war3_lag`j'_class`i' "Austrian2: `j' lag for `:label (class)`i''"
}
}
foreach i of num 1/5{
foreach j of num 1/5{
gen war4_lag`j'_class`i'=0
replace war4_lag`j'_class`i'=1 if year==(1763+`j') & class==`i'
label var war4_lag`j'_class`i' "Seven: `j' lag for `:label (class)`i''"
}
}
foreach i of num 1/5{
foreach j of num 1/5{
gen war5_lag`j'_class`i'=0
replace war5_lag`j'_class`i'=1 if year==(1782+`j') & class==`i'
}
}
foreach i of num 1/5{
foreach j of num 1/5{
gen war6_lag`j'_class`i'=0
replace war6_lag`j'_class`i'=1 if year==(1748+`j') & class==`i'
replace war6_lag`j'_class`i'=1 if year==(1763+`j') & class==`i'
replace war6_lag`j'_class`i'=1 if year==(1782+`j') & class==`i'
label var war6_lag`j'_class`i' "All: `j' lag for `:label (class)`i''"
}
}
***gen pre war effects

foreach i of num 1/5{
foreach j of num 1/4{
gen war4_pre`j'_class`i'=0
replace war4_pre`j'_class`i'=1 if year==(1756-`j') & class==`i'
label var war4_pre`j'_class`i' "Seven: `j' pre for `:label (class)`i''"
}
}
foreach i of num 1/5{
foreach j of num 1/4{
gen war5_pre`j'_class`i'=0
replace war5_pre`j'_class`i'=1 if year==(1778-`j') & class==`i'
label var war5_pre`j'_class`i' "American: `j' pre for `:label (class)`i''"
}
}
foreach i of num 1/5{
foreach j of num 1/4{
gen war6_pre`j'_class`i'=0
replace war6_pre`j'_class`i'=1 if year==(1756-`j') & class==`i'
replace war6_pre`j'_class`i'=1 if year==(1778-`j') & class==`i'
label var war6_pre`j'_class`i' "All: `j' pre for `:label (class)`i''"
}
}

****separetly
***regress with war dummies 
reg lnvalue class_1-class_4 year_class_1-year_class_5 war6_class1-war6_class5, robust 
est2vec reg1_dummies, e(r2 F) shvars(war6_class1-war6_class4 war1_class1-war1_class4 war2_class1-war2_class4 war3_class1-war3_class4 war4_class1-war4_class4 war5_class1-war5_class4) replace

reg lnvalue class_1-class_4 year_class_1-year_class_5 war1_class1-war5_class5, robust 
est2vec reg1_dummies, addto(reg1_dummies) name(reg1_dummies)

poisson value class_1-class_4 year_class_1-year_class_5 war6_class1-war6_class5, robust 
est2vec reg1_dummies, addto(reg1_dummies) name(ppml1)

poisson value class_1-class_4 year_class_1-year_class_5 war1_class1-war5_class5, robust 
est2vec reg1_dummies, addto(reg1_dummies) name(ppml2)

est2rowlbl war1_class1-war6_class5, saving replace path("$thesis/Data/reg_table/hamburg2/alternative") addto(reg1_dummies)
est2tex reg1_dummies, preserve dropall path("$thesis/Data/reg_table/hamburg2/alternative") mark(stars) label fancy collabels(All War~by~war) replace


***regress with lags 
reg lnvalue class_1-class_4 year_class_1-year_class_5 war6_class1-war6_class5 war6_lag1_class1-war6_lag5_class5, robust 
est2vec reg1_lag1, e(r2 F) shvars(war6_lag1_class1-war6_lag5_class4) replace
est2rowlbl war6_lag1_class1-war6_lag5_class5, saving replace path("$thesis/Data/reg_table/hamburg2/alternative") addto(reg1_lag1)
est2tex reg1_lag1, preserve dropall path("$thesis/Data/reg_table/hamburg2/alternative") mark(stars) label fancy collabels(All) replace


reg lnvalue class_1-class_4 year_class_1-year_class_5 war1_class1-war5_class5 war3_lag1_class1-war5_lag5_class5, robust 
est2vec reg1_lag2, e(r2 F) shvars(war3_lag1_class1-war3_lag5_class4) replace
est2rowlbl war3_lag1_class1-war3_lag5_class5, saving replace path("$thesis/Data/reg_table/hamburg2/alternative") addto(reg1_lag2)
est2tex reg1_lag2, preserve dropall path("$thesis/Data/reg_table/hamburg2/alternative") mark(stars) label fancy collabels(Austrian2) replace

reg lnvalue class_1-class_4 year_class_1-year_class_5 war1_class1-war5_class5 war3_lag1_class1-war5_lag5_class5, robust 
est2vec reg1_lag3, e(r2 F) shvars(war4_lag1_class1-war4_lag5_class4) replace
est2rowlbl war4_lag1_class1-war4_lag5_class5, saving replace path("$thesis/Data/reg_table/hamburg2/alternative") addto(reg1_lag3)
est2tex reg1_lag3, preserve dropall path("$thesis/Data/reg_table/hamburg2/alternative") mark(stars) label fancy collabels(Seven) replace


***regress with pre separately
reg lnvalue year class_1-class_4 war1_class1-war5_class5 war6_pre1_class1-war6_pre4_class5, robust 
est2vec reg1_pre1, e(r2 F) shvars(war6_pre1_class1-war6_pre4_class4) replace
est2rowlbl war6_pre1_class1-war6_pre4_class5, saving replace path("$thesis/Data/reg_table/hamburg2/alternative") addto(reg1_pre1)
est2tex reg1_pre1, preserve dropall path("$thesis/Data/reg_table/hamburg2/alternative") mark(stars) label fancy collabels(All) replace


reg lnvalue year class_1-class_4 war1_class1-war5_class5 war4_pre1_class1-war5_pre4_class5, robust 
est2vec reg1_pre2, e(r2 F) shvars(war4_pre1_class1-war4_pre4_class4) replace
est2rowlbl war4_pre1_class1-war4_pre4_class5, saving replace path("$thesis/Data/reg_table/hamburg2/alternative") addto(reg1_pre2)
est2tex reg1_pre2, preserve dropall path("$thesis/Data/reg_table/hamburg2/alternative") mark(stars) label fancy collabels(Seven) replace

reg lnvalue year class_1-class_4 war1_class1-war5_class5 war4_pre1_class1-war5_pre4_class5, robust 
est2vec reg1_pre3, e(r2 F) shvars(war5_pre1_class1-war5_pre4_class4) replace
est2rowlbl war5_pre1_class1-war5_pre4_class5, saving replace path("$thesis/Data/reg_table/hamburg2/alternative") addto(reg1_pre3)
est2tex reg1_pre3, preserve dropall path("$thesis/Data/reg_table/hamburg2/alternative") mark(stars) label fancy collabels(American) replace





