library(tidyverse)
library(mosaic)
library(FNN)

data(SaratogaHouses)

rmse = function(y, yhat) {
  sqrt( mean( (y - yhat)^2 ) )
}


# Split into training and testing sets

n = nrow(SaratogaHouses)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train
train_cases = sample.int(n, n_train, replace=FALSE)
test_cases = setdiff(1:n, train_cases)
saratoga_train = SaratogaHouses[train_cases,]
saratoga_test = SaratogaHouses[test_cases,]

# Calculate baseline RMSE to beat

lm_baseline = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
                   fireplaces + bathrooms + rooms + heating + fuel + centralAir, 
                 data=saratoga_train)

yhat_test_baseline = predict(lm_baseline, saratoga_test)

baseline_rmse = rmse(saratoga_test$price, yhat_test_baseline)



# Calculate RMSE for better linear model

lm_better = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
                 fireplaces + bathrooms + rooms + heating + fuel + centralAir +
                 heating*(fireplaces + fuel) + 
                 bedrooms*(rooms + bathrooms) +
                 livingArea*(rooms + lotSize) +
                 lotSize*(pctCollege + rooms) +
                 age*(lotSize + livingArea + bedrooms + bathrooms + heating + centralAir), 
               data=saratoga_train)

yhat_test_better = predict(lm_better, saratoga_test)

better_rmse = rmse(saratoga_test$price, yhat_test_better)

# Make data numeric and scale by standard deviation for KNN



# Calculate RMSE for KNN

saratoga_train_x = saratoga_train[,c("lotSize", "age", "livingArea", "pctCollege", 
                                     "bedrooms", "fireplaces", "bathrooms", 
                                     "rooms", "heating", "fuel", "centralAir")]
saratoga_train_y = saratoga_train$price
saratoga_test_x = saratoga_test[,c("lotSize", "age", "livingArea", "pctCollege", 
                                   "bedrooms", "fireplaces", "bathrooms", 
                                   "rooms", "heating", "fuel", "centralAir")]
saratoga_test_y = saratoga_test$price

knn_better = knn.reg(train=saratoga_train_x, test=saratoga_test_x, 
                     y=saratoga_train_y, k=5)

