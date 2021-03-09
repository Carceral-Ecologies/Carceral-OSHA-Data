#### Purpose ####

# This code subsets the final dataset (after running the openrefine cleaning code) to california prisons only

#### Load in packages ####
library(dplyr)

#### Load in the data ####
final = read.csv(file = "1_Data_Creation_Cleaning/Cleaned_Data/prison_insp_viol_2010_op.csv", header = TRUE, stringsAsFactors = FALSE)


#### Subset to CA ####
caprisons = final %>% filter_at(vars(site_state), any_vars(. %in% 'CA'))


#### Export the data ####

write.csv(caprisons, file = "1_Data_Creation_Cleaning/Cleaned_Data/CA_prison_insp_viol_2010_op.csv", row.names = FALSE)

