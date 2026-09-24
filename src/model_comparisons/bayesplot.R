library(brms)
library(dplyr)
library(sf)
library(bayesplot)
library(ggplot2)
library(rstan)

acs_df <- sf::st_read("data/acs/2023_5_year_acs_proportion_response.shp")
covariate_df <- readr::read_csv("data/cdl_covariates.csv") %>%
    mutate(
        geoid = as.character(geoid),
        prop_corn_soy = perc_corn_soy / 100
    ) %>%
    select("geoid", "prop_corn_soy")
acs_df <- acs_df %>%
    left_join(covariate_df, by="geoid")

models <- list(
    intercept_only = readRDS("models/intercept_only.rds"),
    icar_only = readRDS("models/icar_only.rds"),
    cdl_no_icar = readRDS("models/cdl_no_icar.rds"),
    cdl_and_icar = readRDS("models/cdl_and_icar.rds")
)

# Let's focus on the full model for now
fit <- models[[4]]
draws <- as.array(fit)
np <- brms::nuts_params(fit)
pars <- c("b_Intercept", "b_prop_corn_soy", "sdcar")
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
