= Data Processing - ACS

== ACS - Processing Steps

#align(horizon)[
  #set text(size: 13pt)
  
  1. Housing unit variables pulled from census api (total units, vacant units).
  2. Conversion from margin of error to standard error
  3. Calculate vacancy rates
  4. Get vacancy rate standard error
  5. Logit transform response
  6. Get standard error of logit transformed response

  #set text(size: 9pt)
  #include "../../paper/tables/acs_df_snippet.typ"
]

== ACS - Raw Variables and Vacancy Rates

#align(horizon)[
  #set text(size: 11pt)
  - Variables used: Total housing units (`B25002_001`) and Vacant Housing Units (`B25002_003`) at the county level from the 2016-2020 ACS. 

/ Vacancy Rate:

  $
    "Vacancy Rate"_i &= ("Vacant Housing Units"_i / "Total Housing Units"_i) \
    P_i &= (A_i / B_i) quad "(Compact version)"
  $
]

  #set text(size: 9pt)
  - The package `tidycensus` was used to interface with the Census API.

== ACS - Vacancy Rate Standard Error

#align(horizon)[
  #set text(size: 11pt)
  
  / Margin of Error to Standard Error: 
    $
      sigma = "Margin of Error"/1.645
    $
  / Standard Error of Proportion (P = A/B):
    $
      sigma(P_i) = 1 / B sqrt(sigma(A_i)^2 - P^2 times sigma(B)^2)
    $
]

#set text(size: 9pt)
- All standard error calculations follow U.S. Census Bureau guidelines.

== ACS - Logit Transformation

#align(horizon)[
  #set text(size: 12pt)
  
  - Due to the core of the FH being a linear regression, a proportion response is inappropriate. 
  - A logit transformation is used to map $[0, 1] arrow RR$

  / Logit Transformation:
    $
      Q(P) = ln(P / (1-P))
    $
]

== ACS - Standard Error of Logit Response
#align(horizon)[
  #set text(size: 10pt)
  - This requires one final adjustment to the standard error using the delta method.
  / Delta Method :
      Let $Y_n$ be a sequence of random variables that satisfies $sqrt(n)(Y_n - theta) arrow N(0, sigma^2)$ in distribution. For a given function $g$ and a specific value of $theta$, suppose that $g'(theta)$ exists and is nonzero. Then
    $
      sqrt(n)[g(Y_n) - g(theta)] arrow N(0, sigma^2[g'(theta)]^2)
    $
  
  Let $g(P) = ln(P / (1-P))$. Following the delta method gives us:

  / Standard Error of Logit(Vacancy Rate):
    $

      sigma_Q &= sigma / (P(1-P)) 
    $
]