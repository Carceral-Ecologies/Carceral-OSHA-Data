#Look at current penalty
#   Summary stats
#   Look at biggest penalties - where are they?
#   How much are missing info?
#   How many had initial penalties but no current? 
#   How many had no initial penalty? 
# Initial penalty versus current penalty
#   How much of a "discount" did activity numbers get? 
#   How many started with a penalty but did not pay anything? 
#   How much are missing data?
#   How many contested? Is there a relationship between contesting and not paying a penalty? 



CA_prison <- CA_prison_insp_viol_2010_op

Initial_penalty <- CA_prison$initial_penalty
Current_penalty <- CA_prison$current_penalty

NA_CA_prison_initial <- subset(CA_prison, is.na(CA_prison$initial_penalty))

NA_CA_prison_current <- subset(CA_prison, is.na(CA_prison$current_penalty))

max_initial_penalty_CA_prison <- CA_prison[which.max(CA_prison$initial_penalty),]

max_current_penalty_CA_prison <- CA_prison[which.max(CA_prison$current_penalty),]

nrow(NA_CA_prison_current)
nrow(NA_CA_prison_initial)