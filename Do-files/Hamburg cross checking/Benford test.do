
if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hamburg/"
	global hamburggit "~/Documents/Recherche/2016 Hamburg/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="TIRINDEE" {
	global hamburg "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}






global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"


if "`c(username)'" =="guillaumedaudin" {
	global thesis ~/Documents/Recherche/2016 Hamburg
}


set more off

if  "`c(username)'" =="TIRINDEE" capture use "/Users/Tirindelli/Desktop/hambourg/bdd courante.dta", clear

if  "`c(username)'" =="Tirindelli" capture use "/Users/Tirindelli/Desktop/hambourg/bdd courante.dta", clear

if "`c(username)'" =="guillaumedaudin" {
	use "~/Documents/Recherche/Commerce International Français XVIIIe.xls/Balance du commerce/Retranscriptions_Commerce_France/Données Stata/bdd courante.dta", clear
}



********************************************************************************
*****************************TEST BENFORD***************************************
********************************************************************************


drop if value==0
drop if value==.
gen firstdigit = real(substr(string(value), 1, 1))
drop if firstdigit==.
*firstdigit value, percent
contract firstdigit
set obs 9 
gen x = _n 
gen expected = log10(1 + 1/x) 
twoway histogram firstdigit [fw=_freq], plotregion(fcolor(white)) ///
	graphregion(fcolor(white)) barw(0.5) bfcolor(ltblue) blcolor(navy) ///
	discrete fraction || connected expected x, xla(1/9) ///
	title("Observed and Expected") caption("French source") yla(, ang(h) ///
	format("%02.1f")) legend(off) plotregion(fcolor(white)) ///
	graphregion(fcolor(white))
graph export "$hamburggit/tex2/benford_fr.png", as(png) replace
