library(raster)
library(dplyr)
library(readxl)
library(readr)

# Variables
zipfile <- 'C:/cs/geodata/Oscillayers/INPUT.zip' # Set directory of the oscillayers dataset
studyarea <- shapefile('./data/study_area.shp')
timeslices <- read_excel("./data/timeslices.xlsx")
scaling_factors <- unzip(zipfile, files='Scaling_factor_TabS1.csv') %>% 
  read_csv(locale = locale(encoding = "ISO-8859-1")) %>% 
  rename() %>% rename(age=1,Oscillayer=2,TS=3,sealevel=4,temperature=5,scaling_factor=6)

timeslices <- timeslices %>% left_join(scaling_factors)

## Load and clip bathymetric DEM
dem <- unzip(zipfile, files='ETOPO1_res.asc') %>% 
  raster() %>% 
  crop(studyarea)
crs(dem) <- '+init=epsg:4326'


sealevels <- timeslices %>% group_by(MIS) %>% summarise(msealevel=mean(sealevel))

for(i in seq(1,nrow(sealevels))){
  print(sealevels$msealevel[i])  
  rfile <- dem - sealevels$msealevel[i]
  writeRaster(rfile, filename=paste('./work/elevation/elev_',sealevels$MIS[i],sep=''), format="GTiff", overwrite=TRUE)
}
