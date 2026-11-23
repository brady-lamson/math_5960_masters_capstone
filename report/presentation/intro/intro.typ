= Intro

== Background (1)

#align(horizon)[
  #set text(size: 15pt)
  - The U.S. Census Bureau is in charge of a long running survey called the American Community Survey (ACS). #v(0.5em)
  - It provides estimates on many social, economic, housing and demographic topics for the entire country. #v(0.5em)
  - These estimates become less reliable for smaller areas, such as those at the county or census tract level.
]

== Background (2)

#align(horizon)[
  #set text(size: 14pt)
  - A solution to this was proposed in 1979 by Fay and Herriot @FayHerriot1979, commonly called the Fay-Herriot Model (FH). #v(0.5em)
  - The FH model is an area-level random effects model that takes advantage of the known survey variance. #v(0.5em)
  - Allows less reliable estimates to "borrow strength" from more reliable estimates.#v(0.5em)
  - Allows for the use auxiliary covariates to improve model fit. 
]

== Motivation

#align(horizon)[
  #set text(size: 14pt)
  - The FH model assumes the area level random effects are *independent*. #v(0.5em)
  - This can be a problem when the estimate of interest exhibits *spatial autocorrelation*. #v(0.5em)
  - Solution: Spatial random effects that only borrow strength from neighboring areas. 
]

== Project Goal

#align(horizon)[
  #set text(size: 14pt)
  - This project explores spatial random effects and auxiliary covariates with a Bayesian approach on the FH model. #v(0.5em)
  - The *goal* is to try and improve county level ACS estimates of housing vacancy rates in Iowa. #v(0.5em)
  - The decennial census values will be used for model evaluation. 
]

== Presentation Overview

#align(horizon)[
  #set text(size: 17pt)
  1. An overview of the motivating data
  2. Necessary data processing for modeling
  3. Relevant analysis of the data
  4. Explanation of the technical methodology
  5. Breakdown of results
  6. Discussion of limitations and final conclusions
]