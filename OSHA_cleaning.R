#### About ####
# We already did a pass through using Openrefine. This script will further clean facility and addresses by removing special characters and other criteria. See Github issue #11. 

#### Load in Data ####
violca = read.csv(file = "Cleaned_Data/CA_prison_insp_viol_2010_op.csv", header = TRUE, stringsAsFactors = FALSE)


#### Cleaning Facility Names ####

violca$estab_name = gsub(",", " ", violca$estab_name)
violca$estab_name = gsub("\\.", "", violca$estab_name)
violca$estab_name = gsub("-", " ", violca$estab_name)
violca$estab_name = gsub("\\s?-\\s?", " ", violca$estab_name)
violca$estab_name = gsub("\\(", "", violca$estab_name)
violca$estab_name = gsub("\\)", "", violca$estab_name)
violca$estab_name = gsub("'", "", violca$estab_name)
violca$estab_name = gsub("\\/", " ", violca$estab_name)
violca$estab_name = gsub("#", "", violca$estab_name)
violca$estab_name = gsub("&", " AND ", violca$estab_name)
violca$estab_name = gsub("CALIFORNIA", "CA", violca$estab_name)
violca$estab_name = gsub("CALIF", "CA", violca$estab_name)
violca$estab_name = gsub("DEPARTMENT", "DEPT", violca$estab_name)
violca$estab_name = gsub("DEPTT", "DEPT", violca$estab_name)
violca$estab_name = gsub("REHABILITATION", "REHAB", violca$estab_name)
violca$estab_name = gsub("FORT", "FT", violca$estab_name)
violca$estab_name = gsub("\\s?  \\s?", " ", violca$estab_name)
trimws(violca$estab_name, which = c("both"))

#### Cleaning addresses ####
violca$site_address = gsub(",", " ", violca$site_address)
violca$site_address = gsub("\\.", "", violca$site_address)
violca$site_address = gsub("-", " ", violca$site_address)
violca$site_address = gsub("#", "", violca$site_address)
violca$site_address = gsub("&", " AND ", violca$site_address)
violca$site_address = gsub("\\(", "", violca$site_address)
violca$site_address = gsub("\\)", "", violca$site_address)
violca$site_address = gsub("STREET", "ST", violca$site_address)
violca$site_address = gsub("AVENUE", "AVE", violca$site_address)
violca$site_address = gsub("DRIVE", "DR", violca$site_address)
violca$site_address = gsub(" WEST ", " W ", violca$site_address)
violca$site_address = gsub(" SOUTH ", " S ", violca$site_address)
violca$site_address = gsub(" EAST ", " E ", violca$site_address)
violca$site_address = gsub(" NORTH ", " N ", violca$site_address)
violca$site_address = gsub("'", "", violca$site_address)
violca$site_address = gsub("ROAD", "RD", violca$site_address)
violca$site_address = gsub("BOULEVARD", "BLVD", violca$site_address)
violca$site_address = gsub("WSETERN", "WESTERN", violca$site_address)
violca$site_address = gsub("HIGHWAY", "HWY", violca$site_address)
violca$site_address = gsub("\\s?  \\s?", " ", violca$site_address)
trimws(violca$site_address, which = c("both"))

write.csv(violca, 'CA_prison_insp_viol_2010_op_fac.csv')
