# Re-using code from `cdl_eda` here. Starting with an overall summary of USA crop proportions
# Potential for per-state here, where we could compare corn/soy and see where Iowa ranks

library(tigris)
library(terra)
library(dplyr)
library(readr)
source("src/R/cdl_helpers.R")

path = "data/2023_30m_cdls/2023_30m_cdls.tif"
cdl <- terra::rast(path)

states <- tigris::states(year=2020) |>
    # CDL is only for the 48 contiguous states, gotta filter out other territories here as well
    dplyr::filter(!STUSPS %in% c("AK", "HI", "PR", "GU", "VI", "MP", "AS")) |>
    sf::st_transform(sf::st_crs(cdl)) |>
    terra::vect()

# --- Frequency eda for all of USA
frequency_df <- cdl_frequency(cdl)
readr::write_csv(frequencies_df, "data/usa_cdl_frequency.csv")