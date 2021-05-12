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

#apply function to all wartime strategies var of interest 
#for only war years and no running sum
dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",1,0, "max"),
  fwartime_corr_df(war_strat, "num_prizes",1,0, "max"),
  fwartime_corr_df(war_strat, "num_prizes_priv",1,0, "max"),
  fwartime_corr_df(war_strat, "colonial_empire",1,0, "max"), 
  fwartime_corr_df(war_strat, "France_vs_GB",1,0, "max"),
  fwartime_corr_df(war_strat, "ally_vs_foe",1,0, "max"),
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",1,0, "max")
)


#make a df with results
max_wartime_nosum_corr = bind_rows(dflist)

#apply function to all wartime strategies var of interest 
#for only war years and running sum
dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",1,1, "max"),
  fwartime_corr_df(war_strat, "num_prizes",1,1, "max"),
  fwartime_corr_df(war_strat, "num_prizes_priv",1,1, "max"),
  fwartime_corr_df(war_strat, "colonial_empire",1,1, "max"), 
  fwartime_corr_df(war_strat, "France_vs_GB",1,1, "max"),
  fwartime_corr_df(war_strat, "ally_vs_foe",1,1, "max"),
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",1,1, "max"),
  fwartime_corr_df(war_strat, "battle_dummy",1,1, "max")
)

#make a df with results
max_wartime_sum_corr = bind_rows(dflist)

#apply function to all wartime strategies var of interest 
#for all years and running sum
dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",0,1, "max"),
  fwartime_corr_df(war_strat, "num_prizes",0,1, "max"),
  fwartime_corr_df(war_strat, "num_prizes_priv",0,1, "max"),
  fwartime_corr_df(war_strat, "colonial_empire",0,1, "max"), 
  fwartime_corr_df(war_strat, "France_vs_GB",0,1, "max"),
  fwartime_corr_df(war_strat, "ally_vs_foe",0,1, "max"),
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",0,1, "max")
)

#make a df with results
max_peacewartime_sum_corr = bind_rows(dflist)

dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",1,0, "log"),
  fwartime_corr_df(war_strat, "num_prizes",1,0, "log"),
  fwartime_corr_df(war_strat, "num_prizes_priv",1,0, "log"),
  fwartime_corr_df(war_strat, "colonial_empire",1,0, "log"), 
  fwartime_corr_df(war_strat, "France_vs_GB",1,0, "log"),
  fwartime_corr_df(war_strat, "ally_vs_foe",1,0, "log"),
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",1,0, "log")
)


#make a df with results
log_wartime_nosum_corr = bind_rows(dflist)

#apply function to all wartime strategies var of interest 
#for only war years and running sum
dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",1,1, "log"),
  fwartime_corr_df(war_strat, "num_prizes",1,1, "log"),
  fwartime_corr_df(war_strat, "num_prizes_priv",1,1, "log"),
  fwartime_corr_df(war_strat, "colonial_empire",1,1, "log"), 
  fwartime_corr_df(war_strat, "France_vs_GB",1,1, "log"),
  fwartime_corr_df(war_strat, "ally_vs_foe",1,1, "log"),
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",1,1, "log")
)

#make a df with results
log_wartime_sum_corr = bind_rows(dflist)

#apply function to all wartime strategies var of interest 
#for all years and running sum
dflist = list(
  fwartime_corr_df(war_strat, "prizes_import",0,1, "log"),
  fwartime_corr_df(war_strat, "num_prizes",0,1, "log"),
  fwartime_corr_df(war_strat, "num_prizes_priv",0,1, "log"),
  fwartime_corr_df(war_strat, "colonial_empire",0,1, "log"), 
  fwartime_corr_df(war_strat, "France_vs_GB",0,1, "log"),
  fwartime_corr_df(war_strat, "ally_vs_foe",0,1, "log"),
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe",0,1, "log")
)

#make a df with results
log_peacewartime_sum_corr = bind_rows(dflist)

