# Small Area Estimation with the Fay-Herriot Model

## Abstract

The Fay-Herriot (FH) model has been in use since 1979 to improve the reliability of small area estimates (SAE). It balances direct survey estimates with predictions of small area means based on a linear regression model. The FH model traditionally assumes independence of area level random effects, which is an assumption that may be violated in cases where the response shows evidence of spatial autocorrelation. This project uses a hierarchical Bayesian framework, an intrinsic autoregressive (ICAR) model for the spatial random effects, and auxiliary information taken from remote sensing data in the NASS Crop Data Layer to adjust estimates of housing vacancy rates at the county level in the state of Iowa. Estimates were evaluated against housing vacancy rates from the decennial census. Results demonstrate a reduction in mean squared error (MSE) and improvements to estimate precision through the use of spatial random effects, though the additional remote sensing covariate provided limited improvement. 

## Tech Stack

This project utilizes `renv` to facilitate a reproducible project environment. For information on renv, click [here](https://rstudio.github.io/renv/articles/renv.html). 

Below are a few of the key packages used for this project. 

|Package|Use|
|---|---|
|`dplyr`|General data processing with tibble dataframes|
|`terra`| For processing raster images|
|`sf`| For processing spatial vector data|
|`tidycensus`|For accessing data from the Census Bureau API|
|`tigris`|For accessing TIGER shapefiles from the Census Bureau API|
|`emdi`|Fitting frequentist FH models|
|`brms`|Framework for Bayesian modeling|
|`ggplot2`|Data visualization|

## Report Template

The report for this project was done in typst using a slightly modified version of the template `grape-suite` version 4.0.0. Modifications were made to the `seminar-paper` class to include functionality for an abstract. 

- [Template Link](https://typst.app/universe/package/grape-suite/)

