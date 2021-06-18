## Download and load the package needed
install.packages("data.table")
library(data.table)

# Download the file and unzip
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "HARdataset.zip")

unzip("HARdataset.zip")

# Read the subject information and assign them to variables
subjtrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subjtest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Read the activity information and assign them to variables
activitytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
activitytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")

# Read the activity info and assign them to variables
train <- read.table("UCI HAR Dataset/train/X_train.txt")
test <- read.table("UCI HAR Dataset/test/X_test.txt")

## Step 1. Merges the training and the test sets to create one dataset ##
mergeddata <- rbind(train, test)

features <- read.table("UCI HAR Dataset/features.txt")

names(mergeddata) <- features$V2

## Step 2. Extracts only the measurements on the mean ##
## and standard deviation for each measurement ##
meansd <- c(grep("mean\\(",names(mergeddata)),grep("std\\(", names(mergeddata)))

meansd <- meansd[order(meansd)]

extracted <- mergeddata[,meansd]

## Step 3. Uses descriptive activity names to name the activities in the dataset ##
allsubjs <- rbind(subjtrain, subjtest)

allactivity <- rbind(activitytrain, activitytest)

extracted <- cbind(mergeddata[,meansd], allsubjs, allactivity)

activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")

extracted$activity <- factor(extracted$activity, labels = activitylabels$V2)

## Step 4. Appropriately labels the data set with descriptive variable names ##
names(mergeddata)<-gsub("^t", "time", names(mergeddata))
names(mergeddata)<-gsub("^f", "frequency", names(mergeddata))
names(mergeddata)<-gsub("Acc", "Accelerometer", names(mergeddata))
names(mergeddata)<-gsub("Gyro", "Gyroscope", names(mergeddata))
names(mergeddata)<-gsub("Mag", "Magnitude", names(mergeddata))
names(mergeddata)<-gsub("BodyBody", "Body", names(mergeddata))

## Step 5. From the data set in step 4, creates a second, ##
## independent tidy data set with the average of each variable ##
## for each activity and each subject ##
dtmergeddata <- data.table(extracted)

## put the tidy dataset into a varaible
tidydata <- dtmergeddata[,lapply(.SD,mean), by = .(activity, subject)]

write.table(tidydata, file = "tidydata.txt", row.names = FALSE) ## output the tidy dataset

## Final check for the variable names and descriptive
str(tidydata)
tidydata




