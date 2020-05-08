library(tidyverse)
library(data.table)

mean_citation_count_data = as.data.table(read.csv("./data/results_meancitationCount_global.csv"))

mean_cited_paper_data = as.data.table(read.csv("./data/results_meancitedPaper_global.csv"))
mean_cited_paper_mult_data = as.data.table(read.csv("./data/results_meancitedPaperMult_global.csv"))
number_in_quantile_data = as.data.table(read.csv("./data/results_numberInQuantile_global.csv"))
sd_citation_count_data = as.data.table(read.csv("./data/results_sdcitationCount_global.csv"))

min(mean_citation_count_data$mean_cited_mult/mean_citation_count_data$mean_cited)

centile_column_order = c(5:19, 102, 20:48, 103, 49:67, 104, 68:101)

centile_reflow_data = data.table()

for(i in 1:6019)
  {
  centile_reflow_row = data.table('centile' = 1:100, 
                                  'mean_citation_count' = t(mean_citation_count_data[i, c(5:19, 102, 20:48, 103, 49:67, 104, 68:101)]), 
                                  'field' = mean_citation_count_data[i, 'field'])
  centile_reflow_data = rbind(centile_reflow_data, centile_reflow_row)
  }

centile_reflow_data[centile_reflow_data$centile%%10 == 0, 'decile2'] = centile_reflow_data[centile_reflow_data$centile%%10 == 0, ]$centile/10


ggplot(data = centile_reflow_data) +
  geom_smooth(aes(x = centile, y = mean_citation_count.V1), method = 'lm', formula = y ~ x + I(x^2))

lm(formula = mean_citation_count.V1 ~ centile + I(centile^2), data = centile_reflow_data)

ggplot(data = subset(centile_reflow_data, ! is.na(decile2))) +
  geom_violin(aes(x = as.factor(decile2), y = mean_citation_count.V1)) +
  coord_cartesian(ylim=c(0, 75))
  

subset(centile_reflow_data, !(is.na(decile)))

lm(mean_citation_count.V1 ~ centile + I(centile^2), data = data1)
