# Getting and Cleaning Data Course Project

library(dplyr)

# Set the working directory
#setwd('C:/Sakthi/Study Materials/Data Science/Course - 3')

# Downloading data 
if(!file.exists("./CourseProject")){dir.create("./CourseProject")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./CourseProject/Dataset.zip")

# UnZipping the downloaded file
unzip(zipfile="courseProject/Dataset.zip",exdir="./courseProject")


# Reading trainings tables:
training_x <- read.table("./CourseProject/UCI HAR Dataset/train/X_train.txt")
training_y <- read.table("./CourseProject/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./CourseProject/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
testData_x <- read.table("./CourseProject/UCI HAR Dataset/test/X_test.txt")
testData_y <- read.table("./CourseProject/UCI HAR Dataset/test/y_test.txt")
subject_testData <- read.table("./CourseProject/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
variable_names <- read.table('./CourseProject/UCI HAR Dataset/features.txt')

# Reading activity labels:
activity_labels  <- read.table('./CourseProject/UCI HAR Dataset/activity_labels.txt')

# Setting the columns  
colnames(training_x) <- featuresData[,2] 
colnames(training_y) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(testData_x) <- featuresData[,2] 
colnames(testData_y) <- "activityId"
colnames(subject_testData) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# 1. Merges the training and the test sets to create one data set.

X_total <- rbind(training_x, testData_x)
Y_total <- rbind(training_y, testData_y)
Sub_total <- rbind(subject_train, subject_testData)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- variable_names[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)
