library(brms)
library(tibble)
source("src/R/transformations.R")

catalog_predictions <- function(model, name, logit_response=TRUE){
    posterior_predictions <- brms::posterior_epred(model) # TODO: Justify use of epred over posterior_predict
    if (logit_response == TRUE) {
        posterior_predictions <- inv_logit(posterior_predictions)
    }
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