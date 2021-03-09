#### Purpose ####
# The purpose of this code is to take activity_nr numbers from the OSHA inspections dataset and locate them in the OSHA related activity dataset. The code creates a new dataset of related activity.  

#### Load in OSHA Inspection Dataset ####
inspections = read.csv("1_Data_Creation_Cleaning/Cleaned_Data/prison_inspections_2010.csv")


#### Load in OSHA Related Activity Datasets ####
vfiles = list.files("1_Data_Creation_Cleaning/Raw_Data/OSHA_related_activity", full.names = TRUE)
ractivity = lapply(vfiles, read.csv, header = TRUE, stringsAsFactors = FALSE)
ractivity_df = do.call(rbind, ractivity)

#### Subset the related activity dataset to prisons ####
# Identify the activity numbers in the inspections dataset
activity_nr_char = as.integer(inspections$activity_nr)

# Subset the related activity data using inspection activity numbers
prison_ractivity = ractivity_df[ractivity_df$activity_nr %in% activity_nr_char, ]

# Checking if any prisons are not in the ractivity dataset
no_ractivity = inspections[!(inspections$activity_nr %in% ractivity_df$activity_nr), "activity_nr"]
# 415 prisons with related activity

# save 
write.csv(prison_ractivity, file = "1_Data_Creation_Cleaning/Cleaned_Data/prison_related_activity_2010.csv", row.names = FALSE)
