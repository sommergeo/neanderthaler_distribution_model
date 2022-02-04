library(raster)
library(dplyr)

# Variables
setwd('C:/cs/mid-pleistocene_niches/work/elevation')
studyarea <- shapefile('../study_area.shp')

# Load and clip bathymetric DEM
gebco <- raster('C:/cs/geodata/GEBCO/unzipped_GEBCO_2020_bathymetry/gebco_global.tif') %>% 
  crop(studyarea)

# Load sea level curve
## Sea level data
library(readr)
sealevel <- read_delim("https://www.ncei.noaa.gov/pub/data/paleo/contributions_by_author/spratt2016/spratt2016.txt", 
                       "\t", escape_double = FALSE, col_types = cols(X10 = col_skip()), 
                       trim_ws = TRUE, skip = 95)
write.csv(sealevel,"sealevel_spratt2016.csv", row.names = T)

## Time slices
sealmean <- function(table, agemin, agemax){
  table %>% filter(age_calkaBP >= agemin, age_calkaBP < agemax) %>% 
    pull(SeaLev_longPC1) %>% mean()}

tstab <- read_excel("../timeslices.xlsx") %>% 
  distinct(MIS, .keep_all = T) %>% 
  select(-c(Oscillayer,Age)) %>% 
  rowwise() %>% mutate(sealvl=sealmean(sealevel, Age_min, Age_max))

write.csv(tstab,"sealevel_timeslices.csv", row.names = T)

# Generate relative sea level rasters
for(i in 1:nrow(tstab)){
  print(tstab$sealvl[i])
  rfile <- gebco-tstab$sealvl[i]
  writeRaster(rfile, filename=paste('elev_',tstab$MIS[i],sep=''), format="GTiff", overwrite=TRUE)
}
