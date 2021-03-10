#### Purpose ####
# The purpose of this code is to take activity_nr numbers from the OSHA inspections dataset and locate them in the OSHA violation event dataset. The code creates a new dataset of violation event data.  

#### Load in OSHA Inspection Dataset ####
inspections = read.csv("1_Data_Creation_Cleaning/Cleaned_Data/prison_inspections_2010.csv")


#### Load in OSHA Related Activity Datasets ####
vfiles = list.files("1_Data_Creation_Cleaning/Raw_Data/OSHA_violation_event", full.names = TRUE)
vevent = lapply(vfiles, read.csv, header = TRUE, stringsAsFactors = FALSE)
vevent_df = do.call(rbind, vevent)

#### Subset the violation event dataset to prisons ####
# Identify the activity numbers in the inspections dataset
activity_nr_char = as.integer(inspections$activity_nr)

# Subset the violation event data using inspection activity numbers
prison_vevent = vevent_df[vevent_df$activity_nr %in% activity_nr_char, ]

# Checking if any prisons are not in the vevent dataset
no_vevent = inspections[!(inspections$activity_nr %in% vevent_df$activity_nr), "activity_nr"]
# 1799 prisons without violation event info

# save 
write.csv(prison_vevent, file = "1_Data_Creation_Cleaning/Cleaned_Data/prison_violation_event_2010.csv", row.names = FALSE)
