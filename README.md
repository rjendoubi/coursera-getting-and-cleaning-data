# UCI HAR Data Cleaning Exercise

This is a course project submission for the Getting and Cleaning Data
couse on Coursera, part of the Data Science specialisation from JHU.

The objective is to write an R script to manipulate a 'raw' data set
obtained from the internet into a specified form.

More information on the data set can be found in
[CodeBook.md](CodeBook.md).

The script itself is called "run_analysis.R". It assumes the original
source data set, called the "UCI HAR Dataset", has been unzipped into
a directory called "UCI HAR Dataset" in the current working directory.

The output, a tidy, summary dataset, is placed into the "UCI HAR
Daraset" directory, in a file called "output.txt".

The script can be run in an interactive R session as follows:

    > dir()
    [1] "CodeBook.md"     "README.md"       "run_analysis.R"
    [4] "UCI HAR Dataset"
    > dir("UCI HAR Dataset/")
    [1] "activity_labels.txt" "features_info.txt"   "features.txt"
    [4] "README.txt"          "test"                "train"
    > source("run_analysis.R")
    > dir("UCI HAR Dataset/")
    [1] "activity_labels.txt" "features_info.txt"   "features.txt"
    [4] "output.txt"          "README.txt"          "test"
    [7] "train"
    >

See [CodeBook.md](CodeBook.md) for details of the variable in
"output.txt".
