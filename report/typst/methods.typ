= Methods

#include "methods/traditional_fh.typ"

#include "methods/bayesian_fh.typ"

== Spatial Random Effects

The traditional Fay-Herriot model treats assumes the spacial random effects are identically distributed independent variables from a normal distribution with an unknown variance. This assumption is often inappropriate for the task of small area estimation, where autocorrelation between neighboring areas is expected. There has been a large amount of work historically in spatial variants of the Fay-Herriot model. 

== Auxillary covariates

== General Modeling Information

Write about parameters, write about how the icar stuff is set up in brms. Also write about how FH predictions are pulled out from the fit objects. 

== Model Evaluation

Keep it short. Just explain the metrics used. Maybe explain why LOOIC and WAIC are missing. 