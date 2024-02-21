# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Plotting figure 3 for the main text.    
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list = ls()) 

# Set seed to get the same plot
set.seed(1)

# Paths
path_source_data = 'analysis/code/08_enactment_effect_load_data.R'
path_m_enactment_effect = 'analysis/results/m_enactment_effect.RData'
path_pdf = 'analysis/results/figure_3.pdf'

# Load data
source(path_source_data)
load(path_m_enactment_effect)

# Plot per species
pdf(path_pdf, 3.5, 3)
par(mar = c(3.5, 2, 1, 0.5))
plot(clean_dat$phase[clean_dat$experiment == 1] + 
       rnorm(length(clean_dat$phase[clean_dat$experiment == 1]), 0, 0.05),
     clean_dat$response[clean_dat$experiment == 1] + 
       ifelse(clean_dat$response[clean_dat$experiment == 1] == 0, 
              runif(length(clean_dat$phase[clean_dat$experiment == 1]), 
                    -0.1, 0),
              runif(length(clean_dat$phase[clean_dat$experiment == 1]), 
                    -0.05, 0.05)), 
     pch = 16, col = alpha('#F5B7B1', 0.5), yaxt = 'n', xaxt = 'n',
     xlab = '', ylab = '')
points(clean_dat$phase[clean_dat$experiment == 2]-2 + 
         rnorm(length(clean_dat$phase[clean_dat$experiment == 2]), -
                 0, 0.05),
       clean_dat$response[clean_dat$experiment == 2] + 
         ifelse(clean_dat$response[clean_dat$experiment == 2] == 0, 
                runif(length(clean_dat$phase[clean_dat$experiment == 2]), 
                      -0.1, 0),
                runif(length(clean_dat$phase[clean_dat$experiment == 2]), 
                      -0.05, 0.05)),
       pch = 16, col = alpha('#A9CCE3', 0.5))
axis(1, at = 1:2, labels = c('10', '60'))
axis(2, at = c(0, 1), labels = c('Incorrect', 'Correct'))
for(i in sample(length(post$a_bar), 16)) 
  lines(1:2, 
        sapply(1:2, function(j) post$a_bar[i] + 
                 post$z_experiment[i, 1] * 
                 post$sigma_experiment[i]+
                 post$z_phase[i, j] * 
                 post$sigma_phase[i]) %>% inv_logit,
        col = alpha('#F5B7B1', 0.5), lwd = 3)
for(i in sample(length(post$a_bar), 16)) 
  lines(1:2, 
        sapply(3:4, function(j) post$a_bar[i] + 
                 post$z_experiment[i, 2] * 
                 post$sigma_experiment[i] +
                 post$z_phase[i, j] * 
                 post$sigma_phase[i]) %>% inv_logit,
        col = alpha('#A9CCE3', 0.5), lwd = 3)

lines(1:2, 
      
      sapply(1:length(post$a_bar), function(i) 
        
        sapply(1:2, function(j) post$a_bar[i] + 
                 post$z_experiment[i, 1] * post$sigma_experiment[i]+
                 post$z_phase[i, j] * post$sigma_phase[i])
        
      ) |> apply(1, mean) |> inv_logit(),
      
      col = alpha('#E74C3C', 0.7), lwd = 5)

lines(1:2, 
      
      sapply(1:length(post$a_bar), function(i) 
        
        sapply(3:4, function(j) post$a_bar[i] + 
                 post$z_experiment[i, 2] * post$sigma_experiment[i]+
                 post$z_phase[i, j] * post$sigma_phase[i])
        
      ) |> apply(1, mean) |> inv_logit(),
      
      col = alpha('#2980B9', 0.7), lwd = 5)

lines(1:2, rep(1/4, length(1:2)), lty = 5, 
      lwd = 3, col = alpha('black', 0.7))
text(min(1:2), 1/4 + 0.1, 'Chance level', adj = 0)
mtext('Delay [seconds]', 1, 2.3)
dev.off()

# Message 
message('Plotted figure.')