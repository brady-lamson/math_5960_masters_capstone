= Data Analysis - ACS

== ACS Housing Overview

#align(center + horizon)[#include "../../paper/tables/acs_df_summary.typ"]

== ACS Housing Errors

#align(center + horizon)[
  #set text(size: 9pt)
  #include "../../paper/tables/acs_df_se_summary.typ"
]

== ACS Response Distribution

#align(center + horizon)[
#figure(
  grid(
    columns: 2,
    [#image("../../../images/response_density.png")],
    [#image("../../../images/response_logit_density.png")]
  ),
  caption: "Distribution of the response before and after the logit transformation."
) <response_distribution>
]
