library(tidyverse)
library(gamlr)

online_news = read.csv("./data/online_news.csv")

hist(log(online_news$shares))

lm_initial = lm(log(shares) ~ . - url, data=online_news)
summary(lm_initial)


covariates = online_news[,2:37]
shares_result = online_news$shares


fit = gamlr(x = covariates,
      y = log(shares_result),
      family = 'gaussian')
plot(fit)

coef(fit)

feature_logit = coef(fit) %>% sort(., decreasing=TRUE)
head(feature_logit, 25)

