=== NASS Crop Data Layer

To help motivate many of the decisions made in @census_processing, analysis will begin with the crop data layer itself. Examining @crop_percentages shows that the makeup of land in Iowa is very different from that of the USA as a whole. Corn and Soybeans make up $38%$ and $27%$ of the states land coverage respectively. Adding those up, approximately $65%$ of Iowas land coverage is corn or soybeans. Neither of these even reach $5%$ of the land coverage in the USA overall. The plots shown in @cdl_spatial_distributions visualize the similar spatial distributions and land coverage of corn and soybeans across the state. Their similarities and high prevelance, alongside their importance to Iowas overall agriculture gave the motivation for using them as a proxy for agricultural coverage per county. 

#include "../../tables/cdl_percentages.typ"

#figure(
  grid(
    columns: 2,
    [#image("../../../../images/corn_spatial_distribution.png")],
    [#image("../../../../images/soy_spatial_distribution.png")],

  ),
  caption: "Plots showcasing the aggregated spatial distribution of corn and soybeans. Aggregation performed on each crop separately taking the mean of every 25x25 pixel area."
) <cdl_spatial_distributions>

Amongst the various CDL classifications, there are ones that are referred to as "double crops". These are classifications with two different crops in them. There are 6 of these classifications total, examples including values like corn/soybeans and soybeans/oats. These were considered for inclusion in the covariate, though upon further inspection they were far too infrequent to justify. All 6 values total up to only around $4,000$ pixels total across all of Iowa. The max percentage for a double crop in a county was $0.042%$. As such, these were ignored in all later work. 

The top crops were examined for all counties to check for any other crops worth consideration. The top 3 crops for all 99 counties simplify down to only 6 cdl classifications. Those being corn, soybeans, developed/low intensity, developed/open space, grassland/pasture and deciduous forest. Nothing here appeared to be worth consideration for inclusion, so the decision was made to stick exclusively to corn and soybeans. 

Narrowing down to the key crops at the county level, the overview in @cdl_county_summary shows that even the minimums show a large percentage of land coverage for the two key crops. At the most extreme almost $90%$ of land is classified as either corn or soybeans. 

#include "../../tables/cdl_covariate_summary.typ"

Visualizing this information in @cdl_county_map shows some indication of spatial autocorrelation of land coverage. Many of the highest coverage counties are grouped together near the north west part of the state, and the lowest coverage counties are grouped in the south.

#figure(
  image("../../../../images/corn_soy_land_coverage.png", width: 75%),
  caption: "Plot of land coverage per county."
) <cdl_county_map>

The plot in @response_vs_covariate showcases a big problem with this choice of covariate. It appears to to show a minor negative relationship with vacancy rates, though it's not a convincing trend. The points on the plot appear very randomly scattered, with no obvious trend to point to. This plot begs the question of why this is even a covariate for the model. This is something that will be explained in more detail in the limitations section, however to keep it brief this is the result of a change in topic partway through the project. The previous response had a far stronger relationship with the crop data layer. Due to the extensive amount of work done on this dataset, it is kept in this report primarily as a showcase of methodology. 

#figure(
  image("../../../../response_vs_covariate.png", width: 75%),
  caption: "Scatterplot showing the a mild negative relationship between vacancy rates and corn/soy land coverage."
) <response_vs_covariate>