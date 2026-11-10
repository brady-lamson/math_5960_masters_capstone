== Model Diagnostics

=== Summary Diagnostics

@model_diagnostics shows the results from some basic convergence diagnostic checks for all 4 bayesian models. All models were fit with the same settings, using 4 chains, $10,000$ iterations and $5,000$ warmup iterations. This gave each model $20,000$ post warmup draws. Summary diagnostics were taken across all model parameters, including model coefficients, variance parameters, and county-level random effects. The ICAR models also includes parameters associated with the ICAR spatial effects. The maximums and minimums were chosen as worst case scenario diagnostics. 

#include "../tables/model_diagnostics.typ"

Starting with the $hat(r)$ values, none exceed the common threshold of $1.01$. The full model gets the closest to this threshold however, landing at $1.008$. As for effective sample sizes, there appear to be large differences in sampling efficiency across models. The ICAR model in particular contains a far larger median effective sample size at the bulk. The full model, yet again, has the only value of concern. It's minimum bulk ESS is only 798, which could indicate, alongside its max $hat(r)$ value, some issues with convergence. As for the intercept only and cdl models, they appear to have very similar results. 

=== Trace Plots and Paired Scatterplots

Trace and paired scatterplots were examined for all 4 baysian models using the `bayesplots` package on CRAN. For this report, only the plots from the full model are shown due to its prior concerning diagnostic results. Starting with the traceplots in @mcmc_trace, there don't appear to be any extremely concerning trends to note. All 4 chains appear to explore the distributions for all 3 variables. The `bayesplot` package warns where there are any diverging chains and it's output determined that there were none. It is worth pointing out that upon visual inspection, the intercept and prop corn soy trace plots do appear less dense than the sdcar variable.

#figure(
  image("../../../images/mcmc_trace_full_model.png"),
  caption: "Trace plots from MCMC Draws for the full model (ICAR and CDL covariate)."
) <mcmc_trace>

As for the collection of plots in @mcmc_pairs, there are some interesting results. For reference, the left diagonal set of plots show the posterior histograms of each variable. The scatterplots surrounding the sdcar variable show its relationship to the other two variables. The outermost scatterplots show the relationship between the prop corn soy variable and the intercept. The scatterplots are the most interesting to interpret. The ones surrounding sdcar indicate no apparently colinearity with the intercept or prop corn soy variables. The top right and bottom left plots however show an almost perfect negative colinearity between the intercept and prop corn soy variables. This is concerning, as it appears to indicate that the two variables are essentially sharing information and that prop corn soy is acting as a part of the intercept. 

#figure(
  image("../../../images/mcmc_pairs_full_model.png", width: 80%),
  caption: "Variable plots from MCMC Draws for the full model (ICAR and CDL covariate)."
) <mcmc_pairs>

These relationships are consistent through the various models. The ICAR model shows the same scattering as shown in the plots surrounding sdcar, and the cdl model shows the same extreme negative colinearity between variables. 

// === Crop Data Layer Model Coefficients

// Due to the above diagnostic results, the Crop Data Layer Models coefficients must be investigated. As shown in @response_vs_covariate, there is a lack of an obvious relationship between the CDL covariate and housing vacancy rates. @cdl_coefficients shows the coefficient distributions for the crop proportion covariate in both models featuring it. The $95%$ credible intervals for both the CDL and Full Model include 0, indicating that there is insufficient evidence of a non-zero effect. These distributions provide additional evidence against its inclusion. Due to all of these diagnostic results, the two CDL models will not be included in further result reporting. 

// #include "../tables/cdl_coefficients.typ"