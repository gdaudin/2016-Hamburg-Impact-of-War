

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires Git/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\tirindee\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
}


use "$hamburg/database_dta/WarAndPeace.dta", clear
drop if partner_grouping=="All" | partner_grouping=="All_ss_outremer"



replace war_status="colonies" if partner_grouping=="Outre-mers"
bys year war_status : gen nbr_pays=_N


**********Graph pour nombre neutres, alliés et foes
replace war=0 if year==1802
gen war_nbr_pays=war*nbr_pays
replace war_nbr_pays=. if war==0


twoway (bar war_nbr_pays year, cmissing(n)) if war_status=="neutral", ///
		yscale(range(0 8)) ytitle("Number of neutral trade partners") ///
		name(neutral, replace) plotregion(fcolor(white)) graphregion(fcolor(white))

twoway (bar war_nbr_pays year, cmissing(n)) if war_status=="ally", ///
		yscale(range(0 8)) ytitle("Number of allied trade partners") ///
		name(ally, replace) plotregion(fcolor(white)) graphregion(fcolor(white))
		
twoway (bar war_nbr_pays year, cmissing(n)) if war_status=="foe", ///
		yscale(range(0 8)) ytitle("Number of ennemy trade partners") ///
		name(foe, replace) plotregion(fcolor(white)) graphregion(fcolor(white))

graph combine (neutral ally foe), ycommon plotregion(fcolor(white)) graphregion(fcolor(white))
graph export "$hamburggit/Results/Loss graphs/by war_status/Number of protagonists.png", replace
graph export "$hamburggit/Paper - Impact of War/Paper/Number of protagonists.png", replace
export delimited "$hamburg/database_csv/number_protagonist.csv", replace




