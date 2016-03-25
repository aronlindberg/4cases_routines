rubinius.c <- clustering(rubinius_STS)
rubinius.dist <- distance_matrix(rubinius_STS)
rubinius.qc <- as.clustrange(rubinius.c, rubinius.dist, ncluster = 10, stat = c("PBC", "HG", "ASW"))

rails.c <- clustering(rails_STS)
rails.dist <- distance_matrix(rails_STS)
rails.qc <- as.clustrange(rails.c, rails.dist, ncluster = 10, stat = c("PBC", "HG", "ASW"))

django.c <- clustering(django_STS)
django.dist <- distance_matrix(django_STS)
django.qc <- as.clustrange(django.c, django.dist, ncluster = 10, stat = c("PBC", "HG", "ASW"))

bootstrap.c <- clustering(bootstrap_STS)
bootstrap.dist <- distance_matrix(bootstrap_STS)
bootstrap.qc <- as.clustrange(bootstrap.c, bootstrap.dist, ncluster = 10, stat = c("PBC", "HG", "ASW"))

plot(rubinius.qc, norm = "zscore", stat = c("PBC", "HG", "ASW")) # 2 clusters
plot(rails.qc, norm = "zscore", stat = c("PBC", "HG", "ASW")) # 2 clusters
plot(django.qc, norm = "zscore", stat = c("PBC", "HG", "ASW")) # 6 clusters
plot(bootstrap.qc, norm = "zscore", stat = c("PBC", "HG", "ASW")) # 3 clusters

# Function
### !!!!! DEBUG THIS, RETURNS 194+128 SEQUENCES FOR RAILS, WHICH IS NOT ENOUGH
extract_cluster_sequences <- function(project, k){
  
  # Cut the tree at k clusters
  c <- cutree(eval(parse(text=paste0(project, ".c"))), k = k)
  
  # calculate means per group
  cent <- aggregate(eval(parse(text=paste0(project, ".dist")))~c, eval(parse(text=paste0(project, "_STS"))), mean)
  # pass as initial centers
  c.k <- kmeans(eval(parse(text=paste0(project, ".dist"))), cent[,-1])
  
  # Extract PR_Ids from data
  pr_ids <- attr(eval(parse(text=paste0(project, "_STS"))), "dimnames"[[1]])
  pr_ids <- pr_ids[[1]]
  pr_ids <- gsub(pr_ids, pattern = "X", replacement = "")
  
  # List pull request ids and their cluster memberships
  cluster_membership <- cbind(pr_ids, c.k$cluster) 
  cluster_membership <- as.data.frame(cluster_membership, stringsAsFactors = TRUE)
  cluster_membership[,2] <- as.numeric(cluster_membership[,2])
  cluster_membership[,1] <- as.numeric(str_replace_all(cluster_membership[,1], pattern = "X", replacement = ""))
  
  # Extract sequence objects based on the k-means clusters
  pr_ids_w_X <- attr(eval(parse(text=paste0(project, "_STS"))), "dimnames")[[1]]
  
  for (i in 1:k){
    assign(paste0("c", i, "_pr_ids"), subset(cluster_membership, cluster_membership[,2] == i)[,1])
    assign(paste0("c", i), subset(eval(parse(text=paste0(project, "_STS"))), as.integer(attr(rubinius_STS, "dimnames")[[1]]) %in% eval(parse(text=paste0("c", i, "_pr_ids")))))
  }
  
  output <- list()
  for (i in 1:k){
    output[[i]] <- eval(parse(text=paste0("c", i)))
  }
  (output)
}

# Extract lists of clusters for each
rubinius_clusters <- extract_cluster_sequences("rubinius", 2)
rails_clusters <- extract_cluster_sequences("rails", 2)
django_clusters <- extract_cluster_sequences("django", 6)
bootstrap_clusters <- extract_cluster_sequences("bootstrap", 3)

# Extract OM for each cluster
r.1.om <- seqdist(seqdef(rubinius_clusters[[1]]), method = "OM", indel = 2, sm = "CONSTANT")
r.2.om <- seqdist(seqdef(rubinius_clusters[[2]]), method = "OM", indel = 2, sm = "CONSTANT")

dissvar(r.1.om)
dissvar(r.2.om)
seqient(seqdef(rubinius_clusters[[1]])) %>% mean
seqient(seqdef(rubinius_clusters[[2]])) %>% mean
seqST(seqdef(rubinius_clusters[[1]])) %>% mean
seqST(seqdef(rubinius_clusters[[2]])) %>% mean

average_diss_per_sequence <- as.data.frame(rowMeans(distance_matrix(seqdef(rubinius_STS))))
rownames(average_diss_per_sequence) <- rownames(rubinius_STS)

average_diss_per_sequence[rownames(average_diss_per_sequence) %in% rownames(rc1),] %>% mean
average_diss_per_sequence[rownames(average_diss_per_sequence) %in% rownames(rc2),] %>% mean
average_diss_per_sequence[rownames(average_diss_per_sequence) %in% rownames(rc3),] %>% mean

rubinius_sequential_variation[rownames(rubinius_sequential_variation) %in% rownames(rc1)] %>% mean
rubinius_sequential_variation[rownames(rubinius_sequential_variation) %in% rownames(rc2)] %>% mean
rubinius_sequential_variation[rownames(rubinius_sequential_variation) %in% rownames(rc3)] %>% mean

seqstatf(seqdef(rubinius_clusters[[1]]))
seqstatf(seqdef(rubinius_clusters[[2]]))

seqlength(seqdef(rubinius_clusters[[1]])) %>% mean
seqlength(seqdef(rubinius_clusters[[2]])) %>% mean