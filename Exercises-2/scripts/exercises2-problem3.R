library(tidyverse)
library(tidyr)
library(gamlr)
library(doMC)

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


lm=lm(log(shares) ~ 1 , data=news)
forward_lm= step(lm, direction='forward',
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
                            title_sentiment_polarity))

lm1=lm(shares ~ 1 , data=news)
forward_lm1= step(lm1, direction='forward',
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
                            title_sentiment_polarity))

glm=glm(viral ~ 1 , data=news1)
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
                            title_sentiment_polarity))

avoid_overfitting_logshares= do(10)*{# splitting
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
               data_channel_is_lifestyle + num_imgs + num_self_hrefs + avg_negative_polarity +  num_keywords + title_sentiment_polarity + weekday_is_friday + weekday_is_monday + title_subjectivity + min_positive_polarity +  avg_positive_polarity + num_videos + data_channel_is_socmed + n_tokens_title , data=news_train)
  
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

colMeans(avoid_overfitting_logshares)
#need to do a base model to compare to
avoid_overfitting_shares= do(10)*{# splitting
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

avoid_overfitting1= do(10)*{# splitting
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
avoid_overfitting_lasso= do(10)*{# splitting
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
