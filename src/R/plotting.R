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

basic_scatterplot <- function(
        columnA,
        columnB, 
        columnA_name, 
        columnB_name, 
        title=NULL,
        xlab=NULL,
        ylab=NULL,
        show_corr=TRUE,
        match_limits=FALSE, 
        abline=FALSE,
        color_by_abline=FALSE
    ) {
    # Basic scatterplot of two numeric columns, passed in directly as vectors
    # Also includes the correlation coefficient on the visual
    # No validation on this function due to a lack of time
    # Only pass in vectors of equal length, jeez
    
    if (is.null(xlab)) {
        xlab = columnA_name
    }
    
    if (is.null(ylab)) {
        ylab = columnB_name
    }
    
    if (is.null(title)) {
        title = paste("Scatterplot -", columnA_name, "vs.", columnB_name)
    }
    
    plot_data <- tibble(
        columnA = columnA,
        columnB = columnB
    ) %>% mutate(position = if_else(columnB > columnA, "Above", "Below or Equal"))
    
    fig <- ggplot(data=plot_data, aes(x=columnA, y=columnB)) +
        # geom_point() +
        labs(title=title) +
        xlab(xlab) +
        ylab(ylab) +
        theme_classic()
    
    if (color_by_abline == TRUE) {
        fig <- fig + 
            geom_point(aes(color=position)) +
            theme(legend.position="none")
    } else {
        fig <- fig + geom_point()
    }
    
    if (show_corr == TRUE) {
        cor_coeff <- cor(columnA, columnB)
        message <- paste0("italic(r) == ", round(cor_coeff, 3))
        fig <- fig + annotate("text", x=Inf, y=Inf, hjust=1, vjust=1, label=message, parse=TRUE)
    }
    
    if (abline == TRUE) {
        fig <- fig + geom_abline(lty=3)
    }
    
    if (match_limits == TRUE) {
        max_val <- max(columnA, columnB, na.rm=TRUE)
        min_val <- min(columnA, columnB, na.rm=TRUE)
        
        fig <- fig +
            xlim(min_val, max_val) +
            ylim(min_val, max_val)
    }
    
    return(fig)
}

# Direct estimate vs. se
# Direct estimate vs. relative se
# corc <- cor(acs_df$est_prop, acs_df$sd_prop)
# message <- paste0("italic(r) == ", round(corc, 3))
# limits <- c(0, max(acs_df$relative_sd_all, acs_df$relative_sd_vacant) + 0.05)
# 
# fig <- ggplot(acs_df, aes(x=relative_sd_all, y=relative_sd_vacant)) +
#     geom_point() +
#     geom_abline(lty=3) +
#     labs(title="Relative Standard Errors - Total Housing vs. Vacant Housing") +
#     xlab("Total Housing SE / Total Housing Units") +
#     ylab("Vacant Housing SE / Vacant Housing Units") +
#     xlim(limits) +
#     ylim(limits) +
#     annotate("text", x=0.2, y=0.3, label=message, parse=TRUE) +
#     theme_classic()
# 
# fig