library(dplyr)
library(sf)
library(spdep)
library(ggplot2)

acs_df <- sf::st_read("data/acs/2020_5_year_acs_proportion_response.shp")
head(acs_df)

neighbor_list <- spdep::poly2nb(acs_df, queen=TRUE)
coords <- st_coordinates(st_centroid(st_geometry(acs_df)))
acs_df["neighbor_count"] <- lengths(neighbor_list)
summary(acs_df$neighbor_count)

neighbors_sf <- as(nb2lines(neighbor_list, coords=coords), 'sf')
neighbors_sf <- st_set_crs(neighbors_sf, st_crs(acs_df))

fig <- ggplot(acs_df) +
    geom_sf(fill = 'deepskyblue3', color='white') +
    geom_sf(data=neighbors_sf) +
    geom_sf(data = st_centroid(acs_df), color = "white", size = 1) +
    labs(title="Iowa County Neighbor Connections") +
    theme_minimal()

fig

ggsave(fig, filename="images/iowa_neighborhood_links.png")
