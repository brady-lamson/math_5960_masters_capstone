# For learning the brms package

library(brms)
library(dplyr)
library(sf)

acs_df <- sf::st_read("data/acs/2023_5_year_acs_proportion_response.shp")

fit <- brms::brm(
    est_prop | se(sd, sigma=FALSE) ~ 1 + (1 | name), # document the heck out of this row to justify it
    data=acs_df,
    family=gaussian(),
    seed=100,
    iter=10000,
    warmup=5000
)

print(fit$fit, digits=5)
print(summary(fit, priors=TRUE, mc_se=TRUE), digits=5)

plot(fit)
plot(fit$fit)

# Get estimated proportions from the posterior distribution
posterior_predictions <- brms::posterior_epred(fit)
sae_estimates <- colMeans(posterior_predictions)
sae_sd <- apply(posterior_predictions, 2, sd)

# Compare estimated proportions ---
limlow <- min(acs_df$est_prop, sae_estimates)
limhigh <- max(acs_df$est_prop, sae_estimates)
limits <- c(limlow, limhigh)
plot(x=acs_df$est_prop, y=sae_estimates, xlim=limits, ylim=limits)
abline(a=0,b=1)

# Compare standard deviations ---
limlow <- min(acs_df$sd, sae_sd)
limhigh <- max(acs_df$sd, sae_sd)
limits <- c(limlow, limhigh)
plot(x=acs_df$sd, y=sae_sd, xlim=limits, ylim=limits)
abline(a=0,b=1)
