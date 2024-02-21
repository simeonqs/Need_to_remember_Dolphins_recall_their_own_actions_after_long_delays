# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: dolphin memory
# Author: Simeon Q. Smeele
# Description: Running the model for trials with delays. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Paths
path_source_data = 'analysis/code/00_prospective_delay_load_data.R'
path_prospective_delay_model = 'analysis/results/m_prospective_delay.RData'

# Load data
source(path_source_data)

# Cleaning the data 
dat = dat_delay
dat = dat[!is.na(dat$Animal),]
dat = dat[dat$Phase != 0,]
dat[is.na(dat)] = 'unknown'
trans_behaviour = 1:length(unique(dat$Behaviour.marked))
names(trans_behaviour) = unique(dat$Behaviour.marked)
trans_prospective_delay = c(1, 1, 2, 2, 3, 5, 4)
names(trans_prospective_delay) = as.character(1:7)
trans_tr1 = 1:length(unique(dat$Trainer.mark))
names(trans_tr1) = unique(dat$Trainer.mark)
trans_tr2 = 1:length(unique(dat$Trainer.recall))
names(trans_tr2) = unique(dat$Trainer.recall)
trans_date = 1:length(unique(dat$Date))
names(trans_date) = unique(dat$Date)
log_dist = log(dat$Distractions + 1)
clean_dat = list(response = ifelse(dat$Behaviour.marked == 
                                     dat$Behaviour.offered, 1L, 0L),
                 id = trans_id[dat$Animal] %>% as.numeric,
                 beh = trans_behaviour[dat$Behaviour.marked] %>% as.numeric,
                 tr1 =  trans_tr1[dat$Trainer.mark] %>% as.integer,
                 tr2 =  trans_tr2[dat$Trainer.recall] %>% as.integer,
                 date =  trans_date[dat$Date] %>% as.integer,
                 phase = trans_prospective_delay[as.character(dat$Phase)] %>% 
                   as.integer,
                 dist = log_dist/max(log_dist),
                 blind = dat$Double.blind+1,
                 alpha = rep( 2 , 4 ))

# Final model
set_ulam_cmdstan(TRUE)
m_prospective_delay <- ulam(
  alist(
    # Model
    response ~ dbinom(1, p),
    logit(p) <- 
      a_bar +
      za_id[id] * s_id + 
      za_blind[blind] * s_blind +
      za_beh[beh] * s_beh + 
      za_tr1[tr1] * s_tr1 +
      za_tr2[tr2] * s_tr2 +
      za_date[date] * s_date -
      (bp + zb_prospective_delay[id] * sbp) * sum(delta_j[1:phase]) + 
      (bd + zb_dist[id] * sbd) * dist,
    # Priors
    a_bar ~ normal(-0.7, 1.5),
    za_id[id] ~ normal(0, 1),
    za_blind[blind] ~ normal(0, 1),
    za_beh[beh] ~ normal(0, 1),
    za_tr1[tr1] ~ normal(0, 1),
    za_tr2[tr2] ~ normal(0, 1),
    za_date[date] ~ normal(0, 1),
    zb_prospective_delay[id] ~ normal(0, 1),
    zb_dist[id] ~ normal(0, 1),
    bp ~ dexp(1),
    bd ~ normal(0, 1),
    c(s_id, s_blind, s_beh, s_tr1, s_tr2, s_date, sbp, sbd) ~ dexp(2),
    vector[5]: delta_j <<- append_row(0 , delta),
    simplex[4]: delta ~ dirichlet(alpha),
    gq> vector[blind]: a_bl <<- a_bar + za_blind * s_blind
  ), data = clean_dat, chains = 4, cores = 4, iter = 8000, warmup = 500)
post_prospective_delay = extract.samples(m_prospective_delay)
save(post_prospective_delay, trans_prospective_delay, clean_dat, 
     file = path_prospective_delay_model)
print(precis(m_prospective_delay, depth = 2))
post_16h = post_prospective_delay$a_bar + post_prospective_delay$bd
message(sprintf('average performance at 16h: %s%%; 89%% PI: %s, %s%%',
                round(inv_logit(mean(post_16h)), 2) * 100,
                round(inv_logit(PI(post_16h)[1]), 2) * 100,
                round(inv_logit(PI(post_16h)[2]), 2) * 100))
message(sprintf('β_phase: %s; 89%% PI = %s, %s',
                round(mean(post_prospective_delay$bp), 2),
                round(PI(post_prospective_delay$bp)[1], 2),
                round(PI(post_prospective_delay$bp)[2], 2)))
message(sprintf('β_distractions: %s; 89%% PI = %s, %s',
                round(mean(post_prospective_delay$bd), 2),
                round(PI(post_prospective_delay$bd)[1], 2),
                round(PI(post_prospective_delay$bd)[2], 2)))
message('Saved model.')

