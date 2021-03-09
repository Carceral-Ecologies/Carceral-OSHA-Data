#### About ####
# This file looks at initial and current penalties for prisons in cA

#### Load in Packages ####
library(tidyverse)

#### Load in Data ####
caprisons = read.csv(file = "Cleaned_Data/CA_OSHA_prison_insp_viol_2010_2019_cleaned_long.csv", header = TRUE, stringsAsFactors = FALSE)

#### Variable Creation ####
## Total Initial Penalty for Establishments (Long) ####

caprisons = do.call(rbind, by(caprisons, caprisons$estab_name, FUN = function(estb){
  estb$iptotal = sum(estb$initial_penalty, na.rm = TRUE)
  return(estb)
}))

## Total Current Penalty for Establishments Long) ####

caprisons = do.call(rbind, by(caprisons, caprisons$estab_name, FUN = function(estb){
  estb$cptotal = sum(estb$current_penalty, na.rm = TRUE)
  return(estb)
}))

## Average Initial Penalty for Establishments (Long) ####
caprisons = do.call(rbind, by(caprisons, caprisons$estab_name, FUN = function(estb){
  estb$ipavg = mean(estb$initial_penalty, na.rm = TRUE)
  return(estb)
}))

## Average Current Penalty for Establishments (Long) ####
caprisons = do.call(rbind, by(caprisons, caprisons$estab_name, FUN = function(estb){
  estb$cpavg = mean(estb$current_penalty, na.rm = TRUE)
  return(estb)
}))


## Create Categorical Initial Penalty Variable by Violation (Long) ####
# This document provides some guidance on low, medium, and high violations
# https://www.osha.gov/sites/default/files/2020-01/20200110124448588.pdf 

caprisons$ip_cut = cut(caprisons$initial_penalty, 
                       c(-1, 1, 5783, 11566, 22500),
                       dig.lab = 5) # stops scientific notation


caprisons$ip_factor = factor(caprisons$ip_cut,
                             labels = c("None", "Low", "Medium", "High"),
                             exclude = NA)

## Create Categorical Current Penalties Variable by Violation (Long) ####
caprisons$cp_cut = cut(caprisons$current_penalty, 
                     c(-1, 1, 5783, 11566, 22500),
                     dig.lab = 5) # stops scientific notation


caprisons$cp_factor = factor(caprisons$cp_cut,
                           labels = c("None", "Low", "Medium", "High"),
                           exclude = NA)


## Create Categorical Average Initial Penalties Variable by Violation (Long) ####

caprisons$ipavg_cut = cut(caprisons$ipavg, 
                          c(-1, 1, 5783, 11566, 22500),
                          dig.lab = 5) # stops scientific notation


caprisons$ipavg_factor = factor(caprisons$ipavg_cut,
                                labels = c("None", "Low", "Medium", "High"),
                                exclude = NA)


##  Create Categorical Average Current Penalties Variable by Violation (Long) ####

caprisons$cpavg_cut = cut(caprisons$cpavg, 
                          c(-1, 1, 5783, 11566, 22500),
                          dig.lab = 5) # stops scientific notation


caprisons$cpavg_factor = factor(caprisons$cpavg_cut,
                                labels = c("None", "Low", "Medium", "High"),
                                exclude = NA)

## Create Categorical Total Initial Penalties Variable by Violation (Long) ####

caprisons$ipt_cut = cut(caprisons$iptotal, 
                          c(-1, 1, 5783, 11566, 22500),
                          dig.lab = 5) # stops scientific notation


caprisons$ipt_factor = factor(caprisons$ipt_cut,
                                labels = c("None", "Low", "Medium", "High"),
                                exclude = NA)


## Create Categorical Current Initial Penalties Variable by Violation (Long) ####

caprisons$cpt_cut = cut(caprisons$cptotal, 
                        c(-1, 1, 5783, 11566, 22500),
                        dig.lab = 5) # stops scientific notation


caprisons$cpt_factor = factor(caprisons$cpt_cut,
                              labels = c("None", "Low", "Medium", "High"),
                              exclude = NA)


## Penalty Decreases ####

  # For each violation
  caprisons$dpenalty = (caprisons$initial_penalty) - (caprisons$current_penalty)

  # For the total of penalties for facilities
  caprisons$dtpenalty = (caprisons$iptotal) - (caprisons$cptotal)

## Reshape to Wide ####

# creating count of violations for each activity number in order to reshape the data
caprisons = do.call(rbind, by(caprisons, caprisons$estab_name, FUN = function(estb){
  estb$estab_count = 1:nrow(estb)
  return(estb)
}))

# reshape by facility name
keepcolumns <- c("activity_nr", "estab_name", "estab_count", "initial_penalty", "current_penalty", "cptotal", "iptotal", "dtpenalty", "ip_cut", "cp_cut", "ip_factor", "cp_factor", "ipavg", "cpavg", "ipt_cut", "cpt_cut", "ipt_factor", "cpt_factor")
caprisonsk = caprisons[keepcolumns]
caprisonsw = reshape(caprisonsk, idvar = "estab_name", timevar = "estab_count", direction = "wide")







#### Data Exploration ####

# see guide - https://r4ds.had.co.nz/exploratory-data-analysis.html#variation

# boxplot for each variable 

# combined histogram with current and initial 

# this is by facility. It might be interesting to ask how initial and current penalty info for each investigation (activity number)

# maybe it makes sense to make this a categorical variable because we have chunks of specific penalties and gaps between penalty amounts. This really isn't an interval ratio variable. Figure out how to do this.

# maybe I need to calculate the initial penalty for each facility by activity number. BC using the decrease between iptotal and cptotal is a bit misleading because a facility could have a decrease overall but still have paid from a specific investigation. Maybe not actually. 

# might look at biggest violators

## Initial Penalties ####
# summary stats initial penalty for all establishments
  summary(caprisonsw$iptotal.1) # median is 420
  table(caprisonsw$iptotal.1) # 62 zeros or ~42%
  table(is.na(caprisonsw$iptotal.1)) # no na's 

# the distribution of initial penalties
  ggplot(data = caprisonsw) + geom_histogram(mapping = aes(x = iptotal.1), binwidth = 5000)

    # limit dist to X penalty size
    caprisonsw2 = caprisonsw %>% filter(iptotal.1 < 2500)
    ggplot(data = caprisonsw2) + geom_histogram(mapping = aes(x = iptotal.1), binwidth = 250)
    
    # limit dist to non-zeros
    caprisonswn0 = caprisonsw %>% filter(iptotal.1 != 0)
    summary(caprisonswn0$iptotal.1) # median is 5245
    ggplot(data = caprisonswn0) + geom_histogram(mapping = aes(x = iptotal.1), binwidth = 2000)
    
    # limit dist to non-zero and with 25,000
    caprisonswn025 = caprisonsw %>% filter(iptotal.1 != 0 & iptotal.1 < 25000)
    summary(caprisonswn025$iptotal.1) # median is 2690 
    ggplot(data = caprisonswn025) + geom_histogram(mapping = aes(x = iptotal.1), binwidth = 1000)
    

  
## Current Penalties ####
# summary stats current penalty for all establishments
  summary(caprisonsw$cptotal.1) # median is 320
  table(caprisonsw$cptotal.1) # 65 zeros or ~44%
  table(is.na(caprisonsw$iptotal.1)) # no na's 
  
# the distribution of current penalties
  ggplot(data = caprisonsw) + geom_histogram(mapping = aes(x = cptotal.1), binwidth = 1000)

    # limit dist to X penalty size
    caprisonsw3 = caprisonsw %>% filter(cptotal.1 < 2500)
    ggplot(data = caprisonsw3) + geom_histogram(mapping = aes(x = cptotal.1), binwidth = 250)
    
    # limit dist to non-zeros
    caprisonsw3n0 = caprisonsw %>% filter(cptotal.1 != 0)
    summary(caprisonsw3n0$cptotal.1) # median is 3140
    ggplot(data = caprisonsw3n0) + geom_histogram(mapping = aes(x = cptotal.1), binwidth = 2000)
    
    # limit dist to non-zero and with 25,000
    caprisonsw3n025 = caprisonsw %>% filter(cptotal.1 != 0 & cptotal.1 < 25000)
    summary(caprisonsw3n025$cptotal.1) # median is 2387.5
    ggplot(data = caprisonsw3n025) + geom_histogram(mapping = aes(x = cptotal.1), binwidth = 1000)
    
# categorical distribution of current penalties
    
  
## Penalty Decreases ####

 # summary stats current penalty for all establishments
  summary(caprisonsw$dtpenalty.1) # median is 0
  table(caprisonsw$dtpenalty.1) # 91 zeros or ~60% had no decrease
  table(is.na(caprisonsw$dtpenalty.1)) # no na's 
    
# the distribution of penalty decreases
  ggplot(data = caprisonsw) + geom_histogram(mapping = aes(x = dtpenalty.1), binwidth = 1000)

    # limit dist to non-zeros
    caprisonsw4n0 = caprisonsw %>% filter(dtpenalty.1 != 0)
    summary(caprisonsw4n0$dtpenalty.1) # median is 4072
    ggplot(data = caprisonsw4n0) + geom_histogram(mapping = aes(x = dtpenalty.1), binwidth = 2500)


## facilities with current penalties ####

table(caprisonsw$estab_name, caprisonsw$cptotal.1)

## Distribution of Low, Medium, and High Penalties by Violations ####
   
  # Current Penalties 
    # summary stats current penalty factor - rows are violations
    summary(caprisons$cp_factor) # 172 0's
    table(is.na(caprisons$cp_factor)) # 388 nas
    
    # the distribution of current penalties - rows are violations
    ggplot(data = caprisons) + geom_bar(mapping = aes(x = cp_factor))
    
    # limit dist to non-zeros
    caprisons_cpfn0 = caprisons %>% filter(cp_factor != "None")
    ggplot(data = caprisons_cpfn0) + geom_bar(mapping = aes(x = cp_factor))
    
  # Initial Penalties 
    # summary stats initial penalty factor - rows are violations
    summary(caprisons$ip_factor) # 134 0's
    table(is.na(caprisons$ip_factor)) # 307 nas
    
    # the distribution of current penalties - rows are violations
    ggplot(data = caprisons) + geom_bar(mapping = aes(x = ip_factor))
    
    # limit dist to non-zeros
    caprisons_ipfn0 = caprisons %>% filter(ip_factor != "None")
    ggplot(data = caprisons_ipfn0) + geom_bar(mapping = aes(x = ip_factor))
  
  
## Distribution of Low, Medium, and High Penalties by Facility #### 
  
  # Current Penalties 
    # summary stats current penalty factor - rows are facilities
    summary(caprisonsw$cpt_factor.1) # 65 0's
    table(is.na(caprisonsw$cpt_factor.1)) # 10 nas
    
    # the distribution of current penalties - rows are facilities
    ggplot(data = caprisonsw) + geom_bar(mapping = aes(x = cpt_factor.1))
    
    # limit dist to non-zeros
    caprisonsw_cptfn0 = caprisonsw %>% filter(cpt_factor.1 != "None")
    ggplot(data = caprisonsw_cptfn0) + geom_bar(mapping = aes(x = cpt_factor.1))
    
  # Initial Penalties 
    # summary stats initial penalty factor - rows are facilities
    summary(caprisonsw$ipt_factor.1) # 62 0's
    table(is.na(caprisonsw$ipt_factor.1)) # 18 nas
    
    # the distribution of current penalties - rows are facilities
    ggplot(data = caprisonsw) + geom_bar(mapping = aes(x = ipt_factor.1))
    
    # limit dist to non-zeros
    caprisonsw_iptfn0 = caprisonsw %>% filter(ip_factor.1 != "None")
    ggplot(data = caprisonsw_iptfn0) + geom_bar(mapping = aes(x = ipt_factor.1))
    
  