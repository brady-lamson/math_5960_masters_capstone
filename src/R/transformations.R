logit <- function(p) {
    if (any(p <= 0 | p >= 1)) {
        stop("All values of <p> must fall strictly between 0 and 1.")
    }
    
    log(p / (1 - p))
}

logit_sd <- function(p, sd) {
    if (any(p <= 0 | p >= 1)) {
        stop("All values of <p> must fall strictly between 0 and 1.")
    }
    
    if (any(sd < 0)) {
        stop("Standard deviation must be non-negative.")
    }
    
    sd / (p * (1 - p))
}

inv_logit <- function(x) {
    1 / (1 + exp(-x))
}