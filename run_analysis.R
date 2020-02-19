# Data Citation: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.
# Retrieved via Coursera link from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip on 2020-02-18

#step 0: Get and load the data
# Get the data (if we haven't yet)
if (!file.exists('data.zip'))
  download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip','data.zip')
if (!dir.exists('UCI HAR Dataset'))
  unzip('data.zip')

# Load the data (ignoring inertial signals)
load_data_fn <- function(dirname, train_or_test){
  if (train_or_test=='train'){
    sub_file = file.path(dirname,'train','subject_train.txt')
    act_file = file.path(dirname,'train','y_train.txt')
    dat_file = file.path(dirname,'train','X_train.txt')
  }else if (train_or_test=='test'){
    sub_file = file.path(dirname,'test','subject_test.txt')
    act_file = file.path(dirname,'test','y_test.txt')
    dat_file = file.path(dirname,'test','X_test.txt')
  }else{
    error('Invalid input in train_or_test')
  }
  subject <- read.csv(sub_file, header=F, sep="", col.names = 'Subject')
  subject[,'Subject'] <- factor(subject[,'Subject'])
  
  activities <- read.csv(file.path(dirname,'activity_labels.txt'), header=F, sep="")
  activity <- read.csv(act_file, header=F, sep="", col.names = 'Activity')
  activity[,'Activity']<-factor(activity[,'Activity'], labels=activities[,2])
  
  features <- read.csv(file.path(dirname,'features.txt'), header=F, sep="")
  features[,2] <- gsub('-(.+?)\\()-','_\\1_', features[,2])
  features[,2] <- gsub('-(.+?)\\()$','_\\1', features[,2])
  data <- read.csv(dat_file, header=F, sep="", col.names = features[,2])
  cbind(subject, activity, data)
}
train <- load_data_fn('UCI HAR Dataset','train')
test <- load_data_fn('UCI HAR Dataset','test')

# Step 1: Merge the training and the test sets to create one dataset
data <- rbind(train,test)

# Step 2: Extract only the measurements on the mean and standard deviation for each measurement
select_data <- data[,grep('Subject|Activity|.*_mean($|_)|.*_std($|_)',colnames(data))]

# Step 3: Use descriptive activity names to name the activities in the data set
# This was done while loading the data. See line 29

# Step 4: Appropriately label the data set with descriptive variable names
# Not sure what this means--the data was already labeled with descriptive names

# Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
# I could probably figure out how to do this with just base lapply, but data.table will make my life so much easier!
library(data.table)
dt <- data.table(select_data)
select_data_means <- dt[, lapply(.SD, mean), by="Subject,Activity"]