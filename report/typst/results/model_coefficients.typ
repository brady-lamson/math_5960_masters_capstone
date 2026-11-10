== Model Coefficients

#include "../tables/model_coefficients.typ"

@model_coefficients provides all of the coefficients for the models fit in this project. For interpretation, it is best go variable by variable and see how they change across models. First, the intercept. This value is consistent across models, coming in around $-2.005$. When transformed back to the original scale gives around an $11% (10.5%, 12.3%)$ vacancy rate. This makes sense given what was shown in @acs_summary, which showed a median rate of $10.7%$ and a mean of $12%$. Though the estimate for the intercept is consistent across models, the standard deviation isn't. The three non-spatial models have an SD of around $0.045$, whereas the two spatial models both share a value of $0.014$. So, the spatial component seems to be increasing the precision of the intercept estimate. 

The "County Random Effects" variable represents the square root of the variation component of the traditional Fay-Herriot model. Within the context of the model,

$
  Y_(i j) = mu + beta X_(i j) + U_i + epsilon_(i j),
$

with $U_i tilde^("iid") N(0, A)$, the county random effects variable is $sqrt(A)$. So this variable describes the distribution that all of the county random effects are realizations of. This distribution being:

$
  U_i &tilde^("iid") N(0, 0.427^2) \
  U_i &tilde^("iid") N(0, 0.182).
$

This variable is a component used to calculate the shrinkage value for each county to determine how much to alter the direct survey estimates. A promising observation from the model results is that this estimate is consistently around $0.43$ across the frequentist and bayesian models, providing some evidence that the bayesian models are behaving correctly. Another interesting observation is that the estimate barely changes when the CDL covariate is added to the model, implying that it has little effect on the between county variation. The posterior distribution of this variable from the bayesian models has a $95%$ credible interval of $(0.372, 0.505)$ for the intercept only and $(0.366, 0.501)$ for the CDL model. 

The "sdcar" parameter, present only in the ICAR models, controls the scale of the spatial estimates for each county. This will be shown in a later section. The estimated value for this variable is mostly consistent across the two models with it, coming in at approximately $0.90$ with a credible interval of $(0.769, 1.058)$. This variable, though filling a similar role to the county random effects, cannot be directly compared in terms of pure magnitude. 

As for the crop proportion variable, it builds on previous concerns. As shown in @response_vs_covariate, there is a lack of an obvious relationship between the CDL covariate and housing vacancy rates. The $95%$ credible intervals of this coefficient for both the CDL and Full Model lean negative but include 0, indicating that there is insufficient evidence of a non-zero effect. These distributions provide additional evidence against its inclusion. Due to this and all of the diagnostic results, the two CDL models will not be included in further result reporting. 