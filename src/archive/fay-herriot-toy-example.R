# Goal here is to explore manual calculation of a simplified fay herriot model. 
# It starts from a simple OLS calculation and extends from there.

# Source for my refresher on manual linear regression
# https://medium.com/@shashis890/linear-regression-by-hand-b2d0369adba7
library(glue)
library(emdi)

# Fay-Herriot relies on known variance. So we shove in 3 identical small variances and a high one
# To show how this model adjusts high variance direct estimates!

set.seed(101) # This seed gives a nice high delta on the third observation showcasing the FH behavior well
sds <- c(2, 2, 10, 2)
df <- data.frame(
    x = 1:4,
    y = 1:4 * 10 + rnorm(4, 0, sds),
    variance = sds^2
)

xbar <- mean(df$x)
ybar <- mean(df$y)
beta1_numerator <- sum((df$x - xbar) * (df$y-ybar))
beta1_denominator <- sum((df$x-xbar)^2)
beta1 <- beta1_numerator / beta1_denominator
beta0 <- ybar - (beta1*xbar)
glue("yhat = {round(beta0, 3)} + {round(beta1, 3)}x")
# Final formula is: yhat = 0 + 10x (when no error is introduced of course)

model <- lm(y ~ x, data=df) # gives the same output
summary(model)

df$yhat <- beta0 + beta1 * df$x
df$residuals <- df$y - df$yhat

# A represents the random effects. For the sake of a simple example, it is known and fixed
A <- 4
df$shrinkage <- A / (A + df$variance)

df$fh_est <- df$yhat + (df$shrinkage * (df$y - df$yhat))
df$delta <- df$y - df$fh_est

# Using emdi FH models ------

fh_simple <- emdi::fh(
    fixed = y ~ x,
    vardir = "variance",
    combined_data=df,
    correlation="no", # change to 'spatial' later perhaps
    maxit=100,  # default
    tol=0.0001 # default
)

print("ORDINARY LEAST SQUARES REGRESSION")
summary(model)

df

print("FAY-HERRIOT MODEL")
summary(fh_simple)

fh_simple$ind
