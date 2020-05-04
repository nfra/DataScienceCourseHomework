library(tidyverse)
library(stringi)

# read data
journals_scimago = read.csv("./data/journals_scimago.csv")
journals_ma_graph = read.csv("./data/journals_ma_graph.csv")
journals_ma_graph_issn = read.csv("./data/journals_ma_graph_issn.csv")

# remove dashes in ISSN for matching
journals_ma_graph_issn[['issn_no_dash']] = str_remove(journals_ma_graph_issn[['issn']], "-")

# add ISSNs to larger ma-graph list for those journals that have them
journals_ma_graph$issn = journals_ma_graph_issn[match(journals_ma_graph$name, journals_ma_graph_issn$name),"issn_no_dash"]

# clean up broken Unicode in names from ma-graph
journals_ma_graph$name = str_replace_all(journals_ma_graph$name, "&amp;", "and")
journals_ma_graph$name = str_replace_all(journals_ma_graph$name, "&#039;", "'")
journals_ma_graph$name = str_replace_all(journals_ma_graph$name, "&#x00E9;", "e")
journals_ma_graph$name = str_replace_all(journals_ma_graph$name, "&#x2013;", "-")

# remove diacritics in names from ma-graph
journals_ma_graph$name = stri_encode(stri_trans_general(journals_ma_graph$name, id = "Latin-ASCII"), to = "UTF8")

# remove punctuation in names from both datasets
journals_ma_graph$name = str_remove_all(journals_ma_graph$name, "[^[:alnum:]]")
journals_scimagov$name = str_remove_all(journals_ma_graph$name, "[^[:alnum:]]")

# match between datasets by ISSN and name
journals_ma_graph$issn_match = pmatch(journals_ma_graph$issn, journals_scimago$Issn)
journals_ma_graph$name_match = match(str_remove_all(stri_trans_general(journals_ma_graph$name, id = "lower"), "[^[:alnum:]]"), 
                                     str_remove_all(stri_trans_general(journals_scimago$Title, id = "lower"), "[^[:alnum:]]")
                                     )

# make final match, privileging issn match
journals_ma_graph$match = journals_ma_graph$issn_match
journals_ma_graph[is.na(journals_ma_graph$match),'match'] = journals_ma_graph[is.na(journals_ma_graph$match),'name_match']

# make merged dataset
journals_both_ma_graph = subset(journals_ma_graph, !is.na(match))
journals_both_scimago = journals_scimago[journals_both_ma_graph$match,]
journals_both = cbind(journals_both_ma_graph, journals_both_scimago)

# export merged dataset
journals_for_python = journals_both[,c('journal','Categories')]

journals_for_python$journal = stri_encode(journals_for_python$journal, to = "UTF8")
journals_for_python$Categories = stri_encode(journals_for_python$Categories, to = "UTF8")

write.csv(journals_for_python, "./data/journals_merged.csv")


paste(str_replace_all(economics_journals$journal, "http://ma-graph.org/entity/", ":"), collapse = " ")

economics_papers = read.csv("./data/econ_papers.csv")
