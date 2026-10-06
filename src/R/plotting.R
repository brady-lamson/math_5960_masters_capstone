# For helper functions specifically used for ranking models by metrics
library(dplyr)
library(ggplot2)
library(sf)

plot_rank1 <- function(rank_df, metric, palette) {
    rank1 <- rank_df %>% slice_min(rank, n=1)
    ggplot(rank1) +
        geom_sf(aes(fill=model_name)) +
        labs(
            title="Best performing model per county", 
            subtitle=paste("Metric:", metric),
            fill="Model"
        ) +
        scale_fill_manual(values = palette)  
}
