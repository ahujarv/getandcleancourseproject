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
The main script to run is run_analysis.R. 

If the UCI HAR Dataset is in working directory:
```{r}
source("run_analysis.R")
runAnalysis()
```
If the UCI HAR Dataset is not in your working directory:
```{r}
source("run_analysis.R")
path <- full path to the directory where UCI HAR Dataset is
runAnalysis(path)
```
## Description

All the functions mentioned below are included in this script:

1. runAnalysis(path) : This function is the main function.  It calls following functions to achieve this:
    1. tidyTrainTest(path) : This function takes path to the directory where the files are as input.  It merges the *Train* and *Test* datasets and organizes the dataset to include columns for means of average and standard deviation.  It calls following function to merge the datasets.
        1. mergeTrainTest(path) : This function prepares *Train* and *Test* datasets individually and merges both of them.  It calls following function:
            1. prepareDataSet(path, dataType) : This function prepares given data set.  It gets features, activities and subjects for given data type (*Train* or *Test*) and binds them to create the required dataset.  It takes two arguments; path for directory where the data files are and data set type ; *Train* or *Type* to decide which file to use to create the dataset.  It calls following functions:
                1. prepareFeatures(path, dataType) : This function takes path for directory where the data files are and data set type ; *Train* or *Type* to decide which file to use to create the dataset as arguments.  It reads file into dataframe, gets column labels for columns to be considered and subsets the dataframe to retain only mean and standard deviation values.  It calls function *getFeatureLabels(path)* to read file *feature.txt* files to get dataframe containing mean and standard deviation labels only.
                2. prepareActivities() : This function takes path for directory where the data files are and data set type ; *Train* or *Type* to decide which file to use to create the dataset as arguments. It reads activity values in a dataframe, merges activities with corresponding labels and returns a dataframe containing activities replaced by their corresponding labels.  It calls function *getActivityLabels(path)* to read file *activity_labels.txt* and returns dataframe of activity labels.
                3. prepareSubjects(path, dataType) : This function takes path for directory where the data files are and data set type ; *Train* or *Type* to decide which file to use to create the dataset as arguments.  It reads the appropriate file and returns a dataframe of subjects with descriptive column name.
