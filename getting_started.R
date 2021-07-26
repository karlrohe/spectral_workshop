## If you don't already have R installed, install R
# https://www.r-project.org


## We will use a number of R packages, which are listed below.
## if any libraries ask you to install/update other packages,
##  try installing/updating all of them.
## if anything asks if you want to compile the code (or something)
##  say no.


## Matrix is for handling sparse matrices
install.packages("Matrix")
library(Matrix)


## fastRG  is to simulate sparse graphs quickly.
## https://github.com/RoheLab/fastRG
install.packages("devtools")
devtools::install_github("RoheLab/fastRG")
library(fastRG)

## RSpectra is to compute eigen quickly
install.packages("RSpectra")
library(RSpectra)

## gdim is to estimate the number of latent dimensions.
devtools::install_github("RoheLab/gdim")
library(gdim)

## vsp is going to do all the stuff we want
remotes::install_github("RoheLab/vsp")
library(vsp)



## tidyverse is for plotting and stuff.
## This one might take awhile...
install.packages("tidyverse")
library(tidyverse)
