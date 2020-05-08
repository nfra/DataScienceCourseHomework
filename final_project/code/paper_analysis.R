library(jsonlite)
library(data.table)
library(tidyverse)
library(stats)

# load journal information
journal_fields = as.data.table(read.csv("C:/Users/Nathan/Documents/journals_merged.csv"))[,2:3]
journal_fields$Categories = str_remove_all(as.character(journal_fields$Categories), ' [(]Q[1-4][)]')
journal_fields$fields_disagg = strsplit(as.character(journal_fields$Categories), "; ")


# loop through all files
results_meancitationCount_global = data.table()
results_sdcitationCount_global = data.table()
results_meancitedPaperMult_global = data.table()
results_meancitedPaper_global = data.table()
results_numberInQuantile_global = data.table()
i = 0
for(field_in_question in unique(journal_fields$Categories))
{
  i = i + 1
  print(paste(i, '/6140: ' ,field_in_question, sep=''))
  
  # define file path
  filename = substr(str_remove_all(str_replace_all(str_remove_all(field_in_question, "and "), "[(]miscellaneous[)]", "(misc)"), " "), 1, 247)
  filepath = paste('C:/data/', filename, '.txt', sep = '')
  
  # load paper data
  paper_data = as.data.table(fromJSON(filepath)[["results"]][["bindings"]])
  if(is_empty(paper_data)){next}
  
  # add journal field data
  paper_data$citedJournalFields = journal_fields[match(paper_data$citedJournal.value, journal_fields$journal), 'fields_disagg']
  
  # take subset of cited papers published in journals with field data
  paper_data = subset(paper_data, !(apply(paper_data[,'citedJournalFields'], MARGIN = 1, FUN = function(x) is.null(unlist(x)))))
  
  # separate all fields in aggregated field string
  field_in_question_split = flatten(strsplit(field_in_question, "; "))
  
  # add columns evaluating whether there's any overlap between fields of journals and cited journals
  for(field in field_in_question_split)
  {
    paper_data[[field]] = apply(paper_data[,'citedJournalFields'], MARGIN = 1, FUN = function(x, y) is.element(y, unlist(x)), y = field)
  }
  
  # define the length of the dataframe
  end_column_num = length(paper_data)
  
  # add column categorizing as single-disciplinary and multidisciplinary
  paper_data$multidisciplinary = TRUE
  paper_data[apply(paper_data[, 13:end_column_num], MARGIN = 1, FUN = any), 'multidisciplinary'] = FALSE
  
  # group all cited paper fields together
  paper_data_grouped = paper_data %>%
    group_by(journal.value, paper.value) %>%
    summarize(citationCount.value = mean(as.numeric(citationCount.value)),
              citedJournalFields = list(unique(unlist(citedJournalFields))),
              numberCitedPapers_multidisciplinary = sum(multidisciplinary),
              numberCitedPapers = n()
    )
  
  paper_data_grouped = setDT(paper_data_grouped)[, quantile := .bincode(numberCitedPapers_multidisciplinary/numberCitedPapers,
                                                                   quantile(numberCitedPapers_multidisciplinary/numberCitedPapers, probs = seq(0, 1, 0.01)),
                                                                   include.lowest = TRUE)
                                                 ]
  
  # group all cited paper fields together
  paper_data_quantiles = paper_data_grouped %>%
    group_by(quantile) %>%
    summarize(meanCitationCount = mean(citationCount.value),
              sdCitationCount = sd(citationCount.value),
              citedJournalFields = list(unique(unlist(citedJournalFields))),
              meanCitedPapers = mean(numberCitedPapers),
              meanCitedPapers_multidisciplinary = mean(numberCitedPapers_multidisciplinary),
              numberInQuantile = n()
    )
  
  # construct summary statistics
  obs = nrow(paper_data_grouped)
  mean_cited = mean(paper_data_grouped$numberCitedPapers)
  mean_cited_mult = mean(paper_data_grouped$numberCitedPapers_multidisciplinary)
  
  # construct centile datatables
  centile_column_names = as.character(paper_data_quantiles$quantile)
  
  centiles_meanCitationCount = data.table(t(paper_data_quantiles$meanCitationCount))
  names(centiles_meanCitationCount) = centile_column_names
  centiles_sdCitationCount = data.table(t(paper_data_quantiles$sdCitationCount))
  names(centiles_sdCitationCount) = centile_column_names
  centiles_meanCitedPaperMult = data.table(t(paper_data_quantiles$meanCitedPapers_multidisciplinary))
  names(centiles_meanCitedPaperMult) = centile_column_names
  centiles_meanCitedPapers = data.table(t(paper_data_quantiles$meanCitedPapers))
  names(centiles_meanCitedPapers) = centile_column_names
  centiles_numberInQuantile = data.table(t(paper_data_quantiles$numberInQuantile))
  names(centiles_numberInQuantile) = centile_column_names
  
  # make result data frame rows
  results_meancitationCount_local = cbind(data.table('field' = field_in_question, 'obs' = obs, 'mean_cited' = mean_cited, 'mean_cited_mult' = mean_cited_mult),
                                          centiles_meanCitationCount)
  results_sdcitationCount_local = cbind(data.table('field' = field_in_question, 'obs' = obs, 'mean_cited' = mean_cited, 'mean_cited_mult' = mean_cited_mult),
                                        centiles_sdCitationCount)
  results_meancitedPaperMult_local = cbind(data.table('field' = field_in_question, 'obs' = obs, 'mean_cited' = mean_cited, 'mean_cited_mult' = mean_cited_mult),
                                           centiles_meanCitedPaperMult)
  results_meancitedPaper_local = cbind(data.table('field' = field_in_question, 'obs' = obs, 'mean_cited' = mean_cited, 'mean_cited_mult' = mean_cited_mult),
                                       centiles_meanCitedPapers)
  results_numberInQuantile_local = cbind(data.table('field' = field_in_question, 'obs' = obs, 'mean_cited' = mean_cited, 'mean_cited_mult' = mean_cited_mult),
                                         centiles_numberInQuantile)
  
  # bind local results to global results
  results_meancitationCount_global = bind_rows(results_meancitationCount_global, results_meancitationCount_local)
  results_sdcitationCount_global = bind_rows(results_sdcitationCount_global, results_sdcitationCount_local)
  results_meancitedPaperMult_global = bind_rows(results_meancitedPaperMult_global, results_meancitedPaperMult_local)
  results_meancitedPaper_global = bind_rows(results_meancitedPaper_global, results_meancitedPaper_local)
  results_numberInQuantile_global = bind_rows(results_numberInQuantile_global, results_numberInQuantile_local)
}


