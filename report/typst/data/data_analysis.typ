== Data Analysis

=== Iowa Spatial Structure <iowa_spatial>

Iowa was chosen for this project for a few reasons. The first is that it has some very populated counties and very sparsely populated counties. This allows for a good demonstration of the Fay-Herriot model as it can effectively pool from informative counties. This will be discussed in more detail in later sections. 

Second is the layout of its counties. Iowa has 99 counties total and they are arranged in a very neat grid as shown in the figure below. On average, each county has $5.9$ neighbors with a minimum of 3 and a maximum of 8. There are no disjointed islands or bizarre geometries that would complicate spatial calculations as well. As such, this state shows useful properties for both Fay-Herriot modeling and spatial methods. 

#figure(
  image("../../../images/iowa_neighborhood_links.png", width: 80%),
  caption: "Plot showing adjacent county links across Iowa."
)

=== 2020 Decennial Census of Population and Housing <census_eda>

The counties in Iowa vary dramatically in terms of their population and housing. The number of total housing units can range from as little as $1,888$ (Adams County) all the way up to $210,184$ (Polk County). 29 of the 99 total counties have less than $5,000$ total housing units.

#include "../tables/census_df_summary.typ"

The same trend is seen with vacant units, as one would expect places with more houses also have more vacant houses. These variables show an almost perfect correlation $(r = 0.947)$. This relationship does not hold however for vacancy rates which show a mild negative correlation with total housing units $(r = -0.237)$. The highest vacancy rates appear on counties with low total housing units. This is unsurprising as each vacant house contributes more to the vacancy rate than one would in larger counties.

#figure(
  grid(
    columns: 2,
    [#image("../../../images/housing_vs_vacant_scatterplot.png")],
    [#image("../../../images/housing_vs_vacancy_rates_scatterplot.png")]
  ),
  caption: "Plots showing the change of relationship when moving from pure vacant housing units to a vacancy rate."
)

#figure(
  grid(
    columns: 2,
    [#image("../../../images/num_houses_by_county.png")],
    [#image("../../../images/vacancy_rate_by_county.png")]
  ),
  caption: "Spatial plots showing the distribution of housing units and vacancy rates by county across the state."
)

Examining these values at the spatial level, we can see that the overall population of housing units is heavily concentrated in a small number of counties scattered throughout the state. In contract, vacancy rates show a far more mixed distribution of values. Visually it is unclear if there is evidence of spatial autocorrelation for the vacancy rates, but there does appear to be some grouping.


=== American Community Survey

To begin the analysis, we examine the ACS equivalent of @census_summary, shown in @acs_summary. What we see are near identical values, though there is a slight difference. The minimums never reach the same lows, and the maximums never reach the same highs. However, the values throughout the 1st and 3rd quartiles are consistently above those from the census. 

#include "../tables/acs_df_summary.typ"

Examining the summary of the errors in @acs_error_summary shows some extremely interesting behavior. The standard errors of the vacancy estimates are far higher than the total unit estimates. On average, the ratio of the vacant standard error to the total unit standard error is around $2.8$, and goes all the way up to $7.1$. This is before even accounting for the fact that the vacant unit estimates are far smaller, being a subset of the total. What this means is the vacancy unit estimates are far less precise than the total estimates are, and this lack of precision carries to the proportion as well. We can see that the relative standard errors for the vacancy estimates are nearly identical to those of the vacancy rates. 

#include "../tables/acs_df_se_summary.typ"

Examining the relationships between the estimates, their corresponding standard errors and relative standard errors in @est_vs_errors shows us a few things. Firstly, it shows that the magnitude of standard errors tend to rise alongside the magnitude of the estimates themselves, and that this is consistent across all 3 types of estimates. Second, it shows that the opposite relationship arises when the standard errors are instead looked at relative to the size of the estimates themselves. In other words, larger estimates tend to be more precise. The counties with less housing units have larger errors in proportion to their estimates. This intutively makes sense as the samples themselves are smaller, there is less data to go off of for the estimates. It is worth noting that this does not mean that the larger estimates are more accurate, as no comparison has been made yet to the true values from the census. 

The takeaway from these findings is that the smaller counties are going to be worth looking at closely in the model comparisons. In theory, these are the counties with the most room for growth as they can pull from the higher precision in other counties with more housing units.

#figure(
  grid(
    columns: 3,
    [#image("../../../images/total_units_est_vs_error.png")],
    [#image("../../../images/vacant_units_est_vs_error.png")],
    [#image("../../../images/vacancy_rates_est_vs_error.png")],
    [#image("../../../images/total_units_est_vs_rel_error.png")],
    [#image("../../../images/vacant_units_est_vs_rel_error.png")],
    [#image("../../../images/vacancy_rates_est_vs_rel_error.png")],
  ),
  caption: "Plots showing the relationship estimates share with their standard errors and relative standard errors (SE / Estimate)."
) <est_vs_errors>

The distributions of the response and errors can be seen in @response_distribution. The untransformed response is unimodal with a long right tail with a small bump in density around 0.4. The transformed response is very similar in distribution, but with a slightly less extreme right tail. Overall, it looks slightly more normally distributed than the untransformed response.

#figure(
  grid(
    columns: 2,
    [#image("../../../images/response_density.png")],
    [#image("../../../images/response_logit_density.png")]
  ),
  caption: "Distribution of the response before and after the logit transformation."
) <response_distribution>

As for the errors shown in @error_distribution, the shape stays mostly the same both before and after the response is transformed. The errors of the logit transformed response do show a couple additional bumps that aren't present in the original errors, though that may be more of an artifact of the plotting methodology than a meaningful change in distribution. 

#figure(
  grid(
    columns: 2,
    [#image("../../../images/error_density.png")],
    [#image("../../../images/error_logit_density.png")]
  ),
  caption: "Distribution of the standard errors before and after the logit transformation of the response. "
) <error_distribution>

=== Tests of Spatial Autocorrelation for Housing Vacancy Rates

To assess the utility of an ICAR component in the Fay-Herriot model, Moran's I tests were performed on both the ACS response and the Census response separately to test for spatial autocorrelation. For this, the `moran.test` function was used from the `spdep` package on CRAN. For each dataset, two tests were performed under the constant risk hypothesis. One test uses binary neighbor encoding, another uses row standardization. The hypotheses for these tests are as follows:

$
  H_0: rho = 0 \
  H_a: rho > 0
$

From the results in the figure below, both forms of encoding from both datasets reach the same conclusions at the $alpha = 0.05$ level. There does seem to be evidence of positive autocorrelation of housing vacancy rates under the constant risk hypothesis. 

#include "../tables/morans_i.typ"

It is worth noting that these tests were primarily used as a diagnostic and a quick check of method feasibility. The risk from incorrectly rejecting the null hypothesis is low, and so additional tests were not performed. What these results show is that an ICAR component in the Fay-Herriot model does have some grounding, it isn't being applied to a response with no evidence of spatial autocorrelation. 

=== NASS Crop Data Layer

