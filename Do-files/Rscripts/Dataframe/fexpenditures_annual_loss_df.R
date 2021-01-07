fexpenditures_annual_loss_df = function(fdf){
  df = rbind(
    data.frame(
      year = fdf$year,
      loss = fdf$loss_abs,
      loss_type = rep("Using all past peace periods for the peace trend", length(fdf$loss_abs)),
      period = fdf$period), 
    data.frame(
      year = fdf$year,
      loss = fdf$loss_nm_abs,
      loss_type = rep("Using the preceeding peace period for the peace trend", length(fdf$loss_nm_abs)),
      period = fdf$period),
    data.frame(
      year = fdf$year,
      loss = fdf$NavyGross,
      loss_type = rep("Gross British Navy expenditures", length(fdf$NavyGross)),
      period = fdf$period),
    data.frame(
      year = fdf$year,
      loss = fdf$NavyNet,
      loss_type = rep("Net British Navy expenditures", length(fdf$NavyNet)),
      period = fdf$period),
    data.frame(
      year = fdf$year,
      loss = fdf$FrenchBudget,
      loss_type = rep("French Navy expenditures", length(fdf$FrenchBudget)),
      period = fdf$period),
    data.frame(
      year = fdf$year,
      loss = fdf$FR_Prize_value,
      loss_type = rep("Value of French prizes captured by Britain", length(fdf$FR_Prize_value)),
      period = fdf$period)
  )
}