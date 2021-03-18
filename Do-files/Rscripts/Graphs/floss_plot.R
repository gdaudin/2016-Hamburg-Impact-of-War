floss_plot = function(fdf){
  #http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/ for color blind friendly colors
  loss = ggplot(fdf) + 
    geom_rect(aes(xmin=1745, xmax=1748, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
    geom_rect(aes(xmin=1756, xmax=1763, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
    geom_rect(aes(xmin=1778, xmax=1783, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
    geom_rect(aes(xmin=1793, xmax=1807, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#999999") +
    geom_rect(aes(xmin=1808, xmax=1815, ymin=-Inf, ymax=Inf), alpha=.03, fill = "#0072B2") +
    geom_hline(yintercept = 0, color = "#D55E00") +
    geom_line(aes(x=year, y= loss, color=loss_type), size = 1) +
    theme_few() +
    theme(legend.title = element_blank(),
          legend.position = 'bottom',
          legend.background = element_blank(),
          legend.text = element_text(family ="LM Roman 10"),
          axis.title = element_blank(),
          axis.text = element_text(family ="LM Roman 10"),
          panel.background = element_blank(),
          panel.grid.major.y = element_line(color = "grey", size = 0.12),
          panel.border = element_rect(color = "black", fill = NA),
          plot.title = element_text(hjust = 0.5, family ="LM Roman 10"),
          strip.text = element_text(size=15, family ="LM Roman 10")) +
    scale_color_manual(labels = c("Using all past periods for peace trend", "Using preceding period for peace trend"), 
                       values = c("Loss" = "#1B9E77", "Loss no memory" = "#E6AB02")) +
    scale_x_continuous(breaks = seq(1740, 1830, by = 10), limits = c(1740,1830)) +
    scale_y_continuous(breaks = seq(-.2, .8, by = .2), limits = c(-.2,.8)) +
    facet_wrap(~loss_mean_annual)
  return(loss)
}