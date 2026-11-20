=== BRMS ICAR

#figure(
  ```R
  fit <- brms::brm(
    est_logit | se(sd_logit, sigma=FALSE) ~ 1 + car(M, type="icar", gr=name),
    data=acs_df,
    data2=list(M=neighbor_matrix),
    family=gaussian(),
    seed=100,
    iter=10000,
    warmup=5000,
    save_pars = brms::save_pars(all=TRUE)
)
  ```
)