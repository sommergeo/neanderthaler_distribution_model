library(tidyverse)
library(raster)

# Variables
rasterlist <- list.files('./work/covariates', full.names=T)
rasterstack <- stack(rasterlist)
variable_levels = c('bio1','bio2','bio3','bio4','bio5','bio6','bio7','bio8','bio9','bio10','bio11','bio12','bio13','bio14','bio15','bio16','bio17','bio18','bio19','npp','elev')
interval_levels = c()
points <- rasterToPoints(rasterstack) %>% data.frame() %>% 
  filter(complete.cases(.)) %>%  # Remove NAs
  mutate(id=as.numeric(rownames(.))) %>% # create a point ID
  pivot_longer(cols=-c(id,x,y), names_to='feat', values_to='val') %>% 
  tidyr::extract(col=feat, into=c('variable','interval'), "([[:alnum:]]+)_([[:alnum:]]+)") %>% # separate variables and timeslices 
  mutate(variable = factor(variable, levels = c('bio1','bio2','bio3','bio4','bio5','bio6','bio7','bio8','bio9','bio10','bio11','bio12','bio13','bio14','bio15','bio16','bio17','bio18','bio19','npp','elev'))) %>% 
  pivot_wider(names_from = variable, values_from = val)

write.csv(points, './work/sample/full_record.csv')
saveRDS(points, './work/sample/full_record.rds')




# Correlation
library(Hmisc)
library(corrplot)

## Pearson
### Correlation
cor1 <- rcorr(points %>% dplyr::select(-c(x,y,id,interval,npp)) %>% as.matrix(), type=c("pearson"))
write.csv(cor1$r, './work/correlation/pearson_coeff.csv')
write.csv(cor1$p, './work/correlation/pearson_p-value.csv')

### Correlation plot
tiff("./work/correlation/pearson_coeff.tiff", units="cm", width=15, height=15, res=300)
corrplot(cor1$r, method = "color", type = "upper", order = "hclust",
         addCoef.col = "black", number.cex = .5, # add labels
         tl.col = "black", tl.srt = 90)
dev.off()

## Spearman
### Correlation
cor2 <- rcorr(points %>% dplyr::select(-c(x,y,id,interval,npp)) %>% as.matrix(), type=c("spearman"))
write.csv(cor2$r, './work/correlation/spearman_coeff.csv')
write.csv(cor2$p, './work/correlation/spearman_p-value.csv')

### Correlation plot
tiff("./work/correlation/spearman_coeff.tiff", units="cm", width=15, height=15, res=300)
corrplot(cor2$r, method = "color", type = "upper", order = "hclust",
         addCoef.col = "black", number.cex = .5, # add labels
         tl.col = "black", tl.srt = 90)
dev.off()

## Correlation chart
library(PerformanceAnalytics)

tiff("./work/correlation/correlation_chart.tiff", units="cm", width=40, height=40, res=300)
chart.Correlation(points %>% sample_n(100000) %>% dplyr::select(-c(x,y,id,interval,npp)), histogram=TRUE, pch=20)
dev.off()



# Collinearity
library(fuzzySim)

collinearity_all <- multicol(vars=points %>% dplyr::select(-c(x,y,id,interval,npp)) %>% as.data.frame()) %>% mutate(feat=rownames(.))
collinearity_r90 <- multicol(vars=points %>% dplyr::select(-c(x,y,id,interval,npp,bio4,bio5,bio6,bio8,bio9,bio10,bio11,bio13,bio14)) %>% as.data.frame()) %>% mutate(feat=rownames(.))
collinearity_VIF5 <- multicol(vars=points %>% dplyr::select(-c(x,y,id,interval,npp,bio3,bio4,bio5,bio6,bio8,bio9,bio10,bio11,bio13,bio14,bio16,bio17,bio18,bio19)) %>% as.data.frame() %>% mutate(feat=rownames(.)))
collinearity_VIF5 <- multicol(vars=points %>% dplyr::select(bio1, bio2, bio7, bio12, bio15, elev) %>% as.data.frame()) %>% mutate(feat=rownames(.))


collinearity_table <- collinearity_all %>% 
  left_join(collinearity_r90, by='feat') %>%
  left_join(collinearity_VIF5, by='feat') %>% 
  dplyr::rename(Rsquared.filter0=Rsquared.x, Tolerance.filter0=Tolerance.x,VIF.filter0=VIF.x,
                Rsquared.filter1=Rsquared.y, Tolerance.filter1=Tolerance.y,VIF.filter1=VIF.y,
                Rsquared.filter2=Rsquared, Tolerance.filter2=Tolerance,VIF.filter2=VIF)


write.csv(collinearity_table, './work/correlation/collinearity_table.csv')




# Normality
library(ggplot2)

point_normality <- points %>% sample_n(10000) %>% select(-npp) %>% 
  pivot_longer(cols=-c(x,y,id,interval), names_to = 'variable', values_to = 'val')
plotqq <- ggplot(data=point_normality, aes(sample=val))+
  stat_qq()+
  stat_qq_line()+
  facet_wrap(~variable, scales = 'free')

tiff("./work/correlation/normality_qqplots.tiff", units="cm", width=18, height=18, res=300)
plotqq
dev.off()
