# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Loading data for the enactment effect trials.  
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Libraries
library(tidyverse)
library(rethinking)

# Paths
path_dat_without_action = 
  'analysis/data/data_enactment_effect_without_action.csv'
path_dat_with_action = 
  'analysis/data/data_enactment_effect_with_action.csv'

# Translate id's
trans_id  = c(Achille = 1, Ulisse = 2)

# Load data
dat_without_action = read.csv2(path_dat_without_action) 
dat_without_action$correct = ifelse(dat_without_action$Behaviour.marked == 
                                      dat_without_action$Behaviour.offered, 
                                    1L, 0L)
dat_with_action = read.csv(path_dat_with_action)
dat_with_action$correct = ifelse(dat_with_action$Behaviour.marked == 
                                   dat_with_action$Behaviour.offered, 
                                 1L, 0L)

clean_dat_1 = data.frame(response = dat_without_action$correct[
  dat_without_action$Phase == 1],
  id = trans_id[dat_without_action$Animal[
    dat_without_action$Phase == 1]] %>% as.numeric,
  experiment = 1, # without action
  phase = 1) # without action, 10 seconds
clean_dat_2 = data.frame(response = dat_without_action$correct[
  dat_without_action$Phase == 2],
  id = trans_id[dat_without_action$Animal[
    dat_without_action$Phase == 2]] %>% as.numeric,
  experiment = 1, # without action
  phase = 2) # without action, 60 seconds
clean_dat_3 = data.frame(response = dat_with_action$correct[
  dat_with_action$Phase == 1],
  id = trans_id[dat_with_action$Animal[
    dat_with_action$Phase == 1]] %>% as.numeric,
  experiment = 2, # with action
  phase = 3) # with action, 10 seconds
clean_dat_4 = data.frame(response = dat_with_action$correct[
  dat_with_action$Phase == 2],
  id = trans_id[dat_with_action$Animal[
    dat_with_action$Phase == 2]] %>% as.numeric,
  experiment = 2, # with action
  phase = 4) # with action, 60 seconds
clean_dat = rbind(clean_dat_1, clean_dat_2, clean_dat_3, clean_dat_4)
