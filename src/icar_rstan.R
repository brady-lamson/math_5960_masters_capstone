library(dplyr)
library(sf)
library(spdep)
library(rstan)

acs_df <- sf::st_read("data/acs/2023_5_year_acs_proportion_response.shp")
head(acs_df)

neighbor_list <- spdep::poly2nb(acs_df, queen=TRUE)
coords <- st_coordinates(st_centroid(st_geometry(acs_df)))


# intercept only for practice -------
stanmod = "
data {
  int<lower=0> N;
  vector[N] y;
}
parameters {
  real alpha;
  real<lower=0> sigma;
}
model {
  y ~ normal(alpha, sigma);
}
"

y <- acs_df$est_prop
stan_dat <- list(N=length(y), y=y)

# if compiled model doesn't already exist,
# compile the model, sample from model,
# returns object of class stan
# save model
file_name <- "linreg.rda"
if (!file.exists(file_name)) {
    # compile and sample from model
    samples = stan(model_code = stanmod,
                    data = stan_dat,
                    iter = 100000,
                    chains = 5)
    # alternatively, describe model
    model = stan_model(model_code = stanmod)
    save(model,
         file = file_name,
         compress = "xz")
} else {
        load(file = file_name)
    # draw samples from the model
    samples = sampling(
        model, 
        data = stan_dat, 
        iter = 100000, 
        chains = 5
    )
}

samples

lm(y ~ 1)

# Basic FH model ---
# Verified this works, need to generate values for shrinkage and fitted values maybe? 
stanmod = "
data {
    int<lower=0> N;
    vector[N] y;
    vector<lower=0>[N] D;
}
parameters {
    real alpha;
    real<lower=0> A;
    vector[N] u;
}
model {
    u ~ normal(0, sqrt(A));
    y ~ normal(alpha + u, sqrt(D));
}
"

stan_dat <- list(N=length(y), y=y, D=acs_df$var)

file_name <- "int_fh.rda"
if (!file.exists(file_name)) {
    print("File not found")
    # compile and sample from model
    samples = stan(model_code = stanmod,
                   data = stan_dat,
                   iter = 100000,
                   chains = 5)
    # alternatively, describe model
    model = stan_model(model_code = stanmod)
    save(model,
         file = file_name,
         compress = "xz")
} else {
    print("File found")
    load(file = file_name)
    # draw samples from the model
    samples = sampling(
        model, 
        data = stan_dat, 
        iter = 100000, 
        chains = 5
    )
}

print(samples, digits=5)
