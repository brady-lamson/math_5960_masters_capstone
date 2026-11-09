== Model Diagnostics

=== Summary Diagnostics

#include "../tables/model_diagnostics.typ"

=== Crop Data Layer Model Coefficients

Before moving on to deeper model results, the Crop Data Layer Models must be investigated. As shown in @response_vs_covariate, there is a lack of an obvious relationship between the CDL covariate and housing vacancy rates. @cdl_coefficients shows the coefficient distributions for the crop proportion covariate in both models featuring it. The $95%$ credible intervals for both the CDL and Full Model include 0, indicating that there is insufficient evidence of a non-zero effect. These distributions provide additional evidence against its inclusion. Due to this, the two CDL models will not be included in further result reporting. 

#include "../tables/cdl_coefficients.typ"