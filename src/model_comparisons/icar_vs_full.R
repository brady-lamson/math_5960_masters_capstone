library(dplyr)
library(tidyr)
library(sf)
library(readr)
library(ggplot2)
library(scales)
library(brms)

# Data ingestion ---
pred_df <- readr::read_csv("data/model_outputs/housing/all_model_predictions.csv")
df <- sf::read_sf("data/acs/housing/2020_5_year_acs_proportion_response.shp") %>%
    select(name, geometry) %>%
    rename(county=name) %>%
    left_join(pred_df, by="county") %>%
    filter((model_name %in% c("icar_only", "cdl_and_icar")) )

# Collect differences between counties ---
diff_df = df %>%
    sf::st_drop_geometry() %>%
    select(county, model_name, estimate, residual, sd, interval_width, crps) %>%
    tidyr::pivot_wider(
        names_from = model_name,
        values_from = c(estimate, residual, sd, interval_width, crps)
    ) %>%
    mutate(
        county,
        diff_estimate = estimate_icar_only - estimate_cdl_and_icar,
        diff_residual = residual_icar_only - residual_cdl_and_icar,
        diff_sd = sd_icar_only - sd_cdl_and_icar,
        diff_interval_width = interval_width_icar_only - interval_width_cdl_and_icar,
        diff_crps = crps_icar_only - crps_cdl_and_icar
    ) %>%
    select(
        county,
        diff_estimate,
        diff_residual,
        diff_sd,
        diff_interval_width,
        diff_crps
    )

summary(diff_df)

diff_df %>%
    summarise(
        across(
            starts_with("diff_"),
            list(
                mean_abs = ~ mean(abs(.x), na.rm = TRUE),
                max_abs = ~ max(abs(.x), na.rm = TRUE),
                sd = ~ sd(.x, na.rm = TRUE)
            )
        )
    ) %>%
    pivot_longer(
        cols = everything(),
        names_to = c("metric", ".value"),
        names_pattern = "(diff_.*)_(mean_abs|max_abs|sd)"
    )

# Compare fits
folder <- "models/housing"
icar_only = readRDS(paste0(folder, "/icar_only.rds"))
cdl_and_icar = readRDS(paste0(folder, "/cdl_and_icar.rds"))

bf1 <- bayes_factor(icar_only, cdl_and_icar)
bf2 <- bayes_factor(icar_only, cdl_and_icar)
bf3 <- bayes_factor(icar_only, cdl_and_icar)
bf4 <- bayes_factor(icar_only, cdl_and_icar)
1 / mean(c(bf1$bf, bf2$bf, bf3$bf, bf4$bf))
