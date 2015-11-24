# Construct objects
django_TSE <- SequenceObject("/Users/aron/git/github-activities/data/activity-django-django.txt", '2012-01-06', '2013-01-06', type = "TSE", exclude = c("synchronize", "subscribed", "unsubscribed", "head_ref_cleaned", "head_ref_deleted", "head_ref_restored"))

rails_TSE <- SequenceObject("/Users/aron/git/github-activities/data/activity-rails-rails.txt", '2012-01-06', '2013-01-06', type = "TSE", exclude = c("synchronize", "subscribed", "unsubscribed", "head_ref_cleaned", "head_ref_deleted", "head_ref_restored"))

rubinius_TSE <- SequenceObject("/Users/aron/git/github-activities/data/activity-rubinius-rubinius.txt", '2012-01-06', '2013-01-06', type = "TSE", exclude = c("synchronize", "subscribed", "unsubscribed", "head_ref_cleaned", "head_ref_deleted", "head_ref_restored"))

bootstrap_TSE <- SequenceObject("/Users/aron/git/github-activities/data/activity-twitter-bootstrap.txt", '2012-01-06', '2013-01-06', type = "TSE", exclude = c("synchronize", "subscribed", "unsubscribed", "head_ref_cleaned", "head_ref_deleted", "head_ref_restored"))

django_TSE <-  django_TSE[django_TSE$id %in% django_include,]
rails_TSE <- rails_TSE[rails_TSE$id %in% rails_include,]
rubinius_TSE <- rubinius_TSE[rubinius_TSE$id %in% rubinius_include,]
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