
capture program drop ACP
program ACP
args plantation_yesno



use "/Users/guillaumedaudin/Documents/Recherche/2016 Hambourg et Guerre/database_dta/temp_for_hotelling.dta", clear

keep if best_guess_national_product==1 




collapse (sum) value, by(year product_sitc_simplEN export_import period_str)


if "`plantation_yesno'"=="no" drop if product_sitc_simplEN=="Plantation foodstuffs"


bysort year export_import : egen total=sum(value)
gen percent= value/total

rename product_sitc_simplEN sitc_simplen
merge m:1 sitc_simplen using "$hamburggit/External Data/classification_product_simplEN_simplEN_short.dta"
keep if _merge==3
drop _merge
drop sitc_simplen
rename sitc_simplen_short product_sitc_simplEN 

gen id=export_import+"_"+product_sitc_simplEN
replace id=subinstr(id," ","",.)
drop export_import product_sitc_simplEN

keep percent year id
rename percent p

fillin year id
replace p = 0 if _fillin==1
drop _fillin



reshape wide p, i(year) j(id) string 
merge 1:1 year using "$hamburg/database_dta/FR_loss.dta"
drop if _merge==2

biplot p*, rowopts(name(year)) autoaspect rowlabel(year) norow scheme(s1mono)
pca p*

predict pc1 pc2, score
corr pc1 pc2 loss
corr pc1 pc2 loss year

regress pc1 loss year
regress pc2 loss year


end 


ACP no
