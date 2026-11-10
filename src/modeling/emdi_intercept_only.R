# This script is related to the frequentist fay-herriot model using the emdi package
# The model here is intercept only with no spatial autocorrelation
# This simple model is helpful for basic understanding of how the model works
# And also will serve as a tool for checking output of bayesian models to verify that they are behaving correctly

library(emdi)       # For fay-herriot model
library(dplyr)      # For the pipe
library(sf)         # For reading in shape files
library(tibble)
library(stringr)
source("src/R/transformations.R")

df <- sf::st_read("data/acs/2020_5_year_acs_proportion_response.shp") %>%
    sf::st_drop_geometry(acs_df) %>%
    as.data.frame() # emdi doesn't work with tibbles

model_fit <- emdi::fh(
    fixed = est_logit ~ 1,
    domains="name",
    vardir = "var_logit",
    combined_data=df,
    correlation="no", # change to 'spatial' later perhaps
    maxit=10000,
    tol=0.0001 # default
)

# Examine model outputs
model_fit
summary(model_fit)

lower_z <- qnorm(0.025)
upper_z <- qnorm(0.975)
coeffs <- model_fit$model$coefficients %>% 
    tibble::rownames_to_column() %>%
    rename(
        variable=rowname,
        estimate=coefficients,
        sd=std.error
    ) %>%
    select(-c(t.value, p.value)) %>%
    mutate(
        variable = str_replace_all(variable, "[()]", ""),
        lower = estimate + (lower_z * sd),
        upper = estimate + (upper_z * sd),
        model_name = "intercept_only_frequentist"
    ) %>%
    bind_rows(tibble(
        variable = "estimated_sd_component", 
        estimate=sqrt(model_fit$model$variance),
        model_name = "intercept_only_frequentist"
    ))

coeffs %>%
    # Between county random effects standard error
    # equivalent to sd_name__Intercept from the bayesian non-icar models
    # From "Estimated variance component" from model summary
    bind_rows(tibble(variable = "estimated_sd_component", estimate=sqrt(model_fit$model$variance)))

# Create dataframe capturing domain specific info, for later comparisons and diagnostics
# Different from all predictions on purpose, to help explore manual calculations
model_output <- model_fit$model
model_df <- data.frame(
    model_name = "emdi_intercept_only",
    county = model_fit$ind$Domain,
    direct_estimate = inv_logit(model_fit$ind$Direct),
    fh_estimate = inv_logit(model_fit$ind$FH),
    fitted_value = inv_logit(model_output$fitted),
    random_effects = model_output$random_effects,
    shrinkage_factor = model_output$gamma$Gamma
)
model_df["delta"] = model_df$direct_estimate - model_df$fh_estimate

head(model_df)
summary(model_df)

# For writing
emdi_pred_df <- tibble(
    model_name = "emdi_intercept_only",
    county = model_fit$ind$Domain,
    estimate = inv_logit(model_fit$ind$FH),
    true_value = NA,
    residual = NA,
    proportional_residual = NA,
    sd = NA,
    lower = NA,
    upper = NA,
    interval_width = NA,
    true_value_captured = NA,
    crps = NA
)

save_df <- FALSE
if (save_df) {
    readr::write_csv(emdi_pred_df, "data/model_outputs/emdi_model_predictions.csv")
    readr::write_csv(model_df, "data/model_outputs/emdi_intercept_only.csv")
    readr::write_csv(coeffs, "data/model_outputs/emdi_coefficients.csv")
}

