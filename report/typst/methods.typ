= Methods

#let mu_sd = $sigma_(mu)$

#include "methods/traditional_fh.typ"

#include "methods/bayesian_fh.typ"

#include "methods/icar.typ"

== Auxillary covariates

#let betax = $bold(beta)_x$
#let xbeta = $bold(x)_i^T #betax$

For preparing the NASS crop data layer for its role as a covariate, please refer to @cdl_processing. Extending the Bayesian model to include covariates is straightforward. Referring to @process_distribution, adding in a covariate vector #betax gives

$
  theta_i | beta_0, #betax, #mu_sd tilde N(beta_0 + #xbeta, #mu_sd^2)
$

#math.equation(
  $
    theta_i | beta_0, #betax, #mu_sd = 1/(sqrt(2 pi) #mu_sd) exp(- (theta_i - (beta_0 + #xbeta) )^2 / (2 #mu_sd^2))
  $
) <process_dist_with_covariates>

where, for this project, #betax is simply $beta_1$. This implementation expands out to support additional covariates in the same way. A similar approach is shown in @bayesCHUNG. Going forward, $beta_1$ will be used instead of $#betax$.

As for priors, by default `brms` gives covariate coefficients an improper flat prior. This is a uniform prior across the entire real line. Instead, a $N(0, 1)$ prior was selected $beta_1$. The same priors for the other components still apply, so this arrangement applies both to the models with and without the ICAR component. 

#math.equation(
  $
    p(beta_0) &= t_3(beta_0 | -2.1, 2.5) \
    p(beta_1) &= N(beta_1 | 0, 1) \
    p(#mu_sd) &= t_3^+(#mu_sd | 0, 2.5) \
  $
)<cdl_priors>

== General Modeling Information

Write about parameters, write about how the icar stuff is set up in brms. Also write about how FH predictions are pulled out from the fit objects. 

== Model Evaluation

Keep it short. Just explain the metrics used. Maybe explain why LOOIC and WAIC are missing. 