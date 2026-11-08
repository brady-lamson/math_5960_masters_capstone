library(dplyr)
source("src/R/plotting.R")

pred_df <- readr::read_csv("data/model_outputs/all_model_predictions.csv") %>%
    filter(model_name %in% c("acs", "intercept_only", "icar_only", "emdi_intercept_only")) %>%
    select(
        model_name,
        county,
        residual,
        sd
    ) %>%
    pivot_wider(
        id_cols=county,
        names_from=model_name, 
        values_from=c(residual, sd), 
        names_sep="_"
    )

# RESIDUAL PLOTS -----

abline = TRUE
show_corr = TRUE
match_limits = TRUE
color_by_abline = TRUE

fig <- basic_scatterplot(
    abs(pred_df$residual_acs), 
    abs(pred_df$residual_intercept_only),
    columnA_name = "ACS", 
    columnB_name = "Intercept Only", 
    title="ACS vs Intercept Only - Residual Absolute Values",
    abline = abline,
    show_corr = show_corr,
    match_limits = match_limits,
    color_by_abline = color_by_abline
)

ggsave(fig, filename="images/residual_scatterplot_acs_int_only.png")

fig <- basic_scatterplot(
    abs(pred_df$residual_acs), 
    abs(pred_df$residual_icar_only),
    columnA_name = "ACS", 
    columnB_name = "ICAR Only", 
    title="ACS vs ICAR Only - Residual Absolute Values",
    abline = abline,
    show_corr = show_corr,
    match_limits = match_limits,
    color_by_abline = color_by_abline
)

ggsave(fig, filename="images/residual_scatterplot_acs_icar_only.png")

fig <- basic_scatterplot(
    abs(pred_df$residual_intercept_only), 
    abs(pred_df$residual_icar_only),
    columnA_name = "Intercept Only", 
    columnB_name = "ICAR Only", 
    title="Intercept Only vs ICAR Only - Residual Absolute Values",
    abline = abline,
    show_corr = show_corr,
    match_limits = match_limits,
    color_by_abline = color_by_abline
)

ggsave(fig, filename="images/residual_scatterplot_int_icar_only.png")

fig <- basic_scatterplot(
    abs(pred_df$residual_acs), 
    abs(pred_df$residual_emdi_intercept_only),
    columnA_name = "ACS", 
    columnB_name = "Intercept Only (Frequentist)", 
    title="ACS vs Intercept Only (Frequentist) - Residual Absolute Values",
    abline = abline,
    show_corr = show_corr,
    match_limits = match_limits,
    color_by_abline = color_by_abline
)

ggsave(fig, filename="images/residual_scatterplot_acs_int_freq.png")


fig <- basic_scatterplot(
    abs(pred_df$residual_emdi_intercept_only),
    abs(pred_df$residual_icar_only), 
    columnA_name = "Intercept Only (Frequentist)", 
    columnB_name = "ICAR Only", 
    title="Intercept Only (Frequentist) vs. ICAR Only - Residual Absolute Values",
    abline = abline,
    show_corr = show_corr,
    match_limits = match_limits,
    color_by_abline = color_by_abline
)

ggsave(fig, filename="images/residual_scatterplot_icar_int_freq.png")

fig <- basic_scatterplot(
    abs(pred_df$residual_emdi_intercept_only), 
    abs(pred_df$residual_intercept_only),
    columnA_name = "Intercept Only (Frequentist)", 
    columnB_name = "Intercept Only (Bayesian)", 
    title="Intercept Only Models - Residual Absolute Values",
    abline = abline,
    show_corr = show_corr,
    match_limits = match_limits,
    color_by_abline = color_by_abline
)

ggsave(fig, filename="images/residual_scatterplot_int_only_models.png")

# STANDARD DEVIATION PLOTS ---


fig <- basic_scatterplot(
    pred_df$sd_acs, 
    pred_df$sd_intercept_only,
    columnA_name = "ACS", 
    columnB_name = "Intercept Only", 
    title="ACS vs Intercept Only - Standard Deviations",
    abline = abline,
    show_corr = show_corr,
    match_limits = match_limits,
    color_by_abline = color_by_abline
)

ggsave(fig, filename="images/sd_scatterplot_acs_int_only.png")

fig <- basic_scatterplot(
    pred_df$sd_acs, 
    pred_df$sd_icar_only,
    columnA_name = "ACS", 
    columnB_name = "ICAR Only", 
    title="ACS vs ICAR Only - Standard Deviations",
    abline = abline,
    show_corr = show_corr,
    match_limits = match_limits,
    color_by_abline = color_by_abline
)

ggsave(fig, filename="images/sd_scatterplot_acs_icar_only.png")

fig <- basic_scatterplot(
    pred_df$sd_intercept_only, 
    pred_df$sd_icar_only,
    columnA_name = "Intercept Only", 
    columnB_name = "ICAR Only", 
    title="Intercept Only vs ICAR Only - Standard Deviations",
    abline = abline,
    show_corr = show_corr,
    match_limits = match_limits,
    color_by_abline = color_by_abline
)

ggsave(fig, filename="images/sd_scatterplot_int_icar_only.png")
