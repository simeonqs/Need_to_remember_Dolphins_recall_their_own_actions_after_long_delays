# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Running the model combining performance in control trials 
# with and without actions. 
# The experiment is a varying effect for with and without actions. 
# The phase is a varying effect that interacts with experiments (there is a 
# unique phase for each phase and each experiment).
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Paths
path_source_data = 'analysis/code/08_enactment_effect_load_data.R'
path_m_enactment_effect = 'analysis/results/m_enactment_effect.RData'

# Load data
source(path_source_data)

# Model
set_ulam_cmdstan(TRUE)
m_enactment_effect <- ulam(
  alist(
    response ~ dbinom(1, p),
    logit(p) <- a_bar + 
      z_experiment[experiment] * sigma_experiment + 
      z_phase[phase] * sigma_phase + 
      z_id[id] * sigma_id,
    a_bar ~  normal(-0.7, 1.5),
    z_id[id] ~ normal(0, 1),
    z_experiment[experiment] ~ normal(0, 1),
    z_phase[phase] ~ normal(0, 1),
    sigma_id ~ dexp(1),
    sigma_experiment ~ dexp(1),
    sigma_phase ~ dexp(1)
  ), data = clean_dat, chains = 4, cores = 4, iter = 8000, warmup = 500)
print(precis(m_enactment_effect, depth = 2))

# Save and message
post = extract.samples(m_enactment_effect)
save(m_enactment_effect, post, file = path_m_enactment_effect)
cont_10vs60_without_actions = 
  (post$a_bar + 
     post$z_experiment[,1] * post$sigma_experiment + # without actions
     post$z_phase[,2] * post$sigma_phase) - # without actions, 60 seconds
  (post$a_bar + 
     post$z_experiment[,1] * post$sigma_experiment + # without actions
     post$z_phase[,1] * post$sigma_phase)  # without actions, 10 seconds
message(sprintf(
  'average contrast (log-odds): %s; 89%% PI: %s, %s',
  round(mean(cont_10vs60_without_actions), 2),
  round(PI(cont_10vs60_without_actions)[1], 2),
  round(PI(cont_10vs60_without_actions)[2], 2)))
cont_60_with_vs_without = cont_10vs60_without_actions = 
  (post$a_bar + 
     post$z_experiment[,2] * post$sigma_experiment + # with actions
     post$z_phase[,4] * post$sigma_phase) - # with actions, 60 seconds
  (post$a_bar + 
     post$z_experiment[,1] * post$sigma_experiment + # without actions
     post$z_phase[,2] * post$sigma_phase)  # without actions, 60 seconds
message(sprintf(
  'average contrast (log-odds): %s; 89%% PI: %s, %s',
  round(mean(cont_60_with_vs_without), 2),
  round(PI(cont_60_with_vs_without)[1], 2),
  round(PI(cont_60_with_vs_without)[2], 2)))
message('Saved model.')
