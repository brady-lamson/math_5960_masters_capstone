library(tidycensus)
library(dplyr)

tidycensus::census_api_key("790cac60174b03ecb62eb40d5348234755b39206")

# Find relevant variables from ACS 5 year estimate
vars <- load_variables(
    year = 2023,
    dataset = "acs5"
)

# 001 - Estimate !! Total
# 002 - Estimate!!Total:!!Agriculture, forestry, fishing and hunting, and mining
x <- tidycensus::get_acs(
        geography="county", 
        variables = c("C24070_001", "C24070_002"), 
        state="IA", 
        geometry=TRUE, 
        year=2023
    ) %>%
    mutate(variable_name = dplyr::if_else(variable == "C24070_001", "all_industries", "agriculture_industry"))

head(x)

x %>%
    filter(variable_name == "all_industries") %>%
    plot()

x %>%
    filter(variable_name == "agriculture_industry") %>%
    plot()
