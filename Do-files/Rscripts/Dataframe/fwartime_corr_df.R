fwartime_corr_df = function(fwar_strat, findep, fonlywar, frunning_sum, log_max){
  
  if(fonlywar == 0 & frunning_sum==0) halt()
  
  if(findep=="num_prizes" | findep=="num_prizes_priv" | findep=="prizes_import") 
    fwar_strat$loss = fwar_strat$loss*100
  
  names(fwar_strat)[names(fwar_strat) == findep] = "findep"
  if(log_max=="max") fwar_strat$findep = fwar_strat$findep/max(fwar_strat$findep, na.rm = TRUE)

  if(frunning_sum==0){
    if(log_max=="log") fwar_strat$findep = log(fwar_strat$findep)
    fDwar_strat = fwar_strat[fwar_strat$war==1,]
    fDwar_strat$Dfindep = fDwar_strat$findep
  }else{
    fwar_strat$findep = ifelse(is.na(fwar_strat$findep), 0, fwar_strat$findep)
    fwar_strat = setDT(fwar_strat)
    fDwar_strat = fwar_strat[,Dfindep:=sapply(1:.N,function(k) sum(0.9**(k-1:k)*head(findep,k)))]
    if(log_max=="log") fDwar_strat$Dfindep = log(fDwar_strat$Dfindep)
    if(fonlywar==1) fDwar_strat = fwar_strat[fwar_strat$war==1,]
  }
  
  m = lm(fDwar_strat$loss~fDwar_strat$Dfindep)
  df = data.frame(
    "var" = findep,
    "coeff" = round(m$coefficients[2], 3),
    "pval" = round(summary(m)$coefficients[2,4], 3),
    "R2" = round(summary(m)$r.squared, 3)
  )
  return(df)
}