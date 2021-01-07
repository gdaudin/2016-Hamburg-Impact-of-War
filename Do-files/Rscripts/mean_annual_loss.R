library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
library(whoami)
loadfonts()

if(username()=="Tirindelli") HamburgDir = "/Volumes/GoogleDrive/My Drive/Hamburg/"

RscriptDir = "Paper/Do-files/Rscripts/"
GraphDir = "Graphs/"
DataframeDir = "Dataframe/"
NewgraphsDir = "New graphs/"
fr_gb=""

source(paste(HamburgDir,RscriptDir,GraphDir, "floss_plot.R", sep = "" ))
source(paste(HamburgDir,RscriptDir,DataframeDir, "fmean_annual_loss_df.R", sep = "" ))

loss = read.csv(paste(HamburgDir,"database_csv/mean_annual_loss.csv", sep = ""))

loss = loss %>% group_by(period) %>% mutate(mean_loss=mean(loss, na.rm = TRUE))
loss = loss %>% group_by(period) %>% mutate(mean_loss_nomemory=mean(loss_nomemory, na.rm = TRUE))

df = fmean_annual_loss_df(loss)
df = df[df$year < 1830,]
loss = floss_plot(df)
print(loss)
ggsave(paste(HamburgDir,RscriptDir,NewgraphsDir, "mean_annual_loss.pdf", sep = "" ))

