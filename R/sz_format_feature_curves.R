#' Format feature curves file
#'
#' Reads the Zonation \code{feature_curves.csv}, strips an empty trailing column
#' if present, removes columns corresponding to zero-weighted features (from the
#' features list), and renames columns to \code{rank} plus the given feature names.
#' Result aligns with the formatted features list (e.g. from
#' \code{\link{sz_format_feature_list}}).
#'
#' @param dir Character. Path to the directory containing the features list file
#'   and the Zonation output folder.
#' @param output_folder_name Character. Name of the Zonation output folder
#'   (e.g. the run name).
#' @param feat_list_name Character. Base name of the features list file (without
#'   extension). Default is \code{"features_list"}.
#' @param feat_names Character vector. Names for the feature columns (one per
#'   feature). Length must equal number of feature columns (i.e. \code{ncol - 1}
#'   after removing zero-weighted columns).
#'
#' @returns A data frame with columns \code{rank} and one column per feature
#'   (named by \code{feat_names}), with zero-weighted feature columns removed and
#'   optional empty last column dropped.
#'
#' @importFrom readr read_table locale
#' @export
sz_format_feature_curves <-
  function(dir,
           output_folder_name,
           feat_list_name = "features_list",
           feat_names) {
    
    feature_curves_path <-
      file.path(dir, output_folder_name, "feature_curves.csv")
    
    if (!file.exists(feature_curves_path)) {
      stop("Feature curves file not found.")
    }
    
    feat_curves <-
      suppressWarnings(suppressMessages(readr::read_table(feature_curves_path)))
    
    
    # Remove last column if it's empty
    last_column <- ncol(feat_curves)
    if (sum(feat_curves[, last_column], na.rm = TRUE) == 0) {
      feat_curves <- feat_curves[, -last_column]
    }
    
    # Remove zero-weighted features
    features_list_path <- file.path(dir, paste0(feat_list_name, ".txt"))
    
    if (!file.exists(features_list_path)) {
      stop("Feature list file not found.")
    }
    
    features_list <-
      suppressMessages(readr::read_table(features_list_path,
                                        locale = readr::locale(encoding = "latin1")))
    
    features_list <- janitor::clean_names(features_list)
    
    zero_feature_pos <- which(features_list$weight == 0)
    
    # To consider the rank column
    zero_feature_pos <- zero_feature_pos + 1
    
    if (length(zero_feature_pos) > 0) {
      feat_curves <- feat_curves[,-zero_feature_pos]
    }
    
    # Ensure feature name length matches column count (minus the rank column)
    stopifnot(length(feat_names) == ncol(feat_curves) - 1)
    
    # Rename columns
    colnames(feat_curves)[1] <- "rank"
    colnames(feat_curves)[2:ncol(feat_curves)] <- feat_names
    
    return(feat_curves)
  }