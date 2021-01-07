fratio_BR_expenditures_annual_lossL_df = function(fdf){
  df = rbind(
    data.frame(
      year = fdf$year,
      ratio = fdf$ratio_abs,
      ratio_nm =fdf$ratio_nm_abs,
      ratio_type = rep("French trade losses", length(fdf$ratio_nm_abs)),
      period = fdf$period), 
    data.frame(
      year = fdf$year,
      ratio = fdf$ratio_abs_v2,
      ratio_nm = fdf$ratio_nm_abs_v2,
      ratio_type = rep("French losses = idem + value of captured French prizes", length(fdf$ratio_nm_abs_v2)),
      period = fdf$period),
    data.frame(
      year = fdf$year,
      ratio = fdf$ratio_abs_v3,
      ratio_nm = fdf$ratio_nm_abs_v3,
      ratio_type = rep("French losses = idem + French Navy budget", length(fdf$ratio_nm_abs_v2)),
      period = fdf$period)
  )
}