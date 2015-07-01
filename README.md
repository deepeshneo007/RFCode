# RFCode
Model to analyse wristWear device data

# Data description

The data set supplied represents observations recorded for 6 different people (Coded as AA…GG).
There are 19,622 records across 159 variables.
Variables represent records from personal activity devices.
The last column “Class” represents the way participants are performing the exercises.

# Task overview

Construct a classification method for the field ‘Class’; given any combination of other features provided within the data file.

# File Structure of Repo

The main R code is in the file RF_v3.R and the input data used for the analysis is Dataset3.csv

During the entire exercise, all the important outputs have been saved to individual files. These are:

1)model_train.txt

2)model_test.txt

3)missing_dataset3.txt

4)imputed_dataset3.txt

5)Summary_dataset3.txt

6)tuneRFPlot.png

7)RelativeVariableImportance.png

Code has been commented to indicate where and at what stage the above mentioned out are generated and saved.

# Pseudo Code

The R code has been commented to provide an understanding of what the code does. Following is a concise representation of that:

1) Read input data and generate summary to give an overview of the variables

2) Feature selection Step : Missing value treatment

3) Missing Value imputation Step

4) Breaking the input in training and test 

5) Model Train

6) Model predict on test data
