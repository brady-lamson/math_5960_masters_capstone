library(terra)
library(readr)
source("src/R/cdl_helpers.R")

path = "data/cdl/2023_30m_cdl_iowa_terra.tif"
cdl <- terra::rast(path)

counties <- tigris::counties(year=2020, state = "iowa") |>
    sf::st_transform(sf::st_crs(cdl)) |>
    terra::vect()

plot(cdl)
plot(counties, add=TRUE, border="black")

corn <- cdl == 1
plot(corn, main="Spatial distribution of corn")
plot(counties, add=TRUE, border="black")

soy <- cdl == 5
plot(soy, main="Spatial distribution of soy")
plot(counties, add=TRUE, border="black")

# --- Frequency eda for all of Iowa
# General eda for Iowa, crop frequency analysis ---
frequencies_df <- cdl_frequency(cdl)
readr::write_csv(frequencies_df, "data/cdl/iowa_cdl_frequency.csv")

frequencies_df %>%
    filter(percentage > 0.5) %>%
    mutate(
        name=factor(value, levels=value),
        percentage=round(percentage, digits=2)
    ) %>%
    ggplot(aes(y= name, x=percentage)) +
    geom_col() +
    geom_text(aes(label=percentage), hjust=-0.25) +
    labs(
        x = "Name",
        y = "Percentage"
    )

plot(cdl)
lines(counties, col="white")