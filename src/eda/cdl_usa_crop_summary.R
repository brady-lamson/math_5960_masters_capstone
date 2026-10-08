# Re-using code from `cdl_eda` here. Starting with an overall summary of USA crop proportions
# Potential for per-state here, where we could compare corn/soy and see where Iowa ranks

library(tigris)
library(terra)
library(dplyr)
library(readr)
source("src/R/cdl_helpers.R")

path = "data/cdl/2020_30m_cdls/2020_30m_cdls.tif"
cdl <- terra::rast(path)

# --- Frequency eda for all of USA
frequency_df <- cdl_frequency(cdl)
readr::write_csv(frequency_df, "data/cdl/usa_cdl_frequency.csv")
