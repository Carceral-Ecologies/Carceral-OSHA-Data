library(dplyr)

CA_prison_insp_viol_2010_op <- prison_insp_viol_2010_op %>% filter_at(vars(site_state), any_vars(. %in% 'CA'))

CA_prison_insp_viol_2010_op

write.csv(CA_prison_insp_viol_2010_op, 'CA_prison_insp_viol_2010_op.csv')