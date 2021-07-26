library(Matrix)
library(fastRG)
library(RSpectra)
library(tidyverse)
library(vsp)
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


#### Simulation....
###  Compute the varimax rotation of the top two eigenvectors:
ei = RSpectra::eigs(A=A, k = 10, which = "LA")

vm = varimax(ei$vectors[,1:2], normalize = F)
zhat = ei$vectors[,1:2]%*%vm$rotmat

# little cheat: make them skew positive
zhat  = zhat %*% diag(apply(zhat,2,function(x)sign(sum(x^3))))


# make data nice for plotting...
dat = tibble(first_factor = zhat[,1],
             second_factor = zhat[,2],
             theta = thetas,
             `z(i)` = as.character(apply(mod$X,1,which.max)))

ggplot(dat, aes(x = first_factor,
                y = second_factor,
                color = `z(i)`)) + geom_point()




### Let's see whether Varimax aligns the data examples to the axes...
# load(file = "data/journal-journal_graph.RData")
# load(file = "data/factor_analysis_abstracts.RData")
# load(file = "data/graph_twitter.RData")
# fa_journal = vsp(A_journal, rank = 10,scale = T)
# fa_fa = vsp(A_fa, rank = 10, scale = T)  # this takes ~1 minute.
# fa_twitter =  vsp(graph_twitter, rank = 10, scale = T)

fa_journal$Z %>% as.matrix %>% my_pairs(1000)
fa_fa$Z %>% as.matrix %>% my_pairs(10000)
fa_twitter$Z %>% as.matrix %>% my_pairs(1000)
