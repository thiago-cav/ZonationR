#' Standardize feature file names in a feature list (INTERNAL FUNCTION)
#'
#' Standardizes the \code{filename} column in a features list data frame by
#' removing directory paths (via \code{\link[base]{basename}}) and user-provided
#' string patterns from each entry. Used to match or compare filenames independent
#' of path or naming conventions.
#'
#' @param features_list_file A data frame with at least a \code{filename} column,
#'   typically the features input list.
#' @param pattern_to_remove Character vector. String patterns to remove from each
#'   filename (e.g. path prefixes or suffixes). Applied in order via
#'   \code{\link[base]{gsub}}.
#'
#' @returns The input \code{features_list_file} with its \code{filename} column
#'   updated to standardized names (no paths, patterns removed).
#'
#' @keywords internal
sz_standardize_feat_list <-
  function(features_list_file, pattern_to_remove) {
    names <- basename(features_list_file$filename)
    
    for (i in seq_along(pattern_to_remove)) {
      names <- gsub(pattern_to_remove[i], "", names)
    }
    
    features_list_file$filename <- names
    return(features_list_file)
  }