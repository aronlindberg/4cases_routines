sna_stat_per_PR <- function(data, stat){
  
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
  browser()
  
  actor_graphs <- list()
  for (i in 1:length(actor_lists_merged)){
    actor_graphs[[i]] <- tryNULL(graph.edgelist(actor_lists_merged[[i]]))
      }
  actor_graphs[[length(unique(data$id))]] <- NA
  
  output <- list()
  for (i in 1:length(actor_graphs)){
    tryNULL(output[[i]] <- eval(parse(text=paste0("igraph::", stat, "(actor_lists_merged[[i]])"))))
    }
  output[[length(unique(data$id))]] <- NA
  
  for (i in 1:length(output)){
    if(is.null(output[[i]]))
      output[[i]] <- 0
    if(is.na(output[[i]]))
      output[[i]] <- 0
  }
  
  output <- unlist(output)
  output <- as.data.frame(output)
  
  rownames(output) <- unique(data$id)
  rownames(output) <- gsub(rownames(output), pattern = "X", replacement = "")
  colnames(output) <- c("social_complexity")
  output$social_complexity <- as.numeric(output$social_complexity)
  (output$social_complexity)
}
