= Appendix

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

== Crop Land Coverage Visual

#figure(
  image("../../../images/corn_soy_land_coverage.png", width: 90%),
  caption: "Plot of land coverage per county."
) <cdl_county_map>

== Summary Diagnostics

#align(center + horizon)[
  #set text(size: 11pt)
  #include "../../paper/tables/model_diagnostics.typ"
]

== Diagnostics - Full Model Trace Plots

#align(center + horizon)[
#figure(
  image("../../../images/mcmc_trace_full_model.png", width: 80%),
  caption: "Trace plots from MCMC Draws for the full model (ICAR and CDL covariate)."
) <mcmc_trace>
]

== Examining Counties Lost
#align(center + horizon)[
  #set text(size: 10pt)
  #include "../../paper/tables/missed_counties.typ"
]