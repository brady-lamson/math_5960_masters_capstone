library(brms)
library(tibble)
# library(loo)
library(scoringRules)
source("src/R/transformations.R")


get_predictions <- function(model, logit_response=TRUE, epred=TRUE) {
    if (epred) {
        posterior_predictions <- brms::posterior_epred(model)
    } else {
        posterior_predictions <- brms::posterior_predict(model)
    }
    
    if (logit_response) {
        posterior_predictions <- inv_logit(posterior_predictions)
    } 
    
    return(posterior_predictions)
}


catalog_predictions <- function(model, name, true_vector, ci_prob=0.95, logit_response=TRUE){
    # This function captures the predictions and various metrics
    # model: The rds model fit
    # name: Name of the model, string.
    # true_vector: Vector of true values, make sure it's the same county order as the predictions
    # ci_prob: Width of credible/confidence interval. 0.95 is a 95% CI.
    #   - This controls lower and upper values. 
    # logit_response: Whether the response is logit transformed. 
    
    p <- (1-ci_prob) / 2 # For CIs
    posterior_predictions <- get_predictions(model, logit_response)
    sae_estimates <- colMeans(posterior_predictions)
    sae_sd <- apply(posterior_predictions, 2, sd)
    crps <- scoringRules::crps_sample(
        y=true_vector, 
        dat=t(posterior_predictions) # To fix matrix dimensions
    )
    
    pred_df <- tibble(
        model_name=name,
        county=model$data$name,
        estimate=sae_estimates,
        true_value=true_vector,
        residual=estimate-true_vector,
        sd=sae_sd,
        lower=apply(posterior_predictions, 2, quantile, probs=0.025),
        upper=apply(posterior_predictions, 2, quantile, probs=0.975),
        interval_width=upper-lower,
        true_value_captured=dplyr::if_else((true_value>=lower) & (true_value <= upper), TRUE, FALSE),
        crps=crps
    )
    
    return(pred_df)
}
