rm(list = ls())
library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
library(whoami)
library(ggpubr)
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

source(paste(HamburgPaperDir,RscriptDir,DataframeDir, "fprizes_nationality_df.R", sep = "" ))
source(paste(HamburgPaperDir,RscriptDir,GraphDir, "fratio_BR_expenditures_annual_loss_plot.R", sep = "" ))

color = c("Navy's prizes (estimated time of capture from 1973)" = "#0072B2", 
          "Privateers' prizes" = "#56B4E9",
          "Share of non Fench prizes among privateers's prizes" = "#E69F00")

prizes = read.csv(paste(toflitDir,"database_csv/prizes.csv", sep = ""))

ggplot(prizes, aes(x=year)) +
  geom_bar(aes(y=Number_of_prizes_Total_All, fill = "Navy's prizes (estimated time of capture from 1973)"), 
           stat="identity", size=.1, color = "#000000") + 
  geom_bar(aes(y=Number_of_prizes_Privateers_All, fill = "Privateers' prizes"), 
           stat="identity", size=.1, color = "#000000") + 
  geom_line(aes(y=share_of_non_FR_prizes*700, color ="Share of non Fench prizes among privateers's prizes")) +
  geom_point(aes(y=share_of_non_FR_prizes*700, color ="Share of non Fench prizes among privateers's prizes")) +
  theme_few() +
  theme(legend.title = element_blank(),
        legend.key.height=unit(.5, "cm"),
        legend.position = "bottom",
        axis.title.y = element_text(family ="LM Roman 10"),
        axis.title.x = element_blank(),
        axis.text = element_text(family ="LM Roman 10"),
        #panel.background = element_blank(),
        #legend.box.background = element_rect(colour = "black"),
        #legend.box="vertical", 
        #legend.margin=margin(),
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
        strip.text = element_text(size=15, family ="LM Roman 10")) +
  scale_x_continuous(breaks = seq(1740, 1800, by = 10), limits = c(1740,1801)) +
  scale_y_continuous(name = "Number of prizes",
                     sec.axis = sec_axis(~./700, name = "Share of privateers' prizes")) +
  scale_fill_manual(values = color, guide = 'legend') +
  scale_color_manual(values = color) +
  guides(fill = guide_legend(nrow = 2))
ggsave(paste(HamburgPaperDir,PaperDir, "Prizes.pdf", sep = "" ))


prizes = read.csv(paste(toflitDir,"database_csv/prizes_imports.csv", sep = ""))
color = c("Absolute value" = "#0072B2", 
          "Share of French trade" = "#E69F00")

ggplot(prizes, aes(x=year)) +
  geom_bar(aes(y=importofprizegoodspoundsterling, fill = "Absolute value"), stat="identity", size=.1, color = "#000000") + 
  geom_line(aes(y=share_prizes*14500, color = "Share of French trade")) +
  geom_point(aes(y=share_prizes*14500, color = "Share of French trade")) +
  theme_few() +
  theme(legend.title = element_blank(),
        legend.position = "bottom",
        legend.key.height=unit(.5, "cm"),
        axis.title.y = element_text(family ="LM Roman 10"),
        axis.title.x = element_blank(),
        axis.text = element_text(family ="LM Roman 10"),
        #panel.background = element_blank(),
        #legend.box.background = element_rect(colour = "black"),
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
        strip.text = element_text(size=15, family ="LM Roman 10")) +
  scale_x_continuous(breaks = seq(1740, 1800, by = 10), limits = c(1740,1801)) +
  guides(colour = guide_legend(override.aes = list(linetype = 1))) +
  scale_y_continuous(name = "Imports of prize goods (£000)",
                       sec.axis = sec_axis(~./14500, name = "Share of French trade")) +
  scale_fill_manual(values = color, guide = 'legend') +
  scale_color_manual(values = color)
ggsave(paste(HamburgPaperDir,PaperDir, "Prizes_imports.pdf", sep = "" ))

prizes = read.csv(paste(toflitDir,"database_csv/prizes_nationality.csv", sep = ""))
prizes_nat = fprizes_nationality_df(prizes)
prizes_nat$prizes = ifelse(prizes_nat$prizes>100, NA, prizes_nat$prizes)
color = c("Absolute value" = "#0072B2", 
          "Share of French trade" = "#E69F00")

loss = ggplot(prizes_nat) + 
  geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1756, xmax=1763, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
  geom_line(aes(x=year, y= prizes, color = prizes_nationality)) +
  geom_point(aes(x=year, y= prizes, color = prizes_nationality)) +
  theme_few() +
  theme(legend.title = element_blank(),
        legend.position = "bottom",
        legend.key.height=unit(.5, "cm"),
        axis.title = element_blank(),
        axis.text = element_text(family ="LM Roman 10"),
        #panel.background = element_blank(),
        #legend.box.background = element_rect(colour = "black"),
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
        strip.text = element_text(size=15, family ="LM Roman 10")) +
  scale_x_continuous(breaks = seq(1740, 1815, by = 10), limits = c(1740,1815)) +
  scale_color_manual(values=c("#E69F00", "#56B4E9", "#009E73", "#F0E442")) 
print(loss)
ggsave(paste(HamburgPaperDir,PaperDir, "Prizes_nationality.pdf", sep = "" ))
