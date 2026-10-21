library(brms)
library(dplyr)
library(readr)
library(ggplot2)

full_df <- readr::read_csv("data/model_outputs/all_model_predictions.csv")
pred_df <- full_df %>%
    filter(!(model_name %in% c("acs", "cdl_only", "cdl_and_icar")) )

acs_df <- full_df %>%
    filter(model_name == "acs") %>%
    select(-c(model_name, crps))

comp_df <- pred_df %>%
    left_join(acs_df, by="county") %>%
    mutate(
        abs_residual_model = abs(residual.x),
        abs_residual_acs = abs(residual.y),
        residual_change = abs_residual_model - abs_residual_acs,
        residual_pct_change = (abs_residual_model - abs_residual_acs) / abs_residual_acs * 100,
        sd_pct_change = (sd.x - sd.y) / sd.y * 100,
        interval_width_pct_change = (interval_width.x - interval_width.y) / interval_width.y * 100,
        capture_agreement = true_value_captured.x == true_value_captured.y,
        capture_agreement_detail = case_when(
            true_value_captured.x & true_value_captured.y ~ "both capture",
            !true_value_captured.x & !true_value_captured.y ~ "both miss",
            true_value_captured.x & !true_value_captured.y ~ "model capture, acs miss",
            !true_value_captured.x & true_value_captured.y ~ "acs capture, model miss"
        )
    ) %>%
    select(
        county, 
        model_name, 
        residual_change,
        residual_pct_change, 
        sd_pct_change, 
        interval_width_pct_change,
        capture_agreement,
        capture_agreement_detail
    )

comp_df %>%
    filter(model_name == "intercept_only") %>%
    summary()

table(comp_df$capture_agreement)
comp_df %>%
    filter(capture_agreement == FALSE) %>%
    select(-capture_agreement)
    # filter(capture_agreement %in% c("acs capture, model miss", "model capture, acs miss"))

comp_df %>%
    filter(model_name == "icar_only") %>%
    summary()

anti_join(pred_df, acs_df, by = "county") %>% count(model_name)

comp_df %>%
    group_by(model_name) %>%
    summarise(
        mean_residual = mean(residual),
        mean_sd = mean(sd),
        mean_int_width = mean(interval_width)
    )
