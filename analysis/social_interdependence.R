# load the data
create_network <- function(project){
  
  dat <- read_seqdata_for_network(paste0("/Users/aron/git/4cases_routines/data/activity-", project, ".txt"), '2012-01-06', '2013-01-06')
  
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

# At this point we need to extract an SNA-statistic for each actor, that we can match with the list of actors associated with each pull request.
# degree_list <- igraph::degree(g)

# Calculate degrees for each pull request
# pr_degrees <- rapply(filename_lists3, function(x) ifelse(x %in% names(degree_list), degree_list[x], x), how='replace')

# output_list <- vector(mode = "double", length = length(pr_degrees))
# for (i in 1:length(pr_degrees)){
#   ifelse(is.null(output_list[i]),output_list[i] <- NA,try_default(output_list[i] <- sum(pr_degrees[[i]]), default = NA))
# }

# names(output_list) <- names(pr_degrees)

# pr_degrees_sums <- t(as.data.frame(lapply(output_list, sum)))
# pr_degrees_sums[pr_degrees_sums == 0] <- NA

rubinius_network <- create_network("rubinius-rubinius")
rails_network <- create_network("rails-rails")
django_network <- create_network("django-django")
bootstrap_network <- create_network("twitter-bootstrap")

modularity(walktrap.community(rails_network))
modularity(walktrap.community(rubinius_network))
modularity(walktrap.community(django_network))
modularity(walktrap.community(bootstrap_network))

centralization.betweenness(rubinius_network)$centralization
centralization.betweenness(rails_network)$centralization
centralization.betweenness(bootstrap_network)$centralization
centralization.betweenness(django_network)$centralization

# Plots

plot(django_network,				#the graph to be plotted
     layout=layout.fruchterman.reingold,	# the layout method. see the igraph documentation for details
     vertex.label.dist=0.5,			#puts the name labels slightly off the dots
     vertex.frame.color='blue', 		#the color of the border of the dots 
     vertex.label.color='black',		#the color of the name labels
)

library(intergraph)

plot.network(asNetwork(django_network), 
             vertex.col="#FF000020", 
             vertex.border="#FF000020", 
             edge.col="#FFFFFF")

plot.network(asNetwork(rubinius_network), 
             vertex.col="#FF000020", 
             vertex.border="#FF000020", 
             edge.col="#FFFFFF")