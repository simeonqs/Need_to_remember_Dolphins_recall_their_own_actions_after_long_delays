# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Plotting figure 2 for the main text.    
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
path_source_data = 'analysis/code/06_retrospective_delay_load_data.R'
path_m_retrospective_delay = 'analysis/results/m_retrospective_delay.RData'
path_pdf = 'analysis/results/figure_1.pdf'

# Load data
source(path_source_data)
load(path_m_retrospective_delay)

# Plot per species
pdf(path_pdf, 3.5, 3)
par(mar = c(3.5, 2, 1, 0.5))
plot(clean_dat$log_time + rnorm(nrow(clean_dat), 0, 0.02), 
     clean_dat$response + rnorm(nrow(clean_dat), 0, 0.02),
     pch = 16, col = alpha('grey', 0.5),
     xlim = c(log2(3.3), log2(23)),
     xaxt = 'n', yaxt = 'n', xlab = '', ylab = '', 
     main = '')
mtext('Delay [seconds]', 1, 2.3)
axis(1, log2(c(2, 4, 8, 16)), c(2, 4, 8, 16))
axis(2, c(0, 1), c('Incorrect', 'Correct'))
times = seq(min(clean_dat$log_time), max(clean_dat$log_time), 0.1)
for(i in sample(length(post$a_bar), 20)) 
  lines(times,
        inv_logit(post$a_bar[i] - post$b_bar[i] * times),
        lty = 1, lwd = 3, col = alpha('grey', 0.5))
fitted = vapply(times, function(time) 
  vapply(seq_len(length(post$a_bar)), function(i)
    post$a_bar[i] - post$b_bar[i] * time, numeric(1)) |> mean(),
  numeric(1))
lines(times, inv_logit(fitted), lwd = 5, col = alpha('black', 0.7))
lines(times, rep(1/4, length(times)), lty = 5, 
      lwd = 3, col = alpha('black', 0.7))
text(min(times), 1/4 + 0.1, 'Chance level', adj = 0)
dev.off()

# Message 
message('Plotted figure.')