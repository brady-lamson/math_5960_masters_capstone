# Notes

Setting up the adjacency matrix today and reviewing some general spatial stats stuff.

## Moran's I test for spatial autocorrelation

Useful source for refreshing on test interpretation: https://doc.esri.com/en/arcgis-pro/latest/tool-reference/spatial-statistics/h-how-spatial-autocorrelation-moran-s-i-spatial-st.html

Below I've got the results of a morans I test for the estimated proportion of agricultural workers per county. 

	Moran I test under normality

data:  acs_df$est_prop  
weights: neighbor_listw    

Moran I statistic standard deviate = 3.3651, p-value = 0.0003825
alternative hypothesis: greater
sample estimates:
Moran I statistic       Expectation          Variance 
      0.179334913      -0.010204082       0.003172445 
     
The Moran's I test indicated significant (p < 0.05) positive global spatial autocorrelation in the estimated proportion of agricultural workers across Iowa counties. Thus, the null hypothesis of spatial randomness was rejected, providing evidence that counties with similar proportions tend to cluster spatially. 

## Spatial autocorrelation

Okay this part hurt my poor brain. I have a lot of thoughts here but I think I have a direction now. For the ICAR thing, that functions as the prior for the spatial random effects. This isn't something I fit separately and plug in. I likely want to create the fay herriot model in stan itself where I can properly define priors and handle the MCMC work. 

Okay final note. I was able to, with some heavy leaning on chatgpt, get the FH model with equivalent output in Stan. I'll need to review the model code. It's simple but I really need to verify I understand all of the bits. From here, we can slowly start ramping up the complexity and implementing the other features. 