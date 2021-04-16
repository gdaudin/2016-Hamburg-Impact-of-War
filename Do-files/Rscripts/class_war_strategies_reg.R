library(dplyr)
library(ggplot2)
library(ggpubr)
library(extrafont)
library(ggthemes)
library(tidyverse)
library(whoami)
library(zoo)

loadfonts()

if(username()=="Tirindelli"){
  HamburgPaperDir = "/Users/Tirindelli/Desktop/HamburgPaper/"
  HamburgDir = "/Volumes/GoogleDrive/My Drive/Hamburg/"
}

RscriptDir = "Do-files/Rscripts/"
GraphDir = "Graphs/"
DataframeDir = "Dataframe/"
NewgraphsDir = "New graphs/"
PaperDir = "Paper - Impact of War/Paper/"

hotelling = read.csv(paste(HamburgDir,"database_csv/temp_for_hotelling.csv", sep = ""))
fhotelling = hotelling
direction = "regional"
X_I = "X"
classification = "sitc"
period = ""

f = function(fhotelling, direction, X_I, classification, period){
  
  if(period=="pre1795") fhotelling = fhotelling[fhotelling$year<1795,]
  
  if(direction=="national"){
    if(classification=="sitc"){
      names(fhotelling)[names(fhotelling) == "product_sitc_simplEN"] = "class"
      fhotelling = fhotelling[fhotelling$best_guess_national_product==1,]
    }
    if(classification=="sitc_aggr"){
      names(fhotelling)[names(fhotelling) == "sitc_aggr"] = "class"
      fhotelling = fhotelling[fhotelling$best_guess_national_product==1,]
    }
    if(classification=="partner_grouping_8"){
      names(fhotelling)[names(fhotelling) == "partner_grouping_8"] = "class"
      fhotelling = fhotelling[fhotelling$best_guess_national_product==1,]
    }
  }
  
  if(direction=="regional"){
    #Computing total trade
    fhotelling = mutate(fhotelling, pour_calcul_national = best_guess_national_partner*value)
    fhotelling = fhotelling %>% group_by(year, export_import) %>% mutate(commerce_national = sum(pour_calcul_national, na.rm = TRUE))
    fhotelling$pour_calcul_national = NULL
    
    #Keeping nationl by region when available
    fhotelling$source_tout_region_one = ifelse(
      (fhotelling$source_type=="National toutes directions tous partenaires" | 
         fhotelling$source_type=="National toutes directions sans produits"), 1, 0)
    fhotelling = fhotelling %>% group_by(year) %>% 
      mutate(source_tout_region = max(source_tout_region_one, na.rm = TRUE))
    fhotelling = 
      fhotelling[!(fhotelling$source_tout_region==1 & 
                     fhotelling$source_type != "National toutes directions tous partenaires" & 
                     fhotelling$source_type !="National toutes directions sans produits"),]
 

    #Keeping best_guess_region_prodxpart (or the next best thing for 1789) otherwise. 
    #Nantes is 1789 is not complete
    fhotelling = fhotelling[!(fhotelling$best_guess_region_prodxpart !=1 & 
                               fhotelling$source_tout_region!=1 & 
                               fhotelling$year!=1789),]
    fhotelling = fhotelling[!(fhotelling$year==1789 & 
                               fhotelling$best_guess_national_region ==0),]
    fhotelling = fhotelling[!(fhotelling$year==1789 & 
                               fhotelling$customs_region =="Nantes"),]
    
    #Various
    fhotelling = fhotelling[fhotelling$year!=1714,]
    
    
    #Now to compute the share of trade
    fhotelling = fhotelling %>% group_by(customs_region_grouping, export_import, 
                                         year, commerce_national, period_str, war) %>%
      summarise(value = sum(value, na.rm = TRUE))
    fhotelling = fhotelling %>% mutate(percent=value/commerce_national)
    fhotelling = fhotelling[!(fhotelling$customs_region_grouping =="France" |  
                                fhotelling$customs_region_grouping =="Colonies Françaises de l'Amérique"  |  
                                fhotelling$customs_region_grouping =="" ),]
    names(fhotelling)[names(fhotelling) == "customs_region_grouping"] = "regional"
    fhotelling$regional = ifelse(fhotelling$regional=="Saint-Quentin", "Saint_Quentin", fhotelling$regional)
    
    fhotelling = fhotelling[!(fhotelling$regional=="Charleville" |  fhotelling$regional=="La Rochelle" |
                                fhotelling$regional=="Langres" | fhotelling$regional=="Rouen" | 
                                fhotelling$regional=="Montpellier" | fhotelling$regional=="Narbonne"),]
    #There is no usefull results for these
  }
  
  if(X_I=="Exports" | X_I=="Imports")  fhotelling = fhotelling[fhotelling$export_import==X_I,]
  
  if(direction!="regional"){
    fhotelling = fhotelling %>% group_by(year, class, export_import, period_str, war) %>%
      summarise(value= sum(value, na.rm = TRUE))
    fhotelling = fhotelling %>% group_by(year) %>% mutate(total = sum(value, na.rm=TRUE))
    fhotelling$percent= fhotelling$value/fhotelling$total
	}
		
  fhotelling$n_percent = log(fhotelling$percent)
	if(classification == "sitc") fhotelling = fhotelling[fhotelling$class != "Other",] 
  if(classification == "partner_grouping_8") fhotelling = fhotelling[fhotelling$class != "",] 
	
  fhotelling = fhotelling[c("year", "export_import", "class", "percent", "ln_percent", "war")]

	if(classification == "sitc"){
	  names(fhotelling)[names(fhotelling) == "class"] = "sitc_simplen"
	  short_sitc = read.csv(paste(HamburgDir,"database_csv/classification_product_simplEN_simplEN_short.dta.csv", sep = ""))
	  fhotelling = transform(merge(
	    x=cbind(fhotelling,source="master"),
	    y=cbind(short_sitc,source="merging"),
	    all=TRUE, by= sitc_simplen),
	    source=ifelse(!is.na(source.x) & !is.na(source.y), "both", 
	                  ifelse(!is.na(source.x), "master", "merging")),
	    source.x=NULL,
	    source.y=NULL
	  )
	  fhotelling = left_join(fhotelling, sitc_short, by = sitc_simplen)
		keep if _merge==3
		fhotelling$sitc_simplen = NULL
		names(fhotelling)[names(fhotelling) == "sitc_simplen_short"] = "class"
	}
		
	gen id=export_import+ `classification'
	replace id=subinstr(id," ","",.)
	drop export_import `classification'
	
  
  
  
  
  
}