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

colony_loss = read.csv(paste(HamburgDir,"database_csv/colony_loss.csv", sep = ""))

loss = ggplot(colony_loss) + 
  geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1756, xmax=1763, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
  geom_line(aes(x=year, y= weight_france, color = "#D55E00")) +
  theme_few() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        axis.title = element_blank(),
        axis.text = element_text(family ="LM Roman 10"),
        panel.background = element_blank(),
        panel.grid.major.y = element_line(color = "grey", size = 0.12),
        panel.border = element_rect(color = "black", fill = NA),
        plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
        strip.text = element_text(size=15, family ="LM Roman 10")) +
  scale_x_continuous(breaks = seq(1740, 1820, by = 10), limits = c(1740,1820)) 
print(loss)
ggsave(paste(HamburgDir,RscriptDir,NewgraphsDir, "colony_loss.pdf", sep = "" ))
