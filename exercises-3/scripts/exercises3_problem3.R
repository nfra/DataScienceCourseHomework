library(tidyverse)
library(ggthemes)
library(LICORS)

# read data
wine_data = read.csv("./data/wine.csv")

# separate data into inputs and outcomes
wine_x = wine_data[,1:11]
wine_score = wine_data[,12]
wine_color = wine_data[,13]

# standardize data
wine_x_st = scale(wine_x)

#######
# PCA #
#######

# calculate principal components
pc_wine = prcomp(wine_x_st, scale=TRUE)
summary(pc_wine)
plot(pc_wine)

# add outcomes back in for graphing
pc_wine_graph_data = as.data.frame(pc_wine$x)
pc_wine_graph_data$score = wine_score
pc_wine_graph_data$color = wine_color

# graph with points colored by wine color
ggplot(data = pc_wine_graph_data) +
  geom_point(aes(x = PC1, y = PC2, color = color), alpha = 1/4) +
  theme_clean() +
  theme(plot.background=element_blank()) +
  scale_color_manual(values = c("#722f37", "#eccd13")) 
  

# graph with points colored by wine score
ggplot(data = pc_wine_graph_data) +
  geom_point(aes(x = PC1, y = PC2, color = as.factor(score)), alpha = 1/4) +
  theme_clean() +
  theme(plot.background=element_blank())



###########
# K-means #
###########

wine_cluster_color = kmeanspp(wine_x_st, k=2, nstart=50)

cluster_wine_data = wine_data
cluster_wine_data$two_clusters = wine_cluster_color$cluster

table(color = cluster_wine_data$color, cluster = cluster_wine_data$two_clusters)



wine_cluster_score = kmeanspp(wine_x_st, k=7, nstart=100)

cluster_wine_data$seven_clusters = wine_cluster_score$cluster

table(score = cluster_wine_data$quality, cluster = cluster_wine_data$seven_clusters)
