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

total_trade = read.csv(paste(toflitDir,"database_csv/Total_silver_trade_FR_GB.csv", sep = ""))

df1 = data.frame(
  year = total_trade$year,
  value = total_trade$log10_valueFR_silver,
  country = "French trade"
  )
df2 = data.frame(
  year = total_trade$year,
  value = total_trade$log10_valueST_silverEN,
  country = "English, GB, UK trade"
)
df3 = data.frame(
  year = total_trade$year,
  value = total_trade$log10_valueST_silverGB, 
  country = "GB trade"
)
df4 = data.frame(
  year = total_trade$year,
  value = total_trade$log10_valueST_silver_tena,
  country = "UK trade"
)


df= rbind(df1, df2, df3, df4)

trade = ggplot(df) + 
  geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1756, xmax=1763, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
  geom_line(aes(x=year, y= value, color=country)) +
  theme_few() +
  theme(legend.title = element_blank(),
        legend.position = 'bottom',
        legend.background = element_blank(),
        legend.text = element_text(family ="LM Roman 10"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(family ="LM Roman 10"),
        axis.text = element_text(family ="LM Roman 10"),
        panel.background = element_blank(),
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        panel.border = element_rect(color = "black", fill = NA),
        plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
        strip.text = element_text(size=15, family ="LM Roman 10"))+ 
  scale_color_manual(values = c("French trade" = "#1B9E77", "English, GB, UK trade" = "#E6AB02",
                                "GB trade" = "#E6AB02", "UK trade" = "#E6AB02"),
                     breaks = c("French trade", "English, GB, UK trade")) +
  scale_x_continuous(breaks = seq(1740, 1830, by = 10), limits = c(1740,1830)) +
  ylab("Tons of silver, log10" )
print(trade)
ggsave(paste(HamburgPaperDir,PaperDir, "Total_silver_trade_FR_GB.pdf", sep = "" ))

