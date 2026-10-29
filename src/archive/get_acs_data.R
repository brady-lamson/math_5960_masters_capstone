library(tidycensus)
library(dplyr)
library(sf)
library(stringr)

tidycensus::census_api_key(Sys.getenv("CENSUS_API_KEY"))

# Find relevant variables from ACS 5 year estimate
vars <- load_variables(
    year = 2023,
    dataset = "acs5"
)

# 001 - Estimate !! Total
# 002 - Estimate!!Total:!!Agriculture, forestry, fishing and hunting, and mining
acs_df <- tidycensus::get_acs(
        geography="county", 
        variables = c("C24070_001", "C24070_002"), 
        state="IA", 
        geometry=TRUE, 
        year=2023
    ) %>%
    mutate(
        NAME=stringr::str_replace(NAME, pattern=" County, Iowa$", replacement = ""), # Clean up redundant county names
        variable_name = dplyr::if_else(variable == "C24070_001", "all_industries", "agriculture_industry"),
        sd = moe/1.645 # This is the way to convert from moe to sd given by the census bureau
    ) %>%
    # Rename to short names to support ESRI column name character limits (10 characters)
    rename(
        "var"="variable",
        "est"="estimate",
        "var_name" = "variable_name"
    ) %>%
    rename_with(tolower)

path <- "data/acs/2023_5_year_acs.shp"
sf::st_write(
    obj=acs_df,
    dsn=path,
    delete_dsn=TRUE
)

# Save the proportion version of the dataset
acs_proportion_df <- sf::st_read("data/acs/2023_5_year_acs.shp") %>%
    select(-c(var, moe)) %>% # Remove columns that break the pivot
    pivot_wider(names_from = var_name, values_from=c(est, sd)) %>%
    mutate(
        est_proportion = est_agriculture_industry / est_all_industries,
        sd_proportion = sqrt(sd_agriculture_industry^2 - (est_proportion^2 * sd_all_industries)^2) / est_all_industries,
        variance_proportion = sd_proportion^2
    ) %>%
    rename(
        geom=geometry,
        est_prop=est_proportion,
        sd=sd_proportion,
        var=variance_proportion,
        est_agri=est_agriculture_industry,
        est_all=est_all_industries,
        sd_agri=sd_agriculture_industry,
        sd_all=sd_all_industries
    )

path <- "data/acs/2023_5_year_acs_proportion_response.shp"
sf::st_write(
    obj=acs_proportion_df,
    dsn=path,
    delete_dsn=TRUE
)
