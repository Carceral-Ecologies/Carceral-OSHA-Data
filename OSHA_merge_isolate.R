## PURPOSE 
# The purpose of this code is to merge the OSHA inspection datasets into one dataframe. And then isolate all of the prison facilities using SIC/NAICS code and logic. 

## Load in OSHA Datasets
osha1 = read.csv("Data/osha_inspection0.csv", header = TRUE, sep = ",")
osha2 = read.csv("Data/osha_inspection1.csv", header = TRUE, sep = ",")
osha3 = read.csv("Data/osha_inspection2.csv", header = TRUE, sep = ",")
osha4 = read.csv("Data/osha_inspection3.csv", header = TRUE, sep = ",")
osha5 = read.csv("Data/osha_inspection4.csv", header = TRUE, sep = ",")

# merge datasets
oshac = rbind(osha1, osha2, osha3, osha4, osha5)

# Isolate prisons
prisonsic = oshac[oshac["sic_code"] == 9223, ]
prisonsnaics = prisonsic[with(prisonsic,"naics_code" == 922140 & "sic_code" != 9223), ] # None labeled 922140 that are not labeled 9223

# find any prisons not coded correctly using logics
prisonnot = oshac[oshac["sic_code"] != 9223, ]
prisonnot$correction = grepl("CORRECTION|CORRECTIONS|CORRECTIONAl|CORR FAC", prisonnot$estab_name) # found 831
prisonnot$prison = grepl("PRISON", prisonnot$estab_name) # 105
prisonnot$jail = grepl("JAIL", prisonnot$estab_name) # 282
prisonnot$pen = grepl("PENITENTIARY", prisonnot$estab_name) # 31
prisonnot$det = grepl("DETENTION CENTER", prisonnot$estab_name) # nothing 
prisonnot$day = grepl("DAY CENTER", prisonnot$estab_name) #1
prisonnot$camp = grepl("BOY'S CAMP|BOYS CAMP|MEN'S CAMP|MENS CAMP", prisonnot$estab_name) # 6
prisonnot$lock = grepl("LOCK-UP FACILITY", prisonnot$estab_name) # nothing
prisonnot$pub = grepl("PUBLIC SAFETY CENTER", prisonnot$estab_name) # 10
prisonnot$wom = grepl("WOMEN'S SAFETY CENTER", prisonnot$estab_name) # nothing
prisonnot$jus = grepl("JUSTICE CENTER", prisonnot$estab_name) # 29
prisonnot$con = grepl("CONSERVATION CAMP", prisonnot$estab_name) # 9
prisonnot$ref = grepl("REFORMATORIES", prisonnot$estab_name) # nothing
prisonnot$farm = grepl("JAIL FARM", prisonnot$estab_name) # 8 - these 8 also included in "Jail" search

# code to locate number of institutions found
table(prisonnot$farm)

# cut down the dataset to just the found facilities
prisonnot2 = prisonnot[prisonnot[("correction")] == TRUE | prisonnot[("prison")] == TRUE | prisonnot[("jail")] == TRUE | prisonnot[("pen")] == TRUE | prisonnot[("day")] == TRUE | prisonnot[("camp")] == TRUE | prisonnot[("lock")] == TRUE | prisonnot[("pub")] == TRUE | prisonnot[("jus")] == TRUE | prisonnot[("con")] == TRUE, ] 



# QUALITY CONTROL NEEDED HERE. SOME OF THE FACILITES in prisonot2 ARE NOT PRISONS. NEXT STEP IS TO CHECK THE SIC CODES FOR ONES THAT ALTERNATES FOR PRISONS OR JAILS AND SEE IF THAT CAN PULL ALL OF THE SAME FACILITIES.
# Also we should do quality control in terms of making sure the code above has found all the prison facilities

# Then merge the prisonnot2 dataset back to the prisonsic dataset

# we may also want to isolate just CA. 





