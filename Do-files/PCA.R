library('aroma.light')

reduite=read.csv("/Users/Tirindelli/Google Drive/Hamburg/database_dta/bdd_courante_reduite2.csv")
reduite1 = reduite %>% group_by(exportsimports, year, product_sitc_simplen) %>% summarise(value=sum(value, na.rm = TRUE))
reduite1 = reduite1[reduite1$year>1748 & reduite1$year<1823,]
reduite1 = reduite1[reduite1$product_sitc_simplen !="",]
reduite1 = reduite1 %>% group_by(exportsimports, year) %>% mutate(percent=value/sum(value, na.rm=TRUE))

loss = read.csv("/Users/Tirindelli/Google Drive/Hamburg/database_dta/Annual_loss.csv")
loss = loss[c(which(colnames(loss)=="year"), which(colnames(loss)=="loss"), which(colnames(loss)=="loss_nomemory"))]

exportsimports=c("Exports", "Imports", "X_I")

for(j in exportsimports){
  
  if(j != "X_I"){
    reduiteXI=cast(reduite1[reduite1$exportsimports==j,c(1:3,5)], year~product_sitc_simplen, mean, value = "percent")
    year = unique(reduiteXI$year)
    reduiteXI= reduiteXI[-c(which( colnames(reduiteXI)=="year" ), which( colnames(reduiteXI)=="Other" ))]
  }else{
    temp = reduite1 %>% group_by(year, product_sitc_simplen) %>% summarise(value=sum(value, na.rm = TRUE))
    temp = temp %>% group_by(year) %>% mutate(percent=value/sum(value, na.rm = TRUE))
    reduiteXI=cast(temp[c(1:2,which( colnames(temp)=="percent" ))], year~product_sitc_simplen, mean, value = "percent")
    reduiteXI= reduiteXI[-c(which( colnames(reduiteXI)=="year" ), which( colnames(reduiteXI)=="Other" ))]
  }
  reduiteXI[is.na(reduiteXI)] =0
  reduiteXI = data.matrix(reduiteXI, rownames.force = NA)
  w=colMeans(reduiteXI)
  reduiteXI_pca <- wpca(reduiteXI, w=w,center = TRUE,scale. = TRUE)
  if(j==exportsimports[1]){
    PCA = data.frame(year = year, PC1 = reduiteXI_pca$pc[,1] )
    colnames(PCA)[2] = j
  } else{
    PCA = cbind(PCA, PC1 = reduiteXI_pca$pc[,1])
    colnames(PCA)[which(colnames(PCA)=="PC1")] = j
  }
}

PCA_loss=merge(PCA, loss, by ="year")
PCA_loss = na.omit(PCA_loss)

for(i in exportsimports){
  m1=lm(PCA_loss$loss~PCA_loss[,which(colnames(PCA_loss)==i)])
  m2=lm(PCA_loss$loss_nomemory~PCA_loss[,which(colnames(PCA_loss)==i)])
  temp=data.frame(
    exportsimports = i,
    corr_loss = cor(PCA_loss$loss, PCA_loss[,which(colnames(PCA_loss)==i)]),
    corr_loss_nomem = cor(PCA_loss$loss_nomemory, PCA_loss[,which(colnames(PCA_loss)==i)]),
    beta_loss = m1$coeff[[2]],
    beta_loss_pval=summary(m1)$coefficients[2,4],
    beta_loss_nomemory = m2$coeff[[2]],
    beta_loss_nm_pval=summary(m2)$coefficients[2,4]
  )
  if(i==exportsimports[1]){
    corr_loss_df=temp
  }else{corr_loss_df=rbind(corr_loss_df,temp )}
}

PCA_loss_long =reshape2::melt(PCA_loss, id.vars=c("year", "loss", "loss_nomemory"), 
     measure.vars=c("Exports", "Imports", "X_I" ), variable.name="exportsimports", value.name="PC1")

ggplot(data=PCA_loss_long) +
  geom_point(aes(x=PC1, y=loss)) +
  facet_wrap(~exportsimports)

geom_abline(mapping = loss~PC1 ) +
  
