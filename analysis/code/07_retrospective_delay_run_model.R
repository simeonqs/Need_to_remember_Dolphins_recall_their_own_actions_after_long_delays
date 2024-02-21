# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Running model.  
# source('ANALYSIS/CODE/01_run_model.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Paths
path_source_data = 'analysis/code/06_retrospective_delay_load_data.R'
path_m_retrospective_delay = 'analysis/results/m_retrospective_delay.RData'

# Set seed to get the same outcome
set.seed(1)

# Load data
source(path_source_data)

# Run model
set_ulam_cmdstan(TRUE)
m_retrospective_delay = ulam(
  alist(
    response ~ dbinom(1, p),
    logit(p) <- 
      (a_bar + 
         z_id[id] * sigma_id + 
         z_beh[beh] * sigma_beh) -
      (b_bar + 
         zb_id[id] * sigma_id_b +
         zb_beh[beh] * sigma_beh_b) * log_time,
    a_bar ~  normal(-1, 2),
    z_id[id] ~ normal(0, 1),
    z_beh[beh] ~ normal(0, 1),
    b_bar ~ exponential(1),
    zb_id[id] ~ normal(0, 1),
    zb_beh[beh] ~ normal(0, 1),
    sigma_id ~ dexp(2),
    sigma_id_b ~ dexp(2),
    sigma_beh ~ dexp(2),
    sigma_beh_b ~ dexp(2),
    gq> vector[id]: a_ind <<- a_bar + z_id * sigma_id,
    gq> vector[beh]: a_beh <<- a_bar + z_beh * sigma_beh
  ), data = clean_dat, chains = 4, cores = 4, iter = 4000, warmup = 500)
print(precis(m_retrospective_delay))

# Save and message
post = extract.samples(m_retrospective_delay)
cross = (logit(1/4) - post$a_bar) / -post$b_bar
message(sprintf(
  'median crossing chance: %ssec; lower bound 89%% PI: %ssec',
  round(2^median(cross), 0),
  round(2^PI(cross)[1], 0)))
save(m_retrospective_delay, clean_dat, post, file = path_m_retrospective_delay)
message('Saved model.')



# Report for paper
print(precis(post))

# Test cross chance-level
times = log2(seq(0, 20, 0.01))
cross = sapply(1:length(post$a_bar), function(i){
  means = inv_logit( post$a_bar[i] + post$b_bar[i] * times )
  return(times[which(means < 0.25)][1])
})
dens(cross)
mean(cross)
