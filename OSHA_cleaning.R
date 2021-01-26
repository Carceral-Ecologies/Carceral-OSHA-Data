#### About ####
# We already did a pass through using Openrefine. This script will further clean facility and addresses by removing special characters and other criteria. See Github issue #11. 

#### Load in Data ####
ca_viol = read.csv(file = "Cleaned_Data/CA_prison_insp_viol_2010_op.csv", header = TRUE, stringsAsFactors = FALSE)


#### Cleaning Facility Names ####

ca_viol$estab_name = gsub(",", " ", ca_viol$estab_name)
ca_viol$estab_name = gsub("\\.", "", ca_viol$estab_name)
ca_viol$estab_name = gsub("-", " ", ca_viol$estab_name)
ca_viol$estab_name = gsub("\\s?-\\s?", " ", ca_viol$estab_name)
ca_viol$estab_name = gsub("\\(", "", ca_viol$estab_name)
ca_viol$estab_name = gsub("\\)", "", ca_viol$estab_name)
ca_viol$estab_name = gsub("'", "", ca_viol$estab_name)
ca_viol$estab_name = gsub("\\/", " ", ca_viol$estab_name)
ca_viol$estab_name = gsub("#", "", ca_viol$estab_name)
ca_viol$estab_name = gsub("&", " AND ", ca_viol$estab_name)
ca_viol$estab_name = gsub("CALIFORNIA", "CA", ca_viol$estab_name)
ca_viol$estab_name = gsub("CALIF", "CA", ca_viol$estab_name)
ca_viol$estab_name = gsub("DEPARTMENT", "DEPT", ca_viol$estab_name)
ca_viol$estab_name = gsub("DEPTT", "DEPT", ca_viol$estab_name)
ca_viol$estab_name = gsub("REHABILITATION", "REHAB", ca_viol$estab_name)
ca_viol$estab_name = gsub("FORT", "FT", ca_viol$estab_name)
ca_viol$estab_name = gsub("\\s?  \\s?", " ", ca_viol$estab_name)
ca_viol$estab_name = gsub("SHERIFF ", "SHERIFFS ", ca_viol$estab_name)

# Standardize how CA Dept of Corrections appears. 
ca_viol$estab_name = gsub("STATE OF CA DEPT OF CORRECTIONS AND REHAB", "CA CORRECTIONS", ca_viol$estab_name)
ca_viol$estab_name = gsub("CA DEPT OF CORRECTIONS AND REHAB", "CA CORRECTIONS", ca_viol$estab_name)
ca_viol$estab_name = gsub("CA DEPT OF CORRECTION AND REHAB", "CA CORRECTIONS", ca_viol$estab_name)
ca_viol$estab_name = gsub("CA DEPT CORRECTIONS AND REHAB", "CA CORRECTIONS", ca_viol$estab_name)
ca_viol$estab_name = gsub("CA DEPT OF CORRECTIONS", "CA CORRECTIONS", ca_viol$estab_name)
ca_viol$estab_name = gsub("CA DEPT OF CORRECTION", "CA CORRECTIONS", ca_viol$estab_name) # NOT SURE IF SPACE NEEDED AFTER CORRECTION
ca_viol$estab_name = gsub("CA CORRECTION AND REHAB CENTER", "CA CORRECTIONS", ca_viol$estab_name)
ca_viol$estab_name = gsub("CA CORRECTIONS AND REHAB", "CA CORRECTIONS", ca_viol$estab_name)
ca_viol$estab_name = gsub("CA CORRECTION AND REHAB", "CA CORRECTIONS", ca_viol$estab_name)
ca_viol$estab_name = gsub("CA CORRECTIONS PIA", "CA CORRECTIONS", ca_viol$estab_name)

# Standardize Prison Industry Authority to CA Corrections 
ca_viol$estab_name = gsub("CA PRISON INDUSTRY AUTHORITY", "CA CORRECTIONS", ca_viol$estab_name)
ca_viol$estab_name = gsub("PRISON INDUSTRY AUTHORITY", "CA CORRECTIONS", ca_viol$estab_name)

# EVEN IF THIS WORKS STILL NEED TO DEAL WITH MERCED COUNTY, US DEPT OF JUSTICE FEDERAL ETC. PRISON INDUSTRY AUTHORITY
# check CA CORRECTIONS DIVISION OF ADULT PAROLE OPERATIONS - two different cities
# I need a way to identify "CA CORRECTIONS" only now and add city name at the end. 

trimws(ca_viol$estab_name, which = c("both"))

# Append city name onto facilities with generic name of CA Corrections 

ca_viol[grepl("^CA CORRECTIONS$", ca_viol$estab_name), "estab_name"] = paste0("CA CORRECTIONS ", ca_viol[grepl("^CA CORRECTIONS$", ca_viol$estab_name), "site_city"])




#### Cleaning addresses ####
ca_viol$site_address = gsub(",", " ", ca_viol$site_address)
ca_viol$site_address = gsub("\\.", "", ca_viol$site_address)
ca_viol$site_address = gsub("-", " ", ca_viol$site_address)
ca_viol$site_address = gsub("#", "", ca_viol$site_address)
ca_viol$site_address = gsub("&", " AND ", ca_viol$site_address)
ca_viol$site_address = gsub("\\(", "", ca_viol$site_address)
ca_viol$site_address = gsub("\\)", "", ca_viol$site_address)
ca_viol$site_address = gsub("STREET", "ST", ca_viol$site_address)
ca_viol$site_address = gsub("AVENUE", "AVE", ca_viol$site_address)
ca_viol$site_address = gsub("DRIVE", "DR", ca_viol$site_address)
ca_viol$site_address = gsub(" WEST ", " W ", ca_viol$site_address)
ca_viol$site_address = gsub(" SOUTH ", " S ", ca_viol$site_address)
ca_viol$site_address = gsub(" EAST ", " E ", ca_viol$site_address)
ca_viol$site_address = gsub(" NORTH ", " N ", ca_viol$site_address)
ca_viol$site_address = gsub("'", "", ca_viol$site_address)
ca_viol$site_address = gsub("ROAD", "RD", ca_viol$site_address)
ca_viol$site_address = gsub("BOULEVARD", "BLVD", ca_viol$site_address)
ca_viol$site_address = gsub("WSETERN", "WESTERN", ca_viol$site_address)
ca_viol$site_address = gsub("HIGHWAY", "HWY", ca_viol$site_address)
ca_viol$site_address = gsub("\\s?  \\s?", " ", ca_viol$site_address)
trimws(ca_viol$site_address, which = c("both"))

#### Export Long Data ####
# If you feel like it. Not fully cleaned yet. This is here as a record that we did export this data for some preliminary analysis.
# write.csv(ca_viol, 'Cleaned_Data/CA_prison_insp_viol_2010_op_fac.csv')

#### Convert to Wide Format by Facility Name ####

# format OSHA violations data to the facility level
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

#### Export Wide Data ####
# Exporting the data in wide format is needed to do the cleaning in the next step. Remove the # below to export the wide data pre-cleaning. There is also code below to export the wide data post-cleaning.

# write.csv(ca_violw, file = "Cleaned_data/CA_prison_insp_viol_2010_op_fac_wide.csv", row.names = FALSE)

#### Manual Cleaning of Facility Names ####
# After converting the data to wide format I found the following corrections needed to be made. 
# Method: I looked through the wide dataset. Sorted by zipcode. Then compared facility names with identical zipcodes and addresses. If they appeared to be similar but had slightly different names I renamed facilities to the titles that appeared in the HIFLD data. See the wiki for more information: https://github.com/Carceral-Ecologies/Caceral-OSHA-Data/wiki/Data-Quality
# These changes are made to the long dataset. 


ca_viol[which(ca_viol$activity_nr %in% c("312663560", "312664980", "312667173", "307189183")), "estab_name"] = "SOUTHERN YOUTH CORR RECEPTION CENTER / CLINIC"

ca_viol[which(ca_viol$activity_nr %in% c(312430754, 316673599, 316668193, 344157367, 314829672, 314827403)), "estab_name"] = "BARRY J NIDORF JUVENILE HALL"

ca_viol[which(ca_viol$activity_nr %in% c(314827866, 314827411, 340046242, 341570802)), "estab_name"] = "PITCHESS DETENTION CENTER"

ca_viol[which(ca_viol$activity_nr %in% c(119948990, 119956639, 125966499, 307459644, 316343821, 316344514, 316345032, 316345941, 316345958, 316346022, 316349117, 340482116, 341161818, 343378477, 343437901, 343457891, 343827929, 344303086, 343630547)), "estab_name"] = "CALIFORNIA INSTITUTION FOR MEN (CIM)"

ca_viol[which(ca_viol$activity_nr %in% c(343220042, 125916916, 342642238, 312677263, 312682768, 125943696)), "estab_name"] = "R J DONOVAN CORRECTIONAL FACILITY (RJD)"

ca_viol[which(ca_viol$activity_nr %in% c(343756508, 341733731, 316210749, 310603956, 313506123, 316214899, 343406914)), "estab_name"] = "CHUCKAWALLA VALLEY STATE PRISON (CVSP)"

ca_viol[which(ca_viol$activity_nr %in% c(316210749, 313506123, 343407045, 340803782, 343756607, 343815908, 344356415, 344437314)), "estab_name"] = "IRONWOOD STATE PRISON (ISP)"

ca_viol[which(ca_viol$activity_nr %in% c(310814918, 309918837, 312677370, 343217097)), "estab_name"] = "CENTINELA STATE PRISON (CEN)"

ca_viol[which(ca_viol$activity_nr %in% c(343253639, 331900134, 342080322, 343400230, 342082575, 331900563, 342082716, 331900639, 331900647, 342083243)), "estab_name"] = "USP VICTORVILLE"

ca_viol[which(ca_viol$activity_nr %in% c(310602537, 342426566, 316212216, 310604897, 316351022, 340198530, 341111151, 341207868)), "estab_name"] = "CALIFORNIA REHABILITATION CENTER (CRC)"

ca_viol[which(ca_viol$activity_nr %in% c(10602693, 340184837, 343700449, 343484002, 343836094, 341070795, 343284931, 310602693, 341110930, 343598462)), "estab_name"] = "CALIFORNIA INSTITUTION FOR WOMEN (CIW)"

ca_viol[which(ca_viol$activity_nr %in% c(316672393, 316668573, 316671932, 342452133)), "estab_name"] = "VENTURA YOUTH CORRECTIONAL FACILITY"

ca_viol[which(ca_viol$activity_nr %in% c(316720499, 300804663, 120146022, 341377265, 316725159, 344439153, 316723220, 300804663, 312915911, 341377265, 316725365, 344309661, 341128007, 315068387, 315070367, 315073551, 301124681, 310822689, 315073569, 315075218, 316723121, 316727247, 341520252, 341534782, 341835296, 342064854, 344217237, 310825237, 310825245, 316726223, 340449347)), "estab_name"] = "AVENAL STATE PRISON"

ca_viol[which(ca_viol$activity_nr %in% c(315072751, 316724319, 343678652, 342176336, 343068243, 344005046, 342116266)), "estab_name"] = "PLEASANT VALLEY STATE PRISON (PVSP)"

ca_viol[which(ca_viol$activity_nr %in% c(316727668 )), "estab_name"] = "DEPARTMENT OF STATE HOSPITALS - COALINGA"

ca_viol[which(ca_viol$activity_nr %in% c(315073080, 341701720, 312914443, 343147393, 342821162, 343282026, 341488237, 342178027, 343154118, 344110796, 315075911, 343054615, 316720143, 316721745, 316726363, 316727171, 340211010, 340945039, 341116101, 343147369, 343346706, 343820379, 343889846, 341552909, 342029709, 342175866, 342386653)), "estab_name"] = "CALIFORNIA STATE PRISON, CORCORAN (COR)"

ca_viol[which(ca_viol$activity_nr %in% c(341299816, 342633195, 316723899, 341642221, 342176047, 316723147, 344023932, 342335742, 342405651, 342482494, 343188793, 343012779, 343281853, 343309266, 343101721, 343256053, 343411567, 343728770, 344039482, 315075317, 343979746, 315069179, 315069187, 315074641, 315076737, 340458884, 340525294, 342155694, 342700671)), "estab_name"] = "CA SUBSTANCE ABUSE TREATMENT FACILITY (SATF)"


ca_viol[which(ca_viol$activity_nr %in% c(312433584, 313388605, 340002872, 314828179, 340058791, 340628544, 340770429)), "estab_name"] = "NORTH KERN STATE PRISON (NKSP)"

ca_viol[which(ca_viol$activity_nr %in% c(314822040, 340183193, 342545779, 314825316, 314829821, 314825324, 342382496)), "estab_name"] = "KERN VALLEY STATE PRISON (KVSP)"

ca_viol[which(ca_viol$activity_nr %in% c(313387631, 314822230, 313388407)), "estab_name"] = "WASCO STATE PRISON (WSP)"

ca_viol[which(ca_viol$activity_nr %in% c(316982446, 314828708, 341338572, 316982453, 341440592, 340168624, 343088555)), "estab_name"] = "CALIFORNIA MEN'S COLONY (CMC)"

ca_viol[which(ca_viol$activity_nr %in% c(316669449, 314824848, 316667955, 316670157, 340815794, 342850856, 343872222, 314822669, 316673276, 341666816, 341861607, 342611654)), "estab_name"] = "CALIFORNIA STATE PRISON-LOS ANGELES COUNTY (LAC)"

ca_viol[which(ca_viol$activity_nr %in% c(314823923, 341969095)), "estab_name"] = "CHALLENGER MEMORIAL YOUTH CENTER"

ca_viol[which(ca_viol$activity_nr %in% c(344267562, 313386476, 316981471, 316983220, 341233344, 341948297, 341591295, 312915796, 315068676, 315069096, 315070003, 315072496, 313388860)), "estab_name"] = "CALIFORNIA CORRECTIONAL INSTITUTION (CCI)"

ca_viol[which(ca_viol$activity_nr %in% c(315069054, 340324474, 342192143, 342189123, 342471323, 342430923)), "estab_name"] = "VALLEY STATE PRISON (VSP)"

ca_viol[which(ca_viol$activity_nr %in% c(343185179, 312913874, 310823653)), "estab_name"] = "CENTRAL CALIFORNIA WOMEN'S FACILITY (CCFW)"

ca_viol[which(ca_viol$activity_nr %in% c(339436370, 343061610, 343143749, 343634572)), "estab_name"] = "FCI MENDOTA CAMP"

ca_viol[which(ca_viol$activity_nr %in% c(316722867, 343828562, 344061163, 315069419, 342858529)), "estab_name"] = "FRESNO COUNTY MAIN DETENTION FACILITY"

ca_viol[which(ca_viol$activity_nr %in% c(343433355)), "estab_name"] = "FRESNO COUNTY JUVENILE JUSTICE CAMPUS"

ca_viol[which(ca_viol$activity_nr %in% c(314146275, 313481350, 314147489, 317200004, 315994657, 313480899, 313481111, 314146788, 316610724, 314147554, 317216745, 315364380, 314794355, 314794215, 316610914, 316734219, 316734227, 316805324, 316992650, 317077105, 317152080, 317200301, 317680635, 340182260, 340710250)), "estab_name"] = "SALINAS VALLEY STATE PRISON (SVSP)"

ca_viol[which(ca_viol$activity_nr %in% c(340300474, 314328808)), "estab_name"] = "SOLANO COUNTY JUVENILE DETENTION FACILITY"

ca_viol[which(ca_viol$activity_nr %in% c(315315416, 317202786, 342132560, 317205391, 342490018, 342756368)), "estab_name"] = "SANTA RITA JAIL"

ca_viol[which(ca_viol$activity_nr %in% c(335612602, 335245585, 335655007, 340642347, 340931518, 341171528, 341954238, 343004719)), "estab_name"] = "FCI DUBLIN"

ca_viol[which(ca_viol$activity_nr %in% c(335646626, 337062467, 337162986)), "estab_name"] = "FCI DUBLIN CAMP"

ca_viol[which(ca_viol$activity_nr %in% c(300751252, 342709201, 315830984, 300752367, 125475228, 125531889, 125479139, 125475350, 125540302, 300750007, 125540468, 125540526, 340921402, 341153112)), "estab_name"] = "SAN QUENTIN STATE PRISON (SQ)"

ca_viol[which(ca_viol$activity_nr %in% c(314146531, 341805232)), "estab_name"] = "ELMWOOD CORRECTIONAL COMPLEX"

ca_viol[which(ca_viol$activity_nr %in% c(314998907, 340596477, 316699974, 312579972, 314994526, 314999608, 316702620, 341395333, 316699982, 314994534, 316699982, 317785046, 316702919, 340886217, 342131208, 343927976)), "estab_name"] = "N.A. CHADERJIAN YOUTH CORRECTIONAL FACILITY"

ca_viol[which(ca_viol$activity_nr %in% c(340851864, 341207181, 316700723, 340078740, 340467612, 316702398, 340886209, 340577873, 341304046)), "estab_name"] = "CALIFORNIA HEALTH CARE FACILITY (CHCF)"

ca_viol[which(ca_viol$activity_nr %in% c(340468180, 341828259, 339927071)), "estab_name"] = "USP ATWATER"

ca_viol[which(ca_viol$activity_nr %in% c(341744688, 310417878, 340208263, 341190098, 312578644, 312580269, 342412657, 312580277, 314993965, 314999244, 314999251, 314995697, 314999269, 316704550, 316703446, 316704147)), "estab_name"] = "DEUEL VOCATIONAL INSTITUTION (DVI)"

ca_viol[which(ca_viol$activity_nr %in% c(316698869, 314992686, 341285310, 342072709, 343592119, 343446019, 343682910, 344102637)), "estab_name"] = "SIERRA CONSERVATION CENTER (SCC)"

ca_viol[which(ca_viol$activity_nr %in% c(314568577, 314532458, 317248557)), "estab_name"] = "PELICAN BAY STATE PRISON (PBSP)"

ca_viol[which(ca_viol$activity_nr %in% c(313234593, 314532474, 340146349, 316515022, 317245371)), "estab_name"] = "RICHARD A. MCGEE CORRECTIONAL TRAINING CENTER (CTC)"

ca_viol[which(ca_viol$activity_nr %in% c(312577562, 314995606, 314995614, 340475557, 341489698, 344074737, 312575830, 316700814)), "estab_name"] = "MULE CREEK STATE PRISON (MCSP)"

ca_viol[which(ca_viol$activity_nr %in% c(125826677, 341685345, 342039666, 316519974, 314533720, 340005883, 341391159)), "estab_name"] = "CALIFORNIA STATE PRISON, SACRAMENTO (SAC)"

ca_viol[which(ca_viol$activity_nr %in% c(313230005, 314536319, 314536301, 314568627, 317248680, 314536459, 316521392, 309370435, 313230732, 314428335, 341635647)), "estab_name"] = "FOLSOM STATE PRISON (FSP)"

ca_viol[which(ca_viol$activity_nr %in% c(311075717, 314323700, 314327545, 316818491, 341314698, 316821024, 314329236, 314328444, 314328451, 314332222, 314331398, 316816511, 316819937, 316821362, 311076079, 314332966, 314337841, 341153922)), "estab_name"] = "CALIFORNIA STATE PRISON, SOLANO (SOL)"

ca_viol[which(ca_viol$activity_nr %in% c(314337882, 314323965, 311074942, 316818509, 316819713, 316820398, 316821438, 314338039, 314332230, 316817071, 316818046, 316817345, 341257186, 316818764, 316819721, 316820802, 341534634, 314324575, 340480623)), "estab_name"] = "CALIFORNIA MEDICAL FACILITY (CMF)"

ca_viol[which(ca_viol$activity_nr %in% c(125827618, 125826990)), "estab_name"] = "DEVIL'S GARDEN CONSERVATION CAMP #40"

ca_viol[which(ca_viol$activity_nr %in% c(340955665, 313235210, 341586592, 125826107, 341550101, 343308193, 343383063)), "estab_name"] = "HIGH DESERT STATE PRISON (HDSP)"

ca_viol[which(ca_viol$activity_nr %in% c(341925386, 338990419, 342502341)), "estab_name"] = "HERLONG FCI CAMP"

ca_viol[which(ca_viol$activity_nr %in% c(343360590)), "estab_name"] = "FCI LOMPOC"

ca_viol[which(ca_viol$activity_nr %in% c(341236479)), "estab_name"] = "MERCED COUNTY JAIL"

ca_viol[which(ca_viol$activity_nr %in% c(341401230)), "estab_name"] = "JOHN LATORRACA CORRECTIONAL FACILITY"

ca_viol[which(ca_viol$activity_nr %in% c(343366332)), "estab_name"] = "CALIPATRIA STATE PRISON"

ca_viol[which(ca_viol$activity_nr %in% c(314759390)), "estab_name"] = "CA DEPT OF STATE HOSPITALS"

ca_viol[which(ca_viol$activity_nr %in% c(317253094)), "estab_name"] = "CA CORRECTIONS OFFICE OF BUSINESS SERVICES"

ca_viol[which(ca_viol$activity_nr %in% c(342979499)), "estab_name"] = "CA CORRECTIONS SAFETY CENTER"

ca_viol[which(ca_viol$activity_nr %in% c(342979499)), "estab_name"] = "CA CORRECTIONS HUMAN RESOURCES"


#### Convert new cleaned facility names to wide format ####

# reshape by facility name
# format OSHA violations data to the facility level
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


#### Export Wide Data ####
# Exporting the data in wide format to verify cleaning

write.csv(ca_violw, file = "Cleaned_data/CA_prison_insp_viol_2010_op_fac_wide.csv", row.names = FALSE)



#### Manual Cleaning of Addresses ####
# change address "US PENITENTIARY13777 AIR EXPRESSWAY BLVD" AND "FCI VICTORVILLE MEDIUM II13777 AIR EXPRESSWAY" to "13777 AIR EXPRESSWAY BLVD"
# rename "14901 S CENTRAL AVE" to "14901 CENTRAL AVE"






