library(brms)
library(dplyr)
library(sf)
library(readr)
library(ggplot2)

acs_df <- sf::st_read("data/acs/housing/2020_5_year_acs_proportion_response.shp")

pred_df <- readr::read_csv("data/model_outputs/all_model_predictions.csv") %>%
    filter(!(model_name %in% c("cdl_only", "cdl_and_icar")) ) %>%
    mutate(
        error_magnitude = abs(residual),
        prop_error_magnitude = abs(proportional_residual)
    ) %>%
    left_join(acs_df %>% select("name", "geometry"), join_by(county == name)) %>%
    sf::st_as_sf() %>%
    mutate(
        model_name = factor(
            model_name,
            levels = c("acs", "intercept_only", "icar_only")
        )
    )

ggplot(pred_df) +
    geom_sf(aes(fill = true_value_captured), color = "white", linewidth = 0.15) +
    facet_wrap(~model_name) +
    scale_fill_manual(
        values = c("TRUE" = "steelblue", "FALSE" = "firebrick"),
        labels = c("TRUE" = "Captured", "FALSE" = "Missed"),
        name = "True value"
    ) +
    labs(
        title = "County-Level Prediction Interval Coverage",
        subtitle = "Comparison of ACS, intercept-only, and ICAR models"
    ) +
    theme_void() +
    theme(
        strip.text = element_text(face = "bold"),
        legend.position = "bottom"
    )

coverage_comparison <- pred_df %>%
    select(county, model_name, true_value_captured) %>%
    st_drop_geometry() %>%
    tidyr::pivot_wider(
        names_from = model_name,
        values_from = true_value_captured
    ) %>%
    select(county, acs, intercept_only, icar_only) %>%
    tidyr::pivot_longer(
        cols = c(intercept_only, icar_only),
        names_to = "model",
        values_to = "model_captured"
    ) %>%
    mutate(
        coverage_outcome = case_when(
            acs & model_captured ~ "Both capture",
            !acs & !model_captured ~ "Both miss",
            !acs & model_captured ~ "SAE gains coverage",
            acs & !model_captured ~ "SAE loses coverage"
        ),
        comparison = recode(
            model,
            intercept_only = "Intercept-only vs. ACS",
            icar_only = "ICAR vs. ACS"
        )
    ) %>%
    left_join(
        pred_df %>%
            select(county, geometry) %>%
            distinct(county, .keep_all = TRUE),
        by = "county"
    ) %>%
    st_as_sf()


ggplot(coverage_comparison) +
    geom_sf(aes(fill = coverage_outcome), color = "white", linewidth = 0.15) +
    facet_wrap(~comparison) +
    scale_fill_manual(
        values = c(
            "Both capture" = "grey75",
            "Both miss" = "grey35",
            "SAE gains coverage" = "steelblue",
            "SAE loses coverage" = "firebrick"
        )
    ) +
    labs(
        title = "Prediction Interval Coverage: SAE Models vs. ACS",
        fill = "Coverage outcome"
    ) +
    theme_void() +
    theme(
        strip.text = element_text(face = "bold"),
        legend.position = "bottom"
    )