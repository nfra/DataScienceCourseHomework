library(tidyverse)
library(tidyr)
library(gamlr)
library(doMC)

##########THIS IS NOT DONE################ See further down for some more organized stuff ####

news<-read_csv("online_news.csv")
news$url<- NULL
news1<-
  news %>% mutate(viral=ifelse(shares>1400, 1, 0))


hist(log(news1$shares))

lm_initial = lm(log(shares) ~ ., data=news1)

summary(lm_initial)

covariates = news1[,1:36]
shares_result = news1$viral


fit1 = gamlr(x = covariates,
      y = shares_result,
      family = 'binomial')
plot(fit1)

coef(fit1)


feature_logit = coef(fit1) %>% sort(., decreasing=TRUE)
head(feature_logit, 10)
feature_logit
beta_h[colnames(news1),]

feature_logit

glm=glm(viral ~ data_channel_is_world + data_channel_is_entertainment + 
          is_weekend + data_channel_is_bus + num_hrefs + data_channel_is_socmed + 
          self_reference_avg_sharess + num_keywords + average_token_length + 
          num_self_hrefs + n_tokens_content + weekday_is_friday + title_sentiment_polarity + 
          data_channel_is_lifestyle + num_imgs + weekday_is_saturday + 
          weekday_is_monday + title_subjectivity + min_positive_polarity + 
          avg_positive_polarity + avg_negative_polarity + data_channel_is_tech + 
          n_tokens_title + weekday_is_thursday + global_rate_positive_words + 
          global_rate_negative_words + num_videos , data=news1)
forward_glm= step(glm, direction='forward',
                  scope=~(n_tokens_title+
                            n_tokens_content+
                            num_hrefs+
                            num_self_hrefs+
                            num_imgs+
                            num_videos+
                            average_token_length+
                            num_keywords+
                            data_channel_is_lifestyle+
                            data_channel_is_entertainment+
                            data_channel_is_bus+
                            data_channel_is_socmed+
                            data_channel_is_tech+
                            data_channel_is_world+
                            self_reference_min_shares+
                            self_reference_max_shares+
                            self_reference_avg_sharess+
                            +is_weekend+
                            weekday_is_monday+
                            weekday_is_tuesday+
                            weekday_is_wednesday+
                            weekday_is_thursday+
                            weekday_is_friday+
                            weekday_is_saturday+
                            weekday_is_sunday+
                            global_rate_positive_words+
                            global_rate_negative_words+
                            avg_positive_polarity+
                            min_positive_polarity+
                            max_positive_polarity+
                            avg_negative_polarity+
                            min_negative_polarity+
                            max_negative_polarity+
                            title_subjectivity+
                            title_sentiment_polarity)^2)


avoid_overfitting_logshares= do(100)*{# splitting
  n = nrow(news)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  news_train = news[train_cases,]
  news_test = news[test_cases,]
  
  # regressions
  lm_news=lm(log(shares) ~ data_channel_is_world + data_channel_is_entertainment + 
               data_channel_is_bus + num_hrefs + weekday_is_sunday + weekday_is_saturday +
               self_reference_avg_sharess + data_channel_is_tech + average_token_length + 
               data_channel_is_lifestyle + num_imgs + num_self_hrefs + avg_negative_polarity +  
               num_keywords + title_sentiment_polarity + weekday_is_friday + weekday_is_monday + 
               title_subjectivity + min_positive_polarity +  avg_positive_polarity + num_videos + 
               data_channel_is_socmed + n_tokens_title , data=news_train)
  
  # predictions
  yhat_news1 = exp(predict(lm_news1, news_test))
  
  
  #output
  
  outcome_1=confusion_fun(news_test$shares, yhat_news1)
  
  
  c(count(outcome_1=="truepos"),
    count(outcome_1=="falsepos"),
    count(outcome_1=="falseneg"), 
    count(outcome_1=="trueneg")
  )
}

colMeans(avoid_overfitting_logshares)
#need to do a base model to compare to
avoid_overfitting_shares= do(100)*{# splitting
  n = nrow(news)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  news_train = news[train_cases,]
  news_test = news[test_cases,]
  
  # regressions
  lm_news=lm(shares~self_reference_avg_sharess + data_channel_is_world + 
               num_hrefs + average_token_length + avg_negative_polarity + 
               data_channel_is_entertainment + data_channel_is_tech + data_channel_is_bus + 
               data_channel_is_socmed + data_channel_is_lifestyle + num_self_hrefs + 
               self_reference_min_shares + n_tokens_title + num_keywords + 
               num_imgs + weekday_is_monday + weekday_is_saturday + self_reference_max_shares + 
               title_sentiment_polarity , data=news_train)
  
  # predictions
  yhat_news1 = predict(lm_news1, news_test)
  
  
  #output
  
  outcome_1=confusion_fun(news_test$shares, yhat_news1)
  
  
  c(count(outcome_1=="truepos"),
    count(outcome_1=="falsepos"),
    count(outcome_1=="falseneg"), 
    count(outcome_1=="trueneg")
  )
}

avoid_overfitting1= do(100)*{# splitting
  n = nrow(news1)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  news1_train = news1[train_cases,]
  news1_test = news1[test_cases,]
  
  # regressions
  glm_news=glm(viral ~ data_channel_is_world + data_channel_is_entertainment + 
                 weekday_is_saturday + weekday_is_sunday + data_channel_is_bus + 
                 num_hrefs + data_channel_is_socmed + self_reference_avg_sharess + 
                 num_keywords + average_token_length + num_self_hrefs + n_tokens_content + 
                 weekday_is_friday + title_sentiment_polarity + data_channel_is_lifestyle + 
                 num_imgs + weekday_is_monday + title_subjectivity + min_positive_polarity + 
                 avg_positive_polarity + avg_negative_polarity + data_channel_is_tech + 
                 n_tokens_title + weekday_is_thursday + global_rate_positive_words + 
                 global_rate_negative_words + num_videos, data=news1_train, family='binomial')
  # predictions
  yhat_newsglm = predict(glm_news, news1_test)
  
  #output
  
  outcome_1=confusion_fun1(news1_test$viral, yhat_newsglm)
  
  
  c(count(outcome_1=="truepos"),
    count(outcome_1=="falsepos"),
    count(outcome_1=="falseneg"), 
    count(outcome_1=="trueneg")
  )
} 
avoid_overfitting_lasso= do(100)*{# splitting
  n = nrow(news1)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  news1_train = news1[train_cases,]
  news1_test = news1[test_cases,]
  
  # regressions
  glm_news=glm(viral ~ . - min_negative_polarity -max_negative_polarity -shares
               -abs_title_sentiment_polarity -weekday_is_sunday -weekday_is_thursday, data=news1_train, family='binomial')
  # predictions
  yhat_newsglm = predict(glm_news, news1_test)
  
  #output
  
  outcome_1=confusion_fun1(news1_test$viral, yhat_newsglm)
  
  
  c(count(outcome_1=="truepos"),
    count(outcome_1=="falsepos"),
    count(outcome_1=="falseneg"), 
    count(outcome_1=="trueneg")
  )
} 
colMeans(avoid_overfitting_logshares)
colMeans(avoid_overfitting_shares)
colMeans(avoid_overfitting1)
colMeans(avoid_overfitting_lasso)

3595.8+1096.2
4692/7929

3893.4+51.6
3945/7929

###Claire's actual Stuff###
library(tidyverse)
library(mosaic)
library(FNN)
library(foreach)
library(readr)
library(doMC) 

news<-read_csv("online_news.csv")
news$url<- NULL

#split data
# splitting
n = nrow(news)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train
train_cases = sample.int(n, n_train, replace=FALSE)
test_cases = setdiff(1:n, train_cases)
news_train = news[train_cases,]
news_test = news[test_cases,]
#out of sample performance

lm_news=lm(shares~self_reference_avg_sharess + data_channel_is_world + 
             num_hrefs + average_token_length + avg_negative_polarity + 
             data_channel_is_entertainment + data_channel_is_tech + data_channel_is_bus + 
             data_channel_is_socmed + data_channel_is_lifestyle + num_self_hrefs + 
             self_reference_min_shares + n_tokens_title + num_keywords + 
             num_imgs + weekday_is_monday + weekday_is_saturday + self_reference_max_shares + 
             title_sentiment_polarity, data=news_train)

#log of shares built stepwise
lm_news1=lm(log(shares) ~ data_channel_is_world + data_channel_is_entertainment + 
              is_weekend + data_channel_is_bus + num_hrefs + self_reference_avg_sharess + 
              data_channel_is_tech + average_token_length + data_channel_is_lifestyle + 
              num_imgs + num_self_hrefs + avg_negative_polarity + num_keywords + 
              title_sentiment_polarity + weekday_is_friday + weekday_is_monday + 
              title_subjectivity + min_positive_polarity + avg_positive_polarity + 
              num_videos + data_channel_is_socmed + n_tokens_title , data=news_train)

#logit model
news1<-
  news %>% mutate(viral=ifelse(shares>1400, 1, 0))

glm_news = glm(viral ~ data_channel_is_world + data_channel_is_entertainment + 
                 is_weekend + data_channel_is_bus + num_hrefs + data_channel_is_socmed + 
                 self_reference_avg_sharess + num_keywords + average_token_length + 
                 num_self_hrefs + n_tokens_content + weekday_is_friday + title_sentiment_polarity + 
                 data_channel_is_lifestyle + num_imgs + weekday_is_saturday + 
                 weekday_is_monday + title_subjectivity + min_positive_polarity + 
                 avg_positive_polarity + avg_negative_polarity + data_channel_is_tech + 
                 n_tokens_title + weekday_is_thursday + global_rate_positive_words + 
                 global_rate_negative_words + num_videos, data=news1, family='binomial')

#confusion matrix for logit model
n = nrow(news1)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train
train_cases = sample.int(n, n_train, replace=FALSE)
test_cases = setdiff(1:n, train_cases)
news1_train = news1[train_cases,]
news1_test = news1[test_cases,]

phat_test_news_logit = predict(glm_news, news1_test, type= 'response')
yhat_test_news_logit = ifelse(phat_test_news_logit > 0.5, 1, 0)
confusion_out_logit = table(y = news1_test$viral, yhat = yhat_test_news_logit)
confusion_out_logit




#function for classification for linear models
confusion_fun= function(y, ypred) {
  ifelse(ypred>1400 & y>1400, "truepos", 
         ifelse(ypred>1400 & y<=1400, "falsepos", 
                ifelse(ypred<=1400 & y>1400, "falseneg", "trueneg")))}

#function for classification for logit models
confusion_fun1= function(y, ypred) {
  ifelse(ypred  > .5 & y >.5, "truepos", 
         ifelse(ypred >.5 & y <=.5 , "falsepos", 
                ifelse(ypred <=.5 & y > .5, "falseneg",  "trueneg")))}

#baseline models to compare to
#best model is nonviral
table(news1_test$viral)

baseline_nonviral= do(100)*{# splitting
  n = nrow(news)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  news_train = news[train_cases,]
  news_test = news[test_cases,]
  
  #output
  
  outcome_1=confusion_fun(news_test$shares, 1300)
  
  c(count(outcome_1=="trueneg"),
    count(outcome_1=="falseneg"),
    count(outcome_1=="falsepos"), 
    count(outcome_1=="truepos")
  )
}

colnames(baseline_nonviral) = c("0 0", "1 0", 
                                "0 1", "1 1")
colMeans(baseline_nonviral)
baseline_nvmatrix<-baseline_nonviral %>% 
  pivot_longer(cols = colnames(.)) %>% 
  separate(name, into = c("Value", "Type")) %>% 
  pivot_wider(id_cols = "Value", names_from = "Type",
              values_fn = list(value = mean))
baseline_nvmatrix
#overall error rate
3909/7929
#true positive rate
0
#false positive rate
3909/7929

#Shares model loop
shares_model= do(100)*{# splitting
  n = nrow(news)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  news_train = news[train_cases,]
  news_test = news[test_cases,]
  
  # regressions
  lm_news=lm(shares~self_reference_avg_sharess + data_channel_is_world + 
               num_hrefs + average_token_length + avg_negative_polarity + 
               data_channel_is_entertainment + data_channel_is_tech + data_channel_is_bus + 
               data_channel_is_socmed + data_channel_is_lifestyle + num_self_hrefs + 
               n_tokens_title + num_imgs + self_reference_min_shares + weekday_is_monday + 
               weekday_is_saturday + num_keywords + self_reference_max_shares + 
               self_reference_avg_sharess:average_token_length + self_reference_avg_sharess:avg_negative_polarity + 
               self_reference_avg_sharess:data_channel_is_tech + num_hrefs:data_channel_is_tech + 
               avg_negative_polarity:data_channel_is_bus + num_self_hrefs:num_imgs + 
               self_reference_avg_sharess:self_reference_min_shares + data_channel_is_bus:self_reference_min_shares + 
               average_token_length:self_reference_min_shares + n_tokens_title:self_reference_min_shares + 
               avg_negative_polarity:self_reference_min_shares + self_reference_avg_sharess:n_tokens_title + 
               num_hrefs:data_channel_is_bus + self_reference_min_shares:weekday_is_monday + 
               avg_negative_polarity:weekday_is_monday + average_token_length:weekday_is_monday + 
               self_reference_min_shares:weekday_is_saturday + num_self_hrefs:self_reference_min_shares + 
               num_hrefs:self_reference_min_shares + data_channel_is_tech:self_reference_min_shares + 
               average_token_length:num_self_hrefs + average_token_length:data_channel_is_bus + 
               self_reference_avg_sharess:data_channel_is_lifestyle + average_token_length:n_tokens_title + 
               data_channel_is_socmed:self_reference_min_shares + avg_negative_polarity:num_keywords + 
               data_channel_is_world:num_imgs + num_hrefs:weekday_is_saturday + 
               data_channel_is_bus:weekday_is_monday + self_reference_avg_sharess:self_reference_max_shares + 
               data_channel_is_tech:self_reference_max_shares + num_keywords:self_reference_max_shares + 
               self_reference_avg_sharess:num_keywords + num_self_hrefs:n_tokens_title + 
               data_channel_is_socmed:num_imgs + average_token_length:self_reference_max_shares + 
               data_channel_is_world:average_token_length + data_channel_is_bus:num_imgs + 
               avg_negative_polarity:n_tokens_title , data=news_train)
  
  # predictions
  yhat_news1 = predict(lm_news, news_test)
  
  
  #output
  
  outcome_1=confusion_fun(news_test$shares, yhat_news1)
  
  
  c(count(outcome_1=="trueneg"),
    count(outcome_1=="falseneg"),
    count(outcome_1=="falsepos"), 
    count(outcome_1=="truepos")
  )
}
#name columns
colnames(shares_model) = c("0 0", "1 0", 
                           "0 1", "1 1")
#turn into confusion matrix
shares_matrix <-shares_model %>% 
  pivot_longer(cols = colnames(.)) %>% 
  separate(name, into = c("Value", "Type")) %>% 
  pivot_wider(id_cols = "Value", names_from = "Type",
              values_fn = list(value = mean))
shares_matrix
#Log of shares model loop

logshares_model= do(100)*{# splitting
  n = nrow(news)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  news_train = news[train_cases,]
  news_test = news[test_cases,]
  
  # regressions
  lm_news=lm(log(shares) ~ data_channel_is_world + data_channel_is_entertainment + 
               is_weekend + data_channel_is_bus + num_hrefs + self_reference_avg_sharess + 
               data_channel_is_tech + average_token_length + data_channel_is_lifestyle + 
               num_imgs + num_self_hrefs + avg_negative_polarity + num_keywords + 
               title_sentiment_polarity + weekday_is_friday + weekday_is_monday + 
               title_subjectivity + min_positive_polarity + avg_positive_polarity + 
               num_videos + data_channel_is_socmed + n_tokens_title, data=news_train)
  
  # predictions
  yhat_news1 = exp(predict(lm_news, news_test))
  
  
  #output
  
  outcome_1=confusion_fun(news_test$shares, yhat_news1)
  
  
  c(count(outcome_1=="trueneg"),
    count(outcome_1=="falseneg"),
    count(outcome_1=="falsepos"), 
    count(outcome_1=="truepos")
  )
}
#name columns
colnames(logshares_model) = c("0 0", "1 0", 
                           "0 1", "1 1")
#turn into confusion matrix
logshares_matrix<- logshares_model %>% 
  pivot_longer(cols = colnames(.)) %>% 
  separate(name, into = c("Value", "Type")) %>% 
  pivot_wider(id_cols = "Value", names_from = "Type",
              values_fn = list(value = mean))


#Report the confusion matrix, overall error rate, true positive rate, and false positive rate for your best model

#confusion matrix
logshares_matrix
colMeans(logshares_model)

#overall error rate
(568+2704)/7929
#true positive rate
3348/(564+3348)
#false positive rate
2719/(1299+2719)


#Logit Loop
logit_model= do(100)*{# splitting
  n = nrow(news1)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  news1_train = news1[train_cases,]
  news1_test = news1[test_cases,]

  # regressions model built stepwise 
  glm_news=glm(viral ~ data_channel_is_world + data_channel_is_entertainment + 
                 is_weekend + data_channel_is_bus + num_hrefs + self_reference_avg_sharess + 
                 data_channel_is_tech + average_token_length + data_channel_is_lifestyle + 
                 num_imgs + num_self_hrefs + avg_negative_polarity + num_keywords + 
                 title_sentiment_polarity + weekday_is_friday + weekday_is_monday + 
                 title_subjectivity + min_positive_polarity + avg_positive_polarity + 
                 num_videos + data_channel_is_socmed + n_tokens_title +n_tokens_content +num_hrefs
               + average_token_length +global_rate_positive_words +global_rate_negative_words +abs_title_sentiment_polarity
               ,data=news1_train, family='binomial')
  
  # predictions
  yhat_newsglm = predict(glm_news, news1_test)
  
  #output
  
  outcome_2=confusion_fun1(news1_test$viral, yhat_newsglm)
  
  
  c(count(outcome_2=="trueneg"),
    count(outcome_2=="falseneg"),
    count(outcome_2=="falsepos"), 
    count(outcome_2=="truepos")
  )
}
#name columns
colnames(logit_model) = c("0 0", "1 0", 
                          "0 1", "1 1")
#turn into confusion matrix
logit_matrix<- logit_model %>% 
  pivot_longer(cols = colnames(.)) %>% 
  separate(name, into = c("Value", "Type")) %>% 
  pivot_wider(id_cols = "Value", names_from = "Type",
              values_fn = list(value = mean))


#Report the confusion matrix, overall error rate, true positive rate, and false positive rate for your best model

#confusion matrix
colMeans(logit_model)
logit_matrix


#overall error rate
(421+2830)/7929

#true positive rate
1086/(1086+2828)

#false positive rate
421.64/(3597.77+421.64)
