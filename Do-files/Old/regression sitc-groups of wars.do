global thesis "/Users/Tirindelli/Google Drive/ETE/Thesis"
*global thesis "C:\Users\TIRINDEE\Google Drive\ETE\Thesis"


set more off

use "$thesis/database_dta/allcountry2_sitc", clear

replace sitc18_en="Raw mat fuel oils" if sitc18_en=="Raw mat; fuel; oils"

encode pays_grouping, gen(pays)
encode sitc18_en, gen(sitc)

gen break=(year>1795 & sitc==3)

********************************************************************************
***************RE-RUN REGRESSIONS WITH GROUPS OF WARS***************************
********************************************************************************


/*gen one dummy for each war and 3 dummies for three groups of wars 
(Polish Austrian1 // Austrian2 Seven American // Revolutionary Napoleonic)
I generate them as string and then encode them to avoid creating 
and labelling a 1000 dummies*/

gen each_war_status=""
gen all_war_status=""

foreach i of num 1733/1738{
replace each_war_status="Land_war adversary" ///
	if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'

replace each_war_status="Land_war neutral" if pays_grouping=="Hollande" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Portugal" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Italie" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
}

foreach i of num 1733/1738{
replace each_war_status="Land_war allied" if ///
	each_war_status!="Land_war neutral" & ///
	each_war_status!="Land_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}


foreach i of num 1740/1743{
replace each_war_status="Land_war adversary" ///
	if pays_grouping=="Angleterre" & year==`i'
replace each_war_status="Land_war adversary" ///
	if pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="Land_war adversary" ///
	if pays_grouping=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==`i'

replace each_war_status="Land_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="Land_war neutral" if pays_grouping=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
}

foreach i of num 1740/1743{
replace each_war_status="Land_war allied" if each_war_status!="Land_war neutral" ///
	& each_war_status!="Land_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}


foreach i of num 1744/1748{
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Hollande" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==`i'

replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Portugal" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
}

foreach i of num 1744/1748{
replace each_war_status="Mercantilist_war allied" if ///
	each_war_status!="Mercantilist_war neutral" & ///
	each_war_status!="Mercantilist_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}

foreach i of num 1756/1763{
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'

replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Hollande" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Suisse" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Hollande" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
}

foreach i of num 1756/1763{
replace each_war_status="Mercantilist_war allied" if ///
	each_war_status!="Mercantilist_war neutral" & ///
	each_war_status!="Mercantilist_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}

foreach i of num 1778/1782{
replace each_war_status="Mercantilist_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'

replace each_war_status="Mercantilist_war neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Italie" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Suisse" & year==`i'
replace each_war_status="Mercantilist_war neutral" if pays_grouping=="Portugal" & year==`i'

replace all_war_status="Neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Italie" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Portugal" & year==`i'
}

foreach i of num 1778/1782{
replace each_war_status="Mercantilist_war allied" if each_war_status!="Mercantilist_war neutral" ///
	& each_war_status!="Mercantilist_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & ///
	all_war_status!="Neutral" & year==`i'
}

foreach i of num 1792/1795{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Espagne" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Hollande" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace each_war_status="R&N_war adversary" if pays_grouping=="Italie" & year==`i'


replace all_war_status="Adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Espagne" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Italie" & year==`i'


replace each_war_status="R&N_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="R&N_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="R&N_war neutral" if pays_grouping=="Suisse" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Suisse" & year==`i'
}

foreach i of num 1792/1795{
replace each_war_status="R&N_war allied" if each_war_status!="R&N_war neutral" ///
	& each_war_status!="R&N_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" & ///
	all_war_status!="Neutral" & year==`i'
}

foreach i of num 1796/1802{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace each_war_status="R&N_war adversary" if pays_grouping=="Italie" & year==`i'

replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Italie" & year==`i'

replace each_war_status="R&N_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="R&N_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="R&N_war neutral" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}

foreach i of num 1796/1802{
replace each_war_status="R&N_war allied" if each_war_status!="R&N_war neutral" ///
	& each_war_status!="R&N_war adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}


foreach i of num 1803/1814{
replace each_war_status="R&N_war allied" if year==`i'
replace all_war_status="Allied" if year==`i'
}

foreach i of num 1803/1814{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Angleterre" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Angleterre" & year==`i'
}

foreach i in 1805 1809{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1805/1809{
replace each_war_status="R&N_war allied" if ///
	each_war_status!="Napoleonic neutral" & ///
	each_war_status!="Napoleonic adversary" & year==`i'
replace all_war_status="Allied" if all_war_status!="Adversary" ///
	& all_war_status!="Neutral" & year==`i'
}

foreach i in 1806 1807{
replace each_war_status="R&N_war neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Neutral" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1813/1815{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Flandre et autres états de l'Empereur" & year==`i'
}

foreach i of num 1800/1807{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Portugal" & year==`i'
}
foreach i of num 1809/1815{
replace each_war_status="R&N_war adversary" if pays_grouping=="Portugal" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Portugal" & year==`i'
}

*****1806-1812 germany is allied
foreach i of num 1806/1807{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}
foreach i of num 1813/1815{
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
replace all_war_status="Adversary" if ///
	pays_grouping=="Allemagne et Pologne (par terre)" & year==`i'
}

foreach i of num 1808/1815{
replace each_war_status="R&N_war adversary" if pays_grouping=="Espagne" & year==`i'
replace all_war_status="Adversary" if pays_grouping=="Espagne" & year==`i'
}

foreach i of num 1803/1815{
replace each_war_status="R&N_war neutral" if pays_grouping=="Levant" & year==`i'
replace each_war_status="R&N_war neutral" if pays_grouping=="Nord" & year==`i'
replace each_war_status="R&N_war neutral" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'

replace all_war_status="Neutral" if pays_grouping=="Levant" & year==`i'
replace all_war_status="Neutral" if pays_grouping=="Nord" & year==`i'
replace all_war_status="Neutral" if ///
	pays_grouping=="États-Unis d'Amérique" & year==`i'
}

replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Suisse" & year==1815
replace each_war_status="R&N_war adversary" if ///
	pays_grouping=="Hollande" & year==1815

replace all_war_status="Adversary" if pays_grouping=="Suisse" & year==1815
replace all_war_status="Adversary" if pays_grouping=="Hollande" & year==1815

encode each_war_status, gen(each_status) 
egen each_status_sitc=group(each_status sitc), label
replace each_status_sitc=0 if each_status_sitc==. /* I do this to have peace 
														as reference cat*/

encode all_war_status, gen(all_status) 
egen all_status_sitc=group(all_status sitc), label
replace all_status_sitc=0 if all_status_sitc==.   /* I do this to have peace 
														as reference cat*/

/*------------------------------------------------------------------------------
					regress with GROUPS OF WAR
------------------------------------------------------------------------------*/
/*	ALL	REGRESSIONS ARE FIRST RUN WITH NO BREAKS AND THEN WITH ONE BREAK	*/

gen lnvalue=ln(value)
replace exportsimports="Exports" if exportsimports=="Exportations"

levelsof exportsimports, local(exportsimports) 

foreach inourout in `exportsimports'{

****groups of wars interacted with sitc and with groups
eststo `inourout'_eachsitc1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status_sitc ///
	if exportsimports=="`inourout'", vce(robust) iterate(40)
eststo `inourout'_eachsitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status_sitc i.pays#1.break c.year#1.break ///
	if exportsimports=="`inourout'", vce(robust) iterate(40)	
eststo `inourout'_eachsitc3: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.each_status i.pays#1.break c.year#1.break if ///
	exportsimports=="`inourout'", vce(robust) iterate(40)
	
****wars interacted with groups only
eststo `inourout'_allsitc1: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.all_status_sitc ///
	if exportsimports=="`inourout'", vce(robust) iterate(40)
eststo `inourout'_allsitc2: poisson value i.pays#i.sitc c.year#i.pays ///
	c.year#i.sitc i.all_status_sitc i.pays#1.break c.year#1.break if ///
	exportsimports=="`inourout'", vce(robust) iterate(40)



esttab `inourout'_eachsitc1 `inourout'_eachsitc2 ///
	`inourout'_eachsitc3 using ///
	"$thesis/Data/do_files/Hamburg/Tables/allcountry2_each_sitc_`inourout'.csv", ///
	label replace mtitles("SITC#each_war no breaks" ///
	"SITC#each_war 1795 break" "each_war no breaks")
	
esttab `inourout'_allsitc1 `inourout'_allsitc2 using ///
	"$thesis/Data/do_files/Hamburg/Tables/allcountry2_all_sitc_`inourout'.csv", ///
	label replace mtitles("SITC#all_war no breaks" ///
	"SITC#all_war 1795 break" )

eststo clear

}

codebook value
codebook value
codebook value
codebook value
