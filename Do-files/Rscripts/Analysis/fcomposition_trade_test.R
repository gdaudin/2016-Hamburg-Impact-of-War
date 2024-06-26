fcomposition_trade_test = function(df, period1, period2, plantation_yesno, direction, X_I, classification){
  names(df)[names(df) == classification] = "class"
  if(direction=="national"){
    if(classification=="product_sitc_simplEN") df = df[df$best_guess_national_product==1,]
    if(classification=="sitc_aggr") df = df[df$best_guess_national_product==1,]
    if(classification=="partner_grouping_8") df = df[df$best_guess_national_partner==1,]
  }
  df = df %>% group_by(year, class, export_import, period_str) %>% 
    summarize(sum_value = sum(value))
  
  if(plantation_yesno==0 & classification=="product_sitc_simplEN") df = df[df$product_sitc_simplEN!="Plantation foodstuff",]
  
  if(X_I=="Exports" | X_I=="Imports"){
    df = df[df$export_import==X_I,]
    df = df %>% group_by(year) %>% mutate(percent= sum_value/sum(sum_value, na.rm = TRUE))
  }else{
    df = df %>% group_by(year, war, class, period_str) %>% 
      summarize(sum_value_xi = sum(sum_value, na.rm = TRUE))
    df = df %>% group_by(year) %>% mutate(percent= sum_value_xi/sum(sum_value_xi, na.rm = TRUE))
  }
  
  df = df[(df$period_str == period1 | df$period_str == period2),]
  df = df[df$class!="",]
  df = df %>% group_by(year) %>% mutate(percent = ifelse(is.na(percent), min(percent/2, na.rm = TRUE), percent))
  df$ln_percent = log(df$percent)    
  df_for_manova = data.frame(year=df$year, class=df$class, period = df$period_str, ln_percent=df$ln_percent)
  df_for_manova = df_for_manova %>% pivot_wider(names_from = class, values_from = ln_percent)
  matrix_period1 = data.matrix(df_for_manova[df_for_manova$period==period1, 3:ncol(df_for_manova)])
  matrix_period2 = data.matrix(df_for_manova[df_for_manova$period==period2, 3:ncol(df_for_manova)])
  man = hotelling.test(matrix_period1, matrix_period2)
  return(man$p.value)
}