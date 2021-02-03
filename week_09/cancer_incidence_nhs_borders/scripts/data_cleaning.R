library(tidyverse)
library(janitor)
library(here)

# Read in cancer incidence data
# Downloaded from: https://www.opendata.nhs.scot/dataset/annual-cancer-incidence/resource/3aef16b7-8af6-4ce0-a90b-8a29d6870014
cancer_incidence_data <- read_csv(here("data_raw/cancer_incidence_by_hb_raw.csv")) %>% 
  clean_names()


# Read in geography codes and labels
# Downloaded from: https://www.opendata.nhs.scot/dataset/9f942fdb-e59e-44f5-b534-d6e17229cc7b/resource/652ff726-e676-4a20-abda-435b98dd7bdc/download/geography_codes_and_labels_hb2014_01042019.csv
geography_codes_labels <- read_csv(here("data_raw/geography_codes_and_labels_hb2014_01042019.csv")) %>% 
  clean_names()


# Add health board name to incidence data
cancer_incidence_data <- 
  inner_join(cancer_incidence_data, geography_codes_labels, by = "hb") %>%
  select(id,
         hb,
         hb_name,
         cancer_site_icd10code,                   
         cancer_site,                             
         sex,                                     
         sex_qf,                                  
         year,                                    
         incidences_all_ages,                     
         crude_rate,                              
         crude_rate_lower95pc_confidence_interval,
         crude_rate_upper95pc_confidence_interval,
         easr,                                    
         easr_lower95pc_confidence_interval,      
         easr_lower95pc_confidence_interval_qf,   
         easr_upper95pc_confidence_interval,      
         easr_upper95pc_confidence_interval_qf,   
         wasr,                                    
         wasr_lower95pc_confidence_interval,      
         wasr_lower95pc_confidence_interval_qf,   
         wasr_upper95pc_confidence_interval,      
         wasr_upper95pc_confidence_interval_qf,   
         standardised_incidence_ratio,            
         sir_lower95pc_confidence_interval,       
         sir_upper95pc_confidence_interval)
  
# Rename hb code column
cancer_incidence_data <- cancer_incidence_data %>% 
rename("hb_code" = "hb")

# Save output as csv in clean_data folder
write_csv(cancer_incidence_data, here("data_clean/cancer_incidence_data.csv"))

# Drop data items from environment
rm(cancer_incidence_data, geography_codes_labels)




# Read in population estimate data
# Downloaded from: https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/population/population-estimates/mid-year-population-estimates/population-estimates-time-series-data

population_estimates <- 
  read_csv(here("data_raw/mid_year_pop_est_19_time_series_4_1981_2019.csv"))

# Pivot wider - create year and population_estimate columns
population_estimates <- population_estimates %>% 
  pivot_longer(cols = "1981":"2019",
               names_to = "year",
               values_to = "population_estimate",)

# Save population output as csv in clean_data folder
write_csv(population_estimates, here("data_clean/population_estimates.csv"))

# Drop population data item from environment
rm(population_estimates)



# Read in data dictionary
data_dictionary <- 
  read_csv(here("data_raw/data_dictionary.csv"))

# Save data dictionary as csv in clean_data folder
write_csv(data_dictionary, here("data_clean/data_dictionary.csv"))

# Drop data dictionary data item from environment
rm(data_dictionary)