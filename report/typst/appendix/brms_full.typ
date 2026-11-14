=== BRMS Full Model

#figure(
  ```R
    brms::brm(
        est_logit | se(sd_logit, sigma=FALSE) ~ prop_corn_soy 
        + car(M, type="icar", gr=name),
        data=acs_df,
        data2=list(M=neighbor_matrix),
        family=gaussian(),
        prior = brms::prior("normal(0, 1)", class = "b", coef="prop_corn_soy"),
        seed=100,
        iter=10000,
        warmup=5000,
        save_pars = brms::save_pars(all=TRUE)
    )
  ```
) <brms_full>