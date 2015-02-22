#Save the comments for your codebook, specifically the recipe of procedures

#The key step is looking at the data files and identifying missing values, quirks and
#...issues that violate tidy data requirements:
#   1. Each variable should be in one column
#   2. Each observation should be in one row
#   3. Each kind of variable should be represented with one table
#   4. Multiple tables should be linked by a common column.

#You should also look at each variable and determine whether a mean can be calculated
#..for that variable.

# You want to turn in: 
#   1. the raw data, submitted as .txt file with write.table() and row.names=FALSE 
#   2. a tidy data set
#   3. a code book describing each variable and its values
#   4. an explicit and exact recipe for completing steps 1-3


# Libraries you might need
library(reshape2)
library(dplyr)
library(tidyr)

#Create necessary data objects
setwd("c://courseraGACD/data/UCI HAR Dataset/test/")
TestX <- read.table("X_test.txt", header=FALSE, sep="")
TestY <- read.table("y_test.txt", header=FALSE, sep="")
TestSubject <- read.table("subject_test.txt", header=FALSE, sep="")
setwd("c://courseraGACD/data/UCI HAR Dataset/train/")
TrainSubject <- read.table("subject_train.txt", header=FALSE, sep="")
TrainY <- read.table("y_train.txt", header=FALSE, sep="")
TrainX <- read.table("X_train.txt", header=FALSE, sep="")
setwd("c://courseraGACD/data/UCI HAR Dataset/")
Features <- read.table("features.txt", header=FALSE, sep="")
#Prepare Features for use as column names in the merged dataset
Features <- as.character(Features[,2])

#Assignment Requirement #3
#Use descriptive names for the activities in the data set
#Rename the values in TestY to the meaningful activity names in Activity_Labels
TestY$V1 <- gsub("1","Walking",TestY$V1)
TestY$V1 <- gsub("2","Walking_Upstairs",TestY$V1)
TestY$V1 <- gsub("3","Walking_Downstairs",TestY$V1)
TestY$V1 <- gsub("4","Sitting",TestY$V1)
TestY$V1 <- gsub("5","Standing",TestY$V1)
TestY$V1 <- gsub("6","Laying",TestY$V1)

#Rename the values in TestY to the meaningful activity names in Activity_Labels
TrainY$V1 <- gsub("1","Walking",TrainY$V1)
TrainY$V1 <- gsub("2","Walking_Upstairs",TrainY$V1)
TrainY$V1 <- gsub("3","Walking_Downstairs",TrainY$V1)
TrainY$V1 <- gsub("4","Sitting",TrainY$V1)
TrainY$V1 <- gsub("5","Standing",TrainY$V1)
TrainY$V1 <- gsub("6","Laying",TrainY$V1)

#Assignment requirements #4
# lable each variable in the data set with appropriate descriptive names
colnames(TestX) <- Features
colnames(TrainX) <- Features
colnames(TrainY) <- "Activity"
colnames(TestY) <- "Activity"

#Assignment Requirement #1: Merge the test and training data sets
#Create objects that bind the observations and activity names
#Adjust the first column name
TestX_2 <- data.frame(cbind(TestY$Activity,TestX))
colnames(TestX_2) [1] <- "Activity"
TrainX_2 <- data.frame(cbind(TrainY$Activity,TrainX))
colnames(TrainX_2)[1] <- "Activity"

#bind the rows of TestX_2 and TrainX_2
merged_master <-  rbind(TestX_2,TrainX_2)

#Create merged set of Subject Numbers from TestSubject and TrainSubject
merged_subjects <- rbind(TestSubject,TrainSubject)
merged_master <- cbind(merged_subjects,merged_master)
colnames(merged_master)[1] <- "Subject.Number"

#Assignment Requirement #2: Return only columns for a mean or st.dev. 
#How? Match column index values that satisfy a logical condition
#H/T to http://linuxgazette.net/152/misc/lg/searching_for_multiple_strings_patterns_with_grep.html
#Create integer vector with positions of columns containing mean or std in the column name
extract_columns <- grep("mean()|std()",colnames(merged_master),value=FALSE)
tmp <- merged_master[,extract_columns]
#Reattach the Subject.Name and Activity columns from merged_master
addons <- data.frame(merged_master[,1:2])
master_final <- cbind(addons,tmp)

#Assignment Requirement #5
# Create a second, tidy data set, with the mean for each activity and subject:
# This portion is incomplete.
by_activities <- master_final[order(master_final$Activity),]
by_subjects <- master_final[order(master_final$Subject.Number),]