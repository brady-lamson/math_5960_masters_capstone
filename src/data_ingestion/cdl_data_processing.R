library(sf)
library(tigris)
library(terra) # Using this over Raster as its a newer more well behaved package

path = "data/2023_30m_cdls/2023_30m_cdls.tif"
cdl <- terra::rast(path)

# Load iowa data, align CRS and convert to data type for Terra
iowa <- tigris::states(year = 2023) |>
    tigris::filter_state("iowa") |>
    sf::st_transform(sf::st_crs(cdl)) |>
    terra::vect()

iowa_cdl <- terra::crop(cdl, iowa, mask=TRUE) # This crops out a square region, mask=TRUE makes everything out of the county borders NA
data_dict <- levels(iowa_cdl)[[1]] # [[1]] needed due to nesting behavior from this output, not needed but saved for documentation

terra::writeRaster(iowa_cdl, "data/2023_30m_cdl_iowa_terra.tif")
write.csv(data_dict, "data/cdl_data_dictionary.csv", row.names = FALSE)
