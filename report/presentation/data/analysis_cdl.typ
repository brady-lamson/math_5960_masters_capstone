= Data Analysis - Crop Data Layer

== Crop Data Layer Overview

#align(center + horizon)[
  #set text(size: 10pt)
  #include "../../paper/tables/cdl_percentages.typ"
]

== Iowa Corn Distribution

#align(center + horizon)[
#figure(
  image("../../../images/corn_spatial_distribution.png"),
  caption: "Plots showcasing the aggregated spatial distribution of corn. Aggregation performed on each crop separately taking the mean of every 25x25 pixel area."
)
]

== Iowa Soybean Distribution

#align(center + horizon)[
#figure(
  image("../../../images/soy_spatial_distribution.png"),
  caption: "Plots showcasing the aggregated spatial distribution of soybeans. Aggregation performed on each crop separately taking the mean of every 25x25 pixel area."
)
]

== Crop Land Coverage Summary

#align(center + horizon)[
#include "../../paper/tables/cdl_covariate_summary.typ"
]

== Housing Vacancy Rates vs Crop Land Coverage

#align(center + horizon)[
#figure(
  image("../../../images/response_vs_covariate.png", width: 75%),
  caption: "Scatter plot showing the a mild negative relationship between vacancy rates and corn/soy land coverage."
) <response_vs_covariate>
]