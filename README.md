# Neanderthaler Distribution Model
DOI TBA

 This analyis circumscribes the ecological niche of Neanderthals between 560.000 and 360.000 years ago (MIS 11–14) in Europe. We informed the MaxEnt algorithm with archaeological presence data and paleoenvironmental reconstructions to calculate habitat suitability and derive the spatial range of the habitat. It is part of a study to estimate the prehistoric population density based on the environmental baseline of modern Hunter-Gatherers:
 > TBA

## Content
 The repository contains the R Project `neanderthaler_distribution_model.Rproj` and four folders.
  
 `data` contains the input data consisting of the dated archaeological sites (`Sites MIS11-MIS14.xlsx`), the study area (`study_area.shp`) and the segementation of the timespan into 11 slces (`timeslices.xlsx`).
 
 `work` contains intermediate results including data preprocessing (`oscillayer`, `npp`, `elevation`, `covariates`), selection of environmental data (`correlation`) and presence/background sample (`sample`), the selection of a suitable model (`maxent_model_selection`), the inference of the habitat suitability (`maxent_model_prediction`) and a binary classfication of the area suitable for Neanderthals (`maxent_model_classification`).
 
 `results` includes figures used in the publication and a validation of the model.
 
 `scripts` contains all the reproducible R scripts. The preprocessing procedure comprises the subsetting and reprojecting the Oscillayer dataset (`0.1_elevation.R`, `0.2_oscillayer.R`, `0.3_npp.R`, `0.4_reproject_and_align_rasters.R`). The model is informed with a presence sample (`1.1_presence_sample.R`) and an evaluated background sample (`1.3_background_sample`). We chose the 6 most informative covariates from the 19 Bioclim variables (`1.2_covariate_reduction.R`). With these data, we ran multiple MaxEnt models with different tuning parameters and seleceted the most suitable (`2.1_maxent_model_selection.R`). The selected was used to infer the habitat suitabiltiy of Neanderthals (`2.2_maxent_model_prediciton.R`). Based on the suitability we derived a binary classification to circumscribe the area potentially covered by Neanderthals in this region (`2.3_maxent_model_classification.R`).

 The Oscillayer dataset is missing due to its size and must be added manually (see References). 
```
 . neanderthaler_distribution_model.Rproj
 ├── data
 │   ├── Sites MIS11-MIS14.xlsx
 │   ├── study_area.shp
 │   └── timeslices.xlsx
 ├── work
 │   ├── oscillayer
 │   ├── npp
 │   ├── elevation
 │   ├── covariates
 │   ├── correlation
 │   ├── sample
 │   │   └── background_sample_validation
 │   ├── maxent_model_selection
 │   ├── maxent_model_prediction
 │   └── maxent_model_classification
 ├── results
 │   ├── fig_background_sample_validation.tiff
 │   ├── fig_model_evaluation.tiff
 │   ├── fig_model_performance
 │   ├── fig_model_results
 │   ├── fig_cumulative_habitats
 │   ├── fig_population_density
 │   └── validation
 └── scripts
     ├── 0.1_elevation.R
     ├── 0.2_oscillayer.R
     ├── 0.3_npp.R
     ├── 0.4_reproject_and_align_rasters.R
     ├── 1.1_presence_sample.R
     ├── 1.2_covariate_reduction.R
     ├── 1.3_background_sample.R
     ├── 2.1_maxent_model_selection.R
     ├── 2.2_maxent_model_prediciton.R
     ├── 2.3_maxent_model_classification.R
     └── 2.4_fig_model_performance.R
 
 
 
 ```
## References
 We used the following datasets:
 * Rodríguez, J., Willmes, C., & Mateos, A. (2021). Shivering in the Pleistocene. Human adaptations to cold exposure in Western Europe from MIS 14 to MIS 11. Journal of Human Evolution, 153, 102966. https://doi.org/10.1016/j.jhevol.2021.102966
 * Gamisch, A. (2019). Oscillayers: A dataset for the study of climatic oscillations over Plio-Pleistocene time-scales at high spatial-temporal resolution. Global Ecology and Biogeography, 28(11), 1552–1560. https://doi.org/10.1111/geb.12979
 
 We used the following software:
 * R Core Team. (2021). R: A language and environment for statistical computing (Version 4.0.5). Vienna, Austria: R Foundation for Statistical Computing. Retrieved from https://www.R-project.org/
 * Muscarella, R., Galante, P.J., Soley-Guardia, M., Boria, R.A., Kass, J., Uriarte, M. and R.P. Anderson (2014). ENMeval: An R package for conducting spatially independent evaluations and estimating optimal model complexity for ecological niche models. Methods in Ecology and Evolution.
 * Robert J. Hijmans (2021). raster: Geographic Data Analysis and Modeling. R package version 3.4-13. https://CRAN.R-project.org/package=raster
 * Pebesma, E., 2018. Simple Features for R: Standardized Support for Spatial Vector Data. The R Journal 10 (1), 439-446, https://doi.org/10.32614/RJ-2018-009
 * Roger S. Bivand, Edzer Pebesma, Virgilio Gomez-Rubio, 2013. Applied spatial data analysis with R, Second edition. Springer, NY. https://asdar-book.org/
 * Roger Bivand, Tim Keitt and Barry Rowlingson (2021). rgdal: Bindings for the 'Geospatial' Data Abstraction Library. R package version 1.5-23. https://CRAN.R-project.org/package=rgdal
 * Michael D. Sumner (2020). spdplyr: Data Manipulation Verbs for the Spatial Classes. R package version 0.4.0. https://CRAN.R-project.org/package=spdplyr
 * Hadley Wickham, Romain François, Lionel Henry and Kirill Müller (2021). dplyr: A Grammar of Data Manipulation. R package version 1.0.7. https://CRAN.R-project.org/package=dplyr 
 * H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.
 * Wickham et al., (2019). Welcome to the tidyverse. Journal of Open Source Software, 4(43), 1686, https://doi.org/10.21105/joss.01686
 * Wilke, C.O. (2020). cowplot: Streamlined Plot Theme and Plot Annotations for 'ggplot2'. R package version 1.1.1. https://CRAN.R-project.org/package=cowplot
 * QGIS Development Team (2021). QGIS Geographic Information System. Open Source Geospatial Foundation Project. http://qgis.osgeo.org
 
## Citation 

This work is available under the following DOI und published under the TBA license.
> TBA

