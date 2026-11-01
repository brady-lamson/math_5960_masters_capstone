library(brms)
library(dplyr)
library(sf)
source("src/R/collect_metrics.R")
library(ggplot2)
library(terra)
library(tidyterra)

acs_df <- sf::st_read("data/acs/2020_5_year_acs_proportion_response.shp")

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
