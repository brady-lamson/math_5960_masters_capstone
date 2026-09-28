library(brms)
library(dplyr)
library(sf)
library(purrr)
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

# Our baseline MSE
mse_acs = mean((full_df$est_prop - full_df$prop_vac)^2)

folder <- "models/housing"
intercept_only = readRDS(paste0(folder, "/intercept_only.rds"))
icar_only = readRDS(paste0(folder, "/icar_only.rds"))
cdl_no_icar = readRDS(paste0(folder, "/cdl_no_icar.rds"))
cdl_and_icar = readRDS(paste0(folder, "/cdl_and_icar.rds"))

true_values <- census_df %>%
    select(name, prop_vac) %>%
    rename(county=name, true_prop=prop_vac)

model0_df <- acs_df %>%
    select(name, est_prop, sd_prop) %>%
    rename(county=name, estimate=est_prop, sd=sd_prop) %>%
    mutate(
        model_name="acs",
        lower=NA,
        upper=NA
    ) %>%
    sf::st_drop_geometry()
model1_df <- catalog_predictions(intercept_only, "intercept_only")
model2_df <- catalog_predictions(icar_only, "icar_only")
model3_df <- catalog_predictions(cdl_no_icar, "cdl_only")
model4_df <- catalog_predictions(cdl_and_icar, "cdl_and_icar")
pred_df <- purrr::reduce(list(model0_df, model1_df, model2_df, model3_df, model4_df), union) %>%
    left_join(true_values, by="county") %>%
    mutate(
        residual=estimate-true_prop,
        true_value_captured=dplyr::if_else((true_prop>=lower) | (true_prop <= upper), TRUE, FALSE),
        interval_width=upper-lower
    )
    
pred_df %>%
    group_by(model_name) %>%
    summarise(
        mse=mean(residual^2),
        mae=mean(abs(residual)),
        rmse=sqrt(mse),
        interval_coverage=mean(true_value_captured),
        mean_interval_width=mean(interval_width),
        mean_sd=mean(sd)
    )

readr::write_csv(pred_df, "data/model_outputs/housing/all_model_predictions.csv")
