#just add your directory 
a <- read.csv("/Users/Tirindelli/Google Drive/ETE/Thesis/database_dta/Total silver trade FR GB.csv")
X<- na.omit(a$log10_valueFR_silver)
library(urca)

lags=1
z=diff(X)
n=length(z)
#independent var
z.diff=embed(z, lags+1)[,1]
#Y_(t-1)
z.lag.1=X[(lags+1):n]
k=lags+1
#deltaY_(t-1)=Y_(t-1)-Y_(t-2)
z.diff.lag = embed(z, lags+1)[, 2:k]
#trend
temps=(lags+1):n

summary(lm(z.diff~1+temps+z.lag.1+z.diff.lag ))

#hypothesis: 
# What tau3 tests is whether we reject or not the null hypothesis of unit root
# (i.e. if we reject there is no unit root). 
# phi3 tests two things: 1) gamma = 0 (unit root) AND 2) there is no time trend term, i.e., a2=0. 
# If we rejected this null, it would imply that one or both of these terms was not 0. 
# phi2 tests 3 things: 1) gamma = 0 (unit root) AND 2) no time trend term AND 3) 
# no drift term, i.e. that gamma =0, that a0 = 0, and that a2 = 0. 
# Rejecting this null implies that one, two, OR all three of these terms was NOT zero.

zipf_coeff <- do.call(rbind,lapply(X[, 1:ncol(X) ],function(x, lags){
  df=ur.df(X,type="trend",lags = lags)
  test_statistic <- abs(summary(df)@teststat[1,1])
  critical_value <- abs(summary(df)@cval[1,1])
  result <- ifelse(test_statistic>critical_value,  'reject',  'not_reject')
  plot(df)
}))

#define X
all_series<- na.omit(a$log10_valueFR_silver)
before_1793<- na.omit(a[a$year<1793,]$log10_valueFR_silver)
after_1793<- na.omit(a[a$year>1793,]$log10_valueFR_silver)
X <- cbind(all_series, before_1793, after_1793)

case=c()
lags=c()
test_statistic=c()
critical_value=c()
result=c()
case_name=colnames(X)

for(i in 1:3){
  for (j in ncol(X)) {
    x=X[,j]
    df=ur.df(x,type="trend",lags = i)
    case[j]=case_name[j]
    lags[j]=i
    test_statistic[j] <- abs(summary(df)@teststat[1,1])
    critical_value[j] <- abs(summary(df)@cval[1,1])
    #result[j] <- ifelse(test_statistic>critical_value,  'reject',  'not_reject')
  }
}

dickey_fuller <- data.frame(case, lags,test_statistic, critical_value, result)

unit_root(X, 0)




