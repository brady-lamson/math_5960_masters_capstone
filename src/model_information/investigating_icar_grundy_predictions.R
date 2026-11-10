library(brms)

icar_only <- readRDS("models/icar_only.rds")
predictions <- colMeans(brms::posterior_epred(icar_only))
print(brms::posterior_summary(icar_only$fit, variable = "zcar[1]"), max=5000)

# Note, grundy is index 38 in the rcar[i] and zcar[i] variables

brms::posterior_linpred(
    icar_only,
    transform = FALSE
)[, 1] |> mean()

brms::posterior_linpred(
    icar_only,
    transform = FALSE
)[, 1]

stan_data <- brms::standata(icar_only)

stan_data$Jloc[1]

