setwd("E:/R")
library(reshape2)
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file,destfile = "data.zip")
unzip(data.zip)

activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activitylabels[,2] <- as.factor(activitylabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.factor(features[,2])
featuresid <- grep(".*mean.*|.*std.*",features[,2])
featuresname <- features[featuresid,2]
featuresname <- gsub("-mean","mean",featuresname)
featuresname <- gsub("-std","std",featuresname)
featuresname <- gsub("[-()]","",featuresname)


train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresid]
trainactivity <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainactivity,trainsubject,train)


test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresid]
testactivity <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testactivity,testsubject,test)


alldata <- rbind(train,test)
colnames(alldata) <- c("activity","subject",featuresname)

alldata$activity <- factor(alldata$activity,levels = activitylabels[,1],labels = activitylabels[,2])
alldata$subject <- as.factor(alldata$subject)

newdata <- melt(alldata,id=c("activity","subject"))
newdatamean <- dcast(newdata,activity+subject~variable,mean)

write.table(newdatamean, "tidy.txt", row.names = FALSE, quote = FALSE)
