library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
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

df = read.csv(paste(HamburgDir,"database_csv/number_protagonist.csv", sep = ""))
df = df[c("year", "war_nbr_pays", "war_status")]
df = df[df$war_status!= "colonies",]
df = df %>% group_by(year, war_status) %>% summarize(war_nbr_pays = mean(war_nbr_pays, na.rm = TRUE))
df$war_status = ifelse(df$war_status=="ally", "Ally", df$war_status)
df$war_status = ifelse(df$war_status=="foe", "Foe", df$war_status)
df$war_status = ifelse(df$war_status=="neutral", "Neutral", df$war_status)

ggplot(df, aes(year, war_nbr_pays)) + 
  geom_col(fill = "#0072B2", color = "#000000")  +
  facet_wrap(~war_status, ncol = 2) +
  theme_few() +
  theme(axis.title = element_blank(),
        axis.text = element_text(family ="LM Roman 10"),
        panel.background = element_blank(),
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        panel.border = element_rect(color = "black", fill = NA),
        plot.title = element_text(hjust = 0.5),
        strip.text = element_text(size=15, family ="LM Roman 10")) +
  scale_x_continuous(breaks = seq(1740, 1830, by = 10), limits = c(1740,1830)) 
ggsave(paste(HamburgPaperDir,PaperDir, "Number_of_protagonist.png", sep = "" ))
