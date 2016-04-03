library(plyr)
library(dplyr)

createTidyData <- function()
{
#read data knowing the names of the columns/features
trainX <- tbl_df(read.table("UCI HAR Dataset\\train\\X_train.txt"))#, col.names = featuresNames[,2]))
trainY <- tbl_df(read.table("UCI HAR Dataset\\train\\y_train.txt"))#, col.names = "activityID"))
trainS <- tbl_df(read.table("UCI HAR Dataset\\train\\subject_train.txt"))#, col.names = "subjectID"))
  
testX <- tbl_df(read.table("UCI HAR Dataset\\test\\X_test.txt"))#, col.names = featuresNames[,2]))
testY <- tbl_df(read.table("UCI HAR Dataset\\test\\y_test.txt"))#, col.names = "activityID"))
testS <- tbl_df(read.table("UCI HAR Dataset\\test\\subject_test.txt"))#, col.names = "subjectID"))

#join all information related with the train and the test set
trainSet <- bind_cols(testS, testY, testX)
testSet <- bind_cols(trainS, trainY, trainX)

#get measurement names
featuresNames <- read.table("UCI HAR Dataset\\features.txt")
names <- c("subjectID", "activityID", as.character(featuresNames[,2])) #4.
colnames(trainSet) <- names
colnames(testSet) <- names
#merge both sets
workingdf <- bind_rows(trainSet, testSet) #1.

#apart from the first two columns, only want the columns that have mean() or std() in its name
workingdf <- workingdf %>% select(1, 2, matches(c("(mean|std)[(][)]"),ignore.case = FALSE)) #2.

#read activity description
activityLabels <- read.table("UCI HAR Dataset\\activity_labels.txt")

#now convert activity column into a factor and use descriptive activity names
workingdf$activityID <- as.factor(workingdf$activityID) #convert to factor
levels(workingdf$activityID) <- activityLabels[,2] #associate new levels #3.

#4. was already performed before merging the sets
workingdf
}

avgData <- createTidyData()
#want to compute the average of each measurement for each activity and subject
#group data by activity and subject then perform mean funcion on all columns (grouped columns will contain only one result)
avgData <- avgData %>% group_by(subjectID, activityID) %>% summarise_each(funs(mean))

#export table
write.table(avgData, file = "averages.txt", row.name = FALSE)