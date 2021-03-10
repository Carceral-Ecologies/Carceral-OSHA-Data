#### About ####
# This script is concerned with understanding how many prisons are in the OSHA data for CA compared to all facilities in the state. The script takes data from the HIFLD and subsets it to CA prisons. Then it imports the OSHA data and reshapes the data to wide by facility name. 

#### Load in Data ####
prisons = read.csv("Raw_Data/Prisons/Prison_Boundaries.csv")

ca_viol = read.csv("Cleaned_data/CA_prison_insp_viol_2010_op_fac.csv")

#### subset prison data to only include CA prisons ####
caprisons = prisons[prisons$STATE == "CA", ]

# add a column if appears in the OSHA dataset 
caprisons$INOSHA = c(0)


#### format OSHA violations data to the facility level ####

# creating count of establishments in order to reshape the data

ca_violc = do.call(rbind, by(ca_viol, ca_viol$estab_name, FUN = function(estab){
  estab$estab_count = 1:nrow(estab)
  return(estab)
}))

# reshape by facility name

keepcolumns <- c("activity_nr", "estab_name", "estab_count", "site_address", "site_city", "site_zip")
ca_violk = ca_violc[keepcolumns]

ca_violw = reshape(ca_violk, idvar = "estab_name", timevar = "estab_count", direction = "wide")

row.names(ca_violw) <- 1:nrow(ca_violw)

# Note: need to check if any of the city's in the wide format do not match site_city.1. If they do not match then that likely means there are different facilities listed under the same name.


#### filter ca prison HIFLD data to include only the same zipcodes as in the OSHA data

caprisons_zip = caprisons[caprisons$ZIP %in% ca_violw$site_zip.1, ]


#### export CA prison HIFELD Data ####
write.csv(caprisons_zip, file = "Cleaned_data/caprisons_zip_HIFLD.csv", row.names = FALSE)


#### export ca_violw ####
write.csv(ca_violw, file = "Cleaned_data/CA_prison_insp_viol_2010_op_fac_wide.csv", row.names = FALSE)

