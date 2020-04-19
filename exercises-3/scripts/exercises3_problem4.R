library(mosaic)
library(tidyverse)
library(data.table)
library(LICORS)
library(cluster)
library(factoextra)

# get the data
sm_data <- read.csv("./DataScienceCourseHomework/exercises-3/data/social_marketing.csv", header=TRUE) %>%
  select(-c(X)) %>%
  mutate(
    num_tweets = rowSums(.[,])
    ) %>%
  scale(center=TRUE, scale=TRUE)

# save scales
mu <- attr(sm_data,"scaled:center")
sigma <- attr(sm_data,"scaled:scale")

set.rseed(63)

# take a random sample for calculating gap
N = nrow(sm_data)
samp_frac = 0.2
N_samp = floor(samp_frac*N)
samp_ind = sample.int(N, N_samp, replace=FALSE) %>% sort
sm_samp = sm_data[samp_ind,]

sm_km_gap <- clusGap(sm_samp, FUN = kmeans, nstart = 50, K.max = 20, B = 100)
plot(sm_km_gap)

# Using kmeans++ initialization
kmpp <- kmeanspp(sm_data, k=15, nstart=50)

# Data Wrangling 
cname <- rownames(t(kmpp$center))
kmpp_pre_t <- kmpp$center
row.names(kmpp_pre_t) <- paste0('g',row.names(kmpp_pre_t))
kmpp_res_t <- as.data.table(cbind(cname = cname, t(kmpp_pre_t))) %>%
  mutate(
    cname = as.factor(cname)
  )

plot_data <- melt(kmpp_res_t, id.vars = 'cname')

km_dev_plot <- ggplot() +
  geom_point(data=plot_data, aes(x=cname, y=as.double(value), color = variable), size = 4, alpha = .8) +
  coord_flip()

km_dev_plot

sm_km_gap <- clusGap(sm_dist, FUN = kmeans, nstart = 50, K.max = 10, B = 50)
plot(sm_km_gap)

sm_dist <- dist(sm_data)
hc_sm <- hclust(sm_dist, method='average')
hc_sm_cut <- cutree(hc_sm, k = 6)



