## Requirements:
1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive activity names. 
5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

## Assumptions:
In order to extract only the measurements on the mean and standard deviation for each measurement consider only the measurements that have mean() and std() in their names.

## Steps to arrive at final dataset that is clean and tidy:
1. Get subjects into a dataframe.  Provide column name as _subject_ following conventions of clean data.
2. Read _activity_labels_ file to read activity labels into a dataframe.
3. Read _Y_train_ and _Y_test_ files individually to create two dataframes one each for _Train_ activities and _Test_ activities,
4. Merge activity labels dataframe obtained in step 3. above to each of the _Y_train_ and _Y_test_ dataframes.
5. Drop column containing codes for activities from each of the dataframes obtained in step 4. above to obtain dataframes that have activity codes replaced by activity labels.
6. Read _features_ file into a dataframe to obtain feature names.
7. Subset dataframe obtained in step 6. above to obtain labels for features that have _mean()_ and _std()_ only in their names.
8. Read _X_train_ and _X_test_ files into two individaual dataframes one each for _Train_ and _Test_ features.
9. Use feature labels dataframe obtained in Step 6. above to subset the two  dataframes (obtained above in step 8.) to obtain dataframes containing features for only mean and std values.
10. Combine all columns of activities dataframe (obtained in Step 5. above) and all columns of features dataframe (obtained in step 9. above) individually for _Train_ and _Test_ datasets to obtain two dataframes one each for _Train_ activities and features and _Test_ activities and features.
11. Combine columns of subject dataframe (obtained in Step 1. above) to all columns in activties and subjects dataframe (obtained in Step 10. above) to obtain two dataframes one each for _Train_ and _Test_ subjects, activities and features.
12. Merge the two dataframes one each for _Train_ and _Test_ (obtained in Step 11. above) by combining rows of the two dataframes.
13. Write merged dataframe obtained in step 12. above to a text file named _mergeddata.txt_ in the working directory.
14. Melt data in dataframe obtained in Step 13. above on subject and activity.
15. Cast this melted dataframe on subject and activity with mean on variables.
16. Provide meaningful column names to the resulting dataframe.
17. Write the tidy dataset to a file named _tidydata.txt_.

## Selection process for features
The features selected for this database are obtained from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ from the original data set but averaged for each subject and activity.

Acticvities include the following WALKING,SITTING,STANDING,LAYING WALKING_UPSTAIRS,WALKING_DOWNSTAIRS

* Subject : the id of subject under test
* Activity : one of the 6 activites per subject

The variables taken into consideration were:
* mean()
* std()