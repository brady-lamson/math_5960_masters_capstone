== Estimation Calculation Examples

This section was written to aid in the interpretation of the various coefficients from these models. A brief example for the county of Grundy will be shown across the three types of models. These will be simple examples meant primarily to show what the various components are doing under the hood. These estimates do not need to be calculated manually as each library has means of acquiring the estimates directly, this is purely for demonstration. 

=== Intercept Only Model Frequentist

For the model fit using `emdi`, it gives a number of components that fit together to create the Fay-herriot estimate. The ones used for this example will be the intercept, variance component, the acs direct estimate and the acs estimate variance. The values are as follows:

#let acs_est = $hat(theta)^("acs")$
#let acs_var = $hat(sigma^2)^("acs")$
#let fh_est = $hat(theta)^("FH")$
#let gamma_est = $hat(gamma)$

$
  hat(beta_0) &= -2.055 \
  sigma^2 &= 0.182 \
  #acs_est &= -2.502 \
  #acs_var &= 0.024 
$

For the intercept only model, the formula for the FH estimate is:

$
  #fh_est &= #gamma_est dot #acs_est + (1 - #gamma_est) dot hat(beta_0)
$

Where $#gamma_est$, Grundy's shrinkage value, is

$
  #gamma_est &= sigma^2 / (sigma^2 + #acs_var) \
  &= 0.182 / (0.182 + 0.024) \
  &approx 0.883
$

This gives

$
  #fh_est &= 0.883 dot -2.502 + 0.117 dot -2.055 \
  &approx -2.450
$

Which matches the FH estimate provided by emdi 

```
> model_fit$ind[1, ]
  Domain    Direct        FH Out
1 Grundy -2.502095 -2.450604   0
```

For reference, this output when transformed gives:

$
  1 / (1 + e^(-x)) = 1 / (1 + e^(2.45)) approx 0.0749,
$

or a $7.9%$ vacancy rate. 

=== Intercept Only Model Bayesian

The approach from the `brms` output works a little bit differently. It provides an intercept, a variable representing the county effect standard error, a standardized county specific effect, and the actual county specific effect. 

They are as follows:

$
  hat(beta_0) &= -2.06 \
  sigma_("random effect") &= 0.43 \
  z["Grundy"] &= -0.91
$

These components combine to get the estimated value,

$
  #fh_est &= hat(beta_0) + sigma_("random effect") dot z["Grundy"] \
  &= -2.06 + 0.43 dot -0.91 \
  &= -2.06 - 0.3913 \
  &approx -2.45
$

Which is the same as the previous example.

=== ICAR Model

As for the ICAR model, it functions identically to this one. The only difference is the standard deviation of the county effects is replaced by sdcar. For the sake of completeness, the same example will be carried out. 

$
  hat(beta_0) &= -2.05 \
  sigma_("car") &= 0.90 \
  z["Grundy"] &= -0.44 \
$

$
  #fh_est &= hat(beta_0) + sigma_("car") dot z["Grundy"] \
  &= -2.06 + 0.90 dot -0.44 \
  &= -2.06 - 0.39 \
  &approx -2.44
$
