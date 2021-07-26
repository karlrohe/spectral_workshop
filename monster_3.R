library(Matrix)
library(fastRG)
library(RSpectra)
library(tidyverse)
library(vsp)
source("src.R")




load(file = "data/journal-journal_graph.RData")
load(file = "data/factor_analysis_abstracts.RData")
load(file = "data/graph_twitter.RData")


# what do the data plots look like without
#   normalization and regularization???


fa_journal = vsp(A_journal, rank = 10,scale = F)
u = fa_journal$u
my_pairs(u)

fa_fa = vsp(A_fa, rank = 10, scale = F)  # this takes ~1 minute.
u = fa_fa$u
my_pairs(u, n = 10000)

fa_twitter =  vsp(graph_twitter, rank = 10, scale = F)
u = fa_twitter$u
my_pairs(u)








# In this simulation,  I've made the estimation harder in two ways
#   1) Higher proportion of "out-of-cluster-friendships"
#   2) lower expected degree.
n = 10000
thetas = rexp(n)
B = matrix(c(2,1,1,2), nrow = 2)

# this parameterizes a dc-sbm
mod = fastRG::dcsbm(theta = thetas,
                    B = B,
                    expected_degree = 10)
# this simulates a sparse adjacency matrix:
A = sample_sparse(mod)

ei = RSpectra::eigs(A=A, k = 5)
eiL = A %>% glaplacian(regularize = T) %>% RSpectra::eigs(k = 5)


# make data nice for plotting (ignore this)
datA = tibble(first_eigenvector = ei$vectors[,1],
              second_eigenvector = ei$vectors[,2],
              version = "A",
              `z(i)` = as.character(apply(mod$X,1,which.max)))

datL = tibble(first_eigenvector = eiL$vectors[,1],
              second_eigenvector = eiL$vectors[,2],
              version = "L",
              `z(i)` = as.character(apply(mod$X,1,which.max)))
dat = rbind(datA,datL)

ggplot(dat, aes(x = first_eigenvector,
                y = second_eigenvector,
                color = `z(i)`)) + geom_point() +facet_wrap(~version,scales = "free")

