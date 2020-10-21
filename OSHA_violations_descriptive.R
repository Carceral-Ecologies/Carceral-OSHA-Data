#### INTRO ####
# PURPOSE #
# The purpose of this script is to provide basic descriptive analysis of the OSHA violation dataset for California prisons from 2010 to 2019.

#### Packages to Install ####
# install.packages("plotly")
library("plotly")


#### Read in Data ####

viol = read.csv(file = "Cleaned_Data/prison_insp_viol_2010_op.csv", header = TRUE, stringsAsFactors = FALSE)

#### Convert from wide to long ####
  # creating count of violations for each activity number in order to reshape the data

violt = do.call(rbind, by(viol, viol$activity_nr, FUN = function(acn){
  acn$viol_count = 1:nrow(acn)
  return(acn)
}))

  # reshape to keep penalty only
  keepcolumns <- c("activity_nr", "current_penalty", "initial_penalty", "viol_count", "estab_name", "site_city", "site_zip")
  violk = violt[keepcolumns]
  
  violw = reshape(violk, idvar = "activity_nr", timevar = "viol_count", direction = "wide")
  
  # 316828490 - has 58 initial penalties 

  # at this point we could do another merge to include basic info from the inspection dataset again 
  
#### Descriptive stats for relevant variables ####

#### 1. What facilities are represented? State prisons? County? What is the distribution by state? ####
  # What states?
  table(viol$site_state)
  # 46 states
  
  # Owner type
  table(viol$owner_type)
  barplot(table(viol$owner_type))
  
  # These are states with only Federal OSHA coverage: 
  # TX - three are federal, one is private, no state prisons 
  # PA - two facilities both federal 
  # OH - REMOVED OH - ELECTRICAL Contractor 
    # AN = 	313787681
  # MS - one facility federal
  # GA - this is a contractor who builds jails - removed
    # AN = 315736637
    # the other is a federal prison 
  # FL - all federal 
  # CO - federal, one health care provider - private 
  # WV - all federal 
  # AL - all federal
  # AR - all federal
  # ID - one private
  # LA - all federal
  # MA - all federal
  # MO - one state, one federal
  # NH - one private
  # OK - all federal
  
  # NOTE: Compare how many private prisons there are in these states as point of comparison that they are not in here. 
  # These are states with plans that only cover state/local employees: 
  # IL - mix of fed, state, local - no private 
  # NY - no private 
  # NJ - AN = 	314730201 is a federal facility but listed as private under owner code - maybe contracted out? 
  # CT - no private 
  # VI - no private 
  
  # These are states with state plans covering both state and private employees:
  # (check means they have at least one private facility inspection)
  # AK
  # AZ
  # CA - check
  # HI
  # IA
  # KY
  # MD - check 
  # MI - check 
  # MN
  # NC - check
  # NM - check 
  # NV - check
  # OR - check 
  # PR - check 
  # SC
  # TN - check
  # UT
  # VA - check 
  # VT - check 
  # WA - check 
  # WY 
  
  
  # States Missing (they are all federal OSHA states):
  # DE
  # KS
  # MT
  # NE
  # ND 
  # RI
  # SD

  
  # Note: This means that federal OSHA is not doing their job in regards to prison H&S inspection in private facilities. We also have several federal OSHA states with no inspections from the last 10 years. 
  
  # What facilities? Are there any repeating?
  table(viol$site_city) - # This actually show number of citations by city
  table(viol$estab_name) # This actually shows number of citations by estab_name
  
  table(violw$site_city.1)  # This actually shows activities by city
  table(violw$estab_name.1) # This actually shows activities by estab_name
  table(violw$site_zip.1) # there are zipcodes with only three numbers
  
#### 2. Current Penalty ####
  #### 2a How many rows (citations) have no penalty attached? ####
  table(is.na(viol$current_penalty))
  # 3052 have no current penalty information
  # 2042 have a current penalty
  
  table(is.na(viol$initial_penalty))
  # 2251 have an initial penalty 
  # 2843 have no initial penalty

  #### 2b What is the distribution of penalties for all rows? ####
    summary(viol$current_penalty) 
      # mean =  819
      # median = 100
      # min = 0 
      # Max = 30000
    quantile(viol$current_penalty, na.rm = TRUE)
    table(viol$current_penalty)
    boxplot(viol$current_penalty)
    hist(viol$current_penalty, 15, freq = TRUE)  
    # the distribution is not normal. Majority of penalties are 0 and a few are very large, over 30,000
    # binning the data for cleaner distribution
    # based on quantiles
    breaks = c(-1, 0, 100, 700, 30000)
    bp = cut(viol$current_penalty, breaks, labels=c("0", "0-100", "100-700", ">700"))
    summary(bp)
    barplot(table(bp))
    
    # based on amounts
    breaks =  c(-1, 500, 1000, 10000, 30000)
    bp = cut(viol$current_penalty, breaks, labels = c("0-500", "500-1000", "1000-10000", ">10000"))
    summary(bp)
    barplot(table(bp), ylim = c(0, 726), title(main = "Current Penalty")) # error in code here bc some NA's
  
  #### 2c What is the distribution of penalties for each activity? Long Format ####
    
  ## What is the total penalty for each activity (long format)? (NA's Removed)
  violc = do.call(rbind, by(viol, viol$activity_nr, FUN = function(acn){
    acn$cptotal = sum(acn$current_penalty, na.rm = TRUE)
    return(acn)
  }))
  
  viol$total_penalty = violc$cptotal

  # Summary stats for current penalty?
  summary(viol[!duplicated(viol$activity_nr), "total_penalty"])
  # Min 0
  # Median 0 
  # Mean 1325.6 
  # Max 70500

  
  table(viol[!duplicated(viol$activity_nr),"total_penalty"])
  boxplot(viol[!duplicated(viol$activity_nr),"total_penalty"])
  hist(viol[!duplicated(viol$activity_nr),"total_penalty"])
  
  hist(viol[!duplicated(viol$activity_nr),"total_penalty"][viol[!duplicated(viol$activity_nr),"total_penalty"] != 0])
    # removed zeros 
  plot_ly(viol, x= ~total_penalty, type = "histogram")
  
  
  #### 2d Total penalty for the wide dataset - This is by activity number ####
  violw$curr_rowsums = rowSums(violw[, grepl("current_penalty", colnames(violw))], na.rm = TRUE)
  violw$init_rowsums = rowSums(violw[, grepl("initial_penalty", colnames(violw))], na.rm = TRUE)
  plot_ly(violw, x= ~curr_rowsums, type = "histogram")
  plot_ly(violw, x= ~init_rowsums, type = "histogram")
  
  fig_ct <- violw %>%
    plot_ly(
      y = ~curr_rowsums,
      type = 'violin',
      box = list(
        visible = T
      ),
      meanline = list(
        visible = T
      ),
      x0 = 'Current Penalty for Activity Number'
    ) 
  
  fig_ct <- fig_ct %>%
    layout(
      yaxis = list(
        title = "",
        zeroline = F
      )
    )
  
  fig_ct
  
  fig_it <- violw %>%
    plot_ly(
      y = ~init_rowsums,
      type = 'violin',
      box = list(
        visible = T
      ),
      meanline = list(
        visible = T
      ),
      x0 = 'Initial Penalty for Activity Number'
    ) 
  
  fig_it <- fig_it %>%
    layout(
      yaxis = list(
        title = "",
        zeroline = F
      )
    )
  
  fig_it
  
  
#### 2e Subset only those with penalties (drop zeros) ####
  table(as.logical(violw$init_rowsums >0.0))
    
  table(as.logical(violw$curr_rowsums >0.0))
  
# creates dataset for facilities that only have some initial penalty listed
  violw_no_init = violw[violw$init_rowsums > 0, ] 
  
  # creates visualization of initial penalty amount for facilties that had a penalty
  hist(violw_no_init$init_rowsums, freq = TRUE, breaks = 25)
  plot_ly(violw_no_init, x = ~init_rowsums, type = "histogram", histnorm = "percent", nbinsx = 75)

# creates dataset for facilities that only have some current penalty listed
  violw_no_curr = violw[violw$curr_rowsums > 0, ]
  

  fig_c <- violw_no_curr %>%
    plot_ly(
      y = ~curr_rowsums,
      type = 'violin',
      box = list(
        visible = T
      ),
      meanline = list(
        visible = T
      ),
      x0 = 'Current Penalty for Activity Numbers (Cases without Zeros)'
    ) 
  
  fig_c <- fig_c %>%
    layout(
      yaxis = list(
        title = "",
        zeroline = F
      )
    )
  
  fig_c
  
  fig_i <- violw_no_init %>%
    plot_ly(
      y = ~init_rowsums,
      type = 'violin',
      box = list(
        visible = T
      ),
      meanline = list(
        visible = T
      ),
      x0 = 'Initial Penalty for Activity Numbers (Cases without Zeros)'
    ) 
  
  fig_i <- fig_i %>%
    layout(
      yaxis = list(
        title = "",
        zeroline = F
      )
    )
  
  fig_i
  
  

#### 2f What level of variation is there between initial and current penalties? ####
violw_no_init$penalty_var = (violw_no_init$init_rowsums - violw_no_init$curr_rowsums)
violw_no_init$penalty_prop = (violw_no_init$curr_rowsums / violw_no_init$init_rowsums)
  
  fig_v <- violw_no_init %>%
    plot_ly(
      y = ~penalty_var,
      type = 'violin',
      box = list(
        visible = T
      ),
      meanline = list(
        visible = T
      ),
      x0 = 'Amount Facilities Did Not Pay (of those that had an initial penalty)'
    ) 
  
  fig_v <- fig_v %>%
    layout(
      yaxis = list(
        title = "",
        zeroline = F
      )
    )
  
  fig_v
  
  table(violw_no_init$penalty_prop)
  summary(violw_no_init$penalty_prop)
  # The mean proportion paid is 65% - so on average activities paid about 65% of the original penalty
  # The median was 75%
  # only 49 paid nothing or 14%
  # 162 paid the entire or 47% 
  
  fig_vp <- violw_no_init %>%
    plot_ly(
      y = ~penalty_prop,
      type = 'violin',
      box = list(
        visible = T
      ),
      meanline = list(
        visible = T
      ),
      x0 = 'Proportion of Initial Penalty Paid (of those that had an initial penalty)'
    ) 
  
  fig_vp <- fig_vp %>%
    layout(
      yaxis = list(
        title = "",
        zeroline = F
      )
    )
  
  fig_vp
  
#### I want to make a table that looks at initial penalty, current penalty, and proportion. I want to check if the ones who ended up paying the whole thing were more likely to be low penalities versus high penalites. ####
  
#### Maybe we should classify high offenders versus low ####
  
  
#### 3. What chemicals? ####
  
  table((viol$hazsub1))
  
  
#### 4. Gravity ####
 
   table(is.na(viol$gravity))

