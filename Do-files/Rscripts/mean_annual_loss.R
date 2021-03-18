library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
library(whoami)
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

source(paste(HamburgPaperDir,RscriptDir,GraphDir, "floss_plot.R", sep = "" ))
source(paste(HamburgPaperDir,RscriptDir,DataframeDir, "fmean_annual_loss_df.R", sep = "" ))

loss = read.csv(paste(toflitDir,"database_csv/mean_annual_loss.csv", sep = ""))

loss = loss %>% group_by(period) %>% mutate(mean_loss=mean(loss, na.rm = TRUE))
loss = loss %>% group_by(period) %>% mutate(mean_loss_nomemory=mean(loss_nomemory, na.rm = TRUE))

df = fmean_annual_loss_df(loss)
df = df[df$year < 1830,]
loss = floss_plot(df)
print(loss)
ggsave(paste(HamburgPaperDir,PaperDir, "mean_annual_loss.png", sep = "" ))

