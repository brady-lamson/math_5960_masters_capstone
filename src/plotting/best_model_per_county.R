library(dplyr)
library(sf)
library(readr)
library(ggplot2)
library(scales)
source("src/R/collect_metrics.R")
source("src/R/plotting.R")

# TODO: GIVE TITLES AND CONSISTENT MODEL COLORS ACROSS PLOTS

# Data ingestion ---
pred_df <- readr::read_csv("data/model_outputs/housing/all_model_predictions.csv")
df <- sf::read_sf("data/acs/housing/2020_5_year_acs_proportion_response.shp") %>%
    select(name, geometry) %>%
    rename(county=name) %>%
    left_join(pred_df, by="county")

# Set palette info
n_models = length(unique(df$model_name))
palette = setNames(object = scales::hue_pal()(n_models), nm = unique(df$model_name))

# CRPS RANKING ---
metric <- "crps"
crps_rank <- get_metric_ranking(
    df=df %>% filter(model_name != "acs"),
    metric=metric
)

get_ranking_summary(crps_rank, metric)
plot_rank1(crps_rank, metric=metric, palette=palette)


# RESIDUAL RANKING (ABSOLUTE VALUE) ---
metric="residual"
residual_rank <- get_metric_ranking(
    df=df %>% mutate(residual=abs(residual)),
    metric=metric
)

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
