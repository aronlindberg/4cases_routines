# Load packages
required_packages <- c('TraMineR','cluster','stringr', 'network', 'sna', 'sqldf',
                       'WeightedCluster', 'knitr', 'irr', 'stringr', 'plyr', 'igraph')
new_packages <- required_packages[!(required_packages %in% installed.packages()[,'Package'])]
if(length(new_packages)) install.packages(new_packages)
lapply(required_packages, library, character.only = TRUE)