# Load packages
library(TraMineR)
library(cluster)
library(stringr) # for the find/replace function in read_seqdata_notime
library(network)
library(sna)
library(sqldf)
library(WeightedCluster)
library(knitr)
library(irr)

# Winston says to use an R project instead so I can use a relative path
setwd("/Users/aron/git/4cases_routines/analysis")

# source functions
source("/Users/aron/git/rubinius_routines/R/functions.R")

django_TSE <- read_seqdata_for_network("/Users/aron/git/github-activities/data/activity-django-django.txt", '2012-01-06', '2013-01-06')
rails_TSE <- read_seqdata_for_network("/Users/aron/git/github-activities/data/activity-rails-rails.txt", '2012-01-06', '2013-01-06')
rubinius_TSE <- read_seqdata_for_network("/Users/aron/git/github-activities/data/activity-rubinius-rubinius.txt", '2012-01-06', '2013-01-06')
bootstrap_TSE <- read_seqdata_for_network("/Users/aron/git/github-activities/data/activity-twitter-bootstrap.txt", '2012-01-06', '2013-01-06')

# Load include-list & # generate a subset object
django_include <- read.csv("/Users/aron/dropbox/Thesis/3-Variance/api_queries/django_include.csv", header = FALSE)
django_include <- c(do.call("cbind", django_include)) 
django_include <- as.character(django_include)
django_TSE <- django_TSE[django_TSE$id %in% django_include,]

rails_include <- read.csv("/Users/aron/dropbox/Thesis/3-Variance/api_queries/rails_include.csv", header = FALSE)
rails_include <- c(do.call("cbind", rails_include)) 
rails_include <- as.character(rails_include)
rails_TSE <- rails_TSE[rails_TSE$id %in% rails_include,]

rubinius_include <- read.csv("/Users/aron/dropbox/Thesis/3-Variance/api_queries/rubinius_include.csv", header = FALSE)
rubinius_include <- c(do.call("cbind", rubinius_include)) 
rubinius_include <- as.character(rubinius_include)
rubinius_TSE <- rubinius_TSE[rubinius_TSE$id %in% rubinius_include,]

bootstrap_include <- read.csv("/Users/aron/dropbox/Thesis/3-Variance/api_queries/bootstrap_include.csv", header = FALSE)
bootstrap_include <- c(do.call("cbind", bootstrap_include)) 
bootstrap_include <- as.character(bootstrap_include)
bootstrap_TSE <- bootstrap_TSE[bootstrap_TSE$id %in% bootstrap_include,]

# Calculate sequential variations
django_sequential_variation <- extract_degrees(django_TSE)
rails_sequential_variation <- extract_degrees(rails_TSE)
rubinius_sequential_variation <- extract_degrees(rubinius_TSE)
bootstrap_sequential_variation <- extract_degrees(bootstrap_TSE)

# Need to adjust these for length
mean(django_sequential_variation/seqlength(seqdef(django_sequences))) # This seems to be the highest due to a lot of sequences with 3 nodes and 4 transitions (4/3=1.333)
mean(rails_sequential_variation/seqlength(seqdef(rails_sequences)))
mean(rubinius_sequential_variation/seqlength(seqdef(rubinius_sequences)))
mean(bootstrap_sequential_variation/seqlength(seqdef(bootstrap_sequences)))

# It seems as if turbulence or my adjusted turbulence measure shows the patterns clearly.
mean(seqST(seqdef(django_sequences)))
mean(seqST(seqdef(rails_sequences)))
mean(seqST(seqdef(rubinius_sequences)))
mean(seqST(seqdef(bootstrap_sequences)))

# Now, extract the 100 most turbulent sequences and the 100 least turbulent sequences for each project, and then do OM distances between these, normalized by length
rails_object <- cbind(seqdef(rails_sequences), seqST(seqdef(rails_sequences)))

rails_top_turbulence <- seqdef(head(rails_object[with(rails_object, order(-Turbulence)), ], 100)[,1:114])
rails_bottom_turbulence <- seqdef(head(rails_object[with(rails_object, order(Turbulence)), ], 100)[,1:114])

dissvar(distance_matrix(rails_top_turbulence))
dissvar(distance_matrix(rails_bottom_turbulence))