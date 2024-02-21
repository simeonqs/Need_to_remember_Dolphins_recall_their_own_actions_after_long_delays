# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Running the models test vs control dolphins. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Paths
path_source_data_delay = 'analysis/code/00_prospective_delay_load_data.R'
path_source_data_control = 'analysis/code/02_prospective_control_load_data.R'
path_ms_prospective_control = 'analysis/results/ms_prospective_control.RData'

# Load data
source(path_source_data_delay)
source(path_source_data_control)

# Cleaning the data - subsetting for phase 0
dat = dat_delay
dat = dat[!is.na(dat$Animal),]
dat = dat[dat$Phase == 0,]
clean_dat = data.frame(response = ifelse(dat$Behaviour.marked == 
                                           dat$Behaviour.offered, 1L, 0L),
                       id = trans_id[dat$Animal], 
                       loc = 1)
trans_behaviour = 1:length(unique(dat$Behaviour.marked))
names(trans_behaviour) = unique(dat$Behaviour.marked)
clean_dat$beh = trans_behaviour[dat$Behaviour.marked]

# Cleaning the data - subsetting
dat = dat_control
dat = dat[!is.na(dat$Animal),]
dat = dat[dat$Phase == 0,]
clean_dat_con = data.frame(response = ifelse(dat$Behaviour.marked == 
                                               dat$Behaviour.offered, 1L, 0L),
                           id = 6, 
                           loc = 2)
trans_behaviour = 1:length(unique(dat$Behaviour.marked))
names(trans_behaviour) = unique(dat$Behaviour.marked)
clean_dat_con$beh = trans_behaviour[dat$Behaviour.marked] + max(clean_dat$beh)

# Merge data
clean_dat_0 = rbind(clean_dat, clean_dat_con)

# Running model
set_ulam_cmdstan(TRUE)
m_prospective_control_0 <- ulam(
  alist(
    response ~ dbinom(1, p),
    logit(p) <- a_bar + 
      z_loc[loc] * sigma_loc +
      z_id[id] * sigma_id + 
      z_beh[beh] * sigma_beh,
    a_bar ~  normal(-0.7, 1.5),
    z_loc[loc] ~ normal(0, 1),
    z_id[id] ~ normal(0, 1),
    z_beh[beh] ~ normal(0, 1),
    sigma_loc ~ dexp(1),
    sigma_id ~ dexp(1),
    sigma_beh ~ dexp(2),
    gq> vector[loc]: a_loc <<- a_bar + z_loc * sigma_loc,
    gq> vector[id]: a_ind <<- a_bar + z_id * sigma_id,
    gq> vector[beh]: a_beh <<- a_bar + z_beh * sigma_beh
  ), data = clean_dat_0, chains = 4, cores = 4, iter = 8000, warmup = 500)
post_prospective_control_0 = extract.samples(m_prospective_control_0)
print(precis(m_prospective_control_0, depth = 2))

# Cleaning the data - subsetting for phase 3
dat = dat_delay
dat = dat[!is.na(dat$Animal),]
dat = dat[dat$Phase == 3,]
clean_dat = data.frame(response = ifelse(dat$Behaviour.marked == 
                                           dat$Behaviour.offered, 1L, 0L),
                       id = trans_id[dat$Animal], 
                       loc = 1)
trans_behaviour = 1:length(unique(dat$Behaviour.marked))
names(trans_behaviour) = unique(dat$Behaviour.marked)
clean_dat$beh = trans_behaviour[dat$Behaviour.marked]

# Cleaning the data - subsetting
dat = dat_control
dat = dat[!is.na(dat$Animal),]
dat = dat[dat$Phase == 3,]
clean_dat_con = data.frame(response = ifelse(dat$Behaviour.marked == 
                                               dat$Behaviour.offered, 1L, 0L),
                           id = 6, 
                           loc = 2)
trans_behaviour = 1:length(unique(dat$Behaviour.marked))
names(trans_behaviour) = unique(dat$Behaviour.marked)
clean_dat_con$beh = trans_behaviour[dat$Behaviour.marked] + max(clean_dat$beh)

# Merge data
clean_dat_3 = rbind(clean_dat, clean_dat_con)

# Running model
set_ulam_cmdstan(TRUE)
m_prospective_control_3 <- ulam(
  alist(
    response ~ dbinom(1, p),
    logit(p) <- a_bar + 
      z_loc[loc] * sigma_loc +
      z_id[id] * sigma_id + 
      z_beh[beh] * sigma_beh,
    a_bar ~  normal(-0.7, 1.5),
    z_loc[loc] ~ normal(0, 1),
    z_id[id] ~ normal(0, 1),
    z_beh[beh] ~ normal(0, 1),
    sigma_loc ~ dexp(1),
    sigma_id ~ dexp(1),
    sigma_beh ~ dexp(2),
    gq> vector[loc]: a_loc <<- a_bar + z_loc * sigma_loc,
    gq> vector[id]: a_ind <<- a_bar + z_id * sigma_id,
    gq> vector[beh]: a_beh <<- a_bar + z_beh * sigma_beh
  ), data = clean_dat_3, chains = 4, cores = 4, iter = 8000, warmup = 500)
post_prospective_control_3 = extract.samples(m_prospective_control_3)
print(precis(m_prospective_control_3, depth = 2))

# Save 
save(post_prospective_control_0, clean_dat_0,
     post_prospective_control_3, clean_dat_3,
     file = path_ms_prospective_control)
diff_0 = post_prospective_control_0$a_loc[,2] - 
  post_prospective_control_0$a_loc[,1]
diff_3 = post_prospective_control_3$a_loc[,2] - 
  post_prospective_control_3$a_loc[,1]
message(sprintf('Average log-odds difference between test and control group 
                at phase 0 (60 sec delay): %s; 89%% PI = %s, %s; 
                at phase 3 (2h delay): %s; 89%% PI = %s, %s',
                round(mean(diff_0), 2),
                round(PI(diff_0)[1], 2),
                round(PI(diff_0)[2], 2),
                round(mean(diff_3), 2),
                round(PI(diff_3)[1], 2),
                round(PI(diff_3)[2], 2)))
message('Saved models.')

