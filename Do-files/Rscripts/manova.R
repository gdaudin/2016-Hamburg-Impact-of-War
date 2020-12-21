library(dplyr)
library(tidyr)
library(Hotelling)
library(ggplot2)

HamburgDir = "/Volumes/GoogleDrive/My Drive/Hamburg/"
RscriptDir = "Paper/Do-files/Rscripts/"
GraphDir = "Graphs/"
NewgraphsDir = "New graphs/"
DfDir = "Dataframe/"

source(paste(HamburgDir,RscriptDir,DfDir, "fcomposition_trade_df.R", sep = "" ))
hotelling = read.csv(paste(HamburgDir, "temp_for_hotelling.csv", ))




 
