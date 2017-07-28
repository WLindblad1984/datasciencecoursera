#Setting the file path and looking at the files within.
data_path <- file.path("C:/Users/owner/Desktop/Coursera/Data_Science/Getting_Cleaning_Data","UCI HAR Dataset")
data_files <- list.files(data_path, recursive=TRUE)
data_files

#Reading in the Y data
y_data_test <- read.table(file.path(data_path,"test","Y_test.txt"),header=FALSE)
y_data_train <- read.table(file.path(data_path,"train","Y_train.txt"),header=FALSE)

#Reading in the X data
x_data_test <- read.table(file.path(data_path,"test","X_test.txt"),header=FALSE)
x_data_train <- read.table(file.path(data_path,"train","X_train.txt"),header=FALSE)

#Reading in the Subject data
subject_data_test <- read.table(file.path(data_path,"test","subject_test.txt"),header=FALSE)
subject_data_train <- read.table(file.path(data_path,"train","subject_train.txt"),header=FALSE)


#MERGING THE DATA
#Merging training and test data
subject_data <- rbind(subject_data_train,subject_data_test)
y_data <- rbind(y_data_train,y_data_test)
x_data <- rbind(x_data_train,x_data_test)

#Assigning variable names
names(subject_data) <- c("Subject")
names(y_data) <- c("Activity")
feature_data <- read.table(file.path(data_path,"features.txt"),head=FALSE)
names(x_data) <- feature_data$V2

#Merge data together
merged_data1 <- cbind(subject_data,y_data)
merged_data <- cbind(x_data,merged_data1)


#EXTRACT ONLY MEASUREMENTS WITH MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
feature_data_subset <- feature_data$V2[grep("mean\\(\\)|std\\(\\)",feature_data$V2)]

select_feature_names <- c(as.character(feature_data_subset),"Subject","Activity")
Data <- subset(merged_data,select=select_feature_names)

str(Data)


#GIVE THE ACTIVITIES IN THE DATA SET DESCRIPTIVE NAMES
activity_labels <- read.table(file.path(data_path,"activity_labels.txt"),header=FALSE)

Data$Activity <- replace(Data$Activity,Data$Activity==1,"WALKING")
Data$Activity <- replace(Data$Activity,Data$Activity==2,"WALKING_UPSTAIRS")
Data$Activity <- replace(Data$Activity,Data$Activity==3,"WALKING_DOWNSTAIRS")
Data$Activity <- replace(Data$Activity,Data$Activity==4,"SITTING")
Data$Activity <- replace(Data$Activity,Data$Activity==5,"STANDING")
Data$Activity <- replace(Data$Activity,Data$Activity==6,"LAYING")

#Checking the previous lines of code
head(Data$Activity,50)


#LABEL THE VARIABLES IN THE DATA SET WITH DESCRIPTIVE NAMES
names(Data) <- gsub("^t","Time",names(Data))
names(Data) <- gsub("^f","Frequency",names(Data))
names(Data) <- gsub("Acc","Accelerometer",names(Data))
names(Data) <- gsub("Gyro","Gyroscope",names(Data))
names(Data) <- gsub("Mag","Magnitude",names(Data))
names(Data) <- gsub("BodyBody","Body",names(Data))

#Check if labels were applied correctly
names(Data)


#CREATE A CLEAN DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR ACTIVITY AND SUBJECT
library(plyr)
Tidy_Data <- aggregate(. ~Subject + Activity,Data,mean)
Tidy_Data <- Tidy_Data[order(Tidy_Data$Subject,Tidy_Data$Activity),]
write.table(Tidy_Data,file="tidydataset.txt",row.name=FALSE)