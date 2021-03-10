#### Purpose ####
# The purpose of this code is to take activity_nr numbers from the OSHA inspections dataset and locate them in the violations dataset. The code creates a new dataset of violations.  

#### Load in OSHA Inspection Dataset ####
inspections = read.csv("1_Data_Creation_Cleaning/Cleaned_Data/prison_inspections_2010.csv")


#### Load in OSHA Violations Datasets ####
vfiles = list.files("1_Data_Creation_Cleaning/Raw_Data/OSHA_violations", full.names = TRUE)
violations = lapply(vfiles, read.csv, header = TRUE, stringsAsFactors = FALSE)
violations_df = do.call(rbind, violations)

#### Subset the violations dataset to prisons ####
# Identify the activity numbers in the inspections dataset
activity_nr_char = as.integer(inspections$activity_nr)

# Subset the violations data using inspection activity numbers
prison_violations = violations_df[violations_df$activity_nr %in% activity_nr_char, ]

# Checking if any prisons are not in the violations_df
no_viol = inspections[!(inspections$activity_nr %in% violations_df$activity_nr), "activity_nr"]
# 1382 prisons with no violations

# save 
write.csv(prison_violations, file = "1_Data_Creation_Cleaning/Cleaned_Data/prison_violations_2010.csv", row.names = FALSE)
