CA_prison <- CA_prison_insp_viol_2010_op

Initial_penalty <- CA_prison$initial_penalty
Current_penalty <- CA_prison$current_penalty

NA_CA_prison_initial <- subset(CA_prison, is.na(CA_prison$initial_penalty))

NA_CA_prison_current <- subset(CA_prison, is.na(CA_prison$current_penalty))

max_initial_penalty_CA_prison <- CA_prison[which.max(CA_prison$initial_penalty),]

max_current_penalty_CA_prison <- CA_prison[which.max(CA_prison$current_penalty),]