fmean_annual_loss_df = function(fdf){
  df = rbind(
    data.frame(
      year = unique(fdf$year),
      loss = fdf$loss,
      loss_type = rep("Loss", length(fdf$loss)),
      period = fdf$period, 
      loss_mean_annual = "Annual loss function"),
    data.frame(
      year = unique(fdf$year),
      loss = fdf$loss_nomemory,
      loss_type = rep("Loss no memory", length(fdf$loss_nomemory)),
      period = fdf$period,
      loss_mean_annual = "Annual loss function"),
    data.frame(
      year = unique(fdf$year),
      loss = fdf$mean_loss,
      loss_type = rep("Loss", length(fdf$loss)),
      period = fdf$period, 
      loss_mean_annual = "Mean loss function"),
    data.frame(
      year = unique(fdf$year),
      loss = fdf$mean_loss_nomemory,
      loss_type = rep("Loss no memory", length(fdf$loss_nomemory)),
      period = fdf$period,
      loss_mean_annual = "Mean loss function")
  )
}