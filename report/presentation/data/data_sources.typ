= Data Sources

== Sources Overview

#align(horizon)[
  #set text(size: 16pt)
  This project pulls from three data sources overall.

  1. *Decennial Census* (2020) #v(1em)
  2. *American Community Survey* (2016-2020) #v(1em)
  3. *USDA NASS Crop Data Layer* (2020)
]

== 2020 Decennial Census

#align(horizon)[
  #set text(size: 15pt)
  - Carried out every 10 years by U.S. Census Bureau.
  - Official source of demographic and housing information for the country.
  - Used as the source of "true values" for model evaluation.
  - *NOTE:* Census values are not perfect even though this project treats them as true values. Uncertainty in these values is outside the scope of this project.
]

== American Community Survey (1)

#align(horizon)[
  #set text(size: 17pt)
  - Ongoing survey carried out by the U.S. Census Bureau, sent out every month of every year to a sample of households. #v(1em)
  - Provides current estimates on a larger set of topics. #v(1em)
  - Contains a "margin of error" alongside every estimate. 
  
]

== American Community Survey (2)

#align(horizon)[
  #set text(size: 13pt)
  - Comes in two forms. *1-year* and *5-year* estimates. #v(1em)
  - *1-year* estimates are more current, but less precise and only provide estimates for areas with more than $65,000$ population size. #v(1em)
  - *5-year* estimates are less current, but more precise and contain estimates for small areas such as at the county level. #v(1em)
  - Ratio of vacant housing units / total housing units creates the response for this project.
]

== USDA NASS Crop Data Layer (1)

#align(horizon)[
  #set text(size: 15pt)
  - Raster image created by USDA National Agricultural Statistics Service #v(1em)
  - Is an annually produced raster image containing crop classifications for land at a 30x30 meter resolution across the entire country. #v(1em)
  - Full file is over 3GB in size, careful processing required.
]


== USDA NASS Crop Data Layer (2)

#align(center + horizon)[
#figure(
  image("../../../images/CDL_complete-2018_print_NASA.jpg"),
  caption: "Snapshot of the 2018 Crop Data Layer. Source (NASA)"
)
]

== USDA NASS Crop Data Layer (3)

#align(center + horizon)[
#figure(
  image("../../../images/cdl_2020_iowa_screenshot_databasin.png"),
  caption: "Snapshot of the 2010 Iowa Crop Data Layer. Source (databasin)"
)
]