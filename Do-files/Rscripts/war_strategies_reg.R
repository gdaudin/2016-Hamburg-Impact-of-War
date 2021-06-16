rm(list = ls())
library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
library(whoami)
library(zoo)
library(data.table)
library(stargazer)

if(username()=="Tirindelli"){
  HamburgPaperDir = "/Users/Tirindelli/Desktop/HamburgPaper/"
  HamburgDir = "/Volumes/GoogleDrive/My Drive/Hamburg/"
}

RscriptDir = "Do-files/Rscripts/"
GraphDir = "Graphs/"
DataframeDir = "Dataframe/"
NewgraphsDir = "New graphs/"
PaperDir = "Paper - Impact of War/Paper/"
AuxFuncionDir = "AuxFunction/"


source(paste(HamburgPaperDir, RscriptDir,DataframeDir,"fwartime_corr_df.R", sep = "" ))
source(paste(HamburgPaperDir, RscriptDir,AuxFuncionDir,"halt.R", sep = "" ))

loss = read.csv(paste(HamburgDir,"database_csv/mean_annual_loss.csv", sep = ""))
loss = loss[c("year", "loss", "loss_nomemory" )]

colony_loss = read.csv(paste(HamburgDir,"database_csv/colony_loss.csv", sep = ""))
colony_loss = colony_loss[c("year", "weight_france")]

naval_sup = read.csv(paste(HamburgDir,"database_csv/naval_supremacy.csv", sep = ""))
naval_sup = naval_sup[c("year", "France_vs_GB", "ally_vs_foe", "allyandneutral_vs_foe")]

prizes = read.csv(paste(HamburgDir,"database_csv/prizes.csv", sep = ""))
prizes = prizes[c("year", "Number_of_prizes_Total_All", 
                  "Number_of_prizes_Privateers_All", "importofprizegoodspoundsterling")]

hotelling = read.csv(paste(HamburgDir,"database_csv/temp_for_hotelling.csv", sep = ""))

#merge loss function db with wartime strageties db
war_strat = left_join(loss, colony_loss, by = "year")
war_strat = left_join(war_strat, naval_sup, by = "year")
war_strat = left_join(war_strat, prizes, by = "year")

#rename variables
names(war_strat)[names(war_strat) == "importofprizegoodspoundsterling"] = "prizes_import"
names(war_strat)[names(war_strat) == "Number_of_prizes_Total_All"] = "num_prizes"
names(war_strat)[names(war_strat) == "Number_of_prizes_Privateers_All"] = "num_prizes_priv"
names(war_strat)[names(war_strat) == "weight_france"] = "colonial_empire"

#create war variable
war_strat$Wcut= cut(war_strat$year, 
                     breaks=c(1739,1748,1755,1763,1777,1783, 1792, 1807,1815, 1840), 
                     labels = FALSE)
war_strat$war = ifelse(((war_strat$Wcut %% 2) == 0), 0, 1)
war_strat$war = ifelse((war_strat$Wcut == 9), 0, war_strat$war)
war_strat$war = ifelse((war_strat$Wcut == 8), 1, war_strat$war)

#create major battle variable
war_strat$battle= cut(war_strat$year, 
                    breaks=c(1739,1746,1747,1758,1760,1761,1762, 1793, 1794,1797, 1798, 1804, 1806,1808, 1809, 1821), 
                    labels = FALSE)
war_strat$battle_dummy = ifelse(((war_strat$Wcut %% 2) == 0), 1, 0)

indep_label = c("Prizes import", "Number of prizes", "Privateers \n prizes", 
                "Colonial Empire", "France vs Britain", "France vs Britain \n + allies", 
                "France vs Britain \n + allies \n + foes", "Battle dummy")
log_max = "max"

#apply function to all wartime strategies var of interest 
#for only war years and no running sum
onlywar = 1
running_sum = 0
dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[1]], 
  fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[1]]
)
#make a df with results of univariate regression
max_wartime_nosum_corr = bind_rows(dflist)

#make a df with results of multivariate regression for only war years and no running sum
max_wartime_nosum_mreg = data.frame(
  year = war_strat[war_strat$war==1,]$year, 
  loss = war_strat[war_strat$war==1,]$loss, 
  prizes_import=fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[2]],
  num_prizes = fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[2]],
  num_prizes_priv = fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[2]],
  colonial_empire = fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[2]], 
  France_vs_GB = fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[2]],
  ally_vs_foe = fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[2]],
  allyandneutral_vs_foe = fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[2]], 
  battle_dummy = fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[2]]
)
m = lm(loss~prizes_import + num_prizes+num_prizes_priv+colonial_empire+
         France_vs_GB+ally_vs_foe+allyandneutral_vs_foe + battle_dummy,
       data = max_wartime_nosum_mreg)
stargazer(fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[3]], 
          fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[3]],
          m, font.size = "small", type = 'latex', covariate.labels= indep_label,
          title="Single and multivariate regressions for war years only",
          label = "tab:max_wartime_nosum_mreg", column.sep.width = "-15pt",
          align=TRUE, dep.var.caption = c("Loss"), dep.var.labels.include = FALSE,
          omit.stat=c("LL","ser","f"), no.space=TRUE, model.numbers=FALSE,
          out = paste(HamburgPaperDir, PaperDir,"max_wartime_nosum_mreg.tex", sep = ""))
rm(dflist, onlywar, running_sum, m)

#apply function to all wartime strategies var of interest 
#for only war years and running sum
onlywar = 1
running_sum = 1

dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[1]], 
  fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[1]]
)

#make a df with results
max_wartime_sum_corr = bind_rows(dflist)

#make a df with results of multivariate regression for only war years and running sum 
#(battle dummy is included as a regular dummy) 
max_wartime_sum_mreg = data.frame(
  year = war_strat[war_strat$war==1,]$year, 
  loss = war_strat[war_strat$war==1,]$loss, 
  prizes_import=fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[2]],
  num_prizes = fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[2]],
  num_prizes_priv = fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[2]],
  colonial_empire = fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[2]], 
  France_vs_GB = fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[2]],
  ally_vs_foe = fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[2]],
  allyandneutral_vs_foe = fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[2]], 
  battle_dummy = fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[2]]
)
m = lm(loss~prizes_import + num_prizes+num_prizes_priv+colonial_empire+
         France_vs_GB+ally_vs_foe+allyandneutral_vs_foe + battle_dummy,
       data = max_wartime_sum_mreg)
stargazer(fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[3]], 
          fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[3]],
          m, font.size = "small", type = 'latex', covariate.labels= indep_label,
          title="Single and multivariate regressions for war years only and running sum",
          label = "tab:max_wartime_sum_mreg", column.sep.width = "-15pt",
          align=TRUE, dep.var.caption = c("Loss"), dep.var.labels.include = FALSE,
          omit.stat=c("LL","ser","f"), no.space=TRUE, model.numbers=FALSE,
          out = paste(HamburgPaperDir, PaperDir,"max_wartime_sum_mreg.tex", sep = ""))
rm(dflist, onlywar, running_sum, m)

#apply function to all wartime strategies var of interest 
#for all years and running sum
onlywar = 0
running_sum = 1
dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[1]], 
  fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[1]]
)
#make a df with results
max_peacewartime_sum_corr = bind_rows(dflist)

#make a df with results of multivariate regression for all years and running sum
max_peacewartime_sum_mreg = data.frame(
  year = war_strat$year, 
  loss = war_strat$loss, 
  prizes_import=fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[2]],
  num_prizes = fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[2]],
  num_prizes_priv = fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[2]],
  colonial_empire = fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[2]], 
  France_vs_GB = fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[2]],
  ally_vs_foe = fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[2]],
  allyandneutral_vs_foe = fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[2]], 
  battle_dummy = fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[2]]
)
m = lm(loss~prizes_import + num_prizes+num_prizes_priv+colonial_empire+
         France_vs_GB+ally_vs_foe+allyandneutral_vs_foe + battle_dummy,
       data = max_peacewartime_sum_mreg)
stargazer(fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[3]], 
          fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[3]],
          m, font.size = "small", type = 'latex', covariate.labels= indep_label,
          title="Single and multivariate regressions for all years and running sum",
          label = "tab:max_peacewartime_sum_mreg", column.sep.width = "-15pt",
          align=TRUE, dep.var.caption = c("Loss"), dep.var.labels.include = FALSE,
          omit.stat=c("LL","ser","f"), no.space=TRUE, model.numbers=FALSE,
          out = paste(HamburgPaperDir, PaperDir,"max_peacewartime_sum_mreg.tex", sep = ""))
rm(dflist, onlywar, running_sum, m)
rm(log_max)
#######################################LOG#############################
#when in log it is a semi-elasticity --> one percent increase in log findep means a one percentage point change in loss
#apply function to all wartime strategies var of interest 
#for war years only and no running sum
log_max = "log"

onlywar = 1
running_sum = 0
dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[1]], 
  fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[1]]
)
#make a df with results
log_wartime_nosum_corr = bind_rows(dflist)

#make a df with results of multivariate regression for war years only and no running sum
log_wartime_nosum_mreg = data.frame(
  year = war_strat[war_strat$war==1,]$year, 
  loss = war_strat[war_strat$war==1,]$loss, 
  prizes_import=fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[2]],
  num_prizes = fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[2]],
  num_prizes_priv = fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[2]],
  colonial_empire = fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[2]], 
  France_vs_GB = fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[2]],
  ally_vs_foe = fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[2]],
  allyandneutral_vs_foe = fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[2]], 
  battle_dummy = fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[2]]
)
m = lm(loss~prizes_import + num_prizes+num_prizes_priv+colonial_empire+
         France_vs_GB+ally_vs_foe+allyandneutral_vs_foe+ battle_dummy,
       data = log_wartime_nosum_mreg)
stargazer(fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[3]], 
          fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[3]],
          m, font.size = "small", type = 'latex', covariate.labels= indep_label,
          title="Single and multivariate regressions for war years only, semi-elasticities",
          label = "tab:log_wartime_nosum_mreg", column.sep.width = "-15pt",
          align=TRUE, dep.var.caption = c("Loss"), dep.var.labels.include = FALSE,
          omit.stat=c("LL","ser","f"), no.space=TRUE, model.numbers=FALSE,
          out = paste(HamburgPaperDir, PaperDir,"log_wartime_nosum_mreg.tex", sep = ""))
rm(dflist, onlywar, running_sum, m)


#apply function to all wartime strategies var of interest 
#for only war years and running sum
onlywar = 1
running_sum = 1
dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[1]], 
  fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[1]]
)
#make a df with results
log_wartime_sum_corr = bind_rows(dflist)
#multivariate regression for only war years and running sum
log_wartime_sum_mreg = data.frame(
  year = war_strat[war_strat$war==1,]$year, 
  loss = war_strat[war_strat$war==1,]$loss, 
  prizes_import=fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[2]],
  num_prizes = fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[2]],
  num_prizes_priv = fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[2]],
  colonial_empire = fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[2]], 
  France_vs_GB = fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[2]],
  ally_vs_foe = fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[2]],
  allyandneutral_vs_foe = fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[2]], 
  battle_dummy = fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[2]]
)
m = lm(loss~prizes_import + num_prizes+num_prizes_priv+colonial_empire+
         France_vs_GB+ally_vs_foe+allyandneutral_vs_foe+battle_dummy,
       data = log_wartime_sum_mreg)
stargazer(fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[3]], 
          fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[3]],
          m, font.size = "small", type = 'latex', covariate.labels= indep_label,
          title="Single and multivariate regressions for war years only and running sum, semi-elasticities",
          label = "tab:log_wartime_sum_mreg", column.sep.width = "-15pt",
          align=TRUE, dep.var.caption = c("Loss"), dep.var.labels.include = FALSE,
          omit.stat=c("LL","ser","f"), no.space=TRUE, model.numbers=FALSE,
          out = paste(HamburgPaperDir, PaperDir,"log_wartime_sum_mreg.tex", sep = ""))

rm(dflist, onlywar, running_sum, m)


#apply function to all wartime strategies var of interest 
#for all years and running sum
onlywar = 0
running_sum = 1
dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[1]], 
  fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[1]],
  fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[1]]
)

#make a df with results
log_peacewartime_sum_corr = bind_rows(dflist)
#multivariate regression for all years and running sum
log_peacewartime_sum_mreg = data.frame(
  year = war_strat$year, 
  loss = war_strat$loss, 
  prizes_import=fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[2]],
  num_prizes = fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[2]],
  num_prizes_priv = fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[2]],
  colonial_empire = fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[2]], 
  France_vs_GB = fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[2]],
  ally_vs_foe = fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[2]],
  allyandneutral_vs_foe = fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[2]], 
  battle_dummy = fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[2]]
)
m = lm(loss~prizes_import + num_prizes+num_prizes_priv+colonial_empire+
         France_vs_GB+ally_vs_foe+allyandneutral_vs_foe+battle_dummy,
       data = log_peacewartime_sum_mreg)
stargazer(fwartime_corr_df(war_strat, "prizes_import",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "num_prizes_priv",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "colonial_empire",onlywar,running_sum, log_max)[[3]], 
          fwartime_corr_df(war_strat, "France_vs_GB",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "ally_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "allyandneutral_vs_foe",onlywar,running_sum, log_max)[[3]],
          fwartime_corr_df(war_strat, "battle_dummy",onlywar,running_sum, "max")[[3]],
          m, font.size = "small", type = 'latex', covariate.labels= indep_label,
          title="Single and multivariate regressions for all years and running sum, semi-elasticities",
          label = "tab:log_peacewartime_sum_mreg", column.sep.width = "-15pt",
          align=TRUE, dep.var.caption = c("Loss"), dep.var.labels.include = FALSE,
          omit.stat=c("LL","ser","f"), no.space=TRUE, model.numbers=FALSE,
          out = paste(HamburgPaperDir, PaperDir,"log_peacewartime_sum_mreg.tex", sep = ""))
