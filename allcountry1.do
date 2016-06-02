global thesis2 "/Users/Tirindelli/Google Drive/ETE/Thesis2"

set more off

use "$thesis2/database_dta/bdd_courante1", clear

drop if year<1733
drop if pays_regroupes=="France"
drop if pays_regroupes=="Indes"
drop if pays_regroupes=="Espagne-Portugal"
drop if pays_regroupes=="Nord-Hollande"

gen each_war_status=""
gen all_war_status=""

foreach i of num 1733/1738{
replace each_war_status="1Polish adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'

replace each_war_status="1Polish neutral" if pays_regroupes=="Hollande" & year==`i'
replace each_war_status="1Polish neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="1Polish neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="1Polish neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="1Polish neutral" if pays_regroupes=="Portugal" & year==`i'
replace each_war_status="1Polish neutral" if pays_regroupes=="Angleterre" & year==`i'
replace each_war_status="1Polish neutral" if pays_regroupes=="Italie" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Portugal" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
}

foreach i of num 1740/1743{
replace each_war_status="2Austrian1 adversary" if pays_regroupes=="Angleterre" & year==`i'
replace each_war_status="2Austrian1 adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="2Austrian1 adversary" if pays_regroupes=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Hollande" & year==`i'

replace each_war_status="2Austrian1 neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="2Austrian1 neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="2Austrian1 neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="2Austrian1 neutral" if pays_regroupes=="Italie" & year==`i'
replace each_war_status="2Austrian1 neutral" if pays_regroupes=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Portugal" & year==`i'
}

foreach i of num 1744/1748{
replace each_war_status="3Austrian2 adversary" if pays_regroupes=="Angleterre" & year==`i'
replace each_war_status="3Austrian2 adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="3Austrian2 adversary" if pays_regroupes=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Hollande" & year==`i'

replace each_war_status="3Austrian2 neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="3Austrian2 neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="3Austrian2 neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="3Austrian2 neutral" if pays_regroupes=="Italie" & year==`i'
replace each_war_status="3Austrian2 neutral" if pays_regroupes=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Portugal" & year==`i'
}

foreach i of num 1756/1763{
replace each_war_status="4Seven adversary" if pays_regroupes=="Angleterre" & year==`i'
replace each_war_status="4Seven adversary" if pays_regroupes=="Portugal" & year==`i'
replace each_war_status="4Seven adversary" if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="États-Unis d'Amérique" & year==`i'

replace each_war_status="4Seven neutral" if pays_regroupes=="Hollande" & year==`i'
replace each_war_status="4Seven neutral" if pays_regroupes=="Italie" & year==`i'
replace each_war_status="4Seven neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="4Seven neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="4Seven neutral" if pays_regroupes=="Suisse" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
}

foreach i of num 1778/1782{
replace each_war_status="5American adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'

replace each_war_status="5American neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="5American neutral" if pays_regroupes=="Italie" & year==`i'
replace each_war_status="5American neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="5American neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="5American neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="5American neutral" if pays_regroupes=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Portugal" & year==`i'
}

foreach i of num 1792/1803{
replace each_war_status="6Revolutionary adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'

replace each_war_status="6Revolutionary neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="6Revolutionary neutral" if pays_regroupes=="Italie" & year==`i'
replace each_war_status="6Revolutionary neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="6Revolutionary neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="6Revolutionary neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="6Revolutionary neutral" if pays_regroupes=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Portugal" & year==`i'
}

foreach i of num 1803/1814{
replace each_war_status="7Napoleonic adversary" if pays_regroupes=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_regroupes=="Angleterre" & year==`i'

replace each_war_status="7Napoleonic neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="7Napoleonic neutral" if pays_regroupes=="Italie" & year==`i'
replace each_war_status="7Napoleonic neutral" if pays_regroupes=="Levant" & year==`i'
replace each_war_status="7Napoleonic neutral" if pays_regroupes=="Nord" & year==`i'
replace each_war_status="7Napoleonic neutral" if pays_regroupes=="Suisse" & year==`i'
replace each_war_status="7Napoleonic neutral" if pays_regroupes=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_regroupes=="Portugal" & year==`i'
}

encode each_war_status, gen(each_status)
replace each_status=0 if each_status==.

encode all_war_status, gen(all_status)
replace all_status=0 if all_status==.

encode pays_regroupes, gen(pays)

foreach i of num 1/12{
gen year_pays`i'=0
replace year_pays`i'=year if pays==`i'
}

poisson value i.pays year_pays1-year_pays12 i.all_status

poisson value i.pays year_pays1-year_pays12 i.each_status


****gen war lags

gen each_war_lag=""
foreach i of num 1/5{
****austrian
replace each_war_lag="`i' lags 3Austria2 adversary" if pays_regroupes=="Angleterre" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 adversary" if pays_regroupes=="Hollande" & year==1748+`i'

replace each_war_lag="`i' lags 3Austria2 neutral" if pays_regroupes=="Levats" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 neutral" if pays_regroupes=="Nord" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 neutral" if pays_regroupes=="Suisse" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 neutral" if pays_regroupes=="Italie" & year==1748+`i'
replace each_war_lag="`i' lags 3Austria2 neutral" if pays_regroupes=="Portugal" & year==1748+`i'

****seven
replace each_war_lag="`i' lags 4Seven adversary" if pays_regroupes=="Angleterre" & year==1763+`i'
replace each_war_lag="`i' lags 4Seven adversary" if pays_regroupes=="Portugal" & year==1763+`i'

replace each_war_lag="`i' lags 4Seven neutral" if pays_regroupes=="Hollande" & year==1763+`i'
replace each_war_lag="`i' lags 4Seven neutral" if pays_regroupes=="Italie" & year==1763+`i'
replace each_war_lag="`i' lags 4Seven neutral" if pays_regroupes=="Levant" & year==1763+`i'
replace each_war_lag="`i' lags 4Seven neutral" if pays_regroupes=="Nord" & year==1763+`i'
replace each_war_lag="`i' lags 4Seven neutral" if pays_regroupes=="Suisse" & year==1763+`i'

****napoleonic
replace each_war_lag="`i' lags 7Napoleonic adversary" if pays_regroupes=="Angleterre" & year==1814+`i'

replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Italue" & year==1814+`i'
replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Levant" & year==1814+`i'
replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Nord" & year==1814+`i'
replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Suisse" & year==1814+`i'
replace each_war_lag="`i' lags 7Napoleonic neutral" if pays_regroupes=="Portuga" & year==1814+`i'
}

gen all_war_lag=""
foreach i of num 1/5{
***austrian
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Angleterre" & year==1748+`i'
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1748+`i'
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Hollande" & year==1748+`i'

replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Levats" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Nord" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Suisse" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Italie" & year==1748+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Portugal" & year==1748+`i'

***seven
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Angleterre" & year==1763+`i'
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Portugal" & year==1763+`i'

replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Hollande" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Italie" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Levant" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Nord" & year==1763+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Suisse" & year==1763+`i'

***napoleonic
replace all_war_lag="`i' lags Adversary" if pays_regroupes=="Angleterre" & year==1814+`i'

replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Italue" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Levant" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Nord" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Suisse" & year==1814+`i'
replace all_war_lag="`i' lags Neutral" if pays_regroupes=="Portugal" & year==1814+`i'
}

encode each_war_lag, gen(each_lag)
replace each_lag=0 if each_lag==.
encode all_war_lag, gen(all_lag)
replace all_lag=0 if all_lag==.


****reg with lags
poisson value i.pays year_pays1-year_pays12 i.all_status i.all_lag

poisson value i.pays year_pays1-year_pays12 i.each_status i.each_lag


****gen prewar effects

gen each_war_pre=""
foreach i of num 1/4{
****seven
replace each_war_pre="`i' pre 4Seven adversary" if pays_regroupes=="Angleterre" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven adversary" if pays_regroupes=="Hollande" & year==1756-`i'

replace each_war_pre="`i' pre 4Seven neutral" if pays_regroupes=="Levats" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_regroupes=="Nord" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_regroupes=="Suisse" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_regroupes=="Italie" & year==1756-`i'
replace each_war_pre="`i' pre 4Seven neutral" if pays_regroupes=="Portugal" & year==1756-`i'

****american
replace each_war_pre="`i' pre 5American adversary" if pays_regroupes=="Angleterre" & year==1778-`i'
replace each_war_pre="`i' pre 5American adversary" if pays_regroupes=="Portugal" & year==1778-`i'

replace each_war_pre="`i' pre 5American neutral" if pays_regroupes=="Hollande" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_regroupes=="Italie" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_regroupes=="Levant" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_regroupes=="Nord" & year==1778-`i'
replace each_war_pre="`i' pre 5American neutral" if pays_regroupes=="Suisse" & year==1778-`i'

****revolutionary
replace each_war_pre="`i' pre 6Revolutionary adversary" if pays_regroupes=="Angleterre" & year==1792-`i'

replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Italue" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Levant" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Nord" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Suisse" & year==1792-`i'
replace each_war_pre="`i' pre 6Revolutionary neutral" if pays_regroupes=="Portugal" & year==1792-`i'
}

gen all_war_pre=""
foreach i of num 1/4{
***seven
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Angleterre" & year==1756-`i'
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1756-`i'
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Hollande" & year==1756-`i'

replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Levats" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Nord" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Suisse" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Italie" & year==1756-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Portugal" & year==1756-`i'

***american
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Angleterre" & year==1778-`i'
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Portugal" & year==1778-`i'

replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Hollande" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Italie" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Levant" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Nord" & year==1778-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Suisse" & year==1778-`i'

***revolutionary
replace all_war_pre="`i' pre Adversary" if pays_regroupes=="Angleterre" & year==1792+`i'

replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Flandre et autres états de l'Empereur" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Italue" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Levant" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Nord" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Suisse" & year==1792-`i'
replace all_war_pre="`i' pre Neutral" if pays_regroupes=="Portugal" & year==1792-`i'
}

encode each_war_pre, gen(each_pre)
replace each_pre=0 if each_pre==.
encode all_war_pre, gen(all_pre)
replace all_pre=0 if all_pre==.


****reg with prewar
poisson value i.pays year_pays1-year_pays12 i.all_status i.all_pre

poisson value i.pays year_pays1-year_pays12 i.each_status i.each_pre








