library(dplyr)
library(terra)
library(tigris)

cdl_frequency <- function(cdl) {
    
    frequencies <- terra::freq(cdl)
    frequencies_df <- frequencies[c("value", "count")] %>%
        dplyr::tibble() %>%
        dplyr::filter(value != "Background") %>%
        select("value", "count") %>%
        dplyr::mutate(
            percentage = count / sum(count) * 100,
            total_pixels = sum(count)
        ) %>%
        rename(
            crop = value,
            frequency = count
        ) %>%
        dplyr::arrange(dplyr::desc(percentage))
    
    return(frequencies_df)
}