#' Create a settings file for a Zonation Analysis
#'
#' This function generates a settings file with various parameters related to
#' the input data and analysis configuration. The resulting settings file is
#' saved with a `.z5` extension and can be used directly in the Zonation
#' software.
#'
#' @param feature_list_file A character string specifying the feature list file.
#'   This is a compulsory parameter.
#' @param external_solution_file A character string specifying the full path
#'   and/or name of the external solution file.
#' @param analysis_area_mask_layer A character string specifying the full path
#'   and/or name of the analysis area mask layer file.
#' @param hierarchic_mask_layer A character string specifying the full path
#'   and/or name of the hierarchic mask layer file.
#' @param cost_layer A character string specifying the full path and/or name of
#'   the cost layer file.
#'
#' @returns A `.z5` file containing the specified settings.
#'
#' @seealso
#' [feature_list()], [command_file()]
#'
#' @export
#'
#' @examples
#' \dontrun{
#' settings_file(feature_list_file = "feature_list.txt")
#' }
settings_file <- function(feature_list_file,
                          external_solution_file = NULL,
                          analysis_area_mask_layer = NULL,
                          hierarchic_mask_layer = NULL,
                          cost_layer = NULL) {

  # Hardcoded filename
  filename <- "settings_file.z5"

  # Check if the feature_list_file is provided
  if (missing(feature_list_file)) {
    stop("feature_list file is required and must be specified.")
  }

  # Open a connection to the file
  con <- file(filename, open = "wt")

    # Write file parameters to the settings file
  writeLines(paste("feature list file =", feature_list_file), con)

  if (!is.null(external_solution_file)) {
    writeLines(paste("external solution =", external_solution_file), con)
  }
  if (!is.null(analysis_area_mask_layer)) {
    writeLines(paste("analysis area mask layer =", analysis_area_mask_layer), con)
  }
  if (!is.null(hierarchic_mask_layer)) {
    writeLines(paste("hierarchic mask layer =", hierarchic_mask_layer), con)
  }
  if (!is.null(cost_layer)) {
    writeLines(paste("cost layer =", cost_layer), con)
  }

  # Close the connection
  close(con)

  # Return a message
  message("Settings file ", filename, " has been created.")
}
