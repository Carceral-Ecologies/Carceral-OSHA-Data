#### Purpose ####
# This code merges all of the OSHA datasets 

#### Load in Packages ####
library("tidyverse")

#### Load in Insepctions ####
inspections = read.csv(file = "1_Data_Creation_Cleaning/Cleaned_Data/prison_inspections_2010.csv", header = TRUE, stringsAsFactors = FALSE)


#### Load in Violations ####
violations = read.csv(file = "1_Data_Creation_Cleaning/Cleaned_Data/prison_violations_2010.csv", header = TRUE, stringsAsFactors = FALSE)


#### Load in Related Activity ####
ractivity = read.csv(file = "1_Data_Creation_Cleaning/Cleaned_Data/prison_related_activity_2010.csv", header = TRUE, stringsAsFactors = FALSE)


#### Load in Violation Event ####
vevent = read.csv(file = "1_Data_Creation_Cleaning/Cleaned_Data/prison_violation_event_2010.csv", header = TRUE, stringsAsFactors = FALSE)

#### Merging Violations and Vevent ####

# Examining missingness between datasets 
# violations not in vevent
viol_not_in_vevent = violations[!(violations$activity_nr %in% vevent$activity_nr), "activity_nr"]
# 1308 - there are 443 activity numbers in violations not in vevent
  
# vevent not in violations
vevent_not_in_viol = vevent[!(vevent$activity_nr %in% violations$activity_nr), "activity_nr"]
# 157 rows - there are only 26 actual activity numbers not in violations
  
# For some reason there are 26 activity numbers from violation event data without violation           information. I recommend dropping those because without corresponding violation information we can't  know what the hazard was, how much the penalty was etc. 
# View the to be dropped cases - checking which vevents not in violations 
test = inspections
test = test[test$activity_nr %in% vevent_not_in_viol, ]

# There are duplicate activity and citation id numbers in the vevent data because this shows record of changes over time. 
table(vevent$activity_nr, vevent$citation_id)
test_vevent = vevent 
test_vevent$dups = paste(vevent$activity_nr, vevent$citation_id)
table(test_vevent$dups)[table(test_vevent$dups) > 1]
  
# Convert vevent from long to wide in order to merge the datasets
# paste the activity number and citation id together in new column
vevent$act_id = paste(vevent$activity_nr, vevent$citation_id)
  
# creating count of act_ID in order to reshape the data
veventc = do.call(rbind, by(vevent, vevent$act_id, FUN = function(actid){
  actid$actid_count = 1:nrow(actid)
  return(actid)
  }))
  
# reshape by activity number and citation id
keepcolumns <- c("activity_nr", "citation_id", "pen_fta", "hist_event", "hist_date", "hist_penalty", "hist_abate_date", "hist_vtype", "hist_insp_nr", "load_dt", "act_id", "actid_count")
veventk = veventc[keepcolumns]
veventw = reshape(veventk, idvar = "act_id", timevar = "actid_count", direction = "wide")
  
# rename the row names
row.names(veventw) <- 1:nrow(veventw) 

# paste activity number and citation id together for violations dataset #
violations$act_id = paste(violations$activity_nr, violations$citation_id)
  
  
### Merge vevent and violations ####
viol_and_vevent = merge(violations, veventw, by = c("act_id"), all.x = TRUE, row.names = FALSE)
# All.x assures that violations with no matching vevent will be included


#### Merging ractivity and inspections ####
# We have to merge ractivity and inspections because neither has a citation id which violations does have. 

# Convert ractivity from long to wide in order to merge the datasets
# creating count of activity number in order to reshape the data
ractivityc = do.call(rbind, by(ractivity, ractivity$activity_nr, FUN = function(actn) {actn$actn_count = 1:nrow(actn)
  return(actn)
}))

# reshape by activity number
keepcolumns <- c("activity_nr", "rel_type", "rel_act_nr", "rel_safety", "rel_health", "load_dt", "actn_count")
ractivityk = ractivityc[keepcolumns]
ractivityw = reshape(ractivityk, idvar = "activity_nr", timevar = "actn_count", direction = "wide") # it is a bit cumbersome that one activity number has 19 other related activities resulting in over 100 variables now. 

# rename the row names
row.names(ractivityw) <- 1:nrow(ractivityw) 

# Check how many ractivity are not in inspections
# ractivity not in inspections
ractivity_not_in_inspec = ractivity[!(ractivity$activity_nr %in% inspections$activity_nr), "activity_nr"] # none

# inspections not in ractivity
inspec_not_in_ractivity = inspections[!(inspections$activity_nr %in% ractivity$activity_nr), "activity_nr"] # 415 inspections not in ractivity

### Merge ractivity and inspections ####
inspections_ractivity = merge(inspections, ractivityw, by = c("activity_nr"), all.x = TRUE, row.names = FALSE)
# all.x = true ensures we keep all inspection records if they do not appear in ractivity


#### Merging inspections and violations ####

# Check how many violations are not in inspections
# violations not in inspections
viol_not_in_inspec = viol_and_vevent[!(viol_and_vevent$activity_nr %in% inspections_ractivity$activity_nr), "activity_nr"] # none

# inspections not in violations
inspec_not_in_violations = inspections_ractivity[!(inspections_ractivity$activity_nr %in% viol_and_vevent$activity_nr), "activity_nr"] # 1382 inspections not in violations. This makes sense because some inspections may never have had a resulting violation.

# create flag to mark no violation data
inspections_ractivity$noviol = ifelse(inspections_ractivity$activity_nr %in% inspec_not_in_violations, TRUE, FALSE)

### Merge inspections and violations ####

final = merge(inspections_ractivity, viol_and_vevent, by = "activity_nr", all.x = TRUE, row.names = FALSE)
# All.x = assures that inspections with no matching violations entry will be included in the final dataset 

#### Rearrange rows for readability ####
final = final %>% relocate(all_of(c("activity_nr", "reporting_id", "state_flag", "estab_name", "site_address", "site_city", "site_state", "site_zip", "owner_type", "owner_code", "adv_notice", "safety_hlth", "sic_code", "naics_code", "insp_type", "insp_scope", "why_no_insp", "union_status", "nr_in_estab", "open_date", "case_mod_date", "close_conf_date", "close_case_date", "ld_dt", "close_year", "noviol", "act_id", "citation_id", "delete_flag", "standard", "viol_type", "issuance_date", "abate_date", "abate_complete", "current_penalty", "initial_penalty", "contest_date", "final_order_date", "nr_instances", "nr_exposed", "rec", "gravity", "emphasis", "hazcat", "fta_insp_nr", "fta_issuance_date", "fta_penalty", "fta_contest_date", "fta_final_order_date", "hazsub1", "hazsub2", "hazsub3", "hazsub4", "hazsub5", "load_dt", .after = "close_year")))


#### Export the final dataset ####

write.csv(final, file = "1_Data_Creation_Cleaning/Cleaned_Data/prison_insp_viol_2010.csv", row.names = FALSE)
