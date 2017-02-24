library(dplyr)

#read in appropriate data with suitable column names
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names="subject")
y.train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names="activity")
y.test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names="activity")
features.table <- read.table("UCI HAR Dataset/features.txt")[2]
features.list <- as.character(unlist(features.table))
x.train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names=features.list)
x.test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=features.list)

# create initial table
table1 <- tbl_df(cbind(rbind(subject.test,subject.train), rbind(y.test, y.train), rbind(x.test,x.train)))

#extract variables of interest
cols <- grep("(mean\\(\\)\\-[XYZ])|(std\\(\\)\\-[XYZ])",features.list)
table2 <- select(table1, cols)

#rename activity variable entries
table2$activity <- sapply(table2$activity, 
        function(x) switch(x,"Walking","Walking Upstairs", "Walking Downstairs","Sitting","Standing","Laying"))

#create final table by grouping activity and subject
table3 <- table2 %>% group_by(activity, subject) %>% summarise_each(funs(mean))

#write table
write.table(table3,"data set.txt", row.names = FALSE)