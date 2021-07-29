
library(Matrix)
library(fastRG)
library(RSpectra)
library(tidyverse)
library(tidygraph)
library(vsp)
source("src.R")



### Draw an image of an adjacency matrix from DC-SBM

# this is a tiny example:
set.seed(1)
n = 200
thetas = rexp(n)
B = matrix(c(5,1,1,5), nrow = 2)

# this parameterizes a dc-sbm
mod = fastRG::dcsbm(theta = thetas,
                    B = B,
                    expected_degree = 100)
# this simulates a sparse adjacency matrix:
A = sample_sparse(mod)

image(A)





###  What are the top two eigenvectors of A?

ei = RSpectra::eigs(A=A, k = 10, which = "LA")

# make data nice for plotting (ignore this)
dat = tibble(first_eigenvector = ei$vectors[,1],
             second_eigenvector = ei$vectors[,2],
             `z(i)` = as.character(apply(mod$X,1,which.max)))

ggplot(dat, aes(x = first_eigenvector,
                y = second_eigenvector,
                color = `z(i)`)) + geom_point()


#  What do the leading eigenvectors of a "real graph" look like?

###########################
# Journal-Journal graph
###########################
load(file = "data/journal-journal_graph.RData")
dim(A_journal)
# I'm cheating in this next line... doing steps we haven't yet talked about
#    we will talk about them later, I PROMISE.
fa_journal = vsp(A_journal, rank = 10,scale = T)
u = fa_journal$u # these are the left singular vectors of the normalized/regularized adjacency

# it takes too long to plot all points... so just plot rows
#  with big elements.
my_pairs(u)

###########################
# Document-term graph of abstracts containing "factor analysis"
###########################

load(file = "data/factor_analysis_abstracts.RData")
dim(A_fa)
fa_fa = vsp(A_fa, rank = 10, scale = T)  # this takes ~1 minute.
u = fa_fa$u
my_pairs(u, n = 10000)

###########################
# Twitter following graph, sampled around
#   Hadley Wickam (creator of tidyverse / Chief Scientist @ Rstudio)
#   AND
#   Guido van Rossum (creator of Python)
###########################

load(file = "data/graph_twitter.RData")
graph_twitter # this thing is a "tidy graph" that contains both
# 1) the edge list (who follows who) and
# 2) lots of details about the nodes

fa_twitter =  vsp(graph_twitter, rank = 10, scale = T)

u = fa_twitter$v
my_pairs(u)
