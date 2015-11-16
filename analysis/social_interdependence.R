# load the data
create_network <- function(project){
  
  dat <- read_seqdata_for_network(paste0("/Users/aron/git/github-activities/data/activity-", project, ".txt"), '2012-01-06', '2013-01-06')
  
  dat_split <- split(dat, dat$id)
  
  actors_per_PR <- list()
  for (i in 1:length(dat_split)){
    actors_per_PR[i] <- list(as.character(dat_split[[i]]$actor))
  }
  
  actors_per_PR <- lapply(actors_per_PR, unlist)
  
  combine_edge_lists <- function(data){
    try_default(t(combn(data, 2)), default = NULL)
  }
  
  actor_lists_merged <- lapply(actors_per_PR, combine_edge_lists)
  
  # Create a network for the whole project
  edge_list <- do.call(rbind, actor_lists_merged)
  whole_network <- graph_from_edgelist(edge_list)
  (whole_network)
}

rubinius_network <- create_network("rubinius-rubinius")
rails_network <- create_network("rails-rails")
django_network <- create_network("django-django")
bootstrap_network <- create_network("twitter-bootstrap")

modularity(walktrap.community(rails_network))
modularity(walktrap.community(rubinius_network))
modularity(walktrap.community(django_network))
modularity(walktrap.community(bootstrap_network))
