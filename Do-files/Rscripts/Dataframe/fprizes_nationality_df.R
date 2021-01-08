fprizes_nationality_df = function(fdf){
  df = rbind(
    data.frame(
      year = fdf$year,
      prizes = fdf$Nbr_HCA34_and_other_Other,
      prizes_nationality = rep("Other prizes", length(fdf$Nbr_HCA34_and_other_Other))), 
    data.frame(
      year = fdf$year,
      prizes = fdf$Nbr_HCA34_and_other_Spain,
      prizes_nationality = rep("Spanish prizes", length(fdf$Nbr_HCA34_and_other_Spain))),
    data.frame(
      year = fdf$year,
      prizes = fdf$Nbr_HCA34_and_other_Neth,
      prizes_nationality = rep("Danish prizes", length(fdf$Nbr_HCA34_and_other_Neth))),
  data.frame(
    year = fdf$year,
    prizes = fdf$Nbr_HCA34_and_other_US,
    prizes_nationality = rep("US prizes", length(fdf$Nbr_HCA34_and_other_US)))
  )
}