library(tidyverse)
library(data.table)

mean_citation_count_data = as.data.table(read.csv("./data/results_meancitationCount_global.csv"))
mean_citation_count_data = 

mean_cited_paper_data = as.data.table(read.csv("./data/results_meancitedPaper_global.csv"))
mean_cited_paper_mult_data = as.data.table(read.csv("./data/results_meancitedPaperMult_global.csv"))
number_in_quantile_data = as.data.table(read.csv("./data/results_numberInQuantile_global.csv"))
sd_citation_count_data = as.data.table(read.csv("./data/results_sdcitationCount_global.csv"))

min(mean_citation_count_data$mean_cited_mult/mean_citation_count_data$mean_cited)

