library(raster)
library(dplyr)


# Variables
setwd('C:/cs/mid-pleistocene_niches/work')

path <- 'C:/cs/geodata/Oscillayers'
studyarea <- shapefile('../work/study_area.shp')
targetdir = paste(getwd(),'oscillayer', sep='/')

# Export
## Function to open zip files, extract filp, clip AOI and save to drive
clipzip <- function(zipfile, filename, studyarea, targetdir){
  file <- unzip(zipfile, files=filename, exdir=targetdir)
  rfile <- raster(file)
  crs(rfile) <- '+init=epsg:4326'
  clipped <- crop(rfile, studyarea)
  targetfile <- paste(targetdir,filename, sep='/')
  writeRaster(clipped, filename=targetfile, format="GTiff", overwrite=TRUE)
  file.remove(paste(targetdir, filename, sep='/'))
  return(clipped)
}

## Export Just a single file
zipfile <- 'Bio1_Pleistocene.zip'
zipdir <- paste(path, zipfile, sep='/')
filename <- 'bio1_t2.asc'
clipzip(zipdir, filename, studyarea, targetdir)

## Export a list
ziplist <- list.files(path, pattern= '*Pleistocene.zip', full.names = TRUE)
timelist <- seq(37,56,1)

for(zip in ziplist){
  print(zip)
  zipped <- unzip(zip, list=TRUE)$Name
  for(timeslice in timelist){
    filename <- zipped[grep(paste('*t',timeslice,'.asc', sep=''), zipped)]
    print(filename)
    
    clipzip(zip,
            filename=filename,
            studyarea=studyarea,
            targetdir=targetdir)
    }
}

# Aggregate to specified time-slices
setwd('C:/cs/mid-pleistocene_niches/work/oscillayer')
for(prefix in paste('bio', seq(1,19,1), sep='')){
  print(prefix)
  brick(list(paste(prefix, '_t37.tif', sep=''), paste(prefix, '_t38.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS11ab',sep=''), format="GTiff", overwrite=TRUE)
  brick(list(paste(prefix, '_t39.tif', sep=''), paste(prefix, '_t40.tif', sep=''),paste(prefix, '_t41.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS11c',sep=''), format="GTiff", overwrite=TRUE)
  brick(list(paste(prefix, '_t42.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS11de',sep=''), format="GTiff", overwrite=TRUE)
  brick(list(paste(prefix, '_t43.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS12a',sep=''), format="GTiff", overwrite=TRUE)
  brick(list(paste(prefix, '_t44.tif', sep=''), paste(prefix, '_t45.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS12b',sep=''), format="GTiff", overwrite=TRUE)
  brick(list(paste(prefix, '_t46.tif', sep=''), paste(prefix, '_t47.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS12c',sep=''), format="GTiff", overwrite=TRUE)
  brick(list(paste(prefix, '_t38.tif', sep=''), paste(prefix, '_t49.tif', sep=''),paste(prefix, '_t50.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS13a',sep=''), format="GTiff", overwrite=TRUE)
  brick(list(paste(prefix, '_t51.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS13b',sep=''), format="GTiff", overwrite=TRUE)
  brick(list(paste(prefix, '_t52.tif', sep=''), paste(prefix, '_t53.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS13c',sep=''), format="GTiff", overwrite=TRUE)
  brick(list(paste(prefix, '_t54.tif', sep=''), paste(prefix, '_t55.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS14ac',sep=''), format="GTiff", overwrite=TRUE)
  brick(list(paste(prefix, '_t56.tif', sep=''))) %>% mean() %>% writeRaster(filename=paste(prefix,'_MIS14d',sep=''), format="GTiff", overwrite=TRUE)
}