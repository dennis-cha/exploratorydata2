# Load packages
library(dplyr)
library(tidyr)

# Download and unzip
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip")

# Load activity labels + features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data with mean or std
featuresTarget <- grep("(.*)mean|(.*)std", features[,2])
featuresTargetVariable <- features[featuresTarget,2]

# Load the datasets for Train data
trainSet <- read.table("UCI HAR Dataset/train/X_train.txt")[,featuresTarget]
trainLabels <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainLabels, trainSet)

# Load the datasets for Test data
testSet <- read.table("UCI HAR Dataset/test/X_test.txt")[,featuresTarget]
testLabels <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testLabels, testSet)

# Merge datasets and add labels with appropriate descriptions
allData <- rbind(train, test)
featuresTargetVariable <- gsub("\\(", "", featuresTargetVariable)
featuresTargetVariable <- gsub("\\)", "", featuresTargetVariable)
colnames(allData) <- c("Subject", "Activity", featuresTargetVariable)
allData$Activity <- factor(allData$Activity, levels = activityLabels[,1], labels = activityLabels[,2])

# Create a tbl grouped by subject and activity
avgSummary <-
    tbl_df(allData) %>%
    group_by(Subject, Activity) %>%
    summarize_all(mean) %>%
    arrange(Subject, Activity)
    
# Output into a txt file
write.table(avgSummary, "tidy.txt", row.names = FALSE, quote = FALSE)