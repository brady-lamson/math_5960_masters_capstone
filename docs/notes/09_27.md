# Notes

Have been forgetting to write these. Lots to update here. 

## New dataset

So I made a big mistake choosing the industry topic. It isn't a topic that is in the census, so there's no reasonable way for me to ascertain if the models estimates are actually better than the ACS. Heck, there's no way for me to ascertain how good the ACS estimates are as a baseline.

Due to this I made a pivot. I instead look at the 2020 decennial census and the 2020 5-year estimate ACS. The new topic is housing vacancy rates. This was a relatively light fix, and thew new models were fit with ease once the topic was decided on. This makes comparisons a lot more intuitive and will save me a ton of headache. 

## Possible new spatial covariate needed?

The crop data layer made sense for the industry based topic, but is a bit of a stretch for housing vacancy. Examining the two, there doesn't seem to be much of a relationship between them whatsoever. I'm considering alternatives to the CDL, depending on the availability of my own free time. 

One option is the Visible Infrared Imaging Radiometer Suite, otherwise known as [VIIRS](https://www.earthdata.nasa.gov/data/instruments/viirs). This lad operates alongside the NASA/NOAA joint polar satellite system platforms. Of interest is the night light data it collects. Perhaps housing vacancy may be related in part to the amount of lights in an area? I personally am not convinced, Iowa is largely just crop land. It will have very little land lit up in the state, so I don't think it'd be particularly informative. This would be a huge timesink too as this is spatio-temporal data. So I'd need multiple levels of aggregation to get it somewhere meaningful. 

Here's a set of topics from NASA on human dimensions: [EARTH DATA](https://www.earthdata.nasa.gov/topics/human-dimensions)

Of note above is the urbanization/urban sprawn dataset. Perhaps there is something there?

## Adjustment of models - LOGIT transformation

So I made an embarrassing mistake all the way up until today. My response is a proportion, bounded between 0 and 1. The FH model is an extension of a linear regression, with both sources of randomness coming from a normal distribution. Thus, the response falls along the entire real line. 

This makes the FH on its own inappropriate for modeling proportions. My solution: LOGIT transformation. It takes probabilities and maps them to the entire real line. This actually sorted out some weirdness in my data, improving effective sample sizes and making model performance comparisons make more sense. I saved a suite of helper functions to make these transformations convenient and re-fit all of my models. 

I'll be saving a paper that ran into the same thing in the sources sub-directory. 

## Closing thoughts

Overall, feeling good about where I'm at. The LOGIT transformation and census topic make things a lot more reasonable and I think with some effort I can be entirely done with the model examinations soon and can begin thinking of the final report. That'll likely involve many tables and plots, so I need to read other SAE papers to see what they decided to show. 