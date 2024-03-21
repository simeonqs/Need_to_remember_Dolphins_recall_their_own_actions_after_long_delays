# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Loading data for prospective delay trials.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Libraries
library(tidyverse)
library(rethinking)

# Paths
path_data_prospective = 'analysis/data/data_prospective_delay.csv'

# Load data
dat_delay = read.csv(path_data_prospective)
dat_delay$Behaviour.marked[dat_delay$Behaviour.marked %in% 
                            c('clap', 'Clao')] = 'Clap'
dat_delay$Behaviour.marked[dat_delay$Behaviour.marked == 'fart'] = 'Fart'
dat_delay$Behaviour.marked = str_remove_all(dat_delay$Behaviour.marked, ' ')
dat_delay$Behaviour.offered = str_remove_all(dat_delay$Behaviour.offered, ' ')
dat_delay$Trainer.recall = ifelse(dat_delay$Trainer.recall %in% 
                                   c('Jhony', 'Johny'), 
                                 'Jhonny', dat_delay$Trainer.recall)

# Translate id's
trans_id  = c(Nemo = 1, Karina = 2, Lluvia = 3, Nouba = 4, Eva = 5)

# Colours
colours_animals = list(Nemo = '#DDCC77', # yellow
                       Karina = '#44AA99', # green
                       Lluvia = '#8D6E63', # brownish
                       Nouba = '#CC6677', # red
                       Eva = '#303F9F') # blueish

# Science colours
colours_animals$Nemo = '#CC0000'
colours_animals$Karina = '#000099'
