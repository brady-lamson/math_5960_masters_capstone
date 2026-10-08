library(readr)
library(dplyr)

path <- "data/cdl"
file <- "cdl_frequency.csv"
iowa <- readr::read_csv(paste0(path, "/iowa_", file)) %>%
    mutate(source="Iowa")
usa <- readr::read_csv(paste0(path, "/usa_", file)) %>%
    mutate(source="USA")
cdl_freq <- usa %>%
    bind_rows(iowa) %>%
    arrange(crop) %>%
    select(-c(total_pixels))

# TODO - PIVOT WIDER, get proportion of iowa crop / usa frequency
# Compare to sum(iowa frequency) / sum(usa frequency) to find over-represented crops
cdl_freq
