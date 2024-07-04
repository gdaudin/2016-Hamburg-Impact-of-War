if "`c(username)'"=="guillaumedaudin" ///
		global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
		global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"

if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Google Drive/Hamburg/Paper"
}

if "`c(username)'" =="tirindee" {
	global hamburg "G:\Il mio Drive\Hamburg"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


cd "~/Répertoires Git/google-ngrams"

/*
*python script getngrams.py, args(War_INF,war_INF,France_INF,french_INF,cotton_INF,industry_INF,manufacture_INF,textile_INF,factory_INF ///
*				-startYear=1700 -endYear=1850 -corpus=eng_gb_2012)

python3 getngrams.py War_INF,war_INF,France_INF,french_INF,cotton_INF, Cotton_INF, industry_INF, Industry_INF, manufacture_INF, Manufacture_INF,textile_INF, Textile_INF,factory_INF, Factory_INF -startYear=1700 -endYear=1850 -corpus=eng_gb_2019
*/

				
insheet using "War_INF_war_INF_France_INF_french_INF_cotton_INF_Cotton_INF_industry_INF_Industry_INF_manufacture_INF_Manufacture_INF_textile_INF_Textile_INF_factory_INF_Factory_INF-eng_gb_2019-1700-1850-3-caseSensitive.csv", clear


egen War = rsum(war-v9)
egen France=rsum(france-frenches)
egen Industry=rsum(cotton-v38)

label var France "France and french"
label var Industry "Cotton, textile, industry, manufacture and factory"

twoway (line France year) (line War year)  (line Industry year), scheme(stsj) note("Including inflexions, not case-sensitive") ///
	ytitle("Share in Google Books" "British English corpus (2019)", margin(medium))

graph export "$hamburggit/Paper - Impact of War/Paper/Ngram.png", replace
