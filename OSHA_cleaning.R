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


#### Manual Cleaning of Facility Names ####
# After converting the data to wide format we found the following corrections needed to be made. 
# Method: We looked through the wide dataset. Sorted by zipcode. Then compared facility names with identical zipcodes. If they appeared to be similar but had slightly different names we renamed facilities to the titles that appeared in the HIFLD data. 

# rename activity number 312663560 312664980 312667173 and 307189183 to "SOUTHERN YOUTH CORR RECEPTION CENTER / CLINIC" 
# rename activity number 312430754 316673599 316668193 344157367 314829672 and 314827403 to "BARRY J NIDORF JUVENILE HALL"
# rename activity number 314827866 314827411 340046242 341570802 "PITCHESS DETENTION CENTER" 
# rename activity number 119948990 119956639 125966499 307459644 316343821 316344514 316345032 316345941 316345958 316346022 316349117 340482116 341161818 343378477 343437901 343457891 343827929 344303086 to "CALIFORNIA INSTITUTION FOR MEN (CIM)" 
# rename 343220042 125916916 342642238 312677263 312682768 125943696 to "R J DONOVAN CORRECTIONAL FACILITY (RJD)"
# rename 343756508 341733731 316210749 310603956 313506123 316214899 343406914 to CHUCKAWALLA VALLEY STATE PRISON (CVSP)
# rename 316210749 313506123 343407045 to "IRONWOOD STATE PRISON (ISP)"
# rename 310814918 309918837 312677370 to CENTINELA STATE PRISON (CEN)
# rename 343253639 331900134 342080322 343400230 342082575 331900563 342082716 331900639 331900647 342083243 to "USP VICTORVILLE"
# rename 310602537 342426566 316212216 310604897 316351022 to "CALIFORNIA REHABILITATION CENTER (CRC)"
# rename 310602693 340184837 343700449 343484002 343836094 341070795 343284931 to CALIFORNIA INSTITUTION FOR WOMEN (CIW)
# rename 316672393 316668573 316671932 to VENTURA YOUTH CORRECTIONAL FACILITY
# rename 316720499 300804663 120146022 341377265 316725159 344439153 316723220 300804663 312915911 341377265 316725365 344309661 341128007 315068387 315070367 315073551 301124681 310822689 315073569 315075218 316723121 316727247 341520252 341534782 341835296 342064854 344217237 to AVENAL STATE PRISON


# START WITH COALINGA 




#Add to above code "SHERIFF" to "SHERIFFS" 


#### Adding name of city to end of facility names ####
# This will deal with similar names but in different cities


#### Manual Cleaning of Addresses ####
# change address "US PENITENTIARY13777 AIR EXPRESSWAY BLVD" AND "FCI VICTORVILLE MEDIUM II13777 AIR EXPRESSWAY" to "13777 AIR EXPRESSWAY BLVD"
# rename "14901 S CENTRAL AVE" to "14901 CENTRAL AVE"


write.csv(violca, 'CA_prison_insp_viol_2010_op_fac.csv')



