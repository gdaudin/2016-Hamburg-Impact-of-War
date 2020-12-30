fviolin_plot = function(df, plantation_yesno){
  if(plantation_yesno == 0) note_option = labs(caption = "Without plantation foodstuff")
  else note_option = labs(caption = "")
  ggplot(df, aes(class, ln_percent, fill = period_str)) + 
    geom_violin() + coord_flip() + 
    theme_few() +
    theme(
      axis.title = element_blank(),
      legend.title = element_blank(),
      legend.position = 'bottom',
      panel.background = element_blank(),
      panel.grid.major.y = element_line(color = "grey", size = 0.12)
    ) +
    stat_summary(geom="pointrange", position = position_dodge(width = 0.9), size = .09) 
    facet_wrap(~export_import) +
    note_option
}
