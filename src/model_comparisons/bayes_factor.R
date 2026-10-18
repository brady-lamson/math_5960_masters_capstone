library(dplyr)
library(readr)
library(brms)
library(readr)
source("src/R/collect_metrics.R")


models <- list(
    intercept = readRDS("models/intercept_only.rds"),
    cdl = readRDS("models/cdl_no_icar.rds"),
    icar = readRDS("models/icar_only.rds"),
    full = readRDS("models/cdl_and_icar.rds")
)

bf_df <- bayes_factor_all_combinations(models, n=5)
readr::write_csv(bf_df, "data/model_outputs/bayes_factor.csv")
