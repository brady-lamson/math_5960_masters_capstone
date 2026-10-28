library(brms)
library(dplyr)
library(sf)
library(readr)
source("src/R/collect_metrics.R")
source("src/R/transformations.R")

# INITIAL DATA INGESTION AND SETUP ----
p <- 0.025 # For upper and lower bounds. 95% interval
acs_df <- sf::st_read("data/acs/2020_5_year_acs_proportion_response.shp") %>%
    mutate(
        lower = inv_logit(qnorm(p, mean=est_logit, sd=sd_logit)),
        upper = inv_logit(qnorm(1-p, mean=est_logit, sd=sd_logit))
    )

census_df <- sf::st_read("data/census/2020_housing_vacancy_rates.shp") %>%
    sf::st_drop_geometry() %>%
    select(name, prop_vac)

df <- acs_df %>%
    left_join(census_df, by="name")

# LOAD MODELS ---
folder <- "models"
intercept_only = readRDS(paste0(folder, "/intercept_only.rds"))
icar_only = readRDS(paste0(folder, "/icar_only.rds"))
cdl_no_icar = readRDS(paste0(folder, "/cdl_no_icar.rds"))
cdl_and_icar = readRDS(paste0(folder, "/cdl_and_icar.rds"))

# COLLECT MODEL METRICS ---
model0_df <- df %>%
    select(name, est_prop, sd_prop, lower, upper, prop_vac) %>%
    rename(county=name, estimate=est_prop, sd=sd_prop, true_value=prop_vac) %>%
    mutate(
        model_name="acs",
        residual=estimate-true_value,
        proportional_residual = (estimate - true_value) / true_value,
        true_value_captured=dplyr::if_else((true_value>=lower) & (true_value <= upper), TRUE, FALSE),
        interval_width=upper-lower,
        crps=NA
    ) %>%
    sf::st_drop_geometry() %>%
    tibble()
model1_df <- readr::read_csv("data/model_outputs/emdi_model_predictions.csv") %>%
    left_join(census_df, join_by("county" == "name")) %>%
    mutate(
        true_value=prop_vac,
        residual=estimate-prop_vac,
        proportional_residual = (estimate - prop_vac) / prop_vac
    ) %>%
    select(-prop_vac)
model2_df <- catalog_predictions(intercept_only, "intercept_only", true_vector=df$prop_vac)
model3_df <- catalog_predictions(cdl_no_icar, "cdl_only", true_vector=df$prop_vac)
model4_df <- catalog_predictions(icar_only, "icar_only", true_vector=df$prop_vac)
model5_df <- catalog_predictions(cdl_and_icar, "cdl_and_icar", true_vector=df$prop_vac)

# COMBINE MODEL METRIC DATAFRAMES, CREATE ADDITIONAL METRICS ---
pred_df <- dplyr::bind_rows(list(model0_df, model1_df, model2_df, model3_df, model4_df, model5_df)) %>%
    # Reorder columns for my own preference
    select(
        model_name,
        county,
        estimate,
        true_value,
        residual,
        proportional_residual,
        sd,
        lower,
        upper,
        interval_width,
        true_value_captured,
        crps
    )

# CREATE THE SUMMARY DATAFRAME ---
digit_override <- options(pillar.sigfig=7)
pred_summary <- pred_df %>%
    group_by(model_name) %>%
    summarise(
        mse=mean(residual^2),
        mspe=mean(proportional_residual^2),
        mae=mean(abs(residual)),
        mape=mean(abs(proportional_residual)),
        rmse=sqrt(mse),
        rmspe=sqrt(mspe),
        interval_coverage=mean(true_value_captured),
        mean_interval_width=mean(interval_width),
        mean_sd=mean(sd),
        mean_crps=mean(crps)
    )
pred_summary

# WRITE TABLES ---
readr::write_csv(pred_df, "data/model_outputs/all_model_predictions.csv")
readr::write_csv(pred_summary, "data/model_outputs/all_model_summary.csv")
