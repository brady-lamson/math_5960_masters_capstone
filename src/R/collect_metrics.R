library(brms)
library(tibble)
library(loo)
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
    
    get_predictions(model, logit_response)
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
    ypred1 <- get_predictions(model, epred=FALSE)
    ypred2 <- get_predictions(model, epred=FALSE)
    y <- full_df$est_prop
    loo::crps(ypred1, ypred2, y)
}