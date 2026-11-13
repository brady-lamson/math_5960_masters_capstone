=== BRMS Intercept Only

#figure(
  ```R
  fit <- brms::brm(
      est_logit | se(sd_logit, sigma=FALSE) ~ 1 + (1 | name),
      data=acs_df,
      family=gaussian(),
      seed=100,
      iter=10000,
      warmup=5000,
      save_pars = brms::save_pars(all=TRUE)
  )
  ```
) <brms_int_only_code> 