library(dplyr)
library(ggplot2) 
library(readr) # For read/write
library(tidyr) # For pivoting
library(terra)
library(tigris)

path <- "data/cdl/county_cdl_aggregation.csv"
county_df <- readr::read_csv(path)

path = "data/cdl/2023_30m_cdl_iowa_terra.tif"
cdl <- terra::rast(path)

counties <- tigris::counties(state = "iowa") %>%
    sf::st_transform(sf::st_crs(cdl)) %>%
    dplyr::select(GEOID, NAME) %>%
    terra::vect()

# EXPLORE THE DATAFRAME ---
table(county_df$crop)

# Curious about the double crops, should I include them?
double_crops <- county_df %>%
    filter(grepl("^Dbl", crop))

dbl_crop_pixels <- sum(double_crops$frequency)
print(paste0("Total double crop pixel count: ", dbl_crop_pixels))
summary(double_crops$percentage)
# Note: Double crops are extremely infrequent, totaling up to only 4174 pixels overall.
# Max percentage for a double crop in a county is 0.042%. A fraction of a percent.
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
# geoid          county           total_pixels         crop             frequency         percentage    
# Min.   :19001   Length:198         Min.   :1151448   Length:198         Min.   : 102866   Min.   : 6.853  
# 1st Qu.:19050   Class :character   1st Qu.:1377575   Class :character   1st Qu.: 335693   1st Qu.:24.128  
# Median :19099   Mode  :character   Median :1650770   Mode  :character   Median : 507708   Median :32.398  
# Mean   :19099                      Mean   :1638511                      Mean   : 514853   Mean   :31.110  
# 3rd Qu.:19148                      3rd Qu.:1701961                      3rd Qu.: 656395   3rd Qu.:38.979  
# Max.   :19197                      Max.   :2807359                      Max.   :1325786   Max.   :51.480 

# COVARIATE DF
covariate_df <- readr::read_csv("data/iowa_counties_aggregated.csv")

summary(covariate_df)
# geoid          county            perc_corn         perc_soy      perc_corn_soy  
# Min.   :19001   Length:99          Min.   : 9.773   Min.   : 6.853   Min.   :17.99  
# 1st Qu.:19050   Class :character   1st Qu.:27.537   1st Qu.:22.268   1st Qu.:50.48  
# Median :19099   Mode  :character   Median :38.101   Median :29.264   Median :67.33  
# Mean   :19099                      Mean   :35.069   Mean   :27.151   Mean   :62.22  
# 3rd Qu.:19148                      3rd Qu.:43.823   3rd Qu.:33.307   3rd Qu.:76.58  
# Max.   :19197                      Max.   :51.480   Max.   :39.751   Max.   :87.19 

counties_joined <- terra::merge(counties, covariate_df, by.x=c("GEOID", "NAME"), by.y=c("geoid", "county"))
breaks <- seq(0, 100, 10)
terra::plot(counties_joined, "perc_corn_soy", main="Percentage of Corn and Soybean Land Coverage by County", breaks=breaks)
terra::plot(counties_joined, "perc_corn", main = "Percentage of Corn Land Coverage by County", breaks=breaks)
terra::plot(counties_joined, "perc_soy", main = "Percentage of Soybean Land Coverage by County", breaks=breaks)
