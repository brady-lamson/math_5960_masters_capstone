library(tidycensus)
library(dplyr)
library(sf)
library(stringr)

tidycensus::census_api_key(Sys.getenv("CENSUS_API_KEY"))

# Find relevant variables from 2020 Decenniel Census. DHC is Demographic and Housing Characteristics File (DHC)
# Contains vacancy information I need
vars <- load_variables(
    year = 2020,
    dataset = "dhc"
)

# H3_001N - Total Units
# H3_003N - Total vacant 
census_df <- tidycensus::get_decennial(
    geography="county", 
    variables = c("H3_001N", "H3_003N"), 
    state="IA", 
    geometry=TRUE, 
    year=2020,
    sumfile="dhc" # Where these variables live: https://api.census.gov/data/2020/dec/dhc/variables.html
) %>% 
    mutate(
        NAME=stringr::str_replace(NAME, pattern=" County, Iowa$", replacement = ""), # Clean up redundant county names
        var_name = dplyr::if_else(variable == "H3_001N", "total_units", "vacant_units"),
    ) %>%
    rename_with(tolower)

path <- "data/census/2020_housing_vacancy.shp"
sf::st_write(
    obj=census_df,
    dsn=path,
    delete_dsn=TRUE
)

# Save the proportion version of the dataset
census_proportion_df <- sf::st_read("data/census/2020_housing_vacancy.shp") %>%
    select(-c(variable)) %>% # Remove columns that break the pivot
    pivot_wider(names_from = var_name, values_from=c(value)) %>%
    mutate(
        prop_vac = vacant_units / total_units,
    ) %>%
    rename(
        geom=geometry,
        total=total_units,
        vacant=vacant_units
    )

# Vacancy rates compared with - https://www.census.gov/library/stories/state-by-state/iowa.html
# My proportions match theirs, so we're good to go! 

path <- "data/census/2020_housing_vacancy_rates.shp"
sf::st_write(
    obj=census_proportion_df,
    dsn=path,
    delete_dsn=TRUE
)

plot(census_proportion_df)
