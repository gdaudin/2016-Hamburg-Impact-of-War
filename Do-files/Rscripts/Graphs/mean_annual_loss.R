library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)

loss = read.csv("/Volumes/GoogleDrive/My Drive/Hamburg/database_csv/loss.csv")

df = rbind(
  data.frame(
    year = unique(loss$year),
    loss = loss$loss,
    loss_type = rep("Loss", length(loss$loss)),
    period = loss$period),
  data.frame(
    year = unique(loss$year),
    loss = loss$loss_nomemory,
    loss_type = rep("Loss no memory", length(loss$loss_nomemory)),
    period = loss$period)
  )
df = df %>% group_by(loss_type, period) %>% mutate(mean_loss=mean(loss, na.rm = TRUE))


annual_loss = ggplot(df) + 
  geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1756, xmax=1762, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
  geom_line(aes(x=year, y= loss, color=loss_type)) +
  theme(legend.title = element_blank(),
        legend.position = 'bottom',
        aspect.ratio = 1, 
        legend.background = element_blank(),
        legend.box.background = element_rect(colour = "black"),
        axis.title = element_blank(),
        panel.background = element_blank(),
        panel.grid.major.y = element_line(color = "grey", size = 0.15),
        panel.border = element_rect(color = "black", fill = NA),
        plot.title = element_text(hjust = 0.5)) +
  scale_color_manual(labels = c("Loss computed using all past period", "Loss computed using only preceding period"), 
                     values = c("Loss" = "#1B9E77", "Loss no memory" = "#E6AB02")) +
  scale_x_continuous(breaks = seq(1740, 1840, by = 10), limits = c(1740,1840)) +
  scale_y_continuous(breaks = seq(-1, 1, by = .2), limits = c(-1,1)) +
  ggtitle("Annual loss function")
print(annual_loss)

mean_loss = ggplot(df) + 
  geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1756, xmax=1762, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
  geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
  geom_line(aes(x=year, y= mean_loss, color=loss_type)) +
  theme(legend.title = element_blank(),
        legend.position = 'bottom',
        aspect.ratio = 1, 
        legend.background = element_blank(),
        legend.box.background = element_rect(colour = "black"),
        axis.title = element_blank(),
        panel.background = element_blank(),
        panel.grid.major.y = element_line(color = "grey", size = 0.15),
        panel.border = element_rect(color = "black", fill = NA),
        plot.title = element_text(hjust = 0.5)) +
  scale_color_manual(labels = c("Loss computed using all past period", "Loss computed using only preceding period"), 
                     values = c("Loss" = "#1B9E77", "Loss no memory" = "#E6AB02")) +
  scale_x_continuous(breaks = seq(1740, 1840, by = 10), limits = c(1740,1840)) +
  scale_y_continuous(breaks = seq(-1, 1, by = .2), limits = c(-1,1)) +
  ggtitle("Mean loss function")

annual_mean_loss = ggarrange(annual_loss, mean_loss, 
                                ncol = 2, common.legend = TRUE, legend = 'bottom')
print(annual_mean_loss)