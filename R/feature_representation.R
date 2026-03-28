#' Calculate feature representation within an area
#'
#' This function calculates the representation of each feature across raster cells,
#' and can optionally summarize results within a specified area.
#'
#' @param feature_layers A `terra::SpatRaster` with one or more layers
#'   representing feature distributions (e.g., species distributions, habitat
#'   suitability).
#' @param area_mask Optional. A `terra::SpatRaster` or `terra::SpatVector`
#'   defining the analysis area. If a raster is provided, it should follow the Zonation
#'   analysis area mask convention, where cells with value 1 represent the area
#'   of interest and cells with value 0 or `NA` are excluded. If a `SpatVector`
#'   is provided, it will be rasterized to match the resolution and extent of
#'   `feature_layers`.
#'
#' @return A list with two elements:
#' \describe{
#'   \item{representation_layers}{
#'     A `terra::SpatRaster` where each layer contains the fractional
#'     representation of the corresponding feature across the landscape.
#'     Each cell value represents the proportion of the global total
#'     representation of that feature occurring in that cell.
#'   }
#'   \item{representation_in_area}{
#'     A named numeric vector containing the representation
#'     of each feature within the specified `area_mask`. If no area is provided,
#'     this element returns `NULL`.
#'   }
#' }
#'
#'
#' @examples
#' r <- terra::rast(nrows = 10, ncols = 10)
#' f1 <- terra::setValues(r, runif(terra::ncell(r)))
#' f2 <- terra::setValues(r, runif(terra::ncell(r)))
#' features <- c(f1, f2)
#' names(features) <- c("feature_1", "feature_2")
#'
#' mask <- r
#' terra::values(mask) <- sample(c(0,1), terra::ncell(mask), replace = TRUE)
#'
#' result <- feature_representation(features, mask)
#' result$representation_in_area
#'
#' @import terra
#' @family postprocessing
#' @export
feature_representation <- function(feature_layers, area_mask = NULL) {

  # Step 1: Calculate fractional representation for each feature
  frac_list <- lapply(1:terra::nlyr(feature_layers), function(i) {
    feat <- feature_layers[[i]]
    total <- terra::global(feat, "sum", na.rm = TRUE)[1,1]
    feat_frac <- feat / total
    feat_frac
  })

  # Combine fractional layers into a SpatRaster
  representation_layers <- terra::rast(frac_list)
  names(representation_layers) <- names(feature_layers)

  # Step 2 (optional): calculate representation within provided area
  representation_in_area <- NULL

  if (!is.null(area_mask)) {

    # Convert polygon to raster if needed
    if (inherits(area_mask, "SpatVector")) {
      area_mask <- terra::rasterize(area_mask, representation_layers[[1]], field = 1)
    }

    # Mask outside area
    area_mask[area_mask == 0] <- NA

    # Calculate representation per feature inside the area
    n_features <- terra::nlyr(representation_layers)
    representation_in_area <- numeric(n_features)

    for (i in 1:n_features) {
      representation_in_area[i] <- terra::global(
        representation_layers[[i]] * area_mask,
        "sum",
        na.rm = TRUE
      )[1,1]
    }

    names(representation_in_area) <- names(representation_layers)
  }

  # Return outputs
  return(list(
    representation_layers = representation_layers,
    representation_in_area = representation_in_area
  ))
}

