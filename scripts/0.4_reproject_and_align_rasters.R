library(raster)
library(dplyr)

# set projection
library(sf)
EPSG3035 <- st_crs(3035)

dummy <- raster('./work/oscillayer/bio1_MIS11ab.tif') %>% 
  projectRaster(crs=EPSG3035$wkt)


# Warp Elevation
list_elev <- list.files('./work/elevation/', full.names = T, pattern='.tif')
for(i in list_elev){
  raster(i) %>% 
    projectRaster(to=dummy) %>% 
    writeRaster(filename=paste0('./work/covariates/', basename(i)), format="GTiff", overwrite=TRUE)
}

# Warp Oscillayer
list_oscillayer <- list.files('./work/oscillayer/', full.names = T, pattern='MIS')
for(i in list_oscillayer){
  raster(i) %>% 
    projectRaster(to=dummy) %>% 
    writeRaster(filename=paste0('./work/covariates/', basename(i)), format="GTiff", overwrite=TRUE)
}

# Warp NPP
list_npp <- list.files('./work/npp/', full.names = T, pattern='.tif')
for(i in list_npp){
  raster(i) %>% 
    projectRaster(to=dummy) %>% 
    writeRaster(filename=paste0('./work/covariates/', basename(i)), format="GTiff", overwrite=TRUE)
}
