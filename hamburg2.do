clear

global thesis2 "/Users/Tirindelli/Google Drive/ETE/Thesis2"

set more off

use "$thesis2/database_dta/hamburg2"

drop if value==.
drop pays_regroupes
drop if year<1733
encode classification_hamburg_large, gen(class)

gen war_each=""

foreach i of num 1733/1738{
replace war_each="Polish" if year==`i'
}

foreach i of num 1740/1743{
replace war_each="Austrian1" if year==`i'
}

foreach i of num 1744/1748{
replace war_each="Austrian2" if year==`i'
}

foreach i of num 1756/1763{
replace war_each="Seven" if year==`i'
}

foreach i of num 1778/1782{
replace war_each="American" if year==`i'
}

foreach i of num 1792/1802{
replace war_each="Revolutionary" if year==`i'
}

foreach i of num 1803/1814{
replace war_each="Napoleonic" if year==`i'
}

encode war_each, gen(wars)
egen war_class=group(wars class)

foreach i of num 1/5{
gen year_class`i'=.
replace year_class`i'=year if class==`i'
}

****reg 
poisson value i.class year_class1-year_class5 i.war_class




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


encode classification_hamburg_large, gen(class)


