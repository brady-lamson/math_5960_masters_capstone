#import "@preview/ctheorems:2.0.0": *
#show: thm-rules
#import thm-themes.ams: *

== Data Processing

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

==== Logit Transformation of the Response

As the Fay-Herriot model relies on linear regression as a key component, a proportion response can behave poorly. The domain of the output of a linear reression is the entire real line, whereas a proportion is bounded between 0 and 1. In a more traditional scenario this would lead to a logistic regression model, though usage of the Fay-Herriot model requires alternative methods to overcome this limitation. Logit transformations have been used in this scenario before, such as in research performed by Cucu Sumarni et al. that found a "logit transformation within the SAE framework improved the precision of proportion estimates" @fhLogitTransform. This takes a response bounded between 0 and 1 and maps it to the entire real line. Thus, our transformed response can be represented as

$
Q = ln(P / (1-P))
$

==== Logit Transformation of the Standard Error

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

The final dataframe contains a variety of other columns for diagnostic and exploratory purposes, but the dataframe of modeling components looks like so:

#include "../tables/acs_df_snippet.typ"

=== 2020 Decennial Census of Population and Housing

Ingestion and processing of the 2020 decennial census data was handled in a similar manner to the ACS data. Data was acquired through the `tidycensus` package, used to access the 2020 Census Demographic and Housing Characteristics File (DHC). The variables pulled were `H3_001N` and `H3_003N`, which correspond to total housing units and total vacant units repsectively. The grain of the data is the same as the original ACS data, one row per county per variable. The final table had one row per county, and a new column representing the housing vacancy rate was created in percent units. These values were not passed through a LOGIT transformation as they are intended for comparison against the predictions after they have been transformed back into the original proportion scale.

To ensure the accuracy of census housing vacancy rates, output was compared to the official housing vacancy numbers provided by the Census Bureau in their 2020 Iowa breakdown @censusIowa2020. All of the values matched their values presented on that sites dashboard. Below is a snippet of the data.

#include "../tables/census_df_snippet.typ"

=== NASS Crop Data Layer

The crop data layer requires careful processing to be usable in this project. At a $30 times 30$ meter resolution, the 2020 crop data layer raster image has a rectangular dimension of $96523 times 153811$ pixels, or 14.8 billion pixels total. About 6.2 billion $(42%)$ pixels are empty background pixels and 8.7 billion encompassing actual categorizations. Naive calculations performed on this object are prone to overloading the memory of the machine running them. The `terra` package was used for loading and processing this file. For filtering down to only Iowa's portion of the CDL, the `tigris` package was utilized to download Iowa's TIGER shapefiles from the U.S. Census. The coordinate reference systems (CRS) of the two objects were aligned to NAD83 Conus Albers (ESPG:5070). Cropping and masking is then performed on the CDL using the Iowa shapefile object. Cropping filters the CDL down to the rectangular region containing Iowa, and masking changes all pixels outside of the state borders to NA. 

This new object, the Iowa CDL, contains a rectangular dimension of $11671 times 17794$, or approximately 207 million pixels total. That is $1.3%$ the size of the original CDL. Of those, about 46 million $(22%)$ are empty background, and appoximately 162 million $(78%)$ pixels are categorized. From here, the goal is to get a table containing the frequency and proportion breakdown of every county in the state. To accomplish this goal, a similar process was used as before. County shapefiles were acquired using `tigris` and, using an iterative approach over the counties that leverages cropping and masking, the frequencies of every CDL classification were captured alongside the total number of pixels within the county's borders. A dataframe was created from this that contains one row per county, with the percent of the pixels in the county that were classified as either corn or soybeans. The proportion from this functions as the spatial covariate for the model and can be represented as:

$
  "Proportion Corn or Soy"_i = ("# of Corn Pixels"_i + "# of Soybean Pixels"_i) / "# of Pixels Total"_i
$

With $i$ representing the index of a given county. 

Below is a snippet of the resulting dataframe. Values are saved as percentages and converted to proportions at the modeling stage.

#include "../tables/cdl_df_snippet.typ"