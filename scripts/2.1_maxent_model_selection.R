#library(dplyr)
library(tidyverse)
library(dismo)
options(java.parameters = "-Xmx20g" )
jar <- paste(system.file(package="dismo"), "/java/maxent.jar", sep='')
library(ENMeval) #v2.0.0

set.seed(31)
covariates <- c('x','y','bio1','bio2','bio7','bio12','bio15','elev')  # Covariates selected in script 1.2_covariates_selection



#### Evaluate combinations of FCs and RMs ----

# load data and set type, where 0=background, 1=sample, as indicated in dismo::maxent
## presence sample
sample <- readRDS('./work/sample/sample_points.RDS')@data %>% 
  as.data.frame() %>% 
  drop_na(bio1:npp) %>% 
  mutate(type=1)
occurence <- sample %>% select(all_of(covariates))

## background sample
background <- readRDS('./work/sample/background_sample_points.RDS') %>% 
  mutate(type=0) %>% 
  select(all_of(covariates))

# define grouped presence samples
user.grp <- list(occs.grp = sample %>% pull(code), # Make sure that NO number is missing
                 bg.grp = rep(unique(sample$code), length.out=nrow(background)))

# Evaluate models
maxent_eval <- ENMevaluate(occs=occurrence,
                           bg=background,
                           algorithm='maxent.jar',
                           partitions='user',
                           user.grp=user.grp,
                           tune.args = list(
                             fc=c('L','LQ','LQH', 'LQP', 'LQHP', 'LQHPT'),
                             rm=c(0.2,0.4,0.6,0.8,1,1.5,2,3,4)),
                           parallel=T)


View(maxent_eval@results)
saveRDS(maxent_eval, './work/maxent_model_selection/maxent_eval.RDS')

# Export best results (after investagiating the figure below)
maxent_eval_select <- maxent_eval@models$fc.LQP_rm.0.4
saveRDS(maxent_eval@models$fc.LQP_rm.0.4, './work/maxent_model_selection/maxent_eval_select.RDS')




#### Plot results ----

# plot model evalutaion
library(RColorBrewer)

evaldata <- maxent_eval@results %>% pivot_longer(-c(fc:tune.args), names_to='criterion', values_to='val') %>%
  filter(criterion %in% c('delta.AICc','or.10p.avg','auc.val.avg')) %>% 
  mutate(fc=factor(fc, levels=c('L','LQ','LQH', 'LQP', 'LQHP', 'LQHPT')),
         rm=as.numeric(as.character(rm)),
         criterion=factor(criterion, levels=c('delta.AICc','or.10p.avg','auc.val.avg'), labels=c('Delta AICc','OR .10','AUC test')))

evalplot <- ggplot(data=evaldata, aes(x=rm, y=val, group=fc, color=fc))+
  geom_vline(xintercept=1, linetype='dashed')+
  geom_point()+
  geom_line()+
  facet_wrap(~criterion,
             scales='free_y',
             strip.position ='top')+
  labs(x='Regularization multiplier', y='', color='Feature class')+
  scale_x_continuous(limits=c(0,4))+
  scale_color_brewer(palette = "Dark2")+
  theme_bw()+
  theme(
    strip.text = element_text(size = rel(1)),
    strip.background = element_rect(fill = NA, colour = 'black', size = 0.4)
  )

plot(evalplot)

tiff("./results/fig_model_evaluation.tiff", units="cm", width=19, height=6, res=600)
evalplot
dev.off()