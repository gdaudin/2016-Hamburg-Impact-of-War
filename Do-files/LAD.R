library(MASS)

reduite=read.csv("/Users/Tirindelli/Google Drive/Hamburg/database_dta/bdd_courante_reduite2.csv")
reduite1 = reduite %>% group_by(exportsimports, year, product_sitc_simplEN) %>% summarise(value=sum(value, na.rm = TRUE))
reduite1 = reduite1[reduite1$year>1748,]
reduite1 = reduite1[reduite1$product_sitc_simplEN !="",]
reduite1 = reduite1 %>% group_by(exportsimports, year) %>% mutate(percent=log(value/sum(value, na.rm=TRUE)))

peace_war=c(1748,1755,1763,1777,1783,1792,1807,1815,1840)
peace_war_label = c("Peace 1749-1755","War 1756-1763","Peace 1764-1777","War 1778-1783",
                    "Peace 1784-1792","War 1793-1807","Blockade 1808-1815","Peace 1816-1840")
reduite1$period_str=cut(reduite1$year,peace_war)
levels(reduite1$period_str) = peace_war_label
reduite1$peace_war=as.integer(grepl(pattern = "Peace", x = reduite1$period_str))
levels(reduite1$peace_war) = c("Peace", "War")

break_years= unique(reduite1[reduite1$year>1758 & reduite1$year<1814,]$year)
exportsimports=c("Exports", "Imports", "X_I")
success_rate=c()
window20 = FALSE

for(j in exportsimports){
  
  if(j != "X_I"){
    reduiteXI=cast(reduite1[reduite1$exportsimports==j,c(1:3,5)], year~product_sitc_simplEN, mean, value = "percent")
  }else{
    temp = reduite1 %>% group_by(year, product_sitc_simplEN) %>% summarise(value=sum(value, na.rm = TRUE))
    temp = temp %>% group_by(year) %>% mutate(percent=log(value/sum(value, na.rm = TRUE)))
    reduiteXI=cast(temp[c(1:2,which( colnames(temp)=="percent" ))], year~product_sitc_simplEN, mean, value = "percent")
  }
  reduiteXI[is.na(reduiteXI)] =0
  if(window20){reduiteXIsave=reduiteXI}
  
  for(i in break_years){
    
    if(window20){
      after10=i+15
      before10=i-15
      reduiteXI=reduiteXIsave[(reduiteXIsave$year>before10 & reduiteXIsave$year<after10),]
    }
    
    reduiteXI$peace_war = ifelse(reduiteXI$year>i,1,0)
    reduiteT=reduiteXI[-c(1,14)]
    
    lda_fit=lda(reduiteT[,-13], grouping=reduiteT[,13])
    lda_pred=predict(lda_fit, reduiteXI[c(2:13)])
    reduiteXI$lda_class=lda_pred$class
    table(reduiteXI$lda_class, reduiteXI$peace_war)
    success_rate = c(success_rate, mean(reduiteXI$lda_class==reduiteXI$peace_war))
    
    reduiteXI$lda_class = reduiteXI$peace_war = NULL
  }
  temp = data.frame(cbind(
    break_years = break_years,
    success_rate = success_rate,
    exportsimports = rep(j, length(break_years))
  ))
  if(j==exportsimports[1]){
    success_rate_df = temp
  } else success_rate_df = rbind(success_rate_df,temp)
  success_rate = c()
}

success_rate_df$success_rate=as.numeric(success_rate_df$success_rate)
success_rate_df$break_years=as.numeric(success_rate_df$break_years)

ggplot(data=success_rate_df) +
  geom_rect(aes(xmin = 1757, xmax = 1763, ymin = -Inf, ymax = Inf), fill = "grey", alpha = 0.01 ) +
  geom_rect(aes(xmin = 1778, xmax = 1783, ymin = -Inf, ymax = Inf), fill = "grey", alpha = 0.01) +
  geom_rect(aes(xmin = 1793, xmax = 1807, ymin = -Inf, ymax = Inf), fill = "grey", alpha = 0.01) +
  geom_rect(aes(xmin = 1808, xmax = 1815, ymin = -Inf, ymax = Inf), fill = "darkgrey", alpha = 0.01) +
  scale_x_continuous(name="Break years", breaks = seq(1759,1813,10)) +
  scale_y_continuous(name="Success rate", breaks = seq(.8,1,.05)) +
  geom_point(aes(x=break_years, y=success_rate), size = 1) +
  geom_line(aes(x=break_years, y=success_rate)) +
  facet_wrap(~exportsimports)

rm(lda_fit, lda_pred, reduiteT, reduiteXI, reduiteXIsave, success_rate_df, temp)
