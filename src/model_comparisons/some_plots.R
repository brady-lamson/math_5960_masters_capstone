library(brms)
library(dplyr)
library(sf)

models <- list(
    intercept_only = readRDS("models/intercept_only.rds"),
    icar_only = readRDS("models/icar_only.rds"),
    cdl_no_icar = readRDS("models/cdl_no_icar.rds"),
    cdl_and_icar = readRDS("models/cdl_and_icar.rds")
)


add_criterion_and_update <- function(model) {
    add_criterion(model, criterion=c("loo", "waic"))
}
models <- lapply(models, add_criterion_and_update)


get_sae_estimates <- function(model) {
    posterior <- brms::posterior_epred(model)
    
    tibble(
        sae_est = colMeans(posterior),
        sae_sd = apply(posterior, 2, sd)
    )
}

estimates <- lapply(models, get_sae_estimates)

comparison <- tibble(
    county = seq_len(nrow(estimates[[1]])),
    intercept_only_est = estimates$intercept_only$sae_est,
    intercept_only_sd = estimates$intercept_only$sae_sd,
    icar_only_est = estimates$icar_only$sae_est,
    icar_only_sd = estimates$icar_only$sae_sd,
    cdl_no_icar_est = estimates$cdl_no_icar$sae_est,
    cdl_no_icar_sd = estimates$cdl_no_icar$sae_sd,
    cdl_and_icar_est = estimates$cdl_and_icar$sae_est,
    cdl_and_icar_sd = estimates$cdl_and_icar$sae_sd
)

# Estimates

plot(comparison$intercept_only_est, comparison$icar_only_est,
     main = "Intercept only vs ICAR",
     xlab = "Intercept only", ylab = "ICAR")
abline(a = 0, b = 1)

plot(comparison$intercept_only_est, comparison$cdl_no_icar_est,
     main = "Intercept only vs CDL Covariate",
     xlab = "Intercept only", ylab = "CDL Covariate")
abline(a = 0, b = 1)

plot(comparison$intercept_only_est, comparison$cdl_and_icar_est,
     main = "Intercept only vs Full Model",
     xlab = "Intercept only", ylab = "Full Model")
abline(a = 0, b = 1)

plot(comparison$icar_only_est, comparison$cdl_no_icar_est,
     main = "ICAR vs CDL Covariate",
     xlab = "ICAR", ylab = "CDL Covariate")
abline(a = 0, b = 1)

plot(comparison$icar_only_est, comparison$cdl_and_icar_est,
     main = "ICAR vs Full Model",
     xlab = "ICAR", ylab = "Full Model")
abline(a = 0, b = 1)

plot(comparison$cdl_no_icar_est, comparison$cdl_and_icar_est,
     main = "CDL Covariate vs Full Model",
     xlab = "CDL Covariate", ylab = "Full Model")
abline(a = 0, b = 1)


# Posterior SDs

plot(comparison$intercept_only_sd, comparison$icar_only_sd,
     main = "Intercept only vs ICAR SD",
     xlab = "Intercept only SD", ylab = "ICAR SD")
abline(a = 0, b = 1)

plot(comparison$intercept_only_sd, comparison$cdl_no_icar_sd,
     main = "Intercept only vs CDL Covariate SD",
     xlab = "Intercept only SD", ylab = "CDL Covariate SD")
abline(a = 0, b = 1)

plot(comparison$intercept_only_sd, comparison$cdl_and_icar_sd,
     main = "Intercept only vs Full Model SD",
     xlab = "Intercept only SD", ylab = "Full Model SD")
abline(a = 0, b = 1)

plot(comparison$icar_only_sd, comparison$cdl_no_icar_sd,
     main = "ICAR vs CDL Covariate SD",
     xlab = "ICAR SD", ylab = "CDL Covariate SD")
abline(a = 0, b = 1)

plot(comparison$icar_only_sd, comparison$cdl_and_icar_sd,
     main = "ICAR vs Full Model SD",
     xlab = "ICAR SD", ylab = "Full Model SD")
abline(a = 0, b = 1)

plot(comparison$cdl_no_icar_sd, comparison$cdl_and_icar_sd,
     main = "CDL Covariate vs Full Model SD",
     xlab = "CDL Covariate SD", ylab = "Full Model SD")
abline(a = 0, b = 1)