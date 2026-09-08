# This script is related to all results found from fitting intercept only fh models.
# I use two approaches here, one using the direct estimate of the agricultural workforce
# Another, using the proportion of agricultural workers/all industries

library(emdi)
library(dplyr)
library(sf)
library(ggplot2)
library(tidyr)
library(patchwork)
library(stringr)

full_acs_data <- sf::st_read("data/acs/2023_5_year_acs.shp")
acs_df <- full_acs_data %>%
    mutate(variance = sd^2) %>%
    filter(var_name == "agriculture_industry")
head(acs_df)

# fh wants a pure dataframe. For the simplest FH model we don't care about the spatial aspect anyway.
simple_df <- sf::st_drop_geometry(acs_df)

simple_df %>%
    select("name", "est", "sd", "variance") %>%
    summary()

# Basic estimate density/sd plots
plot1 <- simple_df %>%
    ggplot() +
    geom_density(aes(x=est))

plot2 <- simple_df %>%
    ggplot() +
    geom_density(aes(x=sd))

plot1 + plot2

# Plot showing that larger estimates appear to have smaller proportional variances

plot1 <- ggplot(simple_df) +
    geom_point(aes(x=est, y=sd)) + 
    ggtitle("Direct estimate vs sigma")

plot2 <- ggplot(simple_df) +
    geom_point(aes(x=est, y=(sd / est))) +
    ggtitle("Direct estimate vs proportional sigma")

plot1 + plot2

# Fit intercept only fh model ------

fh_simple <- emdi::fh(
    fixed = est ~ 1,
    domains="name",
    vardir = "variance",
    combined_data=simple_df,
    correlation="no", # change to 'spatial' later perhaps
    maxit=100,  # default
    tol=0.0001 # default
)

fh_simple

summary(fh_simple)

fh_simple$model

# Join results back to dataframe for analysis
fh_df <- fh_simple$ind
new_df <- dplyr::left_join(simple_df, fh_df, by=c("name"="Domain")) %>%
    rename_with(tolower) %>%
    select(
        "name",
        "est",
        "fh",
        "sd"
    ) %>%
    mutate(delta=est-fh)

new_df %>%
    dplyr::arrange(est)

# PLOT: direct vs fay herriot estimates
max_lim <- max(c(new_df$est, new_df$fh)) + 100
limits <- c(0, max_lim)
ggplot(new_df) +
    geom_point(aes(x=est, y=fh)) +
    geom_abline(intercept=0, slope=1) +
    xlim(limits) +
    ylim(limits)

# More plots - Another way of comparing estimates
plot(new_df$est, type="o", col="blue", pch=16)
points(new_df$fh, type="o", col="red", pch=17)

# RESPONSE AS A PROPORTION
# The following mutation follows census bureau guidelines on how to handle
# Proportions in the ACS data

acs_proportion_df <- full_acs_data %>%
    select(-c(var, moe)) %>% # Remove columns that break the pivot
    pivot_wider(names_from = var_name, values_from=c(est, sd)) %>%
    mutate(
        est_proportion = est_agriculture_industry / est_all_industries,
        sd_proportion = sqrt(sd_agriculture_industry^2 - (est_proportion^2 * sd_all_industries)^2) / est_all_industries,
        variance_proportion = sd_proportion^2
    )

acs_proportion_df

simple_df2 <- sf::st_drop_geometry(acs_proportion_df) %>%
    as.data.frame() # emdi doesnt seem to work with tibbles
#select("geoid", "name", "est_proportion", "variance_proportion")

# Fit the second model - proportion response
fh_simple2 <- emdi::fh(
    fixed = est_proportion ~ 1,
    domains="name",
    vardir = "variance_proportion",
    combined_data=simple_df2,
    correlation="no", # change to 'spatial' later perhaps
    maxit=100,  # default
    tol=0.0001 # default
)

fh_simple2

fh_simple2$model

summary(fh_simple2)

fh_df2 <- fh_simple2$ind
new_df2 <- dplyr::left_join(simple_df2, fh_df2, by=c("name"="Domain")) %>%
    rename_with(tolower) %>%
    select(
        "name",
        "est_proportion",
        "fh",
        "sd_proportion"
    ) %>%
    mutate(delta=est_proportion-fh)

new_df2

summary(new_df2)

# PLOT: Behavior is overall the same as the original model, but this is unsurprising
# This wont be my primary way of seeing if this is a good idea
max_lim <- max(c(new_df2$est_proportion, new_df2$fh)) + 0.01
limits <- c(0, max_lim)
ggplot(new_df2) +
    geom_point(aes(x=est_proportion, y=fh)) +
    geom_abline(intercept=0, slope=1) +
    xlim(limits) +
    ylim(limits)

# --- BASIC COUNTY MAPS --- 
plot(
    acs_proportion_df["est_proportion"],
    breaks = "quantile",
    nbreaks = 5,
    pal = hcl.colors(5, "YlOrRd"),
    main = "Estimated Agricultural Employment Proportion"
)

plot(
    acs_proportion_df["est_agriculture_industry"],
    breaks = "quantile",
    nbreaks = 5,
    pal = hcl.colors(5, "YlOrRd"),
    main = "Estimated Agricultural Employment"
)

plot(
    acs_proportion_df["est_all_industries"],
    breaks = "quantile",
    nbreaks = 10,
    pal = hcl.colors(10, "YlOrRd"),
    main = "Estimated Employment"
)