library(dplyr)
library(terra)
library(tigris)

cdl_frequency <- function(cdl) {
    
    frequencies <- terra::freq(cdl)
    frequencies_df <- frequencies[c("value", "count")] %>%
        dplyr::filter(value != "Background") %>%
        dplyr::tibble() %>%
        dplyr::mutate(percentage = count / sum(count) * 100) %>%
        dplyr::arrange(dplyr::desc(percentage))
    
    return(frequencies_df)
}
