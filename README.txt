READ ME
Class Project: Merging and Tidying Data
Clay Raine class project: September 27, 2015: Getting and Cleaning Data course

NOTE: I took this class back in February and am retaking it to revisit certain concepts. This readme file has been altered to reflect changes in the code I made for this second course project. Major changes begin on Line 53, below.

Introduction
The accompanying script "run_analysis.R" accomplishes a number of operations on two datasets, which provide measurements of activities performed in a UC Irvine study of wearable computing devices. 
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
NOTE: The following code was written for Windows, and a prior version was submitted when I took the course previously. 

Step 1:
Download the data from this link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
Use "If(!file.exists()... etc." to create the appropriate directory, if you are so moved. I'm using c://courseraGACD/data/UCI HAR Dataset/ as my working directory.
Load libraries that you might need:
library(dplyr) #The following code uses this library for mutate().
Optional libraries include reshape2 and tidyr. Ultimately, I didn’t use these library, relying instead on base package tools like cbind, gsub and grep to handle rearranging and renaming of columns.
Step 2: 
Create necessary data objects
setwd("./test/")
TestX <- read.table("X_test.txt", header=FALSE, sep="")
TestY <- read.table("y_test.txt", header=FALSE, sep="")
TestSubject <- read.table("subject_test.txt", header=FALSE, sep="")
setwd("./train/")
TrainSubject <- read.table("subject_train.txt", header=FALSE, sep="")
TrainY <- read.table("y_train.txt", header=FALSE, sep="")
TrainX <- read.table("X_train.txt", header=FALSE, sep="")
setwd("../")
Features <- read.table("features.txt", header=FALSE, sep="")
#Prepare the Features for use as column names in the merged dataset:
Features <- as.character(Features[,2])

Step 3: Skip to Assignment Requirement #3: Use descriptive names for the activities in the data set
I used the gsub() function in the base package during my first attempt, and would explore using a loop to shorten the code. The following block evaluates the currently unnamed first column for each of six activity ID numbers, and assigns a different meaningful name for each.
TestY$V1 <- gsub("1","Walking",TestY$V1)

TestY$V1 <- gsub("2","Walking_Upstairs",TestY$V1)
TestY$V1 <- gsub("3","Walking_Downstairs",TestY$V1)
TestY$V1 <- gsub("4","Sitting",TestY$V1)
TestY$V1 <- gsub("5","Standing",TestY$V1)
TestY$V1 <- gsub("6","Laying",TestY$V1)
Repeat the steps for the TrainY data object. 
TrainY$V1 <- gsub("1","Walking",TrainY$V1)
TrainY$V1 <- gsub("2","Walking_Upstairs",TrainY$V1)
TrainY$V1 <- gsub("3","Walking_Downstairs",TrainY$V1)
TrainY$V1 <- gsub("4","Sitting",TrainY$V1)
TrainY$V1 <- gsub("5","Standing",TrainY$V1)
TrainY$V1 <- gsub("6","Laying",TrainY$V1)

Step 4: Proceed to assignment requirement #4: Label each variable in the data set with appropriate descriptive names.
The appropriate names for the TestX and TrainX columns are found in the Features object (created from the features.txt data file). Having converted Features into a character vector, we can simply replace the column names by the following assignments:
colnames(TestX) <- Features
colnames(TrainX) <- Features
The TrainY and TestY objects contain a single column that can be labeled “Activity”
colnames(TrainY) <- "Activity"
colnames(TestY) <- "Activity"

Step 5: Assignment Requirement #1: Merge the test and training data sets
I had all sorts of fits with merge(), so I went with cbind() and rbind() instead. As a first step, I created objects to bind observations and activity names, and then adjusted the name of column 1 to a meaningful name.
TestX_2 <- data.frame(cbind(TestY$Activity,TestX))

colnames(TestX_2) [1] <- "Activity"
TrainX_2 <- data.frame(cbind(TrainY$Activity,TrainX))
colnames(TrainX_2)[1] <- "Activity"
merged_master <-  rbind(TestX_2,TrainX_2)

Create merged set of Subject Numbers from TestSubject and TrainSubject
merged_subjects <- rbind(TestSubject,TrainSubject)
merged_master <- cbind(merged_subjects,merged_master)
colnames(merged_master)[1] <- "Subject.Number"

Free up some memory by removing the following objects::
rm(merged_subjects,TestX,TestY,TestSubject,TrainX,TrainY,TrainSubject,TestX_2,TrainX_2)

Step 6: Assignment Requirement #2: Return only columns for a mean or st.dev. 
Following the work at the following URL, the code below matches column index values that satisfy a logical condition:
http://linuxgazette.net/152/misc/lg/searching_for_multiple_strings_patterns_with_grep.html 
Create integer vector with positions of columns containing mean or std in the column name
extract_columns <- grep("mean()|std()",colnames(merged_master),value=FALSE)
tmp <- merged_master[,extract_columns]

Reattach the Subject.Name and Activity columns from merged_master:
addons <- data.frame(merged_master[,1:2])
NOTE: Making a second instance of merged_master to preserve a copy in case something goes wrong.
merged_master2 <- cbind(addons,tmp)
Combine the values of Subject.Number and Activity into a single vector: subject_activity
merged_master2 <- mutate(merged_master2, subject_activity =paste(master_final$Subject.Number,master_final$Activity,sep="_"))
Rearrange the contents of merged_master2 in a final set that has subject_activity as the first column, and only the columns with means or st.dev. calculations:
master_final <- cbind(merged_master2[82],merged_master2[,3:81]

Step 7: Assignment Requirement #5: Create (and write to file) a second, tidy data set, with the mean for each activity and subject. The output of “tidy_data” is only tidy-ish because the first column has the subject# and activity as a combined labeled. However, it’s a holdover from my attempts to apply the mean and st.dev() function to each column and group by the subject# and activity. Totally understand if I lose points for that. 
tidy_data <- master_final[order(master_final$subject_activity),]
write.csv(tidy_data,"./tidy_data.txt",row.names=FALSE) 
