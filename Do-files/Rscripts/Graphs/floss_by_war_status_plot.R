floss_by_war_status_plot = function(fdf, plot_title){
  #http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/ for color blind friendly colors
  loss = ggplot(fdf) + 
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
          plot.title = element_text(hjust = 0.5),
          text = element_text(family ="LM Roman 10")) + 
    scale_color_manual(labels = c("Average mean loss" = "Average loss over the period", 
                                  "Weighted mean loss" = "Idem, weighted"), 
                       values = c("Average mean loss" = "#1B9E77", 
                                  "Weighted mean loss" = "#E6AB02")) + 
    scale_x_continuous(breaks = seq(1740, 1830, by = 10), limits = c(1740,1830)) +
    scale_y_continuous(breaks = seq(-.2, .8, by = .2), limits = c(-.2,.8)) +
    facet_wrap(~war_status) 
  print(loss)
  return(loss)
}