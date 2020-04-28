#### Purpose ####
# The purpose of this code is to take activity_nr numbers from the OSHA inspections dataset and locate them in the violations dataset. The code creates a new dataset of violations.  

inspections = read.csv("prison_inspections_2010.csv")


#### Load in OSHA Inspection Datasets ####
vfiles = list.files("Raw_Data/Violations", full.names = TRUE)
violations = lapply(vfiles, read.csv, header = TRUE, stringsAsFactors = FALSE)
violations_df = do.call(rbind, violations)

activity_nr_char = as.integer(inspections$activity_nr)
prison_violations = violations_df[violations_df$activity_nr %in% activity_nr_char, ]

# Checking if any prisons are not in the violations_df
no_viol = inspections[!(inspections$activity_nr %in% violations_df$activity_nr), "activity_nr"]
#809 prisons with no violations 

# save 
write.csv(prison_violations, file = "prison_violations_2010.csv")
