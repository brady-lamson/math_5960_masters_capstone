=== Emdi Intercept Only


#figure(
  ```R
  model_fit <- emdi::fh(
      fixed = est_logit ~ 1,
      domains="name",
      vardir = "var_logit",
      combined_data=df,
      correlation="no",
      maxit=10000,
      tol=0.0001 # default
  )
  ```
) <emdi_code>