# Model 4: Bayesian fh model with spatial covariate

library(brms)
library(dplyr)
library(sf)
library(readr)
source("src/R/collect_metrics.R")

acs_df <- sf::st_read("data/acs/housing/2020_5_year_acs_proportion_response.shp")
covariate_df <- readr::read_csv("data/cdl_covariates.csv") %>%
    mutate(
        geoid = as.character(geoid),
        prop_corn_soy = perc_corn_soy / 100
    ) %>%
    select("geoid", "prop_corn_soy")
acs_df <- acs_df %>%
    left_join(covariate_df, by="geoid")

path <- "models/housing/cdl_no_icar.rds"
if (!file.exists(path)) {
    print(paste0("Model file not found at ", path, " fitting model instead ---"))
    fit <- brms::brm(
        est_logit | se(sd_logit, sigma=FALSE) ~ prop_corn_soy + (1 | name),
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
