# Extract the clients that have at least one positive product flank in the
# Jan 15 - May 16 period

# Clear the workspace
rm(list=ls())

# Set working directory
setwd("/Users/sjkim/kaggle/santander-product-recommendation")

# Load the required libraries
library(data.table)
library(bit64)

# Target date
targetDate <- "15-04-2017"


###################################################################

# Read in the raw cleaned data
train <- readRDS(paste0("train.rds"))

# Extract clients that have any positive flanks
posFlankClients <- integer(0)
daysDiff <- diff(train$fecha_dato)
samePersonConsecutive <- (diff(train$ncodpers)) == 0 & (daysDiff>0) &
  (daysDiff < 32)
for(trainCol in 25:48){
  posFlankIds <- 1 + which(samePersonConsecutive &
                             (train[[trainCol]][-nrow(train)] == 0) &
                             (train[[trainCol]][-1] == 1))
  posFlankClients <- unique(c(posFlankClients, train$ncodpers[posFlankIds]))
}

# Store clients with at least one positive flank
posFlankClients <- sort(posFlankClients)
saveRDS(posFlankClients, file.path(getwd(), "Feature engineering", targetDate,
                                   "positive flank clients.rds"))