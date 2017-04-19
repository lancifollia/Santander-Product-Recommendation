# Use to generate the random first/second level folds

# Clear the workspace
rm(list=ls())

# Set working directory
setwd("/Users/sjkim/kaggle/santander-product-recommendation")

# Load the required libraries
library(data.table)

# Set the random seed in order to obtain reproducible results
set.seed(14) # Used to generate the first level folds
# set.seed(23) # Used to generate the second level folds

# First level K in K-fold cross validation
K1 <- 5
# K1 <- 10

# Target date
targetDate <- "15-04-2017"


#####################################################################

# Create the target folder if it does not exist yet
targetFolder <- file.path(getwd(), "SecondLevelLearners", targetDate)
dir.create(targetFolder, showWarnings = FALSE)

# Read the train data
train <- readRDS(file.path(getwd(), "train.rds"))

# Extract the unique ncodpers
uniqueNcodpers <- sort(unique(train$ncodpers))
nbNcodpers <- length(uniqueNcodpers)

# Generate the first level folds
firstFolds <- sample(cut(seq(1, nbNcodpers), breaks = K1, labels = FALSE))
firstFoldIds <- list()
for(j in 1:K1){
  firstFoldIds <- c(firstFoldIds, list(uniqueNcodpers[firstFolds==j]))
}

# Save the folds information
savePath <- file.path(targetFolder, paste("firstLevelNcodpers", K1,
                                          "folds.rds"))
saveRDS(firstFoldIds, savePath)
