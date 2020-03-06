library(tidyverse)
library(mosaic)
library(FNN)
library(formula.tools)
data(SaratogaHouses)

# define rmse function
rmse = function(y, yhat) {
  sqrt( mean( (y - yhat)^2 ) )
}


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
  lm_better_int=lm(price ~ sewer+ bedrooms*bathrooms*rooms +heating +fuel +pctCollege +lotSize + livingArea*newConstruction, data=saratoga_train)
  #drop fuel variable
  lm_best=lm(price ~ sewer+ bedrooms*bathrooms*rooms + heating + pctCollege + lotSize + livingArea*newConstruction, data=saratoga_train)
  #lm_best duplicate test 
  lm_best2=lm(price ~ bedrooms*bathrooms*rooms + heating + pctCollege + lotSize + livingArea*newConstruction, data=saratoga_train)
  #stepwise selection model
  lm_step=lm(price ~ livingArea + landValue + bathrooms + waterfront + newConstruction +  heating + lotSize + age + centralAir + rooms + bedrooms +                landValue:newConstruction + bathrooms:heating + livingArea:bathrooms + 
               lotSize:age + livingArea:waterfront + landValue:lotSize + 
               livingArea:centralAir + age:centralAir + livingArea:landValue + 
               bathrooms:bedrooms + bathrooms:waterfront + heating:bedrooms + 
               heating:rooms + waterfront:centralAir + waterfront:lotSize + 
               landValue:age + age:rooms + livingArea:lotSize + lotSize:rooms + 
               lotSize:centralAir, data=saratoga_train)
  
  lm_step2 =lm(formula = price ~ lotSize + age + livingArea + pctCollege + 
                 bedrooms + fireplaces + bathrooms + rooms + heating + fuel + 
                 centralAir + landValue + waterfront + newConstruction + livingArea:centralAir + 
                 landValue:newConstruction + bathrooms:heating + livingArea:fuel + 
                 pctCollege:fireplaces + lotSize:landValue + fuel:centralAir + 
                 age:centralAir + age:pctCollege + livingArea:waterfront + 
                 fireplaces:waterfront + fireplaces:landValue + livingArea:fireplaces + 
                 bedrooms:fireplaces + pctCollege:landValue + bedrooms:waterfront + 
                 bathrooms:landValue + heating:waterfront + rooms:heating + 
                 bedrooms:heating + rooms:fuel, data = SaratogaHouses)
  
  
  # predictions
  yhat_medium = predict(lm_medium2, saratoga_test)
  yhat_better= predict(lm_better, saratoga_test)
  yhat_better_int=predict(lm_better_int, saratoga_test)
  yhat_best=predict(lm_best, saratoga_test)
  yhat_best2=predict(lm_best2, saratoga_test)
  yhat_step=predict(lm_step, saratoga_test)
  yhat_step2=predict(lm_step2, saratoga_test)
  
  
  c(rmse(saratoga_test$price, yhat_medium),
    rmse(saratoga_test$price, yhat_better),
    rmse(saratoga_test$price, yhat_better_int), 
    rmse(saratoga_test$price, yhat_best),  
    rmse(saratoga_test$price, yhat_best2), 
    rmse(saratoga_test$price, yhat_step),
    rmse(saratoga_test$price, yhat_step2)
  )
}

colMeans(rmse_vals_better)
which.min(colMeans(rmse_vals_better))
#lm_best is the best performer here, and outperforms test 4 from previous attempts

lmcall <- as.character(formula(lm_best))
lmvars <- unlist(strsplit(gsub('price ~','',lmcall), '\\+'))
for(i in lmvars){
  curvar <- trimws(i)
  
  # Positive values are good, measures the benefit of including a given variable in the regression 
  # (i.e. removing the variable is associated with a an average increase in RMSE of this amount)
  rmse_var_val <- do(50)*{
    # splitting again 
    n = nrow(SaratogaHouses)
    n_train = round(0.8*n)  # round to nearest integer
    n_test = n - n_train
    train_cases = sample.int(n, n_train, replace=FALSE)
    test_cases = setdiff(1:n, train_cases)
    saratoga_train = SaratogaHouses[train_cases,]
    saratoga_test = SaratogaHouses[test_cases,]
    
    # Test best regression plus modified regression with 1 covariate removed
    origmodel <- lm(as.formula(paste0(lmcall)), data = saratoga_train)
    curmodel <- lm(as.formula(paste0(lmcall,'-',curvar)), data=saratoga_train)
    
    # predictions
    yhat_orig = predict(origmodel, saratoga_test)
    yhat_cur = predict(curmodel, saratoga_test)
    c(-rmse(saratoga_test$price, yhat_orig)+rmse(saratoga_test$price, yhat_cur))
  }
  #stop here 
  print(length(names(coef(origmodel)))-length(names(coef(curmodel))))
  print(paste0(curvar,': ', as.numeric(colMeans(rmse_var_val))))
}
colMeans(rmse_vals_better)
which.min(colMeans(rmse_vals_better))
#lm_best is the best performer here, and outperforms test 4 from previous attempts


