library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
library(whoami)
library(zoo)

loadfonts()

if(username()=="Tirindelli"){
  HamburgPaperDir = "/Users/Tirindelli/Desktop/HamburgPaper/"
  HamburgDir = "/Volumes/GoogleDrive/My Drive/Hamburg/"
}

RscriptDir = "Do-files/Rscripts/"
GraphDir = "Graphs/"
DataframeDir = "Dataframe/"
NewgraphsDir = "New graphs/"
PaperDir = "Paper - Impact of War/Paper/"

loss = read.csv(paste(HamburgDir,"database_csv/mean_annual_loss.csv", sep = ""))
loss = loss[c("year", "loss", "loss_nomemory" )]

colony_loss = read.csv(paste(HamburgDir,"database_csv/colony_loss.csv", sep = ""))
colony_loss = colony_loss[c("year", "weight_france")]

naval_sup = read.csv(paste(HamburgDir,"database_csv/naval_supremacy.csv", sep = ""))
naval_sup = naval_sup[c("year", "France_vs_GB", "ally_vs_foe", "allyandneutral_vs_foe")]

prizes = read.csv(paste(HamburgDir,"database_csv/prizes.csv", sep = ""))
prizes = prizes[c("year", "Number_of_prizes_Total_All", 
                  "Number_of_prizes_Privateers_All", "importofprizegoodspoundsterling")]
  
war_strat = left_join(loss, colony_loss, by = "year")
war_strat = left_join(war_strat, naval_sup, by = "year")
war_strat = left_join(war_strat, prizes, by = "year")

names(war_strat)[names(war_strat) == "importofprizegoodspoundsterling"] = "prizes_import"
names(war_strat)[names(war_strat) == "Number_of_prizes_Total_All"] = "num_prizes"
names(war_strat)[names(war_strat) == "Number_of_prizes_Privateers_All"] = "num_prizes_priv"
names(war_strat)[names(war_strat) == "weight_france"] = "colony_loss"

fwartime_corr_df = function(fwar_strat, findep){
  
  names(fwar_strat)[names(fwar_strat) == findep] = "findep"

  m = lm(fwar_strat$loss~fwar_strat$findep)
  df = data.frame(
    "var" = findep,
    "corr" = round(m$coefficients[2], 3),
    "pval" = round(summary(m)$coefficients[2,4], 3)
  )
}

indep_var = c("prizes_import", "num_prizes", "num_prizes_priv", "colony_loss", "France_vs_GB",
              "ally_vs_foe", "allyandneutral_vs_foe")

dflist = list(
  fwartime_corr_df(war_strat, "prizes_import"),
  fwartime_corr_df(war_strat, "num_prizes"),
  fwartime_corr_df(war_strat, "num_prizes_priv"),
  fwartime_corr_df(war_strat, "colony_loss"), 
  fwartime_corr_df(war_strat, "France_vs_GB"),
  fwartime_corr_df(war_strat, "ally_vs_foe"),
  fwartime_corr_df(war_strat, "allyandneutral_vs_foe")
)

wartime_corr = bind_rows(dflist)

Dwar_strat = war_strat
Dwar_strat$Wcut= cut(Dwar_strat$year, 
                     breaks=c(1739,1748,1755,1763,1777,1783, 1792, 1807,1815, 1840), 
                     labels = FALSE)
Dwar_strat$war = ifelse(((Dwar_strat$Wcut %% 2) == 0), 0, 1)
Dwar_strat$war = ifelse((Dwar_strat$Wcut == 9), 0, Dwar_strat$war)
Dwar_strat$war = ifelse((Dwar_strat$Wcut == 8), 1, Dwar_strat$war)

Dwar_strat = Dwar_strat %>% group_by(Wcut) %>% mutate(counter = row_number())

f = function(x){
  x = na.locf(x)
  x = ifelse(Dwar_strat$war ==0, x*exp(-Dwar_strat$counter), x)
}

Dwar_strat[indep_var] = lapply(Dwar_strat[indep_var], f)

dflist = list(
  fwartime_corr_df(Dwar_strat, "prizes_import"),
  fwartime_corr_df(Dwar_strat, "num_prizes"),
  fwartime_corr_df(Dwar_strat, "num_prizes_priv"),
  fwartime_corr_df(Dwar_strat, "colony_loss"), 
  fwartime_corr_df(Dwar_strat, "France_vs_GB"),
  fwartime_corr_df(Dwar_strat, "ally_vs_foe"),
  fwartime_corr_df(Dwar_strat, "allyandneutral_vs_foe")
)

Dwartime_corr = bind_rows(dflist)
