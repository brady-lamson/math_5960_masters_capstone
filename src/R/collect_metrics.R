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


catalog_predictions <- function(model, name, logit_response=TRUE){
    
    posterior_predictions <- get_predictions(model, logit_response)
    sae_estimates <- colMeans(posterior_predictions)
    sae_sd <- apply(posterior_predictions, 2, sd)
    pred_df <- tibble(
        model_name=name,
        county=model$data$name,
        estimate=sae_estimates,
        sd=sae_sd,
        lower=apply(posterior_predictions, 2, quantile, probs=0.025),
        upper=apply(posterior_predictions, 2, quantile, probs=0.975)
    )
    
    return(pred_df)
}

get_crps <- function(model, true_vector) {
    ypred <- get_predictions(model, epred=TRUE)
    y <- true_vector
    return(
        scoringRules::crps_sample(
            y=y, 
            dat=t(ypred) # To fix matrix dimensions
        )
    )
}