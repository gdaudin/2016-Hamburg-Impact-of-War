library(dplyr)
library(tidyr)
library(Hotelling)
library(ggplot2)
library(ggthemes)
library(tidyverse)
library(devtools)
library(whoami)
loadfonts()

if(username()=="Tirindelli") HamburgDir = "/Volumes/GoogleDrive/My Drive/Hamburg/"

RscriptDir = "Paper/Do-files/Rscripts/"
GraphDir = "Graphs/"
NewgraphsDir = "New graphs/"
DfDir = "Dataframe/"
Database_csvDir = "database_csv/"

source(paste(HamburgDir,RscriptDir,DfDir, "fcomposition_trade_df.R", sep = "" ))
source(paste(HamburgDir,RscriptDir,GraphDir, "fviolin_plot.R", sep = "" ))

hotelling = read.csv(paste(HamburgDir,Database_csvDir,"temp_for_hotelling.csv", sep=""))

#fcomposition_trade_df(df, period1, period2, plantation_yesno, direction, X_I, classification)
# periods can be:
#"Peace 1749-1755" "War 1756-1763" "Peace 1764-1777" "War 1778-1783"     
# "Peace 1784-1792" "War 1793-1807" "Blockade 1808-1815" "Peace 1816-1840"   

peace49_55_peace64_77_1_sitc = data.frame(rbind(
  fcomposition_trade_df(hotelling, "Peace 1749-1755","Peace 1764-1777", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "Peace 1749-1755","Peace 1764-1777", 1, "national", "Imports", "product_sitc_simplEN")
))
  
peace49_55_peace64_77_1_sitc_plot = fviolin_plot(peace49_55_peace64_77_1_sitc, 1)
print(peace49_55_peace64_77_1_sitc_plot)

