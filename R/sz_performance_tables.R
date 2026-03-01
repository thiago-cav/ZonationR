#' Calculate feature representation at specific landscape proportions
#'
#' For each value in \code{landscape_prop}, finds the closest rank in
#' \code{feat_curves} and extracts feature representation values. Splits features
#' into positive- and negative-weighted (using \code{feat_list} from the calling
#' environment), converts values to percentages (negative weights inverted as
#' 100 - x), and builds per-feature tables plus summary tables (min, mean, max).
#' Optionally reshapes to long format or writes CSV files to \code{dir/sz_output/}.
#'
#' @param dir Character. Path to the directory where \code{sz_output} will be
#'   created if \code{save_output} is TRUE.
#' @param output_folder_name Character. Name of the Zonation output folder
#'   (unused in current logic but kept for API consistency).
#' @param feat_curves Data frame. Formatted feature curves with \code{rank} in
#'   the first column and one column per feature (e.g. from
#'   \code{\link{sz_format_feature_curves}}).
#' @param landscape_prop Numeric vector. Landscape proportions (rank values) at
#'   which to evaluate representation (e.g. \code{c(0.03, 0.2, 0.5)}).
#' @param format_longer Logical. If TRUE, each table in the result is converted
#'   to long format via \code{\link{sz_format_longer}}. Default FALSE.
#' @param save_output Logical. If TRUE, each table is written as a CSV in
#'   \code{dir/sz_output/}. Default FALSE.
#'
#' @returns A list of data frames, with names including
#'   \code{res_specific_features_pos}, \code{res_summary_features_pos}, and
#'   optionally \code{res_specific_features_neg}, \code{res_summary_features_neg}
#'   when negative-weighted features exist. If \code{format_longer} is TRUE,
#'   elements are in long format (rank, weight_type, feature, representation).
#'
#' @importFrom rlang .data
#' @importFrom magrittr %>%
#' @export
sz_performance_tables <- function(dir,
                                  output_folder_name,
                                  feat_curves,
                                  landscape_prop,
                                  format_longer = FALSE,
                                  save_output = FALSE) {
  
  res_specific_features_neg <- tibble::tibble()
  res_specific_features_pos <- tibble::tibble()
  res_summary_features_neg <- tibble::tibble()
  res_summary_features_pos <- tibble::tibble()
  neg_weighted_features <- character(0)

  for (i in seq_along(landscape_prop)) {
    filter_data <-
      feat_curves %>%
      mutate(minimun_value = abs(rank  - landscape_prop[i])) %>%
      filter(minimun_value == min(minimun_value)) %>%
      dplyr::select(-minimun_value) %>%
      mutate(rank = landscape_prop[i])
    
    # Negative weighted features
    neg_weighted_features <-
      feat_list %>%
      dplyr::filter(weight < 0) %>%
      pull(filename)
    
    # If there are negative values ...
    if (length(neg_weighted_features) > 0) {
      
      filter_data_neg <-
        filter_data %>%
        dplyr::select(rank, all_of(neg_weighted_features)) %>%
        mutate(weight_type = "negative") %>%
        dplyr::select(rank, weight_type, everything())
      
      # Convert to percentage and invert values (100 - x)
      filter_data_neg[1, 3:ncol(filter_data_neg)] <-
        100 - (filter_data_neg[1, 3:ncol(filter_data_neg)] * 100)
      
      # Salve a data.frame of negative-weighted features
      res_specific_features_neg <-
        bind_rows(res_specific_features_neg, filter_data_neg)
      
      # Summarise negative values
      neg_vals <-
        as.numeric(filter_data_neg[, 3:ncol(filter_data_neg)])

      summary_neg <-
        tibble::tibble(
          rank = landscape_prop[i],
          weight_type = "negative",
          min = round(min(neg_vals)),
          mean = round(mean(neg_vals)),
          max = round(max(neg_vals))
        )
      
      # Salve a data.frame summarizing values of negative-weighted features
      res_summary_features_neg <-
        dplyr::bind_rows(res_summary_features_neg, summary_neg)
    }
    
    # Positive weighted features
    pos_weighted_features <-
      feat_list %>%
      dplyr::filter(.data$weight > 0) %>%
      dplyr::pull(.data$filename)

    filter_data_pos <-
      filter_data %>%
      dplyr::select(rank, all_of(pos_weighted_features)) %>%
      mutate(weight_type = "positive") %>%
      dplyr::select(rank, weight_type, everything())
    
    # Convert to percentage
    filter_data_pos[1, 3:ncol(filter_data_pos)] <-
      filter_data_pos[1, 3:ncol(filter_data_pos)] * 100
    
    # Salve a data.frame of positive-weighted features
    res_specific_features_pos <-
      bind_rows(res_specific_features_pos, filter_data_pos)
    
    # Summarise positive values
    pos_vals <-
      as.numeric(filter_data_pos[, 3:ncol(filter_data_pos)])

    summary_pos <-
      tibble::tibble(
        rank = landscape_prop[i],
        weight_type = "positive",
        min = round(min(pos_vals)),
        mean = round(mean(pos_vals)),
        max = round(max(pos_vals))
      )
    
    # Salve a data.frame summarizing values of positive-weighted features
    res_summary_features_pos <-
      bind_rows(res_summary_features_pos, summary_pos)
    
  } # end of for
  
  result_list <- list(
    res_specific_features_pos = res_specific_features_pos,
    res_summary_features_pos = res_summary_features_pos
  )

  if (length(neg_weighted_features) > 0) {
    result_list_neg <- list(
      res_specific_features_neg = res_specific_features_neg,
      res_summary_features_neg = res_summary_features_neg
    )
    result_list <- c(result_list, result_list_neg)
  }
  names_files <- names(result_list)

  if (save_output) {
    fs::dir_create(dir, "sz_output")
    for (i in seq_along(result_list)) {
      write.csv(result_list[[i]],
                paste0(dir, "/sz_output/", names(result_list[i]), ".csv"))
    }
  }

  if (format_longer) {
    result_list <- sz_format_longer(result_list)
    names(result_list) <- names_files
  }

  return(result_list)
}
