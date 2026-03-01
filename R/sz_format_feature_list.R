#' Format feature list and remove excluded features
#'
#' Reads the Zonation features list file, standardizes filenames, and removes
#' features that were not included in the analysis: those with zero weight and
#' those removed as missing (all-zero layers) according to \code{issues.log}.
#' The result matches the set and order of features in the feature curves output.
#'
#' @param dir Character. Path to the directory containing the features list file
#'   and the Zonation output folder.
#' @param output_folder_name Character. Name of the Zonation output folder
#'   (e.g. the run name).
#' @param feat_list_name Character. Base name of the features list file (without
#'   extension). Default is \code{"features_list"} (file \code{features_list.txt}).
#' @param pattern_to_remove Character vector. String patterns to remove from
#'   each filename in the list (e.g. path prefixes or suffixes). Passed to
#'   \code{\link{sz_standardize_feat_list}}.
#'
#' @returns A data frame with the formatted features list: cleaned column names,
#'   standardized \code{filename} values, and rows for zero-weight or missing
#'   features removed. Ready to align with feature curves and other post-analysis
#'   outputs.
#'
#' @importFrom readr read_table locale
#' @export
sz_format_feature_list <-
  function(dir,
           output_folder_name,
           feat_list_name = "features_list",
           pattern_to_remove) {
    
    features_list_path <- file.path(dir, paste0(feat_list_name, ".txt"))
    
    if (!file.exists(features_list_path)) {
      stop("Feature list file not found.")
    }
    
    # Read features list file
    features_list <- suppressMessages(
      readr::read_table(features_list_path, locale = readr::locale(encoding = "latin1"))
    )
    
    features_list <- janitor::clean_names(features_list)
    
    # Standardize file names
    features_list_formatted <-
      sz_standardize_feat_list(features_list, pattern_to_remove)
    
    # Check for missing features. It must be removed from feature
    # list to mach columns in the curve list file
    
    log_file <- file.path(dir, output_folder_name, "issues.log")
    
    if (file.exists(log_file)) {
      missing_feat <- sz_check_missing_layers(dir, output_folder_name)
      missing_feat_posi <- missing_feat$feat_position
      features_to_remove <- missing_feat_posi
      
      # TODO: Mudei aqui
      if(features_to_remove == 0){ 
        features_to_remove <- NULL}
      # Até aqui
      
    } else{
      features_to_remove <- NULL
    }
    
    # Find zero-weighted features
    zero_feature <- features_list_formatted$weight == 0
    if (isTRUE(any(zero_feature))) {
      zero_feature_pos <- which(zero_feature == TRUE)
      features_to_remove <- c(features_to_remove, zero_feature_pos)
    } else{ 
      features_to_remove <- features_to_remove
    }
    
    if (length(features_to_remove) != 0) {
    #if (features_to_remove != 0) {
      # Removing from featured list file missing features
      features_list_formatted <-
        features_list_formatted[-features_to_remove,]
    }
    
    return(features_list_formatted)
  }

