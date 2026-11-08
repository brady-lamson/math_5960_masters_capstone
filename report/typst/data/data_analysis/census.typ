=== 2020 Decennial Census of Population and Housing <census_eda>

The counties in Iowa vary dramatically in terms of their population and housing. The number of total housing units can range from as little as $1,888$ (Adams County) all the way up to $210,184$ (Polk County). 29 of the 99 total counties have less than $5,000$ total housing units.

#include "../../tables/census_df_summary.typ"

The same trend is seen with vacant units, as one would expect places with more houses also have more vacant houses. These variables show an almost perfect correlation $(r = 0.947)$. This relationship does not hold however for vacancy rates which show a mild negative correlation with total housing units $(r = -0.237)$. The highest vacancy rates appear on counties with low total housing units. This is unsurprising as each vacant house contributes more to the vacancy rate than one would in larger counties.

#figure(
  grid(
    columns: 2,
    [#image("../../../../images/housing_vs_vacant_scatterplot.png")],
    [#image("../../../../images/housing_vs_vacancy_rates_scatterplot.png")]
  ),
  caption: "Plots showing the change of relationship when moving from pure vacant housing units to a vacancy rate."
)

#figure(
  grid(
    columns: 2,
    [#image("../../../../images/num_houses_by_county.png")],
    [#image("../../../../images/vacancy_rate_by_county.png")]
  ),
  caption: "Spatial plots showing the distribution of housing units and vacancy rates by county across the state."
)

Examining these values at the spatial level, the overall population of housing units appears heavily concentrated in a small number of counties scattered throughout the state. In contract, vacancy rates show a far more mixed distribution of values. Visually it is unclear if there is evidence of spatial autocorrelation for the vacancy rates, but there does appear to be some grouping.