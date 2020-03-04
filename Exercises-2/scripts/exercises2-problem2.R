library(tidyverse)
library(mosaic)
library(nnet)

brca = read.csv("./data/brca.csv")

# Part 1

# using a multinomial logistic regression
binomial_recall_model = glm(recall ~ . - cancer, data=brca, family=binomial)

summary(binomial_recall_model)

confusion_matrix_radiologist34 = table(cancer = brca$cancer[brca$radiologist == 'radiologist34'],
                                       recall = brca$recall[brca$radiologist == 'radiologist34'])
confusion_matrix_radiologist34
confusion_matrix_radiologist89 = table(cancer = brca$cancer[brca$radiologist == 'radiologist89'],
                                       recall = brca$recall[brca$radiologist == 'radiologist89'])
confusion_matrix_radiologist89

# Plot c

radiologist_estimates = data.frame(summary(binomial_recall_model)$coefficients[2:5,])
radiologist_estimates$radiologist = c('34', '66', '89', '95')
radiologist_estimates$ci_low = radiologist_estimates[,1] - 1.96*radiologist_comparison_data[,2]
radiologist_estimates$ci_high = radiologist_estimates[,1] + 1.96*radiologist_comparison_data[,2]
radiologist_estimates$est_lkhd = exp(radiologist_estimates$Estimate)
radiologist_estimates$ci_low_lkhd = exp(radiologist_estimates$ci_low)
radiologist_estimates$ci_high_lkhd = exp(radiologist_estimates$ci_high)



ggplot(aes(x = radiologist,
           y = Estimate), 
       data = radiologist_estimates) +
  geom_pointrange(aes(ymin = ci_low, ymax = ci_high)) +
  geom_hline(yintercept = 0, color = "red")

# Part 2

# using a multinomial logistic regression
binomial_cancer_model = glm(cancer ~ ., data=brca, family=binomial)
coef(binomial_cancer_model)

summary(binomial_cancer_model)


