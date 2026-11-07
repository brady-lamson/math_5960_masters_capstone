== Crop Data Layer Models

=== Coefficients

Before moving on to deeper model results, the Crop Data Layer Models must be investigated. As shown in @response_vs_covariate, there is a lack of an obvious relationship between the CDL covariate and housing vacancy rates. This raises the question on its ability to be an effective covariate for modeling. @cdl_coefficients shows the coefficients for both models featuring the CDL covariate. Examining the percentile columns for rows with the `Crop Proportion` variable provides additional evidence against this covariate. The $95%$ credible intervals for both the CDL and Full Model include 0, indicating that there is insufficient evidence of a non-zero effect. 

#include "../tables/cdl_coefficients.typ"

=== Bayes Factor

*TODO: DO THIS EXPLANATION BETTER DEAR GOD*

Further investigation utilized the Bayes Factor of each model combination, shown in @bayes_factor. The Bayes Factor is the ratio of the marginal likelihoods of the two selected models. This comparison was done using the `bayes_factor` function from the `brms` package. For each combination of models, 5 bayes factors were calculated and then averaged together for the final result. This was on the recommendation of the package authors themselves, stating that this value can be unstable in some circumstances due to the bridge sampling it uses. Observed factors were stable across runs, though this methodology was preserved.

#include "../tables/bayes_factor.typ"

Of relevance for this section are the rows where the CDL is added as a covariate where it was not there previously. Those rows are the first and last rows. These represent adding the CDL to the intercept only model, and adding the CDL to the ICAR model. The values, $1.167$ for intercept vs. cdl and $1.141$ for full vs. icar don't show a lot of evidence to indicate it's adding a lot of information.

The Bayes Factor in this project is being used primarily as a supplementary diagnostic instead of its typical role as an important hypothesis testing tool. There are many limitations to this methodology that make it unreliable for decision making. 

Anyway, blech ugh god. Wont be adding in cdl stuff in later sections please thanks bye. 

Probably cite like gelman (page 183) and others idk. 