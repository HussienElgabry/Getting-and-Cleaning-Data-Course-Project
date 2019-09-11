
library(plyr)
library(knitr)

# Get the test data
subjectTest <- read.table('UCI HAR Dataset/test/subject_test.txt')
xTest       <- read.table('UCI HAR Dataset/test/x_test.txt')
yTest       <- read.table('UCI HAR Dataset/test/y_test.txt')

#Get training data
subjectTrain <- read.table('UCI HAR Dataset/train/subject_train.txt')
xTrain       <- read.table('UCI HAR Dataset/train/x_train.txt')
yTrain       <- read.table('UCI HAR Dataset/train/y_train.txt')


#  1) Merges the training and the test sets to create one data set
fullData <- rbind(
    cbind(subjectTest, xTest, yTest),
    cbind(subjectTrain, xTrain, yTrain)
)

# Get the activity labels
activityLabels <- as.character(read.table("UCI HAR Dataset/activity_labels.txt")[,2])

#Get the features
features <- as.character(read.table("UCI HAR Dataset/features.txt")[,2])

#  2) Extracts only the measurements on the mean and standard deviation for each measurement
fullData <- fullData[, grepl("subject|activity|mean|std", colnames(fullData))]


#  3) Uses descriptive activity names to name the activities in the data set
colnames(fullData) <- c("subjectID", features, "activityID")

#  4) Appropriately label the data set with descriptive activity names
names(fullData) <- gsub("^t", "time", names(fullData))
names(fullData) <- gsub("^f", "frequency", names(fullData))
names(fullData) <- gsub("Acc", "Accelerometer", names(fullData))
names(fullData) <- gsub("Gyro", "Gyroscope", names(fullData))
names(fullData) <- gsub("Mag", "Magnitude", names(fullData))
names(fullData) <- gsub("BodyBody", "Body", names(fullData))

#  5) From the data set in step 4, creates a second, independent tidy
#     data set with the average of each variable for each activity and each subject.
newData <- aggregate(. ~subject + activity, fullData, mean)
newData <- newData[order(newData$subject, newData$activity),]
write.table(newData, file = "tidydata.txt", row.name = FALSE)

# A code book that describes the variables, the data,
# and any transformations or work that you performed to
# clean up the data called CodeBook.m
knit2html("codebook.Rmd")
