library(mosaic)
library(tidyverse)
library(data.table)
library(LICORS)
library(cluster)
library(factoextra)
library(RColorBrewer)

# get the data & clean/process
sm_data <- read.csv("./DataScienceCourseHomework/exercises-3/data/social_marketing.csv", header=TRUE) %>%
  select(-c(X)) %>%
  mutate(
    num_tweets = rowSums(.[,])
    ) 
ntv <- sm_data$num_tweets
sm_data <- sm_data / ntv 
sm_data$num_tweets <- ntv 

sm_data <- sm_data %>% scale(center=TRUE, scale=TRUE)

# save scales, might use them later
mu <- attr(sm_data,"scaled:center")
sigma <- attr(sm_data,"scaled:scale")

#set seed for reproducibility
set.rseed(63)

# take a random sample for calculating gap
N = nrow(sm_data)
samp_frac = 0.2
N_samp = floor(samp_frac*N)
samp_ind = sample.int(N, N_samp, replace=FALSE) %>% sort
sm_samp = sm_data[samp_ind,]

# K means gap statistic calculation
sm_km_gap <- clusGap(sm_samp, FUN = kmeans, nstart = 25, K.max = 25, B = 50)
plot(sm_km_gap)

# Calculate K-means++
kmpp <- kmeanspp(sm_data, k=13, nstart=50)

# Data cleaning/manipulation 
cname <- rownames(t(kmpp$center))
kmpp_pre_t <- kmpp$center
kmpp_res_t <- as.data.table(cbind(cname = cname, t(kmpp_pre_t))) %>%
  mutate(
    cname = as.factor(cname)
  )
kmpp_res_t$cname <- kmpp_res_t$cname %>% fct_reorder(min_rank(kmpp_res_t$cname),.desc = TRUE)
plot_data <- melt(kmpp_res_t, id.vars = 'cname')

# Choose a significance level (in std. devs.) for distinguising key characteristics of each cluster
sig_level <- 1

# Std. Dev plot by category/cluster
km_dev_plot <- ggplot() +
  geom_point(data=plot_data, aes(x=cname, y=as.double(value), color = variable), size = 4, alpha = .8) +
  labs(title = 'K-Means++ Diverging Dot Plot', subtitle = 'Normalized distribution by variable') +
  ylab('Standard Deviations from Mean') + 
  xlab('') + 
  guides(color=guide_legend(title="Cluster")) + 
  theme_minimal() + 
  geom_hline(yintercept = sig_level, color = 'red', linetype = 'dashed') +
  geom_hline(yintercept = -sig_level, color = 'red', linetype = 'dashed') +
  scale_color_discrete() + 
  coord_flip()

km_dev_plot

# Visualize the cluster sizes 
blank_theme <- theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

size_tab <- as.data.table(kmpp$size) 
colnames(size_tab) <- c('size')
size_tab$cluster <- factor(row.names(size_tab), levels = c('1','2','3','4','5','6','7','8','9','10','11','12','13'), ordered = TRUE) 
size_tab$cluster_ro <- size_tab$cluster %>% fct_reorder(size_tab$size)

kmm_bar <-
  ggplot() + 
  geom_col(data = size_tab, aes(x = cluster_ro, y = size, fill = cluster)) + 
  geom_text(data = size_tab, aes(x = cluster_ro, y = size, label = size), check_overlap = FALSE, hjust = -0.05) + 
  scale_fill_discrete() + 
  ggtitle('K-Means++ Cluster Sizes') +
  blank_theme + 
  ylab('Users in Cluster')+
  coord_flip()

kmm_bar

# What are the important categories for each cluster (for what categories do they have dev >1 or <-1 from norm)
import_cat <- t(kmpp$center*((abs(kmpp$center)>sig_level)*1))
import_cat[import_cat == 0] <- NA
import_cat
# Maybe find another way to visualize this later 

# Hclust gap statistic calculation, note similar cutoff to k-means
sm_hclust_gap <- clusGap(sm_samp, FUN = hcut, K.max = 25, B = 50)
plot(sm_hclust_gap)

# Fit Hclust model using k = 13, using ward.D since other methods didn't work
sm_dist <- dist(sm_data)
hc_sm <- hclust(sm_dist, method='ward.D')
hc_sm_cut <- cutree(hc_sm, k = 13)

# Data prep
hc_sm_full <- data.frame(sm_data, hc = as.factor(hc_sm_cut))
hc_sm_grouped <- hc_sm_full %>% 
  group_by(hc) %>%
  summarise_all(mean) %>%
  select(-starts_with('hc')) %>%
  t() %>% 
  as.data.frame()
colnames(hc_sm_grouped) <- seq(1:13)
hc_sm_grouped$cname <- row.names(hc_sm_grouped)
hc_sm_grouped$cname <- hc_sm_grouped$cname %>% fct_reorder(min_rank(hc_sm_grouped$cname),.desc = TRUE)
hc_plot_data <- melt(hc_sm_grouped, id.vars = 'cname')

# HC Std. Dev plot by category/cluster
hc_dev_plot <- ggplot() +
  geom_point(data=hc_plot_data, aes(x=cname, y=as.double(value), color = variable), size = 4, alpha = .8) +
  labs(title = 'Hierarchical Diverging Dot Plot', subtitle = 'Normalized distribution by variable') +
  ylab('Standard Deviations from Mean') + 
  xlab('') + 
  guides(color=guide_legend(title="Cluster")) + 
  geom_hline(yintercept = sig_level, color = 'red', linetype = 'dashed') +
  geom_hline(yintercept = -sig_level, color = 'red', linetype = 'dashed') +
  theme_minimal() + 
  scale_color_discrete() + 
  coord_flip()

hc_dev_plot

# Visualize the cluster sizes 

hc_size_tab <- as.data.table(summary(factor(hc_sm_cut))) 
colnames(hc_size_tab) <- c('size')
hc_size_tab$cluster <- factor(row.names(size_tab), levels = c('1','2','3','4','5','6','7','8','9','10','11','12','13'), ordered = TRUE) 
hc_size_tab$cluster_ro <- hc_size_tab$cluster %>% fct_reorder(hc_size_tab$size)

hc_kmm_bar <-
  ggplot() + 
  geom_col(data = hc_size_tab, aes(x = cluster_ro, y = size, fill = cluster)) + 
  geom_text(data = hc_size_tab, aes(x = cluster_ro, y = size, label = size), check_overlap = FALSE, hjust = -0.05) + 
  scale_fill_discrete() + 
  ggtitle('Hierarchical Cluster Sizes') +
  blank_theme + 
  ylab('Users in Cluster')+
  coord_flip()

hc_kmm_bar

# More data wrangling
hc_import_cat <- hc_sm_grouped %>% select(-starts_with('cname'))
hc_import_cat <- hc_import_cat*((abs(hc_import_cat)>sig_level)*1)
hc_import_cat[hc_import_cat == 0] <- NA

# What are the important categories for each cluster (for what categories do they have dev >1 or <-1 from norm)
hc_import_cat

