fnaval_supremacy_df = function(fdf){
  df = rbind(
    data.frame(
      year = fdf$year,
      naval_supremacy_ratio = fdf$France_vs_GB,
      naval_supremacy_type = rep("France/GB", length(fdf$France_vs_GB))
    ),
    data.frame(
      year = fdf$year,
      naval_supremacy_ratio = fdf$ally_vs_foe,
      naval_supremacy_type = rep("France and its allies/GB and its allies", length(fdf$France_vs_GB))
    ),
    data.frame(
      year = fdf$year,
      naval_supremacy_ratio = fdf$allyandneutral_vs_foe,
      naval_supremacy_type = rep("France, its allies and neutral/GB and its allies", length(fdf$France_vs_GB))
    ))
  df[df$year<1745,]$naval_supremacy_ratio = NA
  df[(df$year>1748 & df$year<1756),]$naval_supremacy_ratio = NA
  df[(df$year>1763 & df$year<1778),]$naval_supremacy_ratio = NA
  df[(df$year>1783 & df$year<1793),]$naval_supremacy_ratio = NA
  df[(df$year>1815),]$naval_supremacy_ratio = NA
  return(df)
}



  
  