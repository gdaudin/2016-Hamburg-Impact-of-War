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
NewgraphsDir = "New graphs/"
PaperDir = "Paper - Impact of War/Paper/"
source(paste(HamburgPaperDir,RscriptDir,GraphDir, "floss_by_war_status_plot.R", sep = "" ))

loss = read.csv(paste(toflitDir,"database_csv/loss_by_war_status.csv", sep = ""))

df = rbind(
  data.frame(
    year = loss$year,
    export_import = loss$export_import,
    war_status = loss$war_status,
    loss = loss$weighted_mean_loss,
    loss_type = rep("Weighted mean loss", length(loss$weighted_mean_loss))),
  data.frame(
    year = loss$year,
    export_import = loss$export_import,
    war_status = loss$war_status,
    loss = loss$average_mean_loss,
    loss_type = rep("Average mean loss", length(loss$weighted_mean_loss)))
)

df$war_status = ifelse(df$war_status=="ally", "Ally", df$war_status)
df$war_status = ifelse(df$war_status=="foe", "Foe", df$war_status)
df$war_status = ifelse(df$war_status=="neutral", "Neutral", df$war_status)
df$war_status = ifelse(df$war_status=="colonies", "Colonies", df$war_status)

loss = floss_by_war_status_plot(df[df$export_import=="XI",])
ggsave(paste(HamburgPaperDir,PaperDir, "loss_by_war_status_XI.png", sep = "" ))

Xloss = floss_by_war_status_plot(df[df$export_import=="Exports",])
Xloss = Xloss + 
  theme(plot.margin = margin(.5, .1, .1, .1, "cm"),
        plot.background = element_rect(
          fill = NA,
          colour = "black",
          size = .8), 
        legend.box.background = element_blank())
Iloss = floss_by_war_status_plot(df[df$export_import=="Imports",])
Iloss = Iloss + 
  theme(plot.margin = margin(.5, .1, .1, .1, "cm"),
        plot.background = element_rect(
          fill = NA,
          colour = "black",
          size = .8), 
        legend.box.background = element_blank())
ggarrange(Xloss, NULL, Iloss, ncol = 1, heights = c(1, 0.01, 1), 
          common.legend = TRUE, legend = "bottom", labels = c("Exports", "", "Imports"),
          font.label = list(family = "LM Roman 10", face = "bold"))
ggsave(paste(HamburgPaperDir, PaperDir, "loss_by_war_status_X_I_combined.png", sep = "" ), 
       height = 9.5, width = 8.7)

