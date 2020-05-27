#### Purpose ####
# This code merges the inspection and violation datasets 


viol1 = read.csv(file = "Cleaned_Data/prison_violations_2010.csv", header = TRUE, stringsAsFactors = FALSE)

inspec = read.csv(file = "Cleaned_Data/prison_inspections_2010.csv", header = TRUE, stringsAsFactors = FALSE)


final = merge(inspec, viol1, by = "activity_nr", all.x = TRUE)
# All.x = assures that inspections with no matching violations entry will be included in the final dataset 

write.csv(final, file = "Cleaned_Data/prison_insp_viol_2010.csv")
