
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Documents/Recherche/2016 Hambourg et Guerre/2016-Hamburg-Impact-of-War"
}

else if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE\Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


else if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
}

if "`c(username)'" =="guillaumedaudin" {
insheet using "$hamburg/2016-Hamburg-Impact-of-War/External Data/WarAndPeace.csv", case clear
}

else insheet using "$hamburggit/External Data/WarAndPeace.csv", case clear

reshape long p_,i(year) j(partner_grouping) string
rename p_ war_status

replace partner_grouping="Flandre et autres états de l'Empereur" if strmatch(partner_grouping,"*Flandre*")==1
replace partner_grouping="Levant et Barbarie" if strmatch(partner_grouping,"*Levant*")==1
replace partner_grouping="Outre-mers" if strmatch(partner_grouping,"*Outre*")==1
replace partner_grouping="États-Unis d'Amérique" if strmatch(partner_grouping,"*ÉtatsUnis*")==1
drop if partner_grouping=="États-Unis d'Amérique" & year <=1777
drop v*

save "$hamburg/database_dta/WarAndPeace.dta",  replace
