library(dplyr)
library(tidyr)
hotelling = read.csv("/Volumes/GoogleDrive/My Drive/Hamburg/database_csv/temp_for_hotelling.csv")
df = hotelling

composition_trade_test = function(df, period1, period2, plantation_yesno, direction, X_I, classification){}

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
  df = df %>% group_by(year) %>% mutate(percent = ifelse(is.na(percent), min(percent/2, na.rm = TRUE), percent))
  df$ln_percent = log(df$percent)    
  df_for_manova = data.frame(year=df$year, class=df$class, period = df$period_str, ln_percent=df$ln_percent)
  df_for_manova = df_for_manova %>% pivot_wider(names_from = class, values_from = ln_percent)
  man = manova(cbind(df_for_manova[,c(3:14)]) ~ df_for_manova$period)
  

	# I am excluding one category from the test cause they sum uo to a 100 
		
	global `name'`plantation_yesno'`dir'=round(r(p_F),0.01)
	global temp= ${`name'`plantation_yesno'`dir'}
	di ${`name'`plantation_yesno'`dir'}
	// I am storing it as a global macro because I am reporting it in the graphs, so the graph.do can use them
	// I copy the macro in temp for simplicity of use in this do file
	
	if "`X_I'"=="Exports" & `plantation_yesno'==1{
		matrix A= ($temp, 0,0,0,0,0)
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}
	if "`X_I'"=="Exports" & `plantation_yesno'==0{
		matrix A= (0, $temp ,0,0,0,0)
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}
		
	if "`X_I'"=="Imports" & `plantation_yesno'==1{
		matrix A= (0, 0, $temp, 0,0,0)
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}
	if "`X_I'"=="Imports" & `plantation_yesno'==0{
		matrix A= (0, 0,0,$temp, 0,0)
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}
		
	if "`X_I'"=="I_X" & `plantation_yesno'==1{
		matrix A= (0, 0,0,0,$temp, 0)
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}
	if "`X_I'"=="I_X" & `plantation_yesno'==0{
		matrix A= (0, 0,0,0,0,$temp )
		matrix rowname A = "`period1'_`period2'"
		matrix list A
		}	

end

