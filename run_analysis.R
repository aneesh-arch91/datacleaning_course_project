library(dplyr)
library(textclean) # for the mgsub function

filename <- 'UCI HAR Dataset.zip'
foldername <- 'UCI HAR Dataset'

# If the dataset hasn't been downloaded yet
if (!file.exists(filename) && !file.exists(foldername))
{
	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI HAR Dataset.zip", method='curl')
}

# If the zip archive is downloaded but not yet extracted
if (file.exists(filename) && !file.exists(foldername))
{
	unzip(filename)
	file.remove(filename)
}

# Reading all the variable names (functions) and activities
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("id", "activity"))

# Reading train data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity_id")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

# Reading test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity_id")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Merging the train and test data
X_data <- rbind(x_train, x_test)
Y_data <- rbind(y_train, y_test)
Subject_data <- rbind(subject_train, subject_test)

# Merging the X, Y and subject data
Complete_Data <- cbind(X_data, Y_data, Subject_data)

# Only include the mean and standard deviation measurements
Clean_Data <- select(Complete_Data, subject, activity_id, contains('mean'), contains('std'))
Clean_Data$activity_id <- activities[Clean_Data$activity_id, 'activity'] # Changing the activity id to activity name
Clean_Data <- Clean_Data %>% rename('activity' = 'activity_id') # Renaming the activity_id column

# Making the variable names more readable
names(Clean_Data) <- mgsub_regex(names(Clean_Data), 
	c('^t', '^f', 'Acc', 'tBody', 'Gyro', 'Mag'),
	c('Time', 'Frequency', 'Acceleration', 'TimeBody', 'Gyroscope', 'Magnitude')
)

# Summarising all data with the mean function
Summary_Data <- Clean_Data %>%
	group_by(subject, activity) %>%
	summarise_all(mean)

# Writing it to "Summary_Data.txt"
write.table(Summary_Data, "Summary_Data.txt", row.name=FALSE)
