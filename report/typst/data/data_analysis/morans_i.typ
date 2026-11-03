=== Tests of Spatial Autocorrelation for Housing Vacancy Rates

To assess the utility of an ICAR component in the Fay-Herriot model, Moran's I tests were performed on both the ACS response and the Census response separately to test for spatial autocorrelation. For this, the `moran.test` function was used from the `spdep` package on CRAN. For each dataset, two tests were performed under the constant risk hypothesis. One test uses binary neighbor encoding, another uses row standardization. The hypotheses for these tests are as follows:

$
  H_0: rho = 0 \
  H_a: rho > 0
$

From the results in the figure below, both forms of encoding from both datasets reach the same conclusions at the $alpha = 0.05$ level. There does seem to be evidence of positive autocorrelation of housing vacancy rates under the constant risk hypothesis. 

#include "../../tables/morans_i.typ"

It is worth noting that these tests were primarily used as a diagnostic and a quick check of method feasibility. The risk from incorrectly rejecting the null hypothesis is low, and so additional tests were not performed. What these results show is that an ICAR component in the Fay-Herriot model does have some grounding, it isn't being applied to a response with no evidence of spatial autocorrelation. 