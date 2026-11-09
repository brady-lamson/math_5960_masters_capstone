library(dplyr)

frequentist_df <- readr::read_csv("data/model_outputs/emdi_intercept_only.csv")
bayesian_df <- readr::read_csv("data/model_outputs/all_model_predictions.csv") %>%
    filter(model_name=="intercept_only") %>%
    select(county, estimate)

comp_summary <- frequentist_df %>%
    left_join(bayesian_df, by="county") %>%
    select(county, fh_estimate, estimate) %>%
    mutate(
        delta = fh_estimate - estimate,
        abs_delta = abs(fh_estimate - estimate)
    ) %>%
    summarise(
        mean_abs_delta = mean(abs_delta),
        max_abs_delta = max(abs_delta),
        correlation = cor(fh_estimate, estimate)
    )

comp_summary
