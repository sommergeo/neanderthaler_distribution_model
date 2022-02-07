library(tidyverse)
library(dismo)
library(raster)

set.seed(31)
maxent_model <- readRDS('./work/maxent_model_selection/maxent_eval_select.RDS')

# Load covariates
rasterlist <- list.files('./work/covariates', full.names=F) %>% as.data.frame() %>% rename(name=1) %>% 
  tidyr::extract(col=name, into=c('variable','interval'), "([[:alnum:]]+)_([[:alnum:]]+)", remove=F)

list_variables <- unique(rasterlist$variable)
list_intervals <- unique(rasterlist$interval)

# predict all intervals
for(interval_subset in list_intervals){
  print(interval_subset)
  predictors <- rasterlist %>% filter(interval==interval_subset) %>% 
    pull(name) %>% paste('./work/covariates',., sep='/') %>% stack()
  names(predictors) <- names(predictors) %>% as.data.frame %>% tidyr::extract(1, "([[:alnum:]]+)_[[:alnum:]]+") %>% pull()
  prediction <- predict(maxent_model, predictors)
  writeRaster(mean(prediction), paste('./work/maxent_model_prediction/pred_mean_',interval_subset, '.tif', sep=''), overwrite=TRUE)
  writeRaster(calc(prediction,sd), paste('./work/maxent_model_prediction/pred_std_',interval_subset, '.tif', sep=''), overwrite=TRUE)
}
