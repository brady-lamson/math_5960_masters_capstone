library(brms)
library(dplyr)
library(sf)
library(readr)
library(ggplot2)

acs_df <- sf::st_read("data/acs/housing/2020_5_year_acs_proportion_response.shp")
acs_df["proportional_sd"] = acs_df$sd_prop / acs_df$est_prop

covariate_df <- readr::read_csv("data/cdl/cdl_covariates.csv") %>%
    mutate(
        geoid = as.character(geoid),
        prop_corn_soy = perc_corn_soy / 100
    ) %>%
    select("geoid", "prop_corn_soy")

census_df <- sf::st_read("data/census/2020_housing_vacancy_rates.shp") %>%
    sf::st_drop_geometry()

full_df <- acs_df %>%
    left_join(covariate_df, by="geoid") %>%
    left_join(census_df, by=c("geoid", "name"))

pred_df <- readr::read_csv("data/model_outputs/all_model_predictions.csv") %>%
    filter(!(model_name %in% c("cdl_only", "cdl_and_icar")) ) %>%
    mutate(
        error_magnitude = abs(residual),
        prop_error_magnitude = abs(proportional_residual)
    ) %>%
    left_join(acs_df %>% select("name", "geometry"), join_by(county == name)) %>%
    sf::st_as_sf()

# High level sd summary
summary(acs_df$sd_prop)
# Max of 0.0269...
# Min of 0.0030...

# What counties are highest in sd in the ACS?
acs_df %>%
    select(name, est_prop, sd_prop, proportional_sd) %>%
    arrange(desc(proportional_sd))

# Shows sd climbs with estiamtte size
plot(acs_df$est_prop, acs_df$sd_prop)
# Shows that proportionally, smaller estimates have a larger error 
plot(acs_df$est_prop, acs_df$proportional_sd)

# PREDICTION DF -------
print("What are the highest residual acs estimates?")
acs_errors <- pred_df %>% 
    filter(model_name == "acs") %>%
    select(county, estimate, sd, true_value, residual, proportional_residual, error_magnitude, prop_error_magnitude, geometry)

n <- 10
top_errors <- acs_errors %>%
    slice_max(error_magnitude, n=n)

print("What are the highest proportional residual acs estimates?")
top_errors_prop <- acs_errors %>%
    slice_max(prop_error_magnitude, n=n)

acs_errors <- acs_errors %>%
    mutate(
        top_10_error = county %in% top_errors$county,
        top_10_prop_error = county %in% top_errors_prop$county
    ) %>%
    mutate(
        error_category = case_when(
            top_10_error & top_10_prop_error ~ "Both",
            top_10_error ~ "Absolute error only",
            top_10_prop_error ~ "Proportional error only",
            TRUE ~ "Neither"
        )
    )

# Takeaway: The largest residuals come from overestimates in the ACS. 
# Also applies on the proportional level as well. All top 10 are positive values. 

ggplot(acs_errors) +
    geom_sf(aes(fill = error_category), color = "black", linewidth = 0.2) +
    scale_fill_manual(
        values = c(
            "Neither" = "white",
            "Absolute error only" = "red",
            "Proportional error only" = "blue",
            "Both" = "purple"
        ),
        name = "Error Category"
    ) +
    ggtitle("Highest ACS Residual Counties") +
    theme_minimal()

acs_errors %>%
    filter(error_category != "Neither") %>%
    select(
        county,
        estimate,
        true_value,
        residual,
        proportional_residual,
        error_category
    ) %>%
    arrange(desc(residual)) %>%
    st_drop_geometry() %>%
    View()

# Dig into prediction df
pred_df %>%
    ggplot(aes(x=true_value, y=estimate, color=model_name)) +
    geom_point(alpha=0.5) +
    geom_abline(slope=1)

pred_df %>%
    ggplot(aes(residual, fill = model_name, colour = model_name)) +
    geom_vline(xintercept=0, color="black", linetype="dashed", linewidth=0.25) +
    geom_density(alpha = 0.1)

pred_df %>%
    ggplot(aes(residual, fill = model_name, colour = model_name)) +
    geom_vline(xintercept=0, color="black", linetype="dashed", linewidth=0.25) +
    geom_boxplot(alpha = 0.1)


compare_to_acs <- pred_df %>%
    group_by(county) %>%
    mutate(
        acs_residual = residual[model_name == "acs"],
        acs_sd = sd[model_name == "acs"],
        delta_residual = residual - acs_residual,
        delta_sd = sd - acs_sd
    ) %>%
    ungroup() %>%
    filter(model_name != "acs") %>%
    select(model_name, county, estimate, sd, residual, delta_residual, delta_sd)

compare_to_acs %>%
    inner_join(top_errors %>% select(county, estimate, true_value), by="county") %>%
    arrange(county) %>% 
    View()

compare_to_acs %>%
    ggplot(aes(x=delta_residual, fill=model_name, colour=model_name)) +
    geom_density(alpha=0.1)

compare_to_acs %>%
    ggplot(aes(x=delta_residual, fill=model_name, colour=model_name)) +
    geom_boxplot(alpha=0.1)

# Summarise differences from acs estimates
compare_to_acs %>%
    group_by(model_name) %>%
    summarise(
        median_resid = median(delta_residual),
        median_sd = median(delta_sd),
        mean_resid = mean(delta_residual),
        mean_sd = mean(delta_sd),
        min_resid = min(delta_residual),
        max_resid = max(delta_residual),
        min_sd = min(delta_sd),
        max_sd = max(delta_sd)
    )
