This folder includes several cleaned datasets that are created using the code in the 1_Data_Creation_Cleaning folder. Several of the datasets are combined using code in the same folder.

1. Prisons_inspections_2010 included prisons that have inspection data between 2010 and late 2019.
2. Prison_violations_2010 includes prisons violation data. Some prisons may only have inspection information but no violation information.
3. Prison_violation_event_2010 includes prisons violation event data.
4. Prison_related_activity_2010 includes prisons related activity data.
5. Prison_insp_viol_2010 is a dataset that merges datasets 1-4.
6. Prison_insp_viol_2010_op is a cleaned data file of the original prison_insp_viol_2010 data. The following columns were cleaned using openrefine - city, address, and establishment name.
7. CA_prison_insp_viol_2010_op filters dataset 6 to only include CA prisons.
8. CA_prions_insp_viol_op_fac_long is a final cleaned version of dataset 7. This data is the final version with cleaned facility names in the long format.
9. CA_prions_insp_viol_op_fac_wide is a final cleaned version of dataset 7. This data is the final version with cleaned facility names in the wide format.

The HIFLD_data Folder includes data from the HIFLD. This data of prisons in CA was used to help clean the facility names. 

The Files_for_facility_name_cleaning folder is a location where partially cleaned files can be stored. This folder was particularly useful in creating dataset 8 because cleaning the facility names was an iterative process involving exporting the data and inspecting facility names multiple times.