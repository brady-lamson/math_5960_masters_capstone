# This script is related to the frequentist fay-herriot model using the emdi package
# The model here is intercept only with no spatial autocorrelation
# This simple model is helpful for basic understanding of how the model works
# And also will serve as a tool for checking output of bayesian models to verify that they are behaving correctly


library(emdi)       # For fay-herriot model
library(dplyr)      # For the pipe
library(sf)         # For reading in shape files
library(ggplot2)    # Plots
library(patchwork)  # Side by side plots
source("src/R/transformations.R")

acs_df <- sf::st_read("data/acs/housing/2020_5_year_acs_proportion_response.shp")

simple_df <- sf::st_drop_geometry(acs_df) %>%
    as.data.frame() # emdi doesn't work with tibbles

fh_simple <- emdi::fh(
    fixed = est_logit ~ 1,
    domains="name",
    vardir = "var_logit",
    combined_data=simple_df,
    correlation="no", # change to 'spatial' later perhaps
    maxit=1000,
    tol=0.0001 # default
)

# Examine model outputs
fh_simple
summary(fh_simple)

# Create dataframe capturing domain specific info
model_output <- fh_simple$model
model_df <- data.frame(
    county = fh_simple$ind$Domain,
    direct_estimate = inv_logit(fh_simple$ind$Direct),
    fh_estimate = inv_logit(fh_simple$ind$FH),
    fitted_value = inv_logit(model_output$fitted),
    random_effects = model_output$random_effects,
    shrinkage_factor = model_output$gamma$Gamma
)
model_df["delta"] = model_df$direct_estimate - model_df$fh_estimate

head(model_df)
summary(model_df)

save_df <- TRUE
if (save_df) {
    write.csv(model_df, "data/model_outputs/housing/emdi_intercept_only.csv", row.names=FALSE)
}


# Compare to bayesian intercept only outputs
# Do more of this later
int_only_df <- readr::read_csv("data/model_outputs/housing/all_model_predictions.csv") %>%
    filter(model_name=="intercept_only") %>%
    select(county, estimate)

model_df %>%
    left_join(int_only_df, by="county") %>%
    select(county, fh_estimate, estimate) %>%
    mutate(delta = fh_estimate - estimate) %>%
    summary()