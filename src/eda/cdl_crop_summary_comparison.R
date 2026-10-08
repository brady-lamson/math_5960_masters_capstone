library(readr)
library(dplyr)

path <- "data/cdl"
file <- "cdl_frequency.csv"
iowa <- readr::read_csv(paste0(path, "/iowa_", file)) %>%
    mutate(source="Iowa")
usa <- readr::read_csv(paste0(path, "/usa_", file)) %>%
    mutate(source="USA")
cdl_freq <- usa %>%
    union(iowa, by="value")
