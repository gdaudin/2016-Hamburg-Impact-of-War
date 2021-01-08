library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
library(whoami)
library(ggpubr)
loadfonts()

if(username()=="Tirindelli") HamburgDir = "/Volumes/GoogleDrive/My Drive/Hamburg/"
RscriptDir = "Paper/Do-files/Rscripts/"
GraphDir = "Graphs/"
DataframeDir = "Dataframe/"
NewgraphsDir = "New graphs/"

source(paste(HamburgDir,RscriptDir,DataframeDir, "fratio_BR_expenditures_annual_loss_df.R", sep = "" ))
source(paste(HamburgDir,RscriptDir,GraphDir, "fratio_BR_expenditures_annual_loss_plot.R", sep = "" ))

ratio_dfH = read.csv(paste(HamburgDir,"database_csv/ratio_BR_expenditures_ennual_lossH.csv", sep = ""))
ratio_dfL = read.csv(paste(HamburgDir,"database_csv/ratio_BR_expenditures_ennual_lossL.csv", sep = ""))

ratio_expL = fratio_BR_expenditures_annual_loss_df(ratio_dfL)
ratio_expH = fratio_BR_expenditures_annual_loss_df(ratio_dfH)

ratio_expL_plot = fratio_BR_expenditures_annual_loss_plot(ratio_expL, "L")
print(ratio_expL_plot)

ratio_expH_plot = fratio_BR_expenditures_annual_loss_plot(ratio_expH, "H")
print(ratio_expH_plot)

ggarrange(ratio_expL_plot, ratio_expH_plot, common.legend = TRUE, legend = "bottom")
ggsave(paste(HamburgDir,RscriptDir,NewgraphsDir, "ratio_BR_expenditures_ennual_loss.pdf", sep = "" ))