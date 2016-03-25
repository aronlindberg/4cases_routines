setwd("/Users/aron/git/4cases_routines/")

# Load packages
required_packages <- c('TraMineR','cluster','stringr', 'network', 'sna', 'sqldf',
                       'WeightedCluster', 'knitr', 'irr', 'stringr', 'plyr', 'igraph', 'RColorBrewer')
new_packages <- required_packages[!(required_packages %in% installed.packages()[,'Package'])]
if(length(new_packages)) install.packages(new_packages)
lapply(required_packages, library, character.only = TRUE)

# Run scripts
script_list <- list("/Users/aron/git/generic_oss_functions/R/functions.R", "R/SequenceObject.R", "R/sna_stat_per_PR.R", "analysis/routine_variation.R")
for (i in 1:length(script_list)){
  try(source(script_list[[i]], chdir = TRUE))
