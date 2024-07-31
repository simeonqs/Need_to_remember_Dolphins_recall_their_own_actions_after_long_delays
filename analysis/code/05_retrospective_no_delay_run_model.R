# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Running model for the single repeats.  
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Paths
path_source_data = 'analysis/code/04_retrospective_no_delay_load_data.R'
path_retrospective_no_delay = 'analysis/results/m_retrospective_no_delay.RData'

# Load data
source(path_source_data)

# Run model
set_ulam_cmdstan(TRUE)
m_retrospective_no_delay = ulam(
  alist(
    response ~ dbinom(1, p),
    logit(p) <- 
      a_bar + 
      z_id[id] * sigma_id + 
      z_beh[beh] * sigma_beh,
    a_bar ~  normal(-1, 2),
    z_id[id] ~ normal(0, 1),
    z_beh[beh] ~ normal(0, 1),
    sigma_id ~ dexp(2),
    sigma_beh ~ dexp(2),
    gq> vector[id]: a_ind <<- a_bar + z_id * sigma_id,
    gq> vector[beh]: a_beh <<- a_bar + z_beh * sigma_beh
    
  ), data = clean_dat_retrospective_no_delay, chains = 4, 
  cores = 4, iter = 8000, warmup = 500)
print(precis(m_retrospective_no_delay))

# Store results and print results main text
post = extract.samples(m_retrospective_no_delay)
save(m_retrospective_no_delay, post, file = path_retrospective_no_delay)
message(sprintf(
  'average performance across 208 trials/animal: %s%%; 89%% PI: %s, %s%%',
  round(inv_logit(mean(post$a_bar)), 2) * 100,
  round(inv_logit(PI(post$a_bar)[1]), 2) * 100,
  round(inv_logit(PI(post$a_bar)[2]), 2) * 100))
message('Saved model.')