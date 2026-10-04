library(loo)
library(brms)
library(dplyr)
library(sf)
library(purrr)
library(readr)
source("src/R/collect_metrics.R")

acs_df <- sf::st_read("data/acs/housing/2020_5_year_acs_proportion_response.shp")

census_df <- sf::st_read("data/census/2020_housing_vacancy_rates.shp") %>%
    sf::st_drop_geometry()

full_df <- acs_df %>%
    left_join(census_df, by=c("geoid", "name"))

folder <- "models/housing"
icar_only = readRDS(paste0(folder, "/icar_only.rds"))


pars <- brms::variables(icar_only)
grep("car", pars, value = TRUE)
icar_vars <- grep("^rcar", pars, value = TRUE)
icar_draws <- brms::as_draws_matrix(
    icar_only,
    variable = icar_vars
)

# Posterior means
icar_mean <- colMeans(icar_draws)

icar_df <- data.frame(
    name = names(icar_mean),
    icar = as.numeric(icar_mean)
)

neighbor_list <- spdep::poly2nb(acs_df, queen=TRUE, row.names=acs_df$name)
neighbor_listw <- spdep::nb2listw(neighbor_list, )

# Spatial autocorrelation of ICAR estimates
spdep::moran.test(
    icar_df$icar,
    neighbor_listw
)
