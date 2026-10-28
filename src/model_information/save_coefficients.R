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

int_coeff <- get_coefficient_summaries(intercept_only, model_name = "intercept_only", filter_variables = c("Intercept", "sd_name__Intercept"))
icar_coeff <- get_coefficient_summaries(icar_only, model_name = "icar_only", filter_variables = c("Intercept", "sdcar"))
cdl_coeff <- get_coefficient_summaries(cdl_no_icar, model_name = "cdl_only", filter_variables = c("Intercept", "sd_name__Intercept", "b_prop_corn_soy"))
full_coeff <- get_coefficient_summaries(cdl_and_icar, model_name = "cdl_and_icar", filter_variables = c("Intercept", "sdcar", "b_prop_corn_soy"))

coeff_df <- dplyr::bind_rows(list(int_coeff, cdl_coeff, icar_coeff, full_coeff))
readr::write_csv(coeff_df, "data/model_outputs/model_coefficients.csv")
