rm(list = ls())
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

RscriptDir = "Paper/Do-files/Rscripts/"
GraphDir = "Graphs/"
DataframeDir = "Dataframe/"
NewgraphsDir = "New graphs/"
PaperDir = "Paper - Impact of War/Paper/"

seatrade = read.csv(paste(toflitDir,"database_csv/share_by_sea.csv", sep = ""))

trade = ggplot(seatrade) + 
  geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1756, xmax=1763, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
  geom_line(aes(x=year, y= share_sea), color = "#D55E00") +
  theme_few() +
  theme(legend.title = element_blank(),
        legend.position = 'bottom',
        legend.background = element_blank(),
        legend.box.background = element_rect(colour = "black"),
        legend.text = element_text(family ="LM Roman 10"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(family ="LM Roman 10"),
        axis.text = element_text(family ="LM Roman 10"),
        panel.background = element_blank(),
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        panel.border = element_rect(color = "black", fill = NA),
        plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
        strip.text = element_text(size=15, family ="LM Roman 10")) +
  scale_color_manual(values = c("#1B9E77")) +
  scale_x_continuous(breaks = seq(1740, 1820, by = 10), limits = c(1740,1820)) +
  ylab("Imputed share of trade")
print(trade)
ggsave(paste(HamburgPaperDir,PaperDir, "share_by_sea.pdf", sep = "" ))
