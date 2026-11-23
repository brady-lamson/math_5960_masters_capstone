= Methods

#let acs_est = $hat(Y)_i$
#let acs_var = $hat(sigma^2)^("acs")_i$
#let fh_est = $hat(theta)^("FH")_i$
#let est_var = $hat(sigma^2_(mu))$
#let gamma_est = $hat(gamma)_i$

== Fay-Herriot Model (1)

#align(horizon)[
  #set text(size: 10pt)
  
  / Definition and notation:
    for $i = 1, dots, n$,

    #math.equation(
      block: true, 
      $
      Y_i = theta_i + epsilon_i \
      theta_i = beta_0 + bold(x_i^T) bold(beta_x) + mu_i \
      $
    ) 

    where $epsilon_i tilde N(0, sigma_i^2)$ and $mu_i limits(tilde)^"iid" N(0, sigma_(mu)^2)$

    - $Y_i$: Direct estimate of $theta_i$
    - $theta_i$: Population parameter of interest
    - $sigma_i^2$: Known survey variance
    - $mu_i$: Area level random effects

]

== Fay-Herriot Model (2)

#align(horizon)[
  #set text(size: 10pt)
  
  - Model combines regression-based fitted values and direct estimates by calculating a *shrinkage* value $gamma_i$.
  - The shrinkage value takes into account the areas sampling variance relative to the overall random effect variance.

  / Shrinkage Value:

    #math.equation(
      block: true,
      $
      #gamma_est &= #est_var / (#est_var + #acs_var)
      $
    ) <shrinkage>

  - As shown below, it is used to scale the direct estimate and fitted value to determine how closely to stick to the direct estimate. 

  / Fay-Herriot Estimate:
    The FH estimate, for the intercept only model, be shown as:

    #math.equation(
      block: true,
      $
      #fh_est &= #gamma_est #acs_est + (1 - #gamma_est) hat(beta_0)
      $
    ) <fh_int_only>

]

== Bayesian Fay-Herriot (1)

#let betax = $bold(beta)_x$
#let xbeta = $bold(x)_i^T #betax$
#let mu_sd = $sigma_(mu)$

#align(horizon)[
  #set text(size: 10pt)

  / $Y_i$ - Conditional Probability Density Function:
    $
      Y_i | theta_i, sigma_i tilde N(theta_i, sigma^2_i) \
      p(Y_i | theta_i, sigma_i)  = 1/(sqrt(2 pi) sigma_i) exp(- (Y_i - theta_i)^2 / (2 sigma_i^2))
    $
  
  / $theta_i$ - Posterior Distribution:
    $
      theta_i | beta_0, #betax, #mu_sd tilde N(beta_0 + #xbeta, #mu_sd^2) \
      theta_i | beta_0, #betax, #mu_sd = 1/(sqrt(2 pi) #mu_sd) exp(- (theta_i - (beta_0 + #xbeta) )^2 / (2 #mu_sd^2))
    $
]

== Bayesian Fay-Herriot (2) - Spatial Random Effects

#align(horizon)[
  #set text(size: 9pt)

  / Adjacency Matrix:
    Let $W$ represent the binary adjacency matrix where:

    $
      w_(i,j) = cases(
      1 &quad "if counties i and j are adjacent and" i != j,
      0 &quad "otherwise"
    )
    $

    and

    $
      d_i = sum_j w_(i,j)
    $

    represent the number of neighbors for each county. 
  
  / Distribution of County Spatial Effect:
    $
      mu_i | {mu_(i != j)} tilde N(sum_(i tilde j) mu_j / d_i, sigma^2_(mu) / d_i),
    $

    where $i tilde j$ denotes adjacency of counties $i, j$.
]

== Bayesian Fay-Herriot (3) - Priors

#align(horizon)[
  #set text(size: 10pt)

  - By default `brms` gives covariate coefficients an improper flat prior. This is a uniform prior across the entire real line. 
    - Instead, a $N(0, 1)$ prior was selected $beta_1$. 
  - The same prior is used for both the random effects and spatial effects.

  / Priors:
    #math.equation(
      $
        p(beta_0) &= t_3(beta_0 | -2.1, 2.5) \
        p(beta_1) &= N(beta_1 | 0, 1) \
        p(#mu_sd) &= t_3^+(#mu_sd | 0, 2.5) \
      $
    )

    where $t_3^+$ represents the Student's t distribution with 3 degrees of freedom and a lower bound of 0, otherwise known as a Half-Student-t distribution.
]

== Modeling Information and Prediction Calculation

#align(horizon)[
  #set text(size: 10pt)

  - All Bayesian models fit with $10,000$ iterations and $5,000$ warmup iterations across 4 chains.
    - Total of $20,000$ post-warmup iterations.
  - County predictions are acquired through the *expected value of the posterior predictive distribution*. 
    - This is critical as the posterior predictive distribution on its own includes error from the known sampling variance. @brmsPredictionsExplainer

  #figure(
  image("../../../images/posterior_predict_explainer.png", width: 80%),
  caption: "Diagram explaining the various prediction methods present in the brms package. Source: Andrew Heiss, 2022"
) <brms_prediction_explainer>
]