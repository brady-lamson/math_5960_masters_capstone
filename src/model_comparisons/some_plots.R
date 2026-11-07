library(dplyr)
source("src/R/plotting.R")

pred_df <- readr::read_csv("data/model_outputs/all_model_predictions.csv") %>%
    filter(model_name %in% c("acs", "intercept_only", "icar_only")) %>%
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

fig <- basic_scatterplot(
    abs(pred_df$residual_acs), 
    abs(pred_df$residual_intercept_only),
    columnA_name = "ACS", 
    columnB_name = "Intercept Only", 
    title="ACS vs Intercept Only - Residual Absolute Values",
    abline=TRUE,
    show_corr = FALSE,
    match_limits = TRUE,
    color_by_abline = TRUE
)

ggsave(fig, filename="images/residual_scatterplot_acs_int_only.png")

fig <- basic_scatterplot(
    abs(pred_df$residual_acs), 
    abs(pred_df$residual_icar_only),
    columnA_name = "ACS", 
    columnB_name = "ICAR Only", 
    title="ACS vs ICAR Only - Residual Absolute Values",
    abline=TRUE,
    show_corr = FALSE,
    match_limits = TRUE,
    color_by_abline = TRUE
)

ggsave(fig, filename="images/residual_scatterplot_acs_icar_only.png")

fig <- basic_scatterplot(
    abs(pred_df$residual_intercept_only), 
    abs(pred_df$residual_icar_only),
    columnA_name = "Intercept Only", 
    columnB_name = "ICAR Only", 
    title="Intercept Only vs ICAR Only - Residual Absolute Values",
    abline=TRUE,
    show_corr = FALSE,
    match_limits = TRUE,
    color_by_abline = TRUE
)

ggsave(fig, filename="images/residual_scatterplot_int_icar_only.png")
