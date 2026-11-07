== Model Estimate comparisons


The plots in @residuals_and_sds show how the residuals and standard deviations change across the ACS, Intercept Only and ICAR models. Visual inspection shows a reduction in standard deviation across both models, with a more varied reduction for the ICAR model. The overall trend is the same across both models. As the magnitude of the ACS standard deviation increases, the magnitude of the reduction does as well. 

For the residuals, there is more of a tossup in results. Many of the counties show a reduction in the absolute residuals for both models. For the intercept only residuals, they tend to stick a bit more closely to the reference line compared to the ICAR model. Both Fay-Herriot models show consistent reductions in the residuals for the counties with larger residual magnitudes from the ACS. Lower magnitude counties are less consistent however, with updated residuals moving in both directions.

When comparing the two Fay-Herriot models directly, we see the standard deviations are almost all lower for the ICAR model. It is worth noting that they stick extremely close to the trend line, so the difference isn't enormous. Similar behavior is seen for the residuals. It's a tossup for all of the counties, with more favoring the ICAR model. However, the difference is fairly slim and could very well just be due to random chance. 

#include "../plot_grids/residuals_and_sds.typ"