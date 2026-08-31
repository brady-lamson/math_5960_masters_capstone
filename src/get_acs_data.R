library(tidycensus)
library(dplyr)
library(sf)

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
