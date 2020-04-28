#### PURPOSE  ####
# The purpose of this code is to merge the OSHA inspection datasets into one dataframe. And then isolate all of the prison facilities using SIC/NAICS code and logic. 


library(lubridate)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)

#### Load in OSHA Inspection Datasets ####
osha1 = read.csv("Raw_Data/osha_inspection0.csv", header = TRUE, sep = ",")
osha2 = read.csv("Raw_Data/osha_inspection1.csv", header = TRUE, sep = ",")
osha3 = read.csv("Raw_Data/osha_inspection2.csv", header = TRUE, sep = ",")
osha4 = read.csv("Raw_Data/osha_inspection3.csv", header = TRUE, sep = ",")
osha5 = read.csv("Raw_Data/osha_inspection4.csv", header = TRUE, sep = ",")

# merge datasets
oshac = rbind(osha1, osha2, osha3, osha4, osha5)

#### 1. Isolate Prisons using sic code ####
prisonsic = oshac[oshac$sic_code == 9223 & !is.na(oshac$sic_code), ]
prisonsnaics = prisonsic[with(prisonsic,"naics_code" == 922140 & "sic_code" != 9223), ] # None labeled 922140 that are not labeled 9223

# reformating the close dates
prisonsic$close_case_date = ymd(prisonsic$close_case_date)
prisonsic$year = year(prisonsic$close_case_date)
table(prisonsic$year)

# Filter prisons identified by sic code to only inspections with close dates no later than 2009
table(is.na(prisonsic$year))
prisonsic2010 = prisonsic[prisonsic$year > 2009 | is.na(prisonsic$year == TRUE), ]


#### 2. Find any prisons not coded correctly using logics ####
prisonnot = oshac[oshac["sic_code"] != 9223, ]
prisonnot$correction = grepl("CORRECTION|CORRECTIONS|CORRECTIONAl|CORR FAC", prisonnot$estab_name) # found 831
prisonnot$prison = grepl("PRISON", prisonnot$estab_name) # 105
prisonnot$jail = grepl("JAIL", prisonnot$estab_name) # 282
prisonnot$pen = grepl("PENITENTIARY", prisonnot$estab_name) # 31
prisonnot$det = grepl("DETENTION CENTER", prisonnot$estab_name) # nothing 
prisonnot$day = grepl("DAY CENTER", prisonnot$estab_name) # 1
  # NOTE
  # THIS IS NOT A PRISON - ADULT DAY CENTER
prisonnot$camp = grepl("BOY'S CAMP|BOYS CAMP|MEN'S CAMP|MENS CAMP", prisonnot$estab_name) # 6
  # NOTE
  # 5 of these are from the 1970s and were likly camps - no longer exist. 
prisonnot$lock = grepl("LOCK-UP FACILITY", prisonnot$estab_name) # nothing
prisonnot$wom = grepl("WOMEN'S SAFETY CENTER", prisonnot$estab_name) # nothing
prisonnot$jus = grepl("JUSTICE CENTER", prisonnot$estab_name) # 29
prisonnot$con = grepl("CONSERVATION CAMP", prisonnot$estab_name) # 9
  # Not Prisons
  # 102121969; 102215076
prisonnot$ref = grepl("REFORMATORIES", prisonnot$estab_name) # nothing
prisonnot$farm = grepl("JAIL FARM", prisonnot$estab_name) # 8 - these 8 also included in "Jail" search

# code to locate number of institutions found
table(prisonnot$farm)

# Create dataset for found facilities #
prisonnot2 = prisonnot[prisonnot[("correction")] == TRUE | prisonnot[("prison")] == TRUE | prisonnot[("jail")] == TRUE | prisonnot[("pen")] == TRUE | prisonnot[("day")] == TRUE | prisonnot[("camp")] == TRUE | prisonnot[("lock")] == TRUE | prisonnot[("jus")] == TRUE | prisonnot[("con")] == TRUE | prisonnot[("farm")] == TRUE  , ] 

# reformating the dates
prisonnot2$close_case_date = ymd(prisonnot2$close_case_date)
prisonnot2$year = year(prisonnot2$close_case_date)
table(prisonnot2$year)
prisonnot2

# Filter prisons identified by sic code to only inspections with close dates no later than 2009

CaliforniaPrisons <- prisonnot2 %>% filter(site_state == "CA")

prisonnot2$close_case_date <- ymd(prisonnot2$close_case_date)

newprisons <- prisonnot2 %>% mutate(year = year(close_case_date))
newprisons2 <- newprisons %>% filter(year > 2009 | is.na(year == TRUE))

# Drop four facilities which are not actually prisons 
# 1. 314765041
# 2. 313762569
# 3. 315010157
# 4. 315605832
# 5. 315736637 - contractor who builds jails
# 6. 313787681 - electrical contractor

newprisons3 = newprisons2 %>% filter(activity_nr !=  314765041) %>% filter(activity_nr != 313762569) %>% filter(activity_nr != 315010157) %>% filter(activity_nr != 315605832) %>% filter(activity_nr != 315736637) %>% filter(activity_nr !=  313787681)


#### 3. Combine Part1 and Part2 Datasets and Save ####
# combine prison2010 and newprisons2
newprisons4 = select(newprisons3, -correction, -prison, -jail, -pen, -det, -day, -camp, -lock, -wom, -jus, -con, -ref, -farm)

newprisons5 = full_join(prisonsic2010, newprisons4)

# save 
 write.csv(newprisons5, file = "prison_inspections_2010.csv")



