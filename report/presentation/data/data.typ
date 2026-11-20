= Data Sources

== 2020 Decennial Census

Census stuff

== American Community Survey

Stuff



= Data Processing

== American Community Survey



= Data Analysis

== Iowa Spatial Structure

#figure(
  image("../../../images/iowa_neighborhood_links.png", width: 80%),
  caption: "Plot showing adjacent county links across Iowa."
)

== Census Housing Overview

#align(center + horizon)[#include "../../paper/tables/census_df_summary.typ"]

== Census - Housing and Vacancy

#align(center + horizon)[
#figure(
  grid(
    columns: 2,
    [#image("../../../images/housing_vs_vacant_scatterplot.png")],
    [#image("../../../images/housing_vs_vacancy_rates_scatterplot.png")]
  ),
  caption: "Plots showing the change of relationship when moving from pure vacant housing units to a vacancy rate."
)
]

== Census - Spatial Dist'n of Housing

#align(center + horizon)[
#figure(
  grid(
    columns: 2,
    [#image("../../../images/num_houses_by_county.png")],
    [#image("../../../images/vacancy_rate_by_county.png")]
  ),
  caption: "Spatial plots showing the distribution of housing units and vacancy rates by county across the state."
)
]