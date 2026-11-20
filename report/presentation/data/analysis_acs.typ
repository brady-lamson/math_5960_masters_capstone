= Data Analysis - ACS

== ACS Housing Overview

#align(center + horizon)[#include "../../paper/tables/acs_df_summary.typ"]

== ACS Housing Errors

#align(center + horizon)[
  #set text(size: 9pt)
  #include "../../paper/tables/acs_df_se_summary.typ"
]

== ACS Estimates vs. Errors

#align(center + horizon)[
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

== ACS Error Distribution

#align(center + horizon)[
#figure(
  grid(
    columns: 2,
    [#image("../../../images/error_density.png")],
    [#image("../../../images/error_logit_density.png")]
  ),
  caption: "Distribution of the standard errors before and after the logit transformation of the response. "
) <error_distribution>
]

== Vacancy Rate Autocorrelation

*Autocorrelation test: Moran's I* $(alpha = 0.05)$

#align(center )[
  #set text(size: 9pt)
  #include "../../paper/tables/morans_i.typ"
]

Moran's I Hypotheses:

$
  H_0: rho = 0 \
  H_a: rho > 0
$