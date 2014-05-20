## This function
##      1. takes path to directory containing data files as input.  If not
##      provided, it defaults it to 'data/UCI HAR Dataset' in working directory.
##      If this directory is not present in working directory and path
##      to where directory 'UCI HAR Dataset' is not provided, it will 
##      error out.
##      2. downloads the required zip file if zip file is not present in directory
##      'data' in the working directory.  It will download it only one time.  
##      The zip file needs be unzipped manually in the working directory 
##      for default to work, otherwise unzip the file in any directory and 
##      provide complete path to the directory 'UCI HAR Dataset' 
##      3. calls function tidyDataset() to obtain tidy dataset that has been
##      created by series of other functions that extract, merge and label
##      the dataset appropriately.
##      4. writes final tidy dataset to output file named tidydataset.txt in
##      direcotry 'data' under working directory

runAnalysis <- function(path = "data/UCI HAR Dataset") {
        #Download zip file if needed
        downloadFile()
        
        #Tidy the dataset and write it to a file
        finalDataset <- tidyTrainTest(path)
        write.table(finalDataset, file="data/tidydata.txt",quote=FALSE,col.names=TRUE)
}

## This function takes path to the directory having data files as input and
## returns a tidy dataset.
## It performs following:
##      1. Melts the dataset to get average and mean values for each subject 
##      for each acitvity
##      2. Casts dataset applying 'mean' function to each meansurement to 
##      calculate average of each measurement for each subject for each acitivity
##      3. Label each column appropriately

tidyTrainTest <- function(path) {
        library(reshape2)
        #melt mean and standard dev values
        mergedDataset <- mergeTrainTest(path)
        meltDataset <- melt(mergedDataset, id=c("subject","activity"))
        tidyDataset <- dcast(meltDataset, subject+activity ~ variable, mean)
        nonIdCols <- colnames(tidyDataset[3:68])
        nonIdAveCols <- sapply(nonIdCols, function(x) 
                paste("each", "subject","activity", "average",x, sep="-"))
        colnames(tidyDataset) <- c(colnames(tidyDataset[1:2]), as.vector(nonIdAveCols))
        tidyDataset
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
##      2. returns a data frame containing lables for mean and std dev only
getFeatureLabels <- function(path) {
        ## Use input path to get feature label file (features.txt)
        featureLabelsFile <- paste(path, 
                             "/", "features.txt", sep="")
        featureLabelsDf <- read.table(featureLabelsFile)
        ## Get labeles that are for mean and std only
        selectFeatureLabels <- featureLabelsDf[grep("*mean\\(\\)*|*std\\(\\)*", 
                                        featureLabelsDf$V2),]
        featureLabelIndex <- as.vector(selectFeatureLabels$V1)
        featureLabelsCode <- sapply(featureLabelIndex, 
                                    function(x) paste("V", as.character(x), 
                                                      sep = ""))
        featureLabels <- cbind(V1=featureLabelsCode, 
                               V2=selectFeatureLabels["V2"])
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
        featureMeanStdDf <- featureDf[,featureColumnHeaders$V1]
        colnames(featureMeanStdDf) <- as.vector(featureColumnHeaders$V2)
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
        colnames(activities) <- "activity"
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
        colnames(subjectDf) <- "subject"
        subjectDf
}

## This function downloads the file from web if it does not already exist.
downloadFile <- function() {
        ## Create direcotry data it does not exist in working directory
        if(!file.exists("data")) {
                dir.create("data")
        }
        #Download the file if it does not already exist
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        if(!file.exists("data/getdata-projectfiles-UCI HAR Dataset.zip")) {
                download.file(fileUrl, 
                              destfile="data/getdata-projectfiles-UCI HAR Dataset.zip")
        }
        downloadDate <- date()
}
