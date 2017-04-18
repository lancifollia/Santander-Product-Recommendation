# Logic to find users that are probably related (similar age, income, province 
# and joining date)

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

# Combine the train and test records
setkey(train, ncodpers)

# List income by count
incomeByPersonProvCount <- train[!is.na(renta),
                                 .(N = .N,
                                   npers = length(unique(ncodpers)),
                                   nbProv = length(unique(cod_prov))
                                 ), renta]
consideredFamilyIncomes <-
  incomeByPersonProvCount[npers>1 & npers < 7 & nbProv==1,
                          .(renta, familySize = npers)]
consideredFamilyIncomes[, familyId := 1:nrow(consideredFamilyIncomes)]

# Extract the users that belong to one of the extracted families
familyUsers <- sort(unique(train[renta %in% consideredFamilyIncomes$renta,
                                 ncodpers]))

# Store the family incomes
saveRDS(consideredFamilyIncomes, file.path(getwd(), targetDate, "FeatureEngineering",
                                           "familyIncomes.rds"))