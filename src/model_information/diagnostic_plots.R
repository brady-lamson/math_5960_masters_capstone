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

fit <- models[[4]]
draws <- as.array(fit)
np <- brms::nuts_params(fit)
pars <- c("b_Intercept", "sdcar", "b_prop_corn_soy")
color_scheme_set("mix-blue-red")
full_trace <- bayesplot::mcmc_trace(
    draws, np=np, pars=pars,
    facet_args = list(ncol = 1, strip.position = "left")
) + ggtitle("Full Model MCMC Trace Plots")
full_pairs <- bayesplot::mcmc_pairs(draws, pars=pars, np=np) +
    ggtitle("Full Model MCMC Paired Scatterplots")
ggsave(full_pairs, filename="images/mcmc_pairs_full_model.png")
ggsave(full_trace, filename="images/mcmc_trace_full_model.png")

# cdl model ---
fit <- models[[3]]
draws <- as.array(fit)
np <- brms::nuts_params(fit)
pars <- c("b_Intercept", "b_prop_corn_soy")
bayesplot::mcmc_trace(
    draws, np=np, pars=pars,
    facet_args = list(ncol = 1, strip.position = "left")
)
bayesplot::mcmc_pairs(draws, pars=pars, np=np)

