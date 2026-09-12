library(raster)

path = "data/2023_30m_cdls_iowa.tif"
cdl <- raster::raster(path)
data_dict <- read.csv("data/cdl_data_dictionary.csv")

counties <- tigris::counties(state = "iowa") |>
    sf::st_transform(sf::st_crs(cdl)) |>
    as("Spatial")

plot(cdl)
plot(counties, add=TRUE, border="black")

corn <- cdl == 1
plot(corn, main="Spatial distribution of corn")
plot(counties, add=TRUE, border="black")

soy <- cdl == 5
plot(soy, main="Spatial distribution of soy")
plot(counties, add=TRUE, border="black")
