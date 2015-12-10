sna_stat_per_PR <- function(data, stat){
#stat = "graph.density"; data = rubinius  
  data_split <- split(data, data$id)
  
  actors_per_PR <- list()
  for (i in 1:length(data_split)){
    actors_per_PR[i] <- list(as.character(data_split[[i]]$actor))
  }
  
  actors_per_PR <- lapply(actors_per_PR, unlist)
  
  combine_edge_lists <- function(data){
    try_default(t(combn(data, 2)), default = NULL)
  }
  
  actor_lists_merged <- lapply(actors_per_PR, combine_edge_lists)
#  browser()
  
  actor_graphs <- list()
  for (i in 1:length(actor_lists_merged)){
    merged <- actor_lists_merged[[i]]
    graph <- NA
    if (!is.null(merged)) {
      graph <- graph.edgelist(merged)
    }
    actor_graphs[[i]] <- graph
  }

  output <- list()
  browser()
  print(paste0("length of actor_graphs = ", length(actor_graphs)))
  for (i in 1:length(actor_graphs)){
    command = parse(text=paste0("igraph::", stat, "(actor_lists_merged[[i]])"))
    print(class(actor_lists_merged[[i]]))
#    tryNULL(eval(command))
    print(command)
    output[[i]] <- tryNULL(eval(command))
    }
#  output[[length(unique(data$id))]] <- NA
  print("goodbye")
  
  print(output)
  for (i in 1:length(output)){
    print(i)
    print(output[[i]])
    if(is.null(output[[i]]))
      output[[i]] <- 0
    if(is.na(output[[i]]))
      output[[i]] <- 0
  }
  
  print("blah")
  
  output <- unlist(output)
  output <- as.data.frame(output)
  
  rownames(output) <- unique(data$id)
  rownames(output) <- gsub(rownames(output), pattern = "X", replacement = "")
  colnames(output) <- c("social_complexity")
  output$social_complexity <- as.numeric(output$social_complexity)
  (output$social_complexity)
}
