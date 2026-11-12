= Appendix

== Emdi Intercept FH Code

#show figure: set align(left)
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

== BRMS Intercept Only Modeling Code

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

== BRMS Intercept Only STAN Code

```R
> fit$model
// generated with brms 2.23.0
functions {
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  vector<lower=0>[N] se;  // known sampling error
  // data for group-level effects of ID 1
  int<lower=1> N_1;  // number of grouping levels
  int<lower=1> M_1;  // number of coefficients per level
  array[N] int<lower=1> J_1;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_1_1;
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
  vector<lower=0>[N] se2 = square(se);
}
parameters {
  real Intercept;  // temporary intercept for centered predictors
  vector<lower=0>[M_1] sd_1;  // group-level standard deviations
  array[M_1] vector[N_1] z_1;  // standardized group-level effects
}
transformed parameters {
  real sigma = 0;  // dispersion parameter
  vector[N_1] r_1_1;  // actual group-level effects
  // prior contributions to the log posterior
  real lprior = 0;
  r_1_1 = (sd_1[1] * (z_1[1]));
  lprior += student_t_lpdf(Intercept | 3, -2.1, 2.5);
  lprior += student_t_lpdf(sd_1 | 3, 0, 2.5)
    - 1 * student_t_lccdf(0 | 3, 0, 2.5);
}
model {
  // likelihood including constants
  if (!prior_only) {
    // initialize linear predictor term
    vector[N] mu = rep_vector(0.0, N);
    mu += Intercept;
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu[n] += r_1_1[J_1[n]] * Z_1_1[n];
    }
    target += normal_lpdf(Y | mu, se);
  }
  // priors including constants
  target += lprior;
  target += std_normal_lpdf(z_1[1]);
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept;
}
```