# Logic to create a mapping from the categorical levels to corresponding 
# numeric levels for all categorical features
# This mapping results in a uniform mapping accross train and test features

# Clear the workspace
rm(list=ls())

# Set working directory
setwd("/Users/sjkim/kaggle/santander-product-recommendation/FeatureEngineering")

# Load the required libraries
library(data.table)
library(bit64)

# Target date
targetDate <- "15-04-2017"


###################################################################

# Read in the raw cleaned data and general feature files
train <- readRDS(paste0("../train.rds"))
test <- readRDS(paste0("../test.rds"))

# Combine the train and test records
rawData <- rbindlist(list(train, test), fill=TRUE)
setkey(rawData, ncodpers)

# Load the features files
trainFeatures <- readRDS(file.path(getwd(), targetDate,
                                   "trainSmallOrdered/featuresCat.rds"))
testFeatures <- readRDS(file.path(getwd(), targetDate, "testFeaturesCat.rds"))
allFeatures <- rbindlist(list(trainFeatures, testFeatures), fill=TRUE)

# Map the features to the values of a raw data column
mapping <- matrix(c("employeeIndex", "ind_empleado",
                    "lastCountry", "pais_residencia",
                    "firstCountry", "pais_residencia",
                    "firstGender", "sexo",
                    "lastCustType", "tiprel_1mes",
                    "firstCustType", "tiprel_1mes",
                    "previousCustType", "tiprel_1mes",
                    "lastResidentType", "indresi",
                    "previousResidentType", "indresi",
                    "lastForeignerType", "indext",
                    "previousForeignType", "indext",
                    "lastSpouseStatus", "conyuemp",
                    "lastEntryStatus", "canal_entrada",
                    "previousEntryType", "canal_entrada",
                    "lastDeceasedStatus", "indfall",
                    "lastSegment", "segmento",
                    "previousSegmentType", "segmento"),
                  ncol = 2, byrow = TRUE)
nbFeatures <- nrow(mapping)

# Create the mapping structure
# A list where each element contains a separate list with the mapping for 
# that column
# The mapping structure is a list of two same length vectors: key and value
featureMapping <- vector(mode = "list", length = nbFeatures)
names(featureMapping) <- mapping[,1]
for(i in 1:nbFeatures){
  rawDataCol <- mapping[i,2]
  
  # Use alphabetically ordered mapping for now
  catVals <- sort(unique(rawData[[rawDataCol]]))
  catMap <- as.integer(factor(catVals))
  
  # Add missing mapping for firstCustType
  if(rawDataCol=="tiprel_1mes"){
    catVals[1] <- "missing"
  }
  
  # Verify that all features are mapped
  if(!all(unique(allFeatures[[mapping[i,1]]][
    !is.na(allFeatures[[mapping[i,1]]])]) %in% catVals)) browser()
  
  if(rawDataCol == "canal_entrada") browser()
  
  # Add the mapping to the mapping list
  featureMapping[[i]] <- list(keys=catVals, values=catMap)
}

# # Store the feature mapping
# saveRDS(featureMapping, file.path(getwd(), targetDate, "feature mapping.rds"))
