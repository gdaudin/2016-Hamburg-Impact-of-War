program plfit, eclass
syntax varname [if] [in] [pw] , x0(real) [Level(cilevel)]

tempvar wi
if "`weight'" == "" gen byte `wi' = 1
else gen `wi' `exp'

local data `varlist'
marksample touse
markout `touse' `data'

	if ! `:length local x0'  {
		qui su `data' if `touse', meanonly
		local x0 = r(min)
	}
	
	if  (`x0' < 0)  {
		di as error "x0 must be positive"
		exit 198
	}
			
	qui replace `touse' = 0 if `data' < `x0'

	qui count if `touse' 
	if (r(N) == 0) 	error 2000 
	else	loc nobs = r(N)

	tempvar su suc
	qui gen `su' = log(`data'/(`x0'-1/2)) if `touse' & `data'>=`x0'
	qui sum `su', meanonly
	local alpha_disc = 1 + `nobs'*r(sum)^(-1)
	// di `alpha_disc'
	qui gen `suc' = log(`data'/`x0') if `touse' & `data'>=`x0'
	qui sum `suc', meanonly
	local alpha_cont = 1 + `nobs'*r(sum)^(-1)
	
	tempvar x1
	qui gen `x1' = log(`data'/`x0') if `data'>=`x0'
	qui sum `x1', meanonly
	local s1 = r(sum)
	local likelihood = `nobs'*log((`alpha_cont'-1)/`x0') - `alpha_cont'*`s1'
	//	di `likelihood'
	
local depn "`data'"

tempname b V 
mat `b' = J(1,1,.)
mat `V' = J(1,1,0)

mat `b'[1,1] = `alpha_disc'
*mat `b'[1,2] = `alpha_cont'

*mat `V'[1,1] = 0
mat `V'[1,1] = (`alpha_cont'-1)^2/`nobs'
*mat `V'[1,2] = 0
*mat `V'[2,1] = 0

matrix rownames `b' = Index
matrix colnames `b' = alpha_cont
matrix rownames `V' = alpha_cont
matrix colnames `V' = alpha_cont

di
di "Estimating power-law exponent with x0 = " `x0'

ereturn post `b' `V', obs(`nobs') depname(`depn') esample(`touse')
ereturn local cmd "plfit"
ereturn display, level(`level')

ereturn scalar alpha_disc=`alpha_disc'
ereturn scalar alpha_cont=`alpha_cont'
ereturn scalar likelihood=`likelihood'
ereturn scalar nobs =`nobs'

end
