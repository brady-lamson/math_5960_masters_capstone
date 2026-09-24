# B25002_003

library(tidycensus)
library(dplyr)
library(sf)
library(stringr)
library(tidyr)

tidycensus::census_api_key(Sys.getenv("CENSUS_API_KEY"))

# Find relevant variables from ACS 5 year estimate
vars <- load_variables(
    year = 2020,
    dataset = "acs5"
)

codes <- paste0("B25002_00", 1:3)
acs_df <- tidycensus::get_acs(
        geography="county", 
        variables = c(codes), 
        state="IA", 
        geometry=TRUE, 
        year=2020
    ) %>%
    mutate(
        NAME=stringr::str_replace(NAME, pattern=" County, Iowa$", replacement = ""), # Clean up redundant county names
        sd=moe/1.645,
        variable_name=dplyr::case_when(
            variable == codes[1] ~ "total_housing",
            variable == codes[2] ~ "occupied_housing",
            variable == codes[3] ~ "vacant_housing"
        )
    ) %>%
    # Rename to short names to support ESRI column name character limits (10 characters)
    rename(
        "var"="variable",
        "est"="estimate",
        "var_name" = "variable_name"
    ) %>%
    rename_with(tolower)

path <- "data/acs/housing/2020_5_year_acs_housing.shp"
sf::st_write(
    obj=acs_df,
    dsn=path,
    delete_dsn=TRUE
)

# Save the proportion version of the dataset
acs_proportion_df <- sf::st_read(path) %>%
    select(-c(var, moe)) %>% # Remove columns that break the pivot
    pivot_wider(names_from = var_name, values_from=c(est, sd)) %>%
    mutate(
        est_proportion = est_vacant_housing / est_total_housing,
        sd_proportion = sqrt(sd_vacant_housing^2 - (est_proportion^2 * sd_total_housing)^2) / est_total_housing,
        variance_proportion = sd_proportion^2
    ) %>%
    rename(
        geom=geometry,
        est_prop=est_proportion,
        sd_prop=sd_proportion,
        var_prop=variance_proportion,
        est_vacant=est_vacant_housing,
        est_occu=est_occupied_housing,
        est_all=est_total_housing,
        sd_vacant=sd_vacant_housing,
        sd_occ=sd_occupied_housing,
        sd_all=sd_total_housing
    )

path <- "data/acs/housing/2020_5_year_acs_proportion_response.shp"
sf::st_write(
    obj=acs_proportion_df,
    dsn=path,
    delete_dsn=TRUE
)
