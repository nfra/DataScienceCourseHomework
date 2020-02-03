library(tidyverse)
library(FNN)
library(mosaic)

#############
# Exercise 1#
#############

abia = read.csv('C:/Users/Nathan/Documents/UT Courses/3. Spring 2019/Data Mining, Statistical Learning/Homework/Exercises 1/ABIA.csv')

abia_well_behaved = subset(abia, DepDelay != "NA")

abia_sum = abia_well_behaved %>%
  group_by(Month) %>%
  summarize(mean.DepDelay = mean(DepDelay), sd.DepDelay = sd(DepDelay))

ggplot(data = abia_sum) + 
  geom_point(mapping = aes(x = Month, y = mean.DepDelay)) +
  geom_errorbar(aes(x = Month, ymin= mean.DepDelay - 2*sd.DepDelay, ymax= mean.DepDelay + 2*sd.DepDelay), width=.1)

abia_sum2 = abia_well_behaved %>%
  group_by(DayOfWeek) %>%
  summarize(mean.DepDelay = mean(DepDelay), sd.DepDelay = sd(DepDelay))

ggplot(data = abia_sum2) + 
  geom_point(mapping = aes(x = DayOfWeek, y = mean.DepDelay))+
  geom_errorbar(aes(x = DayOfWeek, ymin= mean.DepDelay - 2*sd.DepDelay, ymax= mean.DepDelay + 2*sd.DepDelay), width=.1)

abia_well_behaved$CRSDepTime_NearestHour = round(abia_well_behaved$CRSDepTime, digits=-2)
abia_sum3 = abia_well_behaved %>%
  group_by(CRSDepTime_NearestHour) %>%
  summarize(mean.DepDelay = mean(DepDelay), sd.DepDelay = sd(DepDelay))

ggplot(data = abia_sum3) + 
  geom_bar(mapping = aes(x = CRSDepTime_NearestHour, y = mean.DepDelay), stat = "identity") +
  xlim(500, 2400) 

abia_sum4 = abia_well_behaved %>%
  group_by(CRSDepTime) %>%
  summarize(mean.DepDelay = mean(DepDelay), sd.DepDelay = sd(DepDelay))

lm_SchedDep = lm(DepDelay ~ CRSDepTime, data=abia_well_behaved)
abia_sum4$ypred_lm = predict(lm_SchedDep, abia_sum4)

ggplot(data = abia_sum4) + 
  geom_point(mapping = aes(x = CRSDepTime, y = mean.DepDelay)) +
  geom_path(mapping = aes(x=CRSDepTime, y=ypred_lm), color='red', size=1.2)


#############
# Exercise 2#
#############

sclass = read.csv('C:/Users/Nathan/Documents/UT Courses/3. Spring 2019/Data Mining, Statistical Learning/Homework/Exercises 1/sclass.csv')

# Focus on 2 trim levels: 350 and 65 AMG

# Trim: 350
sclass350 = subset(sclass, trim == '350')

# Make a train-test split
N_350 = nrow(sclass350)
N_train_350 = floor(0.8*N_350)
N_test_350 = N_350 - N_train_350

# Randomly sample a set of data points to include in the training set
train_indices_350 = sample.int(N_350, N_train_350, replace=FALSE)

# Define the training data and testing data sets
D_train_350 = sclass350[train_indices_350,]
D_test_350 = sclass350[-train_indices_350,]

# Reorder the rows of the testing set by the "mileage" variable
D_test_350 = arrange(D_test_350, mileage)

# Separate training and testing sets into features (X) and outcome (y)
X_train_350 = select(D_train_350, mileage)
y_train_350 = select(D_train_350, price)
x_test_350 = select(D_test_350, mileage)
y_test_350 = select(D_test_350, price)

# Define a helper function for calculating RMSE
rmse = function(y, ypred) {
  sqrt(mean(data.matrix((y-ypred)^2)))
}

# Fit KNN for each k-value from 3 to size of training data and record out-of-sample RMSE
# NOTE: KNN bugs out for k-value 2
knn_rmse_350 = data.frame()

for(i in 3:N_train_350) {
  knn_350 = knn.reg(train = X_train_350, test = x_test_350, y = y_train_350, k=i)
  ypred_knn_350 = knn_350$pred
  knn_rmse =  rmse(y_test_350, ypred_knn_350)
  knn_rmse_350 = rbind(knn_rmse_350,list("k"=i,"rmse" = knn_rmse))
}

# Plot RMSE vs k-value (with log x-axis) with optimal k-value marked
knn_rmse_plot = ggplot(data = knn_rmse_350) +
  geom_path(aes(x = k, y = rmse), color='black')+
  geom_vline(xintercept = knn_rmse_350$k[which.min(knn_rmse_350$rmse)], color = 'red')+
  scale_x_continuous(trans='log10')
knn_rmse_plot

# Plot optimal k-value KNN with test data
optimal_ind_350 = knn_rmse_350$k[which.min(knn_rmse_350$rmse)]
knn_optimal_350 = knn.reg(train = X_train_350, test = x_test_350, y = y_train_350, k=optimal_ind_350)

p_test = ggplot(data = D_test_350) + 
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  theme_bw(base_size=18) + 
  geom_path(aes(x = mileage, y = knn_optimal_350$pred), color='red')
p_test


# Trim: 65 AMG
sclass65AMG = subset(sclass, trim == '65 AMG')

# Make a train-test split
N_65AMG = nrow(sclass65AMG)
N_train_65AMG = floor(0.8*N_65AMG)
N_test_65AMG = N_65AMG - N_train_65AMG

# Randomly sample a set of data points to include in the training set
train_indices_65AMG = sample.int(N_65AMG, N_train_65AMG, replace=FALSE)

# Define the training data and testing data sets
D_train_65AMG = sclass65AMG[train_indices_65AMG,]
D_test_65AMG = sclass65AMG[-train_indices_65AMG,]

# Reorder the rows of the testing set by the "mileage" variable
D_test_65AMG = arrange(D_test_65AMG, mileage)

# Separate training and testing sets into features (X) and outcome (y)
X_train_65AMG = select(D_train_65AMG, mileage)
y_train_65AMG = select(D_train_65AMG, price)
x_test_65AMG = select(D_test_65AMG, mileage)
y_test_65AMG = select(D_test_65AMG, price)


# Fit KNN for each k-value from 3 to size of training data and record out-of-sample RMSE
# NOTE: KNN bugs out for k-value 2
knn_rmse_65AMG = data.frame()

for(i in 3:N_train_65AMG) {
  knn_65AMG = knn.reg(train = X_train_65AMG, test = x_test_65AMG, y = y_train_65AMG, k=i)
  ypred_knn_65AMG = knn_65AMG$pred
  knn_rmse =  rmse(y_test_65AMG, ypred_knn_65AMG)
  knn_rmse_65AMG = rbind(knn_rmse_65AMG,list("k"=i,"rmse" = knn_rmse))
}

# Plot RMSE vs k-value with log x-axis
knn_rmse_plot = ggplot(data = knn_rmse_65AMG) +
  geom_path(aes(x = k, y = rmse), color='black') + 
  geom_vline(xintercept = knn_rmse_65AMG$k[which.min(knn_rmse_65AMG$rmse)], color = 'red') +
  scale_x_continuous(trans='log10')
knn_rmse_plot

# Plot optimal k-value KNN with test data
optimal_ind_65AMG = knn_rmse_65AMG$k[which.min(knn_rmse_65AMG$rmse)]
knn_optimal_65AMG = knn.reg(train = X_train_65AMG, test = x_test_65AMG, y = y_train_65AMG, k=optimal_ind_65AMG)

p_test = ggplot(data = D_test_65AMG) + 
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  theme_bw(base_size=18) + 
  geom_path(aes(x = mileage, y = knn_optimal_65AMG$pred), color='red')
p_test
