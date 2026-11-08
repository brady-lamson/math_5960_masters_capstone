=== American Community Survey

Analysis begins with the ACS equivalent of @census_summary, shown in @acs_summary. What is shown are near identical values, though there is a slight difference. The minimums never reach the same lows, and the maximums never reach the same highs. However, the values throughout the 1st and 3rd quartiles are consistently above those from the census. 

#include "../../tables/acs_df_summary.typ"

Examining the summary of the errors in @acs_error_summary shows some extremely interesting behavior. The standard errors of the vacancy estimates are far higher than the total unit estimates. On average, the ratio of the vacant standard error to the total unit standard error is around $2.8$, and goes all the way up to $7.1$. This is before even accounting for the fact that the vacant unit estimates are far smaller, being a subset of the total. What this means is the vacancy unit estimates are far less precise than the total estimates are, and this lack of precision carries to the proportion as well. The relative standard errors for the vacancy estimates appear nearly identical to those of the vacancy rates. 

#include "../../tables/acs_df_se_summary.typ"

Examining the relationships between the estimates, their corresponding standard errors and relative standard errors in @est_vs_errors shows us a few things. Firstly, it shows that the magnitude of standard errors tend to rise alongside the magnitude of the estimates themselves, and that this is consistent across all 3 types of estimates. Second, it shows that the opposite relationship arises when the standard errors are instead looked at relative to the size of the estimates themselves. In other words, larger estimates tend to be more precise. The counties with less housing units have larger errors in proportion to their estimates. This intutively makes sense as the samples themselves are smaller, there is less data to go off of for the estimates. It is worth noting that this does not mean that the larger estimates are more accurate, as no comparison has been made yet to the true values from the census. 

The takeaway from these findings is that the smaller counties are going to be worth looking at closely in the model comparisons. In theory, these are the counties with the most room for growth as they can pull from the higher precision in other counties with more housing units.

#figure(
  grid(
    columns: 3,
    [#image("../../../../images/total_units_est_vs_error.png")],
    [#image("../../../../images/vacant_units_est_vs_error.png")],
    [#image("../../../../images/vacancy_rates_est_vs_error.png")],
    [#image("../../../../images/total_units_est_vs_rel_error.png")],
    [#image("../../../../images/vacant_units_est_vs_rel_error.png")],
    [#image("../../../../images/vacancy_rates_est_vs_rel_error.png")],
  ),
  caption: "Plots showing the relationship estimates share with their standard errors and relative standard errors (SE / Estimate)."
) <est_vs_errors>

The distributions of the response and errors can be seen in @response_distribution. The untransformed response is unimodal with a long right tail with a small bump in density around 0.4. The transformed response is very similar in distribution, but with a slightly less extreme right tail. Overall, it looks slightly more normally distributed than the untransformed response.

#figure(
  grid(
    columns: 2,
    [#image("../../../../images/response_density.png")],
    [#image("../../../../images/response_logit_density.png")]
  ),
  caption: "Distribution of the response before and after the logit transformation."
) <response_distribution>

As for the errors shown in @error_distribution, the shape stays mostly the same both before and after the response is transformed. The errors of the logit transformed response do show a couple additional bumps that aren't present in the original errors, though that may be more of an artifact of the plotting methodology than a meaningful change in distribution. 

#figure(
  grid(
    columns: 2,
    [#image("../../../../images/error_density.png")],
    [#image("../../../../images/error_logit_density.png")]
  ),
  caption: "Distribution of the standard errors before and after the logit transformation of the response. "
) <error_distribution>