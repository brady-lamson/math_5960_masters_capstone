# Notes

Okay, back with more work here. I confirmed my understanding of the basic FH model with Aaron. So I'm on the right track. With this newfound understanding I now take another look at the ACS data and the fay-herriot model output. First, the data itself. I found that the magnitude of the standard deviation grew with the size of the estimates, but proportional uncertainty fell. This makes sense, larger counties have more data and more precise estimates. The entire purpose of this model is to help with the high variability of smaller counties. So it's nice to see that the data follows our given use case. 

As well, I was also curious about the package I was using for modeling. `emdi` seemed good, but I saw an alternative, `msae`. The latter is primarily for multivariate fay-herriot modeling and has an api that is actively hostile to univariate work. It has functions that support it but you can tell it wasn't built for that use case. This project is entirely univariate so I will not be using it. I only even tinkered with it because `emdi` returns kind of awkward objects, and I realized it'd be mildly annoying to join it's predictions back to my original dataset. 

## Examining model output

Okay so I missed an obvious argument to make the join easier. Now we can examine this properly. 

Let me list off the key parts of the model. 

$\text{formula}: \text{Direct estimate} \sim 1$

No covariates, intecept only. 

Variance of random effects: $A = 78583.81$ 

|Coefficient|Value|std. error|t.value|p.value|
|---|---|---|---|---|
|Intercept|580.154|29.245|19.838|2.2e-16|

This intercept is roughly between the median and mean of the direct estimates which are 550 and 610 respectively. This value is the fitted value given to every county. This is *not* the fay herriot estimate yet. 

### Lowest 3 direct estimates

| name      | est |       fh |       sd |     delta |
| --------- | --: | -------: | -------: | --------: |
| Jefferson | 101 | 106.9392 | 31.00304 | -5.939221 |
| Monroe    | 125 | 134.0939 | 39.51368 | -9.093915 |
| Mills     | 173 | 179.2847 | 34.65046 | -6.284682 |

### Highest 3 direct estimates

| name  |  est |       fh |       sd |     delta |
| ----- | ---: | -------: | -------: | --------: |
| Linn  | 1531 | 1220.499 | 192.7052 |  310.5015 |
| Sioux | 1743 | 1360.046 | 193.9210 |  382.9544 |
| Polk  | 2869 | 1628.958 | 300.9119 | 1240.0416 |

### Explanation

What we see here is the larger the direct estimates get, the more extreme the adjustment for the fay herriot estimate is. This is counter to what we want, where we want the larger counties to be information we use for the smaller counties. So what's gone wrong?

It's an intercept only model. The fitted value is 580 for every single county. If the shrinkage value is anything but 1 it's going to drag larger counties down fast. The regression is obviously a terrible fit, so the fay herriot doesn't have much to work with. 

The model assumes all counties should have around 580 people in agriculture and then adjusts using the sub-domain variance. Larger counties have a larger magnitude of variance, causing shrinkage values pulling their values down. Let's calculate the most extreme, Polk County.

Recall that the shrinkage factor, $\gamma = \frac{A}{A + D_i}$ where $A$ is the overall random effects and $D_i$ is the variance of a given domain. I noted the value of $A$ earlier so we can calculate it.

$\gamma = \frac{76583.81}{76583.81 + 300^2} \approx 0.45$.

The gamma values can also be directly pulled from the model object and it matches this. The fh estimates are given by:

$y_i^{\text{FH}} = \hat{y_i} + \gamma_i(y_i - \hat{y_i})$ 

Plugging in our values gives us:

$y_i^{\text{FH}} \approx 580.14 + 0.45(2869 - 580.14) = 1610.127$.

I did some approximating so it isn't exactly the fh estimate but this is how it works. 

The shrinkage value is weighted towards the fitted value, and the fitted value is just the intercept so it's a terrible fit. 

Thus, the poor model behavior! 

The spatial autocorrelation and spatial covariate will *not* fix this, as I need a way to control for population size. Two things come to mind.

1. Just make the estimate a proportion instead. I can use the total industry count per county in the ACS data I already have. And the census has guides on how to combine MOEs. 
2. Use the census population for each county. This isn't an estimate so can be treated as a fixed value.