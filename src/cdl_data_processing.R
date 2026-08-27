# Take enormous 2023 Crop Data Layer (CDL) data set and filter down to only Iowa's data
# Link for source data: https://www.nass.usda.gov/Research_and_Science/Cropland/Release/index.php
# Data: 8/23/2026

library(raster)
library(sf)
library(tigris)

path = "data/2023_30m_cdls/2023_30m_cdls.tif"
cdl <- raster::raster(path)

# Load iowa data, align CRS and convert to data type for Raster
iowa <- tigris::states(year = 2023) |>
    tigris::filter_state("iowa") |>
    sf::st_transform(sf::st_crs(cdl)) |>
    as("Spatial")

# Crop before masking simplify masking. More efficient this way.
# Crop brings us down to a rectangular simplification of iowa
# Mask fully aligns the polygons
iowa_cdl <- raster::crop(cdl, iowa) |>
    raster::mask(iowa)

# Preserve the value mapping as its lost on write to .tiff
data_dictionary <- levels(iowa_cdl)[[1]][, c("ID", "Class_Names")]

# Write files
write.csv(data_dictionary, file = "data/cdl_data_dictionary.csv", row.names = FALSE)
raster::writeRaster(iowa_cdl, filename = "data/2023_30m_cdls_iowa.GTiff", format="GTiff")
