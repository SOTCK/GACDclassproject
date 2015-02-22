# GACDclassproject
A script to merge data files in preparation for creating a tidy dataset.

READ ME
Class Project: Merging and Tidying Data
Clay Raine class project: February 22, 2015: Getting and Cleaning Data course
Introduction
The accompany script "run_analysis.R" accomplishes a number of operations on two datasets, which provide measurements of activities performed in a UC Irvine study of wearable computing devices. 
The script takes the user from raw data to a tidy data set that will return the mean for each participant in the study ("Subject.Name") and each activity performed as part of the study ("Activity"). 

Raw data files can be obtained from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A full description of the data is available here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

From the assignment description (verbatim), the script specifically seeks to accomplish the following:
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names. 
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Obtaining the Data
The data arrived in a zip folder with multiple files. The zip folder was stored locally in my class “data” folder, and no changes were made to the arrangement of files and directories found in the zip folder. Eight files were identified initially as relevant to the class assignment, and they have the following characteristics:

FILE NAME	VARIABLES	OBSERVATIONS	SPACING
X_train.txt	561	7352	Fixed width or tab
y_train.txt	1 (V1)	7352	
train_subject.txt	1 (V1)	7352	
X_test.txt	561	2947	Fixed width or tab
y_test.txt	1	2947	
test_subject.txt	1	2947	
activity_labels.txt	1	6	
features.txt	1	561	

The eight files became eight data objects in R Studio thanks to the read.table() command, where sep=”” and header=FALSE. The names of the objects differed slightly from the file names, in some cases:
•	TestSubject
•	TestX
•	TestY
•	TrainSubject
•	TrainX
•	TrainY
•	Activity_Labels
•	Features

The read.table approach initialized the file features.txt as a data frame with two columns, where the first column was redundant and contained numbers as row names. Features was converted into a one-column character vector using the method

x <- as.character(x[,2])

Upon conversion, the character vector was a single column with the variable name “x”.
Six other data objects were initialized as data frames, with the following characteristics:

NAME	DIMENSIONS	DETAIL
TestSubject	2947 observations of 1 variable	Integer vector
TestX	2947 by 561	561 numeric vectors
TestY	2947 by 1	Integer vector
TrainSubject	7352 by 1	Integer vector
TrainX	7352 by 561	561 numeric vectors
TrainY	7352 by 1	Integer vector

Discussion of the Script
The requirements of this assignment were enumerated in an order that does not reflect the steps I had to take to accomplish the first four requirements. In my case, the order was 3-4-1-2. Therefore, below you will find notes and code explaining the steps I took in the order that worked for me.

Load Libraries that might be necessary
library(reshape2)
library(dplyr)
library(tidyr)

Create the necessary data objects
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

Prepare "Features" for use as column names in the merged dataset
Features <- as.character(Features[,2])

Assignment Requirement #3: Use descriptive names for the activities in the data set
Rename the values in TestY to the meaningful activity names in Activity_Labels
TestY$V1 <- gsub("1","Walking",TestY$V1)
TestY$V1 <- gsub("2","Walking_Upstairs",TestY$V1)
TestY$V1 <- gsub("3","Walking_Downstairs",TestY$V1)
TestY$V1 <- gsub("4","Sitting",TestY$V1)
TestY$V1 <- gsub("5","Standing",TestY$V1)
TestY$V1 <- gsub("6","Laying",TestY$V1)
Rename the values in TestY to the meaningful activity names in Activity_Labels
TrainY$V1 <- gsub("1","Walking",TrainY$V1)
TrainY$V1 <- gsub("2","Walking_Upstairs",TrainY$V1)
TrainY$V1 <- gsub("3","Walking_Downstairs",TrainY$V1)
TrainY$V1 <- gsub("4","Sitting",TrainY$V1)
TrainY$V1 <- gsub("5","Standing",TrainY$V1)
TrainY$V1 <- gsub("6","Laying",TrainY$V1)

Assignment requirements #4:  label each variable in the data set with appropriate descriptive names
colnames(TestX) <- Features
colnames(TrainX) <- Features
colnames(TrainY) <- "Activity"
colnames(TestY) <- "Activity"

Assignment Requirement #1: Merge the test and training data sets
Create objects that bind the observations and activity names
Adjust the first column name
TestX_2 <- data.frame(cbind(TestY$Activity,TestX))
colnames(TestX_2) [1] <- "Activity"
TrainX_2 <- data.frame(cbind(TrainY$Activity,TrainX))
colnames(TrainX_2)[1] <- "Activity"
bind the rows of TestX_2 and TrainX_2
merged_master <-  rbind(TestX_2,TrainX_2)
Create merged set of Subject Numbers from TestSubject and TrainSubject
merged_subjects <- rbind(TestSubject,TrainSubject)
merged_master <- cbind(merged_subjects,merged_master)
colnames(merged_master)[1] <- "Subject.Number"

Assignment Requirement #2: Return only columns for a mean or st.dev. 
How? Match column index values that satisfy a logical condition
H/T to http://linuxgazette.net/152/misc/lg/searching_for_multiple_strings_patterns_with_grep.html
Create integer vector with positions of columns containing mean or std in the column name
extract_columns <- grep("mean()|std()",colnames(merged_master),value=FALSE)
tmp <- merged_master[,extract_columns]
Reattach the Subject.Name and Activity columns from merged_master
addons <- data.frame(merged_master[,1:2])
master_final <- cbind(addons,tmp)

Assignment Requirement #5
Create a second, tidy data set, with the mean for each activity and subject
This part is incomplete.

