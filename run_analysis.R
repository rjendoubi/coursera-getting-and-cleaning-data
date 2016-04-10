#
# run_analysis.R
#
# Perform various cleaning and tidying operations on UCI "Human Activity
# Recognition Using Smartphones Data Set".
#
# Original dataset source:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# Requirementss are:
#
# 1. Merges the training and the test sets to create one data set ✓
# 2. Extracts only the measurements on the mean and standard deviation for each measurement ✓
# 3. Uses descriptive activity names to name the activities in the data set ✓
# 4. Appropriately labels the data set with descriptive variable names ✓
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. ✓
#

#
# 0. Locate the input
#

# The name of the directory in which the data is stored
# could eventually be specified by command-line flag or package options
topdir <- "UCI HAR Dataset";

if (!dir.exists(topdir)) {
    # Stop execution, producing an error message.
    stop(paste0("Cannot find directory: ", topdir));
}

#
# 4. Appropriately labels the data set with descriptive variable names.#
#

# Get the full list of labels, and use these as column labels when
# reading in data.
# First column (V1) is an integer line / variable number, second column
# (V2) is the variable name itself.
labels <- read.table(file.path(topdir, "features.txt"), stringsAsFactors = FALSE);

# Remove undesirable characters in variable names. NB these transformations
# work acceptably for the mean and standard deviation vars required for this
# exercise, but not necessarily for others.
labels <- gsub("-", "_", gsub("\\(|\\)", "", labels$V2));

# Get the labels to which each numeric result value pertains
activities  <- read.table(file.path(topdir, "activity_labels.txt"));

# We have to do effectively the same things with the 'test' and 'training' set;
# So, parameterise the names of the two sets of data, to reduce repetition.
set_names <- c("train", "test");

# Store intermediate results for the sets here, before merging together later.
sets <- list();

# For reading in data, assume directory structure as downloaded from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
for (set in set_names) {
    x <- read.table(
        file.path(                          # Create a file path like:
            topdir,                         # "UCI HAR Dataset"...
            set,                            # "/test"...
            paste0("X_", set, ".txt")       # "/X_test.txt"
        ),
        col.names = labels   # Apply variable names, per requirement 4.
    );

    #
    # 2. Extracts only the measurements on the mean and standard deviation for each measurement.
    #
    # Grab all rows, but only columns matching "mean" or "std" from
    # our set of labels.
    x <- x[,grepl("mean|std", labels)];

    # Get the *numeric* activity codes which were applied by observing
    # videos of the participants performing actions.
    # Converting these numbers to meaningful names is the next step, below.
    y <- read.table(
        file.path(
            topdir,
            set,
            paste0("y_", set, ".txt")
        )
    )

    #
    # 3. Uses descriptive activity names to name the activities in the data set.
    #
    # Y begins as a data.frame in the form
    #   V1
    # 1  5
    # 2  5
    # 3  5
    # 4  5
    # V1 can be one of the 6 integers 1:6, which each correspond to an
    # activity name as detailed in activity_labels.txt, which has already
    # been read into the var 'acvities' above.
    # Use cut() with activities to convert the vector of integers into
    # a vector of factors with meaningful names.

    Activity <- cut(y$V1, length(activities$V2), activities$V2);

    Subject  <- read.table(
        file.path(
            topdir,
            set,
            paste0("subject_", set, ".txt")
        )
    )$V1;

    sets[[set]] <- cbind(x, Activity, Subject);
}

result <- data.frame();

#
# 1. Merges the training and the test sets to create one data set.
#

# In the future, perhaps there won't always be only two sets;
# plan for having 1 or more than 1 (this was also useful for
# testing using only the smaller "test" set of data).
if (length(sets) >= 2) {
    for (i in 2:length(sets)) {
        sets[[1]] <- rbind(sets[[1]],sets[[i]]);
    }
}

result <- sets[[1]];

#
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
new_dataset <- aggregate(

    # Use all columns except the last two, Activity and Subject, which
    # we added separately at the end of the for loop above.
    result[,1:(length(colnames(result))-2)],

    # Aggregate by these two variables.
    list(
        "Activity"=result$Activity,
        "Subject"=result$Subject
    ),

    # Apply this function to the aggregates.
    mean
);

write.table(
    new_dataset,
    file.path(topdir, "output.txt"),
    row.names=FALSE
);
