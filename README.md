# Getting & Cleaning Data Project
The R script run_analysis.R contained in this repository does the following:

1. Download the data set from the web and unzip
2. Load the activity and feature information
3. Extract only the data with "mean" and "std"
4. Load the train data set and the test data set
5. Merge data sets
6. Add labels with appropriate description
7. Create a tbl using dplyr library, grouped by subject and activity of the data
8. Output the data into a txt file called "tidy.txt"
