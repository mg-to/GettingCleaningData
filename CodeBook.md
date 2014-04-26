## input data description
The input data description in available in some of files includes in the zip archive UCI HAR Dataset.zip.  ### README.txt specifies the name and the content of all the files in the zip archive:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every ro
w shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/seco
nd. 

## Operations on data 

The files in the folders
- test/Inertial Signals/
- train/Inertial Signals/

are not used for this analysis, since the measurements required for the analysis are summarized in the files
train/
   subject_train.txt  
   X_train.txt  
   y_train.txt

test/
   subject_test.txt  
   X_test.txt	
   y_test.txt

### 1) Merge the training and the test sets to create one data set 
Training and test data set are kept in the files train/X_train.txt and test/X_test.txt. The two datasets have the same columns and therefore the merging operation is executed simply by loading the two files into two data tables and by appending one to the other. 

1) The two files are loaded into trainingfDS and testfDS data sets

2) TrainingfDS and testfDS data sets are appended by rows into wholeDS data set

3) No filtering or modification is performed on the data set variables

4) wholeDS data set has 10299 rows and 561 columns
 
### 2) Extract only the measurements on the mean and standard deviation for each measurement 
It is required to select only the data related to mean and standard deviation of the sampled data. 

1) The name and position of all the columns of the files train/X_train.txt and test/X_test.txt are loaded from file features.txt

2) The number of all the columns whose name matches "*mean()*" or "*std()*" are identified and saved in a vector

3) A new dataset called meanstdDS is created by filtering the wholeDS data set by the vector with useful columns number

4) meanstdDS inherits the labels related to the selected columns from wholeDS 

5) meanstdDS data set has 10299 rows and 66 columns

### 3) Use descriptive activity names to name the activities in the data set
The description of the activies is kept in the file 'activity_labels.txt', linking the class numeric labels with their activity name. The files 'train/y_train.txt' and 'test/y_test.txt' keep the Training and Test labels associated to the test results. These files have a single column, with the class numeric label.
1) The file 'activity_labels.txt' is loaded into a memory data set
2) The files 'train/y_train.txt' and 'test/y_test.txt' are loade into two memory data sets, named testaDS and trainingaDS
3) The testaDS and trainingaDS data sets are modified by replacing the class numeric label with the corresponding activity name

### 4) Appropriately label the data set with descriptive activity names.
It is required to merge:
1) The data set meanstdDS with the means and the standard deviations of the sampled data
2) The data sets testaDS and trainingaDS with the activity names associated to each row of the meanstdDS data set
3) The data related to the subjects running the tests. They are kept in test/subject_test.txt and train/subject_train.txt files    

Following operations are performed:
1) Test/subject_test.txt and train/subject_train.txt files are loaded into testsDS and trainingsDS data sets
2) A new data set called wholemeanstdDS is created by appending by column 
2.1) the output of the appending by row of trainingaDS and testaDS data sets related to activities 
2.2) the output of the appending by row of trainingsDS and testsDS data sets related to subjects
2.3) meanstdDS data set with means and standard deviation of sampled data
3) wholemeanstdDS data set has 10299 rows and 68 columns

wholemeanstdDS has following columns
1) a column with label Activity, keeping the activity names. It is an ASCII string with one of following values
WALKING
WALKING_UPSTAIRS
WALKING_DOWNSTAIRS
SITTING
STANDING
LAYING
2) a column with label Subject, keeping the subject numeric identifier. It is a positive integer value in the range 1 to 30 for the data used in this analysis
3) the 66 columns inherited from meanstdDS

### 5) Create a second, independent tidy data set with the average of each variable for each activity and each subject
It is required to create a new data set with
1) a row for each combination of subject (1 to 30) and activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING), that is 180 rows
2) a column 
2.1) with the activity names
2.2) with the subject identifier
2.3) for each mean or std variable with the mean over a combination of activity and subject. The total here is 66 columns

The operation is performed in two steps:
1) wholemeanstdDS is molden into wholemeanstdmoldenDS data set with 679734 rows and 4 columns. Each rows has four variables
1.1) Activity
1.2) Subject
1.3) the label of one of 66 mean or std variables
1.4) the corresponding value
2) wholemeanstdmoldenDS data set is cast into activitysubjectmeansDS data set, that is the required tidy data set with 180 rows and 68 variables

The activitysubjectmeansDS is written into activitysubjectmeansDS.csv, a space separated ascii file. This file is submitted to Coursera








