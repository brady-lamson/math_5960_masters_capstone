library(dplyr)
library(sf)
library(readr)
library(ggplot2)
library(scales)
library(tidyr)
source("src/R/collect_metrics.R")
source("src/R/plotting.R")

# TODO: GIVE TITLES AND CONSISTENT MODEL COLORS ACROSS PLOTS
# TODO: COMPARE PERFORMANCE ON COUNTIES ACS DOES WORST ON

# Data ingestion ---
pred_df <- readr::read_csv("data/model_outputs/all_model_predictions.csv")
df <- sf::read_sf("data/acs/housing/2020_5_year_acs_proportion_response.shp") %>%
    select(name, geometry) %>%
    rename(county=name) %>%
    left_join(pred_df, by="county") %>%
    filter(!(model_name %in% c("cdl_only", "cdl_and_icar")) )

# Set palette info
n_models = length(unique(df$model_name))
palette = setNames(object = scales::hue_pal()(n_models), nm = unique(df$model_name))

# CRPS RANKING ---
metric <- "crps"
crps_rank <- get_metric_ranking(
    df=df %>% filter(model_name != "acs"),
    metric=metric
)

crps_wide <- crps_rank %>%
    select(-c("rank")) %>%
    tidyr::pivot_wider(names_from = model_name, values_from = crps) %>%
    mutate(delta = intercept_only - icar_only)

summary(crps_wide$delta)
summary(abs(crps_wide$delta))
plot(crps_wide$intercept_only, crps_wide$icar_only)
# Conclusion: Though intercept only technically wins some counties, 
# The crps per-county values are so small as to be not practically meaningful.

get_ranking_summary(crps_rank, metric)
plot_rank1(crps_rank, metric=metric, palette=palette)


# RESIDUAL RANKING (ABSOLUTE VALUE) ---
metric="residual"
residual_rank <- get_metric_ranking(
    df=df %>% mutate(residual=abs(residual)),
    metric=metric
)

counties_acs_won <- residual_rank %>%
    filter(model_name == "acs" & rank == 1) %>%
    select(county) %>%
    st_drop_geometry()

residual_wide <- residual_rank %>%
    select(-c("rank")) %>%
    tidyr::pivot_wider(names_from = model_name, values_from = residual) %>%
    mutate(
        delta_int = intercept_only - acs,
        delta_icar = icar_only - acs
    )

residual_wide_acs_win <- residual_wide %>%
    inner_join(counties_acs_won, by="county")


summary(residual_wide %>% select(delta_int, delta_icar))
summary(residual_wide_acs_win %>% select(delta_int, delta_icar))
plot(residual_wide$intercept_only, residual_wide$icar_only, color="red")

get_ranking_summary(residual_rank, metric)
plot_rank1(residual_rank, metric=metric, palette=palette)

# INTERVAL WIDTH RANKING ---
metric = "interval_width"
interval_rank <- get_metric_ranking(df, metric)

get_ranking_summary(interval_rank, metric)
plot_rank1(interval_rank, metric=metric, palette=palette)

full_interval_rank <- interval_rank %>%
    filter(model_name == "cdl_and_icar") %>%
    select(-c("model_name", "interval_width"))

ggplot(full_interval_rank) +
    geom_sf(aes(fill=rank)) +
    labs(
        title="Rank per county", 
        subtitle=paste("Metric:", metric),
        fill="Rank"
    )
