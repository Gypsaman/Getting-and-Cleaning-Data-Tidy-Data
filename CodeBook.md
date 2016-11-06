# Initial Data

The initial data is obtained by downloading the zip file located at:

(https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

This data should be downloaded and the zip file should be extracted to your home directory.  
The extraction will create the followin directory structure
* UCI HAR Dataset
  * train
    * Inertial Signals
  * test
    * Inertial Signals
for the purpose of this exercise, the inertial signals directory and files contained within will not be used.
	
##The data is grouped into three categories

###Variable Names and Info

  This data is located in the (UCI HAR Dataset) directory and are located within the following files.
  - Readme.txt.  This file should be reviewed for general description and licensing agreements.

  - activity_labels.txt.  Contains the activity code and description of the activity
  ```
  1 WALKING
  2 WALKING_UPSTAIRS
  3 WALKING_DOWNSTAIRS
  4 SITTING
  5 STANDING
  6 LAYING
  ```
  - features_info.txt  Contains descriptions of the variables used within the tests and training.
                       This document should be read to get familiarized with the variables.
  - features.txt  Contains the variable code and description used.  This data is used as a header for the
                  train and test data.  For brevity they will not be duplicated  here.
				
###Train data

  This data is located in the (UCI HAR Datase/train) directory and contain the following files:
  - x_train.txt   Contains a table with 7352 observations and 561 variables measured.  The variables 
                  are described in features.txt and features_info.txt
  - y_train.txt   Contains a vector with 7352 observations.  Each observation corresponds to an
                   observation within x_train.txt and represents the activity measured.			  
  - subject_train.txt`  Contains a vector with 7352 observations.  Each observation corresponds to an
                      observation within x_train.txt and represents the subject.
###Test data

  This data is located in the (UCI HAR Datase/test) directory and contain the following files:
  - x_test.txt   Contains a table with 2947 observations and 561 variables measured.  The variables 
                 are described in features.txt and features_info.txt
  - y_test.txt   Contains a vector with 2947 observations.  Each observation corresponds to an
                observation within x_test.txt and represents the activity measured.			  
  - subject_test.txt`  Contains a vector with 2947 observations.  Each observation corresponds to an
                       observation within x_test.txt and represents the subject.

# Data Input and Transformations

##The variable descriptions are read in
```
## Read in the activity codes and the features variable names
activity <- read.table("activity_labels.txt",col.names = c("code","activity"))

## Read variable names 
features <- read.table("features.txt",col.names=c("code","name"),colClasses = c("numeric","character"))
```

##The training information is read in

### Read in the train information.  Assign column names and create one data frame combined
```
subject_train <- read.table("train/subject_train.txt",col.names = "subject")
x_train <- read.table("train/x_train.txt")
y_train <- read.table("train/y_train.txt",col.names="Activity")
```

### Convert activity to descriptive names
```
activity_train <- data.frame(Activity=activity$activity[y_train$Activity])
colnames(x_train) <- features$name
```

### only use variables with mean or std measurements
```
x_train <- x_train[,grep("std|mean\\(\\)",colnames(train))]
```

### add a variable to identify the data as training 
```
x_train <- cbind(type="train",x_train)
```

### merge the subject,activity and train data into one data frame.
```
train <- cbind(subject_train,activity_train,x_train)
```

##The test information is read in

### Read in the test information.  Assign column names and create one data frame combined
### add a column type with value "test"
```
subject_test <- read.table("test/subject_test.txt",col.names = "subject")
x_test <- read.table("test/x_test.txt")
y_test<- read.table("test/y_test.txt",col.names = "Activity")
```

### Convert activity to descriptive names
```
activity_test <- data.frame(Activity=activity$activity[y_test$Activity])
colnames(x_test) <- features$name
```

### only use variables with mean or std measurements
```
test <- test[,grep("std|mean\\(\\)",colnames(test))]
```

### add a variable to identify the data as test data
```
x_test <- cbind("test",x_test)
```

### merge the subject,activity and train data into one data frame.
```
test <- cbind(subject_test,activity_test,x_test)
```

##Test data and Train data are meged together and summarised by subject,activity and subject



### combine train and test into one data frame and create a tidy data called summary.csv

```
result <- rbind(train,test)
```

### group by subject,activity and type using the mean of each variable
```
sumresult <- aggregate(result[,4:ncol(result)],by=list("subject"=result$subject ,"activity"=result$Activity,"type"=result$type),FUN=mean)
```

### output the tidy data
```
write.csv(sumresult,"summary.csv")

```

# Description of resulting Tidy Data

The resulting fields used in the tidy data are listed below. Subject is a numeric value identifying the
person being tested or trained.  Activity is a descriptive field describing the activity measured.  
See activity labels above.  Type is either (Train,Test) which identifies the type of data being recorded.
The remaining fields are described in features_info.txt and features.txt					  
					  
```
 [1] "subject"                     "Activity"                    "type"                       
 [4] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"          
 [7] "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
[10] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"       
[13] "tGravityAcc-std()-X"         "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
[16] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"      
[19] "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
[22] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"          "tBodyGyro-mean()-Z"         
[25] "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
[28] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"     
[31] "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
[34] "tBodyAccMag-mean()"          "tBodyAccMag-std()"           "tGravityAccMag-mean()"      
[37] "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
[40] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"    
[43] "tBodyGyroJerkMag-std()"      "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
[46] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"           
[49] "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
[52] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"       
[55] "fBodyAccJerk-std()-Z"        "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
[58] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"          
[61] "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
[64] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"    
[67] "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 
```