library(raster)
library(dplyr)
library(readxl)

oscill_path <- './work/oscillayer/'
oscill_list <- list.files('./work/oscillayer/', full.names = T)
tstab <- read_excel("./data/timeslices.xlsx") %>% distinct(MIS, .keep_all = T)

# NPP: Miami model
npp <- function(temp, prec){
  npp_temp <- 3000 * (1 + exp(1.315-0.119*temp))
  npp_prec <- 3000 * (1 - exp(-0.000664*prec))
  return(min(npp_temp, npp_prec))
}

for(intervall in tstab$MIS){
  rtemp <- list.files(oscill_path, full.names = T, pattern = paste('bio1',intervall, sep='_')) %>% raster()/10
  rprec <- list.files(oscill_path, full.names = T, pattern = paste('bio12',intervall, sep='_')) %>% raster()
  rnpp <- npp(rtemp, rprec)
  writeRaster(rnpp, filename=paste('./work/npp/npp_',intervall,sep=''), format="GTiff", overwrite=TRUE)
}
