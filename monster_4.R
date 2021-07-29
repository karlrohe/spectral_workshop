library(Matrix)
library(fastRG)
library(RSpectra)
library(tidyverse)
library(vsp)
library(gdim)
source("src.R")



# get the simulated graph again...
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


simple_cv  = gdim::eigcv(A, k_max = 20)
plot(simple_cv)


# "harder simulation"

n = 10000
thetas = rexp(n)
B = matrix(c(2,1,1,2), nrow = 2)

# this parameterizes a dc-sbm
mod = fastRG::dcsbm(theta = thetas,
                    B = B,
                    expected_degree = 10)
# this simulates a sparse adjacency matrix:
A = sample_sparse(mod)
hard_cv = gdim::eigcv(A, k_max = 20)
plot(hard_cv)


# # compare to sample eigenvalues...
# eigs(A, 20, which = "LA")$val[1:7] %>% plot()
# # you can kinda see it in the 2nd eigenvalue of the normalized and regularized version:
# eigs(glaplacian(A), 20, which = "LM")$val[1:7] %>% plot()
# eigs(glaplacian(A), 20, which = "LM")$val[2:7] %>% plot()


# load(file = "data/journal-journal_graph.RData")
load(file = "data/factor_analysis_abstracts.RData")
# load(file = "data/graph_twitter.RData")

cv_fa = gdim::eigcv(A_fa, k_max = 10, bootstrap = 1)
plot(cv_fa)


# What about these...
# A_journal
# A_twitter
