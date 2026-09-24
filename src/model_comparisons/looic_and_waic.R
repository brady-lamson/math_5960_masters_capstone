library(brms)
library(dplyr)
library(sf)

acs_df <- sf::st_read("data/acs/2023_5_year_acs_proportion_response.shp")
covariate_df <- readr::read_csv("data/cdl_covariates.csv") %>%
    mutate(
        geoid = as.character(geoid),
        prop_corn_soy = perc_corn_soy / 100
    ) %>%
    select("geoid", "prop_corn_soy")
acs_df <- acs_df %>%
    left_join(covariate_df, by="geoid")

models <- list(
    intercept_only = readRDS("models/intercept_only.rds"),
    icar_only = readRDS("models/icar_only.rds"),
    cdl_no_icar = readRDS("models/cdl_no_icar.rds"),
    cdl_and_icar = readRDS("models/cdl_and_icar.rds")
)


add_criterion_and_update <- function(model) {
    add_criterion(model, criterion=c("loo", "waic"))
}
models <- lapply(models, add_criterion_and_update)

print("LOOIC -------")
for (i in seq_along(models)) {
    print("----------")
    print(paste("Model", i))
    print(models[[i]]$criteria$loo)
}

print("WAIC -----")
for (i in seq_along(models)) {
    print("----------")
    print(paste("Model", i))
    print(models[[i]]$criteria$waic)
}

for (i in seq_along(models)) {
    print("----------")
    print(paste("Model", i))
    k <- models[[i]]$criteria$loo$diagnostics$pareto_k
    temp_df <- acs_df %>%
        select(name) %>%
        mutate(pareto_k = k) %>%
        arrange(desc(pareto_k))
    temp_df <- sf::st_drop_geometry(temp_df)
    print(head(temp_df, n=15))
}
