# Creating the dataset
django_sequences <- read_seqdata_notime("/Users/aron/git/github-activities/data/activity-django-django.txt", '2012-01-06', '2013-01-06')
rails_sequences <- read_seqdata_notime("/Users/aron/git/github-activities/data/activity-rails-rails.txt", '2012-01-06', '2013-01-06')
rubinius_sequences <- read_seqdata_notime("/Users/aron/git/github-activities/data/activity-rubinius-rubinius.txt", '2012-01-06', '2013-01-06')
bootstrap_sequences <- read_seqdata_notime("/Users/aron/git/github-activities/data/activity-twitter-bootstrap.txt", '2012-01-06', '2013-01-06')

# Subsetting by "approved" PR ids

# Delete "X" from rownames
rownames(django_sequences) <- gsub("^X", "", rownames(django_sequences))
rownames(rails_sequences) <- gsub("^X", "", rownames(rails_sequences))
rownames(rubinius_sequences) <- gsub("^X", "", rownames(rubinius_sequences))
rownames(bootstrap_sequences) <- gsub("^X", "", rownames(bootstrap_sequences))

# Load include-list & # generate a subset object
django_include <- read.csv("/Users/aron/dropbox/Thesis/3-Variance/api_queries/django_include.csv", header = FALSE)
django_include <- c(do.call("cbind", django_include)) 
django_include <- as.character(django_include)
django_sequences <- django_sequences[rownames(django_sequences) %in% django_include,]

rails_include <- read.csv("/Users/aron/dropbox/Thesis/3-Variance/api_queries/rails_include.csv", header = FALSE)
rails_include <- c(do.call("cbind", rails_include)) 
rails_include <- as.character(rails_include)
rails_sequences <- rails_sequences[rownames(rails_sequences) %in% rails_include,]

rubinius_include <- read.csv("/Users/aron/dropbox/Thesis/3-Variance/api_queries/rubinius_include.csv", header = FALSE)
rubinius_include <- c(do.call("cbind", rubinius_include)) 
rubinius_include <- as.character(rubinius_include)
rubinius_sequences <- rubinius_sequences[rownames(rubinius_sequences) %in% rubinius_include,]

bootstrap_include <- read.csv("/Users/aron/dropbox/Thesis/3-Variance/api_queries/bootstrap_include.csv", header = FALSE)
bootstrap_include <- c(do.call("cbind", bootstrap_include)) 
bootstrap_include <- as.character(bootstrap_include)
bootstrap_sequences <- bootstrap_sequences[rownames(bootstrap_sequences) %in% bootstrap_include,]
