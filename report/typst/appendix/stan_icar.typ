=== BRMS ICAR STAN Code


```R
> icar_only$model
// generated with brms 2.23.0
functions {
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  vector<lower=0>[N] se;  // known sampling error
  // data for the CAR structure
  int<lower=1> Nloc;
  array[N] int<lower=1> Jloc;
  int<lower=0> Nedges;
  array[Nedges] int<lower=1> edges1;
  array[Nedges] int<lower=1> edges2;
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
  vector<lower=0>[N] se2 = square(se);
}
parameters {
  real Intercept;  // temporary intercept for centered predictors
  real<lower=0> sdcar;  // SD of the CAR structure
  // parameters for the ICAR structure
  vector[Nloc] zcar;
}
transformed parameters {
  // scaled parameters for the ICAR structure
  vector[Nloc] rcar;
  real sigma = 0;  // dispersion parameter
  // prior contributions to the log posterior
  real lprior = 0;
  // compute scaled parameters for the ICAR structure
  rcar = zcar * sdcar;
  lprior += student_t_lpdf(Intercept | 3, -2.1, 2.5);
  lprior += student_t_lpdf(sdcar | 3, 0, 2.5)
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
      mu[n] += rcar[Jloc[n]];
    }
    target += normal_lpdf(Y | mu, se);
  }
  // priors including constants
  target += lprior;
  // improper prior on the spatial CAR component
  target += -0.5 * dot_self(zcar[edges1] - zcar[edges2]);
  // soft sum-to-zero constraint
  target += normal_lpdf(sum(zcar) | 0, 0.001 * Nloc);
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept;
}
```