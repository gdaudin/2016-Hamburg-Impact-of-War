fcumulated_costs_and_benefits_df = function(fdf){
  df = rbind(
    data.frame(
      year = fdf$year,
      loss = fdf$loss_abs_cum,
      loss_type = rep("Using all past peace periods for the peace trend", length(fdf$loss_abs)),
      period = fdf$period), 
    data.frame(
      year = fdf$year,
      loss = fdf$loss_nm_abs_cum,
      loss_type = rep("Using the preceeding peace period for the peace trend", length(fdf$loss_nm_abs)),
      period = fdf$period),
    data.frame(
      year = fdf$year,
      loss = fdf$Navy_cum,
      loss_type = rep("Royal Navy expenditures", length(fdf$NavyGross)),
      period = fdf$period),
    data.frame(
      year = fdf$year,
      loss = fdf$FRbudget_cum,
      loss_type = rep("French Navy expenditures", length(fdf$NavyNet)),
      period = fdf$period),
    data.frame(
      year = fdf$year,
      loss = fdf$FR_Prize_value_cum,
      loss_type = rep("Value of French prizes captured by Britain", length(fdf$FrenchBudget)),
      period = fdf$period)
  )
}