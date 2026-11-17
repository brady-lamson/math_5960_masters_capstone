== Model Diagnostics

=== Summary Diagnostics

@model_diagnostics shows the results from some basic convergence diagnostic checks for all four Bayesian models. All models were fit with the same settings, using 4 chains, $10,000$ iterations and $5,000$ warmup iterations. This gave each model $20,000$ post warmup draws. Summary diagnostics were taken across all model parameters, including model coefficients, variance parameters, and county-level random effects. The ICAR models also include parameters associated with the ICAR spatial effects. The maximums and minimums were chosen as worst-case scenario diagnostics. 

#include "../tables/model_diagnostics.typ"

Starting with the $hat(r)$ values, none exceed the common threshold of $1.01$. The full model gets the closest to this threshold however, landing at $1.008$. As for effective sample sizes, there appear to be large differences in sampling efficiency across models. The ICAR model in particular contains a far larger median effective sample size at the bulk. The full model, yet again, has the only value of concern. Its minimum bulk ESS is only 798, which could indicate, alongside its max $hat(r)$ value, some issues with convergence. As for the intercept only and cdl models, they appear to have very similar results. 

=== Trace Plots and Paired Scatterplots

Trace and paired scatter plots were examined for all four Bayesian models using the `bayesplot` package on CRAN. For this report, only the plots from the full model are shown due to its poor diagnostic results. Starting with the trace plots in @mcmc_trace, there don't appear to be any extremely concerning trends to note. All 4 chains appear to explore the distributions for all 3 variables. The `bayesplot` package warns where there are any diverging chains and its output determined that there were none. It is worth pointing out that upon visual inspection, the intercept and prop corn soy trace plots do appear less dense than the sdcar variable.

#figure(
  image("../../../images/mcmc_trace_full_model.png"),
  caption: "Trace plots from MCMC Draws for the full model (ICAR and CDL covariate)."
) <mcmc_trace>

As for the collection of plots in @mcmc_pairs, there are some interesting results. For reference, the left diagonal set of plots show the posterior histograms of each variable. The scatter plots surrounding the sdcar variable show its relationship to the other two variables. The outermost scatter plots show the relationship between the prop corn soy variable and the intercept. The scatter plots are the most interesting to interpret. The ones surrounding sdcar indicate no apparently collinearity with the intercept or prop corn soy variables. The top right and bottom left plots, however, show an almost perfect negative collinearity between the intercept and prop corn soy variables. This is concerning, as it appears to indicate that the two variables are essentially sharing information and that prop corn soy is acting as a part of the intercept. 

#figure(
  image("../../../images/mcmc_pairs_full_model.png", width: 80%),
  caption: "Variable plots from MCMC Draws for the full model (ICAR and CDL covariate)."
) <mcmc_pairs>

These relationships are consistent across the various models. The ICAR model shows the same scattering as shown in the plots surrounding sdcar, and the cdl model shows the same extreme negative collinearity between variables. 
