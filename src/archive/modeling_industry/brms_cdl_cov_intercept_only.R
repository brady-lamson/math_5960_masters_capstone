# Model 4: Bayesian fh model with spatial covariate

library(brms)
library(dplyr)
library(sf)
library(readr)

acs_df <- sf::st_read("data/acs/2023_5_year_acs_proportion_response.shp")
covariate_df <- readr::read_csv("data/cdl_covariates.csv") %>%
    mutate(
        geoid = as.character(geoid),
        prop_corn_soy = perc_corn_soy / 100
    ) %>%
    select("geoid", "prop_corn_soy")
acs_df <- acs_df %>%
    left_join(covariate_df, by="geoid")

path <- "models/cdl_no_icar.rds"
if (!file.exists(path)) {
    print(paste0("Model file not found at ", path, " fitting model instead ---"))
    fit <- brms::brm(
        est_prop | se(sd, sigma=FALSE) ~ prop_corn_soy + (1 | name),
        data=acs_df,
        family=gaussian(),
        seed=100,
        iter=10000,
        warmup=5000
    )
    print(paste0("Model fit successfully, writing rds to ", path))
    saveRDS(fit, path)
} else {
    print("Model located, reading rds")
    fit <- readRDS(path)
}

print(fit$fit, digits=5)
print(summary(fit, priors=TRUE, mc_se=TRUE), digits=5)

plot(fit)

# Get estimated proportions from the posterior distribution
posterior_predictions <- brms::posterior_epred(fit)
sae_estimates <- colMeans(posterior_predictions)
sae_sd <- apply(posterior_predictions, 2, sd)

run_plots <- TRUE
if (run_plots) {
    # Compare estimated proportions ---
    limlow <- min(acs_df$est_prop, sae_estimates)
    limhigh <- max(acs_df$est_prop, sae_estimates)
    limits <- c(limlow, limhigh)
    plot(x=acs_df$est_prop, y=sae_estimates, xlim=limits, ylim=limits)
    abline(a=0,b=1)
    
    # Compare standard deviations ---
    limlow <- min(acs_df$sd, sae_sd)
    limhigh <- max(acs_df$sd, sae_sd)
    limits <- c(limlow, limhigh)
    plot(x=acs_df$sd, y=sae_sd, xlim=limits, ylim=limits)
    abline(a=0,b=1)
}