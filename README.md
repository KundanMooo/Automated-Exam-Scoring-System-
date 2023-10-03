# Teacher-Assessment-Automation
Automated teacher assessment using programming to compare answer keys with teacher-marked responses in Google Sheets

Working 
1) Paste all files in the exact location.
2) Open Runfile.R code >Session>Set Working Directory> To Source File Location
3) Run Runfile.R
4) An output file will be generated with the name myNamandjoboutput.
Certainly! Here's the content for a README text file that you can use to explain your standalone R script for data processing:

---

# Exam Data Processing R Script

## Overview
This R script is designed for efficient data processing of exam results. It streamlines the process of capturing exam data from individual teachers, comparing it with a standard answer key, and calculating marks.

## Dependencies
Before running this script, ensure you have the following R packages installed:

- tidyr
- readxl
- zoo
- dplyr
- readr
- stringr

You can install these packages using the `install.packages()` function in R.

## Usage
1. Place your reference file (standard answer key) in the same directory as this script and specify its name in the `file_path` variable.

2. Specify the names of the sub-sheets within your reference file in the `sheet_names` vector. These sub-sheets should contain the standard answers for each question.

3. Ensure that your raw data file (teacher's responses) is in CSV format and specify its name in the `file_pathraw` variable.

4. Run the script.

## Script Flow
The script performs the following steps:

1. **Reading Reference Data**
   - Loads the required R packages.
   - Reads all sub-sheets from the reference Excel file, fills missing values, and combines them into a single data frame.

2. **Data Pre-processing for Raw File**
   - Reads the raw data from a CSV file.
   - Transposes the data and converts it back to a data frame.
   - Renames columns based on teacher names.
   - Removes rows containing teacher names.
   - Extracts question IDs from the question column.

3. **Teacher Data Processing**
   - Creates separate data frames for each teacher's responses.
   - Concatenates all teacher data frames into a single data frame.

4. **Summary Calculation**
   - Calculates a summary of marks or scores for each teacher based on the reference data.
   - The summary includes totals for "GEK," "CEA," "EVA," and an average for "MOS."

5. **Pivot Summary**
   - Pivots the summary data to create a more structured view.
   - Replaces missing values with 0.

6. **Output CSV Generation**
   - Writes the pivoted summary data to an output CSV file specified in the `csv_file_path` variable.

## Output
The processed data will be saved in the specified output CSV file, which can be used for further analysis or reporting.

## Notes
- Please ensure that the input files (reference file and raw data file) are correctly named and located in the same directory as this script.
- Make sure that the CSV files are properly formatted with the required data.

Feel free to reach out for any further assistance or questions.

---

You can save this content as a README.txt or README.md file in the same directory as your R script to provide clear instructions and explanations for users who may want to use your script.
