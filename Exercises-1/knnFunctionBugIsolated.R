library(tidyverse)
library(FNN)

sclass = read.csv('sclass.csv')

# Focus on trim level 350
sclass = subset(sclass, trim == '350')

# Make a train-test split
N = nrow(sclass)
N_train = floor(0.8*N)
N_test = N - N_train

# Randomly sample a set of data points to include in the training set
train_indices = sample.int(N, N_train, replace=FALSE)

# Define the training data and testing data sets
D_train = sclass[train_indices,]
D_test = sclass[-train_indices,]

# Reorder the rows of the testing set by the "mileage" variable
D_test = arrange(D_test, mileage)

# Separate training and testing sets into features (X) and outcome (y)
X_train = select(D_train, mileage)
y_train = select(D_train, price)
x_test = select(D_test, mileage)
y_test = select(D_test, price)

# Fit KNN for each k = 2
# NOTE: KNN bugs out for k-value 2
knn2 = knn.reg(train = X_train, test = x_test, y = y_train, k=2)

