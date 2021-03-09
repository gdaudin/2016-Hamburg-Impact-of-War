fviolin_plot = function(df, plantation_yesno, fcolor){
  plot1 = ggplot(df, aes(class, ln_percent, fill = period_str)) + 
    geom_violin() + coord_flip() + 
    theme_few() +
    theme(
      axis.title = element_blank(),
      legend.title = element_blank(),
      legend.position = 'bottom',
      panel.background = element_blank(),
      panel.grid.major.y = element_line(color = "grey", size = 0.12)
    ) +
    #stat_summary(geom="pointrange", position = position_dodge(width = 0.9), size = .09) +
    facet_nested(period_comb ~ export_import, labeller = labeller( period_comb = label_wrap_gen(width = 15))) +
    scale_fill_manual(values=fcolor, guide = 'legend') +
    guides(fill=guide_legend(nrow=2,byrow=TRUE))
  print(plot1)
    #scale_color_manual(values = color) +
  return(plot1)
}
