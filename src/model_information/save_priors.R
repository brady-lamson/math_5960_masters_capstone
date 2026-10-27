library(brms)
library(dplyr)
library(posterior)

models <- list(
    intercept_only = readRDS("models/intercept_only.rds"),
    icar_only = readRDS("models/icar_only.rds"),
    cdl_no_icar = readRDS("models/cdl_no_icar.rds"),
    cdl_and_icar = readRDS("models/cdl_and_icar.rds")
)

prior_summary <- models %>%
    purrr::map(\(fit) as.data.frame(fit$prior)) %>%
    purrr::list_rbind(names_to = "model_name") %>%
    tibble()

prior_summary[prior_summary == ""] <- NA
prior_summary <- prior_summary %>%
    drop_na(prior) %>%
    select(model_name, class, prior, lb) %>%
    mutate(
        class = recode(
            class,
            "b" = "CDL Coefficient",
            "sdcar" = "Spatial-effect SD",
            "sd" = "Random-effect SD"
        )
    )

readr::write_csv(prior_summary, "data/model_outputs/model_priors.csv")
