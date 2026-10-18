# This script is related to the frequentist fay-herriot model using the emdi package
# The model here is intercept only with no spatial autocorrelation
# This simple model is helpful for basic understanding of how the model works
# And also will serve as a tool for checking output of bayesian models to verify that they are behaving correctly


library(emdi)       # For fay-herriot model
library(dplyr)      # For the pipe
library(sf)         # For reading in shape files
library(ggplot2)    # Plots
library(patchwork)  # Side by side plots

acs_df <- sf::st_read("data/acs/2023_5_year_acs_proportion_response.shp")

simple_df <- sf::st_drop_geometry(acs_df) %>%
    as.data.frame() # emdi doesn't work with tibbles

fh_simple <- emdi::fh(
    fixed = est_prop ~ 1,
    domains="name",
    vardir = "var",
    combined_data=simple_df,
    correlation="no", # change to 'spatial' later perhaps
    maxit=100,  # default
    tol=0.0001 # default
)

# Examine model outputs
fh_simple
summary(fh_simple)

# Create dataframe capturing domain specific info
model_output <- fh_simple$model
model_df <- data.frame(
    county = fh_simple$ind$Domain,
    direct_estimate = fh_simple$ind$Direct,
    fh_estimate = fh_simple$ind$FH,
    fitted_value = model_output$fitted,
    random_effects = model_output$random_effects,
    shrinkage_factor = model_output$gamma$Gamma,
    delta = fh_simple$ind$Direct - fh_simple$ind$FH
)

head(model_df)
summary(model_df)

save_df <- TRUE
if (save_df) {
    write.csv(model_df, "data/model_outputs/emdi_intercept_only.csv", row.names=FALSE)
}

run_plots <- FALSE
if (run_plots) {
    # PLOT: Behavior is overall the same as the original model, but this is unsurprising
    # This wont be my primary way of seeing if this is a good idea
    max_lim <- max(c(model_df$direct_estimate, model_df$fh_estimate)) + 0.01
    limits <- c(0, max_lim)
    ggplot(model_df) +
        geom_point(aes(x=direct_estimate, y=fh_estimate)) +
        geom_abline(intercept=0, slope=1) +
        xlim(limits) +
        ylim(limits)
    
    # --- BASIC COUNTY MAPS --- 
    plot(
        model_df["delta"],
        breaks = "quantile",
        nbreaks = 5,
        pal = hcl.colors(5, "YlOrRd"),
        main = "Estimated Agricultural Employment Proportion"
    )
    
    plot(
        acs_df["est_prop"],
        breaks = "quantile",
        nbreaks = 5,
        pal = hcl.colors(5, "YlOrRd"),
        main = "Estimated Agricultural Employment Proportion"
    )
    
    plot(
        acs_df["est_agri"],
        breaks = "quantile",
        nbreaks = 5,
        pal = hcl.colors(5, "YlOrRd"),
        main = "Estimated Agricultural Employment"
    )
    
    plot(
        acs_df["est_all"],
        breaks = "quantile",
        nbreaks = 10,
        pal = hcl.colors(10, "YlOrRd"),
        main = "Estimated Employment"
    )
}


