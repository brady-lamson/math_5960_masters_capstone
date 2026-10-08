library(terra)
library(tigris)
library(dplyr)
library(ggplot2) 
library(readr) # For read/write
library(tidyr) # For pivoting
source("src/R/cdl_helpers.R")

options(scipen=999) # disable scientific notation
path = "data/cdl/2023_30m_cdl_iowa_terra.tif"
cdl <- terra::rast(path)

counties <- tigris::counties(state = "iowa") %>%
    sf::st_transform(sf::st_crs(cdl)) %>%
    dplyr::select(GEOID, NAME) %>%
    terra::vect()

path <- "data/cdl/county_cdl_aggregation.csv"
if (!file.exists(path)) {
    # Steps: Enter county. Crop/mask cdl down to county. Aggregate summary stats. Populate dataframe.
    # Create empty df to bind rows to. Slow but it works.
    print(paste0("File not found at ", path, " creating dataframe manually ---"))
    county_df <- tibble(
        geoid = character(),
        county = character(),
        total_pixels = integer(),
        crop = character(),
        frequency = integer()
    )
    print("Beginning county level loop ---")
    # I use a for loop instead of lapply here just due to my lack of familiarity with R. This makes this loop quite slow
    # Thankfully with only 99 counties it really isn't too bad. 
    for (i in seq_along(counties)) { # seq_along makes this roughly equivalent to enumerate loops in python
        county_name <- terra::values(counties[i])$NAME
        geoid <- terra::values(counties[i])$GEOID
        print(paste0("Processing County - ", county_name))
        
        county_cdl <- terra::crop(cdl, counties[i], mask=TRUE)
        frequency_df <- cdl_frequency(county_cdl) %>%
            mutate(
                county=county_name,
                geoid=geoid
            )
        
        county_df <- dplyr::bind_rows(county_df, frequency_df)
    }
    
    print("SUCCESS - County loop complete ---")
    
    print(paste0("Writing csv to ", path))
    readr::write_csv(county_df, path)
    print("SUCCESS - csv written")
} else {
    print(paste0("SUCCESS - File located, reading csv at ", path))
    county_df <- readr::read_csv(path)
}

corn_soy_df <- county_df %>%
    filter(crop %in% c("Corn", "Soybeans"))

covariate_df <- corn_soy_df %>%
    select(geoid, county, crop, percentage) %>%
    tidyr::pivot_wider(id_cols = c(geoid, county), names_from=crop, values_from=percentage) %>%
    dplyr::rename(perc_corn = Corn, perc_soy=Soybeans) %>%
    dplyr::mutate(perc_corn_soy = perc_corn + perc_soy)

counties_joined <- terra::merge(counties, covariate_df, by.x=c("GEOID", "NAME"), by.y=c("geoid", "county"))

# Save datasets ---
# I'll be saving both the counties and covariate datasets even though both contain the info
# As the csv will be easier for modeling and the raster will be useful for plotting
terra::writeVector(counties_joined, "data/iowa_aggregated/iowa_counties_aggregated.shp", overwrite=TRUE)
readr::write_csv(covariate_df, "data/iowa_counties_aggregated.csv")
