library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
loadfonts()

HamburgDir = "/Volumes/GoogleDrive/My Drive/Hamburg/"
RscriptDir = "Paper/Do-files/Rscripts/"
GraphDir = "Graphs/"
NewgraphsDir = "New graphs/"
fr_gb=""

source(paste(HamburgDir,RscriptDir,GraphDir, "floss_plot.R", sep = "" ))
loss = read.csv(paste(HamburgDir,"database_csv/loss.csv", sep = ""))

loss = loss %>% group_by(period) %>% mutate(mean_loss=mean(loss, na.rm = TRUE))
loss = loss %>% group_by(period) %>% mutate(mean_loss_nomemory=mean(loss_nomemory, na.rm = TRUE))

df = rbind(
  data.frame(
    year = unique(loss$year),
    loss = loss$loss,
    loss_type = rep("Loss", length(loss$loss)),
    period = loss$period, 
    loss_mean_annual = "Annual loss function"),
  data.frame(
    year = unique(loss$year),
    loss = loss$loss_nomemory,
    loss_type = rep("Loss no memory", length(loss$loss_nomemory)),
    period = loss$period,
    loss_mean_annual = "Annual loss function"),
  data.frame(
    year = unique(loss$year),
    loss = loss$mean_loss,
    loss_type = rep("Loss", length(loss$loss)),
    period = loss$period, 
    loss_mean_annual = "Mean loss function"),
  data.frame(
    year = unique(loss$year),
    loss = loss$mean_loss_nomemory,
    loss_type = rep("Loss no memory", length(loss$loss_nomemory)),
    period = loss$period,
    loss_mean_annual = "Mean loss function")
  )

df = df[df$year < 1830,]
loss = floss_plot(df)
print(loss)
ggsave(paste(HamburgDir,RscriptDir,NewgraphsDir, "mean_annual_loss.pdf", sep = "" ))

