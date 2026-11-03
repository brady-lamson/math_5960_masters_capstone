library(brms)
library(dplyr)
library(sf)
source("src/R/collect_metrics.R")
source("src/R/plotting.R")
library(ggplot2)
library(terra)
library(tidyterra)
library(readr)

acs_df <- sf::st_read("data/acs/2020_5_year_acs_proportion_response.shp")
cdl_covariate <- readr::read_csv("data/cdl/cdl_covariates.csv")

acs_df %>% summary()

acs_df %>% select(sd_all, sd_vacant, sd_prop) %>% summary()

# Two plots... one pure se scatterplot of all vs. vacant
# Second plot.... proportional se scatterplot of all vs. vacant

corc <- cor(acs_df$sd_all, acs_df$sd_vacant)
message <- paste0("italic(r) == ", round(corc, 3))
limits <- c(0, max(acs_df$sd_all, acs_df$sd_vacant) + 10)

fig <- ggplot(acs_df, aes(x=sd_all, y=sd_vacant)) +
    geom_point() +
    geom_abline(lty=3) +
    labs(title="Standard Errors - Total Housing vs. Vacant Housing") +
    xlab("Total Housing SE") +
    ylab("Vacant Housing SE") +
    xlim(limits) +
    ylim(limits) +
    annotate("text", x=500, y=600, label=message, parse=TRUE) +
    theme_classic()

fig

ggsave(fig, filename="images/standard_errors_housing_vs_vacant_scatterplot.png")


# RELATIVE ERRORS SCATTERPLOT - TOTAL VS VACANT ----
acs_df <- acs_df %>%
    mutate(
        relative_sd_all = sd_all / est_all,
        relative_sd_vacant = sd_vacant / est_vacant,
        relative_sd_prop = sd_prop / est_prop,
        sd_ratio_vacant_all = sd_vacant / sd_all
    )
corc <- cor(acs_df$relative_sd_all, acs_df$relative_sd_vacant)
message <- paste0("italic(r) == ", round(corc, 3))
limits <- c(0, max(acs_df$relative_sd_all, acs_df$relative_sd_vacant) + 0.05)

fig <- ggplot(acs_df, aes(x=relative_sd_all, y=relative_sd_vacant)) +
    geom_point() +
    geom_abline(lty=3) +
    labs(title="Relative Standard Errors - Total Housing vs. Vacant Housing") +
    xlab("Total Housing SE / Total Housing Units") +
    ylab("Vacant Housing SE / Vacant Housing Units") +
    xlim(limits) +
    ylim(limits) +
    annotate("text", x=0.2, y=0.3, label=message, parse=TRUE) +
    theme_classic()

fig

ggsave(fig, filename="images/relative_standard_errors_housing_vs_vacant_scatterplot.png")

acs_df %>% select(relative_sd_all, relative_sd_vacant, relative_sd_prop, sd_ratio_vacant_all) %>% summary()

# Direct estimate vs. se
# Direct estimate vs. relative se
error_ylab = "Standard Error"
rel_error_ylab = "Relative Standard Error (SE / Estimate)"
est_xlab = "Estimate"

# TOTALS 
fig <- basic_scatterplot(
    columnA=acs_df$est_all, 
    columnB=acs_df$sd_all, 
    columnA_name=est_xlab,
    columnB_name=error_ylab,
    title="Total Housing Units - Estimate vs. Standard Error"
)

ggsave(fig, file="images/total_units_est_vs_error.png")

fig <- basic_scatterplot(
    columnA=acs_df$est_all, 
    columnB=acs_df$relative_sd_all, 
    columnA_name=est_xlab,
    columnB_name=rel_error_ylab,
    title="Total Housing Units - Estimate vs. Relative Standard Error"
)

ggsave(fig, file="images/total_units_est_vs_rel_error.png")

# VACANT UNITS
fig <- basic_scatterplot(
    columnA=acs_df$est_vacant, 
    columnB=acs_df$sd_vacant, 
    columnA_name=est_xlab,
    columnB_name=error_ylab,
    title="Vacant Housing Units - Estimate vs. Standard Error"
)

ggsave(fig, file="images/vacant_units_est_vs_error.png")

fig <- basic_scatterplot(
    columnA=acs_df$est_vacant, 
    columnB=acs_df$relative_sd_vacant, 
    columnA_name=est_xlab,
    columnB_name=rel_error_ylab,
    title="Vacant Housing Units - Estimate vs. Relative Standard Error"
)

ggsave(fig, file="images/vacant_units_est_vs_rel_error.png")

# VACANCY RATES 
fig <- basic_scatterplot(
    columnA=acs_df$est_prop, 
    columnB=acs_df$sd_prop, 
    columnA_name=est_xlab,
    columnB_name=error_ylab,
    title="Vacancy Rates - Estimate vs. Standard Error"
)

ggsave(fig, file="images/vacancy_rates_est_vs_error.png")

fig <- basic_scatterplot(
    columnA=acs_df$est_prop, 
    columnB=acs_df$relative_sd_prop, 
    columnA_name=est_xlab,
    columnB_name=rel_error_ylab,
    title="Vacancy Rates - Estimate vs. Relative Standard Error"
)

ggsave(fig, file="images/vacancy_rates_est_vs_rel_error.png")

# Spatial plot showing relative standard error

fig <- ggplot(acs_df, aes(fill= relative_sd_prop)) +
    geom_sf() +
    coord_sf() +
    labs(
        title="Vacancy Rate - Relative Standard Error by County",
        fill="Rel. SE"
    ) +
    theme_minimal()
fig


# DENSITY PLOTS OF RESPONSE ---

fig <- ggplot(acs_df, aes(x=est_prop)) +
    geom_density() +
    ggtitle("Distribution of Vacancy Rate") +
    xlab("Estimate") +
    xlim(c(0, max(acs_df$est_prop) + 0.05)) +
    theme_minimal()

fig
ggsave(fig, file="images/response_density.png")


limits <- c(
    min(acs_df$est_logit) - 0.5,
    max(acs_df$est_logit) + 0.5
)
fig <- ggplot(acs_df, aes(x=est_logit)) +
    geom_density() +
    ggtitle("Distribution of Vacancy Rate (Logit Transformed)") +
    xlab("Estimate") +
    xlim(limits) +
    theme_minimal()

fig
ggsave(fig, file="images/response_logit_density.png")

# DENSITY PLOTS OF ERRORS ---
fig <- ggplot(acs_df, aes(x=sd_prop)) +
    geom_density() +
    ggtitle("Distribution of Vacancy Rate Standard Error") +
    xlab("Standard Error") +
    xlim(c(0, max(acs_df$sd_prop) + 0.01)) +
    theme_minimal()
fig
ggsave(fig, file="images/error_density.png")

fig <- ggplot(acs_df, aes(x=sd_logit)) +
    geom_density() +
    ggtitle("Distribution of Logit Vacancy Rate Standard Error") +
    xlab("Standard Error") +
    xlim(c(0, max(acs_df$sd_logit) + 0.1)) +
    theme_minimal()

fig
ggsave(fig, file="images/error_logit_density.png")

# RESPONSE VS COVARIATE ---
temp_df <- acs_df %>%
    select(name, est_prop) %>%
    rename(county = name) %>%
    left_join(
        cdl_covariate %>% select(county, perc_corn_soy),
        by="county"
    ) %>%
    mutate(prop_corn_soy = perc_corn_soy / 100) %>%
    st_drop_geometry()

fig <- basic_scatterplot(
    columnA=temp_df$est_prop, 
    columnB=temp_df$prop_corn_soy, 
    columnA_name="Vacancy Rate",
    columnB_name="Proportion Corn or Soy",
    title="Response vs. Covariate"
)

fig
ggsave(fig, filename="response_vs_covariate.png")
