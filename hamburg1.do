
global thesis2 "/Users/Tirindelli/Google Drive/ETE/Thesis2"

set more off

use "$thesis2/database_dta/hamburg1", clear

drop if year<1733

****gen war dummies
foreach i of num 1/8{
gen war`i'=0
}

foreach i of num 1733/1738{
replace war1=1 if year==`i'
label var war1 Polish
}

foreach i of num 1740/1743{
replace war2=1 if year==`i'
label var war2 Austrian1
}

foreach i of num 1744/1748{
replace war3=1 if year==`i'
label var war3 Austrian2
}

foreach i of num 1756/1763{
replace war4=1 if year==`i'
label var war4 Seven
}

foreach i of num 1778/1782{
replace war5=1 if year==`i'
label var war5 American
}

foreach i of num 1792/1802{
replace war6=1 if year==`i'
label var war6 Revolutionary
}

foreach i of num 1803/1814{
replace war7=1 if year==`i'
label var war7 Napoleonic
}

foreach i of num 1733/1738{
replace war8=1 if year==`i'
label var war8 All
}
foreach i of num 1740/1748{
replace war8=1 if year==`i'
}
foreach i of num 1756/1763{
replace war8=1 if year==`i'
}
foreach i of num 1778/1782{
replace war8=1 if year==`i'
}
foreach i of num 1792/1802{
replace war8=1 if year==`i'
}
foreach i of num 1803/1814{
replace war8=1 if year==`i'
}

gen year2=(year)^(2)

poisson value year war8
est2vec dummies1, e(r2 F) shvars(war8 war1-war7) replace

poisson value year2 war8
est2vec dummies1, addto(dummies1) name(quadratic1)

poisson value year war1-war7
est2vec dummies1, addto(dummies1) name(all)

poisson value year2 war1-war7
est2vec dummies1, addto(dummies1) name(quadratic2)

est2rowlbl year war1-war8, saving replace path("$thesis2/reg_table/hamburg1/dummies1") addto(dummies1)
est2tex dummies1, preserve dropall path("$thesis2/reg_table/hamburg1/dummies1") mark(stars) fancy collabels(All War~by~war All~quadratic War~by~war~quadratic) replace

******* gen war lags
foreach i in 3 4 7 8{
foreach j of num 1/5{
gen war`i'_lag`j'=0
local lab `: var label war`i''
label var war`i'_lag`j' "`j' lags `lab'"
}
}


foreach i of num 1/5{
replace war3_lag`i'=1 if year==(1748+`i')
replace war4_lag`i'=1 if year==(1756+`i')
replace war7_lag`i'=1 if year==(1814+`i')
replace war8_lag`i'=1 if year==(1748+`i')
replace war8_lag`i'=1 if year==(1756+`i')
replace war8_lag`i'=1 if year==(1814+`i')
}

poisson value year war8 war8_lag1-war8_lag5
est2vec lag1, e(r2 F) shvars(war8_lag1-war8_lag5 war3_lag1-war7_lag5) replace

poisson value year2 war8 war8_lag1-war8_lag5
est2vec lag1, addto(lag1) name(lag1)

poisson value year war1-war7 war3_lag1-war7_lag5
est2vec lag1, addto(lag1) name(lag2)

poisson value year2 war1-war7 war3_lag1-war7_lag5
est2vec lag1, addto(lag1) name(lag3)

est2rowlbl war3_lag1-war8_lag5, saving replace path("$thesis2/reg_table/hamburg1/lag1") addto(lag1)
est2tex lag1, preserve dropall path("$thesis2/reg_table/hamburg1/lag1") mark(stars) fancy collabels(All War~by~war All~quadratic War~by~war~quadratic) replace



*****gen prewar
foreach i in 4 5 6 8{
foreach j of num 1/4{
gen war`i'_pre`j'=0
local lab `:var label war`i''
label var war`i'_pre`j' "`j' pre `lab'"
}
}

foreach i of num 1/4{
replace war4_pre`i'=1 if year==(1763-`i')
replace war5_pre`i'=1 if year==(1778-`i')
replace war6_pre`i'=1 if year==(1792-`i')
replace war8_pre`i'=1 if year==(1763-`i')
replace war8_pre`i'=1 if year==(1778-`i')
replace war8_pre`i'=1 if year==(1792-`i')
}

poisson value year war8 war8_pre1-war8_pre4
est2vec pre1, e(r2 F) shvars(war8_pre1-war8_pre4 war4_pre1-war6_pre4) replace

poisson value year2 war8 war8_pre1-war8_pre4
est2vec pre1, addto(pre1) name(pre1)

poisson value year war1-war7 war4_pre1-war6_pre4
est2vec pre1, addto(pre1) name(pre2)

poisson value year war1-war7 war4_pre1-war6_pre4
est2vec pre1, addto(pre1) name(pre3)

est2rowlbl war4_pre1-war8_pre4, saving replace path("$thesis2/reg_table/hamburg1/pre1/") addto(pre1)
est2tex pre1, preserve dropall path("$thesis2/reg_table/hamburg1/pre1/") mark(stars) fancy collabels(All War~by~war All~quadratic War~by~war~quadratic) replace
 





