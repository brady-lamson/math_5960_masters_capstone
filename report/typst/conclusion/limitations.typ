== Limitations

This project involves multiple components and was tackled over a single semester. As such, it contains many limitations that constrain the strength of any conclusions that may be reached. 

=== Spatial Covariate

The spatial covariate selected for this project is the most glaring limitation of this project. It was intended to be a showcase of the potential utility of auxiliary covariates, one of the main features of the Fay-Herriot model. However, due to circumstances outside of the project itself, the spatial covariate chosen has a largely inconsequential relationship with the response. As such, it does a poor job of performing its role and the models with it are roughly equivalent to those without it. The cause of this was a change of topic.

The original response for this project was the proportion of workers in the agricultural industry per county, which aligned a lot more with the crop land coverage covariate. This was information only present in the ACS however and is not a topic covered by the decennial census, so there was no way to use it as a source of true values. This was a breaking oversight. 

The topic was scrapped partway through the semester because of this, resulting in the housing vacancy rates explored in this report. Finding a more appropriate spatial dataset for this response was considered, though it was decided to be too time consuming for the point of the semester this occurred in. Dropping the convariate entirely was considered, but enough work was done with it to warrant its inclusion as a demonstration of potential methodologies. 

It is worth noting that the crop data layer contains a ton of information, and it is possible that more sophisticated processing of its data could result in an informative covariate for housing vacancy rates. This project is also limited to Iowa at the county level in 2020, so these results do not rule out the possibility of a relationship in other areas or at other spatial/temporal scales. 

=== Decennial Census as source of truth

The census is a human process and does not provide perfect numbers. The 2020 census in particular is a challenging dataset due to its overlapping occurrence with COVID-19. As briefly discussed, the U.S. Government Accountability Office documented multiple accuracy issues with the 2020 census. This was due in part to multiple challenges the Bureau was faced with, such as "late census design changes, staffing issues, and budgetary uncertainty" @censusUncertainty. Iowa was not a part of the list of 14 states identified with significant population count errors, nor were their findings related to the housing data collected. However, that does not mean the housing data used in this report is free from error. This applies to every decennial census as well. None of the values provided are free from error or bias. 

Using the decennial census as the source of truth for model performance also imposes limitations on the type of analysis that can be performed. As it is only performed every 10 years, comparisons made to non-census years become less reliable. This raises concerns in this project about how well these results generalize to years outside of 2020. It is extremely possible that the best model for 2020 would differ from one in 2027 for example, and this methodology provides no way to identify that drift. The Census Bureau does provide guidelines for this however, with their Population Estimates Program (PEP) that provides official estimtates for between-census years @compareACSandCensus.

=== Neighbor matrix encoding

When addressing spatial autocorrelation there are multiple ways of encoding neighbor relationships. Only one was explored in this project, a binary neighbor encoding. That is, if a county is adjacent to another neighbor the corresponding value in its matrix is set to 1. It is possible that other encoding methods, such as a row normalized matrix, would perform in a meaningfully different way. This was not explored due to the quantity of models already being compared. This limits the conclusions that can be drawn from the ICAR component.

=== Use of abstracted modeling packages

Many sophisticated packages were used to aid in the completion of this project. These packages, such as `brms`, `emdi` and `terra`, greatly expedite the data wrangling and modeling process. However, they also abstract out the methods and mathematics that provide the results. Conclusions were drawn under the assumption that these packages were behaving as expected, and that they were applied correctly by the user. In particular, the package `brms` functions as a wrapper for `Stan` and generates its own stan code it executes. It is possible that a manual stan implementation of the Fay-Herriot model would provide different results. That is not to say that the use of these packages was a mistake, simply that a lower level control over the results was relinquished for the sake of efficiency and that it is worth warranting. 