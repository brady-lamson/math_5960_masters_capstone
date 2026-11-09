== Summary Results

@result_summary contains all of the metrics used to gauge overall model performance. All results should be interpreted with respect to the ACS results, as those function as the baseline to beat. It is important to note that this section focuses on high level aggregated metrics. Further sections will focus more on performance at the individual estimate level. 

#include "../tables/model_summary.typ"

=== Mean Squared Error and Mean Absolute Error

Starting with MSE and MAE, all FH models show improvement over the ACS estimates for both metrcs. The best performer here is actually the frequentist intercept only model, having the lowest value for both metrics. Though it is possible that this is genuinely the best model for MAE and MSE, it is worth considering that this could indicate incorrect estimation collection from the Bayesian models. In other words, that this is a symptom of user error. Regardless, moving on to the Bayesian models they all perform similarly. The full model technically performs the best for MSE and the CDL model performs the best for MAE. The magnitude of these differences is miniscule however, and is not evidence on its own for any of the Bayesian models being the best on these metrics alone. 

#let estimate = $hat(theta)_i$
#let sigma = $hat(sigma)_i$
#let lower_quantile = $z_(0.025)$
#let upper_quantile = $z_(0.975)$

=== Mean Standard Deviation and Mean Interval Width

Moving onto standard deviation and interval width, some meaningful differences begin to take form. To get the baseline values for interval width, the logit transformed estimates and corresponding standard error were utilized to create a $95%$ interval on the original proportion scale. This was done by using those logit values to get the endpoints of the normal interval and then using the inverse logit function to transform them onto the proportion scale. Let #estimate represent the logit transformed estimate for a county $i$ and $sigma$ it's corresponding standard error. 

$
  "Lower"_i &= "logit"^(-1)(#estimate + #lower_quantile #sigma) \
  "Upper"_i &= "logit"^(-1)(#estimate + #upper_quantile #sigma) \
$

From this, the baseline interval width for a given county is:

#align(center)[
  #block(stroke: 1pt, inset: 10pt)[
    $
      W_i = "Upper"_i - "Lower"_i
    $
  ]
]

where #lower_quantile and #upper_quantile represent the $0.025$ and $0.975$ quantiles of the standard normal respectively.  


All 4 models show improvement from that baseline on these 2 metrics, showcasing the increased precision expected from FH estimates. The two models that incorporate the ICAR component show further improvement on these metrics than the intercept only and CDL model. This shows some initial evidence that incorporating that spatial autocorrelation helps with estimate precision beyond the standard Fay-Herriot model. The frequentist model is unable to be compared on these metrics due the lack of uncertainty provided by its county estimates. This is the key upside of the Bayesian approach and provides an interesting tradeoff given the results shown so far. The Bayesian models are worth consideration even if the MSE and MAE performance is truly less than the frequentist approach as the uncertainty built into the estimates is extremely valuable for small area estimates such as these. 

=== Interval Coverage

As for interval coverage, it represents the proportion of counties where the true value from the census is contained within the $95%$ intervals provided by the model estimates. The baseline value is $0.7374$, or 73/99 counties where the ACS intervals captures the true value. All of the models show improvement here, going up to 75/99 counties for 4 of the models and 76/99 counties for the full model. So not only are the estimates more precise with smaller intervals, those intervals capture more of the counties true vacancy rates. There is a tradeoff here that will be examined in a later section. At a glance it appears more counties are being captured that previously weren't with no downsides, though as will be shown later there are counties that the ACS captured that the Bayesian models lose. 

=== Continuous Ranked Probability Score (CRPS)

For one final comparison of overall model performance, the Continuous Ranked Probability Score (CRPS) was captured for every prediction. The CRPS can be thought of as a generalisation of the mean absolute error (MAE) used for probabilistic outputs @cprsExplanation. It's useful as it evaluates the accuracy of the overall distribution for each prediction instead of just the point estimate. 

#quote(block: true, attribution: [Skforecast Documentation])[
  The Continuous Ranked Probability Score (CRPS) is a generalisation of the Mean Absolute Error (MAE) tailored to probabilistic forecasting. Unlike the MAE, which compares point predictions to observations, the CRPS evaluates the accuracy of an entire predicted probaility distribution against the observed value. It does this by comparing the empirical cumulative distribution function (CDF) of the predicted values with the step-function CDF of the true value. 
]

As for the results of this score, all 4 bayesian models are nearly identical here. The full model pulls slightly ahead, but it is difficult to ascertain if the difference here is a meaningful one. It is worth noting that the intercept only model, which had the best MAE, loses out to the full model on CRPS.

=== Crop Data Layer Model Coefficients

Before moving on to deeper model results, the Crop Data Layer Models must be investigated. As shown in @response_vs_covariate, there is a lack of an obvious relationship between the CDL covariate and housing vacancy rates. @cdl_coefficients shows the coefficient distributions for the crop proportion covariate in both models featuring it. The $95%$ credible intervals for both the CDL and Full Model include 0, indicating that there is insufficient evidence of a non-zero effect. These distributions provide additional evidence against its inclusion. Due to this, the two CDL models will not be included in further result reporting. 

#include "../tables/cdl_coefficients.typ"