# Get and Clean Data Peer Graded Assignment Week 4 
# Author Farhan

# Instructions for assignment

# Here are the data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following.

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names (make them more understandable).
# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
# Good luck!


# WD i.e. file location

setwd("C:/Users/Farhan/Documents/R/Data science/Get and Clean Data/UCI HAR Dataset/")

# Merges the training and the test sets to create one data set.

# Read the following: Data General and Training

features        <- read.table("./features.txt",header=FALSE)
activityLabel   <- read.table("./activity_labels.txt",header=FALSE)
subjectTrain    <- read.table("./train/subject_train.txt", header=FALSE)
xTrain          <- read.table("./train/X_train.txt", header=FALSE)
yTrain          <- read.table("./train/y_train.txt", header=FALSE)


# Give the data above appropriate column names

colnames(activityLabel)<-c("activityId","activityType")
colnames(subjectTrain) <- "subId"
colnames(yTrain) <- "activityId"
colnames(xTrain) <- features[,2]


# Merge your training data

trainData <- cbind(yTrain,subjectTrain,xTrain)

# Reading your test Data

subjectTest   <- read.table("./test/subject_test.txt", header=FALSE)
yTest         <- read.table("./test/y_test.txt", header=FALSE)
xTest         <- read.table("./test/X_test.txt", header=FALSE)


# Give the data appropriate column names

colnames(subjectTest) <- "subId"
colnames(xTest) <- features[,2]
colnames(yTest) <- "activityId"

# Merge your test Data
testData <- cbind(yTest,subjectTest,xTest)


# Final Merge Data file

finalData <- rbind(trainData,testData)


# Create a vector with a column name

colNames <- colnames(finalData);



# Extracts only the measurements on the mean and standard deviation for each measurement.

data_mean_std <-finalData[,grepl("mean|std|subject|activityId",colnames(finalData))]


# Uses descriptive activity names to name the activities in the data set

library(plyr)
data_mean_std <- join(data_mean_std, activityLabel, by = "activityId", match = "first")
data_mean_std <- data_mean_std[,-1]

# Appropriately labels the data set with descriptive variable names.
# Remove parenthesis

names(data_mean_std) <- gsub("\\(|\\)", "", names(data_mean_std), perl  = TRUE)


# correct syntax in names where applicable

names(data_mean_std) <- make.names(names(data_mean_std))


# Give detailed and descriptive names for easier reading

names(data_mean_std) <- gsub("Acc", "Acceleration", names(data_mean_std))
names(data_mean_std) <- gsub("^t", "Time", names(data_mean_std))
names(data_mean_std) <- gsub("^f", "Frequency", names(data_mean_std))
names(data_mean_std) <- gsub("BodyBody", "Body", names(data_mean_std))
names(data_mean_std) <- gsub("mean", "Mean", names(data_mean_std))
names(data_mean_std) <- gsub("std", "Std", names(data_mean_std))
names(data_mean_std) <- gsub("Freq", "Frequency", names(data_mean_std))
names(data_mean_std) <- gsub("Mag", "Magnitude", names(data_mean_std))


# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

write.table(names(data_mean_std), "tidydata.txt", row.names = FALSE, quote = FALSE)