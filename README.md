# Getting and Cleaning Data Course Project

This is the repository for the final project for the Getting and Cleaning Data course, which is part of the Data Science specialization from John Hopkins University.

## About the script

1. Firstly, we have to download the dataset using the `download.file` function which gives us a zip archive. After unzipping it using the `unzip` function we can use the dataset.
2. Now all the datasets are read using the `read.table` command.
3. The train and test datasets are combined using the `rbind` function.
4. All the combined datasets of X, Y and subjects are combined using the `cbind` function which combines the datasets along columns.
5. The `select` function from the `dplyr` library is used for only including the mean and standard deviation measurements.
6. Now the variable names are made readable by replacing the short forms using the `mgsub_regex` function from the `textclean` library.
7. Lastly, a new table is created which contains the mean of all variables for each subject and activity. This is done using the `group_by` and `summarise_all` functions. This table is finally written to a file using the `write.table` function.
