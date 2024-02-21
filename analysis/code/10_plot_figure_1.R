# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Plots figure 1 for the main text.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Paths
path_source_data_delay = 'analysis/code/00_prospective_delay_load_data.R'
path_source_data_control = 'analysis/code/02_prospective_control_load_data.R'
path_prospective_delay_model = 'analysis/results/m_prospective_delay.RData'
path_ms_prospective_control = 'analysis/results/ms_prospective_control.RData'
path_pdf = 'analysis/results/figure_1.pdf'

# Load data and results
source(path_source_data_delay)
load(path_prospective_delay_model)

# Set seed so that sampling is always the same
set.seed(1)

# Plot results
pdf(path_pdf, 7, 7/3)
par(mfrow = c(1, 3), mar = rep(0.5, 4), oma = c(3, 2, 1.5, 3))
set.seed(1)
plot_dat = data.frame(response = clean_dat$response,
                      id = clean_dat$id,
                      phase = clean_dat$phase)
phase_average = sapply(0:4, function(i){
  sapply(1:nrow(post_prospective_delay$a_bl), function(j){
    if(i == 0) post_prospective_delay$a_bl[j,1] else 
      post_prospective_delay$a_bl[j,1] - post_prospective_delay$bp[j] * 
      sum(post_prospective_delay$delta[j,1:i])
  }) %>% mean %>% inv_logit
})
phase_PI_95 = sapply(0:4, function(i){
  sapply(1:nrow(post_prospective_delay$a_bl), function(j){
    if(i == 0) post_prospective_delay$a_bl[j,1] else 
      post_prospective_delay$a_bl[j,1] - post_prospective_delay$bp[j] * 
      sum(post_prospective_delay$delta[j,1:i])
  }) %>% PI(0.95) %>% inv_logit
})
phase_PI_50 = sapply(0:4, function(i){
  sapply(1:nrow(post_prospective_delay$a_bl), function(j){
    if(i == 0) post_prospective_delay$a_bl[j,1] else 
      post_prospective_delay$a_bl[j,1] - post_prospective_delay$bp[j] * 
      sum(post_prospective_delay$delta[j,1:i])
  }) %>% PI(0.5) %>% inv_logit
})

plot(plot_dat$phase + runif(nrow(plot_dat), -0.2, 0.2),
     plot_dat$response + runif(nrow(plot_dat), -0.05, 0.05), 
     pch = 16, col =  alpha('grey', 0.5), yaxt = 'n', xaxt = 'n',
     xlab = 'Phase', ylab = 'Response', main = '')
mtext('A', 3, 0.8, adj = 0, font = 2)
mtext('Delay [hours]', 1, 2.3, cex = 0.75)
axis(1, at = 1:5, labels = 1:5)
axis(2, at = c(0, 1), labels = c('Incorrect', 'Correct'))
lines(1:5, rep(1/6, 5), lty = 5, lwd = 3, col = alpha('black', 0.7))
for(i in sample(length(post_prospective_delay$a_bar), 20)) 
  lines(1:5, 
        sapply(0:4, function(j) 
          ifelse(j == 0, 
                 post_prospective_delay$a_bl[i,1], 
                 post_prospective_delay$a_bl[i,1] - 
                   post_prospective_delay$bp[i] * 
                   sum(post_prospective_delay$delta[i,1:j]))) %>% inv_logit,
        col = alpha('grey', 0.5), lwd = 3)
lines(1:5, phase_average, lwd = 5, col = alpha('black', 0.7))
text(1, 1/6 + 0.1, 'Chance level', adj = 0)

# Load data
source(path_source_data_control)
load(path_ms_prospective_control)

# Phase 0 - probs
prior = rnorm(1e6, -0.7, 1.5) %>% inv_logit %>% density
plot(prior, lwd = 2, xlim = c(0, 1), ylim = c(0, 13), main = '', 
     xlab = '', ylab = '', yaxt = 'n')
mtext('Probability of success', 1, 2.3, cex = 0.75)
mtext('B', 3, 0.8, adj = 0, font = 2)
text(0.3, 12, 
     sprintf('Mean contrast: %s', 
             round(mean(
               inv_logit(post_prospective_control_0$a_loc[,1]) - 
                 inv_logit(post_prospective_control_0$a_loc[,2])), 2)), 
     cex = 0.75, adj = 0)
text(0.3, 11, 
     sprintf('89%% PI: %s, %s', 
             round(PI(
               inv_logit(post_prospective_control_0$a_loc[,1]) - 
                 inv_logit(post_prospective_control_0$a_loc[,2]))[1], 2),
             round(PI(
               inv_logit(post_prospective_control_0$a_loc[,1]) - 
                 inv_logit(post_prospective_control_0$a_loc[,2]))[2], 2)), 
     cex = 0.75, adj = 0)
polygon(prior, col = alpha('grey', 0.5))
post_prospective_control_0$a_loc[,1] %>% inv_logit %>% density(bw = 0.02) %>% 
  polygon(col = alpha('#2980B9', 0.8), lwd = 2)
post_prospective_control_0$a_loc[,2] %>% inv_logit %>% density(bw = 0.02) %>% 
  polygon(col = alpha('#E74C3C', 0.8), lwd = 2)
lines(c(0.25, 0.25), c(0, 14), lty = 2, lwd = 3, col = alpha('black', 0.5))
# Phase 3 - probs
prior = rnorm(1e6, -0.7, 1.5) %>% inv_logit %>% density
plot(prior, lwd = 2, xlim = c(0, 1), ylim = c(0, 13), main = '', 
     xlab = '', ylab = '', yaxt = 'n')
polygon(prior, col = alpha('grey', 0.5))
post_prospective_control_3$a_loc[,1] %>% inv_logit %>% density(bw = 0.02) %>% 
  polygon(col = alpha('#2980B9', 0.8), lwd = 2)
post_prospective_control_3$a_loc[,2] %>% inv_logit %>% density(bw = 0.02) %>% 
  polygon(col = alpha('#E74C3C', 0.8), lwd = 2)
lines(c(0.25, 0.25), c(0, 14), lty = 2, lwd = 3, col = alpha('black', 0.5))
axis(4, seq(0, 12, 3), seq(0, 12, 3))
mtext('Probability of success', 1, 2.3, cex = 0.75)
mtext('Density', 4, 2.3, cex = 0.75)
mtext('C', 3, 0.8, adj = 0, font = 2)
text(0.3, 12, 
     sprintf('Mean contrast: %.2f', 
             round(mean(
               inv_logit(post_prospective_control_3$a_loc[,1]) - 
                 inv_logit(post_prospective_control_3$a_loc[,2])), 2)), 
     cex = 0.75, adj = 0)
text(0.3, 11, 
     sprintf('89%% PI: %s, %s', 
             round(PI(
               inv_logit(post_prospective_control_3$a_loc[,1]) - 
                 inv_logit(post_prospective_control_3$a_loc[,2]))[1], 2),
             round(PI(
               inv_logit(post_prospective_control_3$a_loc[,1]) - 
                 inv_logit(post_prospective_control_3$a_loc[,2]))[2], 2)), 
     cex = 0.75, adj = 0)

dev.off()

# Message 
message('Plotted figure.')