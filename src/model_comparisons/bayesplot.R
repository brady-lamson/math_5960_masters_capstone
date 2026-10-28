library(brms)
library(dplyr)
library(sf)
library(bayesplot)
library(ggplot2)
library(rstan)
library(posterior)

models <- list(
    intercept_only = readRDS("models/intercept_only.rds"),
    icar_only = readRDS("models/icar_only.rds"),
    cdl_no_icar = readRDS("models/cdl_no_icar.rds"),
    cdl_and_icar = readRDS("models/cdl_and_icar.rds")
)

# Let's focus on the icar model for now
fit <- models[[2]]
draws <- as.array(fit)
np <- brms::nuts_params(fit)
pars <- c("b_Intercept", "sdcar")
bayesplot::mcmc_parcoord(draws, pars=pars, alpha=0.1, np=np)
# There don't seem to be any divergent iterations here. They'd be highlighted in red if they existed. 

bayesplot::mcmc_pairs(draws, pars=pars, np=np)
color_scheme_set("mix-brightblue-gray")
bayesplot::mcmc_trace(draws, pars="sdcar")

rhats <- bayesplot::rhat(fit$fit)
summary(rhats)
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#  0.9999  1.0004  1.0012  1.0017  1.0029  1.0064       1 

neff_ratios <- bayesplot::neff_ratio(fit$fit)
neff_ratios <- neff_ratios[names(neff_ratios) != "sigma"]
bayesplot::mcmc_neff(neff_ratios)


# Some stuff to print out in meeting ---
print(summary(fit), digits=5)
print(fit$fit, digits=5)

# ahhh posterior library
draws <- posterior::as_draws_df(fit)

# TODO: FILTER THIS FOR INTERCEPT, SDCAR, PROP CORN SOY
# ADD A MODEL NAME COLUMN AS WELL.
# SAVE TO POSTERIOR OUTPUT CSV
summaries <- posterior::summarise_draws(
    draws,
    mean,
    sd,
    ~ quantile(.x, 0.025),
    ~ quantile(.x, 0.975),
    rhat,
    ess_bulk,
    ess_tail
)