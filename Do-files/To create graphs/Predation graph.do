

if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hambourg et Guerre"
	global hamburggit "~/Répertoires GIT/2016-Hamburg-Impact-of-War"
}

else if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\tirindee\Google Drive\ETE\Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Volumes/GoogleDrive/My Drive/Hamburg"
	global hamburggit "/Users/Tirindelli/Desktop/HamburgPaper"
}



use "$hamburg/database_dta/English&French_prizes.dta",  clear

keep if year >=1740 & year <=1820
 
 twoway(connected Total_Prize_value year,  cmissing(n)) (connected FR_Prize_value year,  cmissing(n)) (line Frenchincome year, cmissing(n)), /*
  */ ytitle("tons of silver", axis(1)) scheme(s1mono) /*
  */ legend(rows(3) order (1 "English gross income from predation" 2 "English gross income from predation on France" 3 "French gross predation income")) 
 graph export "$hamburggit/Paper - Impact of War/Paper/FR&BR_Prizes_value_gross.png", replace
 
 


  twoway(connected English_net_income year,  cmissing(n)) (line French_net_income year,  cmissing(n)) , /*
  */ ytitle("tons of silver", axis(1)) scheme(s1mono) /*
  */ legend(rows(2) order (1 "English income from predation, net of privateers’ outfiting" 2 "French income from predation, net of privateers' outfitting")) 
 graph export "$hamburggit/Paper - Impact of War/Paper/FR&BR_Prizes_value_net.png", replace
 
 


   twoway (line Total_Prize_value year, lpattern(dash) lcolor(red)  cmissing(n)) ///
   (line FR_Prize_value year,  cmissing(n) lcolor(red)) ///
   (line Frenchincome year, cmissing(n) lcolor(blue) msize(tiny)) ///
   (connected Privateers_Investment year,  lcolor(red) mcolor(red) cmissing(n) msize(tiny)) /*
   */ (connected Frenchinvestment year,  lcolor(blue) mcolor(blue) cmissing(n) msize(tiny)), /*
  */ yline(0, lcolor(black))  ytitle("tons of silver", axis(1)) scheme(s1color) /*
  */ legend(rows(5) order (1 "English income from all prizes" 2 "English income from French prizes" /*
  */ 3 "French income from privateering" 4 "English private investment in privateering" /*
  */ 5 "French private investment in privateering"))
 graph export "$hamburggit/Paper - Impact of War/Paper/FR&BR_Predation.png", replace

 
 use "$hamburg/database_dta/English&French_prizes.dta",  clear

    twoway (line Total_Prize_value year, lpattern(dash) lcolor(red)  cmissing(n)) ///
   (line FR_Prize_value year,  cmissing(n) lcolor(red)) ///
   (line Frenchincome year, cmissing(n) lcolor(blue) msize(tiny)) ///
   (connected Privateers_Investment year,  lcolor(red) mcolor(red) cmissing(n) msize(tiny)) /*
   */ (connected Frenchinvestment year,  lcolor(blue) mcolor(blue) cmissing(n) msize(tiny)), /*
  */ yline(0, lcolor(black))  ytitle("tons of silver", axis(1)) scheme(s1color) /*
  */ legend(rows(5) order (1 "English income from all prizes" 2 "English income from French prizes" /*
  */ 3 "French income from privateering" 4 "English private investment in privateering" /*
  */ 5 "French private investment in privateering"))
 graph export "$hamburggit/Paper - Impact of War/Paper/FR&BR_Predation--from 1688.png", replace