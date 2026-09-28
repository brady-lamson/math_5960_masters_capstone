# Justifying use of delta method on logit transformation
iters <- 300
mus <- numeric(iters)
sds <- numeric(iters)

for (i in iters) {
    size <- 100
    n <- 10000
    p <- 0.05
    data <- rbinom(n, size, p) / size
    delta <- sqrt(n) * (data - p)
    mus[i] <- mean(delta)
    sds[i] <- sd(delta)
}

mean(mus)
mean(sds)

# Trying it on the acs data
library(dplyr)
library(sf)

acs_df <- sf::st_read("data/acs/housing/2020_5_year_acs_proportion_response.shp")
acs_df["est_logit"] = log(acs_df$est_prop / (1-acs_df$est_prop))
acs_df["sd_logit"] = acs_df$sd_prop / (acs_df$est_prop * (1 - acs_df$est_prop))
inverse_logit = 1 / (1 + exp(-acs_df$est_logit))
inverse_logit2 = plogis(acs_df$est_logit) # Should be equivalent? 

signif(acs_df$est_prop, 6) == signif(inverse_logit, 6) # Sick

# Note that for the SD, I'll need to take the SD of the posterior draws AFTER they've been 
# re-transformed through the inverse logit 

