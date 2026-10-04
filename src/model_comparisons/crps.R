library(loo)
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

census_df <- sf::st_read("data/census/2020_housing_vacancy_rates.shp") %>%
    sf::st_drop_geometry()

full_df <- acs_df %>%
    left_join(covariate_df, by="geoid") %>%
    left_join(census_df, by=c("geoid", "name"))

folder <- "models/housing"
intercept_only = readRDS(paste0(folder, "/intercept_only.rds"))
icar_only = readRDS(paste0(folder, "/icar_only.rds"))
cdl_no_icar = readRDS(paste0(folder, "/cdl_no_icar.rds"))
cdl_and_icar = readRDS(paste0(folder, "/cdl_and_icar.rds"))

y <- full_df$prop_vac
mod1_crps <- get_crps(intercept_only, y)
mod2_crps <- get_crps(icar_only, y)
mod3_crps <- get_crps(cdl_no_icar, y)
mod4_crps <- get_crps(cdl_and_icar, y)

crps_means <- lapply(list(mod1_crps, mod2_crps, mod3_crps, mod4_crps), mean) %>% unlist()
crps_df <- tibble(
    model=c("int_only", "icar_only", "cdl_only", "cdl_icar"),
    crps=num(crps_means, digits=10)
) %>%
    arrange(crps)

