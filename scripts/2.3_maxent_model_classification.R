library(dismo)
library(raster)
library(readxl)

set.seed(31)
maxent_model <- readRDS('./work/maxent_model_selection/maxent_eval_select.RDS')
sites <- read_excel("./work/maxent_model_prediction/Sites MIS11-MIS14_predicted.xlsx",     # Excel file with predicted values for each site
                    col_types = c("numeric", "text", "text", 
                                  "text", "text", "text", "text", "text", 
                                  "text", "text", "numeric", "numeric", 
                                  "numeric"))
rasterlist <- list.files('./work/maxent_model_prediction', full.names=T, pattern='pred_mean')

thrs <- quantile(sites$predicted,0.05)  # 5% percentile of predicted training sites is used as threshold


# Reclassify
for(r in rasterlist){
  basename(r)
  rfile <- raster(r) > thrs
  writeRaster(rfile, paste('./work/maxent_model_classificaiton/range_',basename(r), sep=''), overwrite=TRUE)
}


# Merge 
rasterlist <- list.files('./work/maxent_model_classificaiton/', full.names=T, pattern='.tif')

rasterstack <- stack()
for(i in rasterlist){
  rasterfile <- raster(i)
  rasterfile[is.na(rasterfile)] <- 0
  plot(rasterfile)
  rasterstack <- addLayer(rasterstack,rasterfile)
}

merge <- sum(rasterstack)
clip <- raster('./work/maxent_model_classificaiton/cumulative/full_extent_mis12b.tif') # this is a land-water mask prepared of maximal land expansion prepared in GIS
merge <- merge*clip
writeRaster(merge, './work/maxent_model_classificaiton/cumulative/combined_rasters.tif', overwrite=TRUE)


