== Model Coefficients

#include "../tables/model_coefficients.typ"

@model_coefficients provides all of the coefficients for the models fit in this project. For interpretation, it is best go variable by variable and see how they change across models. First, the intercept. This value is consistent across models, coming in around $-2.005$. When transformed back to the original scale gives around an $11% (10.5%, 12.3%)$ vacancy rate. This makes sense given what was shown in @acs_summary, which showed a median rate of $10.7%$ and a mean of $12%$. Though the estimate for the intercept is consistent across models, the standard deviation isn't. The three non-spatial models have an SD of around $0.045$, whereas the two spatial models both share a value of $0.014$. So, the spatial component seems to be increasing the precision of the intercept estimate. 

*TODO: CLARIFY FH VARIANCE COMPONENT* As for the county level random effects, this variable represents the uncertainty in vacancy rates between counties that is unexplained by the fixed effects and sampling variation provided by the Fay-Herriot model. A promising observtion from this result is that both this and the intercept match almost exactly between the frequentist and bayesian models, providing reassurance that the bayesian model is functioning as intended. 

*TODO: WRITE ABOUT SDCAR*

As for the crop proportion variable, it builds on previous concerns. As shown in @response_vs_covariate, there is a lack of an obvious relationship between the CDL covariate and housing vacancy rates. The $95%$ credible intervals of this coefficient for both the CDL and Full Model lean negative but include 0, indicating that there is insufficient evidence of a non-zero effect. These distributions provide additional evidence against its inclusion. Due to this and all of the diagnostic results, the two CDL models will not be included in further result reporting. 