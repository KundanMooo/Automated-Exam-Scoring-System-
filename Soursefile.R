# This is a standalone R script for executing data processing.

# Load the  package
library(tidyr)
library(readxl)
library(zoo)
library(dplyr)
library(readr)
library(stringr)

# Read the all sheet from the .xlsx file

file_path <- "Refrence file.xlsx"
sheet_names <- c("GEK", "EVA", "MOS", "CEA")
df_list <- list()
for (sheet_name in sheet_names) {
  data <- read_excel(file_path, sheet = sheet_name)
  colnames(data)[colnames(data) == "Actual Question"] <- "Actual_Question"
  df <- data %>%
    fill(UID,Actual_Question,Source,Abb,Skill, .direction = "down") # filling above non null data down
  df_list[[sheet_name]] <- df
}
dfkey <- do.call(rbind, df_list)
dfkey <- dfkey[, -which(names(dfkey) == "QType")]
dfkey <- dfkey[, -which(names(dfkey) == "No. of Questions")]
View(dfkey)
dfkey11 <- dfkey[, c(2,4,6,7)]
#dfkey11$Primary_key <- paste(dfkey11$UID, dfkey11$Options, sep = "")
dfkey11$Primary_Key <- paste((gsub(" ", "", dfkey11$UID)),(gsub(" ", "",dfkey11$Options)),sep = "")
dfkey11 <- dfkey11[, !(names(dfkey11) %in% c("UID", "Options"))]

View(dfkey11)

#RAW file Data Preprocessing 
file_pathraw <- "Rawfile.csv"
dataraw <- read_csv(file_pathraw, locale = locale(encoding = "ISO-8859-1"))
dataraw <- dataraw[, -c(3:9)]
dataraw <- dataraw[, -c(1)]
# Transpose the dataframe
dataraw<- t(dataraw)
# Convert the transposed data back to a dataframe
dataraw <- as.data.frame(dataraw)
# renaming headers
colnames(dataraw) <- dataraw[1, ]
# Remove the first row (which is now the header row)
dataraw <- dataraw[-1, ]
# Made new column for "Question"
dataraw$Question <- rownames(dataraw)
View(dataraw)
# Extract pattern (1_Q_GEK_TP1_001)
dataraw$Question_ID <- str_extract(dataraw$Question, "\\(.*?\\)")
View(dataraw)
# making Question ID same as UID in refrence file
dataraw$Only_Question <- str_trim(str_replace(dataraw$Question, "\\(.*?\\)", ""))

dataraw$Question_ID <- sub(".*Q_", "Q_", dataraw$Question_ID)
View(dataraw)
dataraw$Question_ID <- sub("\\)$", "", dataraw$Question_ID)
View(dataraw)


# Answer marked by Teachers stored in combined_df
teacher_dataframes <- list()

# Loop through each teacher and create data frames
for (i in 1:14) {
  teacher_col <- paste0("Teacher", i)
  df_name <- paste0("dft", i)
  df <- data.frame(
    Teacher_No = i,
    Primary_Key = paste(
      (gsub(" ", "", dataraw$Question_ID)),
      (gsub(" ", "", dataraw[[teacher_col]])),
      sep = ""
    )
  )
  teacher_dataframes[[df_name]] <- df
}
# Concatenate all data frames into a single data frame
combined_df <- do.call(rbind, teacher_dataframes)
View(combined_df)


summary_list <- list()
for (teacher_no in 1:14) {
  summary_result <- combined_df %>%
    filter(Teacher_No == teacher_no) %>%
    left_join(dfkey11, by = "Primary_Key") %>%
    group_by(Abb) %>%
    summarise(
      summary_value = ifelse(Abb %in% c("GEK", "CEA", "EVA"), sum(Marks), 
                             ifelse(Abb == "MOS", mean(Marks), NA)),
      teacher_index = paste("Teacher", teacher_no, sep = " ")  # Add the teacher index column
    ) %>%
    na.omit() %>%
    distinct()
  
  # Add the summary_result to the summary_list
  summary_list[[as.character(teacher_no)]] <- summary_result
}


final_summary <- do.call(rbind, summary_list)

View(final_summary)


pivot_summary <- final_summary %>%
  pivot_wider(names_from = Abb, values_from = summary_value) %>%
  replace_na(list(GEK = 0, CEA = 0, EVA = 0, MOS = 0))  # Replace NA with 0

View(pivot_summary)
# Generating outputfile csv
csv_file_path <- "myNamandjoboutput.csv"
# Write the pivot_summary dataframe to a CSV file
write.csv(pivot_summary, file = csv_file_path, row.names = FALSE)
