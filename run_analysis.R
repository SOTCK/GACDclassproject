#The following code was written for Windows. 

#I'm retaking this class to revisit some topics that I didn't get ample time for the first go around.
#For this project, the submission incorporates some refinements, as well as a concession to the fact I still don't get
#the final requirement regarding the tidy dataset. 
#If the final requirement merely asks for a grouped, sorted collection of the columns containing either a mean or st.dev.,
#then the tidy dataset produced with the following code should suffice. Specifically, the means and st.dev. calculations will
#be grouped by each unique combination of Subject# and (meaningful) Activity name. 
#If, on the other hand, the fourth requirement seeks either of the following, then I'm just going to have to try again
#after the course concludes:
      # a) For each combination of Subject# and Activity, find the mean and st.dev. across the 79 columns containing a mean or st.dev.
      # b) For each combination of Subject# and Activity, find the mean and st.dev. of each of the 79 columns containing a mean or st.dev.
#I tried to find answers to both a) and b). It was fun, but after trying several base package apply functions, dplyr's group_by() and
#and summarize(), and ddply from plyr(), I'm still getting error messages, mostly concerning objects of unequal length.

#Also, I love data.table's fread() functionality and have put it to good use (i.e. huge time savings) at work, so I tried it with
#the UCI Human Activity Recognition dataset, instead of read.table(). My code below retains read.table() because it was fast
#enough and fread() didn't work.

#So, I'm submitting the simpler tidy dataset and have revised the code below to complete step 4, and to fix some typos that slipped 
#through the first go around.

#Download the data from this link: 
#Use "If(!file.exists()... etc." to create the appropriate directory, if you are so moved.
#I'm using c://courseraGACD/data/UCI HAR Dataset/ as my working directory.

# Libraries you might need
library(reshape2)
library(dplyr)
library(tidyr)

#Create necessary data objects
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
#Prepare Features for use as column names in the merged dataset
Features <- as.character(Features[,2])

#Skipping to #3
#Assignment Requirement #3: Use descriptive names for the activities in the data set
#The gsub() function in the base package worked best for me the first time, so I'm keeping it.
#Rename the values in TestY to the meaningful activity names in Activity_Labels
TestY$V1 <- gsub("1","Walking",TestY$V1)
TestY$V1 <- gsub("2","Walking_Upstairs",TestY$V1)
TestY$V1 <- gsub("3","Walking_Downstairs",TestY$V1)
TestY$V1 <- gsub("4","Sitting",TestY$V1)
TestY$V1 <- gsub("5","Standing",TestY$V1)
TestY$V1 <- gsub("6","Laying",TestY$V1)

#Rename the values in TrainY to the meaningful activity names in Activity_Labels
TrainY$V1 <- gsub("1","Walking",TrainY$V1)
TrainY$V1 <- gsub("2","Walking_Upstairs",TrainY$V1)
TrainY$V1 <- gsub("3","Walking_Downstairs",TrainY$V1)
TrainY$V1 <- gsub("4","Sitting",TrainY$V1)
TrainY$V1 <- gsub("5","Standing",TrainY$V1)
TrainY$V1 <- gsub("6","Laying",TrainY$V1)

#Assignment requirement #4
# lable each variable in the data set with appropriate descriptive names
colnames(TestX) <- Features
colnames(TrainX) <- Features
colnames(TrainY) <- "Activity"
colnames(TestY) <- "Activity"

#Assignment Requirement #1: Merge the test and training data sets
#First time around I had all sorts of fits with merge(), so sticking with cbind()...
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

#Some cleaning to free up memory:
rm(merged_subjects,TestX,TestY,TestSubject,TrainX,TrainY,TrainSubject,TestX_2,TrainX_2)

#Assignment Requirement #2: Return only columns for a mean or st.dev. 
#How? Match column index values that satisfy a logical condition
#H/T to http://linuxgazette.net/152/misc/lg/searching_for_multiple_strings_patterns_with_grep.html
#Create integer vector with positions of columns containing mean or std in the column name
extract_columns <- grep("mean()|std()",colnames(merged_master),value=FALSE)
tmp <- merged_master[,extract_columns]
#Reattach the Subject.Name and Activity columns from merged_master
addons <- data.frame(merged_master[,1:2])
#Making a second instance of merged_master to preserve a copy in case something goes wrong.
merged_master2 <- cbind(addons,tmp)
#Combine the values of Subject.Number and Activity into a single new column: subject_activity
merged_master2 <- mutate(merged_master2,subject_activity = paste(master_final$Subject.Number,master_final$Activity,sep="_"))
#Rearrange the contents of merged_master2 in a final set that has subject_activity as the first column, and only the columns
#with means or st.dev. calculations:
master_final <- cbind(merged_master2[82],merged_master2[,3:81])

#Assignment Requirement #5
# Create (and write to file) a second, tidy data set, with the mean for each activity and subject:
merged_master2 <- cbind(addons,tmp)
#Combine the values of Subject.Number and Activity into a single new column: subject_activity
merged_master2 <- mutate(merged_master2,subject_activity = paste(master_final$Subject.Number,master_final$Activity,sep="_"))
#Rearrange the contents of merged_master2 in a final set that has subject_activity as the first column, and only the columns
#with means or st.dev. calculations:
master_final <- cbind(merged_master2[82],merged_master2[,3:81])

#Assignment Requirement #5
# Create (and write to file) a second, tidy data set, with the mean for each activity and subject:
# The output of “tidy_data” is only tidy-ish because the first column has the subject# and activity as a combined labeled. 
# However, it’s a holdover from my attempts to apply the mean and st.dev() function to each column and group by the 
# subject# and activity. Totally understand if I lose points for that.
tidy_data <- master_final[order(master_final$subject_activity),]
write.table(tidy_data,"./tidy_data.txt",row.names=FALSE)
