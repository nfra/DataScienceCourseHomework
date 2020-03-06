library(tidyverse)
library(mosaic)
library(nnet)

brca = read.csv("./data/brca.csv")

# Part 1

# using a logistic regression
binomial_recall_model = glm(recall ~ . - cancer, data=brca, family=binomial)

summary(binomial_recall_model)

confusion_matrix_radiologist34 = table(cancer = brca$cancer[brca$radiologist == 'radiologist34'],
                                       recall = brca$recall[brca$radiologist == 'radiologist34'])
confusion_matrix_radiologist34
confusion_matrix_radiologist89 = table(cancer = brca$cancer[brca$radiologist == 'radiologist89'],
                                       recall = brca$recall[brca$radiologist == 'radiologist89'])
confusion_matrix_radiologist89

# Plot radiologist regression coefficients with 95% CI

callback_conservatism = data.frame(summary(binomial_recall_model)$coefficients[2:5,])
callback_conservatism$radiologist = c('34', '66', '89', '95')
callback_conservatism$ci95_low = callback_conservatism[,1] - 1.96*callback_conservatism[,2]
callback_conservatism$ci95_high = callback_conservatism[,1] + 1.96*callback_conservatism[,2]

ggplot(aes(x = radiologist,
           y = Estimate), 
       data = callback_conservatism) +
  geom_pointrange(aes(ymin = ci95_low, ymax = ci_95high)) +
  geom_hline(yintercept = 0, color = "red")

# Plot radiologist regression coefficients with 90% CI

callback_conservatism$ci90_low = callback_conservatism[,1] - 1.645*callback_conservatism[,2]
callback_conservatism$ci90_high = callback_conservatism[,1] + 1.645*callback_conservatism[,2]


ggplot(aes(x = radiologist,
           y = Estimate), 
       data = callback_conservatism) +
  geom_pointrange(aes(ymin = ci90_low, ymax = ci90_high)) +
  geom_hline(yintercept = 0, color = "red")

# Part 2

# using a logistic regression for all radiologists

logit_cancer_model = glm(cancer ~ ., data=brca, family=binomial)
coef(logit_cancer_model)

callback_error = data.frame(summary(logit_cancer_model)$coefficients)
callback_error_sig = callback_error[callback_error$Pr...z..<=0.1,]
callback_error_sig$label = c('Intercept', 'Recalled', 'Age > 70', 'Tissue Density 4')

callback_error_sig$ci95_low = callback_error_sig[,1] - 1.96*callback_error_sig[,2]
callback_error_sig$ci95_high = callback_error_sig[,1] + 1.96*callback_error_sig[,2]

ggplot(aes(x = label,
           y = Estimate), 
       data = callback_error_sig) +
  geom_pointrange(aes(ymin = ci95_low, ymax = ci95_high)) +
  geom_hline(yintercept = 0, color = "red")

# using a logistic regression with radiologist interactions

logit_cancer_int_model = glm(cancer ~ radiologist * . , data=brca, family=binomial)
coef(logit_cancer_int_model)

callback_error_int = data.frame(summary(logit_cancer_int_model)$coefficients)
callback_error_int_sig = callback_error_int[callback_error_int$Pr...z..<=0.1,]
callback_error_int_sig$label = c('Recalled', 'Age 50-59', 'Rad. 66: Age 50-59', 'Rad. 89: Age 50-59', 'Rad. 95: Post Meno, No HT')

callback_error_int_sig$ci95_low = callback_error_int_sig[,1] - 1.96*callback_error_int_sig[,2]
callback_error_int_sig$ci95_high = callback_error_int_sig[,1] + 1.96*callback_error_int_sig[,2]

ggplot(aes(x = label,
           y = Estimate), 
       data = callback_error_int_sig) +
  geom_pointrange(aes(ymin = ci95_low, ymax = ci95_high)) +
  geom_hline(yintercept = 0, color = "red")






