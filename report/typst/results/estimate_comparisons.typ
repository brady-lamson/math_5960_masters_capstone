== Model Estimate comparisons

=== Residuals and Standard Deviations

The plots in @residuals_and_sds show how the residuals and standard deviations change across the ACS, Intercept Only and ICAR models. Visual inspection shows a reduction in standard deviation across both models, with a more varied reduction for the ICAR model. The overall trend is the same across both models. As the magnitude of the ACS standard deviation increases, the magnitude of the reduction does as well. 

For the residuals, there is more of a tossup in results. Many of the counties show a reduction in the absolute residuals for both models. For the intercept only residuals, they tend to stick a bit more closely to the reference line compared to the ICAR model. Both Fay-Herriot models show consistent reductions in the residuals for the counties with larger residual magnitudes from the ACS. Lower magnitude counties are less consistent however, with updated residuals moving in both directions.

#include "../plot_grids/residuals_and_sds.typ"

When comparing the two Fay-Herriot models directly, visual examination shows that the standard deviations are almost all lower for the ICAR model. It is worth noting that they stick extremely close to the trend line, so the difference isn't enormous. Similar behavior is seen for the residuals. It's a tossup for all of the counties, with more favoring the ICAR model. However, the difference is fairly slim and could very well just be due to random chance. 

The bottom row of plots compares the Bayesian models to the Frequentist Intercept Only model. The bottom left plot with the ICAR model is, visually, nearly identical to the plot above it which examines the Bayesian Intercept Only model. The bottom right plot of the grid compares the two Intercept Only models, the Bayesian and Frequentist approaches. Almost all of the counties fall above the reference line, indicating that the Bayesian approach has slightly higher residuals than the frequentist approach across the board. They all fall very close to the reference line however. This provides some light evidence in the direction of behavioral equivalence between Intercept Only models. 

=== Interval Coverage Outcomes

When digging into improvements to residuals and standard deviations, it is always crucial to examine if the changes are meaningful and beneficial. To accomplish this, the interval coverage metric shown in @result_summary is examined more closely. @coverage_outcomes shows counties that are gained and lost when moving to one of the two SAE models. Whether a county is captured or not is based on if the $95%$ prediction interval for a county contains the true value from the census.

Earlier in the report it was mentioned that the increased value of interval coverage relative to the ACS implies a gain with no tradeoff. This plot shows the tradeoff that summary metric fails to capture. The lefthand plot shows the outcomes resulting from the ICAR model prediction intervals. Of the 99 counties, 5 of them have true values that fall within the ICAR intervals that did not fall in the ACS intervals. However, 3 counties show the opposite result. These are counties captured by the ACS prediction intervals that fall outside the ICAR intervals. This results in a net gain of 2 counties. 

#figure(
  image("../../../images/county_capture_outcomes.png"),
  caption: "Plots showing the consequences of SAE estimates and intervals. Blue squares represent counties where the SAE intervals capture the true value that the ACS intervals failed to. Red is the opposite, showing true values that the ACS captured that the SAE interval failed to."
) <coverage_outcomes>

A particular limitation of the interval coverage metric appears when examining the Intercept only plot on the right. It shows the same net gain, 2 more counties gained than lost. However, that model captures 4 counties and loses 2. The interval coverage metric implies that these two models are equivalent, though they reach different conclusions across counties. 

Both models are consistent across the vast majority of counties. They both gain Deleware, Sac, and Van Buren counties. They both lose Cedar and Dickinson counties. There are 4 counties where outcomes differ. Of those, the ICAR model gains Boone and Monroe county but loses Henry county. The intercept only model gains Wayne county and does not lose Henry county. 

#include "../tables/missed_counties.typ"

@missed_counties shows the results from those counties lost moving from the ACS to SAE models. What these results show is that, though the conclusions differ, estimates are not showing dramatic shifts. These are three counties where the true value falls at the edge of the original intervals, so any minute change results in them being lost. Them being at the edge of their respective intervals is unsurprising, as they land near the tails of the vacancy rate distribution. Dickinson is an interesting county as it has the largest vacancy rate of all counties in Iowa. As such, a method like Fay-Herriot that brings estimates more in line with the regression results is behaving as expected. Cedar and Henry are on the opposite side, falling closer to the 1st quartile of true values $(0.0789)$. This is well below the 1st quartile of ACS estimtates $(0.0900)$ which explains their overestimated values. 

These results are promising as they make the tradeoff discussed earlier less dramatic. The true values no longer fall within the $95%$ prediction interval, but the estimtates themselves barely changed. These models aren't making these county's estimates dramatically worse. These were already sensitive counties to begin with. 