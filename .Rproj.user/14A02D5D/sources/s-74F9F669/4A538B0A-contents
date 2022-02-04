library(tidyverse)
library(readxl)
library(sf)
library(sp)
library(raster)
library(rgdal)
library(spdplyr)



# Coordinate Systems
EPSG3035 <- st_crs(3035)  # New CRS
EPSG4326 <- st_crs(4326)  # Original CRS

# Load arch. sites
sites <- read_excel("./data/Sites MIS11-MIS14.xlsx", 
                    sheet = "Niche_modelling_v3", col_types = c("numeric", 
                                                                "text", "text", "numeric", "numeric", 
                                                                "text", "text", "text", "text", "text"))
coordinates(sites) <- ~long+lat
crs(sites) <- CRS(EPSG4326$wkt)
sites <- sites %>% spTransform(CRS(EPSG3035$wkt))

writeOGR(sites, dsn='./work/sample', layer='arch_sites', driver = "ESRI Shapefile")




# Create Sample
## Create an empty raster with the template layout
dummy <- raster() %>%
  projectRaster(to=raster('./work/covariates/bio1_MIS11ab.tif')) %>% 
  rasterToPoints(spatial=T)

## Construct sample points
buffer <- buffer(sites, width=10000, dissolve=F)
sample <- raster::intersect(dummy, buffer)

sample@data <- sample@data %>% mutate(x=as.numeric(sample@coords[,'x']), y=as.numeric(sample@coords[,'y']), id=rownames(.)) %>% 
  tidyr::extract(col=id, into=c('id_sub'), "[[:alnum:]]+[[:punct:]]([[:alnum:]]+)", remove=F) %>%
  mutate(id_sub=ifelse(is.na(id_sub), 0, id_sub))

# Get environmental values and apply special treatment for sites that span multiple time slices
rasterstack <- list.files('./work/covariates', full.names=T) %>% stack()

sample2 <- raster::extract(rasterstack, sample, sp=T)@data %>% 
  pivot_longer(cols=-c(code:id_sub), names_to='feat', values_to='val') %>% 
  tidyr::extract(col=feat, into=c('variable','ts'), "([[:alnum:]]+)_([[:alnum:]]+)") %>% 
  pivot_wider(id_cols=c(id, ts), names_from = variable, values_from = val)

sample3 <- sample %>% left_join(sample2, by=c('id'='id', 'interval'='ts')) %>% 
  data.frame() %>% 
  group_by(code,id_sub, x, y, locality, unit, age_range, references, comment) %>% 
  dplyr::summarize(across(bio1:npp,mean))

sample4 <- cbind(sample3$y, sample3$y) %>% SpatialPointsDataFrame(sample3)
crs(sample4) <- CRS(EPSG3035$wkt)

saveRDS(sample4, 'sample_points.rds')
writeOGR(sample4, dsn='.', layer='sample_points', driver = "ESRI Shapefile")