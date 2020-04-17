library(tidyverse)
library(ggthemes)
library(LICORS)
library(mosaic)

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

# scatter plot of first two PCs
ggplot(data = pc_wine_graph_data) +
  geom_point(aes(x = PC1, y = PC2), alpha = 1/5) +
  theme_clean() +
  theme(plot.background=element_blank())

# scatter plot of first two PCs
ggplot(data = pc_wine_graph_data) +
  geom_point(aes(x = PC1, y = PC2), alpha = 1/5) +
  geom_abline(slope = 4 , intercept = 4)
  theme_clean() +
  theme(plot.background=element_blank())

# scatter plot of first two PCs, points colored by wine color
ggplot(data = pc_wine_graph_data) +
  geom_point(aes(x = PC1, y = PC2, color = color), alpha = 1/4) +
  theme_clean() +
  theme(plot.background=element_blank()) +
  scale_color_manual(values = c("#722f37", "#eccd13"))

# box plot of first PC, grouped by wine color
ggplot(data = pc_wine_graph_data) +
  geom_boxplot(aes(x = color, y = PC1)) +
  theme_clean() +
  theme(plot.background=element_blank())


# scatter plot of first two PCs, points colored by wine score
ggplot(data = pc_wine_graph_data) +
  geom_point(aes(x = PC2, y = PC3, color = as.factor(score))) +
  theme_clean() +
  theme(plot.background=element_blank())

# box plot of first PC, grouped by wine score
ggplot(data = pc_wine_graph_data) +
  geom_boxplot(aes(x = as.factor(score), y = PC1)) +
  theme_clean() +
  theme(plot.background=element_blank())

# box plot of second PC, grouped by wine score
ggplot(data = pc_wine_graph_data) +
  geom_boxplot(aes(x = as.factor(score), y = PC2)) +
  theme_clean() +
  theme(plot.background=element_blank())

# box plot of third PC, grouped by wine score
ggplot(data = pc_wine_graph_data) +
  geom_boxplot(aes(x = as.factor(score), y = PC3)) +
  theme_clean() +
  theme(plot.background=element_blank())

# summary table of data, grouped by wine score
pc_wine_graph_data %>%
  group_by(score) %>%
  summarize(mean.PC1 = mean(PC1), mean.PC2 = mean(PC2), mean.PC3 = mean(PC3))





###########
# K-means #
###########

wine_cluster_color = kmeanspp(wine_x_st, k=2, nstart=50)

cluster_wine_data = data.frame(wine_data)
cluster_wine_data$two_clusters = wine_cluster_color$cluster

table(color = cluster_wine_data$color, cluster = cluster_wine_data$two_clusters)


wine_cluster_score_3 = kmeanspp(wine_x_st, k=3, nstart=100)
wine_cluster_score_4 = kmeanspp(wine_x_st, k=4, nstart=100)
wine_cluster_score_5 = kmeanspp(wine_x_st, k=5, nstart=100)
wine_cluster_score_6 = kmeanspp(wine_x_st, k=6, nstart=100)
wine_cluster_score_7 = kmeanspp(wine_x_st, k=7, nstart=100)

cluster_wine_data$three_clusters = wine_cluster_score_3$cluster
cluster_wine_data$four_clusters = wine_cluster_score_4$cluster
cluster_wine_data$five_clusters = wine_cluster_score_5$cluster
cluster_wine_data$six_clusters = wine_cluster_score_6$cluster
cluster_wine_data$seven_clusters = wine_cluster_score_7$cluster


vln_3 = ggplot(data = cluster_wine_data) +
  geom_violin(aes(x = as.factor(seven_clusters), y = quality))
vln_4 = ggplot(data = cluster_wine_data) +
  geom_violin(aes(x = as.factor(seven_clusters), y = quality))
vln_5 = ggplot(data = cluster_wine_data) +
  geom_violin(aes(x = as.factor(seven_clusters), y = quality))
vln_6 = ggplot(data = cluster_wine_data) +
  geom_violin(aes(x = as.factor(seven_clusters), y = quality))
vln_7 = ggplot(data = cluster_wine_data) +
  geom_violin(aes(x = as.factor(seven_clusters), y = quality))

facet_wrap(c(vln_3, vln_4, vln_5, vln_6, vln_7), nrow = 5)
facet