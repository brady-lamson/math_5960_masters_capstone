= Data Processing - ACS / Census

== ACS/Census - Processing Steps

#align(horizon)[
  #set text(size: 13pt)
  
  1. Housing unit variables pulled from census api (total units, vacant units).
  2. Conversion from margin of error to standard error
  3. Calculate vacancy rates
  4. Get vacancy rate standard error
  5. Logit transform response
  6. Get standard error of logit transformed response

  #text(size: 9pt)[
    #include "../../paper/tables/acs_df_snippet.typ"
  ]
]

== ACS/Census - Raw Variables and Vacancy Rates

/ Variables: 
  #align(horizon)[
    #set text(size: 10pt)
    #align(center)[
      #table(
        align: center,
        columns: (auto, auto, auto,),
        table.header([Variable], [ACS Code], [Census Code]),
        [Total Housing Units], [`B25002_001`], [`H3_001N`],
        [Vacant Housing Units], [`B25002_003`], [`H3_003N`],
      )
    ]

/ Vacancy Rate:

  $
    "Vacancy Rate"_i &= ("Vacant Housing Units"_i / "Total Housing Units"_i) \
    P_i &= (A_i / B_i) quad "(Compact version)"
  $
]

#text(size: 8pt)[
- The package `tidycensus` was used to interface with the Census API.
- ACS data uses 2016-2020 5-year estimates
- Census data taken from the 2020 Census Demographic and Housing Characteristics File (DHC)
]

== ACS - Vacancy Rate Standard Error

#align(horizon)[
  #set text(size: 11pt)
  
  / Margin of Error to Standard Error: 
    $
      sigma = "Margin of Error"/1.645
    $
  #v(2em)
  / Standard Error of Proportion (P = A/B):
    $
      sigma(P_i) = 1 / B sqrt(sigma(A_i)^2 - P^2 times sigma(B)^2)
    $
]
#v(1em)
#text(size: 9pt)[
- All standard error calculations follow U.S. Census Bureau guidelines. @acsStatisticalGuidelines
]

== ACS - Logit Transformation

#align(horizon)[
  #set text(size: 12pt)
  
  - Due to the core of the FH being a linear regression, a proportion response is inappropriate. #v(1em)
  - A logit transformation is used to map $[0, 1] arrow RR$ #v(1em)
  - This is based on research done by Cucu Sumarni et al. @fhLogitTransform #v(1em)

  / Logit Transformation:
    $
      Q(P) = ln(P / (1-P))
    $
]

== ACS - Standard Error of Logit Response
#align(horizon)[
  #set text(size: 10pt)
  - This requires one final adjustment to the standard error using the delta method @deltaBERGER. 

  / Delta Method:
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

= Data Processing - CDL

== Full CDL Data Overview

#align(horizon)[
  #set text(size: 11pt)
  
  - Full Crop Data Layer has a rectangular dimension of $96523 times 153811$ pixels, resulting in approximately $14.8$ billion pixels. 
  - About $42% (6.2 "billion")$ are empty background, with the remaining $8.7 "billion"$ having actual categorizations.
  / Steps to acquire the Iowa CDL:
    1. Download census TIGER shapefiles for Iowa.
    2. Align both objects coordinate reference systems (CRS)
    3. Crop and mask the full CDL using the Iowa shapefiles.
      - Cropping filters to rectangular region for Iowa.
      - Masking sets all pixels outside borders to `NA`. 
]

#text(size: 9pt)[
  - TIGER shapefiles acquired using the `tigris` package
  - Interacting with these objects was done using the `terra` package
]

== Iowa CDL and Covariate

#align(horizon)[
  #set text(size: 9pt)
  
  - The Iowa CDL has a rectangular dimension of $11671 times 17794$, resulting in around $207$ million pixels. This is about $1.3%$ the size of the full CDL.
  - Of those, $78% (167 "million")$ are categorized. 

  / Crop Data Layer Covariate:
    - For each county, the proportion of land classified as either *corn* OR *soybeans* is captured.
    $
      "Proportion Corn or Soy"_i = ("# of Corn Pixels"_i + "# of Soybean Pixels"_i) / "# of Pixels Total"_i
    $

    - Calculating this requires the same cropping and masking steps done at the county level.

    #include "../../paper/tables/cdl_df_snippet.typ"
]