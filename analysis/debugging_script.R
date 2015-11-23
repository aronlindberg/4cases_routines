rubinius <- SequenceObject("/Users/aron/git/github-activities/data/activity-rubinius-rubinius.txt", '2012-01-06', '2013-01-06', type = "TSE", exclude = c("synchronize", "subscribed", "unsubscribed", "head_ref_cleaned", "head_ref_deleted", "head_ref_restored"))

dat <- read_seqdata_for_network("/Users/aron/git/github-activities/data/activity-rubinius-rubinius.txt", '2012-01-06', '2013-01-06')

sna_stat_per_PR(stat = "graph.density", data = rubinius)