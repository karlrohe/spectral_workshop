
library(vsp)
library(tidytext)
source("src.R")


# load(file = "data/journal-journal_graph.RData")
fa_journal = vsp(A_journal, rank = 10,scale = T,rescale = T)

# here are the journal names:
uniqueJournals = rownames(A_journal)

#bff:
bff_with_words(fa_journal$Y, uniqueJournals,7) %>% View
#top_journals:
top_loadings(fa_journal$Y, uniqueJournals) %>% View




load(file = "data/graph_twitter.RData")
fa_twitter =  vsp(graph_twitter, rank = 20, scale = T)


# we have lots of information about the nodes in the graph:
node_info = graph_twitter %>% as_tibble
colnames(node_info)

# you can get their bios:
bios = node_info$description

# you can get their handles:
handles = node_info$screen_name


# fa_twitter =  vsp(graph_twitter, rank = 10, scale = T)
topaccounts = top_loadings(fa_twitter$Y, handles)
bffs = bff_with_words(fa_twitter$Y, bios,7)
View(bffs)
topaccounts %>% t %>% View

# load(file = "data/factor_analysis_abstracts.RData")
# fa_fa = vsp(A_fa, rank = 10, scale = T)  # this takes ~1 minute.

