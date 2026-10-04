# For learning the brms package

library(brms)
library(dplyr)
library(sf)
source("src/R/collect_metrics.R")

acs_df <- sf::st_read("data/acs/housing/2020_5_year_acs_proportion_response.shp")

path <- "models/housing/intercept_only.rds"
if (!file.exists(path)) {
    print(paste0("Model file not found at ", path, " fitting model instead ---"))
    fit <- brms::brm(
        est_logit | se(sd_logit, sigma=FALSE) ~ 1 + (1 | name), # document the heck out of this row to justify it
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
