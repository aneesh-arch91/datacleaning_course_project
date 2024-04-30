library(dplyr)
library(textclean)

filename <- 'UCI HAR Dataset.zip'
foldername <- 'UCI HAR Dataset'

if (!file.exists(filename) && !file.exists(foldername))
{
	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI HAR Dataset.zip", method='curl')
}

if (file.exists(filename) && !file.exists(foldername))
{
	unzip(filename)
	file.remove(filename)
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("id", "activity"))

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity_id")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity_id")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

X_data <- rbind(x_train, x_test)
Y_data <- rbind(y_train, y_test)
Subject_data <- rbind(subject_train, subject_test)

Complete_Data <- cbind(X_data, Y_data, Subject_data)

Clean_Data <- select(Complete_Data, subject, activity_id, contains('mean'), contains('std'))
Clean_Data$activity_id <- activities[Clean_Data$activity_id, 'activity']
Clean_Data <- Clean_Data %>% rename('activity' = 'activity_id')

names(Clean_Data) <- mgsub_regex(names(Clean_Data), 
	c('^t', '^f', 'Acc', 'tBody', 'Gyro', 'Mag'),
	c('Time', 'Frequency', 'Acceleration', 'TimeBody', 'Gyroscope', 'Magnitude')
)

#names(Clean_Data)

Summary_Data <- Clean_Data %>%
	group_by(subject, activity) %>%
	summarise_all(mean)

write.table(Summary_Data, "Summary_Data.txt", row.name=FALSE)

#head(Clean_Data, 2)
