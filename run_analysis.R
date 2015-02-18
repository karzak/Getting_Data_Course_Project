##Start with Unzipped UCI HAR Dataset directory in working directory
library(data.table)
library(plyr)

#import test and train datasets, and the associated subject and acitivy label tables,
#as well as the features table
train_set = read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
train_setlab = read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
test_set = read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
test_setlab = read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
train_subject = read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
test_subject = read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
features = read.table(".\\UCI HAR Dataset\\features.txt")

#Rename columns using names from features table
for (i in 1:length(colnames(train_set)))colnames(train_set)[i] = as.character(features$V2[i])
for (i in 1:length(colnames(test_set)))colnames(test_set)[i] = as.character(features$V2[i])

#Add activity and subject variables to main data tables
test_set$activity = test_setlab$V1
train_set$activity = train_setlab$V1
test_set$subject = test_subject$V1
train_set$subject = train_subject$V1

#combine test and training sets into one data table
data <- rbind(test_set,train_set)

#make activity a factor variable with useful descriptions
data$activity = factor(data$activity)
labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING",
           "STANDING", "LAYING")
setattr(data$activity, "levels", labels)

#Extract std() and mean() columns and recombine them in to a single dataframe
sddata<-data[,grep('std',names(data))]
mndata<-data[,grep('mean',names(data))]
sdm_data <-cbind(mndata,sddata)
sdm_data$activity = data$activity
sdm_data$subject = data$subject
data = sdm_data
rm(sddata)
rm(mndata)
rm(sdm_data)

#Make a tidy data set (wide form) of the mean of each variable for each subject and activity
tidydata <- ddply(data, c("subject", "activity"), numcolwise(mean))

#clean up
rm(i, labels, features, test_set, test_setlab, test_subject, data, train_set,
   train_setlab, train_subject)
