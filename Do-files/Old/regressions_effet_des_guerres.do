


if "`c(username)'" =="guillaumedaudin" {
	global hamburg "~/Documents/Recherche/2016 Hamburg/"
	global hamburggit "~/Documents/Recherche/2016 Hamburg/2016-Hamburg-Impact-of-War"
}

if "`c(username)'" =="tirindee" {
	global hamburg "C:\Users\TIRINDEE\Google Drive\ETE/Thesis"
	global hamburggit "C:\Users\TIRINDEE\Google Drive\ETE/Thesis/Data/do_files/Hamburg"
}


if "`c(username)'" =="Tirindelli" {
	global hamburg "/Users/Tirindelli/Google Drive/ETE/Thesis"
	global hamburggit "/Users/Tirindelli/Google Drive/ETE/Thesis/Data/do_files/Hamburg"
}



set more off




capture program drop reg_choc_diff
program reg_choc_diff
args  reg_type product_class interet inourout weight outremer predicted

*Exemple : reg_choc_dif poisson sitc noweight Blockade Exports 0 1 
*Exemple : reg_choc_dif reg sitc value Blockade Exports 0 1

clear

if "`reg_type'"=="poisson" local reg_option "vce(robust) iterate(40)" 
if "`reg_type'"=="poisson" local explained_variable "value" 
if "`reg_type'"=="reg" local explained_variable "lnvalue" 


if "`product_class'"=="sitc" use "$hamburg/database_dta/allcountry2_sitc.dta", clear
if "`product_class'"=="hamburg" use "$hamburg/database_dta/allcountry2.dta", clear

gen lnvalue=ln(value)
replace lnvalue=ln(0.00000000000001) if value==0

capture replace sitc18_en="Raw mat fuel oils" if sitc18_en=="Raw mat; fuel; oils"

encode country_grouping, gen(pays)
if "`product_class'"=="sitc" encode sitc18_en, gen(product)
if "`product_class'"=="hamburg" encode hamburg_classification, gen(product)

merge m:1 country_grouping year using "$hamburg/database_dta/WarAndPeace.dta"

drop if _merge==2

replace war_status = "Peace" if war_status==""


gen break=(year>1795)



if `outremer'==0 drop if country_grouping=="Outre-mers"

if "`inourout'"=="XI" {
	order exportsimports value
	collapse (sum) value, by(year-break)
	gen exportsimports="XI"
}




if `predicted'==0 drop if predicted==1

encode  war_status, gen(war_status_num)
replace war_status_num=0 if war_status=="Peace"

gen year_of_war=year
replace year_of_war=year_of_war-1744 if year >=1744 & year<=1748
replace year_of_war=year_of_war-1756 if year >=1756 & year<=1763
replace year_of_war=year_of_war-1778 if year >=1778 & year<=1783
replace year_of_war=year_of_war-1793 if year >=1793 & year<=1801
replace year_of_war=year_of_war-1803 if year >=1803 & year<=1815
replace year_of_war=0 if year_of_war==year

gen war_peace =""


gen noweight =1

if "`interet'" =="R&N" {
	replace war_peace = "Mercantilist_War" if war_status!="Peace" & year>=1744
	replace war_peace = "R&N War" if war_status_num!=. & year>=1793
}


if "`interet'" =="Blockade" {
	replace war_peace = "Mercantilist_War" if war_status!="Peace" & year>=1744
	replace war_peace = "Blockade" if war_status_num!=. & year>=1808 & year <=1815
	replace year_of_war=year-1808 if year >=1808 & year<=1815
}


if "`interet'" =="War" {
	replace war_peace = "War" if war_status_num!=0 & year>=1744
}


replace war_peace="Peace" if war_peace==""
encode war_peace, gen(war_peace_num)
replace war_peace_num=0 if war_peace=="Peace"

replace war_status="Peace" if war_peace=="Peace"
replace war_status_num=0 if war_peace=="Peace"


tabulate war_status_num war_status if war_peace=="Peace"


preserve


collapse (sum) value, by(pays year exportsimports war_status_num year_of_war war_peace_num noweight)

generate lnvalue=ln(value)

*reg with no product/sector differentiation
eststo choc_diff_status_noprod: `reg_type' `explained_variable'  ///
    i.war_status_num#i.war_peace_num  c.year_of_war#i.war_status_num#i.war_peace_num ///
	i.pays c.year#i.pays ///	
	if exportsimports=="`inourout'" ///
    [iweight=`weight'], `reg_option'
	
	
	
restore

*reg with priduct FE and trend
eststo choc_diff_status: `reg_type' `explained_variable'  /// 
	i.war_status_num#i.war_peace_num  c.year_of_war#i.war_status_num#i.war_peace_num ///
	i.pays#i.product  c.year#i.pays#i.product ///	
	if exportsimports=="`inourout'" ///
	[iweight=`weight'], `reg_option'
	

*reg with product differantiation but no war status diff.
eststo choc_diff_goods: `reg_type' `explained_variable' /// 
	i.product#i.war_peace_num c.year_of_war#i.product#i.war_peace_num ///
	i.pays#i.product  c.year#i.pays#i.product ///	
	if exportsimports=="`inourout'" ///
	[iweight=`weight'], `reg_option'
	
preserve

collapse (sum) value, by(product year exportsimports year_of_war war_peace_num noweight)
gen lnvalue=ln(value)

*reg with product differantiation but no war status diff. no country FE
eststo choc_diff_goods_nopays: `reg_type' `explained_variable' ///
	i.product#i.war_peace_num c.year_of_war#i.product#i.war_peace_num ///
	i.product  c.year#i.product ///	
	if exportsimports=="`inourout'" ///
    [iweight=`weight'], `reg_option'
	
	
restore
	
eststo choc_diff_status_no_wart: `reg_type' `explained_variable'  /// 
	i.war_status_num#i.war_peace_num  ///
	i.pays#i.product  c.year#i.pays#i.product ///	
	if exportsimports=="`inourout'" ///
	[iweight=`weight'], `reg_option'

	
eststo choc_diff_goods_no_wart: `reg_type' `explained_variable' /// 
	i.war_peace_num#i.product  ///
	i.pays#i.product  c.year#i.pays#i.product ///	
	if exportsimports=="`inourout'" ///
	[iweight=`weight'], `reg_option'

		
	
	/*
	
eststo `inourout'_eachproduct2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status_sitc i.pays#1.break c.year#1.break ///
	if exportsimports=="`inourout'", vce(robust) iterate(40)	
eststo `inourout'_eachsitc3: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status i.pays#1.break c.year#1.break if ///
	exportsimports=="`inourout'", vce(robust) iterate(40)
	
*/

if "`c(username)'" =="guillaumedaudin" {
esttab choc_diff_status_noprod ///
        choc_diff_status ///
		choc_diff_status_no_wart ///
		choc_diff_goods_nopays ///
		choc_diff_goods ///
		choc_diff_goods_no_wart ///
/*	`inourout'_eachsitc2 ///
	`inourout'_eachsitc3  ///
*/	using "$hamburggit/Tables/reg_choc_diff_`reg_type'_`product_class'_`interet'_`inourout'_`weight'_`outremer'_`predicted'.csv", ///
	label replace mtitles("war # status_noprod" /// 
	"war # status" ///
	"war # status no wart" ///
	"war # goods_noprod" ///
	"war # goods" ///
	"war # goods no wart") 
}

else{ 
if "`interet'"=="Blockade" local option 
if "`interet'"=="Blockade" local option keep 

esttab choc_diff_status_noprod ///
        choc_diff_status ///
		choc_diff_status_no_wart ///
		choc_diff_goods_nopays ///
		choc_diff_goods ///
		choc_diff_goods_no_wart ///
		using "$hamburggit/Impact of War/Paper/reg_choc_diff_`reg_type'_`product_class'_`interet'_`inourout'_`weight'_`outremer'_`predicted'.tex", ///
	label replace mtitles("war status_noprod" /// 
	"war status" ///
	"war status no wart" ///
	"war goods_noprod" ///
	"war goods" ///
	"war goods no wart") style(tex) substitute(# $\times$ _ "" \sym{ "" *} * R&N R\&N)
}		

esttab choc_diff_status_noprod ///
        choc_diff_status ///
		choc_diff_status_no_wart ///
		choc_diff_goods_nopays ///
		choc_diff_goods ///
		choc_diff_goods_no_wart, label
	
eststo clear



end
reg_choc_diff poisson hamburg Blockade XI noweight 1 1

exit




reg_choc_diff reg hamburg Blockade Exports noweight 0 0
reg_choc_diff reg hamburg Blockade Exports noweight 1 0
reg_choc_diff reg hamburg Blockade Exports noweight 1 1

reg_choc_diff poisson hamburg Blockade Exports noweight 0 1

reg_choc_diff reg hamburg Blockade XI noweight 1 0
reg_choc_diff reg hamburg Blockade XI value 1 0

reg_choc_diff reg hamburg War Exports noweight 0 0
reg_choc_diff reg hamburg War Exports value 0 0

reg_choc_diff poisson hamburg Blockade XI noweight 0 0
reg_choc_diff poisson hamburg Blockade XI value 1 0

reg_choc_diff reg hamburg Blockade XI noweight 0 1

reg_choc_diff reg hamburg Blockade XI noweight 0 0
reg_choc_diff reg hamburg Blockade XI value 0 0
reg_choc_diff reg hamburg Blockade XI noweight 0 0
reg_choc_diff reg hamburg Blockade XI noweight 0 1




reg_choc_diff poisson sitc Blockade Exports value 0 1
reg_choc_diff reg sitc Blockade Exports noweight 0 0
reg_choc_diff reg sitc Blockade Exports noweight 0 1
reg_choc_diff reg sitc Blockade Exports value 0 0
reg_choc_diff reg sitc Blockade Exports value 0 1

reg_choc_diff reg sitc Blockade XI value 0 1
reg_choc_diff reg sitc Blockade XI noweight 0 1
reg_choc_diff poisson sitc Blockade XI noweight 0 1
reg_choc_diff poisson sitc Blockade XI value 0 1
reg_choc_diff reg sitc R&N XI value 0 1
reg_choc_diff reg sitc R&N XI noweight 0 1
reg_choc_diff poisson sitc R&N XI value 0 1
reg_choc_diff reg sitc War Exports value 0 0


/*
reg_choc_diff sitc Blockade Exports value 1 1 


reg_choc_diff sitc Blockade Imports value 1 1

reg_choc_diff sitc Blockade Exports noweight 0 1
reg_choc_diff sitc Blockade Imports noweight 0 1



 
reg_choc_diff sitc Blockade XI 0 1 
reg_choc_diff sitc R&N Exports 0 1
reg_choc_diff sitc R&N Imports 0 1 
reg_choc_diff sitc R&N XI 0 1 

*args product_class interet inourout weight outremer predicted
*args  reg_type product_class interet inourout weight outremer predicted
