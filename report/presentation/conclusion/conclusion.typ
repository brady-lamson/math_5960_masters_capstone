= Conclusion

== Limitations

#align(horizon)[
  #set text(size: 10pt)
  / Crop Data Layer Covariate:
    - Was intended to showcase the potential effectiveness of auxiliary covariates, ended up inconsequential.
    - Was a holdover from the original project topic on the agricultural industry. 
    - Kept around primarily to showcase methodology.
  
  / Decennial Census as Source of Truth:
    - The census is a human process that by its nature contains error.
    - The 2020 census in particular faced "late census design changes, staffing issues and budgetary uncertainty" @censusUncertainty. 
    - This method of model evaluation does not work outside of census years

  / Other:
    - The Frequentist equivalent of ICAR and CDL models were never fit.
    - Abstracted modeling libraries limit low-level control of models. 
]

== Discussion

#align(horizon)[
  #set text(size: 12pt)
  - All versions of the Fay-Herriot model showed improvement to MSE, with the Frequentist intercept-only coming out on top.
  - All Bayesian models showed improvement to estimate precision, reducing standard errors and interval width. 
    - This is also made possible by the uncertainty quantification inherent to Bayesian models. 
  - Crop land coverage covariate was inconsequential, failing to show significant evidence of a non-zero effect.
  - Spatial random effects showed further improvements to estimate precision, having the narrowest intervals of the models without substantial loss to MSE.
]