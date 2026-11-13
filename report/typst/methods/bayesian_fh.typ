== Bayesian Fay-Herriot Model

Moving to a bayesian structure requires collecting the various distributional components. This is a hierarchical model, so there a few levels to go through. From @fh_y, it is implied that

$
  Y_i | theta_i, sigma_i tilde N(theta_i, sigma^2_i)
$

From this, the conditional probability density function is

$
  p(Y_i | theta_i, sigma_i)  = 1/(sqrt(2 pi) sigma_i) exp(- (Y_i - theta_i)^2 / (2 sigma_i^2))
$

From this, assuming independent $epsilon_i$, the data distribution is simply the joint distribution of all locations:

#let y_joint_pdf = $product_(i=1)^n p(Y_i | theta_i, sigma_i)$

$
  p(bold(Y) | bold(theta), bold(sigma)) = #y_joint_pdf
$

where 

$
  bold(Y) &= (Y_1, Y_2, dots, Y_n) \
  bold(theta) &= (theta_1, theta_2, dots, theta_n) \
  bold(sigma) &= (sigma_1, sigma_2, dots, sigma_n)
$

A similar approach can be used to get the joint distribution of $bold(theta)$. Referring back to @fh_theta, the intercept only model can be written as

#let mu_sd = $sigma_(mu)$

$
  theta_i | beta_0, #mu_sd = 1/(sqrt(2 pi) #mu_sd) exp(- (theta_i - beta_0)^2 / (2 #mu_sd^2))
$

and, with the assumption of independent county level effects, a joint distribution of

#let theta_join_pdf = $product_(i=1)^n p(theta_i | beta_0, #mu_sd)$
$
  p(bold(theta) | beta_0, #mu_sd) = #theta_join_pdf
$

=== Prior Distributions

For the priors of $beta_0$ and $#mu_sd$, they were automatically provided defaults by the `brms` package. They are as follows,

#math.equation(
  $
    p(beta_0) &= t_3(beta_0 | -2.1, 2.5) \
    p(#mu_sd) &= t_3^+(#mu_sd | 0, 2.5) \
  $
)<int_priors>

where $t_3^+$ represents the students t distribution with 3 degrees of freedom and a lower bound of 0, otherwise known as a Half-Student-t The full density functions of these priors are not written out for the sake of space. 

=== Full Posterior Distribution

Combining everything together gives:

$
  p(bold(theta), beta_0, #mu_sd | bold(Y)) &prop p(bold(Y) | bold(theta)) p(bold(theta) | beta_0, #mu_sd) p(beta_0) p(#mu_sd) \
  &prop #y_joint_pdf times #theta_join_pdf \
  &quad times t_3(beta_0 | -2.1, 2.5) \
  &quad times t_3^+(#mu_sd | 0, 2.5)
$

