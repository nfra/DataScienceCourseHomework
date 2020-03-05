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

# Make data numeric and TODO: scale by standard deviation for KNN

SaratogaHouses$heating_is_electric = eval(SaratogaHouses$heating == "electric")
SaratogaHouses$heating_is_hotwatersteam = eval(SaratogaHouses$heating == "hot water/steam")
SaratogaHouses$heating_is_hotair = eval(SaratogaHouses$heating == "hot air")

SaratogaHouses$fuel_is_gas = eval(SaratogaHouses$fuel == "gas")
SaratogaHouses$fuel_is_electric = eval(SaratogaHouses$fuel == "electric")
SaratogaHouses$fuel_is_oil = eval(SaratogaHouses$fuel == "oil")

SaratogaHouses$centralAir_is_yes = eval(SaratogaHouses$centralAir == "yes")
SaratogaHouses$centralAir_is_no = eval(SaratogaHouses$centralAir == "no")

saratoga_train = SaratogaHouses[train_cases,]
saratoga_test = SaratogaHouses[test_cases,]



# Calculate RMSE for KNN

# (note the -1, which says to leave off a column of 1's for an intercept)
X_all = model.matrix(~lotSize + age + livingArea + pctCollege + 
                       bedrooms + fireplaces + bathrooms + rooms + heating + fuel +
                       centralAir + newConstruction - 1,
                     data=SaratogaHouses)


feature_sd = apply(saratoga_X, 2, sd)
X_std = scale(X_all, scale=feature_sd)

saratoga_train_x = saratoga_train[,c("lotSize", "age", "livingArea", "pctCollege", 
                                     "bedrooms", "fireplaces", "bathrooms", "rooms", 
                                     "heating_is_electric", "heating_is_hotwatersteam", 
                                     "fuel_is_gas", "fuel_is_electric", "centralAir_is_yes")]
saratoga_train_y = saratoga_train$price
saratoga_test_x = saratoga_test[,c("lotSize", "age", "livingArea", "pctCollege", 
                                   "bedrooms", "fireplaces", "bathrooms", "rooms", 
                                   "heating_is_electric", "heating_is_hotwatersteam", 
                                   "fuel_is_gas", "fuel_is_electric", "centralAir_is_yes")]
saratoga_test_y = saratoga_test$price

knn_better = knn.reg(train=saratoga_train_x, test=saratoga_test_x, 
                     y=saratoga_train_y, k=5)

yhat_knn_better = knn_better$pred
rmse(saratoga_test_y, yhat_knn_better)

####CLAIRES STUFF####

rmse_vals_better = do(100)* {
  
  # splitting
  n = nrow(SaratogaHouses)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  saratoga_train = SaratogaHouses[train_cases,]
  saratoga_test = SaratogaHouses[test_cases,]
  
  # regressions
  #regression from class
  lm_medium2 = lm(price ~ . - sewer - waterfront - landValue - newConstruction, data=saratoga_train)
  #attempted regressions to decrease RMSE
  lm_better=lm(price ~ . -sewer - waterfront -landValue , data=saratoga_train)
  #interaction of bedrooms,bathrooms, rooms and interaction of living area and new construction
  lm_better_int=lm(price~ sewer+ bedrooms*bathrooms*rooms +heating +fuel +pctCollege +lotSize + livingArea*newConstruction, data=saratoga_train)
  #drop fuel variable
  lm_best=lm(price~ sewer+ bedrooms*bathrooms*rooms +heating +pctCollege +lotSize + livingArea*newConstruction, data=saratoga_train)
  #stepwise selection model
  lm_step=lm(price~ livingArea + landValue + bathrooms + waterfront + newConstruction +  heating + lotSize + age + centralAir + rooms + bedrooms + 
               landValue:newConstruction + bathrooms:heating + livingArea:bathrooms + 
               lotSize:age + livingArea:waterfront + landValue:lotSize + 
               livingArea:centralAir + age:centralAir + livingArea:landValue + 
               bathrooms:bedrooms + bathrooms:waterfront + heating:bedrooms + 
               heating:rooms + waterfront:centralAir + waterfront:lotSize + 
               landValue:age + age:rooms + livingArea:lotSize + lotSize:rooms + 
               lotSize:centralAir, data=saratoga_train)
  
  
  # predictions
  yhat_medium = predict(lm_medium2, saratoga_test)
  yhat_better= predict(lm_better, saratoga_test)
  yhat_better_int=predict(lm_better_int, saratoga_test)
  yhat_best=predict(lm_best, saratoga_test)
  yhat_step=predict(lm_step, saratoga_test)
  
  c(rmse(saratoga_test$price, yhat_medium),
    rmse(saratoga_test$price, yhat_better),
    rmse(saratoga_test$price, yhat_better_int), 
    rmse(saratoga_test$price, yhat_best), 
    rmse(saratoga_test$price, yhat_step)
  )
}


colMeans(rmse_vals_better)
which.min(colMeans(rmse_vals_better))
#lm_best is the best performer here, and outperforms test 4 from previous attempts



#KNN using the stepwise selected vars
rmse_vals_knn = do(10)* {
  
  # splitting
  n = nrow(SaratogaHouses)
  n_train = round(0.8*n)  # round
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  saratoga_train = SaratogaHouses[train_cases,]
  saratoga_test = SaratogaHouses[test_cases,]
  
  xtrain = model.matrix(~ livingArea + landValue + bathrooms + waterfront + newConstruction +  heating + lotSize + age + centralAir + rooms + bedrooms -1, data=saratoga_train)
  xtest = model.matrix(~ livingArea + landValue + bathrooms + waterfront + newConstruction +  heating + lotSize + age + centralAir + rooms + bedrooms -1, data=saratoga_test)
  
  # training and testing set responses
  ytrain = saratoga_train$price
  ytest = saratoga_test$price
  
  # rescale
  scale_train = apply(xtrain, 2, sd) # calculate std dev for each column
  xtrain_scaled = scale(xtrain, scale = scale_train)
  xtest_scaled = scale(xtest, scale=scale_train)
  # regressions for different values of K
  k_grid = seq(2, 51)
  rmse_grid = foreach(K = k_grid, .combine='c') %do% {
    knn_model_K = knn.reg(xtrain_scaled, xtest_scaled, ytrain, k=K)
    rmse(ytest, knn_model_K$pred)} 
}

colMeans(rmse_vals_knn)

which.min(colMeans(rmse_vals_knn))
min(colMeans(rmse_vals_knn))
###knn using claire's model which sucks
rmse_vals_knn1 = do(10)* {
  
  # splitting
  n = nrow(SaratogaHouses)
  n_train = round(0.8*n)  # round
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  saratoga_train = SaratogaHouses[train_cases,]
  saratoga_test = SaratogaHouses[test_cases,]
  
  xtrain = model.matrix(~ sewer+ bedrooms + bathrooms + rooms + heating + pctCollege + lotSize + livingArea + newConstruction -1, data=saratoga_train)
  xtest = model.matrix(~ sewer+ bedrooms + bathrooms + rooms +heating + pctCollege + lotSize + livingArea+newConstruction -1, data=saratoga_test)
  
  # training and testing set responses
  ytrain = saratoga_train$price
  ytest = saratoga_test$price
  
  # rescale
  scale_train = apply(xtrain, 2, sd) # calculate std dev for each column
  xtrain_scaled = scale(xtrain, scale = scale_train)
  xtest_scaled = scale(xtest, scale=scale_train)
  # regressions for different values of K
  k_grid = seq(2, 51)
  rmse_grid = foreach(K = k_grid, .combine='c') %do% {
    knn_model_K = knn.reg(xtrain_scaled, xtest_scaled, ytrain, k=K)
    rmse(ytest, knn_model_K$pred)} 
}


colMeans(rmse_vals_knn)
which.min(colMeans(rmse_vals_knn))
min(colMeans(rmse_vals_knn))                    



KNN_RMSE_Means<-colMeans(rmse_vals_knn)
plot(k_grid, KNN_RMSE_Means)
#please replace this w ggplot

