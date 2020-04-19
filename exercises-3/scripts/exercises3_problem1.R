library(mosaic)
library(tidyverse)
library(data.table)
library(tree)
library(randomForest)
library(rpart)
library(gbm)
library(pdp)

# unfiltered
greenbuildingsuf = read.csv("./DataScienceCourseHomework/exercises-3/data/greenbuildings.csv", header=TRUE) 
  

# get the data
greenbuildings = read.csv("./DataScienceCourseHomework/exercises-3/data/greenbuildings.csv", header=TRUE) %>%
  na.omit() %>%
  mutate(
    cluster = as.factor(cluster),
    green_rating = as.factor(green_rating),
    class = as.factor(2*class_a + 1*class_b),
    renovated = as.factor(renovated),
    net = as.factor(net),
    amenities = as.factor(amenities)
  )

# Fill factor levels
levels(greenbuildings$green_rating) = c('Non-Green','Green')
levels(greenbuildings$class) = c('C','B','A')
levels(greenbuildings$renovated) = c('No','Yes')
levels(greenbuildings$net) = c('No','Yes')
levels(greenbuildings$amenities) = c('No','Yes')

exclude_vars <- c('CS_PropertyID','cluster','class_a','class_b','LEED','Energystar')

gb_clean <- greenbuildings[ , !(names(greenbuildings) %in% exclude_vars)]

# split into a training and testing set
set.rseed(63)
N = nrow(gb_clean)
train_frac = 0.8
N_train = floor(train_frac*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE) %>% sort
gb_clean_train = gb_clean[train_ind,]
gb_clean_test = gb_clean[-train_ind,]

#### Basic Tree ####

#fit a big tree using rpart.control
gb_bigtree = rpart(Rent ~ ., data=gb_clean_train, method="anova",
                 control=rpart.control(minsplit=5,cp=.00005))
nbig = length(unique(gb_bigtree$where))
cat('size of big tree: ',nbig,'\n')

#look at cross-validation
plotcp(gb_bigtree)

#plot best tree
bestcp=gb_bigtree$cptable[which.min(gb_bigtree$cptable[,"xerror"]),"CP"]
cat('bestcp: ',bestcp,'\n')
gb_besttree = prune(gb_bigtree,cp=bestcp)
nbest = length(unique(gb_besttree$where))
cat('size of best tree: ',nbest,'\n')

yhat_gb_besttree = predict(gb_besttree, gb_clean_test)
rmse_tree = mean((gb_clean_test$Rent - yhat_gb_besttree)^2) %>% sqrt
rmse_tree

#### Bagging ####

gb_bag = randomForest(Rent ~ ., mtry=17, nTree=500, data=gb_clean_train)

yhat_gb_bag = predict(gb_bag, gb_clean_test)
rmse_bag = mean((gb_clean_test$Rent - yhat_gb_bag)^2) %>% sqrt
rmse_bag

#### Random Forest ####

gb_forest = randomForest(Rent ~ ., mtry=7, nTree=500, data=gb_clean_train)

yhat_gb_forest = predict(gb_forest, gb_clean_test)
rmse_forest = mean((gb_clean_test$Rent - yhat_gb_forest)^2) %>% sqrt
rmse_forest

#### Boosting ####

gb_boost = gbm(Rent ~ ., data=gb_clean_train, distribution = 'gaussian',
             interaction.depth=4, n.trees=5000, shrinkage=.1)

yhat_gb_boost = predict(gb_boost, gb_clean_test, n.trees=5000)
rmse_boost = mean((gb_clean_test$Rent - yhat_gb_boost)^2) %>% sqrt
rmse_boost

gbm.perf(gb_boost)


#### Performance Comparison ####
max_rent <- max(gb_clean_test$Rent)
min_rent <- min(gb_clean_test$Rent)
min_max <- c(min_rent,max_rent)

tree_plot <- ggplot() +
  geom_point(aes(x=gb_clean_test$Rent, y = yhat_gb_besttree), alpha = .3, size = 2, shape = 16) + 
  geom_line(aes(x=min_max, y=min_max), color = 'blue', size = 1) + 
  labs(title="Out Of Sample Predicted vs. Actual Rent - Simple Tree", 
     y="Prediction",
     x = "Rent",
     fill="") +
  annotate("label", x = 25, y = 160, label = paste0('RMSE: ',as.character(round(rmse_tree,4))), color = 'red', size = 5) +
  theme_minimal()

tree_plot

bag_plot <- ggplot() +
  geom_point(aes(x=gb_clean_test$Rent, y = yhat_gb_bag), alpha = .3, size = 2, shape = 16) + 
  geom_line(aes(x=min_max, y=min_max), color = 'blue', size = 1) + 
  labs(title="Out Of Sample Predicted vs. Actual Rent - Bagging", 
       y="Prediction",
       x = "Rent",
       fill="") +
  annotate("label", x = 25, y = 160, label = paste0('RMSE: ',as.character(round(rmse_bag,4))), color = 'red', size = 5) +
  theme_minimal()

bag_plot

forest_plot <- ggplot() +
  geom_point(aes(x=gb_clean_test$Rent, y = yhat_gb_forest), alpha = .3, size = 2, shape = 16) + 
  geom_line(aes(x=min_max, y=min_max), color = 'blue', size = 1) + 
  labs(title="Out Of Sample Predicted vs. Actual Rent - Random Forest", 
       y="Prediction",
       x = "Rent",
       fill="") +
  annotate("label", x = 25, y = 160, label = paste0('RMSE: ',as.character(round(rmse_forest,4))), color = 'red', size = 5) +
  theme_minimal()

forest_plot

boost_plot <- ggplot() +
  geom_point(aes(x=gb_clean_test$Rent, y = yhat_gb_boost), alpha = .3, size = 2, shape = 16) + 
  geom_line(aes(x=min_max, y=min_max), color = 'blue', size = 1) + 
  labs(title="Out Of Sample Predicted vs. Actual Rent - Boosting", 
       y="Prediction",
       x = "Rent",
       fill="") +
  annotate("label", x = 25, y = 160, label = paste0('RMSE: ',as.character(round(rmse_boost,4))), color = 'red', size = 5) +
  theme_minimal()

boost_plot

#### Partial Dependence ####

forest_p <- partial(gb_forest, pred.var = c('green_rating'), train = gb_clean)
forest_p$green_rating
forest_p$yhat


pd_plot <- ggplot() + 
  geom_bar(mapping = aes(x=forest_p$green_rating, y=forest_p$yhat, fill = forest_p$green_rating), stat='identity') +
  labs(title="Partial Dependence Plot - Random Forest", 
       y="Average Predicted Rent",
       x = "Green Rating",
       fill="") +
  theme_minimal() + 
  geom_text(aes(x=forest_p$green_rating, y=forest_p$yhat+1, label = round(forest_p$yhat,2)), size = 4) +
  scale_fill_manual(values=c("#FC6767", "#57D06B")) +
  guides(fill=FALSE)

pd_plot

varImpPlot(gb_forest, main = 'Variable Importance Plot - Random Forest')
