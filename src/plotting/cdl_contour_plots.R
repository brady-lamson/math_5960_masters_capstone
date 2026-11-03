library(terra)
library(tidyterra)
library(ggplot2)
library(sf)

path = "data/cdl/2020_30m_cdl_iowa_terra.tif"
cdl <- terra::rast(path)
cdl_covariate <- sf::read_sf("data/cdl/cdl_covariates_with_geometry/cdl_covariates.shp")

corn <- terra::ifel(
    is.na(cdl), NA,
    terra::ifel(cdl == "Corn", 1, 0)
)

soy <- terra::ifel(
    is.na(cdl), NA,
    terra::ifel(cdl == "Soybeans", 1, 0)
)

corn_soy <- terra::ifel(
    is.na(cdl), NA,
    terra::ifel(cdl %in% c("Corn", "Soybeans"), 1, 0)
)

ggplot() +
    geom_spatraster(data = corn_soy) +
    scale_fill_viridis_c() +
    coord_sf() +
    theme_minimal()

corn_soy_agg <- terra::aggregate(
    corn_soy,
    fact = 25,
    fun = mean,
    na.rm = TRUE
)

corn_agg <- terra::aggregate(corn, fact = 25, fun = mean, na.rm = TRUE)
soy_agg <- terra::aggregate(soy, fact = 25, fun = mean, na.rm = TRUE)

ggplot() +
    geom_spatraster(data = corn_soy_agg) +
    scale_fill_viridis_c(
        name = "Proportion",
        limits = c(0, 1),
        na.value = "transparent"
    ) +
    geom_sf(
        data = cdl_covariate,
        fill = NA,
        color = "black",
        linewidth = 0.2
    ) +
    coord_sf() +
    theme_minimal()


# crop_agg <- c(corn_agg, soy_agg)
# names(crop_agg) <- c("Corn", "Soybeans")
# fig <- ggplot() +
#     geom_spatraster(data = crop_agg) +
#     scale_fill_viridis_c(
#         name = "Proportion",
#         limits = c(0, 1),
#         na.value = "transparent"
#     ) +
#     geom_sf(
#         data = cdl_covariate,
#         fill = NA,
#         color = "black",
#         linewidth = 0.2
#     ) +
#     facet_wrap(~lyr) +
#     coord_sf() +
#     ggtitle("Spatial distributions of Corn and Soybeans") +
#     theme_minimal()
# fig
# 
# ggsave(fig, filename="images/crop_distribution_faceted.png")

plot_crop <- function(raster, title) {
    ggplot() +
        geom_spatraster(data = raster) +
        scale_fill_viridis_c(
            name = "Proportion",
            limits = c(0, 1),
            na.value = "transparent"
        ) +
        geom_sf(
            data = cdl_covariate,
            fill = NA,
            color = "black",
            linewidth = 0.2
        ) +
        labs(title = title) +
        coord_sf() +
        theme_minimal()
}

p_corn <- plot_crop(corn_agg, "Corn")
p_soy <- plot_crop(soy_agg, "Soybeans")

ggsave(p_corn, filename="images/corn_spatial_distribution.png")
ggsave(p_soy, filename="images/soy_spatial_distribution.png")

fig <- ggplot() +
    geom_spatraster_contour(
        data = corn_agg,
        aes(z = Class_Names, color = "Corn"),
        breaks = c(0.2, 0.4, 0.6, 0.8)
    ) +
    geom_spatraster_contour(
        data = soy_agg,
        aes(z = Class_Names, color = "Soybeans"),
        breaks = c(0.2, 0.4, 0.6, 0.8)
    ) +
    geom_sf(
        data = cdl_covariate,
        fill = NA,
        color = "black",
        linewidth = 0.2
    ) +
    scale_color_manual(
        values = c("Corn" = "goldenrod2", "Soybeans" = "forestgreen")
    ) +
    labs(color = "Crop") +
    coord_sf() +
    ggtitle("Spatial Distribution of Corn and Soybeans") +
    theme_minimal()

fig

ggsave(fig, filename="images/crop_contours.png")
    