library(terra)
library(tigris)
library(dplyr)
library(ggplot2) 
library(readr) # For read/write
library(tidyr) # For pivoting

options(scipen=999) # disable scientific notation
path = "data/2023_30m_cdl_iowa_terra.tif"
cdl <- terra::rast(path)

counties <- tigris::counties(state = "iowa") %>%
    sf::st_transform(sf::st_crs(cdl)) %>%
    dplyr::select(GEOID, NAME) %>%
    terra::vect()

path <- "data/county_cdl_aggregation.csv"
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
        pixels <- terra::size(county_cdl)
        frequency_df <- terra::freq(county_cdl) %>%
            tibble() %>%
            select("value", "count") %>%
            mutate(
                geoid = geoid,
                county = county_name,
                total_pixels = pixels
            ) %>%
            rename(
                crop = value,
                frequency = count
            )
        
        county_df <- dplyr::bind_rows(county_df, frequency_df)
    }
    
    print("SUCCESS - County loop complete ---")
    county_df <- county_df %>%
        mutate(percentage = frequency / total_pixels * 100) 
    
    print(paste0("Writing csv to ", path))
    readr::write_csv(county_df, path)
    print("SUCCESS - csv written")
} else {
    print(paste0("SUCCESS - File located, reading csv at ", path))
    county_df <- readr::read_csv(path)
}

# EXPLORE THE DATAFRAME ---
table(county_df$crop)

# Curious about the double crops, should I include them?
double_crops <- county_df %>%
    filter(grepl("^Dbl", crop))

dbl_crop_pixels <- sum(double_crops$frequency)
print(paste0("Total double crop pixel count: ", dbl_crop_pixels))
summary(double_crops$percentage)
# Note: Double crops are extremely infrequent, totaling up to only 4174 pixels overall.
# Max percentage for a double crop in a county is 0.037%. A fraction of a percent.
# Due to this, will be removing them from analysis to simplify things.

# Examine top 3 crops per county ---
top_3_crops <- county_df %>%
    arrange(desc(percentage)) %>%
    group_by(county) %>%
    slice(1:3)

table(top_3_crops$crop)
# Note: Top 3 crops for the counties simplify down to 4 categories
# - Corn, Soybeans, Deciduous Forest, Grassland/Pasture
# I don't want to include the latter two, so I'll be filtering to just corn and soy

corn_soy_df <- county_df %>%
    filter(crop %in% c("Corn", "Soybeans"))

# Note, will need to put in zero if any counties are missing. 
counties_with_corn_soy <- corn_soy_df %>% select(county) %>% distinct() %>% count()
counties_with_corn_soy == length(counties)
# We're good! 
summary(corn_soy_df)
#     geoid          county           total_pixels         crop             frequency         percentage   
# Min.   :19001   Length:198         Min.   :1163712   Length:198         Min.   : 102866   Min.   : 5.29  
# 1st Qu.:19050   Class :character   1st Qu.:1588944   Class :character   1st Qu.: 335693   1st Qu.:19.91  
# Median :19099   Mode  :character   Median :1748824   Mode  :character   Median : 507708   Median :29.72  
# Mean   :19099                      Mean   :1837672                      Mean   : 514853   Mean   :28.30  
# 3rd Qu.:19148                      3rd Qu.:1949017                      3rd Qu.: 656395   3rd Qu.:35.86  
# Max.   :19197                      Max.   :3353280                      Max.   :1325786   Max.   :47.78  

# CREATE COVARIATE DF ---
# for this I want 1 row per county. So we'll be taking in 3 columns but really we'll only be using one.
covariate_df <- corn_soy_df %>%
    select(geoid, county, crop, percentage) %>%
    tidyr::pivot_wider(id_cols = c(geoid, county), names_from=crop, values_from=percentage) %>%
    dplyr::rename(perc_corn = Corn, perc_soy=Soybeans) %>%
    dplyr::mutate(perc_corn_soy = perc_corn + perc_soy)

summary(covariate_df)
# geoid          county            perc_corn         perc_soy     perc_corn_soy  
# Min.   :19001   Length:99          Min.   : 9.124   Min.   : 5.29   Min.   :16.79  
# 1st Qu.:19050   Class :character   1st Qu.:22.876   1st Qu.:18.35   1st Qu.:42.60  
# Median :19099   Mode  :character   Median :34.117   Median :26.32   Median :62.13  
# Mean   :19099                      Mean   :31.840   Mean   :24.76   Mean   :56.60  
# 3rd Qu.:19148                      3rd Qu.:40.458   3rd Qu.:30.99   3rd Qu.:70.79  
# Max.   :19197                      Max.   :47.783   Max.   :39.33   Max.   :85.46  

breacks 
counties_joined <- terra::merge(counties, covariate_df, by.x=c("GEOID", "NAME"), by.y=c("geoid", "county"))
breaks <- seq(0, 100, 10)
terra::plot(counties_joined, "perc_corn_soy", main="Percentage of Corn and Soybean Land Coverage by County", breaks=breaks)
terra::plot(counties_joined, "perc_corn", main = "Percentage of Corn Land Coverage by County", breaks=breaks)
terra::plot(counties_joined, "perc_soy", main = "Percentage of Soybean Land Coverage by County", breaks=breaks)

# Save datasets ---
# I'll be saving both the counties and covariate datasets even though both contain the info
# As the csv will be easier for modeling and the raster will be useful for plotting
terra::writeVector(counties_joined, "data/iowa_aggregated/iowa_counties_aggregated.shp")
readr::write_csv(covariate_df, "data/iowa_counties_aggregated.csv")
