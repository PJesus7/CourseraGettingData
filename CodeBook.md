---
title: "CodeBook"
output: html_document
---

First of all, the description of the data can be found in "UCI HAR Dataset\\README.txt".
The creation of the tidy data is performed under the function *createTidyData*. Now for a step-by-step description of this function.

# Importing data

The first thing to do is to import the data to the session, which is done using the function *read.table*. Since there will be heavy use of functions in the package *dplyr*, once the tables are read they are converted to *df* using the command *tbl_df*.

Both the training and test sets are read and stored in the variables *trainX* and *testX*, respectively, storing the 561-feature vector for each observation. Also, information with the identifier of the subject and the activity label is also imported and stored in the variables ending in *S* and *Y*, respectively. These will be useful later on when grouping the data by subject and activity.

# 1. Merging the training and test set

First, for each set, the data frames with the subject, the activity and the observation values are binded together (*bind_cols*) and stored in the variable with name ending in *Set*. 
Then the columns of these variables *Set* are named:

  * The first two columns describe the subject and the activity.
  * The rest of the columns correspond to the 561-feature vector. The name of each feature is stored in the file *features.txt*, which is read and stored in *featuresNames*.
  
Given these two items the columns of *trainSet* and *testSet* are labeled using the command *colnames*.
  
Finally both data frames are merged into one single data set called **workingdf** using the function *bind_rows*, which will bind columns with the same names.

# 2. Extracting only the measurements on the mean and standard deviation for each measurement

According to the file features_info.txt, mean measurement is stored in features with "mean()" included in its name, while standard deviation is stored with the name "std()". The goal is to select the features that include "mean()" or "std()" in its name. 

Since *workingdf* already has the correct column names, the function *select* is called to obtain the first two columns, which describe the subject and activity, and the previously mentioned features, using the special function *matches*. *matches* argument is the regular expression *"(mean|std)[(][)]"*. This expression looks for strings that include "mean()" or "std()". Since parenthesis are part of the regular expression syntax, to specifically search for "()" the regex must be *"[(][)]"*.

# 3. Use descriptive activity names

The data.frame *workingdf* has the activity labels in the second column. This column is an integer with the label of the activity. The goal is to convert this into the name of the activity itself.

The file *activity_labels.txt* maps the activity label with its name, this file is read and stored in the variable *activityLabels*. 

Going back to the main data.frame *workingdf*, the activity column is converted from integer to factor, since activity is a classification and not a measurement. Then the levels of the factor are renamed using *activityLabels* (since the table is sorted by activity label, factor with value i takes the name of the activity with label i).

# 4. Labeling the data set with descriptive variable names

This was already performed in 1. when the column names were inserted. Each variable (column) has the name of the feature it represents.

# 5. Create an independent tidy data set with the average of each variable for each activity and each subject

The tidy data set is created running the function *createTidyData* and stored in *avgData*. Now to perform the average per activity and subject the *group_by* and *summarize_each* functions are used. The data.frame *avgData* is grouped by *subjectID* and *activityID*, then the function *summarize_each* is called with argument *mean* which outputs the average for each pair *subjectID*, *activityID*.
