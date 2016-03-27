# DATA COURSE PROJECT
# Following is the procedure to clean data
rm(list = ls())

filename = "data.zip"

# Verify if the data file is downloaded
if(!file.exists(filename)) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", filename)
}

# Verify if it's unzipped
if(!file.exists("UCI HAR Dataset")) {
    unzip(filename)
}

# Creating a function for gathering the data for test and train data
# now that is the same process, but with different folder.
dataGathered <- function(type) {
    # Gathering data for "type" data
    
    ## Getting subjects
    subjects <- read.table(paste("UCI HAR Dataset/", type, "/subject_", type, ".txt", sep=""), header = F)
    names(subjects) <- "subject"
    
    ## Obtaining  labels of the X_test file, subjects
    Xlabels <- read.table("UCI HAR Dataset/features.txt", header = F)
    Xdata <- read.table(paste("UCI HAR Dataset/", type,"/X_", type, ".txt", sep=""), header = F)
    
    ## Putting data labels to the X_test data
    names(Xdata) <- as.character(Xlabels$V2)
    
    # Getting activity data and labels
    Ylabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = F)
    Ydata <- read.table(paste("UCI HAR Dataset/", type,"/y_", type, ".txt", sep=""), header = F)
    Ymerge <- merge(Ydata, Ylabels, by = "V1", all.x = T, sort = F)
    names(Ymerge) <- c("V1", "Activity")
    
    # Adding the activity, subject and type of data to the X_test data
    dg <- cbind(Xdata, activity = Ymerge$Activity, subjects, type = type)
    
    ## Free up some memory
    rm(list = c("subjects", "Xlabels", "Ylabels", "Xdata", "Ydata", "Ymerge"))
    
    # Returning data gathered and labeled
    dg
}

# 1. Merges the training and the test sets to create one data set.
## Obtaining test data
testData <- dataGathered("test")
## Obtaining train data
trainData <- dataGathered("train")
## Gather in one set
allData <- rbind(testData, trainData)
rm(list = c("testData", "trainData")) # free memory

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
allData.columns <- names(allData)
allData.extract <- allData[, allData.columns[grep(".*std.*|.*mean.*|subject|activity", allData.columns)]]
rm(list = c("allData", "allData.columns")) # free memory

# 3. Uses descriptive activity names to name the activities in the data set
# It was added on "dataGathering" function

# 4. Appropriately labels the data set with descriptive variable names.
allData.extract.columns <- names(allData.extract)
allData.extract.columns <- gsub("-mean", "Mean", allData.extract.columns)
allData.extract.columns <- gsub("-std", "Std", allData.extract.columns)
allData.extract.columns <- gsub("[()-]", "", allData.extract.columns)
names(allData.extract) <- allData.extract.columns
rm("allData.extract.columns")

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
library(reshape2)
allData.extract.Melt <- melt(allData.extract, id = c("subject", "activity"))
allData.extract.Cast <- dcast(allData.extract.Melt, subject + activity ~ variable, mean)

## Export tidy data to file
tidyFileName <- "tidy.txt"
if(file.exists(tidyFileName)) {
   file.remove(tidyFileName)
}
write.csv(allData.extract.Cast, file = tidyFileName, quote = T)
message("Process Terminated.")
rm(list = ls())