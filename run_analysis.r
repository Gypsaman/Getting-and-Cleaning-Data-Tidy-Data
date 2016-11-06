setwd("UCI HAR DATASET/")

## Read in the activity codes and the features variable names
activity <- read.table("activity_labels.txt",col.names = c("code","activity"))

## Read variable names 
features <- read.table("features.txt",col.names=c("code","name"),colClasses = c("numeric","character"))


## Read in the train information.  Assign column names and create one data frame combined
## add a column named type with the value "train"

subject_train <- read.table("train/subject_train.txt",col.names = "subject")
x_train <- read.table("train/x_train.txt")

y_train <- read.table("train/y_train.txt",col.names="Activity")


## Convert activity to descriptive names
activity_train <- data.frame(Activity=activity$activity[y_train$Activity])
colnames(x_train) <- features$name

## only use variables with mean or std measurements
x_train <- x_train[,grep("std|mean\\(\\)",colnames(train))]
x_train <- cbind(type="train",x_train)



train <- cbind(subject_train,activity_train,x_train)


## Read in the test information.  Assign column names and create one data frame combined
## add a column type with value "test"

subject_test <- read.table("test/subject_test.txt",col.names = "subject")
x_test <- read.table("test/x_test.txt")
x_test <- cbind("test",x_test)
y_test<- read.table("test/y_test.txt",col.names = "Activity")

## Convert activity to descriptive names
activity_test <- data.frame(Activity=activity$activity[y_test$Activity])

colnames(x_test) <- c("type",features$name)

test <- cbind(subject_test,activity_test,x_test)
test <- test[,c(1:3,grep("std|mean\\(\\)",colnames(test)))]


## combine train and test into one data frame
result <- rbind(train,test)

## just use the mean for each subject,activity and type
sumresult <- aggregate(result[,4:ncol(result)],by=list("subject"=result$subject ,"activity"=result$Activity,"type"=result$type),FUN=mean)
write.csv(sumresult,"summary.csv")
