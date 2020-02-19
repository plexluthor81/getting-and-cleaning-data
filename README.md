# getting-and-cleaning-data
Coursera Data Science Series part 3 Final Assignment

The run_analysis.R script in this repository is my submission for the [assignment](https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project).

Most of the code is spent reading the text files of the dataset. Since the training and test datasets are very similar but not quite exact, I wrote a function to first defines some filenames (lines 13-23) and then parses the data (lines 24-35). This allowed me to make updates without having to worry about keeping trainig and test parsers in sync.

The remainder of the script (lines 37-56) follows the instructions step-by-step to produce the two new datasets.

The codebook for select_data is [here](codebook.md).
