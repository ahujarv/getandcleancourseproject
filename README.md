## Introduction
This repository contains files/scripts to read data collected from the accelerometers from the Samsung Galaxy S smartphone.  

### Data Set Information
Dataset Informaton is provided at [Data Set Location](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "Title") 

## Objectives
Create one R script called run_analysis.R that does the following: 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Instructions
The main script to run is run_analysis.R.  It has following functions:

1. runAnalysis : This function is the main function.  It takes following parameters:
    1. path for directory where the data files are as input.  The input parameter is defaulted to read from the directory **UCI HAR Datasets** in the working directory if not provided.  

This script further calls following functions:

1. downloadFile() : This function
    1. creates directory *data* in working directory if not already present
    2. downloads the input zip file if not already present in directory named *data* in working directory
    3. stores the date when file is downloaded in a variable
