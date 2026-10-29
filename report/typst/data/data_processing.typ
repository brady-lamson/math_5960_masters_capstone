#import "@preview/ctheorems:2.0.0": *
#show: thm-rules
#import thm-themes.ams: *

== Data Processing

=== 2020 Decennial Census of Population and Housing

=== American Community Survey

ACS data was acquired for this project through the Census Bureau API, indirectly interfaced with via the `tidycensus` R package on CRAN. Data was pulled from the 2020 5-year ACS estimates for the `B25002_001` and `B25002_003` variables, which as previously mentioned correspond to the total housing units and vacant housing units per county. The resulting dataframe has a grain of one row per variable per county, so 2 rows per county. Each row contains the estimate for that variable and its corresponding Margin of Error (MoE). This dataframe was pivoted to a grain of one row per county to facilitate creation of the response variable, vacancy rates. For each county, the vacant unit count was divided by the total housing unit count to get the vacancy rate of that county. 

$
"Vacancy Rate" = ("Vacant Housing Units" / "Total Housing Units")
$

To get the standard deviation of this new estimate, two steps are necessary. First, a conversion from MoE to standard error is required for each estimate. Then, the standard errors of both estimates must be combined to form the standard error of the proportion. The Census Bureau provides guidelines on both steps, and the same document will be referred to for both @acsStatisticalGuidelines. Conversion from MoE to SE is done by simplying dividing the MoE by 1.645.

$
"Standard Error" = "Margin of Error" / 1.645
$

As for the standard error of the proportion response, the following setup is used. First, let $P = A / B$, where A is a subset of B. A will represent the vacant housing units, B will be represent all housing units. Then, the standard error of a counties housing vacancy rate can be represented as

$
  "SE"(P) = 1 / B sqrt("SE"(A)^2 - P^2 times "SE"(B)^2)
$

==== LOGIT Transformation of the Response

As the Fay-Herriot model relies on linear regression as a key component, a proportion response can behave poorly. The domain of the output of a linear reression is the entire real line, whereas a proportion is bounded between 0 and 1. In a more traditional scenario this would lead to a logistic regression model, though usage of the Fay-Herriot model requires alternative methods to overcome this limitation. Logit transformations have been used in this scenario before, such as in research performed by Cucu Sumarni et al. that found a "logit transformation within the SAE framework improved the precision of proportion estimates" @fhLogitTransform. This takes a response bounded between 0 and 1 and maps it to the entire real line. Thus, our transformed response can be represented as

$
Q = ln(P / (1-P))
$

==== LOGIT Transformation of the Standard Error

Yet again, additional work is required for the conversion of the standard error. For this, the delta method was utilized. For reference,

#block(stroke: 1pt, inset: 10pt)[
  #definition[Delta Method][
    Let $Y_n$ be a sequence of random variables that satisfies $sqrt(n)(Y_n - theta) arrow N(0, sigma^2)$ in distribution. For a given function $g$ and a specific value of $theta$, suppose that $g'(theta)$ exists and is nonzero. Then

    $
    sqrt(n)[g(Y_n) - g(theta)] arrow N(0, sigma^2[g'(theta)]^2)
    $

    in distribution.
  ]
]


To apply this, let 

$
  g(P) = ln(P / (1-P))
$

Then, 

$
  g'(P) = 1 / (P - P^2)
$

We can then substitute this into the definition to get the updated variance, $sigma^2_Q$.

$
  sigma^2_Q &= sigma^2[g'(P)]^2) \
  &= sigma^2(1 / (P - P^2))^2 \
  &= sigma^2 / ((P-P^2)^2) \ 
  &= sigma^2 / (P^2(1-P)^2)
$

From this, our transformed standard error is

$
  sigma_Q = sigma / (P(1-P)) 
$

=== NASS Crop Data Layer