# Getting and Cleaning Data Course Project
===============================
This is the Course Project of the Getting and Cleaning Data Course. The R script “run_analysis.R” does the following:

1. Remove any variables in memory.
2. Download the zip file from “https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip”, if it doesn’t exists.
4. The function “dataGathered” was created to obtain the data from the files of subject, activities, labels and data recollected, for both train and test folders separately, returning a set of data combined.
5. Using the function mentioned, the train and test data are merged into one set.
6. Extracts to a new data set the columns with std and mean in their names, besides the subject and activity columns.
7. Appropriately labels the data set with descriptive variable names.
8. Converts the activity and subject columns into factors.
9. Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
10. Creates a file named “tidy.txt” with the result of the process.
11. Remove any variables in memory.