# Notes

My goal today is to try and fit a simple Fay-Herriot model to the ACS data I was able to download using tidycensus.

This is going to involve a few steps as, frankly, I still possess very little understanding of how this model actually works. My hope is that, through running the code, I can begin to tinker and understand the various articles about this online through my own data. 

## Writing and reading the ACS data

First order of business though is saving the actual dataset so I don't have to query the bureau every single time. This is kind of a pain due to the geometry of the dataset. Working with this stuff is kind of new to me. 

I hate to rely on AI overviews from my google searches here but my google-fu isn't getting me where I need to go. I'm trying this code at present.

```
path <- "data/2023_5_year_acs.csv"
sf::st_write(
    obj=acs_df, 
    dsn=path, 
    driver="CSV", 
    layer_options="GEOMETRY=AS_WKT", 
    delete_dsn=TRUE
)
```

The layer I believe corresponds to the spatial aspect of the data, the geometry column. It seems to be working, though it's converted all of my columns to the character type and has BOTH my original geometry column and the new "WKT" column.

Deleting the line about "layer options" I hoped would remove that redundancy but it is giving me mixed signals. It gives me this output when I save. 

> Writing layer `2023_5_year_acs' to data source `data/2023_5_year_acs.csv' using driver `CSV'
Writing 198 features with 6 fields and geometry type Multi Polygon.

And yet, on loading, the geomtry column is gone! Everything is still a character too. Perhaps it is how I'm reading it in?

It seems to be the reading and me being an idiot for trying to save this as a CSV. Writing it as a shape results in many additional files and a larger file size, though nothing unreasonable. Here is the final working code.

```
path <- "data/acs/2023_5_year_acs.shp"
sf::st_write(
    obj=acs_df, 
    dsn=path, 
    delete_dsn=TRUE
)


x <- sf::st_read(path)
```

## Fay-Herriot

Okay so I'm gonna keep these notes a little loose as it's late and my head hurts. However, I have successfully fit the simplest fay-herriot model to the acs data and have also demystified the model. 

To explain, I learned what was required for the Fay-Herriot by chasing errors until it worked. Here is the bare minimum code that worked. 

```
# fh wants a pure dataframe. For the simplest FH model we don't care about the spatial aspect anyway.
simple_df <- sf::st_drop_geometry(acs_df)

fh_simple <- emdi::fh(
    fixed = est ~ 1,
    vardir = "variance",
    combined_data=simple_df,
    correlation="no", # change to 'spatial' later perhaps
    maxit=100,  # default
    tol=0.0001 # default
)

fh_simple
```

This gave estimates different from the direct ones. Cool. So then the hard part, understanding what actually happened to generate those. Following some articles and a basic toy example given by ChatGPT, I was able to write code (myself) that showed what Fay-Herriot actually does. Here is my headache-ridden half-awake understanding.

It's like OLS regression but goes a bit further. To manually calculate this stuff you actually do go through the entire OLS process even! You just go further. Once you get the regression estimates the important part kicks in, the known county-specific variance! Recall that FH requires a known variance for each area, which is why I'm using the ACS survey data at all. FH is kinda like linear regression with an additional source of randomness, the domain (county) level random effects. We use the domain level variance to calculate a shrinkage factor, which essentially tells us which estimate (direct vs. regression) we should use. High variance domains will have a fay-herriot estimate closer to the regression, whereas smaller variance domains will stick more closely to the direct estimate from the survey! 

When we fit the simplest fh model to the ACS data, it's basically a more intelligent intercept only linear regression!

That's the general idea. From there we can start making things more complex by handling spatial autocorrelation (for the toy example we just assume all counties are uncorrelated) and adding in additional covariates! 