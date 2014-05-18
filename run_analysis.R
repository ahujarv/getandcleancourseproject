runAnalysis <- function() {
        #Download zip file
        downloadFile()
}

# calAverage <- function()

#shapeTrainTest <- function() {
        #melt mean and standard dev values
        
        #cast to obtain mean and std dev in their own columns
}

## This function gets the two data frames; train and test and applies
## rbind to merge the two data frames
mergeTrainTest <- function(path) {
        train <- prepareDataset(path, "train")
        test <- prepareDataset(path, "test")
        
        trainTest <- rbind(train, test)
        trainTest
}

## This function prepares each of the dataset train and test.  It
##      1. gets features, activities and subjects for given dataType
##      2. binds subjects, activities and features
##      3. returns data frame containing subjects, activities and features
prepareDataset <- function(path, dataType) {
        ## Get features 
        reqdFeatures <- prepareFeatures(path, dataType)
        
        ## get activities and bind to features
        reqdActivities <- prepareActivities(path, dataType)
        activityFeatures <- cbind(reqdActivities, reqdFeatures)
        
        ## get subjects and bind to activities and features
        reqdSubjects <- prepareSubjects(path, dataType)
        subjectActivityFeatures <- cbind(reqdSubjects, activityFeatures)
        subjectActivityFeatures
}

## This function performs following:
##      1. reads feature label file (features.txt) into a dataframe
##      2. returns a vector containing lables for mean and std dev only
getFeatureLabels <- function(path) {
        ## Use input path to get feature label file (features.txt)
        featureLabelsFile <- paste(path, 
                             "/", "features.txt", sep="")
        featureLabelsDf <- read.table(featureLabelsFile)
        ## Get labeles that are for mean and std only
        selectFeatureLabels <- featureLabelsDf[grep("*mean\\(\\)*|*std\\(\\)*", 
                                        featureLabelsDf$V2),]
        featureLabelIndex <- as.vector(selectFeatureLabels$V1)
        featureLabels <- sapply(featureLabelIndex, 
                                function(x) paste("V", as.character(x), sep = ""))
        featureLabels
}

## This function takes path and directory to get appropriate feature file and:
##      1. Reads the file into a dataframe
##      2. Gets column labels for the columns to be considered
##      3. Subsets the data frame to retain only the mean and std dev values
prepareFeatures <- function(path, dataType) {
        ## Use input path and dataType to get appropriate activity file
        featureDirectory <- paste(path, "/", dataType, sep="")
        featureFile <- paste(featureDirectory, 
                              "/", "X_", dataType, ".txt", sep="")
        featureDf <- read.table(featureFile)
        
        ## Get column names for mean() and std() in a vector
        featureColumnHeaders <- getFeatureLabels(path)
        
        ## Subset to get feature values only for mean() and std()
        featureMeanStdDf <- featureDf[,featureColumnHeaders]
        featureMeanStdDf
}

## This function returns dataframe containing activity values substituted by
## thier corresponding labels.  It does following:
##      1. uses the input path and dataType to get to appropriate file
##      2. uses datatype to read appropriate file (train or test)
##      3. reads the acitvity values in a dataframe
##      4. mereges acitvities with corresponding lables
##      5. returns a dataframe containing one column with activity values
##         replaced with their corresponding labels
prepareActivities <- function(path, dataType) {
        ## Use input path and dataType to get appropriate activity file
        activityDirectory <- paste(path, "/", dataType, sep="")
        activityFile <- paste(activityDirectory, 
                             "/", "y_", dataType, ".txt", sep="")
        activityDf <- read.table(activityFile)
        
        ##get activity labels
        labels <- getActivityLabels(path)
        
        ## Merge activities and labels dataframes.  Default merge without
        ## by.x or by.y will work as column V1 is common in both
        activitiesWithLabels <- merge(activityDf, labels, all=TRUE)
        
        ## Create a dataframe that has values of activities substituted by
        ## their labels
        activities <- activitiesWithLabels["V2"]
        
        ## Name the column with descriptive value: Activity
        colnames(activities) <- "Activity"
        activities
}

## This function creates the data frame of activity labels from the
## input file provided (activity_labels.txt) and returns it.
getActivityLabels <- function(path) {
        ## Get the file containing activity labels
        labelFile <- paste(path, "/", "activity_labels.txt", sep="")
        labelDf <- read.table(labelFile)
        labelDf
}

## This function prepares the subject dataframe as:
## 1. takes path for directory to look for data
## 2. takes dataType to determine whether to consider train or test data set
## 3. uses path and datatype to get to the appropriate subject file
## 4. returns dataframe of subjects with title a descriptive column name
prepareSubjects <- function(path, dataType) {
        ## Use input path and dataType to get to appropriate subject file 
        subjectDirectory <- paste(path, "/", dataType, sep="")
        subjectFile <- paste(subjectDirectory, 
                             "/", "subject_", dataType, ".txt", sep="")
        subjectDf <- read.table(subjectFile)
        colnames(subjectDf) <- "Subject"
        subjectDf
}

## This function downloads the file from web if it does not already exist.
downloadFile <- function() {
        #Download the file if it does not already exist
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        if(!file.exists("data/getdata-projectfiles-UCI HAR Dataset.zip")) {
                download.file(fileUrl, 
                              destfile="getdata-projectfiles-UCI HAR Dataset.zip")
        }
        downloadDate <- date()
}
