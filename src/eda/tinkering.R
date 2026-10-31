library(brms)
library(dplyr)
library(sf)
source("src/R/collect_metrics.R")
library(ggplot2)
library(terra)
library(tidyterra)

acs_df <- sf::st_read("data/acs/2020_5_year_acs_proportion_response.shp")
census_df <- sf::st_read("data/census/2020_housing_vacancy_rates.shp") %>%
    mutate(
        total_perc = total / sum(.$total),
        vacant_perc = vacant / sum(.$vacant)
    )

census_df %>%
    select(total, vacant, prop_vac) %>%
    st_drop_geometry() %>%
    summary() %>%
    as.data.frame()

census_df %>%
    filter(total < 5000) %>%
    View()

joined_df <- acs_df %>%
    select(name, est_all, est_vacant, sd_all, sd_vacant, est_prop, sd_prop) %>%
    st_drop_geometry() %>%
    left_join(census_df, by="name")

census_df %>%
    arrange(desc(total_perc))

plot_df <- census_df %>%
    slice_max(total, n=10) %>%
    arrange(desc(total))

ggplot(plot_df, aes(x=reorder(name, total), y=total)) +
    geom_bar(stat="identity") +
    coord_flip()

corc <- cor(census_df$total, census_df$vacant)
message <- paste0("italic(r) == ", round(corc, 3))

fig <- ggplot(census_df, aes(x=total, y=vacant)) +
    geom_point() +
    labs(title="Total Housing vs. Vacant Housing Units") +
    xlab("Total Housing Units") +
    ylab("Vacant Housing Units") +
    annotate("text", x=200000, y=15000, label=message, parse=TRUE) +
    theme_classic()

fig

ggsave(fig, filename="images/housing_vs_vacant_scatterplot.png")

corc <- cor(census_df$total, census_df$prop_vac)
message <- paste0("italic(r) == ", round(corc, 3))
fig <- ggplot(census_df, aes(x=total, y=prop_vac * 100)) +
    geom_point() +
    labs(title="Total Housing vs. Vacancy Rates") +
    xlab("Total Housing Units") +
    ylab("Vacancy Rate (%)") +
    annotate("text", x=200000, y=40, label=message, parse=TRUE) +
    theme_classic()
fig

ggsave(fig, filename="images/housing_vs_vacancy_rates_scatterplot.png")

fig <- ggplot(census_df, aes(fill=total)) +
    geom_sf() +
    coord_sf() +
    labs(
        title="Number of Housing Units by County",
        fill="Count"
    ) +
    theme_minimal()

fig
ggsave(fig, filename="images/num_houses_by_county.png")

fig <- ggplot(census_df, aes(fill=prop_vac * 100)) +
    geom_sf() +
    coord_sf() +
    labs(
        title="Vacancy Rate by County",
        fill="Rate (%)"
    ) +
    theme_minimal()
fig
ggsave(fig, filename="images/vacancy_rate_by_county.png")



# iowa cdl contour plot

# path = "data/cdl/2020_30m_cdl_iowa_terra.tif"
# cdl <- terra::rast(path)
# cdl2 <- terra::mask(cdl, cdl %in% c("Corn", "Soybeans"), maskvalue=FALSE)
# cdl3 <- terra::ifel(
#     is.na(cdl), NA,
#     terra::ifel(cdl %in% c("Corn", "Soybeans"), 1, 0)
# )
# 
# ggplot() +
#     geom_spatraster_contour(data=cdl3)
