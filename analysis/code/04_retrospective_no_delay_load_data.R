# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Loads data for the retrospective with no delays trials.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'readxl', 'rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Paths
path_data = 'analysis/data/data_retrospective_no_delay.csv'

# Translations
trans_id  = c(Clara = 1, Ulisse = 2, Achille = 3) 
trans_beh = c(sing = 1, clap = 2, spin = 3, belly_up = 4) 

# Load data
dat_orig = read.csv2(path_data)
dat_orig$Animal = dat_orig$Animal %>% str_remove(' ')
dat_orig$Behaviour_1 = dat_orig$Behaviour_1 %>% 
  str_replace(' ', '_')
dat_orig$Behaviour_2 = dat_orig$Behaviour_2 %>% 
  str_replace(' ', '_')
dat_orig$Offered_1 = dat_orig$Offered_1 %>% 
  str_replace(' ', '_')
dat_orig$Offered_2 = dat_orig$Offered_2 %>% 
  str_replace(' ', '_')
dat = data.frame() # fix first two columns
for(i in 1:nrow(dat_orig)){
  for(j in 1:2){
    new = data.frame(animal = dat_orig$Animal[i],
                     session = dat_orig$Session[i],
                     behaviour = dat_orig[i,sprintf('Behaviour_%s', j)],
                     offered = dat_orig[i,sprintf('Offered_%s', j)])
    dat = rbind(dat, new)
  }
}
dat$offered[dat$offered %in% c('bellu_up')] = 'belly_up'
dat$offered[dat$offered %in% c('spim', 'apin')] = 'spin'
clean_dat_retrospective_no_delay = data.frame()
for(i in 2:nrow(dat)){
  if(dat$behaviour[i] == 'repeat' & dat$behaviour[i-1] != 'repeat'){
    new = data.frame(response = ifelse(dat$offered[i] == 
                                         dat$behaviour[i-1], 1L, 0L),
                     id = trans_id[dat$animal[i]],
                     beh = trans_beh[dat$behaviour[i-1]])
    clean_dat_retrospective_no_delay = rbind(clean_dat_retrospective_no_delay, new)
  }
}
