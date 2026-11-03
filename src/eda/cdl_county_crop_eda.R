library(dplyr)
library(ggplot2) 
library(readr) # For read/write
library(tidyr) # For pivoting
library(terra)
library(tigris)

path <- "data/cdl/county_cdl_frequency.csv"
county_df <- readr::read_csv(path)

path = "data/cdl/2020_30m_cdl_iowa_terra.tif"
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
# Min.   :19001   Length:198         Min.   :1151448   Length:198         Min.   : 107494   Min.   : 6.529  
# 1st Qu.:19050   Class :character   1st Qu.:1377575   Class :character   1st Qu.: 347422   1st Qu.:24.412  
# Median :19099   Mode  :character   Median :1650770   Mode  :character   Median : 507230   Median :31.710  
# Mean   :19099                      Mean   :1638511                      Mean   : 530450   Mean   :32.075  
# 3rd Qu.:19148                      3rd Qu.:1701961                      3rd Qu.: 690556   3rd Qu.:41.261  
# Max.   :19197                      Max.   :2807359                      Max.   :1402267   Max.   :57.502

# COVARIATE DF
covariate_df <- readr::read_csv("data/cdl/cdl_covariates.csv")

covariate_summary <- covariate_df %>%
    select(perc_soy, perc_corn, perc_corn_soy) %>%
    summary()
covariate_summary
# geoid          county             perc_soy        perc_corn      perc_corn_soy  
# Min.   :19001   Length:99          Min.   : 6.529   Min.   : 8.585   Min.   :19.95  
# 1st Qu.:19050   Class :character   1st Qu.:21.139   1st Qu.:29.528   1st Qu.:52.51  
# Median :19099   Mode  :character   Median :27.469   Median :41.317   Median :69.36  
# Mean   :19099                      Mean   :26.424   Mean   :37.726   Mean   :64.15  
# 3rd Qu.:19148                      3rd Qu.:32.215   3rd Qu.:47.726   3rd Qu.:77.84  
# Max.   :19197                      Max.   :38.464   Max.   :57.502   Max.   :88.51  

# Conversion to dataframe done by chatgpt
# Certainly not code I'd ever write.
covariate_summary <- covariate_df %>%
    summarise(
        across(
            c(perc_soy, perc_corn, perc_corn_soy),
            list(
                Minimum = min,
                Q1 = \(x) quantile(x, 0.25),
                Median = median,
                Mean = mean,
                Q3 = \(x) quantile(x, 0.75),
                Maximum = max
            )
        )
    ) %>%
    pivot_longer(
        everything(),
        names_to = c("variable", "statistic"),
        names_sep = "_(?=[^_]+$)",
        values_to = "value"
    ) %>%
    pivot_wider(
        names_from = variable,
        values_from = value
    )

readr::write_csv(covariate_summary, "data/cdl/covariate_summary.csv")

counties_joined <- terra::merge(counties, covariate_df, by.x=c("GEOID", "NAME"), by.y=c("geoid", "county"))
breaks <- seq(0, 100, 10)
terra::plot(counties_joined, "perc_corn_soy", main="Percentage of Corn and Soybean Land Coverage by County", breaks=breaks)

# ggsave(fig, filename="images/corn_soy_land_coverage.png")
terra::plot(counties_joined, "perc_corn", main = "Percentage of Corn Land Coverage by County", breaks=breaks)
terra::plot(counties_joined, "perc_soy", main = "Percentage of Soybean Land Coverage by County", breaks=breaks)
