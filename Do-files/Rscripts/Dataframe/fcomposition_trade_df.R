fcomposition_trade_df = function(df, period1, period2, plantation_yesno, direction, X_I, classification){
  names(df)[names(df) == classification] = "class"
  if(direction=="national"){
    if(classification=="product_sitc_simplEN") df = df[df$best_guess_national_product==1,]
    if(classification=="sitc_aggr") df = df[df$best_guess_national_product==1,]
    if(classification=="partner_grouping_8") df = df[df$best_guess_national_partner==1,]
  }
  df = df %>% group_by(year, class, export_import, period_str) %>% 
    summarize(sum_value = sum(value, na.rm = TRUE))
  df = df[df$class != "[vide]" & df$class != "????" ,]
  
  if(plantation_yesno==0 & classification=="product_sitc_simplEN") df = df[df$product_sitc_simplEN!="Plantation foodstuff",]
  
  if(X_I=="Exports" | X_I=="Imports"){
    df = df[df$export_import==X_I,]
    df = df %>% group_by(year) %>% mutate(percent= sum_value/sum(sum_value, na.rm = TRUE))
  }else{
    df = df %>% group_by(year, war, class, period_str) %>% 
      summarize(sum_value_xi = sum(sum_value, na.rm = TRUE))
    df = df %>% group_by(year) %>% mutate(percent= sum_value_xi/sum(sum_value_xi, na.rm = TRUE))
  }
  
  if(period1 == "War" | period2 =="War"){
    df$period_str = ifelse(substr(df$period_str,1,5)=="Peace", "Peace", "War")
  }
  df = df[(df$period_str == period1 | df$period_str == period2),]
  df = df[df$class!="",]
  df = df %>% group_by(year) %>% mutate(percent = ifelse(is.na(percent), min(percent/2, na.rm = TRUE), percent))
  df$ln_percent = log(df$percent)   
  df$period_comb = paste(unique(df$period_str)[1], " and ", unique(df$period_str)[2], sep = "")
  return(df)
}