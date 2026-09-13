# Notes

Forgot to write my notes yesterday or the day before. This project has been progressing nicely. I'll keep this brief overall. 

For starters, Dr. French gave me advice on Friday, September 11th, to use the `brms` package instead of stan for my modeling. This turned out to be life saving advice as I got all of my initial bayesian models fit by the end of saturday. Very easy to use, handy api, good plots. It's great! 

I've decided I'll be fitting 5 distinct models for this project.

1. Frequentist intercept only
2. Bayesian intercept only
3. Bayesian ICAR
4. Bayesian with spatial covariate
5. Full Bayesian model

Not all of these will end up in the final report, but this way I'll have a solid understanding of all of the components and how they influence the results. I currently have 3/5 done, though the most basic model may be revisited. I currently use the `emdi` package which is fantastic, but I'm tempted to learn to calcuate the random effects myself and get equivalent results using entirely base R. 

Both models 2 and 3 are done. Not evaluated really mind you, but done. As for 4 and 5, I worked today to collect the spatial covariate information I needed. Based on a suggestion from ChatGPT, I checked out the `terra` package. I was hesitant to pivot from `Raster`, which this would replace, but it turned out to be a fantastic decision. A lot of my previous headaches, such as losing the inherent raster data dictionary, were solved by this change. 

I was able to wrestle with my own lack of understanding to generate my covariate dataframe, which consists of the following information. Note, not exact columns, cause I want this readable.

- GeoID
- County Name
- Percent Corn
- Percent Soy
- Percent Either Corn or Soy

I examined the other crops and am glad I did. It contains categorizations for forests and even water coverage. Corn and Soybeans are, by a significant margin, the most prevelant in Iowa so I am further emboldened in my decisions to only use those.

I include both corn and soy individually here, though will be using the combination for modeling. They both together make up the same information, which is land covered by key crops, so keeping them separate will likely just make my life more irritating down the line. 

I saved this information as both a csv and a shape file, to make both modeling and later plot generation easier. 

This was a hugely productive weekend, and it's very possible if I keep on pace that I can finish this project well before the semester even ends! We'll see what happens.