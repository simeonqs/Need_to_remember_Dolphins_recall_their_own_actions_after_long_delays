# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Loading data retrospective trials with delays.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'readxl')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Paths
path_data = 'analysis/data/data_retrospective_delay.csv'

# Translations
trans_id  = c(Clara = 1, Ulisse = 2, Achille = 3) 
trans_beh = c(canto = 1, aplauso = 2, giro = 3, belly_up = 4) 

# Load data 
dolphin_data = read.csv2(path_data)
dolphin_data = dolphin_data[dolphin_data$delay > 0,] # 0 delays were a mistake 
dolphin_data$b1 = dolphin_data$b1 %>% str_replace(' ', '_') 
dolphin_data$b2 = dolphin_data$b2 %>% str_replace(' ', '_') 
clean_dat = data.frame(id = trans_id[dolphin_data$Animal],
                       beh = trans_beh[dolphin_data$b1],
                       response = ifelse(dolphin_data$correct.or.not.2 == 'c', 
                                         1, 0),
                       ## adding 0.5 for handling time
                       log_time = log2(dolphin_data$delay + 0.5))
