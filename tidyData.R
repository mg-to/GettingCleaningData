# This script must be executed in a folder having as subfolders the test and train folders with the sampled data
if (!(file.exists("test") & file.exists("train"))) {
    stop("This program must be executed in a folder having as subfolders the train and test folders with the sampled data")
}

# 1)    Merges the training and the test sets to create one data set.
print("1.0 Load test data, this may take some time")
testf<-file.path("test","X_test.txt")
testfDS<-read.table(testf)

print("1.1 Load training data, this may take some more time")
trainingf<-file.path("train","X_train.txt")
trainingfDS<-read.table(trainingf)

# all<-merge(testfDS,trainingfDS, all.x=TRUE, all.y=TRUE)
print("1.2 Merge training and test data")
wholeDS<-rbind(trainingfDS,testfDS) # faster

rm(testfDS)  # save some memory
rm(trainingfDS)

# 2)    Extracts only the measurements on the mean and standard deviation for each measurement. 
print("2.0 Extract only the measurements on the mean and standard deviation") 
features<-read.csv("features.txt",sep=" ",header=FALSE)
columnsList<-grep("mean\\(\\)|std\\(\\)",features[,2]) # select the features with name containing "mean()" or "std()" string. An array with the number of the rows is returned
meanstdDS<-wholeDS[,columnsList] # create a new data set with the mean and std columns only
columnsName<-features[columnsList,2] # get the names of the variables with mean and std
colnames(meanstdDS)<-columnsName # apply  the column names to the new data set   


# 3)    Uses descriptive activity names to name the activities in the data set

print("3.0 Uses descriptive activity names to name the activities in the data set") 
activity<-read.csv("activity_labels.txt",header=FALSE,sep=" ") # read the activity file, first column is the number, second column is the label
testa<-file.path("test","y_test.txt")
traininga<-file.path("train","y_train.txt")                    # read the test activities
testaDS<-read.table(testa)
trainingaDS<-read.table(traininga)                             # read the training activities

# for each activity replace the activity number with the activity label in the test and training data sets
for (i in 1:nrow(activity)) {
    trainingaDS[,1]<-gsub(activity[i,1],activity[i,2],trainingaDS[,1])
    testaDS[,1]<-gsub(activity[i,1],activity[i,2],testaDS[,1]) 
}


# 4)    Appropriately labels the data set with descriptive activity names. 
print("4.0 Merge activities, subjects, means and standard deviations of sampled data") 

# load test subjects
tests<-file.path("test","subject_test.txt")
testsDS<-read.table(tests)
trainings<-file.path("train","subject_train.txt")
trainingsDS<-read.table(trainings)

# merge activity labels column, subject column, mean and std related features columns
wholemeanstdDS<-cbind(rbind(trainingaDS,testaDS),rbind(trainingsDS,testsDS),meanstdDS)
# fix column names 
colnames(wholemeanstdDS)<-c("Activity","Subject",colnames(meanstdDS))
rm(meanstdDS) # save some memory

# 5)    Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
print("5.0 Mold the data") 
library(reshape2)
wholemeanstdmoltenDS<-melt(wholemeanstdDS,id.vars=c("Activity","Subject"))
print("5.1 Generate the tidy dataset") 
wholemeanstdDSCastLength <- dcast(wholemeanstdmoltenDS, Subject + Activity ~ variable, mean)
print("5.1 Write the tidy dataset to activitysubjectmeansDS.csv") 
write.table(wholemeanstdDSCastLength, file = "activitysubjectmeansDS.csv", sep = " ", row.names = FALSE)
