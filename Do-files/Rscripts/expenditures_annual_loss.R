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

source(paste(HamburgDir,RscriptDir,DataframeDir, "fexpenditures_annual_loss_df.R", sep = "" ))

loss_df = read.csv(paste(HamburgDir,"database_csv/expenditures_annual_loss.csv", sep = ""))
exp_loss = fexpenditures_annual_loss_df(loss_df)

loss = ggplot(exp_loss) + 
  geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1756, xmax=1763, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
  geom_line(aes(x=year, y= loss, color = loss_type)) +
  theme_few() +
  theme(legend.title = element_blank(),
        legend.position = "bottom",
        axis.title = element_blank(),
        axis.text = element_text(family ="LM Roman 10"),
        panel.background = element_blank(),
        legend.box.background = element_rect(colour = "black"),
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        panel.border = element_rect(color = "black", fill = NA),
        plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
        strip.text = element_text(size=15, family ="LM Roman 10")) +
  scale_x_continuous(breaks = seq(1740, 1825, by = 10), limits = c(1740,1825)) +
  scale_color_manual(values=c("#E69F00", "#56B4E9", "#009E73", "#F0E442","#D55E00", "#CC79A7"))
print(loss)
ggsave(paste(HamburgDir,RscriptDir,NewgraphsDir, "Expenditures_Annual_Los.pdf", sep = "" ))

loss = ggplot(exp_loss[(exp_loss$loss_type!="Using all past peace periods for the peace trend" &
                         exp_loss$loss_type!="Using the preceeding peace period for the peace trend"),]) + 
  geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1756, xmax=1763, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
  geom_line(aes(x=year, y= loss, color = loss_type)) +
  theme_few() +
  theme(legend.title = element_blank(),
        legend.position = "bottom",
        axis.title = element_blank(),
        axis.text = element_text(family ="LM Roman 10"),
        panel.background = element_blank(),
        legend.box.background = element_rect(colour = "black"),
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        panel.border = element_rect(color = "black", fill = NA),
        plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
        strip.text = element_text(size=15, family ="LM Roman 10")) +
  scale_x_continuous(breaks = seq(1740, 1825, by = 10), limits = c(1740,1825)) +
  scale_color_manual(values=c("#E69F00", "#56B4E9", "#009E73", "#F0E442"))
print(loss)
ggsave(paste(HamburgDir,RscriptDir,NewgraphsDir, "Costs_and_benefits.pdf", sep = "" ))
