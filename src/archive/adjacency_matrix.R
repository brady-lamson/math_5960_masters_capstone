# This script is for developing code to get an adjacency matrix
# Should be short and sweet, code will be re-used in later scripts.

library(dplyr)
library(sf)
library(spdep)

acs_df <- sf::st_read("data/acs/2023_5_year_acs_proportion_response.shp")
head(acs_df)

neighbor_list <- spdep::poly2nb(acs_df, queen=TRUE)
coords <- st_coordinates(st_centroid(st_geometry(acs_df)))

plot(st_geometry(acs_df), border="grey60")
plot(neighbor_list, coords = coords, add=TRUE, pch=19, cex=0.6, col="blue")

summary(neighbor_list)

# Let's test for spatial autocorrelation for the response
neighbor_listw <- spdep::nb2listw(neighbor_list, style="B")
spdep::moran.test(acs_df$est_prop, listw = neighbor_listw, randomisation = FALSE)
