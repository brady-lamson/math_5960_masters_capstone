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


get_metric_ranking <- function(df, metric, print_table=TRUE) {
    # TODO: ALLOW SWAPPING BETWEEN MAX AND MIN
    # KINDA DIDNT THINK ABOUT ALL MY RELEVANT METRICS BEING SMALL IS GOOD
    rank <- df %>%
        select(county, model_name, .data[[metric]]) %>%
        group_by(county) %>%
        mutate(rank=min_rank(.data[[metric]])) 
    
    if (print_table) {
        print("Number of counties each model wins")
        rank1 <- rank %>% slice_min(rank, n=1)
        print(table(rank1$model_name))
    }
    
    return(rank)
}

get_ranking_summary <- function(rank_df, metric) {
    summary_df <- rank_df %>%
        sf::st_drop_geometry() %>%
        group_by(model_name) %>%
        summarise(
            metric_mean=mean(.data[[metric]]),
            metric_min=min(.data[[metric]]),
            metric_median=median(.data[[metric]]),
            metric_max=max(.data[[metric]]),
            rank_mean=mean(rank),
            rank_min=min(rank),
            rank_median=median(rank),
            rank_max=max(rank)
        )
    
    return(summary_df)
}

multi_bayes_factor <- function(fit1, fit2, fit1name, fit2name, n=5) {
    bf <- replicate(
        n,
        brms::bayes_factor(fit1, fit2)$bf
    )
    
    df <- tibble(
        fitA = fit1name,
        fitB = fit2name,
        bf_mean = mean(bf),
        bf_sd = sd(bf),
        bf_min = min(bf),
        bf_max = max(bf)
    )
    
    return(df)
}

bayes_factor_all_combinations <- function(fit_list, n=5) {
    pairs <- combn(names(models), 2, simplify=FALSE)
    bf_df <- tibble(
        fitA = character(),
        fitB = character(),
        bf_mean = numeric(),
        bf_sd = numeric(),
        bf_min = numeric(),
        bf_max = numeric()
    )
    
    for (pair in pairs) {
        print(paste0("Comparing Models: <", pair[1], "> and <", pair[2], ">"))
        temp_df <- multi_bayes_factor(
            fit1=models[[pair[1]]], 
            fit2=models[[pair[2]]], 
            fit1name=pair[1], 
            fit2name=pair[2], 
            n=n
        )
        bf_df <- union(bf_df, temp_df)
    }
    
    return(bf_df)
}