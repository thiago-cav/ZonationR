#' Create a feature list from raster files
#'
#' This function generates a feature list from raster files in a specified
#' directory, adding optional attributes to the list based on user-defined
#' parameters. The resulting feature list is written to a text file. Supported
#' raster formats include GeoTIFF (.tif, .tiff), ERDAS Imagine (.img), and ASCII
#' Grid (.asc).
#'
#'
#' @param spp_file_dir A character string specifying the directory containing
#'   the raster files.
#' @param weight An optional numeric vector (`float`) to assign weights to the
#'   features in the list.
#' @param group An optional integer vector (`int`) representing the output group
#'   number for each raster.
#' @param threshold An optional numeric vector (`float`) representing threshold
#'   values for each raster. If thresholding is applied, values in the input
#'   raster below the threshold are set to zero. Layers that contain only zeros
#'   after thresholding are removed from the analysis.
#'
#' @returns A text file containing a feature list of rasters along with any
#'   additional attributes specified by the user.
#'
#' @seealso
#' [settings_file()], [command_file()]
#'
#' @importFrom utils write.table
#'
#' @export
#'
#' @examples
#' \dontrun{
#' feature_list(spp_file_dir = "path/to/raster/files")
#' }
feature_list <- function(spp_file_dir,
                         weight = NULL,
                         group = NULL,
                         threshold = NULL) {

  # Hardcoded values
  filename <- "feature_list.txt"
  recursive <- FALSE
  spp_file_pattern <- ".+\\.(tif|tiff|img|asc)$"

  # List rasters in the target directory
  target_rasters <- list.files(path = spp_file_dir,
                               pattern = spp_file_pattern,
                               full.names = TRUE,
                               recursive = recursive)

  if (length(target_rasters) == 0) {
    stop("No raster files (.tif, .tiff, .img, or .asc) were found in the '", spp_file_dir, "' folder.")
  }

  # Create the feature list dataframe, starting with filenames
  feature_list <- data.frame(filename = target_rasters)

  # Add non-null parameters to the dataframe
  if (!is.null(weight)) feature_list$weight <- weight
  if (!is.null(group)) feature_list$group <- group
  if (!is.null(threshold)) feature_list$threshold <- threshold

  # Ensure column headers are in quotes
  colnames(feature_list) <- paste0('"', colnames(feature_list), '"')

  # Write the feature list
  write.table(feature_list, file = filename, row.names = FALSE, quote = FALSE, col.names = TRUE)

  message("Feature list ", filename, " has been created.")
}
