library(dplyr)
library(terra)
library(tigris)

cdl_frequency <- function(cdl) {
    pixels <- terra::size(cdl)
    frequencies <- terra::freq(cdl)
    frequencies_df <- frequencies[c("value", "count")] %>%
        dplyr::tibble() %>%
        dplyr::mutate(percentage = count / pixels * 100) %>%
        dplyr::arrange(dplyr::desc(percentage))
    
    return(frequencies_df)
}
