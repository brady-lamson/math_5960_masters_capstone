= Results

== Aggregate Metrics Overview

#align(center + horizon)[
  #set text(size: 9pt)
  #include "../../paper/tables/model_summary.typ"
]

== Diagnostics - Pair Plots

#align(center + horizon)[
#figure(
  image("../../../images/mcmc_pairs_full_model.png", width: 80%),
  caption: "Variable plots from MCMC Draws for the full model (ICAR and CDL covariate)."
) <mcmc_pairs>
]

== Model Coefficients
#align(center + horizon)[
  #set text(size: 8pt)
  #include "../../paper/tables/model_coefficients.typ"
]
== Results - Example Calculations

== Estimate Comparisons: Residuals

#align(center + horizon)[
#figure(
  grid(
    columns: 2,
    [#image("../../../images/residual_scatterplot_acs_int_only.png")],
    [#image("../../../images/residual_scatterplot_acs_icar_only.png")],
    [#image("../../../images/residual_scatterplot_int_icar_only.png")],
  ),
  caption: "Plots comparing the residuals of vacancy rate estimates across models. Colors represent a points position relative to the reference line. "
)
]

== Estimate Comparisons: Standard Deviations

#align(center + horizon)[
#figure(
  grid(
    columns: 2,
    [#image("../../../images/sd_scatterplot_acs_int_only.png")],
    [#image("../../../images/sd_scatterplot_acs_icar_only.png")],
    [#image("../../../images/sd_scatterplot_int_icar_only.png")],
  ),
  caption: "Plots comparing the standard deviations of vacancy rate estimates across models. Colors represent a points position relative to the reference line."
) 
]

== Estimate Comparisons: Frequentist vs. Bayesian

#align(center + horizon)[
#figure(
  grid(
    columns: 1,
    [#image("../../../images/residual_scatterplot_int_only_models.png", width: 75%)],
    [#image("../../../images/residual_scatterplot_icar_int_freq.png", width: 75%)],

  ),
  // caption:" "
)
]

== Interval Change Outcomes

#align(center + horizon)[
  #set text(size: 10pt)
  #figure(
    image("../../../images/county_capture_outcomes.png"),
    caption: "Plots showing the shifts in true value interval capture relative to the ACS intervals."
  ) 
]