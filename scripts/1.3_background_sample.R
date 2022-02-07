library(tidyverse)
library(cowplot)
set.seed(31)

dataset <- readRDS('./work/sample/full_record.RDS')



# Test the effect of sample size
d1 <- dataset %>% dplyr::select(c(bio1,bio2,bio7,bio12,bio15,elev))
N_mean <- d1 %>% colMeans()
sample_error <- setNames(rep(NA, times=7), c('bio1','bio2','bio7','bio12','bio15','elev','n'))

for(samplesize in c(10,100,1000,10000,100000,1000000)){
  for(i in seq(1,1000)){
    n_mean <- d1 %>% sample_n(samplesize) %>% colMeans()
    nN_Diff <- abs(N_mean - n_mean)
    nN_Diff['n'] <- samplesize
    sample_error <- bind_rows(sample_error, nN_Diff)
  }
}
sample_error <- sample_error %>% drop_na() %>%  mutate(n=as.character(n))
saveRDS(sample_error, './work/sample/background_sample_validation/background_sample_size_error.rds')


plt_sample_error <- ggplot(sample_error %>% drop_na() %>% pivot_longer(-n), aes(x=n, y=value))+
  facet_grid(name~., scale='free')+
  geom_boxplot()+
  labs(
    title='Effect of background sample size',
    x='Sample size (n)',
    y='Absolute sample error')+
  scale_x_discrete(labels = c('10','100','1,000','10,000','100,000','1,000,000'))+
  theme_bw()
plot(plt_sample_error)

tiff("./work/sample/background_sample_validation/background_sample_size_error.tiff", units="cm", width=9, height=18, res=600)
plt_sample_error
dev.off()


# Test random vs. stratified background sampling
d2 <- dataset %>% dplyr::select(c(interval,bio1,bio2,bio7,bio12,bio15,elev))

## This is a random sample over all timeslices
sample_2.random <- d2 %>% sample_n(10000)

## This sammple is stratified by the number of arch. sites per timeslice 
sample_2.stratified <- bind_rows('MIS11ab'= d2 %>% filter(interval=="MIS11ab") %>% sample_n(12/30*10000),
                                 'MIS11c'= d2 %>% filter(interval=="MIS11c") %>% sample_n(10/30*10000),
                                 'MIS11de'= d2 %>% filter(interval=="MIS11de") %>% sample_n(1/30*10000),
                                 'MIS12a'= d2 %>% filter(interval=="MIS12a") %>% sample_n(3/30*10000),
                                 'MIS12b'= d2 %>% filter(interval=="MIS12b") %>% sample_n(2/30*10000),
                                 'MIS12c'= d2 %>% filter(interval=="MIS12c") %>% sample_n(2/30*10000),
                                 'MIS13a'= d2 %>% filter(interval=="MIS13a") %>% sample_n(1/30*10000),
                                 #'MIS13b'= d2 %>% filter(interval=="MIS13b") %>% sample_n(0/30*10000),
                                 'MIS13c'= d2 %>% filter(interval=="MIS13c") %>% sample_n(1/30*10000),
                                 'MIS14ac'= d2 %>% filter(interval=="MIS14ac") %>% sample_n(1/30*10000)
                                 #'MIS14d'= d2 %>% filter(interval=="MIS14d") %>% sample_n(0/30*10000)
                                 )

sample_2 <- bind_rows('random'=sample_2.random, 'stratified'=sample_2.stratified, .id='strategy')
saveRDS(sample_2, './work/sample/background_sample_validation/background_sample_strategy.rds')
x <- sample_2 %>% pivot_longer(-c(strategy, interval))

plt_sample2 <- ggplot(sample_2 %>% pivot_longer(-c(strategy, interval)), aes(x=strategy, y=value))+
  facet_grid(name~., scale='free')+
  geom_violin()+
  labs(
  title='Effect of sampling strategy',
    x='Sampling type',
    y='Value')+
  theme_bw()
plot(plt_sample2)

tiff("./work/sample/background_sample_validation/background_sample_strategy.tiff", units="cm", width=9, height=18, res=600)
plt_sample2
dev.off()

tiff("./results/fig_background_sample_validation.tiff", units="cm", width=18.3, height=18, res=600)
plot_grid(plt_sample_error,plt_sample2, labels = c('a','b'), rel_widths = c(1,0.65), align='h')
dev.off()




# Draw the background sample
set.seed(31)
background_sample <- dataset %>% sample_n(10000)

saveRDS(background_sample, './work/sample/background_sample_points.rds')