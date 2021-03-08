fratio_BR_expenditures_annual_loss_plot = function(ratio_exp, L_H){
  if(L_H=="H") title = ggtitle("French trade loss*0.35")
  if(L_H=="L") title = ggtitle("French trade loss*0.18")
  loss = ggplot(ratio_exp) + 
    geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
    geom_rect(aes(xmin=1756, xmax=1763, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
    geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
    geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
    geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
    geom_line(aes(x=year, y= ratio, color = str_wrap(ratio_type, 30))) +
    geom_line(aes(x=year, y= ratio_nm, color = str_wrap(ratio_type, 30)), linetype="dashed") +
    theme_few() +
    theme(legend.title = element_blank(),
          legend.position = "bottom",
          legend.key.height=unit(.5, "cm"),
          axis.title = element_blank(),
          axis.text = element_text(family ="LM Roman 10"),
          panel.background = element_blank(),
          panel.grid.major.y = element_line(color = "grey", size = 0.12),
          panel.border = element_rect(color = "black", fill = NA),
          plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
          strip.text = element_text(size=15, family ="LM Roman 10")) +
    scale_x_continuous(breaks = seq(1740, 1825, by = 10), limits = c(1740,1825)) +
    scale_color_manual(values=c("#E69F00", "#56B4E9", "#009E73")) +
    guides(colour = guide_legend(override.aes = list(linetype = 1))) +
    title
}
