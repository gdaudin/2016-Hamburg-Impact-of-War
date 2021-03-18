rm(list = ls())
library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
library(whoami)
library(ggh4x)
loadfonts()

if(username()=="Tirindelli"){
  HamburgPaperDir = "/Users/Tirindelli/Desktop/HamburgPaper/"
  toflitDir = "/Volumes/GoogleDrive/My Drive/Hamburg/"
}

RscriptDir = "Do-files/Rscripts/"
GraphDir = "Graphs/"
DataframeDir = "Dataframe/"
NewgraphsDir = "New graphs/"
PaperDir = "Paper - Impact of War/Paper/"

source(paste(HamburgPaperDir,RscriptDir,DataframeDir, "fcomposition_trade_df.R", sep = "" ))
source(paste(HamburgPaperDir,RscriptDir,GraphDir, "fviolin_plot.R", sep = "" ))

hotelling = read.csv(paste(toflitDir,"database_csv/temp_for_hotelling.csv", sep=""))

#fcomposition_trade_df(df, period1, period2, plantation_yesno, direction, X_I, classification)
# periods can be:
#"Peace 1749-1755" "War 1756-1763" "Peace 1764-1777" "War 1778-1783"     
# "Peace 1784-1792" "War 1793-1807" "Blockade 1808-1815" "Peace 1816-1840"  

# peace war product_sitc_simplEN

# seven peace1764_1777 product_sitc_simplEN
# peace1764_1777 indep product_sitc_simplEN
# indep peace1784_1792
# rev block product_sitc_simplEN

# peace1816_1840 block product_sitc_simplEN
# peace1749_1755 peace1764_1777 product_sitc_simplEN
# peace1764_1777 peace1784_1792 product_sitc_simplEN


df = data.frame(rbind(
  fcomposition_trade_df(hotelling, "Peace 1816-1840","Blockade 1808-1815", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "Peace 1816-1840","Blockade 1808-1815", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "Peace 1749-1755","Peace 1764-1777", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "Peace 1749-1755","Peace 1764-1777", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "Peace 1764-1777","Peace 1784-1792", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "Peace 1764-1777","Peace 1784-1792", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "War","Peace", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "War","Peace", 1, "national", "Imports", "product_sitc_simplEN")
))
  
color = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
plot1_sitc = fviolin_plot(df, 1, color)
print(plot1_sitc)
ggsave(paste(HamburgPaperDir, PaperDir, "violin_nat_sitc1_XI1.pdf", sep = ""), height = 10)

df = data.frame(rbind(
  fcomposition_trade_df(hotelling, "War 1756-1763","Peace 1764-1777", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "War 1756-1763","Peace 1764-1777", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "Peace 1764-1777","War 1784-1792", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "Peace 1764-1777","War 1784-1792", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "War 1784-1792","Peace 1784-1792", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "War 1784-1792","Peace 1784-1792", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "War 1793-1807","Blockade 1808-1815", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "War 1793-1807","Blockade 1808-1815", 1, "national", "Imports", "product_sitc_simplEN")
))
color = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00")
plot2_sitc = fviolin_plot(df, 1, color)
print(plot2_sitc)
ggsave(paste(HamburgPaperDir, PaperDir, "violin_nat_sitc1_XI2.pdf", sep = ""), height = 10)


df = data.frame(rbind(
  fcomposition_trade_df(hotelling, "Peace 1816-1840","Blockade 1808-1815", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "Peace 1816-1840","Blockade 1808-1815", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "Peace 1749-1755","Peace 1764-1777", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "Peace 1749-1755","Peace 1764-1777", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "Peace 1764-1777","Peace 1784-1792", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "Peace 1764-1777","Peace 1784-1792", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "War","Peace", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "War","Peace", 1, "national", "Imports", "product_sitc_simplEN")
))

color = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
plot1_sitc = fviolin_plot(df, 0, color)
print(plot1_sitc)
ggsave(paste(HamburgPaperDir, PaperDir, "violin_nat_sitc0_XI1.pdf", sep = ""), height = 10)

df = data.frame(rbind(
  fcomposition_trade_df(hotelling, "War 1756-1763","Peace 1764-1777", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "War 1756-1763","Peace 1764-1777", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "Peace 1764-1777","War 1784-1792", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "Peace 1764-1777","War 1784-1792", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "War 1784-1792","Peace 1784-1792", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "War 1784-1792","Peace 1784-1792", 1, "national", "Imports", "product_sitc_simplEN"),
  fcomposition_trade_df(hotelling, "War 1793-1807","Blockade 1808-1815", 1, "national", "Exports", "product_sitc_simplEN"), 
  fcomposition_trade_df(hotelling, "War 1793-1807","Blockade 1808-1815", 1, "national", "Imports", "product_sitc_simplEN")
))
color = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00")
plot2_sitc = fviolin_plot(df, 0, color)
print(plot2_sitc)
ggsave(paste(HamburgPaperDir, PaperDir, "violin_nat_sitc0_XI2.pdf", sep = ""), height = 10)

