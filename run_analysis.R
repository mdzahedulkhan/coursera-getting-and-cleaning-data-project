# Downloading dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")


#Merging the training and the test sets to create one data set:

xTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Reading testing tables:
xTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

#Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Assigning column names:
colnames(xTrain) <- features[,2] 
colnames(yTrain) <-"activityId"
colnames(subjectTrain) <- "subjectId"

colnames(xTest) <- features[,2] 
colnames(yTest) <- "activityId"
colnames(subjectTest) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#Merging all data into one
mrgTrain <- cbind(yTrain, subjectTrain, xTrain)
mrgTest <- cbind(yTest, subjectTest, xTest)
mrgAll <- rbind(mrgTrain, mrgTest)

#Extracting only the measurements on the mean and standard deviation for each measurement

#Reading column names:
colNames <- colnames(mrgAll)

#Create vector for defining ID, mean and standard deviation:
meanAndStd <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#Making nessesary subset from mrgAll
forMeanAndStd <- mrgAll[ , meanAndStd == TRUE]

#Using descriptive activity names to name the activities in the data set:
setWithActivityNames <- merge(forMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

#Appropriately labeling the data set with descriptive variable names.

#Creating a second, independent tidy data set with the average of each variable for each activity and each subject:

#Making second tidy data set 
tidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
tidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#Writing second tidy data set in txt file
write.table(tidySet, "tidyDataSet.txt", row.name=FALSE)