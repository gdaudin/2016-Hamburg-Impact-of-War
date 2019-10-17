
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

insheet using "$hamburggit/External Data/HCA34_prizes.csv", case clear

save "$hamburg/database_dta/HCA34_prizes.dta",  replace

histogram yearofsentence, discrete

keep yearofsentence
rename yearofsentence year
gen source ="HCA34"

save "$hamburg/database_dta/English_prizes.dta",  replace

**************************

insheet using "$hamburggit/External Data/GBNavy_prizes.csv", case clear

gen year=real(substr(YeartoNavy,1,4))



save "$hamburg/database_dta/GBNavy_prizes.dta",  replace


histogram year, discrete

keep if HowtoNavy=="Taken"

histogram year, discrete freq

keep year
gen source ="GBNavy"
append using "$hamburg/database_dta/English_prizes.dta"
save "$hamburg/database_dta/English_prizes.dta",  replace


**************************


insheet using "$hamburggit/External Data/Other_prizes.csv", case clear
rename Year year
histogram year, discrete freq

save "$hamburg/database_dta/Other_prizes.dta",  replace

keep year
keep if year >=1650
generate source="Other"
append using "$hamburg/database_dta/English_prizes.dta"
save "$hamburg/database_dta/English_prizes.dta",  replace

histogram year, discrete freq
