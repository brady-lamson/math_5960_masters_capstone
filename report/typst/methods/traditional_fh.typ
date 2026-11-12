== Fay-Herriot Model

The traditional Fay-Herriot model is, for $i = 1, dots, n$, defined as

#math.equation(
  block: true, numbering: "(1)", 
  $
  Y_i = theta_i + epsilon_i
  $
) <fh_y>

#math.equation(
  block: true, numbering: "(1)", 
  $
  theta_i = beta_0 + bold(x_i^T) bold(beta_x) + mu_i
  $
) <fh_theta>

where $epsilon_i tilde N(0, sigma_i^2)$ and $mu_i tilde N(0, sigma_(mu)^2)$. Notation taken from previous work done by Porter et al. @PORTER201427. These error terms, $epsilon_i$ and $mu_i$ are mututally indepdendent. $theta_i$ represents the population parameter of interest. In this project's case that is the true housing vacancy rate for county $i$. $Y_i$ represents the direct estimate of $theta_i$, these are the estimated vacancy rates from the ACS. The variance of $epsilon_i, sigma_i^2$, is assumed known. These are the variances calculated from each estimate's margin of error provided by the ACS. The other error term $mu_i$ represents the area level random effects. The auxillary information is given by the q-dimensional vector $bold(x_i)$ with corresponding q-dimensional regression parameters $bold(beta_x)$ and intercept $beta_0$ @PORTER201427. 

This model combines the direct estimates and regression-based fitted values taken from the overall random effects and area level sampling variances. Each area's sampling variance $sigma_i^2$ is used to calculate a corresponding shrinkage value $gamma_i$ which determines how much the Fay-Herriot estimate leans towards the original direct estimate or regression fitted value.

For the intercept-only model, the shrinkage value can be represented as

#let acs_est = $hat(Y)_i$
#let acs_var = $hat(sigma^2)^("acs")_i$
#let fh_est = $hat(theta)^("FH")_i$
#let est_var = $hat(sigma^2_(mu))$
#let gamma_est = $hat(gamma)_i$

#math.equation(
  block: true, numbering: "(1)", 
  $
  #fh_est &= #gamma_est #acs_est + (1 - #gamma_est) hat(beta_0)
  $
) <fh_int_only>

where

#math.equation(
  block: true, numbering: "(1)", 
  $
  #gamma_est &= #est_var / (#est_var + #acs_var)
  $
) <shrinkage>

This produces the Empirical best linear unbiased predictor (EBLUPs) for the given area. For models with auxillary covariates, $hat(beta_0)$ is replaced by the models fitted value. Estimation of the variation of the random effects $#est_var$ is done using restricted maximum likelihood (REML). 

For the frequentist intercept-only Fay-Herriot model, the package `emdi` was used. The model fitting code snippet can be found in the appendix at @emdi_code. This fit specifies no correlation of the domains and provides no additional covariates. 