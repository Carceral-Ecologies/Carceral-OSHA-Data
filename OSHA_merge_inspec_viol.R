# Merging inspection and violation datasets 


viol1 = read.csv(file = "Cleaned_Data/prison_violations_2010.csv", header = TRUE, stringsAsFactors = FALSE)

inspec = read.csv(file = "Cleaned_Data/prison_inspections_2010.csv", header = TRUE, stringsAsFactors = FALSE)


final = merge(inspec, viol1, by = "activity_nr", all.y = TRUE)

write.csv(final, file = "Cleaned_Data/prison_insp_viol_2010.csv")
