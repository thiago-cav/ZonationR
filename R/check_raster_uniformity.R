#' Check raster uniformity
#'
#' Verifies that all raster files in a folder are compatible with Zonation.
#' Compatibility requires that all rasters have:
#' - identical resolution (cell size)
#' - identical extent (number of rows and columns)
#' - identical projection (CRS)
#'
#' Supported raster formats: `.tif`, `.tiff`, `.img`, `.asc`.
#'
#' @param spp_file_dir Character. Path to the folder containing raster files.
#' @return Prints a message confirming uniformity. Stops with an error
#'   otherwise.
#'
#' @examples
#' \dontrun{
#' check_raster_uniformity("path/to/rasters")
#' }
#' @family preflight
#'
#' @export
check_raster_uniformity <- function(spp_file_dir) {

  # Hardcoded values (aligned with feature_list())
  recursive <- FALSE
  spp_file_pattern <- ".+\\.(tif|tiff|img|asc)$"

  # List raster files
  raster_files <- list.files(path = spp_file_dir,
                             pattern = spp_file_pattern,
                             full.names = TRUE,
                             recursive = recursive)

  if (length(raster_files) < 2) {
    stop("At least two raster files (.tif, .tiff, .img, or .asc) are required in the '",
         spp_file_dir, "' folder.",
         call. = FALSE)
  }

  rasters <- lapply(raster_files, terra::rast)
  ref <- rasters[[1]]

  ref_res  <- terra::res(ref)
  ref_ext  <- terra::ext(ref)
  ref_nrow <- terra::nrow(ref)
  ref_ncol <- terra::ncol(ref)
  ref_crs  <- terra::crs(ref)

  problems <- list()

  for (i in seq_along(rasters)) {

    r <- rasters[[i]]
    fname <- basename(raster_files[i])

    if (!isTRUE(all.equal(terra::res(r), ref_res))) {
      problems[[fname]] <- c(problems[[fname]], "resolution")
    }

    if (!isTRUE(all.equal(terra::ext(r), ref_ext))) {
      problems[[fname]] <- c(problems[[fname]], "extent")
    }

    if (terra::nrow(r) != ref_nrow || terra::ncol(r) != ref_ncol) {
      problems[[fname]] <- c(problems[[fname]], "dimensions (rows/cols)")
    }

    if (terra::crs(r) != ref_crs) {
      problems[[fname]] <- c(problems[[fname]], "projection (CRS)")
    }
  }

  if (length(problems) > 0) {

    msg <- paste0(
      "Raster mismatch detected.\n",
      "All input rasters must share identical resolution, extent, dimensions, and projection.\n\n",
      paste(
        names(problems),
        "->",
        sapply(problems, paste, collapse = ", "),
        collapse = "\n"
      )
    )

    stop(msg, call. = FALSE)
  }

  message("All raster files in '", spp_file_dir,
          "' are spatially uniform and compatible with Zonation.")

  invisible(TRUE)
}
