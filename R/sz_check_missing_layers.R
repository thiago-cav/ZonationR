#' Check missing features in Zonation output (INTERNAL FUNCTION)
#'
#' Identifies features that were removed during analysis because all values are equal to zero.
#' These missing features are not included in the features list or feature curves files.
#' Reads the Zonation \code{issues.log} file and parses entries for removed layers.
#'
#' @param dir Character. Path to the directory containing the Zonation output folder.
#' @param output_folder_name Character. Name of the Zonation output folder (e.g. the run name).
#'
#' @return A list with two elements:
#'   \itemize{
#'     \item \code{feat_position}: Integer vector of 1-based indices of missing features (or 0 if none).
#'     \item \code{feat_names}: Character vector of basename file paths for missing features (or 0 if none).
#'   }
#'   Positions match the order of features in the features list file.
#'
#' @importFrom readr read_table
#' @keywords internal
sz_check_missing_layers <- function(dir, output_folder_name) {
  log_file <- file.path(dir, output_folder_name, "issues.log")
  
  if (!file.exists(log_file)) {
    stop("Log file not found. Ensure the directory and file exist.")
  }
  
  tab <- suppressWarnings(suppressMessages(readr::read_table(log_file)))
  tab <- tab[tab$analysis == "removing", ] # Filter missing features only
  
  feat_position <- as.numeric(tab$file)
  
  if (length(feat_position) > 0) {
    feat_names <- tab$will
    feat_names <- gsub("\\\\", "/", feat_names)
    feat_names <- basename(feat_names)
    
    # to match the features order in features_list file
    return(list(feat_position = feat_position + 1, feat_names = feat_names))
  } else{
    print("No missing features.")
    return(list(feat_position = 0, feat_names = 0))
  }
  
  # if (as.numeric(feat_position[1]) != 0 | any(feat_position ==  "mask")) {
  #   print("No missing features.")
  #   return(list(feat_position = 0, feat_names = 0))
  # } else{
  #   feat_names <- tab$will
  #   feat_names <- gsub("\\\\", "/", feat_names)
  #   feat_names <- basename(feat_names)
  #   
  #   # to match the features order in features_list file
  #   return(list(feat_position = feat_position + 1, feat_names = feat_names))
  # }
}
