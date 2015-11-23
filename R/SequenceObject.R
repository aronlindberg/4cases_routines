# Constructor function for sequences withOUT timestamps
SequenceObject <- function(data, startdate, stopdate, exclude = c(), type){
  
  # basic reformatting
  data <- read.table(data, sep = ",", header = TRUE)
  data <- subset(data, select = c("pull_req_id", "action", "created_at"))
  
  # exclude all activity types which are not wanted in the data
  data <- subset(data,!action %in% exclude)
  
  # select only data between startdate and stopdate
  colnames(data) <- c("id", "event", "time")
  data <- sqldf(paste0("SELECT * FROM data WHERE strftime('%Y-%m-%d', time,
                       'unixepoch', 'localtime') >= '",startdate,"' AND strftime('%Y-%m-%d', time,
                       'unixepoch', 'localtime') <= '",stopdate,"'"))
  
  # One type of output for TraMineR STS format
  if (type=="STS") {
    data.split <- split(data$event, data$id)
    list.to.df <- function(arg.list) {
      max.len  <- max(sapply(arg.list, length))
      arg.list <- lapply(arg.list, `length<-`, max.len)
      as.data.frame(arg.list)
    }
    data <- list.to.df(data.split)
    data <- t(data)
    (data)
    
    # Another type of output for TraMineR TSE format
    } else {
      data$end <- data$time
      data <- data[with(data, order(time)), ]
      data$time <- match( data$time , unique( data$time ) )
      data$end <- match( data$end , unique( data$end ) )
      slmax <- max(data$time)
      (data)
    }
}
