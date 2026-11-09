library(brms)
library(dplyr)
library(sf)
library(readr)
library(posterior)
source("src/R/collect_metrics.R")

# LOAD MODELS ---
folder <- "models"
intercept_only = readRDS(paste0(folder, "/intercept_only.rds"))
icar_only = readRDS(paste0(folder, "/icar_only.rds"))
cdl_no_icar = readRDS(paste0(folder, "/cdl_no_icar.rds"))
cdl_and_icar = readRDS(paste0(folder, "/cdl_and_icar.rds"))

int_coeff <- get_coefficient_summaries(intercept_only, model_name = "intercept_only")
icar_coeff <- get_coefficient_summaries(icar_only, model_name = "icar_only")
cdl_coeff <- get_coefficient_summaries(cdl_no_icar, model_name = "cdl_only")
full_coeff <- get_coefficient_summaries(cdl_and_icar, model_name = "cdl_and_icar")

coeff_df <- dplyr::bind_rows(list(int_coeff, icar_coeff, cdl_coeff, full_coeff)) %>%
    filter(!(variable %in% c("sigma")))

diagnostic_df <- coeff_df %>%
    group_by(model_name) %>%
    summarise(
        max_rhat = max(rhat),
        min_ess_bulk = min(ess_bulk),
        min_ess_tail = min(ess_tail)
    )

readr::write_csv(diagnostic_df, "data/model_outputs/model_diagnostics.csv")
