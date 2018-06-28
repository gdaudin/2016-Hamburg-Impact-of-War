
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

if "`c(username)'" =="guillaumedaudin" {
insheet using "$hamburg/2016-Hamburg-Impact-of-War/External Data/WarAndPeace.csv", case clear
}

else insheet using "$hamburggit/External Data/WarAndPeace.csv", case clear

reshape long p_,i(year) j(grouping_classification) string
rename p_ war_status

replace grouping_classification="Flandre et autres états de l'Empereur" if strmatch(grouping_classification,"*Flandre*")==1
replace grouping_classification="Levant et Barbarie" if strmatch(grouping_classification,"*Levant*")==1
replace grouping_classification="Outre-mers" if strmatch(grouping_classification,"*Outre*")==1
replace grouping_classification="États-Unis d'Amérique" if strmatch(grouping_classification,"*ÉtatsUnis*")==1
drop if grouping_classification=="États-Unis d'Amérique" & year <=1777

save "$hamburg/database_dta/WarAndPeace.dta",  replace
