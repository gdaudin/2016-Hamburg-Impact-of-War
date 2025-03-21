rm(list = ls())
library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
library(whoami)
library(ggpubr)
library(gridExtra)
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

prizes = read.csv(paste(toflitDir,"database_csv/prizes_nationality.csv", sep = ""))
prizes_nat = fprizes_nationality_df(prizes)
#prizes_nat$prizes = ifelse(prizes_nat$prizes>100, NA, prizes_nat$prizes)
color = c("Absolute value" = "#0072B2", 
          "Share of French trade" = "#E69F00")

loss1 = ggplot(prizes_nat) + 
  geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1756, xmax=1763, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
  geom_line(aes(x=year, y= prizes, color = prizes_nationality), size = 1) +
  geom_point(aes(x=year, y= prizes, color = prizes_nationality)) +
  theme_few() +
  theme(legend.title = element_blank(),
        legend.position = "bottom",
        legend.key.height=unit(.5, "cm"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(family ="LM Roman 10"),
        axis.text = element_text(family ="LM Roman 10"),
        #panel.background = element_blank(),
        #legend.box.background = element_rect(colour = "black"),
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
        strip.text = element_text(size=15, family ="LM Roman 10"),
        plot.margin=unit(c(0,0.5,0,0),"lines")) +
  scale_y_continuous(name = "Number of prizes") +
  scale_x_continuous(breaks = seq(1740, 1815, by = 10), limits = c(1740,1815)) +
  coord_cartesian(ylim=c(-0.1,50)) +
  scale_color_manual(values=c("#E69F00", "#56B4E9", "#009E73", "#F0E442")) 
print(loss1)

loss2 = ggplot(prizes_nat) + 
  geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1756, xmax=1763, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
  geom_line(aes(x=year, y= prizes, color = prizes_nationality), size = 1, show.legend=FALSE) +
  geom_point(aes(x=year, y= prizes, color = prizes_nationality), show.legend=FALSE) +
  theme_few() +
  theme(legend.title = element_blank(),
        axis.title.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y = element_text(family ="LM Roman 10"),
        legend.position="none",
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        plot.margin=unit(c(0,0.5,0,0),"lines")) +
  scale_y_continuous(name = "", breaks = c(seq(150, 180, by = 20))) +
  scale_x_continuous(breaks = seq(1740, 1815, by = 10), limits = c(1740,1815)) +
  coord_cartesian(ylim=c(150,175)) +
  scale_color_manual(values=c("#E69F00", "#56B4E9", "#009E73", "#F0E442")) 
print(loss2)

gA = ggplotGrob(loss1)
gB = ggplotGrob(loss2)
maxWidth = grid::unit.pmax(gA$widths[2:5], gB$widths[2:5])
gA$widths[2:5] = as.list(maxWidth)
gB$widths[2:5] = as.list(maxWidth)
loss = grid.arrange(gB, gA, ncol=1, heights=c(0.15,0.85))
ggsave(paste(HamburgPaperDir,PaperDir, "Prizes_nationality.png", sep = "" ), loss)




